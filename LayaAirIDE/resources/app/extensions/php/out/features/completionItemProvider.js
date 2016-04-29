/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var phpGlobals = require('./phpGlobals');
var PHPCompletionItemProvider = (function () {
    function PHPCompletionItemProvider() {
        this.triggerCharacters = ['.', ':', '$'];
    }
    PHPCompletionItemProvider.prototype.provideCompletionItems = function (document, position, token) {
        var result = [];
        var range = document.getWordRangeAtPosition(position);
        var prefix = range ? document.getText(range) : '';
        if (!range) {
            range = new vscode_1.Range(position, position);
        }
        var added = {};
        var createNewProposal = function (kind, name, entry) {
            var proposal = new vscode_1.CompletionItem(name);
            proposal.kind = kind;
            if (entry) {
                if (entry.description) {
                    proposal.documentation = entry.description;
                }
                if (entry.signature) {
                    proposal.detail = entry.signature;
                }
            }
            return proposal;
        };
        var matches = function (name) {
            return prefix.length === 0 || name.length >= prefix.length && name.substr(0, prefix.length) === prefix;
        };
        if (matches('php') && range.start.character >= 2) {
            var twoBeforePosition = new vscode_1.Position(range.start.line, range.start.character - 2);
            var beforeWord = document.getText(new vscode_1.Range(twoBeforePosition, range.start));
            if (beforeWord === '<?') {
                var proposal = createNewProposal(vscode_1.CompletionItemKind.Class, '<?php', null);
                proposal.textEdit = new vscode_1.TextEdit(new vscode_1.Range(twoBeforePosition, position), '<?php');
                result.push(proposal);
                return Promise.resolve(result);
            }
        }
        for (var name in phpGlobals.globalvariables) {
            if (phpGlobals.globalvariables.hasOwnProperty(name) && matches(name)) {
                added[name] = true;
                result.push(createNewProposal(vscode_1.CompletionItemKind.Variable, name, phpGlobals.globalvariables[name]));
            }
        }
        for (var name in phpGlobals.globalfunctions) {
            if (phpGlobals.globalfunctions.hasOwnProperty(name) && matches(name)) {
                added[name] = true;
                result.push(createNewProposal(vscode_1.CompletionItemKind.Function, name, phpGlobals.globalfunctions[name]));
            }
        }
        for (var name in phpGlobals.compiletimeconstants) {
            if (phpGlobals.compiletimeconstants.hasOwnProperty(name) && matches(name)) {
                added[name] = true;
                result.push(createNewProposal(vscode_1.CompletionItemKind.Field, name, phpGlobals.compiletimeconstants[name]));
            }
        }
        for (var name in phpGlobals.keywords) {
            if (phpGlobals.keywords.hasOwnProperty(name) && matches(name)) {
                added[name] = true;
                result.push(createNewProposal(vscode_1.CompletionItemKind.Keyword, name, phpGlobals.keywords[name]));
            }
        }
        var text = document.getText();
        if (prefix[0] === '$') {
            var variableMatch = /\$([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)/g;
            var match = null;
            while (match = variableMatch.exec(text)) {
                var word = match[0];
                if (!added[word]) {
                    added[word] = true;
                    result.push(createNewProposal(vscode_1.CompletionItemKind.Variable, word, null));
                }
            }
        }
        var functionMatch = /function\s+([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)\s*\(/g;
        var match = null;
        while (match = functionMatch.exec(text)) {
            var word = match[1];
            if (!added[word]) {
                added[word] = true;
                result.push(createNewProposal(vscode_1.CompletionItemKind.Function, word, null));
            }
        }
        return Promise.resolve(result);
    };
    return PHPCompletionItemProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PHPCompletionItemProvider;
//# sourceMappingURL=completionItemProvider.js.map