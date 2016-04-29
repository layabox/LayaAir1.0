/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var Strings = require('../utils/strings');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var globProperties = [
    { kind: vscode_languageserver_1.CompletionItemKind.Value, label: localize(0, null), insertText: '"*.{{extension}}": "{{language}}"', documentation: localize(1, null) },
    { kind: vscode_languageserver_1.CompletionItemKind.Value, label: localize(2, null), insertText: '"/{{path to file}}/*.{{extension}}": "{{language}}"', documentation: localize(3, null) }
];
var FileAssociationContribution = (function () {
    function FileAssociationContribution() {
    }
    FileAssociationContribution.prototype.setLanguageIds = function (ids) {
        this.languageIds = ids;
    };
    FileAssociationContribution.prototype.isSettingsFile = function (resource) {
        return Strings.endsWith(resource, '/settings.json');
    };
    FileAssociationContribution.prototype.collectDefaultSuggestions = function (resource, result) {
        return null;
    };
    FileAssociationContribution.prototype.collectPropertySuggestions = function (resource, location, currentWord, addValue, isLast, result) {
        if (this.isSettingsFile(resource) && location.matches(['files.associations'])) {
            globProperties.forEach(function (e) { return result.add(e); });
        }
        return null;
    };
    FileAssociationContribution.prototype.collectValueSuggestions = function (resource, location, currentKey, result) {
        if (this.isSettingsFile(resource) && location.matches(['files.associations'])) {
            this.languageIds.forEach(function (l) {
                result.add({
                    kind: vscode_languageserver_1.CompletionItemKind.Value,
                    label: l,
                    insertText: '"{{' + l + '}}"',
                });
            });
        }
        return null;
    };
    FileAssociationContribution.prototype.getInfoContribution = function (resource, location) {
        return null;
    };
    return FileAssociationContribution;
}());
exports.FileAssociationContribution = FileAssociationContribution;
//# sourceMappingURL=fileAssociationContribution.js.map