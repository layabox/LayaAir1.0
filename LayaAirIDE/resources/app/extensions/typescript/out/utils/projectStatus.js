/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode = require('vscode');
var vscode_nls_1 = require('vscode-nls');
var path_1 = require('path');
var localize = vscode_nls_1.loadMessageBundle(__filename);
var selector = ['javascript', 'javascriptreact'];
var fileLimit = 500;
function create(client, isOpen, memento) {
    var toDispose = [];
    var projectHinted = Object.create(null);
    var projectHintIgnoreList = memento.get('projectHintIgnoreList', []);
    for (var _i = 0, projectHintIgnoreList_1 = projectHintIgnoreList; _i < projectHintIgnoreList_1.length; _i++) {
        var path = projectHintIgnoreList_1[_i];
        if (path === null) {
            path = undefined;
        }
        projectHinted[path] = true;
    }
    var currentHint;
    var item = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, Number.MIN_VALUE);
    item.command = 'js.projectStatus.command';
    toDispose.push(vscode.commands.registerCommand('js.projectStatus.command', function () {
        var message = currentHint.message, options = currentHint.options;
        return (_a = vscode.window).showInformationMessage.apply(_a, [message].concat(options)).then(function (selection) {
            if (selection) {
                return selection.execute();
            }
        });
        var _a;
    }));
    toDispose.push(vscode.workspace.onDidChangeTextDocument(function (e) {
        delete projectHinted[e.document.fileName];
    }));
    function onEditor(editor) {
        if (!editor || !vscode.languages.match(selector, editor.document)) {
            item.hide();
            return;
        }
        var file = client.asAbsolutePath(editor.document.uri);
        isOpen(file).then(function (value) {
            if (!value) {
                return;
            }
            return client.execute('projectInfo', { file: file, needFileNameList: true }).then(function (res) {
                var _a = res.body, configFileName = _a.configFileName, fileNames = _a.fileNames;
                if (projectHinted[configFileName] === true) {
                    return;
                }
                if (!configFileName) {
                    currentHint = {
                        message: localize(0, null),
                        options: [{
                                title: localize(1, null),
                                execute: function () {
                                    client.logTelemetry('js.hintProjectCreation.ignored');
                                    projectHinted[configFileName] = true;
                                    projectHintIgnoreList.push(configFileName);
                                    memento.update('projectHintIgnoreList', projectHintIgnoreList);
                                    item.hide();
                                }
                            }, {
                                title: localize(2, null),
                                execute: function () {
                                    client.logTelemetry('js.hintProjectCreation.accepted');
                                    projectHinted[configFileName] = true;
                                    item.hide();
                                    return vscode.workspace.openTextDocument(vscode.Uri.parse('untitled:' + path_1.join(vscode.workspace.rootPath, 'jsconfig.json')))
                                        .then(vscode.window.showTextDocument)
                                        .then(function (editor) { return editor.edit(function (builder) { return builder.insert(new vscode.Position(0, 0), defaultConfig); }); });
                                }
                            }]
                    };
                    item.text = '$(light-bulb)';
                    item.tooltip = localize(3, null);
                    item.color = '#A5DF3B';
                    item.show();
                    client.logTelemetry('js.hintProjectCreation');
                }
                else if (fileNames.length > fileLimit) {
                    var largeRoots = computeLargeRoots(configFileName, fileNames).map(function (f) { return ("'/" + f + "/'"); }).join(', ');
                    currentHint = {
                        message: largeRoots.length > 0
                            ? localize(4, null, largeRoots)
                            : localize(5, null),
                        options: [{
                                title: localize(6, null),
                                execute: function () {
                                    client.logTelemetry('js.hintProjectExcludes.accepted');
                                    projectHinted[configFileName] = true;
                                    item.hide();
                                    return vscode.workspace.openTextDocument(configFileName)
                                        .then(vscode.window.showTextDocument);
                                }
                            }]
                    };
                    item.tooltip = currentHint.message;
                    item.text = localize(7, null);
                    item.tooltip = localize(8, null);
                    item.color = '#A5DF3B';
                    item.show();
                    client.logTelemetry('js.hintProjectExcludes');
                }
                else {
                    item.hide();
                }
            });
        }).catch(function (err) {
            console.log(err);
        });
    }
    toDispose.push(vscode.window.onDidChangeActiveTextEditor(onEditor));
    onEditor(vscode.window.activeTextEditor);
    return (_a = vscode.Disposable).from.apply(_a, toDispose);
    var _a;
}
exports.create = create;
function computeLargeRoots(configFileName, fileNames) {
    var roots = Object.create(null);
    var dir = path_1.dirname(configFileName);
    // console.log(dir, fileNames);
    for (var _i = 0, fileNames_1 = fileNames; _i < fileNames_1.length; _i++) {
        var fileName = fileNames_1[_i];
        if (fileName.indexOf(dir) === 0) {
            var first = fileName.substring(dir.length + 1);
            first = first.substring(0, first.indexOf('/'));
            if (first) {
                roots[first] = (roots[first] || 0) + 1;
            }
        }
    }
    var data = [];
    for (var key in roots) {
        data.push({ root: key, count: roots[key] });
    }
    data
        .sort(function (a, b) { return b.count - a.count; })
        .filter(function (s) { return s.root === 'src' || s.root === 'test' || s.root === 'tests'; });
    var result = [];
    var sum = 0;
    for (var _a = 0, data_1 = data; _a < data_1.length; _a++) {
        var e = data_1[_a];
        sum += e.count;
        result.push(e.root);
        if (fileNames.length - sum < fileLimit) {
            break;
        }
    }
    return result;
}
var defaultConfig = "{\n\t// See http://go.microsoft.com/fwlink/?LinkId=759670\n\t// for the documentation about the jsconfig.json format\n\t\"compilerOptions\": {\n\t\t\"target\": \"es6\"\n\t},\n\t\"exclude\": [\n\t\t\"node_modules\",\n\t\t\"bower_components\",\n\t\t\"jspm_packages\",\n\t\t\"tmp\",\n\t\t\"temp\"\n\t]\n}\n";
//# sourceMappingURL=projectStatus.js.map