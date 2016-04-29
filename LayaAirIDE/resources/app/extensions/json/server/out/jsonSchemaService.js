/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var Json = require('./json-toolbox/json');
var httpRequest_1 = require('./utils/httpRequest');
var uri_1 = require('./utils/uri');
var Strings = require('./utils/strings');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var FilePatternAssociation = (function () {
    function FilePatternAssociation(pattern) {
        this.combinedSchemaId = 'local://combinedSchema/' + encodeURIComponent(pattern);
        try {
            this.patternRegExp = new RegExp(Strings.convertSimple2RegExpPattern(pattern) + '$');
        }
        catch (e) {
            // invalid pattern
            this.patternRegExp = null;
        }
        this.schemas = [];
        this.combinedSchema = null;
    }
    FilePatternAssociation.prototype.addSchema = function (id) {
        this.schemas.push(id);
        this.combinedSchema = null;
    };
    FilePatternAssociation.prototype.matchesPattern = function (fileName) {
        return this.patternRegExp && this.patternRegExp.test(fileName);
    };
    FilePatternAssociation.prototype.getCombinedSchema = function (service) {
        if (!this.combinedSchema) {
            this.combinedSchema = service.createCombinedSchema(this.combinedSchemaId, this.schemas);
        }
        return this.combinedSchema;
    };
    return FilePatternAssociation;
}());
var SchemaHandle = (function () {
    function SchemaHandle(service, url, unresolvedSchemaContent) {
        this.service = service;
        this.url = url;
        if (unresolvedSchemaContent) {
            this.unresolvedSchema = Promise.resolve(new UnresolvedSchema(unresolvedSchemaContent));
        }
    }
    SchemaHandle.prototype.getUnresolvedSchema = function () {
        if (!this.unresolvedSchema) {
            this.unresolvedSchema = this.service.loadSchema(this.url);
        }
        return this.unresolvedSchema;
    };
    SchemaHandle.prototype.getResolvedSchema = function () {
        var _this = this;
        if (!this.resolvedSchema) {
            this.resolvedSchema = this.getUnresolvedSchema().then(function (unresolved) {
                return _this.service.resolveSchemaContent(unresolved);
            });
        }
        return this.resolvedSchema;
    };
    SchemaHandle.prototype.clearSchema = function () {
        this.resolvedSchema = null;
        this.unresolvedSchema = null;
    };
    return SchemaHandle;
}());
var UnresolvedSchema = (function () {
    function UnresolvedSchema(schema, errors) {
        if (errors === void 0) { errors = []; }
        this.schema = schema;
        this.errors = errors;
    }
    return UnresolvedSchema;
}());
exports.UnresolvedSchema = UnresolvedSchema;
var ResolvedSchema = (function () {
    function ResolvedSchema(schema, errors) {
        if (errors === void 0) { errors = []; }
        this.schema = schema;
        this.errors = errors;
    }
    ResolvedSchema.prototype.getSection = function (path) {
        return this.getSectionRecursive(path, this.schema);
    };
    ResolvedSchema.prototype.getSectionRecursive = function (path, schema) {
        var _this = this;
        if (!schema || path.length === 0) {
            return schema;
        }
        var next = path.shift();
        if (schema.properties && schema.properties[next]) {
            return this.getSectionRecursive(path, schema.properties[next]);
        }
        else if (schema.patternProperties) {
            Object.keys(schema.patternProperties).forEach(function (pattern) {
                var regex = new RegExp(pattern);
                if (regex.test(next)) {
                    return _this.getSectionRecursive(path, schema.patternProperties[pattern]);
                }
            });
        }
        else if (schema.additionalProperties) {
            return this.getSectionRecursive(path, schema.additionalProperties);
        }
        else if (next.match('[0-9]+')) {
            if (schema.items) {
                return this.getSectionRecursive(path, schema.items);
            }
            else if (Array.isArray(schema.items)) {
                try {
                    var index = parseInt(next, 10);
                    if (schema.items[index]) {
                        return this.getSectionRecursive(path, schema.items[index]);
                    }
                    return null;
                }
                catch (e) {
                    return null;
                }
            }
        }
        return null;
    };
    return ResolvedSchema;
}());
exports.ResolvedSchema = ResolvedSchema;
var JSONSchemaService = (function () {
    function JSONSchemaService(requestService, contextService, telemetryService) {
        this.contextService = contextService;
        this.requestService = requestService;
        this.telemetryService = telemetryService;
        this.callOnDispose = [];
        this.contributionSchemas = {};
        this.contributionAssociations = {};
        this.schemasById = {};
        this.filePatternAssociations = [];
        this.filePatternAssociationById = {};
    }
    JSONSchemaService.prototype.dispose = function () {
        while (this.callOnDispose.length > 0) {
            this.callOnDispose.pop()();
        }
    };
    JSONSchemaService.prototype.onResourceChange = function (uri) {
        var schemaFile = this.schemasById[uri];
        if (schemaFile) {
            schemaFile.clearSchema();
            return true;
        }
        return false;
    };
    JSONSchemaService.prototype.normalizeId = function (id) {
        if (id.length > 0 && id.charAt(id.length - 1) === '#') {
            return id.substring(0, id.length - 1);
        }
        return id;
    };
    JSONSchemaService.prototype.setSchemaContributions = function (schemaContributions) {
        var _this = this;
        if (schemaContributions.schemas) {
            var schemas = schemaContributions.schemas;
            for (var id in schemas) {
                var normalizedId = this.normalizeId(id);
                this.contributionSchemas[normalizedId] = this.addSchemaHandle(normalizedId, schemas[id]);
            }
        }
        if (schemaContributions.schemaAssociations) {
            var schemaAssociations = schemaContributions.schemaAssociations;
            for (var pattern in schemaAssociations) {
                var associations = schemaAssociations[pattern];
                this.contributionAssociations[pattern] = associations;
                var fpa = this.getOrAddFilePatternAssociation(pattern);
                associations.forEach(function (schemaId) {
                    var id = _this.normalizeId(schemaId);
                    fpa.addSchema(id);
                });
            }
        }
    };
    JSONSchemaService.prototype.addSchemaHandle = function (id, unresolvedSchemaContent) {
        var schemaHandle = new SchemaHandle(this, id, unresolvedSchemaContent);
        this.schemasById[id] = schemaHandle;
        return schemaHandle;
    };
    JSONSchemaService.prototype.getOrAddSchemaHandle = function (id, unresolvedSchemaContent) {
        return this.schemasById[id] || this.addSchemaHandle(id, unresolvedSchemaContent);
    };
    JSONSchemaService.prototype.getOrAddFilePatternAssociation = function (pattern) {
        var fpa = this.filePatternAssociationById[pattern];
        if (!fpa) {
            fpa = new FilePatternAssociation(pattern);
            this.filePatternAssociationById[pattern] = fpa;
            this.filePatternAssociations.push(fpa);
        }
        return fpa;
    };
    JSONSchemaService.prototype.registerExternalSchema = function (uri, filePatterns, unresolvedSchemaContent) {
        var _this = this;
        if (filePatterns === void 0) { filePatterns = null; }
        var id = this.normalizeId(uri);
        if (filePatterns) {
            filePatterns.forEach(function (pattern) {
                _this.getOrAddFilePatternAssociation(pattern).addSchema(uri);
            });
        }
        return unresolvedSchemaContent ? this.addSchemaHandle(id, unresolvedSchemaContent) : this.getOrAddSchemaHandle(id);
    };
    JSONSchemaService.prototype.clearExternalSchemas = function () {
        var _this = this;
        this.schemasById = {};
        this.filePatternAssociations = [];
        this.filePatternAssociationById = {};
        for (var id in this.contributionSchemas) {
            this.schemasById[id] = this.contributionSchemas[id];
        }
        for (var pattern in this.contributionAssociations) {
            var fpa = this.getOrAddFilePatternAssociation(pattern);
            this.contributionAssociations[pattern].forEach(function (schemaId) {
                var id = _this.normalizeId(schemaId);
                fpa.addSchema(id);
            });
        }
    };
    JSONSchemaService.prototype.getResolvedSchema = function (schemaId) {
        var id = this.normalizeId(schemaId);
        var schemaHandle = this.schemasById[id];
        if (schemaHandle) {
            return schemaHandle.getResolvedSchema();
        }
        return Promise.resolve(null);
    };
    JSONSchemaService.prototype.loadSchema = function (url) {
        if (this.telemetryService && url.indexOf('//schema.management.azure.com/') !== -1) {
            this.telemetryService.log('json.schema', {
                schemaURL: url
            });
        }
        return this.requestService({ url: url, followRedirects: 5 }).then(function (request) {
            var content = request.responseText;
            if (!content) {
                var errorMessage = localize(0, null, toDisplayString(url));
                return new UnresolvedSchema({}, [errorMessage]);
            }
            var schemaContent = {};
            var jsonErrors = [];
            schemaContent = Json.parse(content, jsonErrors);
            var errors = jsonErrors.length ? [localize(1, null, toDisplayString(url), jsonErrors[0])] : [];
            return new UnresolvedSchema(schemaContent, errors);
        }, function (error) {
            var errorMessage = localize(2, null, toDisplayString(url), error.responseText || httpRequest_1.getErrorStatusDescription(error.status) || error.toString());
            return new UnresolvedSchema({}, [errorMessage]);
        });
    };
    JSONSchemaService.prototype.resolveSchemaContent = function (schemaToResolve) {
        var _this = this;
        var resolveErrors = schemaToResolve.errors.slice(0);
        var schema = schemaToResolve.schema;
        var findSection = function (schema, path) {
            if (!path) {
                return schema;
            }
            var current = schema;
            path.substr(1).split('/').some(function (part) {
                current = current[part];
                return !current;
            });
            return current;
        };
        var resolveLink = function (node, linkedSchema, linkPath) {
            var section = findSection(linkedSchema, linkPath);
            if (section) {
                for (var key in section) {
                    if (section.hasOwnProperty(key) && !node.hasOwnProperty(key)) {
                        node[key] = section[key];
                    }
                }
            }
            else {
                resolveErrors.push(localize(3, null, linkPath, linkedSchema.id));
            }
            delete node.$ref;
        };
        var resolveExternalLink = function (node, uri, linkPath) {
            return _this.getOrAddSchemaHandle(uri).getUnresolvedSchema().then(function (unresolvedSchema) {
                if (unresolvedSchema.errors.length) {
                    var loc = linkPath ? uri + '#' + linkPath : uri;
                    resolveErrors.push(localize(4, null, loc, unresolvedSchema.errors[0]));
                }
                resolveLink(node, unresolvedSchema.schema, linkPath);
                return resolveRefs(node, unresolvedSchema.schema);
            });
        };
        var resolveRefs = function (node, parentSchema) {
            var toWalk = [node];
            var seen = [];
            var openPromises = [];
            while (toWalk.length) {
                var next = toWalk.pop();
                if (seen.indexOf(next) >= 0) {
                    continue;
                }
                seen.push(next);
                if (Array.isArray(next)) {
                    next.forEach(function (item) {
                        toWalk.push(item);
                    });
                }
                else if (next) {
                    if (next.$ref) {
                        var segments = next.$ref.split('#', 2);
                        if (segments[0].length > 0) {
                            openPromises.push(resolveExternalLink(next, segments[0], segments[1]));
                            continue;
                        }
                        else {
                            resolveLink(next, parentSchema, segments[1]);
                        }
                    }
                    for (var key in next) {
                        toWalk.push(next[key]);
                    }
                }
            }
            return Promise.all(openPromises);
        };
        return resolveRefs(schema, schema).then(function (_) { return new ResolvedSchema(schema, resolveErrors); });
    };
    JSONSchemaService.prototype.getSchemaForResource = function (resource, document) {
        // first use $schema if present
        if (document && document.root && document.root.type === 'object') {
            var schemaProperties = document.root.properties.filter(function (p) { return (p.key.value === '$schema') && !!p.value; });
            if (schemaProperties.length > 0) {
                var schemeId = schemaProperties[0].value.getValue();
                if (!Strings.startsWith(schemeId, 'http://') && !Strings.startsWith(schemeId, 'https://') && !Strings.startsWith(schemeId, 'file://')) {
                    if (this.contextService) {
                        var resourceURL = this.contextService.toResource(schemeId);
                        if (resourceURL) {
                            schemeId = resourceURL.toString();
                        }
                    }
                }
                if (schemeId) {
                    var id = this.normalizeId(schemeId);
                    return this.getOrAddSchemaHandle(id).getResolvedSchema();
                }
            }
        }
        // then check for matching file names, last to first
        for (var i = this.filePatternAssociations.length - 1; i >= 0; i--) {
            var entry = this.filePatternAssociations[i];
            if (entry.matchesPattern(resource)) {
                return entry.getCombinedSchema(this).getResolvedSchema();
            }
        }
        return Promise.resolve(null);
    };
    JSONSchemaService.prototype.createCombinedSchema = function (combinedSchemaId, schemaIds) {
        if (schemaIds.length === 1) {
            return this.getOrAddSchemaHandle(schemaIds[0]);
        }
        else {
            var combinedSchema = {
                allOf: schemaIds.map(function (schemaId) { return ({ $ref: schemaId }); })
            };
            return this.addSchemaHandle(combinedSchemaId, combinedSchema);
        }
    };
    return JSONSchemaService;
}());
exports.JSONSchemaService = JSONSchemaService;
function toDisplayString(url) {
    try {
        var uri = uri_1.default.parse(url);
        if (uri.scheme === 'file') {
            return uri.fsPath;
        }
    }
    catch (e) {
    }
    return url;
}
//# sourceMappingURL=jsonSchemaService.js.map