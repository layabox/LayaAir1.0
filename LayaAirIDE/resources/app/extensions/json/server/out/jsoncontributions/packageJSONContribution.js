/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var Strings = require('../utils/strings');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var LIMIT = 40;
var PackageJSONContribution = (function () {
    function PackageJSONContribution(requestService) {
        this.mostDependedOn = ['lodash', 'async', 'underscore', 'request', 'commander', 'express', 'debug', 'chalk', 'colors', 'q', 'coffee-script',
            'mkdirp', 'optimist', 'through2', 'yeoman-generator', 'moment', 'bluebird', 'glob', 'gulp-util', 'minimist', 'cheerio', 'jade', 'redis', 'node-uuid',
            'socket', 'io', 'uglify-js', 'winston', 'through', 'fs-extra', 'handlebars', 'body-parser', 'rimraf', 'mime', 'semver', 'mongodb', 'jquery',
            'grunt', 'connect', 'yosay', 'underscore', 'string', 'xml2js', 'ejs', 'mongoose', 'marked', 'extend', 'mocha', 'superagent', 'js-yaml', 'xtend',
            'shelljs', 'gulp', 'yargs', 'browserify', 'minimatch', 'react', 'less', 'prompt', 'inquirer', 'ws', 'event-stream', 'inherits', 'mysql', 'esprima',
            'jsdom', 'stylus', 'when', 'readable-stream', 'aws-sdk', 'concat-stream', 'chai', 'Thenable', 'wrench'];
        this.requestService = requestService;
    }
    PackageJSONContribution.prototype.isPackageJSONFile = function (resource) {
        return Strings.endsWith(resource, '/package.json');
    };
    PackageJSONContribution.prototype.collectDefaultSuggestions = function (resource, result) {
        if (this.isPackageJSONFile(resource)) {
            var defaultValue = {
                'name': '{{name}}',
                'description': '{{description}}',
                'author': '{{author}}',
                'version': '{{1.0.0}}',
                'main': '{{pathToMain}}',
                'dependencies': {}
            };
            result.add({ kind: vscode_languageserver_1.CompletionItemKind.Module, label: localize(0, null), insertText: JSON.stringify(defaultValue, null, '\t'), documentation: '' });
        }
        return null;
    };
    PackageJSONContribution.prototype.collectPropertySuggestions = function (resource, location, currentWord, addValue, isLast, result) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['devDependencies']) || location.matches(['optionalDependencies']) || location.matches(['peerDependencies']))) {
            var queryUrl = void 0;
            if (currentWord.length > 0) {
                queryUrl = 'https://skimdb.npmjs.com/registry/_design/app/_view/browseAll?group_level=1&limit=' + LIMIT + '&start_key=%5B%22' + encodeURIComponent(currentWord) + '%22%5D&end_key=%5B%22' + encodeURIComponent(currentWord + 'z') + '%22,%7B%7D%5D';
                return this.requestService({
                    url: queryUrl
                }).then(function (success) {
                    if (success.status === 200) {
                        try {
                            var obj = JSON.parse(success.responseText);
                            if (obj && Array.isArray(obj.rows)) {
                                var results = obj.rows;
                                for (var i = 0; i < results.length; i++) {
                                    var keys = results[i].key;
                                    if (Array.isArray(keys) && keys.length > 0) {
                                        var name = keys[0];
                                        var insertText = JSON.stringify(name);
                                        if (addValue) {
                                            insertText += ': "{{*}}"';
                                            if (!isLast) {
                                                insertText += ',';
                                            }
                                        }
                                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: name, insertText: insertText, documentation: '' });
                                    }
                                }
                                if (results.length === LIMIT) {
                                    result.setAsIncomplete();
                                }
                            }
                        }
                        catch (e) {
                        }
                    }
                    else {
                        result.error(localize(1, null, success.responseText));
                        return 0;
                    }
                }, function (error) {
                    result.error(localize(2, null, error.responseText));
                    return 0;
                });
            }
            else {
                this.mostDependedOn.forEach(function (name) {
                    var insertText = JSON.stringify(name);
                    if (addValue) {
                        insertText += ': "{{*}}"';
                        if (!isLast) {
                            insertText += ',';
                        }
                    }
                    result.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: name, insertText: insertText, documentation: '' });
                });
                result.setAsIncomplete();
            }
        }
        return null;
    };
    PackageJSONContribution.prototype.collectValueSuggestions = function (resource, location, currentKey, result) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['devDependencies']) || location.matches(['optionalDependencies']) || location.matches(['peerDependencies']))) {
            var queryUrl = 'http://registry.npmjs.org/' + encodeURIComponent(currentKey) + '/latest';
            return this.requestService({
                url: queryUrl
            }).then(function (success) {
                try {
                    var obj = JSON.parse(success.responseText);
                    if (obj && obj.version) {
                        var version = obj.version;
                        var name = JSON.stringify(version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name, insertText: name, documentation: localize(3, null) });
                        name = JSON.stringify('^' + version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name, insertText: name, documentation: localize(4, null) });
                        name = JSON.stringify('~' + version);
                        result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: name, insertText: name, documentation: localize(5, null) });
                    }
                }
                catch (e) {
                }
                return 0;
            }, function (error) {
                return 0;
            });
        }
        return null;
    };
    PackageJSONContribution.prototype.getInfoContribution = function (resource, location) {
        if (this.isPackageJSONFile(resource) && (location.matches(['dependencies', '*']) || location.matches(['devDependencies', '*']) || location.matches(['optionalDependencies', '*']) || location.matches(['peerDependencies', '*']))) {
            var pack = location.getSegments()[location.getSegments().length - 1];
            var htmlContent_1 = [];
            htmlContent_1.push(localize(6, null, pack));
            var queryUrl = 'http://registry.npmjs.org/' + encodeURIComponent(pack) + '/latest';
            return this.requestService({
                url: queryUrl
            }).then(function (success) {
                try {
                    var obj = JSON.parse(success.responseText);
                    if (obj) {
                        if (obj.description) {
                            htmlContent_1.push(obj.description);
                        }
                        if (obj.version) {
                            htmlContent_1.push(localize(7, null, obj.version));
                        }
                    }
                }
                catch (e) {
                }
                return htmlContent_1;
            }, function (error) {
                return htmlContent_1;
            });
        }
        return null;
    };
    return PackageJSONContribution;
}());
exports.PackageJSONContribution = PackageJSONContribution;
//# sourceMappingURL=packageJSONContribution.js.map