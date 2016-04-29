/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
// declare var require;
var $map = {};
function $load(name, factory) {
    var mod = {
        exports: {}
    };
    factory.call(this, function (mod) {
        if ($map[mod]) {
            return $map[mod].exports;
        }
        return require(mod);
    }, mod, mod.exports);
    $map[name] = mod;
}

$load('./utils', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
function clone(something) {
    return doClone(something);
}
exports.clone = clone;
function doClone(something) {
    if (Array.isArray(something)) {
        return cloneArray(something);
    }
    if (typeof something === 'object') {
        return cloneObj(something);
    }
    return something;
}
function cloneArray(arr) {
    var r = [];
    for (var i = 0, len = arr.length; i < len; i++) {
        r[i] = doClone(arr[i]);
    }
    return r;
}
function cloneObj(obj) {
    var r = {};
    for (var key in obj) {
        r[key] = doClone(obj[key]);
    }
    return r;
}
function mergeObjects(target) {
    var sources = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        sources[_i - 1] = arguments[_i];
    }
    sources.forEach(function (source) {
        for (var key in source) {
            target[key] = source[key];
        }
    });
    return target;
}
exports.mergeObjects = mergeObjects;
var CAPTURING_REGEX_SOURCE = /\$(\d+)|\${(\d+):\/(downcase|upcase)}/;
var RegexSource = (function () {
    function RegexSource() {
    }
    RegexSource.hasCaptures = function (regexSource) {
        return CAPTURING_REGEX_SOURCE.test(regexSource);
    };
    RegexSource.replaceCaptures = function (regexSource, captureSource, captureIndices) {
        return regexSource.replace(CAPTURING_REGEX_SOURCE, function (match, index, commandIndex, command) {
            var capture = captureIndices[parseInt(index || commandIndex, 10)];
            if (capture) {
                var result = captureSource.substring(capture.start, capture.end);
                // Remove leading dots that would make the selector invalid
                while (result[0] === '.') {
                    result = result.substring(1);
                }
                switch (command) {
                    case 'downcase':
                        return result.toLowerCase();
                    case 'upcase':
                        return result.toUpperCase();
                    default:
                        return result;
                }
            }
            else {
                return match;
            }
        });
    };
    return RegexSource;
})();
exports.RegexSource = RegexSource;

});
$load('./matcher', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
function createMatcher(expression, matchesName) {
    var tokenizer = newTokenizer(expression);
    var token = tokenizer.next();
    function parseOperand() {
        if (token === '-') {
            token = tokenizer.next();
            var expressionToNegate = parseOperand();
            return function (matcherInput) { return expressionToNegate && !expressionToNegate(matcherInput); };
        }
        if (token === '(') {
            token = tokenizer.next();
            var expressionInParents = parseExpression('|');
            if (token == ')') {
                token = tokenizer.next();
            }
            return expressionInParents;
        }
        if (isIdentifier(token)) {
            var identifiers = [];
            do {
                identifiers.push(token);
                token = tokenizer.next();
            } while (isIdentifier(token));
            return function (matcherInput) { return matchesName(identifiers, matcherInput); };
        }
        return null;
    }
    function parseConjunction() {
        var matchers = [];
        var matcher = parseOperand();
        while (matcher) {
            matchers.push(matcher);
            matcher = parseOperand();
        }
        return function (matcherInput) { return matchers.every(function (matcher) { return matcher(matcherInput); }); }; // and
    }
    function parseExpression(orOperatorToken) {
        if (orOperatorToken === void 0) { orOperatorToken = ','; }
        var matchers = [];
        var matcher = parseConjunction();
        while (matcher) {
            matchers.push(matcher);
            if (token === orOperatorToken) {
                do {
                    token = tokenizer.next();
                } while (token === orOperatorToken); // ignore subsequent commas
            }
            else {
                break;
            }
            matcher = parseConjunction();
        }
        return function (matcherInput) { return matchers.some(function (matcher) { return matcher(matcherInput); }); }; // or
    }
    return parseExpression() || (function (matcherInput) { return false; });
}
exports.createMatcher = createMatcher;
function isIdentifier(token) {
    return token && token.match(/[\w\.:]+/);
}
function newTokenizer(input) {
    var regex = /([\w\.:]+|[\,\|\-\(\)])/g;
    var match = regex.exec(input);
    return {
        next: function () {
            if (!match) {
                return null;
            }
            var res = match[0];
            match = regex.exec(input);
            return res;
        }
    };
}

});
$load('./plistParser', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var createParser = (function () {
    var saxModule = null;
    return function parser(strict, opt) {
        if (!saxModule) {
            saxModule = require('sax');
        }
        return saxModule.parser(strict, opt);
    };
})();
function parse(content) {
    var errors = [];
    var currObject = null;
    var result = null;
    var text = null;
    var parser = createParser(false, { lowercase: true });
    parser.onerror = function (e) {
        errors.push(e.message);
    };
    parser.ontext = function (s) {
        text = s;
    };
    parser.onopentag = function (tag) {
        switch (tag.name) {
            case 'dict':
                currObject = { parent: currObject, value: {} };
                break;
            case 'array':
                currObject = { parent: currObject, value: [] };
                break;
            case 'key':
                if (currObject) {
                    currObject.lastKey = null;
                }
                break;
        }
        text = '';
    };
    parser.onclosetag = function (tagName) {
        var value;
        switch (tagName) {
            case 'key':
                if (!currObject || Array.isArray(currObject.value)) {
                    errors.push('key can only be used inside an open dict element');
                    return;
                }
                currObject.lastKey = text;
                return;
            case 'dict':
            case 'array':
                if (!currObject) {
                    errors.push(tagName + ' closing tag found, without opening tag');
                    return;
                }
                value = currObject.value;
                currObject = currObject.parent;
                break;
            case 'string':
            case 'data':
                value = text;
                break;
            case 'date':
                value = new Date(text);
                break;
            case 'integer':
                value = parseInt(text);
                if (isNaN(value)) {
                    errors.push(text + ' is not a integer');
                    return;
                }
                break;
            case 'real':
                value = parseFloat(text);
                if (isNaN(value)) {
                    errors.push(text + ' is not a float');
                    return;
                }
                break;
            case 'true':
                value = true;
                break;
            case 'false':
                value = false;
                break;
            case 'plist':
                return;
            default:
                errors.push('Invalid tag name: ' + tagName);
                return;
        }
        if (!currObject) {
            result = value;
        }
        else if (Array.isArray(currObject.value)) {
            currObject.value.push(value);
        }
        else {
            if (currObject.lastKey) {
                currObject.value[currObject.lastKey] = value;
            }
            else {
                errors.push('Dictionary key missing for value ' + value);
            }
        }
    };
    parser.write(content);
    return { errors: errors, value: result };
}
exports.parse = parse;

});
$load('./grammarReader', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var fs = require('fs');
var plistParser_1 = require('./plistParser');
function readGrammar(filePath, callback) {
    var reader = new AsyncGrammarReader(filePath, getGrammarParser(filePath));
    reader.load(callback);
}
exports.readGrammar = readGrammar;
function readGrammarSync(filePath) {
    var reader = new SyncGrammarReader(filePath, getGrammarParser(filePath));
    return reader.load();
}
exports.readGrammarSync = readGrammarSync;
var AsyncGrammarReader = (function () {
    function AsyncGrammarReader(filePath, parser) {
        this._filePath = filePath;
        this._parser = parser;
    }
    AsyncGrammarReader.prototype.load = function (callback) {
        var _this = this;
        fs.readFile(this._filePath, function (err, contents) {
            if (err) {
                callback(err, null);
                return;
            }
            var r;
            try {
                r = _this._parser(contents.toString());
            }
            catch (err) {
                callback(err, null);
                return;
            }
            callback(null, r);
        });
    };
    return AsyncGrammarReader;
})();
var SyncGrammarReader = (function () {
    function SyncGrammarReader(filePath, parser) {
        this._filePath = filePath;
        this._parser = parser;
    }
    SyncGrammarReader.prototype.load = function () {
        var contents = fs.readFileSync(this._filePath);
        return this._parser(contents.toString());
    };
    return SyncGrammarReader;
})();
function getGrammarParser(filePath) {
    if (/\.json$/.test(filePath)) {
        return parseJSONGrammar;
    }
    return parsePLISTGrammar;
}
function parseJSONGrammar(contents) {
    return JSON.parse(contents.toString());
}
function parsePLISTGrammar(contents) {
    var tmp;
    tmp = plistParser_1.parse(contents);
    if (tmp.errors && tmp.errors.length > 0) {
        throw new Error('Error parsing PLIST: ' + tmp.errors.join(','));
    }
    return tmp.value;
}

});
$load('./rule', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var utils_1 = require('./utils');
var HAS_BACK_REFERENCES = /\\(\d+)/;
var BACK_REFERENCING_END = /\\(\d+)/g;
var Rule = (function () {
    function Rule(id, name, contentName) {
        this.id = id;
        this._name = name || null;
        this._nameIsCapturing = utils_1.RegexSource.hasCaptures(this._name);
        this._contentName = contentName || null;
        this._contentNameIsCapturing = utils_1.RegexSource.hasCaptures(this._contentName);
    }
    Rule.prototype.getName = function (lineText, captureIndices) {
        if (!this._nameIsCapturing) {
            return this._name;
        }
        return utils_1.RegexSource.replaceCaptures(this._name, lineText, captureIndices);
    };
    Rule.prototype.getContentName = function (lineText, captureIndices) {
        if (!this._contentNameIsCapturing) {
            return this._contentName;
        }
        return utils_1.RegexSource.replaceCaptures(this._contentName, lineText, captureIndices);
    };
    Rule.prototype.collectPatternsRecursive = function (grammar, out, isFirst) {
        throw new Error('Implement me!');
    };
    Rule.prototype.compile = function (grammar, endRegexSource, allowA, allowG) {
        throw new Error('Implement me!');
    };
    return Rule;
})();
exports.Rule = Rule;
var CaptureRule = (function (_super) {
    __extends(CaptureRule, _super);
    function CaptureRule(id, name, contentName, retokenizeCapturedWithRuleId) {
        _super.call(this, id, name, contentName);
        this.retokenizeCapturedWithRuleId = retokenizeCapturedWithRuleId;
    }
    return CaptureRule;
})(Rule);
exports.CaptureRule = CaptureRule;
var RegExpSource = (function () {
    function RegExpSource(regExpSource, ruleId, handleAnchors) {
        if (handleAnchors === void 0) { handleAnchors = true; }
        if (handleAnchors) {
            this._handleAnchors(regExpSource);
        }
        else {
            this.source = regExpSource;
            this.hasAnchor = false;
        }
        if (this.hasAnchor) {
            this._anchorCache = this._buildAnchorCache();
        }
        this.ruleId = ruleId;
        this.hasBackReferences = HAS_BACK_REFERENCES.test(this.source);
        // console.log('input: ' + regExpSource + ' => ' + this.source + ', ' + this.hasAnchor);
    }
    RegExpSource.prototype.clone = function () {
        return new RegExpSource(this.source, this.ruleId, true);
    };
    RegExpSource.prototype.setSource = function (newSource) {
        if (this.source === newSource) {
            return;
        }
        this.source = newSource;
        if (this.hasAnchor) {
            this._anchorCache = this._buildAnchorCache();
        }
    };
    RegExpSource.prototype._handleAnchors = function (regExpSource) {
        if (regExpSource) {
            var pos, len, ch, nextCh, lastPushedPos = 0, output = [];
            var hasAnchor = false;
            for (pos = 0, len = regExpSource.length; pos < len; pos++) {
                ch = regExpSource.charAt(pos);
                if (ch === '\\') {
                    if (pos + 1 < len) {
                        nextCh = regExpSource.charAt(pos + 1);
                        if (nextCh === 'z') {
                            output.push(regExpSource.substring(lastPushedPos, pos));
                            output.push('$(?!\\n)(?<!\\n)');
                            lastPushedPos = pos + 2;
                        }
                        else if (nextCh === 'A' || nextCh === 'G') {
                            hasAnchor = true;
                        }
                        pos++;
                    }
                }
            }
            this.hasAnchor = hasAnchor;
            if (lastPushedPos === 0) {
                // No \z hit
                this.source = regExpSource;
            }
            else {
                output.push(regExpSource.substring(lastPushedPos, len));
                this.source = output.join('');
            }
        }
        else {
            this.hasAnchor = false;
            this.source = regExpSource;
        }
    };
    RegExpSource.prototype.resolveBackReferences = function (lineText, captureIndices) {
        var capturedValues = captureIndices.map(function (capture) {
            return lineText.substring(capture.start, capture.end);
        });
        BACK_REFERENCING_END.lastIndex = 0;
        return this.source.replace(BACK_REFERENCING_END, function (match, g1) {
            return escapeRegExpCharacters(capturedValues[parseInt(g1, 10)] || '');
        });
    };
    RegExpSource.prototype._buildAnchorCache = function () {
        var A0_G0_result = [];
        var A0_G1_result = [];
        var A1_G0_result = [];
        var A1_G1_result = [];
        var pos, len, ch, nextCh;
        for (pos = 0, len = this.source.length; pos < len; pos++) {
            ch = this.source.charAt(pos);
            A0_G0_result[pos] = ch;
            A0_G1_result[pos] = ch;
            A1_G0_result[pos] = ch;
            A1_G1_result[pos] = ch;
            if (ch === '\\') {
                if (pos + 1 < len) {
                    nextCh = this.source.charAt(pos + 1);
                    if (nextCh === 'A') {
                        A0_G0_result[pos + 1] = '\uFFFF';
                        A0_G1_result[pos + 1] = '\uFFFF';
                        A1_G0_result[pos + 1] = 'A';
                        A1_G1_result[pos + 1] = 'A';
                    }
                    else if (nextCh === 'G') {
                        A0_G0_result[pos + 1] = '\uFFFF';
                        A0_G1_result[pos + 1] = 'G';
                        A1_G0_result[pos + 1] = '\uFFFF';
                        A1_G1_result[pos + 1] = 'G';
                    }
                    else {
                        A0_G0_result[pos + 1] = nextCh;
                        A0_G1_result[pos + 1] = nextCh;
                        A1_G0_result[pos + 1] = nextCh;
                        A1_G1_result[pos + 1] = nextCh;
                    }
                    pos++;
                }
            }
        }
        return {
            A0_G0: A0_G0_result.join(''),
            A0_G1: A0_G1_result.join(''),
            A1_G0: A1_G0_result.join(''),
            A1_G1: A1_G1_result.join('')
        };
    };
    RegExpSource.prototype.resolveAnchors = function (allowA, allowG) {
        if (!this.hasAnchor) {
            return this.source;
        }
        if (allowA) {
            if (allowG) {
                return this._anchorCache.A1_G1;
            }
            else {
                return this._anchorCache.A1_G0;
            }
        }
        else {
            if (allowG) {
                return this._anchorCache.A0_G1;
            }
            else {
                return this._anchorCache.A0_G0;
            }
        }
    };
    return RegExpSource;
})();
exports.RegExpSource = RegExpSource;
var getOnigModule = (function () {
    var onigurumaModule = null;
    return function () {
        if (!onigurumaModule) {
            onigurumaModule = require('oniguruma');
        }
        return onigurumaModule;
    };
})();
function createOnigScanner(sources) {
    var onigurumaModule = getOnigModule();
    return new onigurumaModule.OnigScanner(sources);
}
function createOnigString(sources) {
    var onigurumaModule = getOnigModule();
    var r = new onigurumaModule.OnigString(sources);
    r.$str = sources;
    return r;
}
exports.createOnigString = createOnigString;
function getString(str) {
    return str.$str;
}
exports.getString = getString;
var RegExpSourceList = (function () {
    function RegExpSourceList() {
        this._items = [];
        this._hasAnchors = false;
        this._cached = null;
        this._cachedSources = null;
        this._anchorCache = {
            A0_G0: null,
            A0_G1: null,
            A1_G0: null,
            A1_G1: null
        };
    }
    RegExpSourceList.prototype.push = function (item) {
        this._items.push(item);
        this._hasAnchors = this._hasAnchors || item.hasAnchor;
    };
    RegExpSourceList.prototype.unshift = function (item) {
        this._items.unshift(item);
        this._hasAnchors = this._hasAnchors || item.hasAnchor;
    };
    RegExpSourceList.prototype.length = function () {
        return this._items.length;
    };
    RegExpSourceList.prototype.setSource = function (index, newSource) {
        if (this._items[index].source !== newSource) {
            // bust the cache
            this._cached = null;
            this._anchorCache.A0_G0 = null;
            this._anchorCache.A0_G1 = null;
            this._anchorCache.A1_G0 = null;
            this._anchorCache.A1_G1 = null;
            this._items[index].setSource(newSource);
        }
    };
    RegExpSourceList.prototype.compile = function (grammar, allowA, allowG) {
        if (!this._hasAnchors) {
            if (!this._cached) {
                this._cached = {
                    scanner: createOnigScanner(this._items.map(function (e) { return e.source; })),
                    rules: this._items.map(function (e) { return e.ruleId; })
                };
            }
            return this._cached;
        }
        else {
            this._anchorCache = {
                A0_G0: this._anchorCache.A0_G0 || (allowA === false && allowG === false ? this._resolveAnchors(allowA, allowG) : null),
                A0_G1: this._anchorCache.A0_G1 || (allowA === false && allowG === true ? this._resolveAnchors(allowA, allowG) : null),
                A1_G0: this._anchorCache.A1_G0 || (allowA === true && allowG === false ? this._resolveAnchors(allowA, allowG) : null),
                A1_G1: this._anchorCache.A1_G1 || (allowA === true && allowG === true ? this._resolveAnchors(allowA, allowG) : null),
            };
            if (allowA) {
                if (allowG) {
                    return this._anchorCache.A1_G1;
                }
                else {
                    return this._anchorCache.A1_G0;
                }
            }
            else {
                if (allowG) {
                    return this._anchorCache.A0_G1;
                }
                else {
                    return this._anchorCache.A0_G0;
                }
            }
        }
    };
    RegExpSourceList.prototype._resolveAnchors = function (allowA, allowG) {
        return {
            scanner: createOnigScanner(this._items.map(function (e) { return e.resolveAnchors(allowA, allowG); })),
            rules: this._items.map(function (e) { return e.ruleId; })
        };
    };
    return RegExpSourceList;
})();
exports.RegExpSourceList = RegExpSourceList;
var MatchRule = (function (_super) {
    __extends(MatchRule, _super);
    function MatchRule(id, name, match, captures) {
        _super.call(this, id, name, null);
        this._match = new RegExpSource(match, this.id);
        this.captures = captures;
        this._cachedCompiledPatterns = null;
    }
    MatchRule.prototype.collectPatternsRecursive = function (grammar, out, isFirst) {
        out.push(this._match);
    };
    MatchRule.prototype.compile = function (grammar, endRegexSource, allowA, allowG) {
        if (!this._cachedCompiledPatterns) {
            this._cachedCompiledPatterns = new RegExpSourceList();
            this.collectPatternsRecursive(grammar, this._cachedCompiledPatterns, true);
        }
        return this._cachedCompiledPatterns.compile(grammar, allowA, allowG);
    };
    return MatchRule;
})(Rule);
exports.MatchRule = MatchRule;
var IncludeOnlyRule = (function (_super) {
    __extends(IncludeOnlyRule, _super);
    function IncludeOnlyRule(id, name, contentName, patterns) {
        _super.call(this, id, name, contentName);
        this.patterns = patterns.patterns;
        this.hasMissingPatterns = patterns.hasMissingPatterns;
        this._cachedCompiledPatterns = null;
    }
    IncludeOnlyRule.prototype.collectPatternsRecursive = function (grammar, out, isFirst) {
        var i, len, rule;
        for (i = 0, len = this.patterns.length; i < len; i++) {
            rule = grammar.getRule(this.patterns[i]);
            rule.collectPatternsRecursive(grammar, out, false);
        }
    };
    IncludeOnlyRule.prototype.compile = function (grammar, endRegexSource, allowA, allowG) {
        if (!this._cachedCompiledPatterns) {
            this._cachedCompiledPatterns = new RegExpSourceList();
            this.collectPatternsRecursive(grammar, this._cachedCompiledPatterns, true);
        }
        return this._cachedCompiledPatterns.compile(grammar, allowA, allowG);
    };
    return IncludeOnlyRule;
})(Rule);
exports.IncludeOnlyRule = IncludeOnlyRule;
function escapeRegExpCharacters(value) {
    return value.replace(/[\-\\\{\}\*\+\?\|\^\$\.\,\[\]\(\)\#\s]/g, '\\$&');
}
var BeginEndRule = (function (_super) {
    __extends(BeginEndRule, _super);
    function BeginEndRule(id, name, contentName, begin, beginCaptures, end, endCaptures, applyEndPatternLast, patterns) {
        _super.call(this, id, name, contentName);
        this._begin = new RegExpSource(begin, this.id);
        this.beginCaptures = beginCaptures;
        this._end = new RegExpSource(end, -1);
        this.endHasBackReferences = this._end.hasBackReferences;
        this.endCaptures = endCaptures;
        this.applyEndPatternLast = applyEndPatternLast || false;
        this.patterns = patterns.patterns;
        this.hasMissingPatterns = patterns.hasMissingPatterns;
        this._cachedCompiledPatterns = null;
    }
    BeginEndRule.prototype.getEndWithResolvedBackReferences = function (lineText, captureIndices) {
        return this._end.resolveBackReferences(lineText, captureIndices);
    };
    BeginEndRule.prototype.collectPatternsRecursive = function (grammar, out, isFirst) {
        if (isFirst) {
            var i, len, rule;
            for (i = 0, len = this.patterns.length; i < len; i++) {
                rule = grammar.getRule(this.patterns[i]);
                rule.collectPatternsRecursive(grammar, out, false);
            }
        }
        else {
            out.push(this._begin);
        }
    };
    BeginEndRule.prototype.compile = function (grammar, endRegexSource, allowA, allowG) {
        var precompiled = this._precompile(grammar);
        if (this._end.hasBackReferences) {
            if (this.applyEndPatternLast) {
                precompiled.setSource(precompiled.length() - 1, endRegexSource);
            }
            else {
                precompiled.setSource(0, endRegexSource);
            }
        }
        return this._cachedCompiledPatterns.compile(grammar, allowA, allowG);
    };
    BeginEndRule.prototype._precompile = function (grammar) {
        if (!this._cachedCompiledPatterns) {
            this._cachedCompiledPatterns = new RegExpSourceList();
            this.collectPatternsRecursive(grammar, this._cachedCompiledPatterns, true);
            if (this.applyEndPatternLast) {
                this._cachedCompiledPatterns.push(this._end.hasBackReferences ? this._end.clone() : this._end);
            }
            else {
                this._cachedCompiledPatterns.unshift(this._end.hasBackReferences ? this._end.clone() : this._end);
            }
        }
        return this._cachedCompiledPatterns;
    };
    return BeginEndRule;
})(Rule);
exports.BeginEndRule = BeginEndRule;
var RuleFactory = (function () {
    function RuleFactory() {
    }
    RuleFactory.createCaptureRule = function (helper, name, contentName, retokenizeCapturedWithRuleId) {
        return helper.registerRule(function (id) {
            return new CaptureRule(id, name, contentName, retokenizeCapturedWithRuleId);
        });
    };
    RuleFactory.getCompiledRuleId = function (desc, helper, repository) {
        if (!desc.id) {
            helper.registerRule(function (id) {
                desc.id = id;
                if (desc.match) {
                    return new MatchRule(desc.id, desc.name, desc.match, RuleFactory._compileCaptures(desc.captures, helper, repository));
                }
                if (!desc.begin) {
                    if (desc.repository) {
                        repository = utils_1.mergeObjects({}, repository, desc.repository);
                    }
                    return new IncludeOnlyRule(desc.id, desc.name, desc.contentName, RuleFactory._compilePatterns(desc.patterns, helper, repository));
                }
                return new BeginEndRule(desc.id, desc.name, desc.contentName, desc.begin, RuleFactory._compileCaptures(desc.beginCaptures || desc.captures, helper, repository), desc.end, RuleFactory._compileCaptures(desc.endCaptures || desc.captures, helper, repository), desc.applyEndPatternLast, RuleFactory._compilePatterns(desc.patterns, helper, repository));
            });
        }
        return desc.id;
    };
    RuleFactory._compileCaptures = function (captures, helper, repository) {
        var r = [], numericCaptureId, maximumCaptureId, i, captureId;
        if (captures) {
            // Find the maximum capture id
            maximumCaptureId = 0;
            for (captureId in captures) {
                numericCaptureId = parseInt(captureId, 10);
                if (numericCaptureId > maximumCaptureId) {
                    maximumCaptureId = numericCaptureId;
                }
            }
            // Initialize result
            for (i = 0; i <= maximumCaptureId; i++) {
                r[i] = null;
            }
            // Fill out result
            for (captureId in captures) {
                numericCaptureId = parseInt(captureId, 10);
                var retokenizeCapturedWithRuleId = 0;
                if (captures[captureId].patterns) {
                    retokenizeCapturedWithRuleId = RuleFactory.getCompiledRuleId(captures[captureId], helper, repository);
                }
                r[numericCaptureId] = RuleFactory.createCaptureRule(helper, captures[captureId].name, captures[captureId].contentName, retokenizeCapturedWithRuleId);
            }
        }
        return r;
    };
    RuleFactory._compilePatterns = function (patterns, helper, repository) {
        var r = [], pattern, i, len, patternId, externalGrammar, rule, skipRule;
        if (patterns) {
            for (i = 0, len = patterns.length; i < len; i++) {
                pattern = patterns[i];
                patternId = -1;
                if (pattern.include) {
                    if (pattern.include.charAt(0) === '#') {
                        // Local include found in `repository`
                        var localIncludedRule = repository[pattern.include.substr(1)];
                        if (localIncludedRule) {
                            patternId = RuleFactory.getCompiledRuleId(localIncludedRule, helper, repository);
                        }
                        else {
                        }
                    }
                    else if (pattern.include === '$base' || pattern.include === '$self') {
                        // Special include also found in `repository`
                        patternId = RuleFactory.getCompiledRuleId(repository[pattern.include], helper, repository);
                    }
                    else {
                        var externalGrammarName = null, externalGrammarInclude = null, sharpIndex = pattern.include.indexOf('#');
                        if (sharpIndex >= 0) {
                            externalGrammarName = pattern.include.substring(0, sharpIndex);
                            externalGrammarInclude = pattern.include.substring(sharpIndex + 1);
                        }
                        else {
                            externalGrammarName = pattern.include;
                        }
                        // External include
                        externalGrammar = helper.getExternalGrammar(externalGrammarName, repository);
                        if (externalGrammar) {
                            if (externalGrammarInclude) {
                                var externalIncludedRule = externalGrammar.repository[externalGrammarInclude];
                                if (externalIncludedRule) {
                                    patternId = RuleFactory.getCompiledRuleId(externalIncludedRule, helper, externalGrammar.repository);
                                }
                                else {
                                }
                            }
                            else {
                                patternId = RuleFactory.getCompiledRuleId(externalGrammar.repository.$self, helper, externalGrammar.repository);
                            }
                        }
                        else {
                        }
                    }
                }
                else {
                    patternId = RuleFactory.getCompiledRuleId(pattern, helper, repository);
                }
                if (patternId !== -1) {
                    rule = helper.getRule(patternId);
                    skipRule = false;
                    if (rule instanceof IncludeOnlyRule) {
                        if (rule.hasMissingPatterns && rule.patterns.length === 0) {
                            skipRule = true;
                        }
                    }
                    else if (rule instanceof BeginEndRule) {
                        if (rule.hasMissingPatterns && rule.patterns.length === 0) {
                            skipRule = true;
                        }
                    }
                    if (skipRule) {
                        // console.log('REMOVING RULE ENTIRELY DUE TO EMPTY PATTERNS THAT ARE MISSING');
                        continue;
                    }
                    r.push(patternId);
                }
            }
        }
        return {
            patterns: r,
            hasMissingPatterns: ((patterns ? patterns.length : 0) !== r.length)
        };
    };
    return RuleFactory;
})();
exports.RuleFactory = RuleFactory;

});
$load('./grammar', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var utils_1 = require('./utils');
var rule_1 = require('./rule');
var matcher_1 = require('./matcher');
function createGrammar(grammar, grammarRepository) {
    return new Grammar(grammar, grammarRepository);
}
exports.createGrammar = createGrammar;
/**
 * Fill in `result` all external included scopes in `patterns`
 */
function _extractIncludedScopesInPatterns(result, patterns) {
    for (var i = 0, len = patterns.length; i < len; i++) {
        if (Array.isArray(patterns[i].patterns)) {
            _extractIncludedScopesInPatterns(result, patterns[i].patterns);
        }
        var include = patterns[i].include;
        if (!include) {
            continue;
        }
        if (include === '$base' || include === '$self') {
            // Special includes that can be resolved locally in this grammar
            continue;
        }
        if (include.charAt(0) === '#') {
            // Local include from this grammar
            continue;
        }
        var sharpIndex = include.indexOf('#');
        if (sharpIndex >= 0) {
            result[include.substring(0, sharpIndex)] = true;
        }
        else {
            result[include] = true;
        }
    }
}
/**
 * Fill in `result` all external included scopes in `repository`
 */
function _extractIncludedScopesInRepository(result, repository) {
    for (var name_1 in repository) {
        var rule = repository[name_1];
        if (rule.patterns && Array.isArray(rule.patterns)) {
            _extractIncludedScopesInPatterns(result, rule.patterns);
        }
        if (rule.repository) {
            _extractIncludedScopesInRepository(result, rule.repository);
        }
    }
}
/**
 * Return a list of all external included scopes in `grammar`.
 */
function extractIncludedScopes(grammar) {
    var result = {};
    if (grammar.patterns && Array.isArray(grammar.patterns)) {
        _extractIncludedScopesInPatterns(result, grammar.patterns);
    }
    if (grammar.repository) {
        _extractIncludedScopesInRepository(result, grammar.repository);
    }
    // remove references to own scope (avoid recursion)
    delete result[grammar.scopeName];
    return Object.keys(result);
}
exports.extractIncludedScopes = extractIncludedScopes;
function getGrammarInjections(grammar, ruleFactoryHelper) {
    var injections = [];
    var rawInjections = grammar.injections;
    if (rawInjections) {
        var nameMatcher = function (identifers, stackElements) {
            var lastIndex = 0;
            return identifers.every(function (identifier) {
                for (var i = lastIndex; i < stackElements.length; i++) {
                    if (stackElements[i].matches(identifier)) {
                        lastIndex = i;
                        return true;
                    }
                }
                return false;
            });
        };
        for (var expression in rawInjections) {
            var subExpressions = expression.split(',');
            subExpressions.forEach(function (subExpression) {
                var expressionString = subExpression.replace(/L:/g, '');
                injections.push({
                    matcher: matcher_1.createMatcher(expressionString, nameMatcher),
                    ruleId: rule_1.RuleFactory.getCompiledRuleId(rawInjections[expression], ruleFactoryHelper, grammar.repository),
                    grammar: grammar,
                    priorityMatch: expressionString.length < subExpression.length
                });
            });
        }
    }
    return injections;
}
var Grammar = (function () {
    function Grammar(grammar, grammarRepository) {
        this._rootId = -1;
        this._lastRuleId = 0;
        this._ruleId2desc = [];
        this._includedGrammars = {};
        this._grammarRepository = grammarRepository;
        this._grammar = initGrammar(grammar, null);
    }
    Grammar.prototype.getInjections = function (states) {
        if (!this._injections) {
            this._injections = getGrammarInjections(this._grammar, this);
        }
        if (this._injections.length === 0) {
            return this._injections;
        }
        return this._injections.filter(function (injection) { return injection.matcher(states); });
    };
    Grammar.prototype.registerRule = function (factory) {
        var id = (++this._lastRuleId);
        var result = factory(id);
        this._ruleId2desc[id] = result;
        return result;
    };
    Grammar.prototype.getRule = function (patternId) {
        return this._ruleId2desc[patternId];
    };
    Grammar.prototype.getExternalGrammar = function (scopeName, repository) {
        var actualGrammar = null;
        if (this._includedGrammars[scopeName]) {
            return this._includedGrammars[scopeName];
        }
        else if (this._grammarRepository) {
            var rawIncludedGrammar = this._grammarRepository.lookup(scopeName);
            if (rawIncludedGrammar) {
                // console.log('LOADED GRAMMAR ' + pattern.include);
                this._includedGrammars[scopeName] = initGrammar(rawIncludedGrammar, repository.$base);
                return this._includedGrammars[scopeName];
            }
        }
    };
    Grammar.prototype.tokenizeLine = function (lineText, prevState) {
        if (this._rootId === -1) {
            this._rootId = rule_1.RuleFactory.getCompiledRuleId(this._grammar.repository.$self, this, this._grammar.repository);
        }
        var isFirstLine;
        if (!prevState) {
            isFirstLine = true;
            prevState = [new StackElement(this._rootId, -1, null, this.getRule(this._rootId).getName(null, null), null)];
        }
        else {
            isFirstLine = false;
            for (var i = 0; i < prevState.length; i++) {
                prevState[i].enterPos = -1;
            }
        }
        lineText = lineText + '\n';
        var onigLineText = rule_1.createOnigString(lineText);
        var lineLength = rule_1.getString(onigLineText).length;
        var lineTokens = new LineTokens();
        _tokenizeString(this, onigLineText, isFirstLine, 0, prevState, lineTokens);
        var _produced = lineTokens.getResult(prevState, lineLength);
        return {
            tokens: _produced,
            ruleStack: prevState
        };
    };
    return Grammar;
})();
function initGrammar(grammar, base) {
    grammar = utils_1.clone(grammar);
    grammar.repository = grammar.repository || {};
    grammar.repository.$self = {
        patterns: grammar.patterns,
        name: grammar.scopeName
    };
    grammar.repository.$base = base || grammar.repository.$self;
    return grammar;
}
function handleCaptures(grammar, lineText, isFirstLine, stack, lineTokens, captures, captureIndices) {
    if (captures.length === 0) {
        return;
    }
    var len = Math.min(captures.length, captureIndices.length), localStack = [], maxEnd = captureIndices[0].end, i, captureRule, captureIndex;
    for (i = 0; i < len; i++) {
        captureRule = captures[i];
        if (captureRule === null) {
            // Not interested
            continue;
        }
        captureIndex = captureIndices[i];
        if (captureIndex.length === 0) {
            // Nothing really captured
            continue;
        }
        if (captureIndex.start > maxEnd) {
            // Capture going beyond consumed string
            break;
        }
        // pop captures while needed
        while (localStack.length > 0 && localStack[localStack.length - 1].endPos <= captureIndex.start) {
            // pop!
            lineTokens.produce(stack, localStack[localStack.length - 1].endPos, localStack);
            localStack.pop();
        }
        lineTokens.produce(stack, captureIndex.start, localStack);
        if (captureRule.retokenizeCapturedWithRuleId) {
            // the capture requires additional matching
            var stackClone = stack.map(function (el) { return el.clone(); });
            stackClone.push(new StackElement(captureRule.retokenizeCapturedWithRuleId, captureIndex.start, null, captureRule.getName(rule_1.getString(lineText), captureIndices), captureRule.getContentName(rule_1.getString(lineText), captureIndices)));
            _tokenizeString(grammar, rule_1.createOnigString(rule_1.getString(lineText).substring(0, captureIndex.end)), (isFirstLine && captureIndex.start === 0), captureIndex.start, stackClone, lineTokens);
            continue;
        }
        // push
        localStack.push(new LocalStackElement(captureRule.getName(rule_1.getString(lineText), captureIndices), captureIndex.end));
    }
    while (localStack.length > 0) {
        // pop!
        lineTokens.produce(stack, localStack[localStack.length - 1].endPos, localStack);
        localStack.pop();
    }
}
function matchInjections(injections, grammar, lineText, isFirstLine, linePos, stack, anchorPosition) {
    // The lower the better
    var bestMatchRating = Number.MAX_VALUE;
    var bestMatchCaptureIndices = null;
    var bestMatchRuleId;
    var bestMatchResultPriority = false;
    for (var i = 0, len = injections.length; i < len; i++) {
        var injection = injections[i];
        var ruleScanner = grammar.getRule(injection.ruleId).compile(grammar, null, isFirstLine, linePos === anchorPosition);
        var matchResult = ruleScanner.scanner._findNextMatchSync(lineText, linePos);
        if (!matchResult) {
            continue;
        }
        var matchRating = matchResult.captureIndices[0].start;
        if (matchRating >= bestMatchRating) {
            continue;
        }
        bestMatchRating = matchRating;
        bestMatchCaptureIndices = matchResult.captureIndices;
        bestMatchRuleId = ruleScanner.rules[matchResult.index];
        bestMatchResultPriority = injection.priorityMatch;
        if (bestMatchRating === linePos && bestMatchResultPriority) {
            // No more need to look at the rest of the injections
            break;
        }
    }
    if (bestMatchCaptureIndices) {
        return {
            priorityMatch: bestMatchResultPriority,
            captureIndices: bestMatchCaptureIndices,
            matchedRuleId: bestMatchRuleId
        };
    }
    return null;
}
function matchRule(grammar, lineText, isFirstLine, linePos, stack, anchorPosition) {
    var stackElement = stack[stack.length - 1];
    var ruleScanner = grammar.getRule(stackElement.ruleId).compile(grammar, stackElement.endRule, isFirstLine, linePos === anchorPosition);
    var r = ruleScanner.scanner._findNextMatchSync(lineText, linePos);
    if (r) {
        return {
            captureIndices: r.captureIndices,
            matchedRuleId: ruleScanner.rules[r.index]
        };
    }
    return null;
}
function matchRuleOrInjections(grammar, lineText, isFirstLine, linePos, stack, anchorPosition) {
    // Look for normal grammar rule
    var matchResult = matchRule(grammar, lineText, isFirstLine, linePos, stack, anchorPosition);
    // Look for injected rules
    var injections = grammar.getInjections(stack);
    if (injections.length === 0) {
        // No injections whatsoever => early return
        return matchResult;
    }
    var injectionResult = matchInjections(injections, grammar, lineText, isFirstLine, linePos, stack, anchorPosition);
    if (!injectionResult) {
        // No injections matched => early return
        return matchResult;
    }
    if (!matchResult) {
        // Only injections matched => early return
        return injectionResult;
    }
    // Decide if `matchResult` or `injectionResult` should win
    var matchResultScore = matchResult.captureIndices[0].start;
    var injectionResultScore = injectionResult.captureIndices[0].start;
    if (injectionResultScore < matchResultScore || (injectionResult.priorityMatch && injectionResultScore === matchResultScore)) {
        // injection won!
        return injectionResult;
    }
    return matchResult;
}
function _tokenizeString(grammar, lineText, isFirstLine, linePos, stack, lineTokens) {
    var lineLength = rule_1.getString(lineText).length;
    var anchorPosition = -1;
    while (linePos < lineLength) {
        scanNext(); // potentially modifies linePos && anchorPosition
    }
    function scanNext() {
        var stackElement = stack[stack.length - 1];
        var r = matchRuleOrInjections(grammar, lineText, isFirstLine, linePos, stack, anchorPosition);
        if (!r) {
            // No match
            lineTokens.produce(stack, lineLength);
            linePos = lineLength;
            return true;
        }
        var captureIndices = r.captureIndices;
        var matchedRuleId = r.matchedRuleId;
        var hasAdvanced = (captureIndices[0].end > linePos);
        if (matchedRuleId === -1) {
            // We matched the `end` for this rule => pop it
            var poppedRule = grammar.getRule(stackElement.ruleId);
            lineTokens.produce(stack, captureIndices[0].start);
            stackElement.contentName = null;
            handleCaptures(grammar, lineText, isFirstLine, stack, lineTokens, poppedRule.endCaptures, captureIndices);
            lineTokens.produce(stack, captureIndices[0].end);
            // pop
            stack.pop();
            if (!hasAdvanced && stackElement.enterPos === linePos) {
                // Grammar pushed & popped a rule without advancing
                console.error('Grammar is in an endless loop - case 1');
                lineTokens.produce(stack, lineLength);
                linePos = lineLength;
                return false;
            }
        }
        else {
            // We matched a rule!
            var _rule = grammar.getRule(matchedRuleId);
            lineTokens.produce(stack, captureIndices[0].start);
            // push it on the stack rule
            stack.push(new StackElement(matchedRuleId, linePos, null, _rule.getName(rule_1.getString(lineText), captureIndices), null));
            if (_rule instanceof rule_1.BeginEndRule) {
                var pushedRule = _rule;
                handleCaptures(grammar, lineText, isFirstLine, stack, lineTokens, pushedRule.beginCaptures, captureIndices);
                lineTokens.produce(stack, captureIndices[0].end);
                anchorPosition = captureIndices[0].end;
                stack[stack.length - 1].contentName = pushedRule.getContentName(rule_1.getString(lineText), captureIndices);
                if (pushedRule.endHasBackReferences) {
                    stack[stack.length - 1].endRule = pushedRule.getEndWithResolvedBackReferences(rule_1.getString(lineText), captureIndices);
                }
                if (!hasAdvanced && stackElement.ruleId === stack[stack.length - 1].ruleId) {
                    // Grammar pushed the same rule without advancing
                    console.error('Grammar is in an endless loop - case 2');
                    stack.pop();
                    lineTokens.produce(stack, lineLength);
                    linePos = lineLength;
                    return false;
                }
            }
            else {
                var matchingRule = _rule;
                handleCaptures(grammar, lineText, isFirstLine, stack, lineTokens, matchingRule.captures, captureIndices);
                lineTokens.produce(stack, captureIndices[0].end);
                // pop rule immediately since it is a MatchRule
                stack.pop();
                if (!hasAdvanced) {
                    // Grammar is not advancing, nor is it pushing/popping
                    console.error('Grammar is in an endless loop - case 3');
                    if (stack.length > 1) {
                        stack.pop();
                    }
                    lineTokens.produce(stack, lineLength);
                    linePos = lineLength;
                    return false;
                }
            }
        }
        if (captureIndices[0].end > linePos) {
            // Advance stream
            linePos = captureIndices[0].end;
            isFirstLine = false;
        }
        return true;
    }
}
var StackElement = (function () {
    function StackElement(ruleId, enterPos, endRule, scopeName, contentName) {
        this.ruleId = ruleId;
        this.enterPos = enterPos;
        this.endRule = endRule;
        this.scopeName = scopeName;
        this.contentName = contentName;
    }
    StackElement.prototype.clone = function () {
        return new StackElement(this.ruleId, this.enterPos, this.endRule, this.scopeName, this.contentName);
    };
    StackElement.prototype.matches = function (scopeName) {
        if (!this.scopeName) {
            return false;
        }
        if (this.scopeName === scopeName) {
            return true;
        }
        var len = scopeName.length;
        return this.scopeName.length > len && this.scopeName.substr(0, len) === scopeName && this.scopeName[len] === '.';
    };
    return StackElement;
})();
exports.StackElement = StackElement;
var LocalStackElement = (function () {
    function LocalStackElement(scopeName, endPos) {
        this.scopeName = scopeName;
        this.endPos = endPos;
    }
    return LocalStackElement;
})();
var LineTokens = (function () {
    function LineTokens() {
        this._tokens = [];
        this._lastTokenEndIndex = 0;
    }
    LineTokens.prototype.produce = function (stack, endIndex, extraScopes) {
        // console.log('PRODUCE TOKEN: lastTokenEndIndex: ' + lastTokenEndIndex + ', endIndex: ' + endIndex);
        if (this._lastTokenEndIndex >= endIndex) {
            return;
        }
        var scopes = [], out = 0;
        for (var i = 0; i < stack.length; i++) {
            var el = stack[i];
            if (el.scopeName) {
                scopes[out++] = el.scopeName;
            }
            if (el.contentName) {
                scopes[out++] = el.contentName;
            }
        }
        if (extraScopes) {
            for (var i = 0; i < extraScopes.length; i++) {
                scopes[out++] = extraScopes[i].scopeName;
            }
        }
        this._tokens.push({
            startIndex: this._lastTokenEndIndex,
            endIndex: endIndex,
            // value: lineText.substring(lastTokenEndIndex, endIndex),
            scopes: scopes
        });
        this._lastTokenEndIndex = endIndex;
    };
    LineTokens.prototype.getResult = function (stack, lineLength) {
        if (this._tokens.length > 0 && this._tokens[this._tokens.length - 1].startIndex === lineLength - 1) {
            // pop produced token for newline
            this._tokens.pop();
        }
        if (this._tokens.length === 0) {
            this._lastTokenEndIndex = -1;
            this.produce(stack, lineLength, null);
            this._tokens[this._tokens.length - 1].startIndex = 0;
        }
        return this._tokens;
    };
    return LineTokens;
})();

});
$load('./registry', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var grammar_1 = require('./grammar');
var SyncRegistry = (function () {
    function SyncRegistry() {
        this._grammars = {};
        this._rawGrammars = {};
    }
    /**
     * Add `grammar` to registry and return a list of referenced scope names
     */
    SyncRegistry.prototype.addGrammar = function (grammar) {
        this._rawGrammars[grammar.scopeName] = grammar;
        return grammar_1.extractIncludedScopes(grammar);
    };
    /**
     * Lookup a raw grammar.
     */
    SyncRegistry.prototype.lookup = function (scopeName) {
        return this._rawGrammars[scopeName];
    };
    /**
     * Lookup a grammar.
     */
    SyncRegistry.prototype.grammarForScopeName = function (scopeName) {
        if (!this._grammars[scopeName]) {
            var rawGrammar = this._rawGrammars[scopeName];
            if (!rawGrammar) {
                return null;
            }
            this._grammars[scopeName] = grammar_1.createGrammar(rawGrammar, this);
        }
        return this._grammars[scopeName];
    };
    return SyncRegistry;
})();
exports.SyncRegistry = SyncRegistry;

});
$load('./main', function(require, module, exports) {
/*---------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var registry_1 = require('./registry');
var grammarReader_1 = require('./grammarReader');
var expressionMatcher = require('./matcher');
exports.createMatcher = expressionMatcher.createMatcher;
var DEFAULT_LOCATOR = {
    getFilePath: function (scopeName) { return null; }
};
var Registry = (function () {
    function Registry(locator) {
        if (locator === void 0) { locator = DEFAULT_LOCATOR; }
        this._locator = locator;
        this._syncRegistry = new registry_1.SyncRegistry();
    }
    Registry._extractInfo = function (rawGrammar) {
        return {
            fileTypes: rawGrammar.fileTypes,
            name: rawGrammar.name,
            scopeName: rawGrammar.scopeName,
            firstLineMatch: rawGrammar.firstLineMatch
        };
    };
    Registry.readGrammarInfo = function (path, callback) {
        var _this = this;
        grammarReader_1.readGrammar(path, function (err, grammar) {
            if (err) {
                callback(err, null);
                return;
            }
            callback(null, _this._extractInfo(grammar));
        });
    };
    Registry.readGrammarInfoSync = function (path) {
        return this._extractInfo(grammarReader_1.readGrammarSync(path));
    };
    Registry.prototype.loadGrammar = function (initialScopeName, callback) {
        var remainingScopeNames = [initialScopeName];
        var seenScopeNames = {};
        seenScopeNames[initialScopeName] = true;
        while (remainingScopeNames.length > 0) {
            var scopeName = remainingScopeNames.shift();
            if (this._syncRegistry.lookup(scopeName)) {
                continue;
            }
            var filePath = this._locator.getFilePath(scopeName);
            if (!filePath) {
                if (scopeName === initialScopeName) {
                    callback(new Error('Unknown location for grammar <' + initialScopeName + '>'), null);
                    return;
                }
                continue;
            }
            try {
                var grammar = grammarReader_1.readGrammarSync(filePath);
                var deps = this._syncRegistry.addGrammar(grammar);
                deps.forEach(function (dep) {
                    if (!seenScopeNames[dep]) {
                        seenScopeNames[dep] = true;
                        remainingScopeNames.push(dep);
                    }
                });
            }
            catch (err) {
                if (scopeName === initialScopeName) {
                    callback(new Error('Unknown location for grammar <' + initialScopeName + '>'), null);
                    return;
                }
            }
        }
        callback(null, this.grammarForScopeName(initialScopeName));
    };
    Registry.prototype.loadGrammarFromPathSync = function (path) {
        var rawGrammar = grammarReader_1.readGrammarSync(path);
        this._syncRegistry.addGrammar(rawGrammar);
        return this.grammarForScopeName(rawGrammar.scopeName);
    };
    Registry.prototype.grammarForScopeName = function (scopeName) {
        return this._syncRegistry.grammarForScopeName(scopeName);
    };
    return Registry;
})();
exports.Registry = Registry;

});
module.exports = $map['./main'].exports;
