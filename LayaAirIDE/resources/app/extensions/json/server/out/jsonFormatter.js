/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var Json = require('./json-toolbox/json');
var vscode_languageserver_1 = require('vscode-languageserver');
function format(document, range, options) {
    var documentText = document.getText();
    var initialIndentLevel;
    var value;
    var rangeOffset;
    if (range) {
        var startPosition = vscode_languageserver_1.Position.create(range.start.line, 0);
        rangeOffset = document.offsetAt(startPosition);
        var endOffset = document.offsetAt(vscode_languageserver_1.Position.create(range.end.line + 1, 0));
        var endLineStart = document.offsetAt(vscode_languageserver_1.Position.create(range.end.line, 0));
        while (endOffset > endLineStart && isEOL(documentText, endOffset - 1)) {
            endOffset--;
        }
        range = vscode_languageserver_1.Range.create(startPosition, document.positionAt(endOffset));
        value = documentText.substring(rangeOffset, endOffset);
        initialIndentLevel = computeIndentLevel(value, 0, options);
    }
    else {
        value = documentText;
        range = vscode_languageserver_1.Range.create(vscode_languageserver_1.Position.create(0, 0), document.positionAt(value.length));
        initialIndentLevel = 0;
        rangeOffset = 0;
    }
    var eol = getEOL(document);
    var lineBreak = false;
    var indentLevel = 0;
    var indentValue;
    if (options.insertSpaces) {
        indentValue = repeat(' ', options.tabSize);
    }
    else {
        indentValue = '\t';
    }
    var scanner = Json.createScanner(value, false);
    function newLineAndIndent() {
        return eol + repeat(indentValue, initialIndentLevel + indentLevel);
    }
    function scanNext() {
        var token = scanner.scan();
        lineBreak = false;
        while (token === Json.SyntaxKind.Trivia || token === Json.SyntaxKind.LineBreakTrivia) {
            lineBreak = lineBreak || (token === Json.SyntaxKind.LineBreakTrivia);
            token = scanner.scan();
        }
        return token;
    }
    var editOperations = [];
    function addEdit(text, startOffset, endOffset) {
        if (documentText.substring(startOffset, endOffset) !== text) {
            var replaceRange = vscode_languageserver_1.Range.create(document.positionAt(startOffset), document.positionAt(endOffset));
            editOperations.push(vscode_languageserver_1.TextEdit.replace(replaceRange, text));
        }
    }
    var firstToken = scanNext();
    if (firstToken !== Json.SyntaxKind.EOF) {
        var firstTokenStart = scanner.getTokenOffset() + rangeOffset;
        var initialIndent = repeat(indentValue, initialIndentLevel);
        addEdit(initialIndent, rangeOffset, firstTokenStart);
    }
    while (firstToken !== Json.SyntaxKind.EOF) {
        var firstTokenEnd = scanner.getTokenOffset() + scanner.getTokenLength() + rangeOffset;
        var secondToken = scanNext();
        while (!lineBreak && (secondToken === Json.SyntaxKind.LineCommentTrivia || secondToken === Json.SyntaxKind.BlockCommentTrivia)) {
            // comments on the same line: keep them on the same line, but ignore them otherwise
            var commentTokenStart = scanner.getTokenOffset() + rangeOffset;
            addEdit(' ', firstTokenEnd, commentTokenStart);
            firstTokenEnd = scanner.getTokenOffset() + scanner.getTokenLength() + rangeOffset;
            secondToken = scanNext();
        }
        var replaceContent = '';
        if (secondToken === Json.SyntaxKind.CloseBraceToken) {
            if (firstToken !== Json.SyntaxKind.OpenBraceToken) {
                indentLevel--;
                replaceContent = newLineAndIndent();
            }
        }
        else if (secondToken === Json.SyntaxKind.CloseBracketToken) {
            if (firstToken !== Json.SyntaxKind.OpenBracketToken) {
                indentLevel--;
                replaceContent = newLineAndIndent();
            }
        }
        else {
            switch (firstToken) {
                case Json.SyntaxKind.OpenBracketToken:
                case Json.SyntaxKind.OpenBraceToken:
                    indentLevel++;
                    replaceContent = newLineAndIndent();
                    break;
                case Json.SyntaxKind.CommaToken:
                case Json.SyntaxKind.LineCommentTrivia:
                    replaceContent = newLineAndIndent();
                    break;
                case Json.SyntaxKind.BlockCommentTrivia:
                    if (lineBreak) {
                        replaceContent = newLineAndIndent();
                    }
                    else {
                        // symbol following comment on the same line: keep on same line, separate with ' '
                        replaceContent = ' ';
                    }
                    break;
                case Json.SyntaxKind.ColonToken:
                    replaceContent = ' ';
                    break;
                case Json.SyntaxKind.NullKeyword:
                case Json.SyntaxKind.TrueKeyword:
                case Json.SyntaxKind.FalseKeyword:
                case Json.SyntaxKind.NumericLiteral:
                    if (secondToken === Json.SyntaxKind.NullKeyword || secondToken === Json.SyntaxKind.FalseKeyword || secondToken === Json.SyntaxKind.NumericLiteral) {
                        replaceContent = ' ';
                    }
                    break;
            }
            if (lineBreak && (secondToken === Json.SyntaxKind.LineCommentTrivia || secondToken === Json.SyntaxKind.BlockCommentTrivia)) {
                replaceContent = newLineAndIndent();
            }
        }
        var secondTokenStart = scanner.getTokenOffset() + rangeOffset;
        addEdit(replaceContent, firstTokenEnd, secondTokenStart);
        firstToken = secondToken;
    }
    return editOperations;
}
exports.format = format;
function repeat(s, count) {
    var result = '';
    for (var i = 0; i < count; i++) {
        result += s;
    }
    return result;
}
function computeIndentLevel(content, offset, options) {
    var i = 0;
    var nChars = 0;
    var tabSize = options.tabSize || 4;
    while (i < content.length) {
        var ch = content.charAt(i);
        if (ch === ' ') {
            nChars++;
        }
        else if (ch === '\t') {
            nChars += tabSize;
        }
        else {
            break;
        }
        i++;
    }
    return Math.floor(nChars / tabSize);
}
function getEOL(document) {
    var text = document.getText();
    if (document.lineCount > 1) {
        var to = document.offsetAt(vscode_languageserver_1.Position.create(1, 0));
        var from = to;
        while (from > 0 && isEOL(text, from - 1)) {
            from--;
        }
        return text.substr(from, to - from);
    }
    return '\n';
}
function isEOL(text, offset) {
    return '\r\n'.indexOf(text.charAt(offset)) !== -1;
}
//# sourceMappingURL=jsonFormatter.js.map