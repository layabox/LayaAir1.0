/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var Previewer = require('./previewer');
var TypeScriptSignatureHelpProvider = (function () {
    function TypeScriptSignatureHelpProvider(client) {
        this.client = client;
    }
    TypeScriptSignatureHelpProvider.prototype.provideSignatureHelp = function (document, position, token) {
        var args = {
            file: this.client.asAbsolutePath(document.uri),
            line: position.line + 1,
            offset: position.character + 1
        };
        if (!args.file) {
            return Promise.resolve(null);
        }
        return this.client.execute('signatureHelp', args, token).then(function (response) {
            var info = response.body;
            if (!info) {
                return null;
            }
            var result = new vscode_1.SignatureHelp();
            result.activeSignature = info.selectedItemIndex;
            result.activeParameter = info.argumentIndex;
            info.items.forEach(function (item) {
                var signature = new vscode_1.SignatureInformation('');
                signature.label += Previewer.plain(item.prefixDisplayParts);
                item.parameters.forEach(function (p, i, a) {
                    var parameter = new vscode_1.ParameterInformation(Previewer.plain(p.displayParts), Previewer.plain(p.documentation));
                    signature.label += parameter.label;
                    signature.parameters.push(parameter);
                    if (i < a.length - 1) {
                        signature.label += Previewer.plain(item.separatorDisplayParts);
                    }
                });
                signature.label += Previewer.plain(item.suffixDisplayParts);
                result.signatures.push(signature);
            });
            return result;
        }, function (err) {
            return null;
        });
    };
    return TypeScriptSignatureHelpProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptSignatureHelpProvider;
//# sourceMappingURL=signatureHelpProvider.js.map