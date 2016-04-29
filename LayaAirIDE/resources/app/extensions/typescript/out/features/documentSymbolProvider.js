/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var PConst = require('../protocol.const');
var outlineTypeTable = Object.create(null);
outlineTypeTable[PConst.Kind.module] = vscode_1.SymbolKind.Module;
outlineTypeTable[PConst.Kind.class] = vscode_1.SymbolKind.Class;
outlineTypeTable[PConst.Kind.enum] = vscode_1.SymbolKind.Enum;
outlineTypeTable[PConst.Kind.interface] = vscode_1.SymbolKind.Interface;
outlineTypeTable[PConst.Kind.memberFunction] = vscode_1.SymbolKind.Method;
outlineTypeTable[PConst.Kind.memberVariable] = vscode_1.SymbolKind.Property;
outlineTypeTable[PConst.Kind.memberGetAccessor] = vscode_1.SymbolKind.Property;
outlineTypeTable[PConst.Kind.memberSetAccessor] = vscode_1.SymbolKind.Property;
outlineTypeTable[PConst.Kind.variable] = vscode_1.SymbolKind.Variable;
outlineTypeTable[PConst.Kind.const] = vscode_1.SymbolKind.Variable;
outlineTypeTable[PConst.Kind.localVariable] = vscode_1.SymbolKind.Variable;
outlineTypeTable[PConst.Kind.variable] = vscode_1.SymbolKind.Variable;
outlineTypeTable[PConst.Kind.function] = vscode_1.SymbolKind.Function;
outlineTypeTable[PConst.Kind.localFunction] = vscode_1.SymbolKind.Function;
function textSpan2Range(value) {
    return new vscode_1.Range(value.start.line - 1, value.start.offset - 1, value.end.line - 1, value.end.offset - 1);
}
var TypeScriptDocumentSymbolProvider = (function () {
    function TypeScriptDocumentSymbolProvider(client) {
        this.client = client;
    }
    TypeScriptDocumentSymbolProvider.prototype.provideDocumentSymbols = function (resource, token) {
        var args = {
            file: this.client.asAbsolutePath(resource.uri)
        };
        if (!args.file) {
            return Promise.resolve([]);
        }
        function convert(bucket, item, containerLabel) {
            var result = new vscode_1.SymbolInformation(item.text, outlineTypeTable[item.kind] || vscode_1.SymbolKind.Variable, textSpan2Range(item.spans[0]), resource.uri, containerLabel);
            if (item.childItems && item.childItems.length > 0) {
                for (var _i = 0, _a = item.childItems; _i < _a.length; _i++) {
                    var child = _a[_i];
                    convert(bucket, child, result.name);
                }
            }
            bucket.push(result);
        }
        return this.client.execute('navbar', args, token).then(function (response) {
            if (response.body) {
                var result_1 = [];
                response.body.forEach(function (item) { return convert(result_1, item); });
                return result_1;
            }
        }, function (err) {
            return [];
        });
    };
    return TypeScriptDocumentSymbolProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptDocumentSymbolProvider;
//# sourceMappingURL=documentSymbolProvider.js.map