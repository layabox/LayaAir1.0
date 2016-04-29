/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var Strings = require('../utils/strings');
var httpRequest_1 = require('../utils/httpRequest');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var FEED_INDEX_URL = 'https://api.nuget.org/v3/index.json';
var LIMIT = 30;
var RESOLVE_ID = 'ProjectJSONContribution-';
var CACHE_EXPIRY = 1000 * 60 * 5; // 5 minutes
var ProjectJSONContribution = (function () {
    function ProjectJSONContribution(requestService) {
        this.cachedProjects = {};
        this.cacheSize = 0;
        this.requestService = requestService;
    }
    ProjectJSONContribution.prototype.isProjectJSONFile = function (resource) {
        return Strings.endsWith(resource, '/project.json');
    };
    ProjectJSONContribution.prototype.completeWithCache = function (id, item) {
        var entry = this.cachedProjects[id];
        if (entry) {
            if (new Date().getTime() - entry.time > CACHE_EXPIRY) {
                delete this.cachedProjects[id];
                this.cacheSize--;
                return false;
            }
            item.detail = entry.version;
            item.documentation = entry.description;
            item.insertText = item.insertText.replace(/\{\{\}\}/, '{{' + entry.version + '}}');
            return true;
        }
        return false;
    };
    ProjectJSONContribution.prototype.addCached = function (id, version, description) {
        this.cachedProjects[id] = { version: version, description: description, time: new Date().getTime() };
        this.cacheSize++;
        if (this.cacheSize > 50) {
            var currentTime = new Date().getTime();
            for (var id_1 in this.cachedProjects) {
                var entry = this.cachedProjects[id_1];
                if (currentTime - entry.time > CACHE_EXPIRY) {
                    delete this.cachedProjects[id_1];
                    this.cacheSize--;
                }
            }
        }
    };
    ProjectJSONContribution.prototype.getNugetIndex = function () {
        if (!this.nugetIndexPromise) {
            this.nugetIndexPromise = this.makeJSONRequest(FEED_INDEX_URL).then(function (indexContent) {
                var services = {};
                if (indexContent && Array.isArray(indexContent.resources)) {
                    var resources = indexContent.resources;
                    for (var i = resources.length - 1; i >= 0; i--) {
                        var type = resources[i]['@type'];
                        var id = resources[i]['@id'];
                        if (type && id) {
                            services[type] = id;
                        }
                    }
                }
                return services;
            });
        }
        return this.nugetIndexPromise;
    };
    ProjectJSONContribution.prototype.getNugetService = function (serviceType) {
        return this.getNugetIndex().then(function (services) {
            var serviceURL = services[serviceType];
            if (!serviceURL) {
                return Promise.reject(localize(0, null, serviceType));
            }
            return serviceURL;
        });
    };
    ProjectJSONContribution.prototype.collectDefaultSuggestions = function (resource, result) {
        if (this.isProjectJSONFile(resource)) {
            var defaultValue = {
                'version': '{{1.0.0-*}}',
                'dependencies': {},
                'frameworks': {
                    'dnx451': {},
                    'dnxcore50': {}
                }
            };
            result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: localize(1, null), insertText: JSON.stringify(defaultValue, null, '\t'), documentation: '' });
        }
        return null;
    };
    ProjectJSONContribution.prototype.makeJSONRequest = function (url) {
        return this.requestService({
            url: url
        }).then(function (success) {
            if (success.status === 200) {
                try {
                    return JSON.parse(success.responseText);
                }
                catch (e) {
                    return Promise.reject(localize(2, null, url));
                }
            }
            return Promise.reject(localize(3, null, url, success.responseText));
        }, function (error) {
            return Promise.reject(localize(4, null, url, httpRequest_1.getErrorStatusDescription(error.status)));
        });
    };
    ProjectJSONContribution.prototype.collectPropertySuggestions = function (resource, location, currentWord, addValue, isLast, result) {
        var _this = this;
        if (this.isProjectJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['frameworks', '*', 'dependencies']) || location.matches(['frameworks', '*', 'frameworkAssemblies']))) {
            return this.getNugetService('SearchAutocompleteService').then(function (service) {
                var queryUrl;
                if (currentWord.length > 0) {
                    queryUrl = service + '?q=' + encodeURIComponent(currentWord) + '&take=' + LIMIT;
                }
                else {
                    queryUrl = service + '?take=' + LIMIT;
                }
                return _this.makeJSONRequest(queryUrl).then(function (resultObj) {
                    if (Array.isArray(resultObj.data)) {
                        var results = resultObj.data;
                        for (var i = 0; i < results.length; i++) {
                            var name = results[i];
                            var insertText = JSON.stringify(name);
                            if (addValue) {
                                insertText += ': "{{}}"';
                                if (!isLast) {
                                    insertText += ',';
                                }
                            }
                            var item = { kind: vscode_languageserver_1.CompletionItemKind.Property, label: name, insertText: insertText };
                            if (!_this.completeWithCache(name, item)) {
                                item.data = RESOLVE_ID + name;
                            }
                            result.add(item);
                        }
                        if (results.length === LIMIT) {
                            result.setAsIncomplete();
                        }
                    }
                }, function (error) {
                    result.error(error);
                });
            }, function (error) {
                result.error(error);
            });
        }
        ;
        return null;
    };
    ProjectJSONContribution.prototype.collectValueSuggestions = function (resource, location, currentKey, result) {
        var _this = this;
        if (this.isProjectJSONFile(resource) && (location.matches(['dependencies']) || location.matches(['frameworks', '*', 'dependencies']) || location.matches(['frameworks', '*', 'frameworkAssemblies']))) {
            return this.getNugetService('PackageBaseAddress/3.0.0').then(function (service) {
                var queryUrl = service + currentKey + '/index.json';
                return _this.makeJSONRequest(queryUrl).then(function (obj) {
                    if (Array.isArray(obj.versions)) {
                        var results = obj.versions;
                        for (var i = 0; i < results.length; i++) {
                            var curr = results[i];
                            var name = JSON.stringify(curr);
                            var label = name;
                            var documentation = '';
                            result.add({ kind: vscode_languageserver_1.CompletionItemKind.Class, label: label, insertText: name, documentation: documentation });
                        }
                        if (results.length === LIMIT) {
                            result.setAsIncomplete();
                        }
                    }
                }, function (error) {
                    result.error(error);
                });
            }, function (error) {
                result.error(error);
            });
        }
        return null;
    };
    ProjectJSONContribution.prototype.getInfoContribution = function (resource, location) {
        var _this = this;
        if (this.isProjectJSONFile(resource) && (location.matches(['dependencies', '*']) || location.matches(['frameworks', '*', 'dependencies', '*']) || location.matches(['frameworks', '*', 'frameworkAssemblies', '*']))) {
            var pack_1 = location.getSegments()[location.getSegments().length - 1];
            return this.getNugetService('SearchQueryService').then(function (service) {
                var queryUrl = service + '?q=' + encodeURIComponent(pack_1) + '&take=' + 5;
                return _this.makeJSONRequest(queryUrl).then(function (resultObj) {
                    var htmlContent = [];
                    htmlContent.push(localize(5, null, pack_1));
                    if (Array.isArray(resultObj.data)) {
                        var results = resultObj.data;
                        for (var i = 0; i < results.length; i++) {
                            var res = results[i];
                            _this.addCached(res.id, res.version, res.description);
                            if (res.id === pack_1) {
                                if (res.description) {
                                    htmlContent.push(res.description);
                                }
                                if (res.version) {
                                    htmlContent.push(localize(6, null, res.version));
                                }
                                break;
                            }
                        }
                    }
                    return htmlContent;
                }, function (error) {
                    return null;
                });
            }, function (error) {
                return null;
            });
        }
        return null;
    };
    ProjectJSONContribution.prototype.resolveSuggestion = function (item) {
        var _this = this;
        if (item.data && Strings.startsWith(item.data, RESOLVE_ID)) {
            var pack_2 = item.data.substring(RESOLVE_ID.length);
            if (this.completeWithCache(pack_2, item)) {
                return Promise.resolve(item);
            }
            return this.getNugetService('SearchQueryService').then(function (service) {
                var queryUrl = service + '?q=' + encodeURIComponent(pack_2) + '&take=' + 10;
                return _this.makeJSONRequest(queryUrl).then(function (resultObj) {
                    var itemResolved = false;
                    if (Array.isArray(resultObj.data)) {
                        var results = resultObj.data;
                        for (var i = 0; i < results.length; i++) {
                            var curr = results[i];
                            _this.addCached(curr.id, curr.version, curr.description);
                            if (curr.id === pack_2) {
                                _this.completeWithCache(pack_2, item);
                                itemResolved = true;
                            }
                        }
                    }
                    return itemResolved ? item : null;
                });
            });
        }
        ;
        return null;
    };
    return ProjectJSONContribution;
}());
exports.ProjectJSONContribution = ProjectJSONContribution;
//# sourceMappingURL=projectJSONContribution.js.map