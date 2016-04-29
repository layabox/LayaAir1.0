/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

var keymapping = null;
var tried = false;

exports.getKeyMap = function() {
  if (!tried) {
    tried = true;
    try {
      keymapping = require('./build/Release/keymapping');
    } catch(err) {
      console.error(err);
    }
  }

  if (!keymapping) {
    return [];
  }

  var r = [];
  try {
    r = keymapping.getKeyMap();
  } catch(err) {
    console.error(err);
  }
  return r;
};
