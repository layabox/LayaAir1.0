/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var httpRequest_1 = require('./utils/httpRequest');
var path = require('path');
var fs = require('fs');
var uri_1 = require('./utils/uri');
var Strings = require('./utils/strings');
var jsonSchemaService_1 = require('./jsonSchemaService');
var jsonParser_1 = require('./jsonParser');
var jsonCompletion_1 = require('./jsonCompletion');
var jsonHover_1 = require('./jsonHover');
var jsonDocumentSymbols_1 = require('./jsonDocumentSymbols');
var jsonFormatter_1 = require('./jsonFormatter');
var configuration_1 = require('./configuration');
var bowerJSONContribution_1 = require('./jsoncontributions/bowerJSONContribution');
var packageJSONContribution_1 = require('./jsoncontributions/packageJSONContribution');
var projectJSONContribution_1 = require('./jsoncontributions/projectJSONContribution');
var globPatternContribution_1 = require('./jsoncontributions/globPatternContribution');
var fileAssociationContribution_1 = require('./jsoncontributions/fileAssociationContribution');
var nls = require('vscode-nls');
nls.config(process.env['VSCODE_NLS_CONFIG']);
var TelemetryNotification;
(function (TelemetryNotification) {
    TelemetryNotification.type = { get method() { return 'telemetry'; } };
})(TelemetryNotification || (TelemetryNotification = {}));
var SchemaAssociationNotification;
(function (SchemaAssociationNotification) {
    SchemaAssociationNotification.type = { get method() { return 'json/schemaAssociations'; } };
})(SchemaAssociationNotification || (SchemaAssociationNotification = {}));
var VSCodeContentRequest;
(function (VSCodeContentRequest) {
    VSCodeContentRequest.type = { get method() { return 'vscode/content'; } };
})(VSCodeContentRequest || (VSCodeContentRequest = {}));
// Create a connection for the server. The connection uses for
// stdin / stdout for message passing
var connection = vscode_languageserver_1.createConnection(new vscode_languageserver_1.IPCMessageReader(process), new vscode_languageserver_1.IPCMessageWriter(process));
// Create a simple text document manager. The text document manager
// supports full document sync only
var documents = new vscode_languageserver_1.TextDocuments();
// Make the text document manager listen on the connection
// for open, change and close text document events
documents.listen(connection);
var filesAssociationContribution = new fileAssociationContribution_1.FileAssociationContribution();
// After the server has started the client sends an initilize request. The server receives
// in the passed params the rootPath of the workspace plus the client capabilites.
var workspaceRoot;
connection.onInitialize(function (params) {
    workspaceRoot = uri_1.default.parse(params.rootPath);
    filesAssociationContribution.setLanguageIds(params.initializationOptions.languageIds);
    return {
        capabilities: {
            // Tell the client that the server works in FULL text document sync mode
            textDocumentSync: documents.syncKind,
            completionProvider: { resolveProvider: true },
            hoverProvider: true,
            documentSymbolProvider: true,
            documentRangeFormattingProvider: true,
            documentFormattingProvider: true
        }
    };
});
var workspaceContext = {
    toResource: function (workspaceRelativePath) {
        if (typeof workspaceRelativePath === 'string' && workspaceRoot) {
            return uri_1.default.file(path.join(workspaceRoot.fsPath, workspaceRelativePath)).toString();
        }
        return workspaceRelativePath;
    }
};
var telemetry = {
    log: function (key, data) {
        connection.sendNotification(TelemetryNotification.type, { key: key, data: data });
    }
};
var request = function (options) {
    if (Strings.startsWith(options.url, 'file://')) {
        var fsPath_1 = uri_1.default.parse(options.url).fsPath;
        return new Promise(function (c, e) {
            fs.readFile(fsPath_1, 'UTF-8', function (err, result) {
                err ? e({ responseText: '', status: 404 }) : c({ responseText: result.toString(), status: 200 });
            });
        });
    }
    else if (Strings.startsWith(options.url, 'vscode://')) {
        return connection.sendRequest(VSCodeContentRequest.type, options.url).then(function (responseText) {
            return {
                responseText: responseText,
                status: 200
            };
        }, function (error) {
            return {
                responseText: error.message,
                status: 404
            };
        });
    }
    return httpRequest_1.xhr(options);
};
var contributions = [
    new projectJSONContribution_1.ProjectJSONContribution(request),
    new packageJSONContribution_1.PackageJSONContribution(request),
    new bowerJSONContribution_1.BowerJSONContribution(request),
    new globPatternContribution_1.GlobPatternContribution(),
    filesAssociationContribution
];
var jsonSchemaService = new jsonSchemaService_1.JSONSchemaService(request, workspaceContext, telemetry);
jsonSchemaService.setSchemaContributions(configuration_1.schemaContributions);
var jsonCompletion = new jsonCompletion_1.JSONCompletion(jsonSchemaService, connection.console, contributions);
var jsonHover = new jsonHover_1.JSONHover(jsonSchemaService, contributions);
var jsonDocumentSymbols = new jsonDocumentSymbols_1.JSONDocumentSymbols();
// The content of a text document has changed. This event is emitted
// when the text document first opened or when its content has changed.
documents.onDidChangeContent(function (change) {
    validateTextDocument(change.document);
});
var jsonConfigurationSettings = void 0;
var schemaAssociations = void 0;
// The settings have changed. Is send on server activation as well.
connection.onDidChangeConfiguration(function (change) {
    var settings = change.settings;
    httpRequest_1.configure(settings.http && settings.http.proxy, settings.http && settings.http.proxyStrictSSL);
    jsonConfigurationSettings = settings.json && settings.json.schemas;
    updateConfiguration();
});
// The jsonValidation extension configuration has changed
connection.onNotification(SchemaAssociationNotification.type, function (associations) {
    schemaAssociations = associations;
    updateConfiguration();
});
function updateConfiguration() {
    jsonSchemaService.clearExternalSchemas();
    if (schemaAssociations) {
        for (var pattern in schemaAssociations) {
            var association = schemaAssociations[pattern];
            if (Array.isArray(association)) {
                association.forEach(function (url) {
                    jsonSchemaService.registerExternalSchema(url, [pattern]);
                });
            }
        }
    }
    if (jsonConfigurationSettings) {
        jsonConfigurationSettings.forEach(function (schema) {
            if (schema.fileMatch) {
                var url = schema.url;
                if (!url && schema.schema) {
                    url = schema.schema.id;
                    if (!url) {
                        url = 'vscode://schemas/custom/' + encodeURIComponent(schema.fileMatch.join('&'));
                    }
                }
                if (!Strings.startsWith(url, 'http://') && !Strings.startsWith(url, 'https://') && !Strings.startsWith(url, 'file://')) {
                    var resourceURL = workspaceContext.toResource(url);
                    if (resourceURL) {
                        url = resourceURL.toString();
                    }
                }
                if (url) {
                    jsonSchemaService.registerExternalSchema(url, schema.fileMatch, schema.schema);
                }
            }
        });
    }
    // Revalidate any open text documents
    documents.all().forEach(validateTextDocument);
}
function validateTextDocument(textDocument) {
    var jsonDocument = getJSONDocument(textDocument);
    jsonSchemaService.getSchemaForResource(textDocument.uri, jsonDocument).then(function (schema) {
        if (schema) {
            if (schema.errors.length && jsonDocument.root) {
                var astRoot = jsonDocument.root;
                var property = astRoot.type === 'object' ? astRoot.getFirstProperty('$schema') : null;
                if (property) {
                    var node = property.value || property;
                    jsonDocument.warnings.push({ location: { start: node.start, end: node.end }, message: schema.errors[0] });
                }
                else {
                    jsonDocument.warnings.push({ location: { start: astRoot.start, end: astRoot.start + 1 }, message: schema.errors[0] });
                }
            }
            else {
                jsonDocument.validate(schema.schema);
            }
        }
        var diagnostics = [];
        var added = {};
        jsonDocument.errors.concat(jsonDocument.warnings).forEach(function (error, idx) {
            // remove duplicated messages
            var signature = error.location.start + ' ' + error.location.end + ' ' + error.message;
            if (!added[signature]) {
                added[signature] = true;
                var range = {
                    start: textDocument.positionAt(error.location.start),
                    end: textDocument.positionAt(error.location.end)
                };
                diagnostics.push({
                    severity: idx >= jsonDocument.errors.length ? vscode_languageserver_1.DiagnosticSeverity.Warning : vscode_languageserver_1.DiagnosticSeverity.Error,
                    range: range,
                    message: error.message
                });
            }
        });
        // Send the computed diagnostics to VSCode.
        connection.sendDiagnostics({ uri: textDocument.uri, diagnostics: diagnostics });
    });
}
connection.onDidChangeWatchedFiles(function (change) {
    // Monitored files have change in VSCode
    var hasChanges = false;
    change.changes.forEach(function (c) {
        if (jsonSchemaService.onResourceChange(c.uri)) {
            hasChanges = true;
        }
    });
    if (hasChanges) {
        documents.all().forEach(validateTextDocument);
    }
});
function getJSONDocument(document) {
    return jsonParser_1.parse(document.getText());
}
connection.onCompletion(function (textDocumentPosition) {
    var document = documents.get(textDocumentPosition.uri);
    var jsonDocument = getJSONDocument(document);
    return jsonCompletion.doSuggest(document, textDocumentPosition, jsonDocument);
});
connection.onCompletionResolve(function (item) {
    return jsonCompletion.doResolve(item);
});
connection.onHover(function (textDocumentPosition) {
    var document = documents.get(textDocumentPosition.uri);
    var jsonDocument = getJSONDocument(document);
    return jsonHover.doHover(document, textDocumentPosition, jsonDocument);
});
connection.onDocumentSymbol(function (textDocumentIdentifier) {
    var document = documents.get(textDocumentIdentifier.uri);
    var jsonDocument = getJSONDocument(document);
    return jsonDocumentSymbols.compute(document, jsonDocument);
});
connection.onDocumentFormatting(function (formatParams) {
    var document = documents.get(formatParams.textDocument.uri);
    return jsonFormatter_1.format(document, null, formatParams.options);
});
connection.onDocumentRangeFormatting(function (formatParams) {
    var document = documents.get(formatParams.textDocument.uri);
    return jsonFormatter_1.format(document, formatParams.range, formatParams.options);
});
// Listen on the connection
connection.listen();
//# sourceMappingURL=server.js.map