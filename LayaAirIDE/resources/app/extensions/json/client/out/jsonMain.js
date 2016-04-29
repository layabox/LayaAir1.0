/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var path = require('path');
var vscode_1 = require('vscode');
var vscode_languageclient_1 = require('vscode-languageclient');
var vscode_extension_telemetry_1 = require('vscode-extension-telemetry');
var TelemetryNotification;
(function (TelemetryNotification) {
    TelemetryNotification.type = { get method() { return 'telemetry'; } };
})(TelemetryNotification || (TelemetryNotification = {}));
var VSCodeContentRequest;
(function (VSCodeContentRequest) {
    VSCodeContentRequest.type = { get method() { return 'vscode/content'; } };
})(VSCodeContentRequest || (VSCodeContentRequest = {}));
var SchemaAssociationNotification;
(function (SchemaAssociationNotification) {
    SchemaAssociationNotification.type = { get method() { return 'json/schemaAssociations'; } };
})(SchemaAssociationNotification || (SchemaAssociationNotification = {}));
function activate(context) {
    var packageInfo = getPackageInfo(context);
    var telemetryReporter = packageInfo && new vscode_extension_telemetry_1.default(packageInfo.name, packageInfo.version, packageInfo.aiKey);
    // Resolve language ids to pass around as initialization data
    vscode_1.languages.getLanguages().then(function (languageIds) {
        // The server is implemented in node
        var serverModule = context.asAbsolutePath(path.join('server', 'out', 'server.js'));
        // The debug options for the server
        var debugOptions = { execArgv: ['--nolazy', '--debug=6004'] };
        // If the extension is launch in debug mode the debug server options are use
        // Otherwise the run options are used
        var serverOptions = {
            run: { module: serverModule, transport: vscode_languageclient_1.TransportKind.ipc },
            debug: { module: serverModule, transport: vscode_languageclient_1.TransportKind.ipc, options: debugOptions }
        };
        // Options to control the language client
        var clientOptions = {
            // Register the server for json documents
            documentSelector: ['json'],
            synchronize: {
                // Synchronize the setting section 'json' to the server
                configurationSection: ['json.schemas', 'http.proxy', 'http.proxyStrictSSL'],
                fileEvents: vscode_1.workspace.createFileSystemWatcher('**/.json')
            },
            initializationOptions: {
                languageIds: languageIds
            }
        };
        // Create the language client and start the client.
        var client = new vscode_languageclient_1.LanguageClient('JSON Server', serverOptions, clientOptions);
        client.onNotification(TelemetryNotification.type, function (e) {
            if (telemetryReporter) {
                telemetryReporter.sendTelemetryEvent(e.key, e.data);
            }
        });
        // handle content request
        client.onRequest(VSCodeContentRequest.type, function (uriPath) {
            var uri = vscode_1.Uri.parse(uriPath);
            return vscode_1.workspace.openTextDocument(uri).then(function (doc) {
                return doc.getText();
            }, function (error) {
                return Promise.reject(error);
            });
        });
        var disposable = client.start();
        client.sendNotification(SchemaAssociationNotification.type, getSchemaAssociation(context));
        // Push the disposable to the context's subscriptions so that the
        // client can be deactivated on extension deactivation
        context.subscriptions.push(disposable);
        vscode_1.languages.setLanguageConfiguration('json', {
            wordPattern: /(-?\d*\.\d\w*)|([^\[\{\]\}\:\"\,\s]+)/g,
            __characterPairSupport: {
                autoClosingPairs: [
                    { open: '{', close: '}' },
                    { open: '[', close: ']' },
                    { open: '(', close: ')' },
                    { open: '"', close: '"', notIn: ['string'] },
                    { open: '\'', close: '\'', notIn: ['string', 'comment'] },
                    { open: '`', close: '`', notIn: ['string', 'comment'] }
                ]
            }
        });
    });
}
exports.activate = activate;
function getSchemaAssociation(context) {
    var associations = {};
    vscode_1.extensions.all.forEach(function (extension) {
        var packageJSON = extension.packageJSON;
        if (packageJSON && packageJSON.contributes && packageJSON.contributes.jsonValidation) {
            var jsonValidation = packageJSON.contributes.jsonValidation;
            if (Array.isArray(jsonValidation)) {
                jsonValidation.forEach(function (jv) {
                    var fileMatch = jv.fileMatch, url = jv.url;
                    if (fileMatch && url) {
                        if (url[0] === '.' && url[1] === '/') {
                            url = vscode_1.Uri.file(path.join(extension.extensionPath, url)).toString();
                        }
                        if (fileMatch[0] === '%') {
                            fileMatch = fileMatch.replace(/%APP_SETTINGS_HOME%/, '/User');
                        }
                        else if (fileMatch.charAt(0) !== '/' && !fileMatch.match(/\w+:\/\//)) {
                            fileMatch = '/' + fileMatch;
                        }
                        var association = associations[fileMatch];
                        if (!association) {
                            association = [];
                            associations[fileMatch] = association;
                        }
                        association.push(url);
                    }
                });
            }
        }
    });
    return associations;
}
function getPackageInfo(context) {
    var extensionPackage = require(context.asAbsolutePath('./package.json'));
    if (extensionPackage) {
        return {
            name: extensionPackage.name,
            version: extensionPackage.version,
            aiKey: extensionPackage.aiKey
        };
    }
    return null;
}
//# sourceMappingURL=jsonMain.js.map