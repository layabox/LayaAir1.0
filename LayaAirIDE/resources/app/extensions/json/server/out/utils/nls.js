/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
function localize2(key, message) {
    var formatArgs = [];
    for (var _i = 2; _i < arguments.length; _i++) {
        formatArgs[_i - 2] = arguments[_i];
    }
    if (formatArgs.length > 0) {
        return message.replace(/\{(\d+)\}/g, function (match, rest) {
            var index = rest[0];
            return typeof formatArgs[index] !== 'undefined' ? formatArgs[index] : match;
        });
    }
    return message;
}
exports.localize2 = localize2;
//# sourceMappingURL=nls.js.map