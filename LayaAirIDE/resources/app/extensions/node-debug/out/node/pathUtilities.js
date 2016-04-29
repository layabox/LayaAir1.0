/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
"use strict";
var Path = require('path');
var FS = require('fs');
/**
  * The input paths must use the path syntax of the underlying operating system.
 */
function makePathAbsolute(absPath, relPath) {
    return Path.resolve(Path.dirname(absPath), relPath);
}
exports.makePathAbsolute = makePathAbsolute;
/**
 * Remove the first segment of the given path and return the result.
 * The input path must use the path syntax of the underlying operating system.
 */
function removeFirstSegment(path) {
    var segments = path.split(Path.sep);
    segments.shift();
    if (segments.length > 0) {
        return segments.join(Path.sep);
    }
    return null;
}
exports.removeFirstSegment = removeFirstSegment;
/**
 * Return the relative path between 'path' and 'target'.
 * The input paths must use the path syntax of the underlying operating system.
 */
function makeRelative(target, path) {
    var t = target.split(Path.sep);
    var p = path.split(Path.sep);
    var i = 0;
    for (; i < Math.min(t.length, p.length) && t[i] === p[i]; i++) {
    }
    var result = '';
    for (; i < p.length; i++) {
        result = Path.join(result, p[i]);
    }
    return result;
}
exports.makeRelative = makeRelative;
/**
 * Returns a path with a lower case drive letter.
 */
function normalizeDriveLetter(path) {
    var regex = /^([A-Z])(\:[\\\/].*)$/;
    if (regex.test(path)) {
        path = path.replace(regex, function (s, s1, s2) { return s1.toLowerCase() + s2; });
    }
    return path;
}
exports.normalizeDriveLetter = normalizeDriveLetter;
/**
 * Given an absolute, normalized, and existing file path 'realPath' returns the exact path that the file has on disk.
 * On a case insensitive file system, the returned path might differ from the original path by character casing.
 * On a case sensitive file system, the returned path will always be identical to the original path.
 * In case of errors, null is returned. But you cannot use this function to verify that a path exists.
 * realPath does not handle '..' or '.' path segments and it does not take the locale into account.
 * Since a drive letter of a Windows path cannot be looked up, realPath normalizes the drive letter to lower case.
 */
function realPath(path) {
    var dir = Path.dirname(path);
    if (path === dir) {
        // is this an upper case drive letter?
        if (/^[A-Z]\:\\$/.test(path)) {
            path = path.toLowerCase();
        }
        return path;
    }
    var name = Path.basename(path).toLowerCase();
    try {
        var entries = FS.readdirSync(dir);
        var found = entries.filter(function (e) { return e.toLowerCase() === name; }); // use a case insensitive search
        if (found.length === 1) {
            // on a case sensitive filesystem we cannot determine here, whether the file exists or not, hence we need the 'file exists' precondition
            var prefix = realPath(dir); // recurse
            if (prefix) {
                return Path.join(prefix, found[0]);
            }
        }
        else if (found.length > 1) {
            // must be a case sensitive $filesystem
            var ix = found.indexOf(name);
            if (ix >= 0) {
                var prefix = realPath(dir); // recurse
                if (prefix) {
                    return Path.join(prefix, found[ix]);
                }
            }
        }
    }
    catch (error) {
    }
    return null;
}
exports.realPath = realPath;
//---- the following functions work with Windows and Unix-style paths independent from the underlying OS.
/**
 * Returns true if the Windows or Unix-style path is absolute.
 */
function isAbsolutePath(path) {
    if (path) {
        if (path.charAt(0) === '/') {
            return true;
        }
        if (/^[a-zA-Z]\:[\\\/]/.test(path)) {
            return true;
        }
    }
    return false;
}
exports.isAbsolutePath = isAbsolutePath;
/**
 * Convert the given Windows or Unix-style path into a normalized path that only uses forward slashes and has all superflous '..' sequences removed.
 * If the path starts with a Windows-style drive letter, a '/' is prepended.
 */
function normalize(path) {
    path = path.replace(/\\/g, '/');
    if (/^[a-zA-Z]\:\//.test(path)) {
        path = '/' + path;
    }
    path = Path.normalize(path); // use node's normalize to remove '<dir>/..' etc.
    path = path.replace(/\\/g, '/');
    return path;
}
exports.normalize = normalize;
/**
 * Convert the given normalized path into a Windows-style path.
 */
function toWindows(path) {
    if (/^\/[a-zA-Z]\:\//.test(path)) {
        path = path.substr(1);
    }
    path = path.replace(/\//g, '\\');
    return path;
}
exports.toWindows = toWindows;
/**
 * Append the given relative path to the absolute path and normalize the result.
 */
function join(absPath, relPath) {
    absPath = normalize(absPath);
    relPath = normalize(relPath);
    if (absPath.charAt(absPath.length - 1) === '/') {
        absPath = absPath + relPath;
    }
    else {
        absPath = absPath + '/' + relPath;
    }
    absPath = Path.normalize(absPath);
    absPath = absPath.replace(/\\/g, '/');
    return absPath;
}
exports.join = join;
/**
 * Return the relative path between 'from' and 'to'.
 */
function makeRelative2(from, to) {
    from = normalize(from);
    to = normalize(to);
    var froms = from.substr(1).split('/');
    var tos = to.substr(1).split('/');
    while (froms.length > 0 && tos.length > 0 && froms[0] === tos[0]) {
        froms.shift();
        tos.shift();
    }
    var l = froms.length - tos.length;
    if (l === 0) {
        l = tos.length - 1;
    }
    while (l > 0) {
        tos.unshift('..');
        l--;
    }
    return tos.join('/');
}
exports.makeRelative2 = makeRelative2;

//# sourceMappingURL=../../out/node/pathUtilities.js.map
