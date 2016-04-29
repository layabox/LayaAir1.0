/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var vscode_1 = require('vscode');
var PConst = require('../protocol.const');
var Previewer = require('./previewer');
var MyCompletionItem = (function (_super) {
    __extends(MyCompletionItem, _super);
    function MyCompletionItem(entry) {
        _super.call(this, entry.name);
        this.sortText = entry.sortText;
        this.kind = MyCompletionItem.convertKind(entry.kind);
    }
    MyCompletionItem.convertKind = function (kind) {
        switch (kind) {
            case PConst.Kind.primitiveType:
            case PConst.Kind.keyword:
                return vscode_1.CompletionItemKind.Keyword;
            case PConst.Kind.variable:
            case PConst.Kind.localVariable:
                return vscode_1.CompletionItemKind.Variable;
            case PConst.Kind.memberVariable:
            case PConst.Kind.memberGetAccessor:
            case PConst.Kind.memberSetAccessor:
                return vscode_1.CompletionItemKind.Field;
            case PConst.Kind.function:
            case PConst.Kind.memberFunction:
            case PConst.Kind.constructSignature:
            case PConst.Kind.callSignature:
            case PConst.Kind.indexSignature:
                return vscode_1.CompletionItemKind.Function;
            case PConst.Kind.enum:
                return vscode_1.CompletionItemKind.Enum;
            case PConst.Kind.module:
                return vscode_1.CompletionItemKind.Module;
            case PConst.Kind.class:
                return vscode_1.CompletionItemKind.Class;
            case PConst.Kind.interface:
                return vscode_1.CompletionItemKind.Interface;
            case PConst.Kind.warning:
                return vscode_1.CompletionItemKind.File;
        }
        return vscode_1.CompletionItemKind.Property;
    };
    return MyCompletionItem;
}(vscode_1.CompletionItem));
var Configuration;
(function (Configuration) {
    Configuration.useCodeSnippetsOnMethodSuggest = 'useCodeSnippetsOnMethodSuggest';
})(Configuration || (Configuration = {}));
var TypeScriptCompletionItemProvider = (function () {
    function TypeScriptCompletionItemProvider(client) {
        this.triggerCharacters = ['.'];
        this.excludeTokens = ['string', 'comment', 'numeric'];
        this.sortBy = [{ type: 'reference', partSeparator: '/' }];
        this.client = client;
        this.config = { useCodeSnippetsOnMethodSuggest: false };
    }
    TypeScriptCompletionItemProvider.prototype.updateConfiguration = function (config) {
        this.config.useCodeSnippetsOnMethodSuggest = config.get(Configuration.useCodeSnippetsOnMethodSuggest, false);
    };
    TypeScriptCompletionItemProvider.prototype.provideCompletionItems = function (document, position, token) {
        var filepath = this.client.asAbsolutePath(document.uri);
        var args = {
            file: filepath,
            line: position.line + 1,
            offset: position.character + 1
        };
        if (!args.file) {
            return Promise.resolve([]);
        }
        return this.client.execute('completions', args, token).then(function (msg) {
            // This info has to come from the tsserver. See https://github.com/Microsoft/TypeScript/issues/2831
            // let isMemberCompletion = false;
            // let requestColumn = position.character;
            // if (wordAtPosition) {
            // 	requestColumn = wordAtPosition.startColumn;
            // }
            // if (requestColumn > 0) {
            // 	let value = model.getValueInRange({
            // 		startLineNumber: position.line,
            // 		startColumn: requestColumn - 1,
            // 		endLineNumber: position.line,
            // 		endColumn: requestColumn
            // 	});
            // 	isMemberCompletion = value === '.';
            // }
            var completionItems = [];
            var body = msg.body;
            for (var i = 0; i < body.length; i++) {
                var element = body[i];
                var item = new MyCompletionItem(element);
                item.document = document;
                item.position = position;
                completionItems.push(item);
            }
            return completionItems;
        }, function (err) {
            return [];
        });
    };
    TypeScriptCompletionItemProvider.prototype.resolveCompletionItem = function (item, token) {
        var _this = this;
        if (item instanceof MyCompletionItem) {
            var args = {
                file: this.client.asAbsolutePath(item.document.uri),
                line: item.position.line + 1,
                offset: item.position.character + 1,
                entryNames: [item.label]
            };
            return this.client.execute('completionEntryDetails', args, token).then(function (response) {
                var details = response.body;
                var detail = null;
                if (details && details.length > 0) {
                    detail = details[0];
                    item.documentation = Previewer.plain(detail.documentation);
                    item.detail = Previewer.plain(detail.displayParts);
                }
                if (detail && _this.config.useCodeSnippetsOnMethodSuggest && item.kind === vscode_1.CompletionItemKind.Function) {
                    var codeSnippet = detail.name;
                    var suggestionArgumentNames = void 0;
                    suggestionArgumentNames = detail.displayParts
                        .filter(function (part) { return part.kind === 'parameterName'; })
                        .map(function (part) { return ("{{" + part.text + "}}"); });
                    if (suggestionArgumentNames.length > 0) {
                        codeSnippet += '(' + suggestionArgumentNames.join(', ') + '){{}}';
                    }
                    else {
                        codeSnippet += '()';
                    }
                    item.insertText = codeSnippet;
                }
                return item;
            }, function (err) {
                return item;
            });
        }
    };
    return TypeScriptCompletionItemProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = TypeScriptCompletionItemProvider;
//# sourceMappingURL=completionItemProvider.js.map