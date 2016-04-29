/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
var phpGlobals = require('./phpGlobals');
var PHPHoverProvider = (function () {
    function PHPHoverProvider() {
    }
    PHPHoverProvider.prototype.provideHover = function (document, position, token) {
        var wordRange = document.getWordRangeAtPosition(position);
        if (!wordRange) {
            return;
        }
        var name = document.getText(wordRange);
        var entry = phpGlobals.globalfunctions[name] || phpGlobals.compiletimeconstants[name] || phpGlobals.globalvariables[name] || phpGlobals.keywords[name];
        if (entry && entry.description) {
            var signature = name + (entry.signature || '');
            var contents = [entry.description, { language: 'php', value: signature }];
            return new vscode_1.Hover(contents, wordRange);
        }
    };
    return PHPHoverProvider;
}());
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PHPHoverProvider;
//# sourceMappingURL=hoverProvider.js.map