/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
"use strict";
var Path = require('path');
var FS = require('fs');
var source_map_1 = require('source-map');
var PathUtils = require('./pathUtilities');
var util = require('../../node_modules/source-map/lib/util.js');
(function (Bias) {
    Bias[Bias["GREATEST_LOWER_BOUND"] = 1] = "GREATEST_LOWER_BOUND";
    Bias[Bias["LEAST_UPPER_BOUND"] = 2] = "LEAST_UPPER_BOUND";
})(exports.Bias || (exports.Bias = {}));
var Bias = exports.Bias;
var SourceMaps = (function () {
    function SourceMaps(session, generatedCodeDirectory) {
        this._allSourceMaps = {}; // map file path -> SourceMap
        this._generatedToSourceMaps = {}; // generated file -> SourceMap
        this._sourceToGeneratedMaps = {}; // source file -> SourceMap
        this._session = session;
        this._generatedCodeDirectory = generatedCodeDirectory;
    }
    SourceMaps.prototype.MapPathFromSource = function (pathToSource) {
        var map = this._findSourceToGeneratedMapping(pathToSource);
        if (map) {
            return map.generatedPath();
        }
        return null;
    };
    SourceMaps.prototype.MapFromSource = function (pathToSource, line, column, bias) {
        var map = this._findSourceToGeneratedMapping(pathToSource);
        if (map) {
            line += 1; // source map impl is 1 based
            var mr = map.generatedPositionFor(pathToSource, line, column, bias);
            if (mr && typeof mr.line === 'number') {
                return {
                    path: map.generatedPath(),
                    line: mr.line - 1,
                    column: mr.column
                };
            }
        }
        return null;
    };
    SourceMaps.prototype.MapToSource = function (pathToGenerated, line, column, bias) {
        var map = this._findGeneratedToSourceMapping(pathToGenerated);
        if (map) {
            line += 1; // source map impl is 1 based
            var mr = map.originalPositionFor(line, column, bias);
            if (mr && mr.source) {
                return {
                    path: mr.source,
                    content: mr.content,
                    line: mr.line - 1,
                    column: mr.column
                };
            }
        }
        return null;
    };
    //---- private -----------------------------------------------------------------------
    /**
     * Tries to find a SourceMap for the given source.
     * This is difficult because the source does not contain any information about where
     * the generated code or the source map is located.
     * Our strategy is as follows:
     * - search in all known source maps whether if refers to this source in the sources array.
     * - ...
     */
    SourceMaps.prototype._findSourceToGeneratedMapping = function (pathToSource) {
        if (!pathToSource) {
            return null;
        }
        // try to find in existing
        if (pathToSource in this._sourceToGeneratedMaps) {
            return this._sourceToGeneratedMaps[pathToSource];
        }
        // a reverse lookup: in all source maps try to find pathToSource in the sources array
        for (var key in this._generatedToSourceMaps) {
            var m = this._generatedToSourceMaps[key];
            if (m.doesOriginateFrom(pathToSource)) {
                this._sourceToGeneratedMaps[pathToSource] = m;
                return m;
            }
        }
        // search for all map files in generatedCodeDirectory
        if (this._generatedCodeDirectory) {
            try {
                var maps = FS.readdirSync(this._generatedCodeDirectory).filter(function (e) { return Path.extname(e.toLowerCase()) === '.map'; });
                for (var _i = 0, maps_1 = maps; _i < maps_1.length; _i++) {
                    var map_name = maps_1[_i];
                    var map_path = Path.join(this._generatedCodeDirectory, map_name);
                    var m = this._loadSourceMap(map_path);
                    if (m && m.doesOriginateFrom(pathToSource)) {
                        this._log("_findSourceToGeneratedMapping: found source map for source " + pathToSource + " in outDir");
                        this._sourceToGeneratedMaps[pathToSource] = m;
                        return m;
                    }
                }
            }
            catch (e) {
            }
        }
        // no map found
        var pathToGenerated = pathToSource;
        var ext = Path.extname(pathToSource);
        if (ext !== '.js') {
            // use heuristic: change extension to ".js" and find a map for it
            var pos = pathToSource.lastIndexOf('.');
            if (pos >= 0) {
                pathToGenerated = pathToSource.substr(0, pos) + '.js';
            }
        }
        var map = null;
        // first look into the generated code directory
        if (this._generatedCodeDirectory) {
            var rest = PathUtils.makeRelative(this._generatedCodeDirectory, pathToGenerated);
            while (rest) {
                var path = Path.join(this._generatedCodeDirectory, rest);
                map = this._findGeneratedToSourceMapping(path);
                if (map) {
                    break;
                }
                rest = PathUtils.removeFirstSegment(rest);
            }
        }
        // VSCode extension host support:
        // we know that the plugin has an "out" directory next to the "src" directory
        if (map === null) {
            var srcSegment = Path.sep + 'src' + Path.sep;
            if (pathToGenerated.indexOf(srcSegment) >= 0) {
                var outSegment = Path.sep + 'out' + Path.sep;
                pathToGenerated = pathToGenerated.replace(srcSegment, outSegment);
                map = this._findGeneratedToSourceMapping(pathToGenerated);
            }
        }
        // if not found look in the same directory as the source
        if (map === null && pathToGenerated !== pathToSource) {
            map = this._findGeneratedToSourceMapping(pathToGenerated);
        }
        if (map) {
            this._sourceToGeneratedMaps[pathToSource] = map;
            return map;
        }
        // nothing found
        return null;
    };
    /**
     * Tries to find a SourceMap for the given path to a generated file.
     * This is simple if the generated file has the 'sourceMappingURL' at the end.
     * If not, we are using some heuristics...
     */
    SourceMaps.prototype._findGeneratedToSourceMapping = function (pathToGenerated) {
        if (!pathToGenerated) {
            return null;
        }
        if (pathToGenerated in this._generatedToSourceMaps) {
            return this._generatedToSourceMaps[pathToGenerated];
        }
        // try to find a source map URL in the generated file
        var map_path = null;
        var uri = this._findSourceMapUrlInFile(pathToGenerated);
        if (uri) {
            // if uri is data url source map is inlined in generated file
            if (uri.indexOf('data:application/json') >= 0) {
                var pos = uri.lastIndexOf(',');
                if (pos > 0) {
                    var data = uri.substr(pos + 1);
                    try {
                        var buffer = new Buffer(data, 'base64');
                        var json = buffer.toString();
                        if (json) {
                            this._log("_findGeneratedToSourceMapping: successfully read inlined source map in '" + pathToGenerated + "'");
                            return this._registerSourceMap(new SourceMap(pathToGenerated, pathToGenerated, json));
                        }
                    }
                    catch (e) {
                        this._log("_findGeneratedToSourceMapping: exception while processing data url '" + e + "'");
                    }
                }
            }
            else {
                map_path = uri;
            }
        }
        // if path is relative make it absolute
        if (map_path && !Path.isAbsolute(map_path)) {
            map_path = PathUtils.makePathAbsolute(pathToGenerated, map_path);
        }
        if (!map_path || !FS.existsSync(map_path)) {
            // try to find map file next to the generated source
            map_path = pathToGenerated + '.map';
        }
        if (map_path && FS.existsSync(map_path)) {
            var map = this._loadSourceMap(map_path, pathToGenerated);
            if (map) {
                return map;
            }
        }
        return null;
    };
    /**
     * try to find the 'sourceMappingURL' in the file with the given path.
     * Returns null in case of errors.
     */
    SourceMaps.prototype._findSourceMapUrlInFile = function (pathToGenerated) {
        try {
            var contents = FS.readFileSync(pathToGenerated).toString();
            var lines = contents.split('\n');
            for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
                var line = lines_1[_i];
                var matches = SourceMaps.SOURCE_MAPPING_MATCHER.exec(line);
                if (matches && matches.length === 2) {
                    var uri = matches[1].trim();
                    this._log("_findSourceMapUrlInFile: source map url at end of generated file '" + pathToGenerated + "''");
                    return uri;
                }
            }
        }
        catch (e) {
        }
        return null;
    };
    /**
     * Loads source map from file system.
     * If no generatedPath is given, the 'file' attribute of the source map is used.
     */
    SourceMaps.prototype._loadSourceMap = function (map_path, generatedPath) {
        if (map_path in this._allSourceMaps) {
            return this._allSourceMaps[map_path];
        }
        try {
            var mp = Path.join(map_path);
            var contents = FS.readFileSync(mp).toString();
            var map = new SourceMap(mp, generatedPath, contents);
            this._allSourceMaps[map_path] = map;
            this._registerSourceMap(map);
            this._log("_loadSourceMap: successfully loaded source map '" + map_path + "'");
            return map;
        }
        catch (e) {
            this._log("_loadSourceMap: loading source map '" + map_path + "' failed with exception: " + e);
        }
        return null;
    };
    SourceMaps.prototype._registerSourceMap = function (map) {
        var gp = map.generatedPath();
        if (gp) {
            this._generatedToSourceMaps[gp] = map;
        }
        return map;
    };
    SourceMaps.prototype._log = function (message) {
        this._session.log('sm', message);
    };
    SourceMaps.SOURCE_MAPPING_MATCHER = new RegExp('//[#@] ?sourceMappingURL=(.+)$');
    return SourceMaps;
}());
exports.SourceMaps = SourceMaps;
var SourceMap = (function () {
    function SourceMap(mapPath, generatedPath, json) {
        var _this = this;
        this._sourcemapLocation = this.fixPath(Path.dirname(mapPath));
        var sm = JSON.parse(json);
        if (!generatedPath) {
            var file = sm.file;
            if (!PathUtils.isAbsolutePath(file)) {
                generatedPath = PathUtils.makePathAbsolute(mapPath, file);
            }
        }
        this._generatedFile = generatedPath;
        // fix all paths for use with the source-map npm module.
        sm.sourceRoot = this.fixPath(sm.sourceRoot, '');
        for (var i = 0; i < sm.sources.length; i++) {
            sm.sources[i] = this.fixPath(sm.sources[i]);
        }
        this._sourceRoot = sm.sourceRoot;
        // use source-map utilities to normalize sources entries
        this._sources = sm.sources
            .map(util.normalize)
            .map(function (source) {
            return _this._sourceRoot && util.isAbsolute(_this._sourceRoot) && util.isAbsolute(source)
                ? util.relative(_this._sourceRoot, source)
                : source;
        });
        try {
            this._smc = new source_map_1.SourceMapConsumer(sm);
        }
        catch (e) {
        }
    }
    /**
     * fix a path for use with the source-map npm module because:
     * - source map sources are URLs, so even on Windows they should be using forward slashes.
     * - the source-map library expects forward slashes and their relative path logic
     *   (specifically the "normalize" function) gives incorrect results when passing in backslashes.
     * - paths starting with drive letters are not recognized as absolute by the source-map library.
     */
    SourceMap.prototype.fixPath = function (path, dflt) {
        if (path) {
            path = path.replace(/\\/g, '/');
            // if path starts with a drive letter convert path to a file url so that the source-map library can handle it
            if (/^[a-zA-Z]\:\//.test(path)) {
                // Windows drive letter must be prefixed with a slash
                path = encodeURI('file:///' + path);
            }
            return path;
        }
        return dflt;
    };
    /**
     * undo the fix
     */
    SourceMap.prototype.unfixPath = function (path) {
        var prefix = 'file://';
        if (path.indexOf(prefix) === 0) {
            path = path.substr(prefix.length);
            path = decodeURI(path);
            if (/^\/[a-zA-Z]\:\//.test(path)) {
                path = path.substr(1); // remove additional '/'
            }
        }
        return path;
    };
    /*
     * The generated file this source map belongs to.
     */
    SourceMap.prototype.generatedPath = function () {
        return this._generatedFile;
    };
    /*
     * Returns true if this source map originates from the given source.
     */
    SourceMap.prototype.doesOriginateFrom = function (absPath) {
        return this.findSource(absPath) !== null;
    };
    /**
     * returns the first entry from the sources array that matches the given absPath
     * or null otherwise.
     */
    SourceMap.prototype.findSource = function (absPath) {
        // on Windows change back slashes to forward slashes because the source-map library requires this
        if (process.platform === 'win32') {
            absPath = absPath.replace(/\\/g, '/');
        }
        for (var _i = 0, _a = this._sources; _i < _a.length; _i++) {
            var name_1 = _a[_i];
            if (!util.isAbsolute(name_1)) {
                name_1 = util.join(this._sourceRoot, name_1);
            }
            var path = this.absolutePath(name_1);
            if (absPath === path) {
                return name_1;
            }
        }
        return null;
    };
    /**
     * Tries to make the given path absolute by prefixing it with the source maps location.
     * Any url schemes are removed.
     */
    SourceMap.prototype.absolutePath = function (path) {
        if (!util.isAbsolute(path)) {
            path = util.join(this._sourcemapLocation, path);
        }
        return this.unfixPath(path);
    };
    /*
     * Finds the nearest source location for the given location in the generated file.
     * Returns null if sourcemap is invalid.
     */
    SourceMap.prototype.originalPositionFor = function (line, column, bias) {
        if (!this._smc) {
            return null;
        }
        var needle = {
            line: line,
            column: column,
            bias: bias || Bias.LEAST_UPPER_BOUND
        };
        var mp = this._smc.originalPositionFor(needle);
        if (mp.source) {
            // if source map has inlined source, return it
            var src = this._smc.sourceContentFor(mp.source);
            if (src) {
                mp.content = src;
            }
            // map result back to absolute path
            mp.source = this.absolutePath(mp.source);
            // on Windows change forward slashes back to back slashes
            if (process.platform === 'win32') {
                mp.source = mp.source.replace(/\//g, '\\');
            }
        }
        return mp;
    };
    /*
     * Finds the nearest location in the generated file for the given source location.
     * Returns null if sourcemap is invalid.
     */
    SourceMap.prototype.generatedPositionFor = function (absPath, line, column, bias) {
        if (!this._smc) {
            return null;
        }
        // make sure that we use an entry from the "sources" array that matches the passed absolute path
        var source = this.findSource(absPath);
        if (source) {
            var needle = {
                source: source,
                line: line,
                column: column,
                bias: bias || Bias.LEAST_UPPER_BOUND
            };
            return this._smc.generatedPositionFor(needle);
        }
        return null;
    };
    return SourceMap;
}());

//# sourceMappingURL=../../out/node/sourceMaps.js.map
