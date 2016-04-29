/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var Strings = require('./utils/strings');
var vscode_languageserver_1 = require('vscode-languageserver');
var JSONDocumentSymbols = (function () {
    function JSONDocumentSymbols() {
    }
    JSONDocumentSymbols.prototype.compute = function (document, doc) {
        var _this = this;
        var root = doc.root;
        if (!root) {
            return Promise.resolve(null);
        }
        // special handling for key bindings
        var resourceString = document.uri;
        if ((resourceString === 'vscode://defaultsettings/keybindings.json') || Strings.endsWith(resourceString.toLowerCase(), '/user/keybindings.json')) {
            if (root.type === 'array') {
                var result_1 = [];
                root.items.forEach(function (item) {
                    if (item.type === 'object') {
                        var property = item.getFirstProperty('key');
                        if (property && property.value) {
                            var location = vscode_languageserver_1.Location.create(document.uri, vscode_languageserver_1.Range.create(document.positionAt(item.start), document.positionAt(item.end)));
                            result_1.push({ name: property.value.getValue(), kind: vscode_languageserver_1.SymbolKind.Function, location: location });
                        }
                    }
                });
                return Promise.resolve(result_1);
            }
        }
        var collectOutlineEntries = function (result, node, containerName) {
            if (node.type === 'array') {
                node.items.forEach(function (node) {
                    collectOutlineEntries(result, node, containerName);
                });
            }
            else if (node.type === 'object') {
                var objectNode = node;
                objectNode.properties.forEach(function (property) {
                    var location = vscode_languageserver_1.Location.create(document.uri, vscode_languageserver_1.Range.create(document.positionAt(property.start), document.positionAt(property.end)));
                    var valueNode = property.value;
                    if (valueNode) {
                        var childContainerName = containerName ? containerName + '.' + property.key.name : property.key.name;
                        result.push({ name: property.key.getValue(), kind: _this.getSymbolKind(valueNode.type), location: location, containerName: containerName });
                        collectOutlineEntries(result, valueNode, childContainerName);
                    }
                });
            }
            return result;
        };
        var result = collectOutlineEntries([], root, void 0);
        return Promise.resolve(result);
    };
    JSONDocumentSymbols.prototype.getSymbolKind = function (nodeType) {
        switch (nodeType) {
            case 'object':
                return vscode_languageserver_1.SymbolKind.Module;
            case 'string':
                return vscode_languageserver_1.SymbolKind.String;
            case 'number':
                return vscode_languageserver_1.SymbolKind.Number;
            case 'array':
                return vscode_languageserver_1.SymbolKind.Array;
            case 'boolean':
                return vscode_languageserver_1.SymbolKind.Boolean;
            default:
                return vscode_languageserver_1.SymbolKind.Variable;
        }
    };
    return JSONDocumentSymbols;
}());
exports.JSONDocumentSymbols = JSONDocumentSymbols;
//# sourceMappingURL=jsonDocumentSymbols.js.map