/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var completionItemProvider_1 = require('./features/completionItemProvider');
var hoverProvider_1 = require('./features/hoverProvider');
var signatureHelpProvider_1 = require('./features/signatureHelpProvider');
var validationProvider_1 = require('./features/validationProvider');
var vscode_1 = require('vscode');
var nls = require('vscode-nls');
function activate(context) {
    nls.config({ locale: vscode_1.env.language });
    // add providers
    context.subscriptions.push(vscode_1.languages.registerCompletionItemProvider('php', new completionItemProvider_1.default(), '.', '$'));
    context.subscriptions.push(vscode_1.languages.registerHoverProvider('php', new hoverProvider_1.default()));
    context.subscriptions.push(vscode_1.languages.registerSignatureHelpProvider('php', new signatureHelpProvider_1.default(), '(', ','));
    var validator = new validationProvider_1.default();
    validator.activate(context.subscriptions);
    // need to set in the extension host as well as the completion provider uses it.
    vscode_1.languages.setLanguageConfiguration('php', {
        wordPattern: /(-?\d*\.\d\w*)|([^\-\`\~\!\@\#\%\^\&\*\(\)\=\+\[\{\]\}\\\|\;\:\'\"\,\.\<\>\/\?\s]+)/g,
        __characterPairSupport: {
            autoClosingPairs: [
                { open: '{', close: '}' },
                { open: '[', close: ']' },
                { open: '(', close: ')' },
                { open: '"', close: '"', notIn: ['string'] },
                { open: '\'', close: '\'', notIn: ['string', 'comment'] }
            ]
        }
    });
}
exports.activate = activate;
//# sourceMappingURL=phpMain.js.map