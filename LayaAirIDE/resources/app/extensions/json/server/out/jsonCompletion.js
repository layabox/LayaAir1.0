/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
'use strict';
var vscode_languageserver_1 = require('vscode-languageserver');
var nls = require('vscode-nls');
var localize = nls.loadMessageBundle(__filename);
var JSONCompletion = (function () {
    function JSONCompletion(schemaService, console, contributions) {
        if (contributions === void 0) { contributions = []; }
        this.schemaService = schemaService;
        this.contributions = contributions;
        this.console = console;
    }
    JSONCompletion.prototype.doResolve = function (item) {
        for (var i = this.contributions.length - 1; i >= 0; i--) {
            if (this.contributions[i].resolveSuggestion) {
                var resolver = this.contributions[i].resolveSuggestion(item);
                if (resolver) {
                    return resolver;
                }
            }
        }
        return Promise.resolve(item);
    };
    JSONCompletion.prototype.doSuggest = function (document, textDocumentPosition, doc) {
        var _this = this;
        var offset = document.offsetAt(textDocumentPosition.position);
        var node = doc.getNodeFromOffsetEndInclusive(offset);
        var currentWord = this.getCurrentWord(document, offset);
        var overwriteRange = null;
        var result = {
            items: [],
            isIncomplete: false
        };
        if (node && (node.type === 'string' || node.type === 'number' || node.type === 'boolean' || node.type === 'null')) {
            overwriteRange = vscode_languageserver_1.Range.create(document.positionAt(node.start), document.positionAt(node.end));
        }
        else {
            overwriteRange = vscode_languageserver_1.Range.create(document.positionAt(offset - currentWord.length), textDocumentPosition.position);
        }
        var proposed = {};
        var collector = {
            add: function (suggestion) {
                if (!proposed[suggestion.label]) {
                    proposed[suggestion.label] = true;
                    if (overwriteRange) {
                        suggestion.textEdit = vscode_languageserver_1.TextEdit.replace(overwriteRange, suggestion.insertText);
                    }
                    result.items.push(suggestion);
                }
            },
            setAsIncomplete: function () {
                result.isIncomplete = true;
            },
            error: function (message) {
                _this.console.error(message);
            },
            log: function (message) {
                _this.console.log(message);
            }
        };
        return this.schemaService.getSchemaForResource(textDocumentPosition.uri, doc).then(function (schema) {
            var collectionPromises = [];
            var addValue = true;
            var currentKey = '';
            var currentProperty = null;
            if (node) {
                if (node.type === 'string') {
                    var stringNode = node;
                    if (stringNode.isKey) {
                        addValue = !(node.parent && (node.parent.value));
                        currentProperty = node.parent ? node.parent : null;
                        currentKey = document.getText().substring(node.start + 1, node.end - 1);
                        if (node.parent) {
                            node = node.parent.parent;
                        }
                    }
                }
            }
            // proposals for properties
            if (node && node.type === 'object') {
                // don't suggest keys when the cursor is just before the opening curly brace
                if (node.start === offset) {
                    return result;
                }
                // don't suggest properties that are already present
                var properties = node.properties;
                properties.forEach(function (p) {
                    if (!currentProperty || currentProperty !== p) {
                        proposed[p.key.value] = true;
                    }
                });
                var isLast_1 = properties.length === 0 || offset >= properties[properties.length - 1].start;
                if (schema) {
                    // property proposals with schema
                    _this.getPropertySuggestions(schema, doc, node, addValue, isLast_1, collector);
                }
                else {
                    // property proposals without schema
                    _this.getSchemaLessPropertySuggestions(doc, node, currentKey, currentWord, isLast_1, collector);
                }
                var location_1 = node.getNodeLocation();
                _this.contributions.forEach(function (contribution) {
                    var collectPromise = contribution.collectPropertySuggestions(textDocumentPosition.uri, location_1, currentWord, addValue, isLast_1, collector);
                    if (collectPromise) {
                        collectionPromises.push(collectPromise);
                    }
                });
            }
            // proposals for values
            if (node && (node.type === 'string' || node.type === 'number' || node.type === 'boolean' || node.type === 'null')) {
                node = node.parent;
            }
            if (schema) {
                // value proposals with schema
                _this.getValueSuggestions(schema, doc, node, offset, collector);
            }
            else {
                // value proposals without schema
                _this.getSchemaLessValueSuggestions(doc, node, offset, document, collector);
            }
            if (!node) {
                _this.contributions.forEach(function (contribution) {
                    var collectPromise = contribution.collectDefaultSuggestions(textDocumentPosition.uri, collector);
                    if (collectPromise) {
                        collectionPromises.push(collectPromise);
                    }
                });
            }
            else {
                if ((node.type === 'property') && offset > node.colonOffset) {
                    var parentKey_1 = node.key.value;
                    var valueNode = node.value;
                    if (!valueNode || offset <= valueNode.end) {
                        var location_2 = node.parent.getNodeLocation();
                        _this.contributions.forEach(function (contribution) {
                            var collectPromise = contribution.collectValueSuggestions(textDocumentPosition.uri, location_2, parentKey_1, collector);
                            if (collectPromise) {
                                collectionPromises.push(collectPromise);
                            }
                        });
                    }
                }
            }
            return Promise.all(collectionPromises).then(function () { return result; });
        });
    };
    JSONCompletion.prototype.getPropertySuggestions = function (schema, doc, node, addValue, isLast, collector) {
        var _this = this;
        var matchingSchemas = [];
        doc.validate(schema.schema, matchingSchemas, node.start);
        matchingSchemas.forEach(function (s) {
            if (s.node === node && !s.inverted) {
                var schemaProperties_1 = s.schema.properties;
                if (schemaProperties_1) {
                    Object.keys(schemaProperties_1).forEach(function (key) {
                        var propertySchema = schemaProperties_1[key];
                        collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: key, insertText: _this.getTextForProperty(key, propertySchema, addValue, isLast), documentation: propertySchema.description || '' });
                    });
                }
            }
        });
    };
    JSONCompletion.prototype.getSchemaLessPropertySuggestions = function (doc, node, currentKey, currentWord, isLast, collector) {
        var _this = this;
        var collectSuggestionsForSimilarObject = function (obj) {
            obj.properties.forEach(function (p) {
                var key = p.key.value;
                collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: key, insertText: _this.getTextForSimilarProperty(key, p.value), documentation: '' });
            });
        };
        if (node.parent) {
            if (node.parent.type === 'property') {
                // if the object is a property value, check the tree for other objects that hang under a property of the same name
                var parentKey_2 = node.parent.key.value;
                doc.visit(function (n) {
                    if (n.type === 'property' && n.key.value === parentKey_2 && n.value && n.value.type === 'object') {
                        collectSuggestionsForSimilarObject(n.value);
                    }
                    return true;
                });
            }
            else if (node.parent.type === 'array') {
                // if the object is in an array, use all other array elements as similar objects
                node.parent.items.forEach(function (n) {
                    if (n.type === 'object' && n !== node) {
                        collectSuggestionsForSimilarObject(n);
                    }
                });
            }
        }
        if (!currentKey && currentWord.length > 0) {
            collector.add({ kind: vscode_languageserver_1.CompletionItemKind.Property, label: this.getLabelForValue(currentWord), insertText: this.getTextForProperty(currentWord, null, true, isLast), documentation: '' });
        }
    };
    JSONCompletion.prototype.getSchemaLessValueSuggestions = function (doc, node, offset, document, collector) {
        var _this = this;
        var collectSuggestionsForValues = function (value) {
            if (!value.contains(offset)) {
                var content = _this.getTextForMatchingNode(value, document);
                collector.add({ kind: _this.getSuggestionKind(value.type), label: content, insertText: content, documentation: '' });
            }
            if (value.type === 'boolean') {
                _this.addBooleanSuggestion(!value.getValue(), collector);
            }
        };
        if (!node) {
            collector.add({ kind: this.getSuggestionKind('object'), label: 'Empty object', insertText: '{\n\t{{}}\n}', documentation: '' });
            collector.add({ kind: this.getSuggestionKind('array'), label: 'Empty array', insertText: '[\n\t{{}}\n]', documentation: '' });
        }
        else {
            if (node.type === 'property' && offset > node.colonOffset) {
                var valueNode = node.value;
                if (valueNode && offset > valueNode.end) {
                    return;
                }
                // suggest values at the same key
                var parentKey_3 = node.key.value;
                doc.visit(function (n) {
                    if (n.type === 'property' && n.key.value === parentKey_3 && n.value) {
                        collectSuggestionsForValues(n.value);
                    }
                    return true;
                });
            }
            if (node.type === 'array') {
                if (node.parent && node.parent.type === 'property') {
                    // suggest items of an array at the same key
                    var parentKey_4 = node.parent.key.value;
                    doc.visit(function (n) {
                        if (n.type === 'property' && n.key.value === parentKey_4 && n.value && n.value.type === 'array') {
                            (n.value.items).forEach(function (n) {
                                collectSuggestionsForValues(n);
                            });
                        }
                        return true;
                    });
                }
                else {
                    // suggest items in the same array
                    node.items.forEach(function (n) {
                        collectSuggestionsForValues(n);
                    });
                }
            }
        }
    };
    JSONCompletion.prototype.getValueSuggestions = function (schema, doc, node, offset, collector) {
        var _this = this;
        if (!node) {
            this.addDefaultSuggestion(schema.schema, collector);
        }
        else {
            var parentKey_5 = null;
            if (node && (node.type === 'property') && offset > node.colonOffset) {
                var valueNode = node.value;
                if (valueNode && offset > valueNode.end) {
                    return; // we are past the value node
                }
                parentKey_5 = node.key.value;
                node = node.parent;
            }
            if (node && (parentKey_5 !== null || node.type === 'array')) {
                var matchingSchemas = [];
                doc.validate(schema.schema, matchingSchemas, node.start);
                matchingSchemas.forEach(function (s) {
                    if (s.node === node && !s.inverted && s.schema) {
                        if (s.schema.items) {
                            _this.addDefaultSuggestion(s.schema.items, collector);
                            _this.addEnumSuggestion(s.schema.items, collector);
                        }
                        if (s.schema.properties) {
                            var propertySchema = s.schema.properties[parentKey_5];
                            if (propertySchema) {
                                _this.addDefaultSuggestion(propertySchema, collector);
                                _this.addEnumSuggestion(propertySchema, collector);
                            }
                        }
                    }
                });
            }
        }
    };
    JSONCompletion.prototype.addBooleanSuggestion = function (value, collector) {
        collector.add({ kind: this.getSuggestionKind('boolean'), label: value ? 'true' : 'false', insertText: this.getTextForValue(value), documentation: '' });
    };
    JSONCompletion.prototype.addNullSuggestion = function (collector) {
        collector.add({ kind: this.getSuggestionKind('null'), label: 'null', insertText: 'null', documentation: '' });
    };
    JSONCompletion.prototype.addEnumSuggestion = function (schema, collector) {
        var _this = this;
        if (Array.isArray(schema.enum)) {
            schema.enum.forEach(function (enm) { return collector.add({ kind: _this.getSuggestionKind(schema.type), label: _this.getLabelForValue(enm), insertText: _this.getTextForValue(enm), documentation: '' }); });
        }
        else {
            if (this.isType(schema, 'boolean')) {
                this.addBooleanSuggestion(true, collector);
                this.addBooleanSuggestion(false, collector);
            }
            if (this.isType(schema, 'null')) {
                this.addNullSuggestion(collector);
            }
        }
        if (Array.isArray(schema.allOf)) {
            schema.allOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
        if (Array.isArray(schema.anyOf)) {
            schema.anyOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
        if (Array.isArray(schema.oneOf)) {
            schema.oneOf.forEach(function (s) { return _this.addEnumSuggestion(s, collector); });
        }
    };
    JSONCompletion.prototype.isType = function (schema, type) {
        if (Array.isArray(schema.type)) {
            return schema.type.indexOf(type) !== -1;
        }
        return schema.type === type;
    };
    JSONCompletion.prototype.addDefaultSuggestion = function (schema, collector) {
        var _this = this;
        if (schema.default) {
            collector.add({
                kind: this.getSuggestionKind(schema.type),
                label: this.getLabelForValue(schema.default),
                insertText: this.getTextForValue(schema.default),
                detail: localize(0, null),
            });
        }
        if (Array.isArray(schema.defaultSnippets)) {
            schema.defaultSnippets.forEach(function (s) {
                collector.add({
                    kind: vscode_languageserver_1.CompletionItemKind.Snippet,
                    label: _this.getLabelForSnippetValue(s.body),
                    insertText: _this.getTextForSnippetValue(s.body)
                });
            });
        }
        if (Array.isArray(schema.allOf)) {
            schema.allOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
        if (Array.isArray(schema.anyOf)) {
            schema.anyOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
        if (Array.isArray(schema.oneOf)) {
            schema.oneOf.forEach(function (s) { return _this.addDefaultSuggestion(s, collector); });
        }
    };
    JSONCompletion.prototype.getLabelForValue = function (value) {
        var label = JSON.stringify(value);
        if (label.length > 57) {
            return label.substr(0, 57).trim() + '...';
        }
        return label;
    };
    JSONCompletion.prototype.getLabelForSnippetValue = function (value) {
        var label = JSON.stringify(value);
        label = label.replace(/\{\{|\}\}/g, '');
        if (label.length > 57) {
            return label.substr(0, 57).trim() + '...';
        }
        return label;
    };
    JSONCompletion.prototype.getTextForValue = function (value) {
        var text = JSON.stringify(value, null, '\t');
        text = text.replace(/[\\\{\}]/g, '\\$&');
        return text;
    };
    JSONCompletion.prototype.getTextForSnippetValue = function (value) {
        return JSON.stringify(value, null, '\t');
    };
    JSONCompletion.prototype.getTextForEnumValue = function (value) {
        var snippet = this.getTextForValue(value);
        switch (typeof value) {
            case 'object':
                if (value === null) {
                    return '{{null}}';
                }
                return snippet;
            case 'string':
                return '"{{' + snippet.substr(1, snippet.length - 2) + '}}"';
            case 'number':
            case 'boolean':
                return '{{' + snippet + '}}';
        }
        return snippet;
    };
    JSONCompletion.prototype.getSuggestionKind = function (type) {
        if (Array.isArray(type)) {
            var array = type;
            type = array.length > 0 ? array[0] : null;
        }
        if (!type) {
            return vscode_languageserver_1.CompletionItemKind.Text;
        }
        switch (type) {
            case 'string': return vscode_languageserver_1.CompletionItemKind.Text;
            case 'object': return vscode_languageserver_1.CompletionItemKind.Module;
            case 'property': return vscode_languageserver_1.CompletionItemKind.Property;
            default: return vscode_languageserver_1.CompletionItemKind.Value;
        }
    };
    JSONCompletion.prototype.getTextForMatchingNode = function (node, document) {
        switch (node.type) {
            case 'array':
                return '[]';
            case 'object':
                return '{}';
            default:
                var content = document.getText().substr(node.start, node.end - node.start);
                return content;
        }
    };
    JSONCompletion.prototype.getTextForProperty = function (key, propertySchema, addValue, isLast) {
        var result = this.getTextForValue(key);
        if (!addValue) {
            return result;
        }
        result += ': ';
        if (propertySchema) {
            var defaultVal = propertySchema.default;
            if (typeof defaultVal !== 'undefined') {
                result = result + this.getTextForEnumValue(defaultVal);
            }
            else if (propertySchema.enum && propertySchema.enum.length > 0) {
                result = result + this.getTextForEnumValue(propertySchema.enum[0]);
            }
            else {
                var type = Array.isArray(propertySchema.type) ? propertySchema.type[0] : propertySchema.type;
                switch (type) {
                    case 'boolean':
                        result += '{{false}}';
                        break;
                    case 'string':
                        result += '"{{}}"';
                        break;
                    case 'object':
                        result += '{\n\t{{}}\n}';
                        break;
                    case 'array':
                        result += '[\n\t{{}}\n]';
                        break;
                    case 'number':
                        result += '{{0}}';
                        break;
                    case 'null':
                        result += '{{null}}';
                        break;
                    default:
                        return result;
                }
            }
        }
        else {
            result += '{{0}}';
        }
        if (!isLast) {
            result += ',';
        }
        return result;
    };
    JSONCompletion.prototype.getTextForSimilarProperty = function (key, templateValue) {
        return this.getTextForValue(key);
    };
    JSONCompletion.prototype.getCurrentWord = function (document, offset) {
        var i = offset - 1;
        var text = document.getText();
        while (i >= 0 && ' \t\n\r\v":{[,'.indexOf(text.charAt(i)) === -1) {
            i--;
        }
        return text.substring(i + 1, offset);
    };
    return JSONCompletion;
}());
exports.JSONCompletion = JSONCompletion;
//# sourceMappingURL=jsonCompletion.js.map