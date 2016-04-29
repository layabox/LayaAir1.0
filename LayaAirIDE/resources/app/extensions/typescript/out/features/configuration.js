/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_1 = require('vscode');
exports.defaultConfiguration = {
    useCodeSnippetsOnMethodSuggest: false
};
function load(myPluginId) {
    var configuration = vscode_1.workspace.getConfiguration(myPluginId);
    var useCodeSnippetsOnMethodSuggest = configuration.get('useCodeSnippetsOnMethodSuggest', exports.defaultConfiguration.useCodeSnippetsOnMethodSuggest);
    return {
        useCodeSnippetsOnMethodSuggest: useCodeSnippetsOnMethodSuggest
    };
}
exports.load = load;
//# sourceMappingURL=configuration.js.map