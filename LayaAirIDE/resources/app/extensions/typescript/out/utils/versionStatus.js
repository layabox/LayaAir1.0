/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode = require('vscode');
var versionBarEntry = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, Number.MIN_VALUE);
var _enable = false;
function showHideStatus() {
    if (!versionBarEntry || !_enable) {
        return;
    }
    if (!vscode.window.activeTextEditor) {
        versionBarEntry.hide();
        return;
    }
    var doc = vscode.window.activeTextEditor.document;
    if (vscode.languages.match('javascript', doc) || vscode.languages.match('javascriptreact', doc)
        || vscode.languages.match('typescript', doc) || vscode.languages.match('typescriptreact', doc)) {
        versionBarEntry.show();
        return;
    }
    versionBarEntry.hide();
}
exports.showHideStatus = showHideStatus;
function disposeStatus() {
    if (versionBarEntry) {
        versionBarEntry.dispose();
    }
}
exports.disposeStatus = disposeStatus;
function setInfo(message, tooltip) {
    versionBarEntry.text = message;
    versionBarEntry.tooltip = tooltip;
    var color = 'white';
    versionBarEntry.color = color;
    if (_enable) {
        versionBarEntry.show();
    }
}
exports.setInfo = setInfo;
function enable(value) {
    _enable = value;
    showHideStatus();
}
exports.enable = enable;
//# sourceMappingURL=versionStatus.js.map