/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var Strings = require('../utils/strings');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var BowerJSONContribution = (function () {
    function BowerJSONContribution(requestService) {
        this.topRanked = ['twitter', 'bootstrap', 'angular-1.1.6', 'angular-latest', 'angulerjs', 'd3', 'myjquery', 'jq', 'abcdef1234567890', 'jQuery', 'jquery-1.11.1', 'jquery',
            'sushi-vanilla-x-data', 'font-awsome', 'Font-Awesome', 'font-awesome', 'fontawesome', 'html5-boilerplate', 'impress.js', 'homebrew',
            'backbone', 'moment1', 'momentjs', 'moment', 'linux', 'animate.css', 'animate-css', 'reveal.js', 'jquery-file-upload', 'blueimp-file-upload', 'threejs', 'express', 'chosen',
            'normalize-css', 'normalize.css', 'semantic', 'semantic-ui', 'Semantic-UI', 'modernizr', 'underscore', 'underscore1',
            'material-design-icons', 'ionic', 'chartjs', 'Chart.js', 'nnnick-chartjs', 'select2-ng', 'select2-dist', 'phantom', 'skrollr', 'scrollr', 'less.js', 'leancss', 'parser-lib',
            'hui', 'bootstrap-languages', 'async', 'gulp', 'jquery-pjax', 'coffeescript', 'hammer.js', 'ace', 'leaflet', 'jquery-mobile', 'sweetalert', 'typeahead.js', 'soup', 'typehead.js',
            'sails', 'codeigniter2'];
        this.requestService = requestService;
    }
    BowerJSONContribution.prototype.isBowerFile = function (resource) {
        return Strings.endsWith(resource, '/bower.json') || Strings.endsWith(resource, '/.bower.json');
    };
    BowerJSONContribution.prototype.collectDefaultSuggestions = function (resource, result) {
        if (this.isBowerFile(resource)) {
            var defaultValue = {
                'name': '{{name}}',
                'description': '{{description}}',
                'authors': ['{{author}}'],
                'version': '{{1.0.0}}',
                'main': '{{pathToMain}}',
                'dependencies': {}
            };
            result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: localize(0, null), insertText: JSON.stringify(defaultValue, null, '\t'), documentation: '' });
        }
        return null;
    };
    BowerJSONContribution.prototype.collectPropertySuggestions = function (resource, location, currentWord, addValue, isLast, result) {
        if (this.isBowerFile(resource) && (location.matches(['dependencies']) || location.matches(['devDependencies']))) {
            if (currentWord.length > 0) {
                var queryUrl = 'https://bower.herokuapp.com/packages/search/' + encodeURIComponent(currentWord);
                return this.requestService({
                    url: queryUrl
                }).then(function (success) {
                    if (success.status === 200) {
                        try {
                            var obj = JSON.parse(success.responseText);
                            if (Array.isArray(obj)) {
                                var results = obj;
                                for (var i = 0; i < results.length; i++) {
                                    var name = results[i].name;
                                    var description = results[i].description || '';
                                    var insertText = JSON.stringify(name);
                                    if (addValue) {
                                        insertText += ': "{{*}}"';
                                        if (!isLast) {
                                            insertText += ',';
                                        }
                                    }
                                    result.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: name, insertText: insertText, documentation: description });
                                }
                                result.setAsIncomplete();
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
                this.topRanked.forEach(function (name) {
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
    BowerJSONContribution.prototype.collectValueSuggestions = function (resource, location, currentKey, result) {
        // not implemented. Could be do done calling the bower command. Waiting for web API: https://github.com/bower/registry/issues/26
        return null;
    };
    BowerJSONContribution.prototype.getInfoContribution = function (resource, location) {
        if (this.isBowerFile(resource) && (location.matches(['dependencies', '*']) || location.matches(['devDependencies', '*']))) {
            var pack = location.getSegments()[location.getSegments().length - 1];
            var htmlContent_1 = [];
            htmlContent_1.push(localize(3, null, pack));
            var queryUrl = 'https://bower.herokuapp.com/packages/' + encodeURIComponent(pack);
            return this.requestService({
                url: queryUrl
            }).then(function (success) {
                try {
                    var obj = JSON.parse(success.responseText);
                    if (obj && obj.url) {
                        var url = obj.url;
                        if (Strings.startsWith(url, 'git://')) {
                            url = url.substring(6);
                        }
                        if (Strings.endsWith(url, '.git')) {
                            url = url.substring(0, url.length - 4);
                        }
                        htmlContent_1.push(url);
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
    return BowerJSONContribution;
}());
exports.BowerJSONContribution = BowerJSONContribution;
//# sourceMappingURL=bowerJSONContribution.js.map