/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var _kindMapping = Object.create(null);
_kindMapping['method'] = vscode_1.SymbolKind.Method;
_kindMapping['enum'] = vscode_1.SymbolKind.Enum;
_kindMapping['function'] = vscode_1.SymbolKind.Function;
_kindMapping['class'] = vscode_1.SymbolKind.Class;
_kindMapping['interface'] = vscode_1.SymbolKind.Interface;
_kindMapping['var'] = vscode_1.SymbolKind.Variable;
var TypeScriptWorkspaceSymbolProvider = (function () {
    function TypeScriptWorkspaceSymbolProvider(client, modeId) {
        this.client = client;
        this.modeId = modeId;
    }
    TypeScriptWorkspaceSymbolProvider.prototype.provideWorkspaceSymbols = function (search, token) {
        var _this = this;
        // typescript wants to have a resource even when asking
        // general questions so we check all open documents for
        // one that is typescript'ish
        var uri;
        var documents = vscode_1.workspace.textDocuments;
        for (var _i = 0, documents_1 = documents; _i < documents_1.length; _i++) {
            var document = documents_1[_i];
            if (document.languageId === this.modeId) {
                uri = document.uri;
                break;
            }
        }
        if (!uri) {
            return Promise.resolve([]);
        }
        var args = {
            file: this.client.asAbsolutePath(uri),
            searchValue: search
        };
        if (!args.file) {
            return Promise.resolve([]);
        }
        return this.client.execute('navto', args, token).then(function (response) {
            var data = response.body;
            if (data) {
                return data.map(function (item) {
                    var range = new vscode_1.Range(item.start.line - 1, item.start.offset - 1, item.end.line - 1, item.end.offset - 1);
                    var label = item.name;
                    if (item.kind === 'method' || item.kind === 'function') {
                        label += '()';
                    }
                    return new vscode_1.SymbolInformation(label, _kindMapping[item.kind], range, _this.client.asUrl(item.file), item.containerName);
                });
            }
            else {
                return [];
            }
        }, function (err) {
            return [];
        });
    };
    return TypeScriptWorkspaceSymbolProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptWorkspaceSymbolProvider;
//# sourceMappingURL=workspaceSymbolProvider.js.map