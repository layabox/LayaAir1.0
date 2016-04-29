/*!--------------------------------------------------------
 * Copyright (C) Microsoft Corporation. All rights reserved.
 *--------------------------------------------------------*/
define("vs/base/common/arrays", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e, t) {
        return void 0 === t && (t = 0), e[e.length - (1 + t)]
    }

    function r(e, t) {
        for (var n = 0, r = e.length; r > n; n++)t(e[n], function () {
            e.splice(n, 1), n--, r--
        })
    }

    function o(e, t, n) {
        if (e.length !== t.length)return !1;
        for (var r = 0, o = e.length; o > r; r++)if (!n(e[r], t[r]))return !1;
        return !0
    }

    function i(e, t, n) {
        for (var r = 0, o = e.length - 1; o >= r;) {
            var i = (r + o) / 2 | 0, a = n(e[i], t);
            if (0 > a)r = i + 1; else {
                if (!(a > 0))return i;
                o = i - 1
            }
        }
        return -(r + 1)
    }

    function a(e, t) {
        var n = 0, r = e.length;
        if (0 === r)return 0;
        for (; r > n;) {
            var o = Math.floor((n + r) / 2);
            t(e[o]) ? r = o : n = o + 1
        }
        return n
    }

    function s(e, t) {
        var n = new Array;
        if (t)for (var r = {}, o = 0; o < e.length; o++)for (var i = 0; i < e[o].length; i++) {
            var a = e[o][i], s = t(a);
            r.hasOwnProperty(s) || (r[s] = !0, n.push(a))
        } else for (var o = 0, c = e.length; c > o; o++)n.push.apply(n, e[o]);
        return n
    }

    function c(e) {
        return e ? e.filter(function (e) {
            return !!e
        }) : e
    }

    function u(e, t) {
        return e.indexOf(t) >= 0
    }

    function l(e, t, n) {
        var r = e[t], o = e[n];
        e[t] = o, e[n] = r
    }

    function f(e, t, n) {
        e.splice(n, 0, e.splice(t, 1)[0])
    }

    function p(e) {
        return !Array.isArray(e) || 0 === e.length
    }

    function d(e, t) {
        if (!t)return e.filter(function (t, n) {
            return e.indexOf(t) === n
        });
        var n = {};
        return e.filter(function (e) {
            var r = t(e);
            return n[r] ? !1 : (n[r] = !0, !0)
        })
    }

    function h(e, t, n) {
        void 0 === n && (n = null);
        for (var r = 0; r < e.length; r++) {
            var o = e[r];
            if (t(o))return o
        }
        return n
    }

    function m(e, t, n) {
        void 0 === n && (n = function (e, t) {
            return e === t
        });
        for (var r = 0, o = 0, i = Math.min(e.length, t.length); i > o && n(e[o], t[o]); o++)r++;
        return r
    }

    function g(e) {
        return e.reduce(function (e, t) {
            return e.concat(t)
        }, [])
    }

    t.tail = n, t.forEach = r, t.equals = o, t.binarySearch = i, t.findFirst = a, t.merge = s, t.coalesce = c, t.contains = u, t.swap = l, t.move = f, t.isFalsyOrEmpty = p, t.distinct = d, t.first = h, t.commonPrefixLength = m, t.flatten = g
}), define("vs/base/common/lifecycle", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e) {
        return e && e.dispose(), null
    }

    function r(e) {
        if (e)for (var t = 0, n = e.length; n > t; t++)e[t] && e[t].dispose();
        return []
    }

    function o() {
        for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
        return {
            dispose: function () {
                return r(e)
            }
        }
    }

    function i(e) {
        return {
            dispose: function () {
                return r(e)
            }
        }
    }

    function a(e) {
        return {
            dispose: function () {
                return e()
            }
        }
    }

    function s() {
        for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
        return i(e.map(a))
    }

    function c(e) {
        if (e) {
            if ("function" == typeof e)return e(), null;
            if (Array.isArray(e)) {
                for (; e.length > 0;)e.pop()();
                return e
            }
            return null
        }
        return null
    }

    t.empty = Object.freeze({
        dispose: function () {
        }
    }), t.dispose = n, t.disposeAll = r, t.combinedDispose = o, t.combinedDispose2 = i, t.fnToDisposable = a, t.toDisposable = s, t.cAll = c;
    var u = function () {
        function e() {
            this._toDispose = []
        }

        return e.prototype.dispose = function () {
            this._toDispose = r(this._toDispose)
        }, e.prototype._register = function (e) {
            return this._toDispose.push(e), e
        }, e
    }();
    t.Disposable = u
}), define("vs/base/common/platform", ["require", "exports"], function (e, t) {
    "use strict";
    function n() {
        return "undefined" != typeof v.Worker
    }

    var r = !1, o = !1, i = !1, a = !1, s = !1, c = !1, u = void 0, l = void 0;
    if ("object" == typeof process) {
        r = "win32" === process.platform, o = "darwin" === process.platform, i = "linux" === process.platform;
        var f = process.env.VSCODE_NLS_CONFIG;
        if (f)try {
            var p = JSON.parse(f), d = p.availableLanguages["*"];
            u = p.locale, l = d ? d : "en"
        } catch (h) {
        }
        a = !0
    } else if ("object" == typeof navigator) {
        var m = navigator.userAgent;
        r = m.indexOf("Windows") >= 0, o = m.indexOf("Macintosh") >= 0, i = m.indexOf("Linux") >= 0, s = !0, u = navigator.language, l = u, c = !!self.QUnit
    }
    !function (e) {
        e[e.Web = 0] = "Web", e[e.Mac = 1] = "Mac", e[e.Linux = 2] = "Linux", e[e.Windows = 3] = "Windows"
    }(t.Platform || (t.Platform = {}));
    var g = t.Platform;
    t._platform = g.Web, a && (o ? t._platform = g.Mac : r ? t._platform = g.Windows : i && (t._platform = g.Linux)), t.isWindows = r, t.isMacintosh = o, t.isLinux = i, t.isNative = a, t.isWeb = s, t.isQunit = c, t.platform = t._platform, t.language = l, t.locale = u;
    var v = "object" == typeof self ? self : global;
    t.globals = v, t.hasWebWorkerSupport = n, t.setTimeout = v.setTimeout.bind(v), t.clearTimeout = v.clearTimeout.bind(v), t.setInterval = v.setInterval.bind(v), t.clearInterval = v.clearInterval.bind(v)
}), define("vs/base/common/strings", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e, t, n) {
        void 0 === n && (n = "0");
        for (var r = "" + e, o = [r], i = r.length; t > i; i++)o.push(n);
        return o.reverse().join("")
    }

    function r(e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        return 0 === t.length ? e : e.replace(O, function (e, n) {
            var r = parseInt(n, 10);
            return isNaN(r) || 0 > r || r >= t.length ? e : t[r]
        })
    }

    function o(e) {
        return e.replace(/[<|>|&]/g, function (e) {
            switch (e) {
                case"<":
                    return "&lt;";
                case">":
                    return "&gt;";
                case"&":
                    return "&amp;";
                default:
                    return e
            }
        })
    }

    function i(e) {
        return e.replace(/[\-\\\{\}\*\+\?\|\^\$\.\,\[\]\(\)\#\s]/g, "\\$&")
    }

    function a(e, t) {
        void 0 === t && (t = " ");
        var n = s(e, t);
        return c(n, t)
    }

    function s(e, t) {
        if (!e || !t)return e;
        var n = t.length;
        if (0 === n || 0 === e.length)return e;
        for (var r = 0, o = -1; (o = e.indexOf(t, r)) === r;)r += n;
        return e.substring(r)
    }

    function c(e, t) {
        if (!e || !t)return e;
        var n = t.length, r = e.length;
        if (0 === n || 0 === r)return e;
        for (var o = r, i = -1; ;) {
            if (i = e.lastIndexOf(t, o - 1), -1 === i || i + n !== o)break;
            if (0 === i)return "";
            o = i
        }
        return e.substring(0, o)
    }

    function u(e) {
        return e.replace(/[\-\\\{\}\+\?\|\^\$\.\,\[\]\(\)\#\s]/g, "\\$&").replace(/[\*]/g, ".*")
    }

    function l(e) {
        return e.replace(/\*/g, "")
    }

    function f(e, t) {
        if (e.length < t.length)return !1;
        for (var n = 0; n < t.length; n++)if (e[n] !== t[n])return !1;
        return !0
    }

    function p(e, t) {
        var n = e.length - t.length;
        return n > 0 ? e.lastIndexOf(t) === e.length - t.length : 0 === n ? e === t : !1
    }

    function d(e, t, n, r, o) {
        if ("" === e)throw new Error("Cannot create regex from empty string");
        t || (e = e.replace(/[\-\\\{\}\*\+\?\|\^\$\.\,\[\]\(\)\#\s]/g, "\\$&")), r && (/\B/.test(e.charAt(0)) || (e = "\\b" + e), /\B/.test(e.charAt(e.length - 1)) || (e += "\\b"));
        var i = "";
        return o && (i += "g"), n || (i += "i"), new RegExp(e, i)
    }

    function h(e, t, n, r) {
        if ("" === e)return null;
        var o = null;
        try {
            o = d(e, t, n, r, !0)
        } catch (i) {
            return null
        }
        try {
            if (m(o))return null
        } catch (i) {
            return null
        }
        return o
    }

    function m(e) {
        if ("^" === e.source || "^$" === e.source || "$" === e.source)return !1;
        var t = e.exec("");
        return t && 0 === e.lastIndex
    }

    function g(e) {
        if (!t.canNormalize || !e)return e;
        var n = L[e];
        if (n)return n;
        var r;
        return r = I.test(e) ? e.normalize("NFC") : e, 1e4 > U && (L[e] = r, U++), r
    }

    function v(e) {
        for (var t = 0, n = e.length; n > t; t++)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return t;
        return -1
    }

    function w(e) {
        for (var t = 0, n = e.length; n > t; t++)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return e.substring(0, t);
        return e
    }

    function y(e) {
        for (var t = e.length - 1; t >= 0; t--)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return t;
        return -1
    }

    function b(e, t) {
        return e.localeCompare(t)
    }

    function _(e) {
        return e >= 97 && 122 >= e || e >= 65 && 90 >= e
    }

    function S(e, t) {
        var n = e.length, r = t.length;
        if (n !== r)return !1;
        for (var o = 0; n > o; o++) {
            var i = e.charCodeAt(o), a = t.charCodeAt(o);
            if (i !== a)if (_(i) && _(a)) {
                var s = Math.abs(i - a);
                if (0 !== s && 32 !== s)return !1
            } else if (String.fromCharCode(i).toLocaleLowerCase() !== String.fromCharCode(a).toLocaleLowerCase())return !1
        }
        return !0
    }

    function E(e, t) {
        var n, r = Math.min(e.length, t.length);
        for (n = 0; r > n; n++)if (e.charCodeAt(n) !== t.charCodeAt(n))return n;
        return r
    }

    function P(e, t) {
        var n, r = Math.min(e.length, t.length), o = e.length - 1, i = t.length - 1;
        for (n = 0; r > n; n++)if (e.charCodeAt(o - n) !== t.charCodeAt(i - n))return n;
        return r
    }

    function C(e) {
        return e >= 11904 && 55215 >= e || e >= 63744 && 64255 >= e || e >= 65281 && 65374 >= e
    }

    function k(e, t, n) {
        void 0 === n && (n = 4);
        var r = Math.abs(e.length - t.length);
        if (r > n)return 0;
        var o, i, a = [], s = [];
        for (o = 0; o < t.length + 1; ++o)s.push(0);
        for (o = 0; o < e.length + 1; ++o)a.push(s);
        for (o = 1; o < e.length + 1; ++o)for (i = 1; i < t.length + 1; ++i)e[o - 1] === t[i - 1] ? a[o][i] = a[o - 1][i - 1] + 1 : a[o][i] = Math.max(a[o - 1][i], a[o][i - 1]);
        return a[e.length][t.length] - Math.sqrt(r)
    }

    function A(e) {
        for (var t, n = /\r\n|\r|\n/g, r = [0]; t = n.exec(e);)r.push(n.lastIndex);
        return r
    }

    function M(e, n) {
        if (e.length < n)return e;
        for (var r = e.split(/\b/), o = 0, i = r.length - 1; i >= 0; i--)if (o += r[i].length, o > n) {
            r.splice(0, i);
            break
        }
        return r.join(t.empty).replace(/^\s/, t.empty)
    }

    function x(e) {
        return e && (e = e.replace(N, ""), e = e.replace(W, "\n"), e = e.replace(F, ""), e = e.replace(R, "")), e
    }

    function T(e) {
        return e && e.length > 0 && e.charCodeAt(0) === D
    }

    t.empty = "", t.pad = n;
    var O = /{(\d+)}/g;
    t.format = r, t.escape = o, t.escapeRegExpCharacters = i, t.trim = a, t.ltrim = s, t.rtrim = c, t.convertSimple2RegExpPattern = u, t.stripWildcards = l, t.startsWith = f, t.endsWith = p, t.createRegExp = d, t.createSafeRegExp = h, t.regExpLeadsToEndlessLoop = m, t.canNormalize = "function" == typeof"".normalize;
    var I = /[^\u0000-\u0080]/, L = Object.create(null), U = 0;
    t.normalizeNFC = g, t.firstNonWhitespaceIndex = v, t.getLeadingWhitespace = w, t.lastNonWhitespaceIndex = y, t.localeCompare = b, t.equalsIgnoreCase = S, t.commonPrefixLength = E, t.commonSuffixLength = P, t.isFullWidthCharacter = C, t.difference = k, t.computeLineStarts = A, t.lcut = M;
    var N = /\x1B\x5B[12]?K/g, W = /\xA/g, F = /\x1b\[\d+m/g, R = /\x1b\[0?m/g;
    t.removeAnsiEscapeCodes = x;
    var D = 65279;
    t.UTF8_BOM_CHARACTER = String.fromCharCode(D), t.startsWithUTF8BOM = T
}), define("vs/base/common/paths", ["require", "exports", "vs/base/common/platform", "vs/base/common/strings"], function (e, t, n, r) {
    "use strict";
    function o(e, n) {
        e = i(e), n = i(n);
        for (var r = e.split(t.sep), o = n.split(t.sep); r.length > 0 && o.length > 0 && r[0] === o[0];)r.shift(), o.shift();
        for (var a = 0, s = r.length; s > a; a++)o.unshift("..");
        return o.join(t.sep)
    }

    function i(e, r) {
        if (!e)return e;
        if (!y.test(e)) {
            var o = r && n.isWindows ? "/" : "\\";
            if (-1 === e.indexOf(o))return e
        }
        for (var i = e.split(/[\\\/]/), a = 0, s = i.length; s > a; a++)"." === i[a] && i[a + 1] ? (i.splice(a, 1), a -= 1) : ".." === i[a] && i[a - 1] && (i.splice(a - 1, 2), a -= 2);
        return i.join(r ? t.nativeSep : t.sep)
    }

    function a(e) {
        function t() {
            return "." === n || "/" === n || "\\" === n ? (n = void 0, r = !0) : n = s(n), {value: n, done: r}
        }

        var n = e, r = !1;
        return {next: t}
    }

    function s(e) {
        var t = ~e.lastIndexOf("/") || ~e.lastIndexOf("\\");
        return 0 === t ? "." : 0 === ~t ? e[0] : e.substring(0, ~t)
    }

    function c(e) {
        var t = ~e.lastIndexOf("/") || ~e.lastIndexOf("\\");
        return 0 === t ? e : ~t === e.length - 1 ? c(e.substring(0, e.length - 1)) : e.substr(~t + 1)
    }

    function u(e) {
        e = c(e);
        var t = ~e.lastIndexOf(".");
        return t ? e.substring(~t) : ""
    }

    function l(e) {
        if (!e)return 0;
        if (e = e.replace(/\/|\\/g, "/"), "/" === e[0])return "/" !== e[1] ? 1 : 2;
        if (":" === e[1])return "/" === e[2] ? 3 : 2;
        if (0 === e.indexOf("file:///"))return 8;
        var t = e.indexOf("://");
        return -1 !== t ? t + 3 : 0
    }

    function f() {
        for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
        var n, r = l(e[0]);
        n = e[0].substr(0, r), e[0] = e[0].substr(r);
        for (var o = [], i = /[\\\/]$/.test(e[e.length - 1]), a = 0; a < e.length; a++)o.push.apply(o, e[a].split(/\/|\\/));
        for (var a = 0; a < o.length; a++) {
            var s = o[a];
            "." === s || 0 === s.length ? (o.splice(a, 1), a -= 1) : ".." === s && o[a - 1] && ".." !== o[a - 1] && (o.splice(a - 1, 2), a -= 2)
        }
        i && o.push("");
        var c = o.join("/");
        return n && (c = n.replace(/\/|\\/g, "/") + c), c
    }

    function p(e) {
        return n.isWindows && e ? (e = this.normalize(e, !0), e[0] === t.nativeSep && e[1] === t.nativeSep) : !1
    }

    function d(e) {
        return e && "/" === e[0]
    }

    function h(e, n) {
        return d(n ? e : i(e)) ? e : t.sep + e
    }

    function m(e) {
        return e && e.length > 1 && "." === e[0]
    }

    function g(e, t) {
        if (e === t)return !0;
        e = i(e), t = i(t);
        var r = t.length, o = t.charCodeAt(r - 1);
        if (o === b && (t = t.substring(0, r - 1), r -= 1), e === t)return !0;
        if (n.isLinux || (e = e.toLowerCase(), t = t.toLowerCase()), e === t)return !0;
        if (0 !== e.indexOf(t))return !1;
        var a = e.charCodeAt(r);
        return a === b
    }

    function v(e) {
        return !e || 0 === e.length || /^\s+$/.test(e) ? !1 : (_.lastIndex = 0, _.test(e) ? !1 : n.isWindows && S.test(e) ? !1 : "." === e || ".." === e ? !1 : n.isWindows && r.endsWith(e, ".") ? !1 : !n.isWindows || e.length === e.trim().length)
    }

    function w(e) {
        return t.isAbsoluteRegex.test(e)
    }

    t.sep = "/", t.nativeSep = n.isWindows ? "\\" : "/", t.relative = o;
    var y = /[\\\/]\.\.?[\\\/]?|[\\\/]?\.\.?[\\\/]/;
    t.normalize = i, t.dirnames = a, t.dirname = s, t.basename = c, t.extname = u, t.join = f, t.isUNC = p, t.makeAbsolute = h, t.isRelative = m;
    var b = "/".charCodeAt(0);
    t.isEqualOrParent = g;
    var _ = n.isWindows ? /[\\/:\*\?"<>\|]/g : /[\\/]/g, S = /^(con|prn|aux|clock\$|nul|lpt[0-9]|com[0-9])$/i;
    t.isValidBasename = v, t.isAbsoluteRegex = /^((\/|[a-zA-Z]:\\)[^\(\)<>\\'\"\[\]]+)/, t.isAbsolute = w
}), define("vs/base/common/types", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e) {
        return Array.isArray ? Array.isArray(e) : !(!e || "number" != typeof e.length || e.constructor !== Array)
    }

    function r(e) {
        return "string" == typeof e || e instanceof String
    }

    function o(e) {
        return n(e) && e.every(function (e) {
                return r(e)
            })
    }

    function i(e) {
        return "undefined" == typeof e || null === e ? !1 : "[object Object]" === Object.prototype.toString.call(e)
    }

    function a(e) {
        return ("number" == typeof e || e instanceof Number) && !isNaN(e)
    }

    function s(e) {
        return e === !0 || e === !1
    }

    function c(e) {
        return "undefined" == typeof e
    }

    function u(e) {
        return c(e) || null === e
    }

    function l(e) {
        if (!i(e))return !1;
        for (var t in e)if (g.call(e, t))return !1;
        return !0
    }

    function f(e) {
        return "[object Function]" === Object.prototype.toString.call(e)
    }

    function p() {
        for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
        return e && e.length > 0 && e.every(function (e) {
                return f(e)
            })
    }

    function d(e, t) {
        for (var n = Math.min(e.length, t.length), r = 0; n > r; r++)h(e[r], t[r])
    }

    function h(e, t) {
        if ("string" == typeof t) {
            if (typeof e !== t)throw new Error("argument does not match constraint: typeof " + t)
        } else if ("function" == typeof t) {
            if (e instanceof t)return;
            if (e && e.constructor === t)return;
            if (1 === t.length && t.call(void 0, e) === !0)return;
            throw new Error("argument does not match one of these constraints: arg instanceof constraint, arg.constructor === constraint, nor constraint(arg) === true")
        }
    }

    function m(e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        var r = Object.create(e.prototype);
        return e.apply(r, t), r
    }

    t.isArray = n, t.isString = r, t.isStringArray = o, t.isObject = i, t.isNumber = a, t.isBoolean = s, t.isUndefined = c, t.isUndefinedOrNull = u;
    var g = Object.prototype.hasOwnProperty;
    t.isEmptyObject = l, t.isFunction = f, t.areFunctions = p, t.validateConstraints = d, t.validateConstraint = h, t.create = m
}), define("vs/base/common/objects", ["require", "exports", "vs/base/common/types"], function (e, t, n) {
    "use strict";
    function r(e) {
        if (!e || "object" != typeof e)return e;
        if (e instanceof RegExp)return e;
        var t = Array.isArray(e) ? [] : {};
        return Object.keys(e).forEach(function (n) {
            e[n] && "object" == typeof e[n] ? t[n] = r(e[n]) : t[n] = e[n]
        }), t
    }

    function o(e) {
        if (!e || "object" != typeof e)return e;
        var t = Array.isArray(e) ? [] : {};
        return Object.getOwnPropertyNames(e).forEach(function (n) {
            e[n] && "object" == typeof e[n] ? t[n] = o(e[n]) : t[n] = e[n]
        }), t
    }

    function i(e, t) {
        return a(e, t, [])
    }

    function a(e, t, r) {
        if (n.isUndefinedOrNull(e))return e;
        var o = t(e);
        if ("undefined" != typeof o)return o;
        if (n.isArray(e)) {
            for (var i = [], s = 0; s < e.length; s++)i.push(a(e[s], t, r));
            return i
        }
        if (n.isObject(e)) {
            if (r.indexOf(e) >= 0)throw new Error("Cannot clone recursive data-structure");
            r.push(e);
            var c = {};
            for (var u in e)v.call(e, u) && (c[u] = a(e[u], t, r));
            return r.pop(), c
        }
        return e
    }

    function s(e, t, r) {
        return void 0 === r && (r = !0), n.isObject(e) ? (n.isObject(t) && Object.keys(t).forEach(function (o) {
            o in e ? r && (n.isObject(e[o]) && n.isObject(t[o]) ? s(e[o], t[o], r) : e[o] = t[o]) : e[o] = t[o]
        }), e) : t
    }

    function c(e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        return t.forEach(function (t) {
            return Object.keys(t).forEach(function (n) {
                return e[n] = t[n]
            })
        }), e
    }

    function u(e, t, n) {
        return void 0 === n && (n = function (e) {
            return e
        }), e.reduce(function (e, r) {
            return c(e, (o = {}, o[t(r)] = n(r), o));
            var o
        }, Object.create(null))
    }

    function l(e, t) {
        return s(r(t), e || {})
    }

    function f(e, t) {
        if (e === t)return !0;
        if (null === e || void 0 === e || null === t || void 0 === t)return !1;
        if (typeof e != typeof t)return !1;
        if ("object" != typeof e)return !1;
        if (Array.isArray(e) !== Array.isArray(t))return !1;
        var n, r;
        if (Array.isArray(e)) {
            if (e.length !== t.length)return !1;
            for (n = 0; n < e.length; n++)if (!f(e[n], t[n]))return !1
        } else {
            var o = [];
            for (r in e)o.push(r);
            o.sort();
            var i = [];
            for (r in t)i.push(r);
            if (i.sort(), !f(o, i))return !1;
            for (n = 0; n < o.length; n++)if (!f(e[o[n]], t[o[n]]))return !1
        }
        return !0
    }

    function p(e, t, n) {
        "undefined" == typeof e[t] && (e[t] = n)
    }

    function d(e) {
        for (var t = {}, n = 0; n < e.length; ++n)t[e[n]] = !0;
        return t
    }

    function h(e, t) {
        void 0 === t && (t = !1), t && (e = e.map(function (e) {
            return e.toLowerCase()
        }));
        var n = d(e);
        return t ? function (e) {
            return void 0 !== n[e.toLowerCase()] && n.hasOwnProperty(e.toLowerCase())
        } : function (e) {
            return void 0 !== n[e] && n.hasOwnProperty(e)
        }
    }

    function m(e, t) {
        for (var n in e)e.hasOwnProperty(n) && (t[n] = e[n]);
        t = t || function () {
            };
        var r = e.prototype, o = t.prototype;
        t.prototype = Object.create(r);
        for (var n in o)o.hasOwnProperty(n) && Object.defineProperty(t.prototype, n, Object.getOwnPropertyDescriptor(o, n));
        Object.defineProperty(t.prototype, "constructor", {value: t, writable: !0, configurable: !0, enumerable: !0})
    }

    function g(e) {
        var t = [];
        return JSON.stringify(e, function (e, r) {
            if (n.isObject(r) || Array.isArray(r)) {
                if (-1 !== t.indexOf(r))return "[Circular]";
                t.push(r)
            }
            return r
        })
    }

    t.clone = r, t.deepClone = o;
    var v = Object.prototype.hasOwnProperty;
    t.cloneAndChange = i, t.mixin = s, t.assign = c, t.toObject = u, t.withDefaults = l, t.equals = f, t.ensureProperty = p, t.arrayToHash = d, t.createKeywordMatcher = h, t.derive = m, t.safeStringify = g
}), define("vs/base/common/uri", ["require", "exports", "vs/base/common/platform"], function (e, t, n) {
    "use strict";
    function r(e) {
        return encodeURIComponent(e).replace(/[!'()*]/g, function (e) {
            return "%" + e.charCodeAt(0).toString(16).toUpperCase()
        })
    }

    var o = function () {
        function e() {
            this._scheme = e._empty, this._authority = e._empty, this._path = e._empty, this._query = e._empty, this._fragment = e._empty
        }

        return Object.defineProperty(e.prototype, "scheme", {
            get: function () {
                return this._scheme
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "authority", {
            get: function () {
                return this._authority
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "path", {
            get: function () {
                return this._path
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "query", {
            get: function () {
                return this._query
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "fragment", {
            get: function () {
                return this._fragment
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "fsPath", {
            get: function () {
                if (!this._fsPath) {
                    var t;
                    t = this._authority && "file" === this.scheme ? "//" + this._authority + this._path : e._driveLetterPath.test(this._path) ? this._path[1].toLowerCase() + this._path.substr(2) : this._path, n.isWindows && (t = t.replace(/\//g, "\\")), this._fsPath = t
                }
                return this._fsPath
            }, enumerable: !0, configurable: !0
        }), e.prototype["with"] = function (t, n, r, o, i) {
            var a = new e;
            return a._scheme = t || this.scheme, a._authority = n || this.authority, a._path = r || this.path, a._query = o || this.query, a._fragment = i || this.fragment, e._validate(a), a
        }, e.prototype.withScheme = function (e) {
            return this["with"](e, void 0, void 0, void 0, void 0)
        }, e.prototype.withAuthority = function (e) {
            return this["with"](void 0, e, void 0, void 0, void 0)
        }, e.prototype.withPath = function (e) {
            return this["with"](void 0, void 0, e, void 0, void 0)
        }, e.prototype.withQuery = function (e) {
            return this["with"](void 0, void 0, void 0, e, void 0)
        }, e.prototype.withFragment = function (e) {
            return this["with"](void 0, void 0, void 0, void 0, e)
        }, e.parse = function (t) {
            var n = new e, r = e._parseComponents(t);
            return n._scheme = r.scheme, n._authority = decodeURIComponent(r.authority), n._path = decodeURIComponent(r.path), n._query = decodeURIComponent(r.query), n._fragment = decodeURIComponent(r.fragment), e._validate(n), n
        }, e.file = function (t) {
            t = t.replace(/\\/g, "/"), t = t.replace(/%/g, "%25"), t = t.replace(/#/g, "%23"), t = t.replace(/\?/g, "%3F"), t = e._driveLetter.test(t) ? "/" + t : t;
            var n = e._parseComponents(t);
            if (n.scheme || n.fragment || n.query)throw new Error("Path contains a scheme, fragment or a query. Can not convert it to a file uri.");
            var r = new e;
            return r._scheme = "file", r._authority = n.authority, r._path = decodeURIComponent("/" === n.path[0] ? n.path : "/" + n.path), r._query = n.query, r._fragment = n.fragment, e._validate(r), r
        }, e._parseComponents = function (t) {
            var n = {
                scheme: e._empty,
                authority: e._empty,
                path: e._empty,
                query: e._empty,
                fragment: e._empty
            }, r = e._regexp.exec(t);
            return r && (n.scheme = r[2] || n.scheme, n.authority = r[4] || n.authority, n.path = r[5] || n.path, n.query = r[7] || n.query, n.fragment = r[9] || n.fragment), n
        }, e.create = function (t, n, r, o, i) {
            return (new e)["with"](t, n, r, o, i)
        }, e._validate = function (e) {
            if (e.authority && e.path && "/" !== e.path[0])throw new Error('[UriError]: If a URI contains an authority component, then the path component must either be empty or begin with a slash ("/") character');
            if (!e.authority && 0 === e.path.indexOf("//"))throw new Error('[UriError]: If a URI does not contain an authority component, then the path cannot begin with two slash characters ("//")')
        }, e.prototype.toString = function () {
            if (!this._formatted) {
                var t = [];
                if (this._scheme && (t.push(this._scheme), t.push(":")), (this._authority || "file" === this._scheme) && t.push("//"), this._authority) {
                    var n, o = this._authority;
                    o = o.toLowerCase(), n = o.indexOf(":"), -1 === n ? t.push(r(o)) : (t.push(r(o.substr(0, n))), t.push(o.substr(n)))
                }
                if (this._path) {
                    var i, a = this._path;
                    e._driveLetterPath.test(a) ? a = "/" + a[1].toLowerCase() + a.substr(2) : e._driveLetter.test(a) && (a = a[0].toLowerCase() + a.substr(1)), i = a.split("/");
                    for (var s = 0, c = i.length; c > s; s++)i[s] = r(i[s]);
                    t.push(i.join("/"))
                }
                if (this._query) {
                    var u = /https?/i.test(this.scheme) ? encodeURI : r;
                    t.push("?"), t.push(u(this._query))
                }
                this._fragment && (t.push("#"), t.push(r(this._fragment))), this._formatted = t.join("")
            }
            return this._formatted
        }, e.prototype.toJSON = function () {
            return {
                scheme: this.scheme,
                authority: this.authority,
                path: this.path,
                fsPath: this.fsPath,
                query: this.query,
                fragment: this.fragment.replace(/URL_MARSHAL_REMOVE.*$/, ""),
                external: this.toString().replace(/#?URL_MARSHAL_REMOVE.*$/, ""),
                $mid: 1
            }
        }, e.revive = function (t) {
            var n = new e;
            return n._scheme = t.scheme, n._authority = t.authority, n._path = t.path, n._query = t.query, n._fragment = t.fragment, n._fsPath = t.fsPath, n._formatted = t.external, e._validate(n), n
        }, e._empty = "", e._regexp = /^(([^:\/?#]+?):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?/, e._driveLetterPath = /^\/[a-zA-z]:/, e._driveLetter = /^[a-zA-z]:/, e
    }();
    Object.defineProperty(t, "__esModule", {value: !0}), t["default"] = o
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/base/common/uuid", ["require", "exports"], function (e, t) {
    "use strict";
    function n() {
        return new a
    }

    function r(e) {
        if (!s.test(e))throw new Error("invalid uuid");
        return new i(e)
    }

    function o() {
        return n().asHex()
    }

    var i = function () {
        function e(e) {
            this._value = e
        }

        return e.prototype.asHex = function () {
            return this._value
        }, e.prototype.equals = function (e) {
            return this.asHex() === e.asHex()
        }, e
    }(), a = function (e) {
        function t() {
            e.call(this, [t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), "-", t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), "-", "4", t._randomHex(), t._randomHex(), t._randomHex(), "-", t._oneOf(t._timeHighBits), t._randomHex(), t._randomHex(), t._randomHex(), "-", t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex(), t._randomHex()].join(""))
        }

        return __extends(t, e), t._oneOf = function (e) {
            var t = Math.floor(e.length * Math.random());
            return e[t]
        }, t._randomHex = function () {
            return t._oneOf(t._chars)
        }, t._chars = ["0", "1", "2", "3", "4", "5", "6", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"], t._timeHighBits = ["8", "9", "a", "b"], t
    }(i);
    t.empty = new i("00000000-0000-0000-0000-000000000000"), t.v4 = n;
    var s = /^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$/;
    t.parse = r, t.generateUuid = o
}), "undefined" == typeof WinJS && (!function (e) {
    e.setImmediate || ("undefined" != typeof process && "function" == typeof process.nextTick ? e.setImmediate = function (e) {
        return process.nextTick(e)
    } : e.setImmediate = function (e) {
        return setTimeout(e, 0)
    })
}(this), function (e, t) {
    "use strict";
    function n(e, n) {
        var r, o, i, a = Object.keys(n);
        for (o = 0, i = a.length; i > o; o++) {
            var s = a[o], c = 95 !== s.charCodeAt(0), u = n[s];
            !u || "object" != typeof u || u.value === t && "function" != typeof u.get && "function" != typeof u.set ? c ? e[s] = u : (r = r || {}, r[s] = {
                value: u,
                enumerable: c,
                configurable: !0,
                writable: !0
            }) : (u.enumerable === t && (u.enumerable = c), r = r || {}, r[s] = u)
        }
        r && Object.defineProperties(e, r)
    }

    !function (t) {
        function r(e, t, r) {
            for (var o = e, i = t.split("."), a = 0, s = i.length; s > a; a++) {
                var c = i[a];
                o[c] || Object.defineProperty(o, c, {
                    value: {},
                    writable: !1,
                    enumerable: !0,
                    configurable: !0
                }), o = o[c]
            }
            return r && n(o, r), o
        }

        function o(t, n) {
            return r(e, t, n)
        }

        e[t] || (e[t] = Object.create(Object.prototype));
        var i = e[t];
        i.Namespace || (i.Namespace = Object.create(Object.prototype)), Object.defineProperties(i.Namespace, {
            defineWithParent: {
                value: r,
                writable: !0,
                enumerable: !0,
                configurable: !0
            }, define: {value: o, writable: !0, enumerable: !0, configurable: !0}
        })
    }("WinJS"), function (e) {
        function t(t, r, o) {
            return t = t || function () {
                }, e.Utilities.markSupportedForProcessing(t), r && n(t.prototype, r), o && n(t, o), t
        }

        function r(r, o, i, a) {
            if (r) {
                o = o || function () {
                    };
                var s = r.prototype;
                return o.prototype = Object.create(s), e.Utilities.markSupportedForProcessing(o), Object.defineProperty(o.prototype, "constructor", {
                    value: o,
                    writable: !0,
                    configurable: !0,
                    enumerable: !0
                }), i && n(o.prototype, i), a && n(o, a), o
            }
            return t(o, i, a)
        }

        function o(e) {
            e = e || function () {
                };
            var t, r;
            for (t = 1, r = arguments.length; r > t; t++)n(e.prototype, arguments[t]);
            return e
        }

        e.Namespace.define("WinJS.Class", {define: t, derive: r, mix: o})
    }(e.WinJS)
}(this), function (e, t) {
    "use strict";
    function n(e) {
        return e
    }

    function r(e, t, n) {
        return e.split(".").reduce(function (e, t) {
            return e ? n(e[t]) : null
        }, t)
    }

    var o = !!e.Windows, i = {notSupportedForProcessing: "Value is not supported within a declarative processing context, if you want it to be supported mark it using WinJS.Utilities.markSupportedForProcessing. The value was: '{0}'"};
    t.Namespace.define("WinJS.Utilities", {
        _setHasWinRT: {
            value: function (e) {
                o = e
            }, configurable: !1, writable: !1, enumerable: !1
        }, hasWinRT: {
            get: function () {
                return o
            }, configurable: !1, enumerable: !0
        }, _getMemberFiltered: r, getMember: function (t, o) {
            return t ? r(t, o || e, n) : null
        }, ready: function (n, r) {
            return new t.Promise(function (o, i) {
                function a() {
                    if (n)try {
                        n(), o()
                    } catch (e) {
                        i(e)
                    } else o()
                }

                var s = t.Utilities.testReadyState;
                s || (s = e.document ? document.readyState : "complete"), "complete" === s || e.document && null !== document.body ? r ? e.setImmediate(a) : a() : e.addEventListener("DOMContentLoaded", a, !1)
            })
        }, strictProcessing: {
            get: function () {
                return !0
            }, configurable: !1, enumerable: !0
        }, markSupportedForProcessing: {
            value: function (e) {
                return e.supportedForProcessing = !0, e
            }, configurable: !1, writable: !1, enumerable: !0
        }, requireSupportedForProcessing: {
            value: function (n) {
                var r = !0;
                switch (r = r && !(n === e), r = r && !(n === e.location), r = r && !(n instanceof HTMLIFrameElement), r = r && !("function" == typeof n && !n.supportedForProcessing), e.frames.length) {
                    case 0:
                        break;
                    case 1:
                        r = r && !(n === e.frames[0]);
                        break;
                    default:
                        for (var o = 0, a = e.frames.length; r && a > o; o++)r = r && !(n === e.frames[o])
                }
                if (r)return n;
                throw new t.ErrorFromName("WinJS.Utilities.requireSupportedForProcessing", t.Resources._formatString(i.notSupportedForProcessing, n))
            }, configurable: !1, writable: !1, enumerable: !0
        }
    }), t.Namespace.define("WinJS", {
        validation: !1, strictProcessing: {
            value: function () {
            }, configurable: !1, writable: !1, enumerable: !1
        }
    })
}(this, this.WinJS), function (e) {
    "use strict";
    function t(e, t, n) {
        var r = e;
        return "function" == typeof r && (r = r()), (n && i.test(n) ? "" : n ? n + ": " : "") + (t ? t.replace(o, ":") + ": " : "") + r
    }

    function n(t, n, r) {
        var o = e.Utilities.formatLog(t, n, r);
        console[r && i.test(r) ? r : "log"](o)
    }

    function r(e) {
        return e.replace(/[-[\]{}()*+?.,\\^$|#]/g, "\\$&")
    }

    var o = /\s+/g, i = /^(error|warn|info|log)$/;
    e.Namespace.define("WinJS.Utilities", {
        startLog: function (t) {
            t = t || {}, "string" == typeof t && (t = {tags: t});
            var i = t.type && new RegExp("^(" + r(t.type).replace(o, " ").split(" ").join("|") + ")$"), a = t.excludeTags && new RegExp("(^|\\s)(" + r(t.excludeTags).replace(o, " ").split(" ").join("|") + ")(\\s|$)", "i"), s = t.tags && new RegExp("(^|\\s)(" + r(t.tags).replace(o, " ").split(" ").join("|") + ")(\\s|$)", "i"), c = t.action || n;
            if (!(i || a || s || e.log))return void(e.log = c);
            var u = function (e, t, n) {
                i && !i.test(n) || a && a.test(t) || s && !s.test(t) || c(e, t, n), u.next && u.next(e, t, n)
            };
            u.next = e.log, e.log = u
        }, stopLog: function () {
            delete e.log
        }, formatLog: t
    })
}(this.WinJS), function (e, t) {
    "use strict";
    function n(e) {
        var t = "_on" + e + "state";
        return {
            get: function () {
                var e = this[t];
                return e && e.userHandler
            }, set: function (n) {
                var r = this[t];
                n ? (r || (r = {
                    wrapper: function (e) {
                        return r.userHandler(e)
                    }, userHandler: n
                }, Object.defineProperty(this, t, {
                    value: r,
                    enumerable: !1,
                    writable: !0,
                    configurable: !0
                }), this.addEventListener(e, r.wrapper, !1)), r.userHandler = n) : r && (this.removeEventListener(e, r.wrapper, !1), this[t] = null)
            }, enumerable: !0
        }
    }

    function r(e) {
        for (var t = {}, r = 0, o = arguments.length; o > r; r++) {
            var i = arguments[r];
            t["on" + i] = n(i)
        }
        return t
    }

    var o = e.Class.define(function (e, t, n) {
        this.detail = t, this.target = n, this.timeStamp = Date.now(), this.type = e
    }, {
        bubbles: {value: !1, writable: !1},
        cancelable: {value: !1, writable: !1},
        currentTarget: {
            get: function () {
                return this.target
            }
        },
        defaultPrevented: {
            get: function () {
                return this._preventDefaultCalled
            }
        },
        trusted: {value: !1, writable: !1},
        eventPhase: {value: 0, writable: !1},
        target: null,
        timeStamp: null,
        type: null,
        preventDefault: function () {
            this._preventDefaultCalled = !0
        },
        stopImmediatePropagation: function () {
            this._stopImmediatePropagationCalled = !0
        },
        stopPropagation: function () {
        }
    }, {supportedForProcessing: !1}), i = {
        _listeners: null, addEventListener: function (e, t, n) {
            n = n || !1, this._listeners = this._listeners || {};
            for (var r = this._listeners[e] = this._listeners[e] || [], o = 0, i = r.length; i > o; o++) {
                var a = r[o];
                if (a.useCapture === n && a.listener === t)return
            }
            r.push({listener: t, useCapture: n})
        }, dispatchEvent: function (e, t) {
            var n = this._listeners && this._listeners[e];
            if (n) {
                var r = new o(e, t, this);
                n = n.slice(0, n.length);
                for (var i = 0, a = n.length; a > i && !r._stopImmediatePropagationCalled; i++)n[i].listener(r);
                return r.defaultPrevented || !1
            }
            return !1
        }, removeEventListener: function (e, t, n) {
            n = n || !1;
            var r = this._listeners && this._listeners[e];
            if (r)for (var o = 0, i = r.length; i > o; o++) {
                var a = r[o];
                if (a.listener === t && a.useCapture === n) {
                    r.splice(o, 1), 0 === r.length && delete this._listeners[e];
                    break
                }
            }
        }
    };
    e.Namespace.define("WinJS.Utilities", {_createEventProperty: n, createEventProperties: r, eventMixin: i})
}(this.WinJS), function (e, t, n) {
    "use strict";
    var r, o = !1, i = "contextchanged", a = t.Class.mix(t.Class.define(null, {}, {supportedForProcessing: !1}), t.Utilities.eventMixin), s = new a, c = {malformedFormatStringInput: "Malformed, did you mean to escape your '{0}'?"};
    t.Namespace.define("WinJS.Resources", {
        addEventListener: function (e, n, r) {
            if (t.Utilities.hasWinRT && !o && e === i)try {
                Windows.ApplicationModel.Resources.Core.ResourceManager.current.defaultContext.qualifierValues.addEventListener("mapchanged", function (e) {
                    t.Resources.dispatchEvent(i, {qualifier: e.key, changed: e.target[e.key]})
                }, !1), o = !0
            } catch (a) {
            }
            s.addEventListener(e, n, r)
        },
        removeEventListener: s.removeEventListener.bind(s),
        dispatchEvent: s.dispatchEvent.bind(s),
        _formatString: function (e) {
            var n = arguments;
            return n.length > 1 && (e = e.replace(/({{)|(}})|{(\d+)}|({)|(})/g, function (e, r, o, i, a, s) {
                if (a || s)throw t.Resources._formatString(c.malformedFormatStringInput, a || s);
                return r && "{" || o && "}" || n[(0 | i) + 1]
            })), e
        },
        _getStringWinRT: function (e) {
            if (!r) {
                var t = Windows.ApplicationModel.Resources.Core.ResourceManager.current.mainResourceMap;
                try {
                    r = t.getSubtree("Resources")
                } catch (o) {
                }
                r || (r = t)
            }
            var i, a, s;
            try {
                s = r.getValue(e), s && (i = s.valueAsString, i === n && (i = s.toString()))
            } catch (o) {
            }
            if (!i)return {value: e, empty: !0};
            try {
                a = s.getQualifierValue("Language")
            } catch (o) {
                return {value: i}
            }
            return {value: i, lang: a}
        },
        _getStringJS: function (t) {
            var n = e.strings && e.strings[t];
            return "string" == typeof n && (n = {value: n}), n || {value: t, empty: !0}
        }
    }), Object.defineProperties(t.Resources, t.Utilities.createEventProperties(i));
    var u;
    t.Resources.getString = function (e) {
        return (u = u || (t.Utilities.hasWinRT ? t.Resources._getStringWinRT : t.Resources._getStringJS))(e)
    }
}(this, this.WinJS), function (e, t, n) {
    "use strict";
    function r() {
    }

    function o(e, t) {
        var n;
        n = t && "object" == typeof t && "function" == typeof t.then ? O : N, e._value = t, e._setState(n)
    }

    function i(e, t, n, r, o, i) {
        return {exception: e, error: t, promise: n, handler: i, id: r, parent: o}
    }

    function a(e, t, n, r) {
        var o = n._isException, a = n._errorId;
        return i(o ? t : null, o ? null : t, e, a, n, r)
    }

    function s(e, t, n) {
        var r = n._isException, o = n._errorId;
        return v(e, o, r), i(r ? t : null, r ? null : t, e, o, n)
    }

    function c(e, t) {
        var n = ++D;
        return v(e, n), i(null, t, e, n)
    }

    function u(e, t) {
        var n = ++D;
        return v(e, n, !0), i(t, null, e, n)
    }

    function l(e, t, n, r) {
        g(e, {c: t, e: n, p: r})
    }

    function f(e, t, n, r) {
        e._value = t, h(e, t, n, r), e._setState(F)
    }

    function p(e, t) {
        var n = e._value, r = e._listeners;
        if (r) {
            e._listeners = null;
            var o, i;
            for (o = 0, i = Array.isArray(r) ? r.length : 1; i > o; o++) {
                var a = 1 === i ? r : r[o], s = a.c, c = a.promise;
                if (c) {
                    try {
                        c._setCompleteValue(s ? s(n) : n)
                    } catch (u) {
                        c._setExceptionValue(u)
                    }
                    c._state !== O && c._listeners && t.push(c)
                } else B.prototype.done.call(e, s)
            }
        }
    }

    function d(e, t) {
        var n = e._value, r = e._listeners;
        if (r) {
            e._listeners = null;
            var o, i;
            for (o = 0, i = Array.isArray(r) ? r.length : 1; i > o; o++) {
                var s = 1 === i ? r : r[o], c = s.e, u = s.promise;
                if (u) {
                    try {
                        c ? (c.handlesOnError || h(u, n, a, e, c), u._setCompleteValue(c(n))) : u._setChainedErrorValue(n, e)
                    } catch (l) {
                        u._setExceptionValue(l)
                    }
                    u._state !== O && u._listeners && t.push(u)
                } else H.prototype.done.call(e, null, c)
            }
        }
    }

    function h(e, t, n, r, o) {
        if (P._listeners[C]) {
            if (t instanceof Error && t.message === k)return;
            P.dispatchEvent(C, n(e, t, r, o))
        }
    }

    function m(e, t) {
        var n = e._listeners;
        if (n) {
            var r, o;
            for (r = 0, o = Array.isArray(n) ? n.length : 1; o > r; r++) {
                var i = 1 === o ? n : n[r], a = i.p;
                if (a)try {
                    a(t)
                } catch (s) {
                }
                i.c || i.e || !i.promise || i.promise._progress(t)
            }
        }
    }

    function g(e, t) {
        var n = e._listeners;
        n ? (n = Array.isArray(n) ? n : [n], n.push(t)) : n = t, e._listeners = n
    }

    function v(e, t, n) {
        e._isException = n || !1, e._errorId = t
    }

    function w(e, t, n, r) {
        e._value = t, h(e, t, n, r), e._setState(R)
    }

    function y(e, t) {
        var n;
        n = t && "object" == typeof t && "function" == typeof t.then ? O : W, e._value = t, e._setState(n)
    }

    function b(e, t, n, r) {
        var o = new j(e);
        return g(e, {promise: o, c: t, e: n, p: r}), o
    }

    function _(e) {
        var n;
        return new t.Promise(function (t) {
            e ? n = setTimeout(t, e) : setImmediate(t)
        }, function () {
            n && clearTimeout(n)
        })
    }

    function S(e, t) {
        var n = function () {
            t.cancel()
        }, r = function () {
            e.cancel()
        };
        return e.then(n), t.then(r, r), t
    }

    e.Debug && (e.Debug.setNonUserCodeExceptions = !0);
    var E = t.Class.mix(t.Class.define(null, {}, {supportedForProcessing: !1}), t.Utilities.eventMixin), P = new E;
    P._listeners = {};
    var C = "error", k = "Canceled", A = !1, M = {
        promise: 1,
        thenPromise: 2,
        errorPromise: 4,
        exceptionPromise: 8,
        completePromise: 16
    };
    M.all = M.promise | M.thenPromise | M.errorPromise | M.exceptionPromise | M.completePromise;
    var x, T, O, I, L, U, N, W, F, R, D = 1;
    x = {
        name: "created",
        enter: function (e) {
            e._setState(T)
        },
        cancel: r,
        done: r,
        then: r,
        _completed: r,
        _error: r,
        _notify: r,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, T = {
        name: "working", enter: r, cancel: function (e) {
            e._setState(L)
        }, done: l, then: b, _completed: o, _error: f, _notify: r, _progress: m, _setCompleteValue: y, _setErrorValue: w
    }, O = {
        name: "waiting", enter: function (e) {
            var t = e._value, n = function (r) {
                t._errorId ? e._chainedError(r, t) : (h(e, r, a, t, n), e._error(r))
            };
            n.handlesOnError = !0, t.then(e._completed.bind(e), n, e._progress.bind(e))
        }, cancel: function (e) {
            e._setState(I)
        }, done: l, then: b, _completed: o, _error: f, _notify: r, _progress: m, _setCompleteValue: y, _setErrorValue: w
    }, I = {
        name: "waiting_canceled",
        enter: function (e) {
            e._setState(U);
            var t = e._value;
            t.cancel && t.cancel()
        },
        cancel: r,
        done: l,
        then: b,
        _completed: o,
        _error: f,
        _notify: r,
        _progress: m,
        _setCompleteValue: y,
        _setErrorValue: w
    }, L = {
        name: "canceled",
        enter: function (e) {
            e._setState(U), e._cancelAction()
        },
        cancel: r,
        done: l,
        then: b,
        _completed: o,
        _error: f,
        _notify: r,
        _progress: m,
        _setCompleteValue: y,
        _setErrorValue: w
    }, U = {
        name: "canceling",
        enter: function (e) {
            var t = new Error(k);
            t.name = t.message, e._value = t, e._setState(F)
        },
        cancel: r,
        done: r,
        then: r,
        _completed: r,
        _error: r,
        _notify: r,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, N = {
        name: "complete_notify",
        enter: function (e) {
            if (e.done = B.prototype.done, e.then = B.prototype.then, e._listeners)for (var t, n = [e]; n.length;)t = n.pop(), t._state._notify(t, n);
            e._setState(W)
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: p,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, W = {
        name: "success",
        enter: function (e) {
            e.done = B.prototype.done, e.then = B.prototype.then, e._cleanupAction()
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: p,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, F = {
        name: "error_notify",
        enter: function (e) {
            if (e.done = H.prototype.done, e.then = H.prototype.then, e._listeners)for (var t, n = [e]; n.length;)t = n.pop(), t._state._notify(t, n);
            e._setState(R)
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: d,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, R = {
        name: "error",
        enter: function (e) {
            e.done = H.prototype.done, e.then = H.prototype.then, e._cleanupAction()
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: d,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    };
    var K, z = t.Class.define(null, {
        _listeners: null,
        _nextState: null,
        _state: null,
        _value: null,
        cancel: function () {
            this._state.cancel(this), this._run()
        },
        done: function (e, t, n) {
            this._state.done(this, e, t, n)
        },
        then: function (e, t, n) {
            return this._state.then(this, e, t, n)
        },
        _chainedError: function (e, t) {
            var n = this._state._error(this, e, s, t);
            return this._run(), n
        },
        _completed: function (e) {
            var t = this._state._completed(this, e);
            return this._run(), t
        },
        _error: function (e) {
            var t = this._state._error(this, e, c);
            return this._run(), t
        },
        _progress: function (e) {
            this._state._progress(this, e)
        },
        _setState: function (e) {
            this._nextState = e
        },
        _setCompleteValue: function (e) {
            this._state._setCompleteValue(this, e), this._run()
        },
        _setChainedErrorValue: function (e, t) {
            var n = this._state._setErrorValue(this, e, s, t);
            return this._run(), n
        },
        _setExceptionValue: function (e) {
            var t = this._state._setErrorValue(this, e, u);
            return this._run(), t
        },
        _run: function () {
            for (; this._nextState;)this._state = this._nextState, this._nextState = null, this._state.enter(this)
        }
    }, {supportedForProcessing: !1}), j = t.Class.derive(z, function (e) {
        A && (A === !0 || A & M.thenPromise) && (this._stack = t.Promise._getStack()), this._creator = e, this._setState(x), this._run()
    }, {
        _creator: null, _cancelAction: function () {
            this._creator && this._creator.cancel()
        }, _cleanupAction: function () {
            this._creator = null
        }
    }, {supportedForProcessing: !1}), H = t.Class.define(function (e) {
        A && (A === !0 || A & M.errorPromise) && (this._stack = t.Promise._getStack()), this._value = e, h(this, e, c)
    }, {
        cancel: function () {
        }, done: function (e, t) {
            var n = this._value;
            if (t)try {
                t.handlesOnError || h(null, n, a, this, t);
                var r = t(n);
                return void(r && "object" == typeof r && "function" == typeof r.done && r.done())
            } catch (o) {
                n = o
            }
            n instanceof Error && n.message === k || setImmediate(function () {
                throw n
            })
        }, then: function (e, t) {
            if (!t)return this;
            var n, r = this._value;
            try {
                t.handlesOnError || h(null, r, a, this, t), n = new B(t(r))
            } catch (o) {
                n = o === r ? this : new q(o)
            }
            return n
        }
    }, {supportedForProcessing: !1}), q = t.Class.derive(H, function (e) {
        A && (A === !0 || A & M.exceptionPromise) && (this._stack = t.Promise._getStack()), this._value = e, h(this, e, u)
    }, {}, {supportedForProcessing: !1}), B = t.Class.define(function (e) {
        if (A && (A === !0 || A & M.completePromise) && (this._stack = t.Promise._getStack()), e && "object" == typeof e && "function" == typeof e.then) {
            var n = new j(null);
            return n._setCompleteValue(e), n
        }
        this._value = e
    }, {
        cancel: function () {
        }, done: function (e) {
            if (e)try {
                var t = e(this._value);
                t && "object" == typeof t && "function" == typeof t.done && t.done()
            } catch (n) {
                setImmediate(function () {
                    throw n
                })
            }
        }, then: function (e) {
            try {
                var t = e ? e(this._value) : this._value;
                return t === this._value ? this : new B(t)
            } catch (n) {
                return new q(n)
            }
        }
    }, {supportedForProcessing: !1}), Y = t.Class.derive(z, function (e, n) {
        A && (A === !0 || A & M.promise) && (this._stack = t.Promise._getStack()), this._oncancel = n, this._setState(x), this._run();
        try {
            var r = this._completed.bind(this), o = this._error.bind(this), i = this._progress.bind(this);
            e(r, o, i)
        } catch (a) {
            this._setExceptionValue(a)
        }
    }, {
        _oncancel: null, _cancelAction: function () {
            try {
                if (!this._oncancel)throw new Error("Promise did not implement oncancel");
                this._oncancel()
            } catch (e) {
                e.message, e.stack;
                P.dispatchEvent("error", e)
            }
        }, _cleanupAction: function () {
            this._oncancel = null
        }
    }, {
        addEventListener: function (e, t, n) {
            P.addEventListener(e, t, n)
        }, any: function (e) {
            return new Y(function (n, r, o) {
                var i = Object.keys(e);
                Array.isArray(e) ? [] : {};
                0 === i.length && n();
                var a = 0;
                i.forEach(function (o) {
                    Y.as(e[o]).then(function () {
                        n({key: o, value: e[o]})
                    }, function (s) {
                        return s instanceof Error && s.name === k ? void(++a === i.length && n(t.Promise.cancel)) : void r({
                            key: o,
                            value: e[o]
                        })
                    })
                })
            }, function () {
                var t = Object.keys(e);
                t.forEach(function (t) {
                    var n = Y.as(e[t]);
                    "function" == typeof n.cancel && n.cancel()
                })
            })
        }, as: function (e) {
            return e && "object" == typeof e && "function" == typeof e.then ? e : new B(e)
        }, cancel: {
            get: function () {
                return K = K || new H(new t.ErrorFromName(k))
            }
        }, dispatchEvent: function (e, t) {
            return P.dispatchEvent(e, t)
        }, is: function (e) {
            return e && "object" == typeof e && "function" == typeof e.then
        }, join: function (e) {
            return new Y(function (r, o, i) {
                var a = Object.keys(e), s = Array.isArray(e) ? [] : {}, c = Array.isArray(e) ? [] : {}, u = 0, l = a.length, f = function (e) {
                    if (0 === --l) {
                        var n = Object.keys(s).length;
                        if (0 === n)r(c); else {
                            var u = 0;
                            a.forEach(function (e) {
                                var t = s[e];
                                t instanceof Error && t.name === k && u++
                            }), u === n ? r(t.Promise.cancel) : o(s)
                        }
                    } else i({Key: e, Done: !0})
                };
                return a.forEach(function (t) {
                    var r = e[t];
                    r === n ? u++ : Y.then(r, function (e) {
                        c[t] = e, f(t)
                    }, function (e) {
                        s[t] = e, f(t)
                    })
                }), l -= u, 0 === l ? void r(c) : void 0
            }, function () {
                Object.keys(e).forEach(function (t) {
                    var n = Y.as(e[t]);
                    "function" == typeof n.cancel && n.cancel()
                })
            })
        }, removeEventListener: function (e, t, n) {
            P.removeEventListener(e, t, n)
        }, supportedForProcessing: !1, then: function (e, t, n, r) {
            return Y.as(e).then(t, n, r)
        }, thenEach: function (e, t, n, r) {
            var o = Array.isArray(e) ? [] : {};
            return Object.keys(e).forEach(function (i) {
                o[i] = Y.as(e[i]).then(t, n, r)
            }), Y.join(o)
        }, timeout: function (e, t) {
            var n = _(e);
            return t ? S(n, t) : n
        }, wrap: function (e) {
            return new B(e)
        }, wrapError: function (e) {
            return new H(e)
        }, _veryExpensiveTagWithStack: {
            get: function () {
                return A
            }, set: function (e) {
                A = e
            }
        }, _veryExpensiveTagWithStack_tag: M, _getStack: function () {
            if (Debug.debuggerEnabled)try {
                throw new Error
            } catch (e) {
                return e.stack
            }
        }
    });
    Object.defineProperties(Y, t.Utilities.createEventProperties(C));
    var V = t.Class.derive(z, function (e) {
        this._oncancel = e, this._setState(x), this._run()
    }, {
        _cancelAction: function () {
            this._oncancel && this._oncancel()
        }, _cleanupAction: function () {
            this._oncancel = null
        }
    }, {supportedForProcessing: !1}), Q = t.Class.define(function (e) {
        this._promise = new V(e)
    }, {
        promise: {
            get: function () {
                return this._promise
            }
        }, cancel: function () {
            this._promise.cancel()
        }, complete: function (e) {
            this._promise._completed(e)
        }, error: function (e) {
            this._promise._error(e)
        }, progress: function (e) {
            this._promise._progress(e)
        }
    }, {supportedForProcessing: !1});
    t.Namespace.define("WinJS", {Promise: Y, _Signal: Q})
}(this, this.WinJS), function (e, t) {
    "use strict";
    t.Namespace.define("WinJS", {
        ErrorFromName: t.Class.derive(Error, function (e, t) {
            this.name = e, this.message = t || e
        }, {}, {supportedForProcessing: !1})
    })
}(this, this.WinJS), function (e) {
    "use strict";
    e.Namespace.define("WinJS", {
        xhr: function (t) {
            var n;
            return new e.Promise(function (e, r, o) {
                n = new XMLHttpRequest, n.onreadystatechange = function () {
                    n._canceled || (4 === n.readyState ? (n.status >= 200 && n.status < 300 || 1223 === n.status ? e(n) : r(n), n.onreadystatechange = function () {
                    }) : o(n))
                }, n.open(t.type || "GET", t.url, !0, t.user, t.password), n.responseType = t.responseType || "", Object.keys(t.headers || {}).forEach(function (e) {
                    n.setRequestHeader(e, t.headers[e])
                }), t.customRequestInitializer && t.customRequestInitializer(n), n.send(t.data)
            }, function () {
                n._canceled = !0, n.abort()
            })
        }
    })
}(this.WinJS), function (e, t, n) {
    "use strict";
    var r, o, i, a, s, c, u = {nonStaticHTML: "Unable to add dynamic content. A script attempted to inject dynamic content, or elements previously modified dynamically, that might be unsafe. For example, using the innerHTML property or the document.write method to add a script element will generate this exception. If the content is safe and from a trusted source, use a method to explicitly manipulate elements and attributes, such as createElement, or use setInnerHTMLUnsafe (or other unsafe method)."};
    r = o = function (e, t) {
        e.innerHTML = t
    }, i = a = function (e, t) {
        e.outerHTML = t
    }, s = c = function (e, t, n) {
        e.insertAdjacentHTML(t, n)
    };
    var l = e.MSApp;
    if (l)o = function (e, t) {
        l.execUnsafeLocalFunction(function () {
            e.innerHTML = t
        })
    }, a = function (e, t) {
        l.execUnsafeLocalFunction(function () {
            e.outerHTML = t
        })
    }, c = function (e, t, n) {
        l.execUnsafeLocalFunction(function () {
            e.insertAdjacentHTML(t, n)
        })
    }; else if (e.msIsStaticHTML) {
        var f = function (n) {
            if (!e.msIsStaticHTML(n))throw new t.ErrorFromName("WinJS.Utitilies.NonStaticHTML", u.nonStaticHTML)
        };
        r = function (e, t) {
            f(t), e.innerHTML = t
        }, i = function (e, t) {
            f(t), e.outerHTML = t
        }, s = function (e, t, n) {
            f(n), e.insertAdjacentHTML(t, n)
        }
    }
    t.Namespace.define("WinJS.Utilities", {
        setInnerHTML: r,
        setInnerHTMLUnsafe: o,
        setOuterHTML: i,
        setOuterHTMLUnsafe: a,
        insertAdjacentHTML: s,
        insertAdjacentHTMLUnsafe: c
    })
}(this, this.WinJS)), function (e) {
    "undefined" == typeof exports && "function" == typeof define && define.amd ? define("vs/base/common/winjs.base.raw", e.WinJS) : module.exports = e.WinJS
}(this), define("vs/base/node/flow", ["require", "exports", "assert"], function (e, t, n) {
    "use strict";
    function r(e, t, n) {
        var r = new Array(e.length), o = new Array(e.length), i = !1, a = 0;
        return 0 === e.length ? n(null, []) : void e.forEach(function (s, c) {
            t(s, function (t, s) {
                return t ? (i = !0, r[c] = null, o[c] = t) : (r[c] = s, o[c] = null), ++a === e.length ? n(i ? o : null, r) : void 0
            })
        })
    }

    function o(e, t, r) {
        if (n.ok(e, "Missing first parameter"), n.ok("function" == typeof t, "Second parameter must be a function that is called for each element"), n.ok("function" == typeof r, "Third parameter must be a function that is called on error and success"), "function" == typeof e)try {
            e(function (e, n) {
                e ? r(e, null) : o(n, t, r)
            })
        } catch (i) {
            r(i, null)
        } else {
            var a = [], s = function (n) {
                if (n < e.length)try {
                    t(e[n], function (e, t) {
                        e !== !0 && e !== !1 || (t = e, e = null), e ? r(e, null) : (t && a.push(t), process.nextTick(function () {
                            s(n + 1)
                        }))
                    }, n, e.length)
                } catch (o) {
                    r(o, null)
                } else r(null, a)
            };
            s(0)
        }
    }

    function i(e) {
        n.ok(e.length > 1, "Need at least one error handler and one function to process sequence"), e.forEach(function (e) {
            n.ok("function" == typeof e)
        });
        var t = e.splice(0, 1)[0], r = null;
        o(e, function (e, t) {
            var n = function (e, n) {
                e !== !0 && e !== !1 || (n = e, e = null), e ? t(e, null) : (r = n, t(null, null))
            };
            try {
                e.call(n, r)
            } catch (o) {
                t(o, null)
            }
        }, function (e, n) {
            e && t(e)
        })
    }

    function a(e) {
        i(Array.isArray(e) ? e : Array.prototype.slice.call(arguments))
    }

    t.parallel = r, t.loop = o, t.sequence = a
}), define("vs/base/node/extfs", ["require", "exports", "vs/base/common/uuid", "vs/base/common/strings", "vs/base/common/platform", "vs/base/node/flow", "fs", "path"], function (e, t, n, r, o, i, a, s) {
    "use strict";
    function c(e, t) {
        return o.isMacintosh ? u(e, function (e, n) {
            return e ? t(e, null) : t(null, n.map(function (e) {
                return r.normalizeNFC(e)
            }))
        }) : u(e, t)
    }

    function u(e, t) {
        a.readdir(e, function (e, n) {
            return e ? t(e, null) : t(null, n.filter(function (e) {
                return "." !== e && ".." !== e
            }))
        })
    }

    function l(e, t, n) {
        a.exists(e, function (r) {
            return r ? f(e, function (t, r) {
                return t ? n(t) : r ? void n(null) : n(new Error('"' + e + '" is not a directory.'))
            }) : void l(s.dirname(e), t, function (r) {
                return r ? void n(r) : void(t ? a.mkdir(e, t, function (r) {
                    return r ? n(r) : void a.chmod(e, t, n)
                }) : a.mkdir(e, null, n))
            })
        })
    }

    function f(e, t) {
        a.stat(e, function (e, n) {
            return e ? t(e) : void t(null, n.isDirectory())
        })
    }

    function p(e, t, n, r) {
        r || (r = Object.create(null)), a.stat(e, function (o, i) {
            return o ? n(o) : i.isDirectory() ? r[e] ? n(null) : (r[e] = !0, void l(t, 511 & i.mode, function (o) {
                c(e, function (o, i) {
                    v(i, function (n, o) {
                        p(s.join(e, n), s.join(t, n), o, r)
                    }, n)
                })
            })) : d(e, t, 511 & i.mode, n)
        })
    }

    function d(e, t, n, r) {
        var o = !1, i = a.createReadStream(e), s = a.createWriteStream(t, {mode: n}), c = function (e) {
            o || (o = !0, r(e))
        };
        i.on("error", c), s.on("error", c), i.on("end", function () {
            s.end(function () {
                o || (o = !0, a.chmod(t, n, r))
            })
        }), i.pipe(s, {end: !1})
    }

    function h(e, t, o, i) {
        a.exists(e, function (c) {
            return c ? void a.stat(e, function (c, u) {
                if (c || !u)return o(c);
                if ("." === e[e.length - 1] || r.endsWith(e, "./") || r.endsWith(e, ".\\"))return m(e, o);
                var l = s.join(t, n.generateUuid());
                a.rename(e, l, function (t) {
                    return t ? m(e, o) : (o(null), void m(l, function (e) {
                        e && console.error(e), i && i(e)
                    }))
                })
            }) : o(null)
        })
    }

    function m(e, t) {
        return "\\" === e || "/" === e ? t(new Error("Will not delete root!")) : void a.exists(e, function (n) {
            n ? a.lstat(e, function (n, r) {
                if (n || !r)t(n); else if (!r.isDirectory() || r.isSymbolicLink()) {
                    var o = r.mode;
                    128 & o ? a.unlink(e, t) : a.chmod(e, 128 | o, function (n) {
                        n ? t(n) : a.unlink(e, t)
                    })
                } else c(e, function (n, r) {
                    if (n || !r)t(n); else if (0 === r.length)a.rmdir(e, t); else {
                        var o = null, i = r.length;
                        r.forEach(function (n) {
                            m(s.join(e, n), function (n) {
                                i--, n && (o = o || n), 0 === i && (o ? t(o) : a.rmdir(e, t))
                            })
                        })
                    }
                })
            }) : t(null)
        })
    }

    function g(e, t, n) {
        function o(e) {
            return e ? n(e) : void a.stat(t, function (e, r) {
                return e ? n(e) : r.isDirectory() ? n(null) : void a.open(t, "a", null, function (e, t) {
                    return e ? n(e) : void a.futimes(t, r.atime, new Date, function (e) {
                        return e ? n(e) : void a.close(t, n)
                    })
                })
            })
        }

        return e === t ? n(null) : void a.rename(e, t, function (i) {
            return i ? i && e.toLowerCase() !== t.toLowerCase() && "EXDEV" === i.code || r.endsWith(e, ".") ? p(e, t, function (t) {
                return t ? n(t) : void m(e, o)
            }) : n(i) : o(null)
        })
    }

    var v = i.loop;
    t.readdir = c, t.mkdirp = l, t.copy = p, t.del = h, t.mv = g
}), define("vs/base/node/proxy", ["require", "exports", "url", "vs/base/common/types", "http-proxy-agent", "https-proxy-agent"], function (e, t, n, r, o, i) {
    "use strict";
    function a(e) {
        return "http:" === e.protocol ? process.env.HTTP_PROXY || process.env.http_proxy || null : "https:" === e.protocol ? process.env.HTTPS_PROXY || process.env.https_proxy || process.env.HTTP_PROXY || process.env.http_proxy || null : null
    }

    function s(e, t) {
        void 0 === t && (t = {});
        var s = n.parse(e), c = t.proxyUrl || a(s);
        if (!c)return null;
        var u = n.parse(c);
        if (!/^https?:$/.test(u.protocol))return null;
        var l = {
            host: u.hostname,
            port: Number(u.port),
            auth: u.auth,
            rejectUnauthorized: r.isBoolean(t.strictSSL) ? t.strictSSL : !0
        };
        return "http:" === s.protocol ? new o(l) : new i(l)
    }

    t.getProxyAgent = s
}), define("vs/nls!vs/base/common/errors", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/base/common/errors", t)
}), define("vs/base/common/errors", ["require", "exports", "vs/nls!vs/base/common/errors", "vs/base/common/objects", "vs/base/common/platform", "vs/base/common/types", "vs/base/common/arrays", "vs/base/common/strings"], function (e, t, n, r, o, i, a, s) {
    "use strict";
    function c(e) {
        t.errorHandler.setUnexpectedErrorHandler(e)
    }

    function u(e) {
        g(e) || t.errorHandler.onUnexpectedError(e)
    }

    function l(e) {
        return e.then(null, u)
    }

    function f(e) {
        if (e instanceof Error) {
            var t = e.name, n = e.message, r = e.stacktrace || e.stack;
            return {$isError: !0, name: t, message: n, stack: r}
        }
        return e
    }

    function p(e, t) {
        var n = new C(e);
        return t ? n.verboseMessage : n.message
    }

    function d(e, t) {
        return e.message ? t && (e.stack || e.stacktrace) ? n.localize(7, null, h(e), e.stack || e.stacktrace) : h(e) : n.localize(8, null)
    }

    function h(e) {
        return "string" == typeof e.code && "number" == typeof e.errno && "string" == typeof e.syscall ? n.localize(9, null, e.message) : e.message
    }

    function m(e, t) {
        if (void 0 === e && (e = null), void 0 === t && (t = !1), !e)return n.localize(10, null);
        if (Array.isArray(e)) {
            var r = a.coalesce(e), o = m(r[0], t);
            return r.length > 1 ? n.localize(11, null, o, r.length) : o
        }
        if (i.isString(e))return e;
        if (!i.isUndefinedOrNull(e.status))return p(e, t);
        if (e.detail) {
            var s = e.detail;
            if (s.error) {
                if (s.error && !i.isUndefinedOrNull(s.error.status))return p(s.error, t);
                if (!i.isArray(s.error))return d(s.error, t);
                for (var c = 0; c < s.error.length; c++)if (s.error[c] && !i.isUndefinedOrNull(s.error[c].status))return p(s.error[c], t)
            }
            if (s.exception)return i.isUndefinedOrNull(s.exception.status) ? d(s.exception, t) : p(s.exception, t)
        }
        return e.stack ? d(e, t) : e.message ? e.message : n.localize(12, null)
    }

    function g(e) {
        return e instanceof Error && e.name === k && e.message === k
    }

    function v() {
        var e = new Error(k);
        return e.name = e.message, e
    }

    function w() {
        return new Error(n.localize(13, null))
    }

    function y(e) {
        return e ? new Error(n.localize(14, null, e)) : new Error(n.localize(15, null))
    }

    function b(e) {
        return e ? new Error(n.localize(16, null, e)) : new Error(n.localize(17, null))
    }

    function _() {
        return new Error("readonly property cannot be changed")
    }

    function S(e) {
        return o.isWeb ? new Error(n.localize(18, null)) : new Error(n.localize(19, null, JSON.stringify(e)))
    }

    function E(e, t) {
        void 0 === t && (t = {});
        var n = new Error(e);
        return i.isNumber(t.severity) && (n.severity = t.severity), t.actions && (n.actions = t.actions), n
    }

    var P = function () {
        function e() {
            this.listeners = [], this.unexpectedErrorHandler = function (e) {
                o.setTimeout(function () {
                    if (e.stack)throw new Error(e.message + "\n\n" + e.stack);
                    throw e
                }, 0)
            }
        }

        return e.prototype.addListener = function (e) {
            var t = this;
            return this.listeners.push(e), function () {
                t._removeListener(e)
            }
        }, e.prototype.emit = function (e) {
            this.listeners.forEach(function (t) {
                t(e)
            })
        }, e.prototype._removeListener = function (e) {
            this.listeners.splice(this.listeners.indexOf(e), 1)
        }, e.prototype.setUnexpectedErrorHandler = function (e) {
            this.unexpectedErrorHandler = e
        }, e.prototype.getUnexpectedErrorHandler = function () {
            return this.unexpectedErrorHandler
        }, e.prototype.onUnexpectedError = function (e) {
            this.unexpectedErrorHandler(e), this.emit(e)
        }, e
    }();
    t.ErrorHandler = P, t.errorHandler = new P, t.setUnexpectedErrorHandler = c, t.onUnexpectedError = u, t.onUnexpectedPromiseError = l, t.transformErrorForSerialization = f;
    var C = function () {
        function e(e) {
            this.status = e.status, this.statusText = e.statusText, this.name = "ConnectionError";
            try {
                this.responseText = e.responseText
            } catch (t) {
                this.responseText = ""
            }
            if (this.errorMessage = null, this.errorCode = null, this.errorObject = null, this.responseText)try {
                var n = JSON.parse(this.responseText);
                this.errorMessage = n.message, this.errorCode = n.code, this.errorObject = n
            } catch (r) {
            }
        }

        return Object.defineProperty(e.prototype, "message", {
            get: function () {
                return this.connectionErrorToMessage(this, !1)
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "verboseMessage", {
            get: function () {
                return this.connectionErrorToMessage(this, !0)
            }, enumerable: !0, configurable: !0
        }), e.prototype.connectionErrorDetailsToMessage = function (e, t) {
            var r = e.errorCode, o = e.errorMessage;
            return null !== r && null !== o ? n.localize(0, null, s.rtrim(o, "."), r) : null !== o ? o : t && null !== e.responseText ? e.responseText : null
        }, e.prototype.connectionErrorToMessage = function (e, t) {
            var r = this.connectionErrorDetailsToMessage(e, t);
            return 401 === e.status ? null !== r ? n.localize(1, null, r) : n.localize(2, null) : r ? r : e.status > 0 && null !== e.statusText ? t && null !== e.responseText && e.responseText.length > 0 ? n.localize(3, null, e.statusText, e.status, e.responseText) : n.localize(4, null, e.statusText, e.status) : t && null !== e.responseText && e.responseText.length > 0 ? n.localize(5, null, e.responseText) : n.localize(6, null)
        }, e
    }();
    t.ConnectionError = C, r.derive(Error, C), t.toErrorMessage = m;
    var k = "Canceled";
    t.isPromiseCanceledError = g, t.canceled = v, t.notImplemented = w, t.illegalArgument = y, t.illegalState = b, t.readonly = _, t.loaderError = S, t.create = E
}), define("vs/base/common/callbackList", ["require", "exports", "vs/base/common/errors"], function (e, t, n) {
    "use strict";
    var r = function () {
        function e() {
        }

        return e.prototype.add = function (e, t, n) {
            var r = this;
            void 0 === t && (t = null), this._callbacks || (this._callbacks = [], this._contexts = []), this._callbacks.push(e), this._contexts.push(t), Array.isArray(n) && n.push({
                dispose: function () {
                    return r.remove(e, t)
                }
            })
        }, e.prototype.remove = function (e, t) {
            if (void 0 === t && (t = null), this._callbacks) {
                for (var n = !1, r = 0, o = this._callbacks.length; o > r; r++)if (this._callbacks[r] === e) {
                    if (this._contexts[r] === t)return this._callbacks.splice(r, 1), void this._contexts.splice(r, 1);
                    n = !0
                }
                if (n)throw new Error("When adding a listener with a context, you should remove it with the same context")
            }
        }, e.prototype.invoke = function () {
            for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
            if (this._callbacks) {
                for (var r = [], o = this._callbacks.slice(0), i = this._contexts.slice(0), a = 0, s = o.length; s > a; a++)try {
                    r.push(o[a].apply(i[a], e))
                } catch (c) {
                    n.onUnexpectedError(c)
                }
                return r
            }
        }, e.prototype.isEmpty = function () {
            return !this._callbacks || 0 === this._callbacks.length
        }, e.prototype.dispose = function () {
            this._callbacks = void 0, this._contexts = void 0
        }, e
    }();
    Object.defineProperty(t, "__esModule", {value: !0}), t["default"] = r
}), define("vs/base/common/event", ["require", "exports", "vs/base/common/callbackList"], function (e, t, n) {
    "use strict";
    function r(e, t) {
        return function (n, r, o) {
            var i = e.addListener2(t, function () {
                n.apply(r, arguments)
            });
            return Array.isArray(o) && o.push(i), i
        }
    }

    function o(e, t) {
        return function (n, r, o) {
            return e(function (e) {
                return n(t(e))
            }, r, o)
        }
    }

    var i;
    !function (e) {
        var t = {
            dispose: function () {
            }
        };
        e.None = function () {
            return t
        }
    }(i || (i = {})), Object.defineProperty(t, "__esModule", {value: !0}), t["default"] = i;
    var a = function () {
        function e(e) {
            this._options = e
        }

        return Object.defineProperty(e.prototype, "event", {
            get: function () {
                var t = this;
                return this._event || (this._event = function (r, o, i) {
                    t._callbacks || (t._callbacks = new n["default"]), t._options && t._options.onFirstListenerAdd && t._callbacks.isEmpty() && t._options.onFirstListenerAdd(t), t._callbacks.add(r, o);
                    var a;
                    return a = {
                        dispose: function () {
                            a.dispose = e._noop, t._disposed || (t._callbacks.remove(r, o), t._options && t._options.onLastListenerRemove && t._callbacks.isEmpty() && t._options.onLastListenerRemove(t))
                        }
                    }, Array.isArray(i) && i.push(a), a
                }), this._event
            }, enumerable: !0, configurable: !0
        }), e.prototype.fire = function (e) {
            this._callbacks && this._callbacks.invoke.call(this._callbacks, e)
        }, e.prototype.dispose = function () {
            this._callbacks && (this._callbacks.dispose(), this._callbacks = void 0, this._disposed = !0)
        }, e._noop = function () {
        }, e
    }();
    t.Emitter = a, t.fromEventEmitter = r, t.mapEvent = o;
    var s;
    !function (e) {
        e[e.Idle = 0] = "Idle", e[e.Running = 1] = "Running"
    }(s || (s = {}));
    var c = function () {
        function e() {
            this.buffers = []
        }

        return e.prototype.wrapEvent = function (e) {
            var t = this;
            return function (n, r, o) {
                return e(function (e) {
                    var o = t.buffers[t.buffers.length - 1];
                    o ? o.push(function () {
                        return n.call(r, e)
                    }) : n.call(r, e)
                }, void 0, o)
            }
        }, e.prototype.bufferEvents = function (e) {
            var t = [];
            this.buffers.push(t), e(), this.buffers.pop(), t.forEach(function (e) {
                return e()
            })
        }, e
    }();
    t.EventBufferer = c
}), define("vs/base/common/cancellation", ["require", "exports", "vs/base/common/event"], function (e, t, n) {
    "use strict";
    var r;
    !function (e) {
        e.None = Object.freeze({
            isCancellationRequested: !1,
            onCancellationRequested: n["default"].None
        }), e.Cancelled = Object.freeze({isCancellationRequested: !0, onCancellationRequested: n["default"].None})
    }(r = t.CancellationToken || (t.CancellationToken = {}));
    var o = Object.freeze(function (e, t) {
        var n = setTimeout(e.bind(t), 0);
        return {
            dispose: function () {
                clearTimeout(n)
            }
        }
    }), i = function () {
        function e() {
            this._isCancelled = !1
        }

        return e.prototype.cancel = function () {
            this._isCancelled || (this._isCancelled = !0, this._emitter && (this._emitter.fire(void 0), this._emitter = void 0))
        }, Object.defineProperty(e.prototype, "isCancellationRequested", {
            get: function () {
                return this._isCancelled
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "onCancellationRequested", {
            get: function () {
                return this._isCancelled ? o : (this._emitter || (this._emitter = new n.Emitter), this._emitter.event)
            }, enumerable: !0, configurable: !0
        }), e
    }(), a = function () {
        function e() {
        }

        return Object.defineProperty(e.prototype, "token", {
            get: function () {
                return this._token || (this._token = new i), this._token
            }, enumerable: !0, configurable: !0
        }), e.prototype.cancel = function () {
            this._token ? this._token.cancel() : this._token = r.Cancelled
        }, e.prototype.dispose = function () {
            this.cancel()
        }, e
    }();
    t.CancellationTokenSource = a
}), define("vs/base/common/winjs.base", ["./winjs.base.raw", "vs/base/common/errors"], function (e, t) {
    "use strict";
    function n(e) {
        var n = e.detail, r = n.id;
        return n.parent ? void(n.handler && i && delete i[r]) : (i[r] = n, void(1 === Object.keys(i).length && setTimeout(function () {
            var e = i;
            i = {}, Object.keys(e).forEach(function (n) {
                var r = e[n];
                r.exception ? t.onUnexpectedError(r.exception) : r.error && t.onUnexpectedError(r.error), console.log("WARNING: Promise with no error callback:" + r.id), console.log(r), r.exception && console.log(r.exception.stack)
            })
        }, 0)))
    }

    function r(e, t, n) {
        var r, i, a, s = new o.Promise(function (e, t, n) {
            r = e, i = t, a = n
        }, function () {
            e.cancel()
        });
        return e.then(function (e) {
            t && t(e), r(e)
        }, function (e) {
            n && n(e), i(e)
        }, a), s
    }

    var o = e, i = {};
    return o.Promise.addEventListener("error", n), {
        decoratePromise: r,
        Class: o.Class,
        xhr: o.xhr,
        Promise: o.Promise,
        TPromise: o.Promise,
        PPromise: o.Promise,
        Utilities: o.Utilities
    }
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/base/common/async", ["require", "exports", "vs/base/common/errors", "vs/base/common/winjs.base", "vs/base/common/platform", "vs/base/common/cancellation", "vs/base/common/lifecycle"], function (e, t, n, r, o, i, a) {
    "use strict";
    function s(e) {
        return e && "function" == typeof e.then
    }

    function c(e) {
        var t = new i.CancellationTokenSource;
        return new r.TPromise(function (n, r) {
            var o = e(t.token);
            s(o) ? o.then(n, r) : n(o)
        }, function () {
            t.cancel()
        })
    }

    function u(e, t) {
        return new r.TPromise(function (r, o, i) {
            e.done(function (e) {
                try {
                    t(e)
                } catch (o) {
                    n.onUnexpectedError(o)
                }
                r(e)
            }, function (e) {
                try {
                    t(e)
                } catch (r) {
                    n.onUnexpectedError(r)
                }
                o(e)
            }, function (e) {
                i(e)
            })
        }, function () {
            e.cancel()
        })
    }

    function l(e) {
        function t() {
            return e.length ? e.pop()() : null
        }

        function n(e) {
            e && o.push(e);
            var i = t();
            return i ? i.then(n) : r.TPromise.as(o)
        }

        var o = [];
        return e = e.reverse(), r.TPromise.as(null).then(n)
    }

    function f(e) {
        var t, n = this, r = !1;
        return function () {
            return r ? t : (r = !0, t = e.apply(n, arguments))
        }
    }

    function p(e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        return new r.Promise(function (n, r) {
            return e.apply(void 0, t.concat([function (e, t) {
                return e ? r(e) : n(t)
            }]))
        })
    }

    function d(e, t) {
        for (var n = [], o = 2; o < arguments.length; o++)n[o - 2] = arguments[o];
        return new r.Promise(function (r, o) {
            return t.call.apply(t, [e].concat(n, [function (e, t) {
                return e ? o(e) : r(t)
            }]))
        })
    }

    t.asWinJsPromise = c;
    var h = function () {
        function e() {
            this.activePromise = null, this.queuedPromise = null, this.queuedPromiseFactory = null
        }

        return e.prototype.queue = function (e) {
            var t = this;
            if (this.activePromise) {
                if (this.queuedPromiseFactory = e, !this.queuedPromise) {
                    var n = function () {
                        t.queuedPromise = null;
                        var e = t.queue(t.queuedPromiseFactory);
                        return t.queuedPromiseFactory = null, e
                    };
                    this.queuedPromise = new r.Promise(function (e, r, o) {
                        t.activePromise.then(n, n, o).done(e)
                    }, function () {
                        t.activePromise.cancel()
                    })
                }
                return new r.Promise(function (e, n, r) {
                    t.queuedPromise.then(e, n, r)
                }, function () {
                })
            }
            return this.activePromise = e(), new r.Promise(function (e, n, r) {
                t.activePromise.done(function (n) {
                    t.activePromise = null, e(n)
                }, function (e) {
                    t.activePromise = null, n(e)
                }, r)
            }, function () {
                t.activePromise.cancel()
            })
        }, e
    }();
    t.Throttler = h;
    var m = function () {
        function e(e) {
            this.defaultDelay = e, this.timeout = null, this.completionPromise = null, this.onSuccess = null, this.task = null
        }

        return e.prototype.trigger = function (e, t) {
            var n = this;
            return void 0 === t && (t = this.defaultDelay), this.task = e, this.cancelTimeout(), this.completionPromise || (this.completionPromise = new r.Promise(function (e) {
                n.onSuccess = e
            }, function () {
            }).then(function () {
                n.completionPromise = null, n.onSuccess = null;
                var e = n.task;
                return n.task = null, e()
            })), this.timeout = setTimeout(function () {
                n.timeout = null, n.onSuccess(null)
            }, t), this.completionPromise
        }, e.prototype.isTriggered = function () {
            return null !== this.timeout
        }, e.prototype.cancel = function () {
            this.cancelTimeout(), this.completionPromise && (this.completionPromise.cancel(), this.completionPromise = null)
        }, e.prototype.cancelTimeout = function () {
            null !== this.timeout && (clearTimeout(this.timeout), this.timeout = null)
        }, e
    }();
    t.Delayer = m;
    var g = function (e) {
        function t(t) {
            e.call(this, t), this.throttler = new h
        }

        return __extends(t, e), t.prototype.trigger = function (t, n) {
            var r = this;
            return e.prototype.trigger.call(this, function () {
                return r.throttler.queue(t)
            }, n)
        }, t
    }(m);
    t.ThrottledDelayer = g;
    var v = function (e) {
        function t(t, n) {
            void 0 === n && (n = 0), e.call(this, t), this.minimumPeriod = n, this.periodThrottler = new h
        }

        return __extends(t, e), t.prototype.trigger = function (t, n) {
            var o = this;
            return e.prototype.trigger.call(this, function () {
                return o.periodThrottler.queue(function () {
                    return r.Promise.join([r.TPromise.timeout(o.minimumPeriod), t()]).then(function (e) {
                        return e[1]
                    })
                })
            }, n)
        }, t
    }(g);
    t.PeriodThrottledDelayer = v;
    var w = function () {
        function e() {
            var e = this;
            this._value = new r.TPromise(function (t, n) {
                e._completeCallback = t, e._errorCallback = n
            })
        }

        return Object.defineProperty(e.prototype, "value", {
            get: function () {
                return this._value
            }, enumerable: !0, configurable: !0
        }), e.prototype.complete = function (e) {
            this._completeCallback(e)
        }, e.prototype.error = function (e) {
            this._errorCallback(e)
        }, e
    }();
    t.PromiseSource = w;
    var y = function (e) {
        function t(t) {
            var r, o, i;
            e.call(this, function (e, t, n) {
                r = e, o = t, i = n
            }, function () {
                o(n.canceled())
            }), t.then(r, o, i)
        }

        return __extends(t, e), t
    }(r.TPromise);
    t.ShallowCancelThenPromise = y, t.always = u, t.sequence = l, t.once = f;
    var b = function () {
        function e(e) {
            this.maxDegreeOfParalellism = e, this.outstandingPromises = [], this.runningPromises = 0
        }

        return e.prototype.queue = function (e) {
            var t = this;
            return new r.TPromise(function (n, r, o) {
                t.outstandingPromises.push({factory: e, c: n, e: r, p: o}), t.consume()
            })
        }, e.prototype.consume = function () {
            for (var e = this; this.outstandingPromises.length && this.runningPromises < this.maxDegreeOfParalellism;) {
                var t = this.outstandingPromises.shift();
                this.runningPromises++;
                var n = t.factory();
                n.done(t.c, t.e, t.p), n.done(function () {
                    return e.consumed()
                }, function () {
                    return e.consumed()
                })
            }
        }, e.prototype.consumed = function () {
            this.runningPromises--, this.consume()
        }, e
    }();
    t.Limiter = b;
    var _ = function (e) {
        function t() {
            e.call(this), this._token = -1
        }

        return __extends(t, e), t.prototype.dispose = function () {
            this.cancel(), e.prototype.dispose.call(this)
        }, t.prototype.cancel = function () {
            -1 !== this._token && (o.clearTimeout(this._token), this._token = -1)
        }, t.prototype.cancelAndSet = function (e, t) {
            var n = this;
            this.cancel(), this._token = o.setTimeout(function () {
                n._token = -1, e()
            }, t)
        }, t.prototype.setIfNotSet = function (e, t) {
            var n = this;
            -1 === this._token && (this._token = o.setTimeout(function () {
                n._token = -1, e()
            }, t))
        }, t
    }(a.Disposable);
    t.TimeoutTimer = _;
    var S = function (e) {
        function t() {
            e.call(this), this._token = -1
        }

        return __extends(t, e), t.prototype.dispose = function () {
            this.cancel(), e.prototype.dispose.call(this)
        }, t.prototype.cancel = function () {
            -1 !== this._token && (o.clearInterval(this._token), this._token = -1)
        }, t.prototype.cancelAndSet = function (e, t) {
            this.cancel(), this._token = o.setInterval(function () {
                e()
            }, t)
        }, t
    }(a.Disposable);
    t.IntervalTimer = S;
    var E = function () {
        function e(e, t) {
            this.timeoutToken = -1, this.runner = e, this.timeout = t, this.timeoutHandler = this.onTimeout.bind(this)
        }

        return e.prototype.dispose = function () {
            this.cancel(), this.runner = null
        }, e.prototype.cancel = function () {
            this.isScheduled() && (o.clearTimeout(this.timeoutToken), this.timeoutToken = -1)
        }, e.prototype.setRunner = function (e) {
            this.runner = e
        }, e.prototype.setTimeout = function (e) {
            this.timeout = e
        }, e.prototype.schedule = function () {
            this.cancel(), this.timeoutToken = o.setTimeout(this.timeoutHandler, this.timeout)
        }, e.prototype.isScheduled = function () {
            return -1 !== this.timeoutToken
        }, e.prototype.onTimeout = function () {
            this.timeoutToken = -1, this.runner && this.runner()
        }, e
    }();
    t.RunOnceScheduler = E, t.nfcall = p, t.ninvoke = d
}), define("vs/base/common/service", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/objects", "vs/base/common/lifecycle", "vs/base/common/event"], function (e, t, n, r, o, i) {
    "use strict";
    function a(e, t) {
        e[t] = (n = {}, n[p] = !0, n);
        var n
    }

    function s(e) {
        return e[p]
    }

    function c(e, t, n) {
        var o, a = function () {
            return o || (o = e.then(function (e) {
                return e.getService(t, n)
            })), o
        };
        return Object.keys(n.prototype).filter(function (e) {
            return "constructor" !== e
        }).reduce(function (e, t) {
            if (s(n.prototype[t])) {
                var o, c, u = new i.Emitter({
                    onFirstListenerAdd: function () {
                        o = a().then(function (e) {
                            c = e[t](function (e) {
                                return u.fire(e)
                            })
                        })
                    }, onLastListenerRemove: function () {
                        c && (c.dispose(), c = null), o.cancel(), o = null
                    }
                });
                return r.assign(e, (l = {}, l[t] = u.event, l))
            }
            return r.assign(e, (f = {}, f[t] = function () {
                for (var e = [], n = 0; n < arguments.length; n++)e[n - 0] = arguments[n];
                return a().then(function (n) {
                    return n[t].apply(n, e)
                })
            }, f));
            var l, f
        }, {})
    }

    var u;
    !function (e) {
        e[e.Common = 0] = "Common", e[e.Cancel = 1] = "Cancel"
    }(u || (u = {}));
    var l;
    !function (e) {
        e[e.Initialize = 0] = "Initialize", e[e.Success = 1] = "Success", e[e.Progress = 2] = "Progress", e[e.Error = 3] = "Error", e[e.ErrorObj = 4] = "ErrorObj"
    }(l || (l = {}));
    var f;
    !function (e) {
        e[e.Uninitialized = 0] = "Uninitialized", e[e.Idle = 1] = "Idle"
    }(f || (f = {}));
    var p = "$__SERVICE_EVENT";
    t.ServiceEvent = a, t.isServiceEvent = s;
    var d = function () {
        function e(e) {
            var t = this;
            this.protocol = e, this.services = Object.create(null), this.activeRequests = Object.create(null), this.protocol.onMessage(function (e) {
                return t.onMessage(e)
            }), this.protocol.send({type: l.Initialize})
        }

        return e.prototype.registerService = function (e, t) {
            this.services[e] = t
        }, e.prototype.onMessage = function (e) {
            switch (e.type) {
                case u.Common:
                    this.onCommonRequest(e);
                    break;
                case u.Cancel:
                    this.onCancelRequest(e)
            }
        }, e.prototype.onCommonRequest = function (e) {
            var t, r = this.services[e.serviceName], o = r.constructor.prototype, i = o && o[e.name], a = i && i[p], s = r[e.name];
            if (a) {
                var c;
                t = new n.Promise(function (e, t, n) {
                    return c = s.call(r, n)
                }, function () {
                    return c.dispose()
                })
            } else {
                if (s)try {
                    t = s.call.apply(s, [r].concat(e.args))
                } catch (u) {
                    t = n.Promise.wrapError(u)
                } else t = n.Promise.wrapError(new Error(e.name + " is not a valid method on " + e.serviceName));
                if (!n.Promise.is(t)) {
                    var l = "'" + e.name + "' did not return a promise";
                    console.warn(l), t = n.Promise.wrapError(new Error(l))
                }
            }
            this.onPromiseRequest(t, e)
        }, e.prototype.onPromiseRequest = function (e, t) {
            var n = this, r = t.id, i = e.then(function (e) {
                n.protocol.send({id: r, data: e, type: l.Success}), delete n.activeRequests[t.id]
            }, function (e) {
                e instanceof Error ? n.protocol.send({
                    id: r,
                    data: {message: e.message, name: e.name, stack: e.stack ? e.stack.split("\n") : void 0},
                    type: l.Error
                }) : n.protocol.send({id: r, data: e, type: l.ErrorObj}), delete n.activeRequests[t.id]
            }, function (e) {
                n.protocol.send({id: r, data: e, type: l.Progress})
            });
            this.activeRequests[t.id] = o.fnToDisposable(function () {
                return i.cancel()
            })
        }, e.prototype.onCancelRequest = function (e) {
            var t = this.activeRequests[e.id];
            t && (t.dispose(), delete this.activeRequests[e.id])
        }, e.prototype.dispose = function () {
            var e = this;
            Object.keys(this.activeRequests).forEach(function (t) {
                e.activeRequests[t].dispose()
            }), this.activeRequests = null
        }, e
    }();
    t.Server = d;
    var h = function () {
        function e(e) {
            var t = this;
            this.protocol = e, this.state = f.Uninitialized, this.bufferedRequests = [], this.handlers = Object.create(null), this.lastRequestId = 0, this.protocol.onMessage(function (e) {
                return t.onMessage(e)
            })
        }

        return e.prototype.getService = function (e, t) {
            var n = this, o = Object.keys(t.prototype).filter(function (e) {
                return "constructor" !== e
            });
            return o.reduce(function (o, a) {
                if (t.prototype[a][p]) {
                    var s, c = new i.Emitter({
                        onFirstListenerAdd: function () {
                            s = n.request(e, a).then(null, null, function (e) {
                                return c.fire(e)
                            })
                        }, onLastListenerRemove: function () {
                            s.cancel(), s = null
                        }
                    });
                    return r.assign(o, (u = {}, u[a] = c.event, u))
                }
                return r.assign(o, (l = {}, l[a] = function () {
                    for (var t = [], r = 0; r < arguments.length; r++)t[r - 0] = arguments[r];
                    return n.request.apply(n, [e, a].concat(t))
                }, l));
                var u, l
            }, {})
        }, e.prototype.request = function (e, t) {
            for (var n = [], r = 2; r < arguments.length; r++)n[r - 2] = arguments[r];
            var o = {raw: {id: this.lastRequestId++, type: u.Common, serviceName: e, name: t, args: n}};
            return this.state === f.Uninitialized ? this.bufferRequest(o) : this.doRequest(o)
        }, e.prototype.doRequest = function (e) {
            var t = this, r = e.raw.id;
            return new n.Promise(function (n, o, i) {
                t.handlers[r] = function (e) {
                    switch (e.type) {
                        case l.Success:
                            delete t.handlers[r], n(e.data);
                            break;
                        case l.Error:
                            delete t.handlers[r];
                            var a = new Error(e.data.message);
                            a.stack = e.data.stack, a.name = e.data.name, o(a);
                            break;
                        case l.ErrorObj:
                            delete t.handlers[r], o(e.data);
                            break;
                        case l.Progress:
                            i(e.data)
                    }
                }, t.send(e.raw)
            }, function () {
                return t.send({id: r, type: u.Cancel})
            })
        }, e.prototype.bufferRequest = function (e) {
            var t = this, r = null;
            return new n.Promise(function (n, o, i) {
                t.bufferedRequests.push(e), e.flush = function () {
                    e.flush = null, r = t.doRequest(e).then(n, o, i)
                }
            }, function () {
                if (e.flush = null, t.state !== f.Uninitialized)return void(r && (r.cancel(), r = null));
                var n = t.bufferedRequests.indexOf(e);
                -1 !== n && t.bufferedRequests.splice(n, 1)
            })
        }, e.prototype.onMessage = function (e) {
            if (this.state === f.Uninitialized && e.type === l.Initialize)return this.state = f.Idle, this.bufferedRequests.forEach(function (e) {
                return e.flush && e.flush()
            }), void(this.bufferedRequests = null);
            var t = this.handlers[e.id];
            t && t(e)
        }, e.prototype.send = function (e) {
            try {
                this.protocol.send(e)
            } catch (t) {
            }
        }, e
    }();
    t.Client = h, t.getService = c
}), define("vs/base/node/env", ["require", "exports", "vs/base/common/platform", "vs/base/common/winjs.base", "child_process"], function (e, t, n, r, o) {
    "use strict";
    function i() {
        return n.isWindows ? r.TPromise.as({}) : new r.TPromise(function (e, t) {
            var n = o.spawn(process.env.SHELL, ["-ilc", "env"], {
                detached: !0,
                stdio: ["ignore", "pipe", process.stderr]
            });
            n.stdout.setEncoding("utf8"), n.on("error", function () {
                return e({})
            });
            var r = "";
            n.stdout.on("data", function (e) {
                r += e
            }), n.on("close", function (t, n) {
                if (0 !== t)return e({});
                var o = Object.create(null);
                r.split("\n").forEach(function (e) {
                    var t = e.indexOf("=");
                    if (t > 0) {
                        var n = e.substring(0, t), r = e.substring(t + 1);
                        if (!n || "string" == typeof o[n])return;
                        o[n] = r
                    }
                }), e(o)
            })
        })
    }

    t.getUserEnvironment = i
}), define("vs/base/node/pfs", ["require", "exports", "vs/base/common/winjs.base", "vs/base/node/extfs", "vs/base/common/paths", "path", "vs/base/common/async", "fs"], function (e, t, n, r, o, i, a, s) {
    "use strict";
    function c(e) {
        return e === i.dirname(e)
    }

    function u(e) {
        return a.nfcall(r.readdir, e)
    }

    function l(e) {
        return new n.Promise(function (t) {
            return s.exists(e, t)
        })
    }

    function f(e, t) {
        return a.nfcall(s.chmod, e, t)
    }

    function p(e, t) {
        var r = function () {
            return a.nfcall(s.mkdir, e, t).then(null, function (t) {
                return "EEXIST" === t.code ? a.nfcall(s.stat, e).then(function (t) {
                    return t.isDirectory ? null : n.Promise.wrapError(new Error("'" + e + "' exists and is not a directory."))
                }) : n.TPromise.wrapError(t)
            })
        };
        return c(e) ? n.TPromise.as(!0) : r().then(null, function (o) {
            return "ENOENT" === o.code ? p(i.dirname(e), t).then(r) : n.TPromise.wrapError(o)
        })
    }

    function d(e) {
        return m(e).then(function (t) {
            return t.isDirectory() ? u(e).then(function (t) {
                return n.TPromise.join(t.map(function (t) {
                    return d(i.join(e, t))
                }))
            }).then(function () {
                return y(e)
            }) : b(e)
        }, function (e) {
            return "ENOENT" !== e.code ? n.TPromise.wrapError(e) : void 0
        })
    }

    function h(e) {
        return a.nfcall(s.realpath, e, null)
    }

    function m(e) {
        return a.nfcall(s.stat, e)
    }

    function g(e) {
        return a.nfcall(s.lstat, e)
    }

    function v(e) {
        return E(e.slice(0))
    }

    function w(e, t) {
        return a.nfcall(s.rename, e, t)
    }

    function y(e) {
        return a.nfcall(s.rmdir, e)
    }

    function b(e) {
        return a.nfcall(s.unlink, e)
    }

    function _(e, t, n) {
        return a.nfcall(s.symlink, e, t, n)
    }

    function S(e) {
        return a.nfcall(s.readlink, e)
    }

    function E(e) {
        var t = e.shift();
        return m(t).then(function (e) {
            return {path: t, stats: e}
        }, function (t) {
            return 0 === e.length ? t : v(e)
        })
    }

    function P(e, t) {
        return a.nfcall(s.readFile, e, t)
    }

    function C(e, t, n) {
        return void 0 === n && (n = "utf8"), a.nfcall(s.writeFile, e, t, n)
    }

    function k(e) {
        return u(e).then(function (t) {
            return n.TPromise.join(t.map(function (t) {
                return A(o.join(e, t), t)
            })).then(function (e) {
                return I(e)
            })
        })
    }

    function A(e, t) {
        return M(e).then(function (e) {
            return e ? t : null
        })
    }

    function M(e) {
        return m(e).then(function (e) {
            return e.isDirectory()
        }, function () {
            return !1
        })
    }

    function x(e) {
        return m(e).then(function (e) {
            return e.isFile()
        }, function () {
            return !1
        })
    }

    function T(e, t) {
        return u(e).then(function (r) {
            r = r.filter(function (e) {
                return t.test(e)
            });
            var i = r.map(function (t) {
                return O(o.join(e, t), t)
            });
            return n.TPromise.join(i).then(function (e) {
                return I(e)
            })
        })
    }

    function O(e, t) {
        return x(e).then(function (e) {
            return e ? t : null
        }, function (e) {
            return n.TPromise.wrapError(e)
        })
    }

    function I(e) {
        return e.filter(function (e) {
            return null !== e
        })
    }

    t.isRoot = c, t.readdir = u, t.exists = l, t.chmod = f, t.mkdirp = p, t.rimraf = d, t.realpath = h, t.stat = m, t.lstat = g, t.mstat = v, t.rename = w, t.rmdir = y, t.unlink = b, t.symlink = _, t.readlink = S, t.readFile = P, t.writeFile = C, t.readDirsInDir = k, t.dirExists = M, t.fileExists = x, t.readFiles = T, t.fileExistsWithResult = O
}), define("vs/base/node/request", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/types", "https", "http", "url", "fs", "vs/base/common/objects"], function (e, t, n, r, o, i, a, s, c) {
    "use strict";
    function u(e) {
        var t;
        return new n.TPromise(function (n, s) {
            var l = a.parse(e.url), f = {
                hostname: l.hostname,
                port: l.port ? parseInt(l.port) : "https:" === l.protocol ? 443 : 80,
                path: l.path,
                method: e.type || "GET",
                headers: e.headers,
                agent: e.agent,
                rejectUnauthorized: r.isBoolean(e.strictSSL) ? e.strictSSL : !0
            };
            e.user && e.password && (f.auth = e.user + ":" + e.password);
            var p = "https:" === l.protocol ? o : i;
            t = p.request(f, function (r) {
                n(r.statusCode >= 300 && r.statusCode < 400 && e.followRedirects && e.followRedirects > 0 && r.headers.location ? u(c.assign({}, e, {
                    url: r.headers.location,
                    followRedirects: e.followRedirects - 1
                })) : {req: t, res: r})
            }), t.on("error", s), e.timeout && t.setTimeout(e.timeout), e.data && t.write(e.data), t.end()
        }, function () {
            return t && t.abort()
        })
    }

    function l(e, t) {
        return u(c.assign(t, {followRedirects: 3})).then(function (t) {
            return new n.TPromise(function (n, r) {
                var o = s.createWriteStream(e);
                o.once("finish", function () {
                    return n(null)
                }), t.res.once("error", r), t.res.pipe(o)
            })
        })
    }

    function f(e) {
        return u(e).then(function (e) {
            return new n.Promise(function (t, n) {
                if (!(e.res.statusCode >= 200 && e.res.statusCode < 300 || 1223 === e.res.statusCode))return n("Server returned " + e.res.statusCode);
                if (204 === e.res.statusCode)return t(null);
                if (!/application\/json/.test(e.res.headers["content-type"]))return n("Response doesn't appear to be JSON");
                var r = [];
                e.res.on("data", function (e) {
                    return r.push(e)
                }), e.res.on("end", function () {
                    return t(JSON.parse(r.join("")))
                }), e.res.on("error", n)
            })
        })
    }

    t.request = u, t.download = l, t.json = f
}), define("vs/base/node/service.net", ["require", "exports", "net", "vs/base/common/event", "vs/base/common/service", "vs/base/common/winjs.base"], function (e, t, n, r, o, i) {
    "use strict";
    function a(e, t, n) {
        for (void 0 === n && (n = 0); n < e.length && e[n] !== t;)n++;
        return n
    }

    function s(e) {
        return new i.TPromise(function (t, r) {
            var o = n.createServer();
            o.on("error", r), o.listen(e, function () {
                o.removeListener("error", r), t(new l(o))
            })
        })
    }

    function c(e) {
        return new i.TPromise(function (t, r) {
            var o = n.createConnection(e, function () {
                o.removeListener("error", r), t(new f(o))
            });
            o.once("error", r)
        })
    }

    var u = function () {
        function e(e) {
            this.socket = e, this.buffer = null
        }

        return e.prototype.send = function (t) {
            this.socket.write(JSON.stringify(t)), this.socket.write(e.Boundary)
        }, e.prototype.onMessage = function (e) {
            var t = this;
            this.socket.on("data", function (n) {
                for (var r = 0, o = 0; (o = a(n, 0, r)) < n.length;) {
                    var i = n.slice(r, o);
                    t.buffer ? (e(JSON.parse(Buffer.concat([t.buffer, i]).toString("utf8"))), t.buffer = null) : e(JSON.parse(i.toString("utf8"))), r = o + 1
                }
                if (o - r > 0) {
                    var s = n.slice(r, o);
                    t.buffer ? t.buffer = Buffer.concat([t.buffer, s]) : t.buffer = s
                }
            })
        }, e.Boundary = new Buffer([0]), e
    }(), l = function () {
        function e(e) {
            var t = this;
            this.server = e, this.services = Object.create(null), this.server.on("connection", function (e) {
                var n = new o.Server(new u(e));
                Object.keys(t.services).forEach(function (e) {
                    return n.registerService(e, t.services[e])
                }), e.once("close", function () {
                    return n.dispose()
                })
            })
        }

        return e.prototype.registerService = function (e, t) {
            this.services[e] = t
        }, e.prototype.dispose = function () {
            this.services = null, this.server.close(), this.server = null
        }, e
    }();
    t.Server = l;
    var f = function () {
        function e(e) {
            var t = this;
            this.socket = e, this._onClose = new r.Emitter, this.ipcClient = new o.Client(new u(e)), e.once("close", function () {
                return t._onClose.fire()
            })
        }

        return Object.defineProperty(e.prototype, "onClose", {
            get: function () {
                return this._onClose.event
            }, enumerable: !0, configurable: !0
        }), e.prototype.getService = function (e, t) {
            return this.ipcClient.getService(e, t)
        }, e.prototype.dispose = function () {
            this.socket.end(), this.socket = null, this.ipcClient = null
        }, e
    }();
    t.Client = f, t.serve = s, t.connect = c
}), define("vs/nls!vs/base/common/json", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/base/common/json", t)
}), define("vs/base/common/json", ["require", "exports", "vs/nls!vs/base/common/json"], function (e, t, n) {
    "use strict";
    function r(e, t) {
        function n(t, n) {
            for (var r = 0, o = 0; t > r || !n;) {
                var i = e.charCodeAt(h);
                if (i >= p._0 && i <= p._9)o = 16 * o + i - p._0; else if (i >= p.A && i <= p.F)o = 16 * o + i - p.A + 10; else {
                    if (!(i >= p.a && i <= p.f))break;
                    o = 16 * o + i - p.a + 10
                }
                h++, r++
            }
            return t > r && (o = -1), o
        }

        function r() {
            var t = h;
            if (e.charCodeAt(h) === p._0)h++; else for (h++; h < e.length && a(e.charCodeAt(h));)h++;
            if (h < e.length && e.charCodeAt(h) === p.dot) {
                if (h++, !(h < e.length && a(e.charCodeAt(h))))return y = l.UnexpectedEndOfNumber, e.substring(t, n);
                for (h++; h < e.length && a(e.charCodeAt(h));)h++
            }
            var n = h;
            if (h < e.length && (e.charCodeAt(h) === p.E || e.charCodeAt(h) === p.e))if (h++, (h < e.length && e.charCodeAt(h) === p.plus || e.charCodeAt(h) === p.minus) && h++, h < e.length && a(e.charCodeAt(h))) {
                for (h++; h < e.length && a(e.charCodeAt(h));)h++;
                n = h
            } else y = l.UnexpectedEndOfNumber;
            return e.substring(t, n)
        }

        function s() {
            for (var t = "", r = h; ;) {
                if (h >= m) {
                    t += e.substring(r, h), y = l.UnexpectedEndOfString;
                    break
                }
                var o = e.charCodeAt(h);
                if (o === p.doubleQuote) {
                    t += e.substring(r, h), h++;
                    break
                }
                if (o !== p.backslash) {
                    if (i(o)) {
                        t += e.substring(r, h), y = l.UnexpectedEndOfString;
                        break
                    }
                    h++
                } else {
                    if (t += e.substring(r, h), h++, h >= m) {
                        y = l.UnexpectedEndOfString;
                        break
                    }
                    switch (o = e.charCodeAt(h++)) {
                        case p.doubleQuote:
                            t += '"';
                            break;
                        case p.backslash:
                            t += "\\";
                            break;
                        case p.slash:
                            t += "/";
                            break;
                        case p.b:
                            t += "\b";
                            break;
                        case p.f:
                            t += "\f";
                            break;
                        case p.n:
                            t += "\n";
                            break;
                        case p.r:
                            t += "\r";
                            break;
                        case p.t:
                            t += "	";
                            break;
                        case p.u:
                            var o = n(4, !0);
                            o >= 0 ? t += String.fromCharCode(o) : y = l.InvalidUnicode;
                            break;
                        default:
                            y = l.InvalidEscapeCharacter
                    }
                    r = h
                }
            }
            return t
        }

        function c() {
            if (g = "", y = l.None, v = h, h >= m)return v = m, w = f.EOF;
            var t = e.charCodeAt(h);
            if (o(t)) {
                do h++, g += String.fromCharCode(t), t = e.charCodeAt(h); while (o(t));
                return w = f.Trivia
            }
            if (i(t))return h++, g += String.fromCharCode(t), t === p.carriageReturn && e.charCodeAt(h) === p.lineFeed && (h++, g += "\n"), w = f.LineBreakTrivia;
            switch (t) {
                case p.openBrace:
                    return h++, w = f.OpenBraceToken;
                case p.closeBrace:
                    return h++, w = f.CloseBraceToken;
                case p.openBracket:
                    return h++, w = f.OpenBracketToken;
                case p.closeBracket:
                    return h++, w = f.CloseBracketToken;
                case p.colon:
                    return h++, w = f.ColonToken;
                case p.comma:
                    return h++, w = f.CommaToken;
                case p.doubleQuote:
                    return h++, g = s(), w = f.StringLiteral;
                case p.slash:
                    var n = h - 1;
                    if (e.charCodeAt(h + 1) === p.slash) {
                        for (h += 2; m > h && !i(e.charCodeAt(h));)h++;
                        return g = e.substring(n, h), w = f.LineCommentTrivia
                    }
                    if (e.charCodeAt(h + 1) === p.asterisk) {
                        h += 2;
                        for (var c = m - 1, d = !1; c > h;) {
                            var b = e.charCodeAt(h);
                            if (b === p.asterisk && e.charCodeAt(h + 1) === p.slash) {
                                h += 2, d = !0;
                                break
                            }
                            h++
                        }
                        return d || (h++, y = l.UnexpectedEndOfComment), g = e.substring(n, h), w = f.BlockCommentTrivia
                    }
                    return g += String.fromCharCode(t), h++, w = f.Unknown;
                case p.minus:
                    if (g += String.fromCharCode(t), h++, h === m || !a(e.charCodeAt(h)))return w = f.Unknown;
                case p._0:
                case p._1:
                case p._2:
                case p._3:
                case p._4:
                case p._5:
                case p._6:
                case p._7:
                case p._8:
                case p._9:
                    return g += r(), w = f.NumericLiteral;
                default:
                    for (; m > h && u(t);)h++, t = e.charCodeAt(h);
                    if (v !== h) {
                        switch (g = e.substring(v, h)) {
                            case"true":
                                return w = f.TrueKeyword;
                            case"false":
                                return w = f.FalseKeyword;
                            case"null":
                                return w = f.NullKeyword
                        }
                        return w = f.Unknown
                    }
                    return g += String.fromCharCode(t), h++, w = f.Unknown
            }
        }

        function u(e) {
            if (o(e) || i(e))return !1;
            switch (e) {
                case p.closeBrace:
                case p.closeBracket:
                case p.openBrace:
                case p.openBracket:
                case p.doubleQuote:
                case p.colon:
                case p.comma:
                    return !1
            }
            return !0
        }

        function d() {
            var e;
            do e = c(); while (e >= f.LineCommentTrivia && e <= f.Trivia);
            return e
        }

        void 0 === t && (t = !1);
        var h = 0, m = e.length, g = "", v = 0, w = f.Unknown, y = l.None;
        return {
            getPosition: function () {
                return h
            }, scan: t ? d : c, getToken: function () {
                return w
            }, getTokenValue: function () {
                return g
            }, getTokenOffset: function () {
                return v
            }, getTokenLength: function () {
                return h - v
            }, getTokenError: function () {
                return y
            }
        }
    }

    function o(e) {
        return e === p.space || e === p.tab || e === p.verticalTab || e === p.formFeed || e === p.nonBreakingSpace || e === p.ogham || e >= p.enQuad && e <= p.zeroWidthSpace || e === p.narrowNoBreakSpace || e === p.mathematicalSpace || e === p.ideographicSpace || e === p.byteOrderMark
    }

    function i(e) {
        return e === p.lineFeed || e === p.carriageReturn || e === p.lineSeparator || e === p.paragraphSeparator
    }

    function a(e) {
        return e >= p._0 && e <= p._9
    }

    function s(e) {
        return e >= p.a && e <= p.z || e >= p.A && e <= p.Z
    }

    function c(e, t) {
        var n, o, i = r(e), a = [], s = 0;
        do switch (o = i.getPosition(), n = i.scan()) {
            case f.LineCommentTrivia:
            case f.BlockCommentTrivia:
            case f.EOF:
                s !== o && a.push(e.substring(s, o)), void 0 !== t && a.push(i.getTokenValue().replace(/[^\r\n]/g, t)), s = i.getPosition()
        } while (n !== f.EOF);
        return a.join("")
    }

    function u(e, t) {
        function o() {
            for (var e = h.scan(); e === f.Unknown;)i(n.localize(0, null)), e = h.scan();
            return e
        }

        function i(e, n, r) {
            if (void 0 === n && (n = []), void 0 === r && (r = []), t.push(e), n.length + r.length > 0)for (var i = h.getToken(); i !== f.EOF;) {
                if (-1 !== n.indexOf(i)) {
                    o();
                    break
                }
                if (-1 !== r.indexOf(i))break;
                i = o()
            }
        }

        function a() {
            if (h.getToken() !== f.StringLiteral)return d;
            var e = h.getTokenValue();
            return o(), e
        }

        function s() {
            var e;
            switch (h.getToken()) {
                case f.NumericLiteral:
                    try {
                        e = JSON.parse(h.getTokenValue()), "number" != typeof e && (i(n.localize(1, null)), e = 0)
                    } catch (t) {
                        e = 0
                    }
                    break;
                case f.NullKeyword:
                    e = null;
                    break;
                case f.TrueKeyword:
                    e = !0;
                    break;
                case f.FalseKeyword:
                    e = !1;
                    break;
                default:
                    return d
            }
            return o(), e
        }

        function c(e) {
            var t = a();
            if (t === d)return i(n.localize(2, null), [], [f.CloseBraceToken, f.CommaToken]), !1;
            if (h.getToken() === f.ColonToken) {
                o();
                var r = p();
                r !== d ? e[t] = r : i(n.localize(3, null), [], [f.CloseBraceToken, f.CommaToken])
            } else i(n.localize(4, null), [], [f.CloseBraceToken, f.CommaToken]);
            return !0
        }

        function u() {
            if (h.getToken() !== f.OpenBraceToken)return d;
            var e = {};
            o();
            for (var t = !1; h.getToken() !== f.CloseBraceToken && h.getToken() !== f.EOF;) {
                h.getToken() === f.CommaToken ? (t || i(n.localize(5, null), [], []), o()) : t && i(n.localize(6, null), [], []);
                var r = c(e);
                r || i(n.localize(7, null), [], [f.CloseBraceToken, f.CommaToken]), t = !0
            }
            return h.getToken() !== f.CloseBraceToken ? i(n.localize(8, null), [f.CloseBraceToken], []) : o(), e
        }

        function l() {
            if (h.getToken() !== f.OpenBracketToken)return d;
            var e = [];
            o();
            for (var t = !1; h.getToken() !== f.CloseBracketToken && h.getToken() !== f.EOF;) {
                h.getToken() === f.CommaToken ? (t || i(n.localize(9, null), [], []), o()) : t && i(n.localize(10, null), [], []);
                var r = p();
                r === d ? i(n.localize(11, null), [], [f.CloseBracketToken, f.CommaToken]) : e.push(r), t = !0
            }
            return h.getToken() !== f.CloseBracketToken ? i(n.localize(12, null), [f.CloseBracketToken], []) : o(), e
        }

        function p() {
            var e = l();
            return e !== d ? e : (e = u(), e !== d ? e : (e = a(), e !== d ? e : s()))
        }

        void 0 === t && (t = []);
        var d = Object(), h = r(e, !0);
        o();
        var m = p();
        return m === d ? void i(n.localize(13, null), [], []) : (h.getToken() !== f.EOF && i(n.localize(14, null), [], []), m)
    }

    !function (e) {
        e[e.None = 0] = "None", e[e.UnexpectedEndOfComment = 1] = "UnexpectedEndOfComment", e[e.UnexpectedEndOfString = 2] = "UnexpectedEndOfString", e[e.UnexpectedEndOfNumber = 3] = "UnexpectedEndOfNumber", e[e.InvalidUnicode = 4] = "InvalidUnicode", e[e.InvalidEscapeCharacter = 5] = "InvalidEscapeCharacter"
    }(t.ScanError || (t.ScanError = {}));
    var l = t.ScanError;
    !function (e) {
        e[e.Unknown = 0] = "Unknown", e[e.OpenBraceToken = 1] = "OpenBraceToken", e[e.CloseBraceToken = 2] = "CloseBraceToken", e[e.OpenBracketToken = 3] = "OpenBracketToken", e[e.CloseBracketToken = 4] = "CloseBracketToken", e[e.CommaToken = 5] = "CommaToken", e[e.ColonToken = 6] = "ColonToken", e[e.NullKeyword = 7] = "NullKeyword", e[e.TrueKeyword = 8] = "TrueKeyword", e[e.FalseKeyword = 9] = "FalseKeyword", e[e.StringLiteral = 10] = "StringLiteral", e[e.NumericLiteral = 11] = "NumericLiteral", e[e.LineCommentTrivia = 12] = "LineCommentTrivia", e[e.BlockCommentTrivia = 13] = "BlockCommentTrivia", e[e.LineBreakTrivia = 14] = "LineBreakTrivia", e[e.Trivia = 15] = "Trivia", e[e.EOF = 16] = "EOF"
    }(t.SyntaxKind || (t.SyntaxKind = {}));
    var f = t.SyntaxKind;
    t.createScanner = r, t.isLetter = s;
    var p;
    !function (e) {
        e[e.nullCharacter = 0] = "nullCharacter", e[e.maxAsciiCharacter = 127] = "maxAsciiCharacter", e[e.lineFeed = 10] = "lineFeed", e[e.carriageReturn = 13] = "carriageReturn", e[e.lineSeparator = 8232] = "lineSeparator", e[e.paragraphSeparator = 8233] = "paragraphSeparator", e[e.nextLine = 133] = "nextLine", e[e.space = 32] = "space", e[e.nonBreakingSpace = 160] = "nonBreakingSpace", e[e.enQuad = 8192] = "enQuad", e[e.emQuad = 8193] = "emQuad", e[e.enSpace = 8194] = "enSpace", e[e.emSpace = 8195] = "emSpace", e[e.threePerEmSpace = 8196] = "threePerEmSpace", e[e.fourPerEmSpace = 8197] = "fourPerEmSpace", e[e.sixPerEmSpace = 8198] = "sixPerEmSpace", e[e.figureSpace = 8199] = "figureSpace", e[e.punctuationSpace = 8200] = "punctuationSpace", e[e.thinSpace = 8201] = "thinSpace", e[e.hairSpace = 8202] = "hairSpace", e[e.zeroWidthSpace = 8203] = "zeroWidthSpace", e[e.narrowNoBreakSpace = 8239] = "narrowNoBreakSpace", e[e.ideographicSpace = 12288] = "ideographicSpace", e[e.mathematicalSpace = 8287] = "mathematicalSpace", e[e.ogham = 5760] = "ogham", e[e._ = 95] = "_", e[e.$ = 36] = "$", e[e._0 = 48] = "_0", e[e._1 = 49] = "_1", e[e._2 = 50] = "_2", e[e._3 = 51] = "_3", e[e._4 = 52] = "_4", e[e._5 = 53] = "_5", e[e._6 = 54] = "_6", e[e._7 = 55] = "_7", e[e._8 = 56] = "_8", e[e._9 = 57] = "_9", e[e.a = 97] = "a", e[e.b = 98] = "b", e[e.c = 99] = "c", e[e.d = 100] = "d", e[e.e = 101] = "e", e[e.f = 102] = "f", e[e.g = 103] = "g", e[e.h = 104] = "h", e[e.i = 105] = "i", e[e.j = 106] = "j", e[e.k = 107] = "k", e[e.l = 108] = "l", e[e.m = 109] = "m", e[e.n = 110] = "n", e[e.o = 111] = "o", e[e.p = 112] = "p", e[e.q = 113] = "q", e[e.r = 114] = "r", e[e.s = 115] = "s", e[e.t = 116] = "t", e[e.u = 117] = "u", e[e.v = 118] = "v", e[e.w = 119] = "w", e[e.x = 120] = "x", e[e.y = 121] = "y", e[e.z = 122] = "z", e[e.A = 65] = "A", e[e.B = 66] = "B", e[e.C = 67] = "C", e[e.D = 68] = "D", e[e.E = 69] = "E", e[e.F = 70] = "F", e[e.G = 71] = "G", e[e.H = 72] = "H", e[e.I = 73] = "I", e[e.J = 74] = "J", e[e.K = 75] = "K", e[e.L = 76] = "L", e[e.M = 77] = "M", e[e.N = 78] = "N", e[e.O = 79] = "O", e[e.P = 80] = "P", e[e.Q = 81] = "Q", e[e.R = 82] = "R", e[e.S = 83] = "S", e[e.T = 84] = "T", e[e.U = 85] = "U", e[e.V = 86] = "V", e[e.W = 87] = "W", e[e.X = 88] = "X", e[e.Y = 89] = "Y", e[e.Z = 90] = "Z", e[e.ampersand = 38] = "ampersand", e[e.asterisk = 42] = "asterisk", e[e.at = 64] = "at", e[e.backslash = 92] = "backslash", e[e.bar = 124] = "bar", e[e.caret = 94] = "caret", e[e.closeBrace = 125] = "closeBrace", e[e.closeBracket = 93] = "closeBracket", e[e.closeParen = 41] = "closeParen", e[e.colon = 58] = "colon", e[e.comma = 44] = "comma", e[e.dot = 46] = "dot",e[e.doubleQuote = 34] = "doubleQuote",e[e.equals = 61] = "equals",e[e.exclamation = 33] = "exclamation",e[e.greaterThan = 62] = "greaterThan",e[e.lessThan = 60] = "lessThan",e[e.minus = 45] = "minus",e[e.openBrace = 123] = "openBrace",e[e.openBracket = 91] = "openBracket",e[e.openParen = 40] = "openParen",e[e.percent = 37] = "percent",e[e.plus = 43] = "plus",e[e.question = 63] = "question",e[e.semicolon = 59] = "semicolon",e[e.singleQuote = 39] = "singleQuote",e[e.slash = 47] = "slash",e[e.tilde = 126] = "tilde",e[e.backspace = 8] = "backspace",e[e.formFeed = 12] = "formFeed",e[e.byteOrderMark = 65279] = "byteOrderMark",e[e.tab = 9] = "tab",e[e.verticalTab = 11] = "verticalTab"
    }(p || (p = {})), t.stripComments = c, t.parse = u
}), define("vs/nls!vs/base/common/keyCodes", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/base/common/keyCodes", t)
}), define("vs/base/common/keyCodes", ["require", "exports", "vs/nls!vs/base/common/keyCodes", "vs/base/common/platform"], function (e, t, n, r) {
    "use strict";
    function o(e, t) {
        var n = [];
        e(n);
        for (var r = {}, o = 0, i = n.length; i > o; o++)n[o] && (r[n[o]] = o);
        t(r);
        var a = {};
        for (var s in r)r.hasOwnProperty(s) && (a[s] = r[s], a[s.toLowerCase()] = r[s]);
        return new u(n, a)
    }

    function i(e, t, n) {
        var r = [], o = v.hasCtrlCmd(e), a = v.hasShift(e), s = v.hasAlt(e), c = v.hasWinCtrl(e), u = v.extractKeyCode(e), l = t.getLabelForKey(u);
        if (!l)return "";
        (o && !n.isMacintosh || c && n.isMacintosh) && r.push(t.ctrlKeyLabel), a && r.push(t.shiftKeyLabel), s && r.push(t.altKeyLabel), o && n.isMacintosh && r.push(t.cmdKeyLabel), c && !n.isMacintosh && r.push(t.windowsKeyLabel), r.push(l);
        var f = r.join(t.modifierSeparator);
        return v.hasChord(e) ? f + " " + i(v.extractChordPart(e), t, n) : f
    }

    function a(e, t) {
        e.length > 0 && e.push({tagName: "span", text: "+"}), e.push({
            tagName: "span",
            className: "monaco-kbkey",
            text: t
        })
    }

    function s(e, t, n, r) {
        void 0 === r && (r = !1);
        var o = [], i = v.hasCtrlCmd(e), c = v.hasShift(e), u = v.hasAlt(e), l = v.hasWinCtrl(e), f = v.extractKeyCode(e), p = t.getLabelForKey(f);
        if (!p)return [];
        (i && !n.isMacintosh || l && n.isMacintosh) && a(o, t.ctrlKeyLabel), c && a(o, t.shiftKeyLabel), u && a(o, t.altKeyLabel), i && n.isMacintosh && a(o, t.cmdKeyLabel), l && !n.isMacintosh && a(o, t.windowsKeyLabel), a(o, p);
        var d = null;
        return v.hasChord(e) && (d = s(v.extractChordPart(e), t, n, !0), o.push({
            tagName: "span",
            text: " "
        }), o = o.concat(d)), r ? o : [{tagName: "span", className: "monaco-kb", children: o}]
    }

    !function (e) {
        e[e.Unknown = 0] = "Unknown", e[e.Backspace = 1] = "Backspace", e[e.Tab = 2] = "Tab", e[e.Enter = 3] = "Enter", e[e.Shift = 4] = "Shift", e[e.Ctrl = 5] = "Ctrl", e[e.Alt = 6] = "Alt", e[e.PauseBreak = 7] = "PauseBreak", e[e.CapsLock = 8] = "CapsLock", e[e.Escape = 9] = "Escape", e[e.Space = 10] = "Space", e[e.PageUp = 11] = "PageUp", e[e.PageDown = 12] = "PageDown", e[e.End = 13] = "End", e[e.Home = 14] = "Home", e[e.LeftArrow = 15] = "LeftArrow", e[e.UpArrow = 16] = "UpArrow", e[e.RightArrow = 17] = "RightArrow", e[e.DownArrow = 18] = "DownArrow", e[e.Insert = 19] = "Insert", e[e.Delete = 20] = "Delete", e[e.KEY_0 = 21] = "KEY_0", e[e.KEY_1 = 22] = "KEY_1", e[e.KEY_2 = 23] = "KEY_2", e[e.KEY_3 = 24] = "KEY_3", e[e.KEY_4 = 25] = "KEY_4", e[e.KEY_5 = 26] = "KEY_5", e[e.KEY_6 = 27] = "KEY_6", e[e.KEY_7 = 28] = "KEY_7", e[e.KEY_8 = 29] = "KEY_8", e[e.KEY_9 = 30] = "KEY_9", e[e.KEY_A = 31] = "KEY_A", e[e.KEY_B = 32] = "KEY_B", e[e.KEY_C = 33] = "KEY_C", e[e.KEY_D = 34] = "KEY_D", e[e.KEY_E = 35] = "KEY_E", e[e.KEY_F = 36] = "KEY_F", e[e.KEY_G = 37] = "KEY_G", e[e.KEY_H = 38] = "KEY_H", e[e.KEY_I = 39] = "KEY_I", e[e.KEY_J = 40] = "KEY_J", e[e.KEY_K = 41] = "KEY_K", e[e.KEY_L = 42] = "KEY_L", e[e.KEY_M = 43] = "KEY_M", e[e.KEY_N = 44] = "KEY_N", e[e.KEY_O = 45] = "KEY_O", e[e.KEY_P = 46] = "KEY_P", e[e.KEY_Q = 47] = "KEY_Q", e[e.KEY_R = 48] = "KEY_R", e[e.KEY_S = 49] = "KEY_S", e[e.KEY_T = 50] = "KEY_T", e[e.KEY_U = 51] = "KEY_U", e[e.KEY_V = 52] = "KEY_V", e[e.KEY_W = 53] = "KEY_W", e[e.KEY_X = 54] = "KEY_X", e[e.KEY_Y = 55] = "KEY_Y", e[e.KEY_Z = 56] = "KEY_Z", e[e.Meta = 57] = "Meta", e[e.ContextMenu = 58] = "ContextMenu", e[e.F1 = 59] = "F1", e[e.F2 = 60] = "F2", e[e.F3 = 61] = "F3", e[e.F4 = 62] = "F4", e[e.F5 = 63] = "F5", e[e.F6 = 64] = "F6", e[e.F7 = 65] = "F7", e[e.F8 = 66] = "F8", e[e.F9 = 67] = "F9", e[e.F10 = 68] = "F10", e[e.F11 = 69] = "F11", e[e.F12 = 70] = "F12", e[e.F13 = 71] = "F13", e[e.F14 = 72] = "F14", e[e.F15 = 73] = "F15", e[e.F16 = 74] = "F16", e[e.F17 = 75] = "F17", e[e.F18 = 76] = "F18", e[e.F19 = 77] = "F19", e[e.NumLock = 78] = "NumLock", e[e.ScrollLock = 79] = "ScrollLock", e[e.US_SEMICOLON = 80] = "US_SEMICOLON", e[e.US_EQUAL = 81] = "US_EQUAL", e[e.US_COMMA = 82] = "US_COMMA", e[e.US_MINUS = 83] = "US_MINUS", e[e.US_DOT = 84] = "US_DOT", e[e.US_SLASH = 85] = "US_SLASH", e[e.US_BACKTICK = 86] = "US_BACKTICK", e[e.US_OPEN_SQUARE_BRACKET = 87] = "US_OPEN_SQUARE_BRACKET", e[e.US_BACKSLASH = 88] = "US_BACKSLASH", e[e.US_CLOSE_SQUARE_BRACKET = 89] = "US_CLOSE_SQUARE_BRACKET", e[e.US_QUOTE = 90] = "US_QUOTE", e[e.OEM_8 = 91] = "OEM_8", e[e.OEM_102 = 92] = "OEM_102", e[e.NUMPAD_0 = 93] = "NUMPAD_0", e[e.NUMPAD_1 = 94] = "NUMPAD_1", e[e.NUMPAD_2 = 95] = "NUMPAD_2", e[e.NUMPAD_3 = 96] = "NUMPAD_3", e[e.NUMPAD_4 = 97] = "NUMPAD_4", e[e.NUMPAD_5 = 98] = "NUMPAD_5", e[e.NUMPAD_6 = 99] = "NUMPAD_6", e[e.NUMPAD_7 = 100] = "NUMPAD_7",e[e.NUMPAD_8 = 101] = "NUMPAD_8",e[e.NUMPAD_9 = 102] = "NUMPAD_9",e[e.NUMPAD_MULTIPLY = 103] = "NUMPAD_MULTIPLY",e[e.NUMPAD_ADD = 104] = "NUMPAD_ADD",e[e.NUMPAD_SEPARATOR = 105] = "NUMPAD_SEPARATOR",e[e.NUMPAD_SUBTRACT = 106] = "NUMPAD_SUBTRACT",e[e.NUMPAD_DECIMAL = 107] = "NUMPAD_DECIMAL",e[e.NUMPAD_DIVIDE = 108] = "NUMPAD_DIVIDE",e[e.MAX_VALUE = 109] = "MAX_VALUE"
    }(t.KeyCode || (t.KeyCode = {}));
    var c, c = t.KeyCode, u = function () {
        function e(e, t) {
            this._fromKeyCode = e, this._toKeyCode = t
        }

        return e.prototype.fromKeyCode = function (e) {
            return this._fromKeyCode[e]
        }, e.prototype.toKeyCode = function (e) {
            return this._toKeyCode.hasOwnProperty(e) ? this._toKeyCode[e] : c.Unknown
        }, e
    }(), l = o(function (e) {
        e[c.Unknown] = "unknown", e[c.Backspace] = "Backspace", e[c.Tab] = "Tab", e[c.Enter] = "Enter", e[c.Shift] = "Shift", e[c.Ctrl] = "Ctrl", e[c.Alt] = "Alt", e[c.PauseBreak] = "PauseBreak", e[c.CapsLock] = "CapsLock", e[c.Escape] = "Escape", e[c.Space] = "Space", e[c.PageUp] = "PageUp", e[c.PageDown] = "PageDown", e[c.End] = "End", e[c.Home] = "Home", e[c.LeftArrow] = "LeftArrow", e[c.UpArrow] = "UpArrow", e[c.RightArrow] = "RightArrow", e[c.DownArrow] = "DownArrow", e[c.Insert] = "Insert", e[c.Delete] = "Delete", e[c.KEY_0] = "0", e[c.KEY_1] = "1", e[c.KEY_2] = "2", e[c.KEY_3] = "3", e[c.KEY_4] = "4", e[c.KEY_5] = "5", e[c.KEY_6] = "6", e[c.KEY_7] = "7", e[c.KEY_8] = "8", e[c.KEY_9] = "9", e[c.KEY_A] = "A", e[c.KEY_B] = "B", e[c.KEY_C] = "C", e[c.KEY_D] = "D", e[c.KEY_E] = "E", e[c.KEY_F] = "F", e[c.KEY_G] = "G", e[c.KEY_H] = "H", e[c.KEY_I] = "I", e[c.KEY_J] = "J", e[c.KEY_K] = "K", e[c.KEY_L] = "L", e[c.KEY_M] = "M", e[c.KEY_N] = "N", e[c.KEY_O] = "O", e[c.KEY_P] = "P", e[c.KEY_Q] = "Q", e[c.KEY_R] = "R", e[c.KEY_S] = "S", e[c.KEY_T] = "T", e[c.KEY_U] = "U", e[c.KEY_V] = "V", e[c.KEY_W] = "W", e[c.KEY_X] = "X", e[c.KEY_Y] = "Y", e[c.KEY_Z] = "Z", e[c.ContextMenu] = "ContextMenu", e[c.F1] = "F1", e[c.F2] = "F2", e[c.F3] = "F3", e[c.F4] = "F4", e[c.F5] = "F5", e[c.F6] = "F6", e[c.F7] = "F7", e[c.F8] = "F8", e[c.F9] = "F9", e[c.F10] = "F10", e[c.F11] = "F11", e[c.F12] = "F12", e[c.F13] = "F13", e[c.F14] = "F14", e[c.F15] = "F15", e[c.F16] = "F16", e[c.F17] = "F17", e[c.F18] = "F18", e[c.F19] = "F19", e[c.NumLock] = "NumLock", e[c.ScrollLock] = "ScrollLock", e[c.US_SEMICOLON] = ";", e[c.US_EQUAL] = "=", e[c.US_COMMA] = ",", e[c.US_MINUS] = "-", e[c.US_DOT] = ".", e[c.US_SLASH] = "/", e[c.US_BACKTICK] = "`", e[c.US_OPEN_SQUARE_BRACKET] = "[", e[c.US_BACKSLASH] = "\\", e[c.US_CLOSE_SQUARE_BRACKET] = "]", e[c.US_QUOTE] = "'", e[c.OEM_8] = "OEM_8", e[c.OEM_102] = "OEM_102", e[c.NUMPAD_0] = "NumPad0", e[c.NUMPAD_1] = "NumPad1", e[c.NUMPAD_2] = "NumPad2", e[c.NUMPAD_3] = "NumPad3", e[c.NUMPAD_4] = "NumPad4", e[c.NUMPAD_5] = "NumPad5", e[c.NUMPAD_6] = "NumPad6", e[c.NUMPAD_7] = "NumPad7", e[c.NUMPAD_8] = "NumPad8",e[c.NUMPAD_9] = "NumPad9",e[c.NUMPAD_MULTIPLY] = "NumPad_Multiply",e[c.NUMPAD_ADD] = "NumPad_Add",e[c.NUMPAD_SEPARATOR] = "NumPad_Separator",e[c.NUMPAD_SUBTRACT] = "NumPad_Subtract",e[c.NUMPAD_DECIMAL] = "NumPad_Decimal",e[c.NUMPAD_DIVIDE] = "NumPad_Divide"
    }, function (e) {
        e["\r"] = c.Enter
    }), f = o(function (e) {
        for (var t = 0, n = l._fromKeyCode.length; n > t; t++)e[t] = l._fromKeyCode[t];
        e[c.LeftArrow] = "Left", e[c.UpArrow] = "Up", e[c.RightArrow] = "Right", e[c.DownArrow] = "Down"
    }, function (e) {
        e.OEM_1 = c.US_SEMICOLON, e.OEM_PLUS = c.US_EQUAL, e.OEM_COMMA = c.US_COMMA, e.OEM_MINUS = c.US_MINUS, e.OEM_PERIOD = c.US_DOT, e.OEM_2 = c.US_SLASH, e.OEM_3 = c.US_BACKTICK, e.OEM_4 = c.US_OPEN_SQUARE_BRACKET, e.OEM_5 = c.US_BACKSLASH, e.OEM_6 = c.US_CLOSE_SQUARE_BRACKET, e.OEM_7 = c.US_QUOTE, e.OEM_8 = c.OEM_8, e.OEM_102 = c.OEM_102
    });
    !function (e) {
        function t(e) {
            return l.fromKeyCode(e)
        }

        function n(e) {
            return l.toKeyCode(e)
        }

        e.toString = t, e.fromString = n
    }(c = t.KeyCode || (t.KeyCode = {}));
    var p = 32768, d = 16384, h = 8192, m = 4096, g = 4095, v = function () {
        function e() {
        }

        return e.extractFirstPart = function (e) {
            return 65535 & e
        }, e.extractChordPart = function (e) {
            return e >> 16 & 65535
        }, e.hasChord = function (e) {
            return 0 !== this.extractChordPart(e)
        }, e.hasCtrlCmd = function (e) {
            return !!(e & p)
        }, e.hasShift = function (e) {
            return !!(e & d)
        }, e.hasAlt = function (e) {
            return !!(e & h)
        }, e.hasWinCtrl = function (e) {
            return !!(e & m)
        }, e.extractKeyCode = function (e) {
            return e & g
        }, e
    }();
    t.BinaryKeybindings = v;
    var w = function () {
        function e() {
        }

        return e.chord = function (e, t) {
            return e | (65535 & t) << 16
        }, e.CtrlCmd = p, e.Shift = d, e.Alt = h, e.WinCtrl = m, e
    }();
    t.KeyMod = w;
    var y = function () {
        function e() {
        }

        return e.ENTER = c.Enter, e.SHIFT_ENTER = w.Shift | c.Enter, e.CTRLCMD_ENTER = w.CtrlCmd | c.Enter, e.WINCTRL_ENTER = w.WinCtrl | c.Enter, e.TAB = c.Tab, e.SHIFT_TAB = w.Shift | c.Tab, e.ESCAPE = c.Escape, e.SPACE = c.Space, e.DELETE = c.Delete, e.SHIFT_DELETE = w.Shift | c.Delete, e.CTRLCMD_BACKSPACE = w.CtrlCmd | c.Backspace, e.UP_ARROW = c.UpArrow, e.SHIFT_UP_ARROW = w.Shift | c.UpArrow, e.CTRLCMD_UP_ARROW = w.CtrlCmd | c.UpArrow, e.DOWN_ARROW = c.DownArrow, e.SHIFT_DOWN_ARROW = w.Shift | c.DownArrow, e.CTRLCMD_DOWN_ARROW = w.CtrlCmd | c.DownArrow, e.LEFT_ARROW = c.LeftArrow, e.RIGHT_ARROW = c.RightArrow, e.PAGE_UP = c.PageUp, e.SHIFT_PAGE_UP = w.Shift | c.PageUp, e.PAGE_DOWN = c.PageDown, e.SHIFT_PAGE_DOWN = w.Shift | c.PageDown, e.F2 = c.F2, e.CTRLCMD_S = w.CtrlCmd | c.KEY_S, e.CTRLCMD_C = w.CtrlCmd | c.KEY_C, e.CTRLCMD_V = w.CtrlCmd | c.KEY_V, e
    }();
    t.CommonKeybindings = y;
    var b = function () {
        function e(e) {
            this.value = e
        }

        return e._toUSLabel = function (e, t) {
            return i(e, t.isMacintosh ? S.INSTANCE : P.INSTANCE, t)
        }, e._toUSAriaLabel = function (e, t) {
            return i(e, E.INSTANCE, t)
        }, e._toUSHTMLLabel = function (e, t) {
            return s(e, t.isMacintosh ? S.INSTANCE : P.INSTANCE, t)
        }, e._toCustomLabel = function (e, t, n) {
            return i(e, t, n)
        }, e._toCustomHTMLLabel = function (e, t, n) {
            return s(e, t, n)
        }, e._toElectronAccelerator = function (e, t) {
            return v.hasChord(e) ? null : i(e, _.INSTANCE, t)
        }, e.getUserSettingsKeybindingRegex = function () {
            if (!this._cachedKeybindingRegex) {
                var e = "numpad(0|1|2|3|4|5|6|7|8|9|_multiply|_add|_subtract|_decimal|_divide|_separator)", t = "`|\\-|=|\\[|\\]|\\\\\\\\|;|'|,|\\.|\\/|oem_8|oem_102", n = "left|up|right|down|pageup|pagedown|end|home|tab|enter|escape|space|backspace|delete|pausebreak|capslock|insert|contextmenu|numlock|scrolllock", r = "[a-z]|[0-9]|f(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19)", o = "((" + [e, t, n, r].join(")|(") + "))", i = "((ctrl|shift|alt|cmd|win|meta)\\+)*", a = "(" + i + o + ")";
                this._cachedKeybindingRegex = '"\\s*(' + a + "(\\s+" + a + ')?)\\s*"'
            }
            return this._cachedKeybindingRegex
        }, e.toUserSettingsLabel = function (e, t) {
            void 0 === t && (t = r);
            var n = i(e, C.INSTANCE, t);
            return n = n.toLowerCase(), t.isMacintosh ? n = n.replace(/meta/g, "cmd") : t.isWindows && (n = n.replace(/meta/g, "win")), n
        }, e.fromUserSettingsLabel = function (t, n) {
            if (void 0 === n && (n = r), !t)return null;
            t = t.toLowerCase().trim();
            for (var o = !1, i = !1, a = !1, s = !1, c = ""; /^(ctrl|shift|alt|meta|win|cmd)(\+|\-)/.test(t);)/^ctrl(\+|\-)/.test(t) && (n.isMacintosh ? s = !0 : o = !0, t = t.substr("ctrl-".length)), /^shift(\+|\-)/.test(t) && (i = !0, t = t.substr("shift-".length)), /^alt(\+|\-)/.test(t) && (a = !0, t = t.substr("alt-".length)), /^meta(\+|\-)/.test(t) && (n.isMacintosh ? o = !0 : s = !0, t = t.substr("meta-".length)), /^win(\+|\-)/.test(t) && (n.isMacintosh ? o = !0 : s = !0, t = t.substr("win-".length)), /^cmd(\+|\-)/.test(t) && (n.isMacintosh ? o = !0 : s = !0, t = t.substr("cmd-".length));
            var u = 0, l = t.indexOf(" ");
            l > 0 ? (c = t.substring(0, l), u = e.fromUserSettingsLabel(t.substring(l), n)) : c = t;
            var p = f.toKeyCode(c), d = 0;
            return o && (d |= w.CtrlCmd), i && (d |= w.Shift), a && (d |= w.Alt), s && (d |= w.WinCtrl), d |= p, w.chord(d, u)
        }, e.prototype.hasCtrlCmd = function () {
            return v.hasCtrlCmd(this.value)
        }, e.prototype.hasShift = function () {
            return v.hasShift(this.value)
        }, e.prototype.hasAlt = function () {
            return v.hasAlt(this.value)
        }, e.prototype.hasWinCtrl = function () {
            return v.hasWinCtrl(this.value)
        }, e.prototype.extractKeyCode = function () {
            return v.extractKeyCode(this.value)
        }, e.prototype._toUSLabel = function (t) {
            return void 0 === t && (t = r), e._toUSLabel(this.value, t)
        }, e.prototype._toUSAriaLabel = function (t) {
            return void 0 === t && (t = r), e._toUSAriaLabel(this.value, t)
        }, e.prototype._toUSHTMLLabel = function (t) {
            return void 0 === t && (t = r), e._toUSHTMLLabel(this.value, t)
        }, e.prototype.toCustomLabel = function (t, n) {
            return void 0 === n && (n = r), e._toCustomLabel(this.value, t, n)
        }, e.prototype.toCustomHTMLLabel = function (t, n) {
            return void 0 === n && (n = r), e._toCustomHTMLLabel(this.value, t, n)
        }, e.prototype._toElectronAccelerator = function (t) {
            return void 0 === t && (t = r), e._toElectronAccelerator(this.value, t)
        }, e.prototype.toUserSettingsLabel = function (t) {
            return void 0 === t && (t = r), e.toUserSettingsLabel(this.value, t)
        }, e._cachedKeybindingRegex = null, e
    }();
    t.Keybinding = b;
    var _ = function () {
        function e() {
            this.ctrlKeyLabel = "Ctrl", this.shiftKeyLabel = "Shift", this.altKeyLabel = "Alt", this.cmdKeyLabel = "Cmd", this.windowsKeyLabel = "Super", this.modifierSeparator = "+"
        }

        return e.prototype.getLabelForKey = function (e) {
            switch (e) {
                case c.UpArrow:
                    return "Up";
                case c.DownArrow:
                    return "Down";
                case c.LeftArrow:
                    return "Left";
                case c.RightArrow:
                    return "Right"
            }
            return c.toString(e)
        }, e.INSTANCE = new e, e
    }();
    t.ElectronAcceleratorLabelProvider = _;
    var S = function () {
        function e() {
            this.ctrlKeyLabel = "⌃", this.shiftKeyLabel = "⇧", this.altKeyLabel = "⌥", this.cmdKeyLabel = "⌘", this.windowsKeyLabel = n.localize(0, null), this.modifierSeparator = ""
        }

        return e.prototype.getLabelForKey = function (t) {
            switch (t) {
                case c.LeftArrow:
                    return e.leftArrowUnicodeLabel;
                case c.UpArrow:
                    return e.upArrowUnicodeLabel;
                case c.RightArrow:
                    return e.rightArrowUnicodeLabel;
                case c.DownArrow:
                    return e.downArrowUnicodeLabel
            }
            return c.toString(t)
        }, e.INSTANCE = new e, e.leftArrowUnicodeLabel = String.fromCharCode(8592), e.upArrowUnicodeLabel = String.fromCharCode(8593), e.rightArrowUnicodeLabel = String.fromCharCode(8594), e.downArrowUnicodeLabel = String.fromCharCode(8595), e
    }();
    t.MacUIKeyLabelProvider = S;
    var E = function () {
        function e() {
            this.ctrlKeyLabel = n.localize(1, null), this.shiftKeyLabel = n.localize(2, null), this.altKeyLabel = n.localize(3, null), this.cmdKeyLabel = n.localize(4, null), this.windowsKeyLabel = n.localize(5, null), this.modifierSeparator = "+"
        }

        return e.prototype.getLabelForKey = function (e) {
            return c.toString(e)
        }, e.INSTANCE = new S, e
    }();
    t.AriaKeyLabelProvider = E;
    var P = function () {
        function e() {
            this.ctrlKeyLabel = n.localize(6, null), this.shiftKeyLabel = n.localize(7, null), this.altKeyLabel = n.localize(8, null), this.cmdKeyLabel = n.localize(9, null), this.windowsKeyLabel = n.localize(10, null), this.modifierSeparator = "+"
        }

        return e.prototype.getLabelForKey = function (e) {
            return c.toString(e)
        }, e.INSTANCE = new e, e
    }();
    t.ClassicUIKeyLabelProvider = P;
    var C = function () {
        function e() {
            this.ctrlKeyLabel = "Ctrl", this.shiftKeyLabel = "Shift", this.altKeyLabel = "Alt", this.cmdKeyLabel = "Meta", this.windowsKeyLabel = "Meta", this.modifierSeparator = "+"
        }

        return e.prototype.getLabelForKey = function (e) {
            return f.fromKeyCode(e)
        }, e.INSTANCE = new e, e
    }()
}), define("vs/nls!vs/workbench/electron-main/menus", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/workbench/electron-main/menus", t)
}), define("vs/nls!vs/workbench/electron-main/windows", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/workbench/electron-main/windows", t)
}), define("vs/nls!vs/workbench/parts/git/electron-main/askpassService", ["vs/nls", "vs/nls!vs/workbench/electron-main/main"], function (e, t) {
    return e.create("vs/workbench/parts/git/electron-main/askpassService", t)
}), define("vs/workbench/electron-main/env", ["require", "exports", "crypto", "fs", "path", "os", "electron", "vs/base/common/arrays", "vs/base/common/strings", "vs/base/common/paths", "vs/base/common/platform", "vs/base/common/uri", "vs/base/common/types"], function (e, t, n, r, o, i, a, s, c, u, l, f, p) {
    "use strict";
    function d() {
        for (var e = [], n = 0; n < arguments.length; n++)e[n - 0] = arguments[n];
        t.cliArgs.verboseLogging && console.log.apply(null, e)
    }

    function h() {
        var e = Array.prototype.slice.call(process.argv, 1);
        if (!t.isBuilt) {
            var n = function () {
                for (var t = 0; t < e.length; t++)if ("-" !== e[t][0])return t;
                return -1
            }();
            n > -1 && e.splice(n, 1)
        }
        if (r.existsSync(o.join(t.appRoot, "argv"))) {
            var i = JSON.parse(r.readFileSync(o.join(t.appRoot, "argv"), "utf8"));
            e = i.concat(e)
        }
        var a, s, c = y(e), u = !!c.g || !!c["goto"], l = P(e, "--debugBrkPluginHost", 5870);
        l ? (a = l, s = !0) : a = P(e, "--debugPluginHost", 5870, t.isBuilt ? void 0 : 5870);
        var f = b(e, u);
        return {
            pathArguments: f,
            programStart: P(e, "--timestamp", 0, 0),
            enablePerformance: !!c.p,
            verboseLogging: !!c.verbose,
            debugPluginHostPort: a,
            debugBrkPluginHost: s,
            logPluginHostCommunication: !!c.logPluginHostCommunication,
            firstrun: !!c["squirrel-firstrun"],
            openNewWindow: !!c.n || !!c["new-window"],
            openInSameWindow: !!c.r || !!c["reuse-window"],
            gotoLineMode: u,
            diffMode: !(!c.d && !c.diff || 2 !== f.length),
            pluginHomePath: S(C(e, "--extensionHomePath")),
            extensionDevelopmentPath: S(C(e, "--extensionDevelopmentPath")),
            extensionTestsPath: S(C(e, "--extensionTestsPath")),
            disableExtensions: !!c.disableExtensions || !!c["disable-extensions"],
            locale: C(e, "--locale"),
            waitForWindowClose: !!c.w || !!c.wait
        }
    }

    function m() {
        var e = a.app.getName();
        t.isBuilt || (e += "-dev");
        var n = w();
        return n && (e += "-" + n), "win32" === process.platform ? "\\\\.\\pipe\\" + e : o.join(i.tmpdir(), e)
    }

    function g() {
        return m() + ("win32" === process.platform ? "-sock" : ".sock")
    }

    function v() {
        return m() + "-shared" + ("win32" === process.platform ? "-sock" : ".sock")
    }

    function w() {
        var e;
        return e = l.isWindows ? process.env.USERNAME : process.env.USER, e ? n.createHash("sha256").update(e).digest("hex").substr(0, 6) : ""
    }

    function y(e) {
        return e.filter(function (e) {
            return /^-/.test(e)
        }).map(function (e) {
            return e.replace(/^-*/, "")
        }).reduce(function (e, t) {
            return e[t] = !0, e
        }, {})
    }

    function b(e, t) {
        return s.coalesce(s.distinct(e.filter(function (e) {
            return !/^-/.test(e)
        }).map(function (e) {
            var n, i = e;
            t && (n = A(e), i = n.path), i && (i = _(i));
            var a;
            try {
                a = r.realpathSync(i)
            } catch (s) {
                a = o.normalize(o.isAbsolute(i) ? i : o.join(process.cwd(), i))
            }
            return u.isValidBasename(o.basename(a)) ? t ? (n.path = a, M(n)) : a : null
        }), function (e) {
            return e && (l.isWindows || l.isMacintosh) ? e.toLowerCase() : e
        }))
    }

    function _(e) {
        return l.isWindows && (e = c.rtrim(e, '"')), e = c.trim(c.trim(e, " "), "	"), l.isWindows && (e = c.rtrim(E(e), ".")), e
    }

    function S(e) {
        return e ? o.normalize(e) : e
    }

    function E(e) {
        return e ? o.resolve(e) : e
    }

    function P(e, t, n, r) {
        for (var o, i = 0; i < e.length; i++) {
            var a = e[i].split("=");
            if (a[0] === t) {
                o = Number(a[1]) || n;
                break
            }
        }
        return p.isNumber(o) ? o : r
    }

    function C(e, t, n, r) {
        for (var o, i = 0; i < e.length; i++) {
            var a = e[i].split("=");
            if (a[0] === t) {
                o = String(a[1]) || n;
                break
            }
        }
        return p.isString(o) ? c.trim(o, '"') : r
    }

    function k() {
        return "linux" === process.platform ? "linux-" + process.arch : process.platform
    }

    function A(e) {
        var t, n = e.split(":"), r = null, o = null;
        return n.forEach(function (e) {
            var n = Number(e);
            p.isNumber(n) ? null === r ? r = n : null === o && (o = n) : t = t ? [t, e].join(":") : e
        }), {path: t, line: null !== r ? r : void 0, column: null !== o ? o : null !== r ? 1 : void 0}
    }

    function M(e) {
        var t = [e.path];
        return p.isNumber(e.line) && t.push(String(e.line)), p.isNumber(e.column) && t.push(String(e.column)), t.join(":")
    }

    t.isBuilt = !process.env.VSCODE_DEV, t.appRoot = o.dirname(f["default"].parse(e.toUrl("")).fsPath);
    var x;
    try {
        x = JSON.parse(r.readFileSync(o.join(t.appRoot, "product.json"), "utf8"))
    } catch (T) {
        x = Object.create(null)
    }
    t.product = x, t.product.nameShort = t.product.nameShort + (t.isBuilt ? "" : " Dev"), t.product.nameLong = t.product.nameLong + (t.isBuilt ? "" : " Dev"), t.product.dataFolderName = t.product.dataFolderName + (t.isBuilt ? "" : "-dev"), t.updateUrl = t.product.updateUrl, t.quality = t.product.quality, t.mainIPCHandle = g(), t.sharedIPCHandle = v(), t.version = a.app.getVersion(), t.cliArgs = h(), t.appHome = a.app.getPath("userData"), t.appSettingsHome = o.join(t.appHome, "User"), r.existsSync(t.appSettingsHome) || r.mkdirSync(t.appSettingsHome), t.appSettingsPath = o.join(t.appSettingsHome, "settings.json"), t.appKeybindingsPath = o.join(t.appSettingsHome, "keybindings.json"), t.userHome = o.join(a.app.getPath("home"), t.product.dataFolderName), r.existsSync(t.userHome) || r.mkdirSync(t.userHome), t.userExtensionsHome = t.cliArgs.pluginHomePath || o.join(t.userHome, "extensions"), r.existsSync(t.userExtensionsHome) || r.mkdirSync(t.userExtensionsHome), t.isTestingFromCli = t.cliArgs.extensionTestsPath && !t.cliArgs.debugBrkPluginHost, t.log = d, t.getPlatformIdentifier = k, t.parseLineAndColumnAware = A, t.toLineAndColumnPath = M
}), define("vs/workbench/electron-main/storage", ["require", "exports", "path", "fs", "events", "vs/workbench/electron-main/env"], function (e, t, n, r, o, i) {
    "use strict";
    function a(e) {
        return m.addListener(h.STORE, e), function () {
            return m.removeListener(h.STORE, e)
        }
    }

    function s(e, t) {
        d || (d = l());
        var n = d[e];
        return "undefined" == typeof n ? t : d[e]
    }

    function c(e, t) {
        if (d || (d = l()), "string" != typeof t && "number" != typeof t && "boolean" != typeof t || d[e] !== t) {
            var n = d[e];
            d[e] = t, f(), m.emit(h.STORE, e, n, t)
        }
    }

    function u(e) {
        if (d || (d = l()), d[e]) {
            var t = d[e];
            delete d[e], f(), m.emit(h.STORE, e, t, null)
        }
    }

    function l() {
        try {
            return JSON.parse(r.readFileSync(p).toString())
        } catch (e) {
            return i.cliArgs.verboseLogging && console.error(e), {}
        }
    }

    function f() {
        r.writeFileSync(p, JSON.stringify(d, null, 4))
    }

    var p = n.join(i.appHome, "storage.json"), d = null, h = {STORE: "store"}, m = new o.EventEmitter;
    t.onStore = a, t.getItem = s, t.setItem = c, t.removeItem = u
}), define("vs/workbench/electron-main/window", ["require", "exports", "path", "os", "electron", "vs/base/common/winjs.base", "vs/base/common/platform", "vs/base/common/objects", "vs/workbench/electron-main/env", "vs/workbench/electron-main/storage"], function (e, t, n, r, o, i, a, s, c, u) {
    "use strict";
    !function (e) {
        e[e.Maximized = 0] = "Maximized", e[e.Normal = 1] = "Normal", e[e.Minimized = 2] = "Minimized"
    }(t.WindowMode || (t.WindowMode = {}));
    var l = t.WindowMode;
    t.defaultWindowState = function (e) {
        return void 0 === e && (e = l.Normal), {width: 1024, height: 768, mode: e}
    }, function (e) {
        e[e.NONE = 0] = "NONE", e[e.LOADING = 1] = "LOADING", e[e.NAVIGATING = 2] = "NAVIGATING", e[e.READY = 3] = "READY"
    }(t.ReadyState || (t.ReadyState = {}));
    var f = t.ReadyState, p = function () {
        function p(e) {
            this._lastFocusTime = -1, this._readyState = f.NONE, this._extensionDevelopmentPath = e.extensionDevelopmentPath, this.whenReadyCallbacks = [], this.restoreWindowState(e.state);
            var t = /vs($| )/.test(u.getItem(p.themeStorageKey)), r = t;
            r && !global.windowShow && (global.windowShow = (new Date).getTime());
            var i = {
                width: this.windowState.width,
                height: this.windowState.height,
                x: this.windowState.x,
                y: this.windowState.y,
                backgroundColor: t ? "#FFFFFF" : "#1E1E1E",
                minWidth: 800,
                minHeight: 600,
                show: r && this.currentWindowMode !== l.Maximized,
                title: c.product.nameLong,
                frame: false
            };
            a.isLinux && (i.icon = n.join(c.appRoot, "resources/linux/code.png")), this._win = new o.BrowserWindow(i), this._id = this._win.id, r && this.currentWindowMode === l.Maximized && (this.win.maximize(), this.win.isVisible() || this.win.show()), r && (this._lastFocusTime = (new Date).getTime()), u.getItem(p.menuBarHiddenKey, !1) && this.setMenuBarVisibility(!1), this.registerListeners()
        }

        return Object.defineProperty(p.prototype, "isPluginDevelopmentHost", {
            get: function () {
                return !!this._extensionDevelopmentPath
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "extensionDevelopmentPath", {
            get: function () {
                return this._extensionDevelopmentPath
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "config", {
            get: function () {
                return this.currentConfig
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "id", {
            get: function () {
                return this._id
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "win", {
            get: function () {
                return this._win
            }, enumerable: !0, configurable: !0
        }), p.prototype.focus = function () {
            this._win && (a.isWindows && r.release() && 0 === r.release().indexOf("10.") && !this._win.isFocused() ? (this._win.minimize(), this._win.focus()) : (this._win.isMinimized() && this._win.restore(), this._win.focus()))
        }, Object.defineProperty(p.prototype, "lastFocusTime", {
            get: function () {
                return this._lastFocusTime
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "openedWorkspacePath", {
            get: function () {
                return this.currentConfig.workspacePath
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(p.prototype, "openedFilePath", {
            get: function () {
                return this.currentConfig.filesToOpen && this.currentConfig.filesToOpen[0] && this.currentConfig.filesToOpen[0].filePath
            }, enumerable: !0, configurable: !0
        }), p.prototype.setReady = function () {
            for (this._readyState = f.READY; this.whenReadyCallbacks.length;)this.whenReadyCallbacks.pop()(this)
        }, p.prototype.ready = function () {
            var e = this;
            return new i.TPromise(function (t) {
                return e._readyState === f.READY ? t(e) : void e.whenReadyCallbacks.push(t)
            })
        }, Object.defineProperty(p.prototype, "readyState", {
            get: function () {
                return this._readyState
            }, enumerable: !0, configurable: !0
        }), p.prototype.registerListeners = function () {
            var e = this;
            this._win.webContents.on("did-finish-load", function () {
                e._readyState = f.LOADING, e.pendingLoadConfig && (e.currentConfig = e.pendingLoadConfig, e.pendingLoadConfig = null), e.win.isVisible() || (global.windowShow || (global.windowShow = (new Date).getTime()), e.currentWindowMode === l.Maximized && e.win.maximize(), e.win.isVisible() || e.win.show())
            }), this._win.on("app-command", function (t, n) {
                e.readyState === f.READY && ("browser-backward" === n ? e.send("vscode:runAction", "workbench.action.navigateBack") : "browser-forward" === n && e.send("vscode:runAction", "workbench.action.navigateForward"))
            }), this._win.webContents.on("new-window", function (e, t) {
                e.preventDefault(), o.shell.openExternal(t)
            }), this._win.on("focus", function () {
                e._lastFocusTime = (new Date).getTime()
            }), this._win.webContents.on("did-fail-load", function (e, t, n) {
                console.warn("[electron event]: fail to load, ", n)
            }), c.isBuilt && this._win.webContents.on("will-navigate", function (e) {
                e && e.preventDefault()
            })
        }, p.prototype.load = function (e) {
            var t = this;
            this.readyState === f.NONE ? this.currentConfig = e : (this.pendingLoadConfig = e, this._readyState = f.NAVIGATING), this._win.loadURL(this.getUrl(e)), e.isBuilt || (this.showTimeoutHandle = setTimeout(function () {
                !t._win || t._win.isVisible() || t._win.isMinimized() || (t._win.show(), t._win.focus(), t._win.webContents.openDevTools())
            }, 1e4))
        }, p.prototype.reload = function (e) {
            var t = s.mixin({}, this.currentConfig);
            delete t.filesToOpen, delete t.filesToCreate, delete t.filesToDiff, delete t.extensionsToInstall, this.isPluginDevelopmentHost && e && (t.verboseLogging = e.verboseLogging, t.logPluginHostCommunication = e.logPluginHostCommunication, t.debugPluginHostPort = e.debugPluginHostPort, t.debugBrkPluginHost = e.debugBrkPluginHost, t.pluginHomePath = e.pluginHomePath), this.load(t)
        }, p.prototype.getUrl = function (t) {
            var n = e.toUrl('vs/layaEditor/h5/index.html');
            return n += "?config=" + encodeURIComponent(JSON.stringify(t))
        }, p.prototype.serializeWindowState = function () {
            if (this.win.isFullScreen())return t.defaultWindowState();
            var e, n = Object.create(null);
            if (e = !a.isMacintosh && this.win.isMaximized() ? l.Maximized : this.win.isMinimized() ? l.Minimized : l.Normal, e === l.Maximized ? n.mode = l.Maximized : e !== l.Minimized && (n.mode = l.Normal), e === l.Normal || e === l.Maximized) {
                var r = this.win.getPosition(), o = this.win.getSize();
                n.x = r[0], n.y = r[1], n.width = o[0], n.height = o[1]
            }
            return n
        }, p.prototype.restoreWindowState = function (e) {
            if (e)try {
                e = this.validateWindowState(e)
            } catch (n) {
                c.log("Unexpected error validating window state: " + n + "\n" + n.stack)
            }
            e || (e = t.defaultWindowState()), this.windowState = e, this.currentWindowMode = this.windowState.mode
        }, p.prototype.validateWindowState = function (e) {
            if (!e)return null;
            if ([e.x, e.y, e.width, e.height].some(function (e) {
                    return "number" != typeof e
                }))return null;
            if (e.width <= 0 || e.height <= 0)return null;
            var n = o.screen.getAllDisplays();
            if (1 === n.length) {
                var r = n[0].bounds;
                return e.mode !== l.Maximized && r.width > 0 && r.height > 0 && (e.x < r.x && (e.x = r.x), e.y < r.y && (e.y = r.y), e.x > r.x + r.width && (e.x = r.x), e.y > r.y + r.height && (e.y = r.y), e.width > r.width && (e.width = r.width), e.height > r.height && (e.height = r.height)), e.mode === l.Maximized ? t.defaultWindowState(l.Maximized) : e
            }
            var i = {x: e.x, y: e.y, width: e.width, height: e.height}, a = o.screen.getDisplayMatching(i);
            if (a && a.bounds.x + a.bounds.width > i.x && a.bounds.y + a.bounds.height > i.y) {
                if (e.mode === l.Maximized) {
                    var s = t.defaultWindowState(l.Maximized);
                    return s.x = e.x, s.y = e.y, s
                }
                return e
            }
            return null
        }, p.prototype.getBounds = function () {
            var e = this.win.getPosition(), t = this.win.getSize();
            return {x: e[0], y: e[1], width: t[0], height: t[1]}
        }, p.prototype.toggleFullScreen = function () {
            var e = !this.win.isFullScreen();
            this.win.setFullScreen(e), (a.isWindows || a.isLinux) && (e ? this.setMenuBarVisibility(!1) : this.setMenuBarVisibility(!u.getItem(p.menuBarHiddenKey, !1)))
        }, p.prototype.setMenuBarVisibility = function (e) {
            this.win.setMenuBarVisibility(e), this.win.setAutoHideMenuBar(!e)
        }, p.prototype.sendWhenReady = function (e) {
            for (var t = this, n = [], r = 1; r < arguments.length; r++)n[r - 1] = arguments[r];
            this.ready().then(function () {
                t.send.apply(t, [e].concat(n))
            })
        }, p.prototype.send = function (e) {
            for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
            (r = this._win.webContents).send.apply(r, [e].concat(t));
            var r
        }, p.prototype.dispose = function () {
            this.showTimeoutHandle && clearTimeout(this.showTimeoutHandle), this._win = null
        }, p.menuBarHiddenKey = "menuBarHidden", p.themeStorageKey = "theme", p.MIN_WIDTH = 200, p.MIN_HEIGHT = 120, p
    }();
    t.VSCodeWindow = p
}), define("vs/workbench/electron-main/lifecycle", ["require", "exports", "events", "electron", "vs/base/common/winjs.base", "vs/workbench/electron-main/window", "vs/workbench/electron-main/env"], function (e, t, n, r, o, i, a) {
    "use strict";
    function s(e) {
        return c.addListener(u.BEFORE_QUIT, e), function () {
            return c.removeListener(u.BEFORE_QUIT, e)
        }
    }

    var c = new n.EventEmitter, u = {BEFORE_QUIT: "before-quit"};
    t.onBeforeQuit = s;
    var l = function () {
        function e() {
            this.windowToCloseRequest = Object.create(null), this.quitRequested = !1, this.oneTimeListenerTokenGenerator = 0
        }

        return e.prototype.ready = function () {
            this.registerListeners()
        }, e.prototype.registerListeners = function () {
            var e = this;
            r.app.on("before-quit", function (t) {
                a.log("Lifecycle#before-quit"), e.quitRequested || c.emit(u.BEFORE_QUIT), e.quitRequested = !0
            }), r.app.on("window-all-closed", function () {
                a.log("Lifecycle#window-all-closed"), (e.quitRequested || "darwin" !== process.platform || a.cliArgs.waitForWindowClose) && r.app.quit()
            })
        }, e.prototype.registerWindow = function (e) {
            var t = this;
            e.win.on("close", function (n) {
                var r = e.id;
                return a.log("Lifecycle#window-before-close", r), t.windowToCloseRequest[r] ? (a.log("Lifecycle#window-close", r), void delete t.windowToCloseRequest[r]) : (n.preventDefault(), void t.unload(e).done(function (n) {
                    n ? (t.quitRequested = !1, delete t.windowToCloseRequest[r]) : (t.windowToCloseRequest[r] = !0, e.win.close())
                }))
            })
        }, e.prototype.unload = function (e) {
            var t = this;
            return a.log("Lifecycle#unload()", e.id), e.readyState !== i.ReadyState.READY ? o.TPromise.as(!1) : new o.TPromise(function (n) {
                var o = t.oneTimeListenerTokenGenerator++, i = "vscode:ok" + o, a = "vscode:cancel" + o;
                r.ipcMain.once(i, function () {
                    n(!1)
                }), r.ipcMain.once(a, function () {
                    t.pendingQuitPromiseComplete && (t.pendingQuitPromiseComplete(!0), t.pendingQuitPromiseComplete = null, t.pendingQuitPromise = null), n(!0)
                }), e.send("vscode:beforeUnload", {okChannel: i, cancelChannel: a})
            })
        }, e.prototype.quit = function () {
            var e = this;
            return a.log("Lifecycle#quit()"), this.pendingQuitPromise || (this.pendingQuitPromise = new o.TPromise(function (t) {
                e.pendingQuitPromiseComplete = t, r.app.once("will-quit", function () {
                    e.pendingQuitPromiseComplete && (e.pendingQuitPromiseComplete(!1), e.pendingQuitPromiseComplete = null, e.pendingQuitPromise = null)
                }), r.app.quit()
            })), this.pendingQuitPromise
        }, e
    }();
    t.Lifecycle = l, t.manager = new l
}), define("vs/workbench/node/userSettings", ["require", "exports", "fs", "path", "vs/base/common/json", "vs/base/common/objects", "vs/base/common/winjs.base", "vs/base/common/event"], function (e, t, n, r, o, i, a, s) {
    "use strict";
    var c = function () {
        function e(e, t) {
            this.appSettingsPath = e, this.appKeybindingsPath = t, this._onChange = new s.Emitter, this.registerWatchers()
        }

        return e.getValue = function (t, r, i) {
            return new a.TPromise(function (a, s) {
                var c = t.getConfiguration().env.appSettingsPath;
                n.readFile(c, function (t, n) {
                    var s = Object.create(null), c = n ? n.toString() : "{}", u = Object.create(null);
                    try {
                        u = o.parse(c)
                    } catch (t) {
                    }
                    for (var l in u)e.setNode(s, l, u[l]);
                    return a(e.doGetValue(s, r, i))
                })
            })
        }, Object.defineProperty(e.prototype, "onChange", {
            get: function () {
                return this._onChange.event
            }, enumerable: !0, configurable: !0
        }), e.prototype.getValue = function (t, n) {
            return e.doGetValue(this.globalSettings.settings, t, n)
        }, e.doGetValue = function (e, t, n) {
            if (!t)return n;
            for (var r = e, o = t.split("."); o.length && r;) {
                var i = o.shift();
                r = r[i]
            }
            return "undefined" != typeof r ? r : n
        }, e.prototype.registerWatchers = function () {
            var e = this;
            this.watcher = n.watch(r.dirname(this.appSettingsPath)), this.watcher.on("change", function (t, n) {
                return e.onSettingsFileChange(t, n)
            })
        }, e.prototype.onSettingsFileChange = function (t, n) {
            var r = this;
            this.timeoutHandle && (global.clearTimeout(this.timeoutHandle), this.timeoutHandle = null), this.timeoutHandle = global.setTimeout(function () {
                var e = r.loadSync();
                e && r._onChange.fire(r.globalSettings)
            }, e.CHANGE_BUFFER_DELAY)
        }, e.prototype.loadSync = function () {
            var e = this.doLoadSync();
            return i.equals(e, this.globalSettings) ? !1 : (this.globalSettings = e, !0)
        }, e.prototype.doLoadSync = function () {
            var e = this.doLoadSettingsSync();
            return {settings: e.contents, settingsParseErrors: e.parseErrors, keybindings: this.doLoadKeybindingsSync()}
        }, e.prototype.doLoadSettingsSync = function () {
            var t = Object.create(null), r = "{}";
            try {
                r = n.readFileSync(this.appSettingsPath).toString()
            } catch (i) {
            }
            var a = Object.create(null);
            try {
                a = o.parse(r)
            } catch (i) {
                return {contents: Object.create(null), parseErrors: [this.appSettingsPath]}
            }
            for (var s in a)e.setNode(t, s, a[s]);
            return {contents: t}
        }, e.setNode = function (e, t, n) {
            var r = t.split("."), o = r.pop(), i = e;
            r.forEach(function (e) {
                var n = i[e];
                switch (typeof n) {
                    case"undefined":
                        n = i[e] = {};
                        break;
                    case"object":
                        break;
                    default:
                        console.log("Conflicting user settings: " + t + " at " + e + " with " + JSON.stringify(n))
                }
                i = n
            }), i[o] = n
        }, e.prototype.doLoadKeybindingsSync = function () {
            try {
                return o.parse(n.readFileSync(this.appKeybindingsPath).toString())
            } catch (e) {
            }
            return []
        }, e.prototype.dispose = function () {
            this.watcher && (this.watcher.close(), this.watcher = null)
        }, e.CHANGE_BUFFER_DELAY = 300, e
    }();
    t.UserSettings = c
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/electron-main/settings", ["require", "exports", "electron", "vs/workbench/electron-main/env", "vs/workbench/node/userSettings"], function (e, t, n, r, o) {
    "use strict";
    var i = function (e) {
        function t() {
            var t = this;
            e.call(this, r.appSettingsPath, r.appKeybindingsPath), n.app.on("will-quit", function () {
                t.dispose()
            })
        }

        return __extends(t, e), t.prototype.loadSync = function () {
            var t = e.prototype.loadSync.call(this);
            return t && (global.globalSettingsValue = JSON.stringify(this.globalSettings)), t
        }, t
    }(o.UserSettings);
    t.SettingsManager = i, t.manager = new i
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/electron-main/win32/auto-updater.win32", ["require", "exports", "events", "path", "os", "child_process", "vs/base/node/pfs", "vs/base/node/extfs", "vs/base/common/types", "vs/base/common/winjs.base", "vs/base/node/request", "vs/base/node/proxy", "vs/workbench/electron-main/settings", "vs/workbench/electron-main/lifecycle"], function (e, t, n, r, o, i, a, s, c, u, l, f, p, d) {
    "use strict";
    var h = function (e) {
        function t() {
            e.call(this), this.url = null, this.currentRequest = null
        }

        return __extends(t, e), Object.defineProperty(t.prototype, "cachePath", {
            get: function () {
                var e = r.join(o.tmpdir(), "vscode-update");
                return new u.TPromise(function (t, n) {
                    return s.mkdirp(e, null, function (r) {
                        return r ? n(r) : t(e)
                    })
                })
            }, enumerable: !0, configurable: !0
        }), t.prototype.setFeedURL = function (e) {
            this.url = e
        }, t.prototype.checkForUpdates = function () {
            var e = this;
            if (!this.url)throw new Error("No feed url set.");
            if (!this.currentRequest) {
                this.emit("checking-for-update");
                var t = p.manager.getValue("http.proxy"), n = p.manager.getValue("http.proxyStrictSSL", !0), r = f.getProxyAgent(this.url, {
                    proxyUrl: t,
                    strictSSL: n
                });
                this.currentRequest = l.json({url: this.url, agent: r}).then(function (r) {
                    return r && r.url && r.version ? (e.emit("update-available"), e.cleanup(r.version).then(function () {
                        return e.getUpdatePackagePath(r.version).then(function (e) {
                            return a.exists(e).then(function (o) {
                                if (o)return u.TPromise.as(e);
                                var i = r.url, s = e + ".tmp", c = f.getProxyAgent(i, {proxyUrl: t, strictSSL: n});
                                return l.download(s, {url: i, agent: c, strictSSL: n}).then(function () {
                                    return a.rename(s, e)
                                }).then(function () {
                                    return e
                                })
                            })
                        }).then(function (t) {
                            e.emit("update-downloaded", {}, r.releaseNotes, r.version, new Date, e.url, function () {
                                return e.quitAndUpdate(t)
                            })
                        })
                    })) : (e.emit("update-not-available"), e.cleanup())
                }).then(null, function (t) {
                    c.isString(t) && /^Server returned/.test(t) || (e.emit("update-not-available"), e.emit("error", t))
                }).then(function () {
                    return e.currentRequest = null
                })
            }
        }, t.prototype.getUpdatePackagePath = function (e) {
            return this.cachePath.then(function (t) {
                return r.join(t, "CodeSetup-" + e + ".exe")
            })
        }, t.prototype.quitAndUpdate = function (e) {
            d.manager.quit().done(function (t) {
                t || i.spawn(e, ["/silent", "/mergetasks=runcode,!desktopicon,!quicklaunchicon"], {
                    detached: !0,
                    stdio: ["ignore", "ignore", "ignore"]
                })
            })
        }, t.prototype.cleanup = function (e) {
            void 0 === e && (e = null);
            var t = e ? function (t) {
                return !new RegExp(e + "\\.exe$").test(t)
            } : function () {
                return !0
            };
            return this.cachePath.then(function (e) {
                return a.readdir(e).then(function (n) {
                    return u.Promise.join(n.filter(t).map(function (t) {
                        return a.unlink(r.join(e, t)).then(null, function () {
                            return null
                        })
                    }))
                })
            })
        }, t
    }(n.EventEmitter);
    t.Win32AutoUpdaterImpl = h
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/electron-main/update-manager", ["require", "exports", "fs", "path", "events", "electron", "vs/base/common/platform", "vs/workbench/electron-main/env", "vs/workbench/electron-main/settings", "vs/workbench/electron-main/win32/auto-updater.win32", "vs/workbench/electron-main/lifecycle"], function (e, t, n, r, o, i, a, s, c, u, l) {
    "use strict";
    !function (e) {
        e[e.Uninitialized = 0] = "Uninitialized", e[e.Idle = 1] = "Idle", e[e.CheckingForUpdate = 2] = "CheckingForUpdate", e[e.UpdateAvailable = 3] = "UpdateAvailable", e[e.UpdateDownloaded = 4] = "UpdateDownloaded"
    }(t.State || (t.State = {}));
    var f = t.State;
    !function (e) {
        e[e.Implicit = 0] = "Implicit", e[e.Explicit = 1] = "Explicit"
    }(t.ExplicitState || (t.ExplicitState = {}));
    var p = t.ExplicitState, d = function (e) {
        function t() {
            e.call(this), this._state = f.Uninitialized, this.explicitState = p.Implicit, this._availableUpdate = null, this._lastCheckDate = null, this._feedUrl = null, this._channel = null, a.isWindows ? this.raw = new u.Win32AutoUpdaterImpl : a.isMacintosh && (this.raw = i.autoUpdater), this.raw && this.initRaw()
        }

        return __extends(t, e), t.prototype.initRaw = function () {
            var e = this;
            this.raw.on("error", function (t, n) {
                e.emit("error", t, n), e.setState(f.Idle)
            }), this.raw.on("checking-for-update", function () {
                e.emit("checking-for-update"), e.setState(f.CheckingForUpdate)
            }), this.raw.on("update-available", function () {
                e.emit("update-available"), e.setState(f.UpdateAvailable)
            }), this.raw.on("update-not-available", function () {
                e.emit("update-not-available", e.explicitState === p.Explicit), e.setState(f.Idle)
            }), this.raw.on("update-downloaded", function (t, n, r, o, i, a) {
                var s = {
                    releaseNotes: n, version: r, date: o, quitAndUpdate: function () {
                        return e.quitAndUpdate(a)
                    }
                };
                e.emit("update-downloaded", s), e.setState(f.UpdateDownloaded, s)
            })
        }, t.prototype.quitAndUpdate = function (e) {
            l.manager.quit().done(function (t) {
                t || e()
            })
        }, Object.defineProperty(t.prototype, "feedUrl", {
            get: function () {
                return this._feedUrl
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(t.prototype, "channel", {
            get: function () {
                return this._channel
            }, enumerable: !0, configurable: !0
        }), t.prototype.initialize = function () {
            var e = this;
            if (!this.feedUrl) {
                var n = t.getUpdateChannel(), r = t.getUpdateFeedUrl(n);
                if (r) {
                    this._channel = n, this._feedUrl = r, this.raw.setFeedURL(r), this.setState(f.Idle);
                    var o = setTimeout(function () {
                        return e.checkForUpdates()
                    }, 3e4);
                    this.on("error", function (e, t) {
                        return console.error(e, t)
                    }), this.on("checking-for-update", function () {
                        return clearTimeout(o)
                    }), this.on("update-not-available", function () {
                        o = setTimeout(function () {
                            return e.checkForUpdates()
                        }, 6e5)
                    })
                }
            }
        }, Object.defineProperty(t.prototype, "state", {
            get: function () {
                return this._state
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(t.prototype, "availableUpdate", {
            get: function () {
                return this._availableUpdate
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(t.prototype, "lastCheckDate", {
            get: function () {
                return this._lastCheckDate
            }, enumerable: !0, configurable: !0
        }), t.prototype.checkForUpdates = function (e) {
            void 0 === e && (e = !1), this.explicitState = e ? p.Explicit : p.Implicit, this._lastCheckDate = new Date, this.raw.checkForUpdates()
        }, t.prototype.setState = function (e, t) {
            void 0 === t && (t = null), this._state = e, this._availableUpdate = t, this.emit("change")
        }, t.getUpdateChannel = function () {
            var e = c.manager.getValue("update.channel") || "default";
            return "none" === e ? null : s.quality
        },
            t.getUpdateFeedUrl = function (e) {
                return e ? a.isLinux ? null : a.isWindows && !n.existsSync(r.join(r.dirname(process.execPath), "unins000.exe")) ? null : s.updateUrl && s.product.commit ? s.updateUrl + "/api/update/" + s.getPlatformIdentifier() + "/" + e + "/" + s.product.commit : null : null
            }, t
    }(o.EventEmitter);
    t.UpdateManager = d, t.Instance = new d
}), define("vs/workbench/electron-main/sharedProcess", ["require", "exports", "child_process", "vs/base/common/uri", "vs/base/common/objects", "vs/workbench/electron-main/env", "vs/workbench/electron-main/settings", "vs/workbench/electron-main/update-manager"], function (e, t, n, r, o, i, a, s) {
    "use strict";
    function c() {
        var e = o.assign({}, i.cliArgs);
        return e.execPath = process.execPath, e.appName = i.product.nameLong, e.appRoot = i.appRoot, e.version = i.version, e.commitHash = i.product.commit, e.appSettingsHome = i.appSettingsHome, e.appSettingsPath = i.appSettingsPath, e.appKeybindingsPath = i.appKeybindingsPath, e.userExtensionsHome = i.userExtensionsHome, e.isBuilt = i.isBuilt, e.updateFeedUrl = s.Instance.feedUrl, e.updateChannel = s.Instance.channel, e.extensionsGallery = i.product.extensionsGallery, e
    }

    function u() {
        var e = {env: o.assign(o.assign({}, process.env), {AMD_ENTRYPOINT: "vs/workbench/electron-main/sharedProcessMain"})}, t = n.fork(f, ["--type=SharedProcess"], e);
        return t.once("message", function () {
            t.send({configuration: {env: c()}, contextServiceOptions: {globalSettings: a.manager.globalSettings}})
        }), t
    }

    function l() {
        var e, t = function () {
            ++p > 10 || (e = u(), e.on("exit", t))
        };
        return t(), {
            dispose: function () {
                e && (e.removeListener("exit", t), e.kill(), e = null)
            }
        }
    }

    var f = r["default"].parse(e.toUrl("bootstrap")).fsPath, p = 0;
    t.spawnSharedProcess = l
}), define("vs/workbench/electron-main/windows", ["require", "exports", "events", "path", "fs", "electron", "vs/base/common/platform", "vs/workbench/electron-main/env", "vs/workbench/electron-main/window", "vs/workbench/electron-main/lifecycle", "vs/nls!vs/workbench/electron-main/windows", "vs/base/common/paths", "vs/base/common/arrays", "vs/base/common/objects", "vs/workbench/electron-main/storage", "vs/workbench/electron-main/settings", "vs/workbench/electron-main/update-manager"], function (e, t, n, r, o, i, a, s, c, u, l, f, p, d, h, m, g) {
    "use strict";
    function v(e) {
        return b.addListener(_.OPEN, e), function () {
            return b.removeListener(_.OPEN, e)
        }
    }

    function w(e) {
        return b.addListener(_.READY, e), function () {
            return b.removeListener(_.READY, e)
        }
    }

    function y(e) {
        return b.addListener(_.CLOSE, e), function () {
            return b.removeListener(_.CLOSE, e)
        }
    }

    var b = new n.EventEmitter, _ = {OPEN: "open", CLOSE: "close", READY: "ready"};
    t.onOpen = v, t.onReady = w, t.onClose = y;
    var S;
    !function (e) {
        e[e.UNRESPONSIVE = 0] = "UNRESPONSIVE", e[e.CRASHED = 1] = "CRASHED"
    }(S || (S = {}));
    var E = function () {
        function e() {
        }

        return e.prototype.ready = function (t) {
            this.registerListeners(), this.initialUserEnv = t, this.windowsState = h.getItem(e.windowsStateStorageKey) || {openedFolders: []}
        }, e.prototype.registerListeners = function () {
            var t = this;
            i.app.on("activate", function (e, n) {
                if (s.log("App#activate"), !n) {
                    var r = d.clone(s.cliArgs);
                    r.pathArguments = [], t.windowsState.openedFolders = [], t.open({cli: r})
                }
            });
            var n = [], r = null;
            i.app.on("open-file", function (e, o) {
                s.log("App#open-file: ", o), e.preventDefault(), n.push(o), null !== r && (clearTimeout(r), r = null), r = setTimeout(function () {
                    t.open({cli: s.cliArgs, pathsToOpen: n, preferNewWindow: !0}), n = [], r = null
                }, 100)
            }), m.manager.onChange(function (e) {
                t.sendToAll("vscode:optionsChange", JSON.stringify({globalSettings: e}))
            }, this), i.ipcMain.on("vscode:startCrashReporter", function (e, t) {
                i.crashReporter.start(t)
            }), i.ipcMain.on("vscode:windowOpen", function (e, n, r) {
                s.log("IPC#vscode-windowOpen: ", n), n && n.length && t.open({
                    cli: s.cliArgs,
                    pathsToOpen: n,
                    forceNewWindow: r
                })
            }), i.ipcMain.on("vscode:workbenchLoaded", function (e, n) {
                s.log("IPC#vscode-workbenchLoaded");
                var r = t.getWindowById(n);
                r && (r.setReady(), b.emit(_.READY, r))
            }), i.ipcMain.on("vscode:openFilePicker", function () {
                s.log("IPC#vscode-openFilePicker"), t.openFilePicker()
            }), i.ipcMain.on("vscode:openFolderPicker", function () {
                s.log("IPC#vscode-openFolderPicker"), t.openFolderPicker()
            }), i.ipcMain.on("vscode:openFolderPickerLaya", function (e, path, layaZipPath) {
                t.openFolderPickerLaya(path);

            }), i.ipcMain.on("vscode:closeFolder", function (e, n) {
                s.log("IPC#vscode-closeFolder");
                var r = t.getWindowById(n);
                r && t.open({cli: s.cliArgs, forceEmpty: !0, windowToUse: r})
            }), i.ipcMain.on("vscode:openNewWindow", function () {
                s.log("IPC#vscode-openNewWindow"), t.openNewWindow()
            }), i.ipcMain.on("vscode:openFileFolderPicker", function () {
                s.log("IPC#vscode-openFileFolderPicker"), t.openFolderPicker()
            }), i.ipcMain.on("vscode:reloadWindow", function (e, n) {
                s.log("IPC#vscode:reloadWindow");
                var r = t.getWindowById(n);
                r && t.reload(r)
            }), i.ipcMain.on("vscode:toggleFullScreen", function (e, n) {
                s.log("IPC#vscode:toggleFullScreen");
                var r = t.getWindowById(n);
                r && r.toggleFullScreen()
            }), i.ipcMain.on("vscode:setFullScreen", function (e, n, r) {
                s.log("IPC#vscode:setFullScreen");
                var o = t.getWindowById(n);
                o && o.win.setFullScreen(r)
            }), i.ipcMain.on("vscode:toggleDevTools", function (e, n) {
                s.log("IPC#vscode:toggleDevTools");
                var r = t.getWindowById(n);
                r && r.win.webContents.toggleDevTools()
            }), i.ipcMain.on("vscode:openDevTools", function (e, n) {
                s.log("IPC#vscode:openDevTools");
                var r = t.getWindowById(n);
                r && (r.win.webContents.openDevTools(), r.win.show())
            }), i.ipcMain.on("vscode:setRepresentedFilename", function (e, n, r) {
                s.log("IPC#vscode:setRepresentedFilename");
                var o = t.getWindowById(n);
                o && o.win.setRepresentedFilename(r)
            }), i.ipcMain.on("vscode:setMenuBarVisibility", function (e, n, r) {
                s.log("IPC#vscode:setMenuBarVisibility");
                var o = t.getWindowById(n);
                o && o.win.setMenuBarVisibility(r)
            }), i.ipcMain.on("vscode:flashFrame", function (e, n) {
                s.log("IPC#vscode:flashFrame");
                var r = t.getWindowById(n);
                r && r.win.flashFrame(!r.win.isFocused())
            }), i.ipcMain.on("vscode:focusWindow", function (e, n) {
                s.log("IPC#vscode:focusWindow");
                var r = t.getWindowById(n);
                r && r.win.focus()
            }), i.ipcMain.on("vscode:setDocumentEdited", function (e, n, r) {
                s.log("IPC#vscode:setDocumentEdited");
                var o = t.getWindowById(n);
                o && o.win.isDocumentEdited() !== r && o.win.setDocumentEdited(r)
            }), i.ipcMain.on("vscode:toggleMenuBar", function (n, r) {
                s.log("IPC#vscode:toggleMenuBar");
                var o = h.getItem(c.VSCodeWindow.menuBarHiddenKey, !1), i = !o;
                if (h.setItem(c.VSCodeWindow.menuBarHiddenKey, i), e.WINDOWS.forEach(function (e) {
                        return e.setMenuBarVisibility(!i)
                    }), i) {
                    var a = t.getWindowById(r);
                    a && a.send("vscode:showInfoMessage", l.localize(0, null))
                }
            }), i.ipcMain.on("vscode:changeTheme", function (e, n) {
                t.sendToAll("vscode:changeTheme", n), h.setItem(c.VSCodeWindow.themeStorageKey, n)
            }), i.ipcMain.on("vscode:broadcast", function (n, r, o, i) {
                if (i.channel && i.payload)if (o) {
                    var a = e.WINDOWS.filter(function (e) {
                        return e.id !== r && "string" == typeof e.openedWorkspacePath
                    }), s = a.filter(function (e) {
                        return t.isPathEqual(o, e.openedWorkspacePath)
                    }), c = a.filter(function (e) {
                        return f.isEqualOrParent(o, e.openedWorkspacePath)
                    }), u = s.length ? s[0] : c[0];
                    u && u.send("vscode:broadcast", i)
                } else t.sendToAll("vscode:broadcast", i, [r])
            }), i.ipcMain.on("vscode:log", function (e, t) {
                var n = [];
                try {
                    var r = JSON.parse(t.arguments);
                    n.push.apply(n, Object.getOwnPropertyNames(r).map(function (e) {
                        return r[e]
                    }))
                } catch (o) {
                    n.push(t.arguments)
                }
                console[t.severity].apply(console, n)
            }), i.ipcMain.on("vscode:exit", function (e, t) {
                process.exit(t)
            }), i.ipcMain.on("vscode:closeExtensionHostWindow", function (e, n) {
                var r = t.findWindow(null, null, n);
                r && r.win.close()
            }), g.Instance.on("update-downloaded", function (e) {
                t.sendToFocused("vscode:telemetry", {
                    eventName: "update:downloaded",
                    data: {version: e.version}
                }), t.sendToAll("vscode:update-downloaded", JSON.stringify({
                    releaseNotes: e.releaseNotes,
                    version: e.version,
                    date: e.date
                }))
            }), i.ipcMain.on("vscode:update-apply", function () {
                s.log("IPC#vscode:update-apply"), g.Instance.availableUpdate && g.Instance.availableUpdate.quitAndUpdate()
            }), g.Instance.on("update-not-available", function (e) {
                t.sendToFocused("vscode:telemetry", {
                    eventName: "update:notAvailable",
                    data: {explicit: e}
                }), e && t.sendToFocused("vscode:update-not-available", "")
            }), u.onBeforeQuit(function () {
                return e.WINDOWS.length < 2 ? void(t.windowsState.openedFolders = []) : void(t.windowsState.openedFolders = e.WINDOWS.filter(function (e) {
                    return e.readyState === c.ReadyState.READY && !!e.openedWorkspacePath && !e.isPluginDevelopmentHost
                }).map(function (e) {
                    return {workspacePath: e.openedWorkspacePath, uiState: e.serializeWindowState()}
                }))
            }), i.app.on("will-quit", function () {
                h.setItem(e.windowsStateStorageKey, t.windowsState)
            });
            var o = !1;
            w(function (e) {
                o || (o = !0, e.send("vscode:telemetry", {
                    eventName: "startupTime",
                    data: {ellapsed: Date.now() - global.vscodeStart}
                }))
            })
        }, e.prototype.reload = function (e, t) {
            u.manager.unload(e).done(function (n) {
                n || e.reload(t)
            })
        }, e.prototype.open = function (e) {
            var t, n = this, r = [];
            if (e.pathsToOpen && e.pathsToOpen.length > 0) {
                if (t = e.pathsToOpen.map(function (t) {
                        var r = n.toIPath(t, !1, e.cli && e.cli.gotoLineMode);
                        if (!r) {
                            var o = {
                                title: s.product.nameLong,
                                type: "info",
                                buttons: [l.localize(1, null)],
                                message: l.localize(2, null),
                                detail: l.localize(3, null, t),
                                noLink: !0
                            }, a = i.BrowserWindow.getFocusedWindow();
                            a ? i.dialog.showMessageBox(a, o) : i.dialog.showMessageBox(o)
                        }
                        return r
                    }), t = p.coalesce(t), 0 === t.length)return null
            } else if (e.forceEmpty)t = [Object.create(null)]; else {
                var o = e.cli.pathArguments.length > 0;
                t = this.cliToPaths(e.cli, o)
            }
            var a = [], c = [], u = t.filter(function (e) {
                return e.workspacePath && !e.filePath && !e.installExtensionPath
            }), f = t.filter(function (e) {
                return !e.workspacePath && !e.filePath && !e.installExtensionPath
            }), d = t.filter(function (e) {
                return e.installExtensionPath
            }).map(function (e) {
                return e.filePath
            }), h = t.filter(function (e) {
                return !!e.filePath && e.createFilePath && !e.installExtensionPath
            }), g = t.filter(function (e) {
                return !!e.filePath && !e.createFilePath && !e.installExtensionPath
            });
            e.cli.diffMode && 2 === g.length ? (c = g, u = [], h = []) : a = g;
            var v;
            if (!u.length && (a.length > 0 || h.length > 0 || c.length > 0 || d.length > 0)) {
                var w = void 0;
                e.forceNewWindow ? w = !0 : (w = e.preferNewWindow, w && !e.cli.extensionDevelopmentPath && (w = m.manager.getValue("window.openFilesInNewWindow", w)));
                var y = this.getLastActiveWindow();
                if (!w && y)y.focus(), y.ready().then(function (e) {
                    e.send("vscode:openFiles", {
                        filesToOpen: a,
                        filesToCreate: h,
                        filesToDiff: c
                    }), d.length && e.send("vscode:installExtensions", {extensionsToInstall: d})
                }), r.push(y); else {
                    v = this.toConfiguration(e.userEnv || this.initialUserEnv, e.cli, null, a, h, c, d);
                    var S = this.openInBrowserWindow(v, !0);
                    r.push(S), e.forceNewWindow = !0
                }
            }
            var E = e.preferNewWindow || e.forceNewWindow;
            if (u.length > 0) {
                var P = p.coalesce(u.map(function (e) {
                    return n.findWindow(e.workspacePath)
                }));
                if (P.length > 0) {
                    var S = P[0];
                    S.focus(), S.ready().then(function (e) {
                        e.send("vscode:openFiles", {
                            filesToOpen: a,
                            filesToCreate: h,
                            filesToDiff: c
                        }), d.length && e.send("vscode:installExtensions", {extensionsToInstall: d})
                    }), r.push(S), a = [], h = [], c = [], d = [], E = !0
                }
                u.forEach(function (t) {
                    if (!P.some(function (e) {
                            return n.isPathEqual(e.openedWorkspacePath, t.workspacePath)
                        })) {
                        v = n.toConfiguration(e.userEnv || n.initialUserEnv, e.cli, t.workspacePath, a, h, c, d);
                        var o = n.openInBrowserWindow(v, E, E ? void 0 : e.windowToUse);
                        r.push(o), a = [], h = [], c = [], d = [], E = !0
                    }
                })
            }
            return f.length > 0 && f.forEach(function () {
                var t = n.toConfiguration(e.userEnv || n.initialUserEnv, e.cli), o = n.openInBrowserWindow(t, E, E ? void 0 : e.windowToUse);
                r.push(o), E = !0
            }), t.forEach(function (e) {
                (e.filePath || e.workspacePath) && i.app.addRecentDocument(e.filePath || e.workspacePath)
            }), t.forEach(function (e) {
                return b.emit(_.OPEN, e)
            }), p.distinct(r)
        }, e.prototype.openPluginDevelopmentHostWindow = function (t) {
            var n = this, r = e.WINDOWS.filter(function (e) {
                return e.config && n.isPathEqual(e.config.extensionDevelopmentPath, t.cli.extensionDevelopmentPath)
            });
            if (r && 1 === r.length)return this.reload(r[0], t.cli), void r[0].focus();
            if (0 === t.cli.pathArguments.length) {
                var o = this.windowsState.lastPluginDevelopmentHostWindow && this.windowsState.lastPluginDevelopmentHostWindow.workspacePath;
                o && (t.cli.pathArguments = [o])
            }
            t.cli.pathArguments.length > 0 && (r = e.WINDOWS.filter(function (e) {
                return e.openedWorkspacePath && t.cli.pathArguments.indexOf(e.openedWorkspacePath) >= 0
            }), r.length && (t.cli.pathArguments = [])), this.open({
                cli: t.cli,
                forceNewWindow: !0,
                forceEmpty: 0 === t.cli.pathArguments.length
            })
        }, e.prototype.toConfiguration = function (e, t, n, r, o, i, a) {
            var c = d.mixin({}, t);
            return c.execPath = process.execPath, c.workspacePath = n, c.filesToOpen = r, c.filesToCreate = o, c.filesToDiff = i, c.extensionsToInstall = a, c.appName = s.product.nameLong, c.applicationName = s.product.applicationName, c.darwinBundleIdentifier = s.product.darwinBundleIdentifier, c.appRoot = s.appRoot, c.version = s.version, c.commitHash = s.product.commit, c.appSettingsHome = s.appSettingsHome, c.appSettingsPath = s.appSettingsPath, c.appKeybindingsPath = s.appKeybindingsPath, c.userExtensionsHome = s.userExtensionsHome, c.extensionTips = s.product.extensionTips, c.sharedIPCHandle = s.sharedIPCHandle, c.isBuilt = s.isBuilt, c.crashReporter = s.product.crashReporter, c.extensionsGallery = s.product.extensionsGallery, c.welcomePage = s.product.welcomePage, c.productDownloadUrl = s.product.downloadUrl, c.releaseNotesUrl = s.product.releaseNotesUrl, c.licenseUrl = s.product.licenseUrl, c.updateFeedUrl = g.Instance.feedUrl, c.updateChannel = g.Instance.channel, c.recentPaths = this.getRecentlyOpenedPaths(n, r), c.aiConfig = s.product.aiConfig, c.sendASmile = s.product.sendASmile, c.enableTelemetry = s.product.enableTelemetry, c.userEnv = e, c
        }, e.prototype.getRecentlyOpenedPaths = function (t, n) {
            var r = h.getItem(e.openedPathsListStorageKey);
            r || (r = {folders: [], files: []});
            var o = r.folders.concat(r.files);
            return n && o.unshift.apply(o, n.map(function (e) {
                return e.filePath
            })), t && o.unshift(t), o = p.distinct(o), o.slice(0, 10)
        }, e.prototype.toIPath = function (e, t, n) {
            if (!e)return null;
            var i;
            n && (i = s.parseLineAndColumnAware(e), e = i.path);
            var a = r.normalize(e);
            try {
                var c = o.statSync(a);
                if (c)return c.isFile() ? {
                    filePath: a,
                    lineNumber: n ? i.line : void 0,
                    columnNumber: n ? i.column : void 0,
                    installExtensionPath: /\.vsix$/i.test(a)
                } : {workspacePath: a}
            } catch (u) {
                if (t)return {filePath: a, createFilePath: !0}
            }
            return null
        }, e.prototype.cliToPaths = function (e, t) {
            var n = this, r = [];
            if (e.pathArguments.length > 0)r = e.pathArguments; else {
                var o = m.manager.getValue("window.reopenFolders", "one"), i = this.windowsState.lastActiveWindow && this.windowsState.lastActiveWindow.workspacePath;
                if ("all" === o) {
                    var a = this.windowsState.openedFolders.map(function (e) {
                        return e.workspacePath
                    });
                    i && (a.splice(a.indexOf(i), 1), a.push(i)), r.push.apply(r, a)
                } else!i || "one" !== o && "none" === o || r.push(i)
            }
            var s = r.map(function (r) {
                return n.toIPath(r, t, e.gotoLineMode)
            }).filter(function (e) {
                return !!e
            });
            return s.length > 0 ? s : [Object.create(null)]
        }, e.prototype.openInBrowserWindow = function (t, n, r) {
            var o, i = this;
            if (n || (o = r || this.getLastActiveWindow(), o && o.focus()), o) {
                var a = o.config;
                !t.extensionDevelopmentPath && a && a.extensionDevelopmentPath && (t.extensionDevelopmentPath = a.extensionDevelopmentPath, t.verboseLogging = a.verboseLogging, t.logPluginHostCommunication = a.logPluginHostCommunication, t.debugBrkPluginHost = a.debugBrkPluginHost, t.debugPluginHostPort = a.debugPluginHostPort, t.pluginHomePath = a.pluginHomePath)
            } else o = new c.VSCodeWindow({
                state: this.getNewWindowState(t),
                extensionDevelopmentPath: t.extensionDevelopmentPath
            }), e.WINDOWS.push(o), o.win.webContents.on("crashed", function () {
                return i.onWindowError(o, S.CRASHED)
            }), o.win.on("unresponsive", function () {
                return i.onWindowError(o, S.UNRESPONSIVE)
            }), o.win.on("close", function () {
                return i.onBeforeWindowClose(o)
            }), o.win.on("closed", function () {
                return i.onWindowClosed(o)
            }), u.manager.registerWindow(o);
            return u.manager.unload(o).done(function (e) {
                e || o.load(t)
            }), o
        }, e.prototype.getNewWindowState = function (e) {
            var t = this;
            if (e.extensionDevelopmentPath && this.windowsState.lastPluginDevelopmentHostWindow)return this.windowsState.lastPluginDevelopmentHostWindow.uiState;
            if (e.workspacePath) {
                var n = this.windowsState.openedFolders.filter(function (n) {
                    return t.isPathEqual(n.workspacePath, e.workspacePath)
                }).map(function (e) {
                    return e.uiState
                });
                if (n.length)return n[0]
            }
            var r = this.getLastActiveWindow();
            if (!r && this.windowsState.lastActiveWindow)return this.windowsState.lastActiveWindow.uiState;
            var o, s = i.screen.getAllDisplays();
            if (1 === s.length)o = s[0]; else {
                if (a.isMacintosh) {
                    var u = i.screen.getCursorScreenPoint();
                    o = i.screen.getDisplayNearestPoint(u)
                }
                !o && r && (o = i.screen.getDisplayMatching(r.getBounds())), o || (o = s[0])
            }
            var l = c.defaultWindowState();
            return l.x = o.bounds.x + o.bounds.width / 2 - l.width / 2, l.y = o.bounds.y + o.bounds.height / 2 - l.height / 2, this.ensureNoOverlap(l)
        }, e.prototype.ensureNoOverlap = function (t) {
            if (0 === e.WINDOWS.length)return t;
            for (var n = e.WINDOWS.map(function (e) {
                return e.getBounds()
            }); n.some(function (e) {
                return e.x === t.x || e.y === t.y
            });)t.x += 30, t.y += 30;
            return t
        }, e.prototype.openFilePicker = function () {
            var e = this;
            this.getFileOrFolderPaths(!1, function (t) {
                t && t.length && e.open({cli: s.cliArgs, pathsToOpen: t})
            })
        }, e.prototype.openFolderPicker = function () {
            var e = this;
            this.getFileOrFolderPaths(!0, function (t) {
                t && t.length && e.open({cli: s.cliArgs, pathsToOpen: t})
            })
        }, e.prototype.openFolderPickerLaya = function (layapath) {
            var e = this;
            layapath && layapath.length && e.open({cli: s.cliArgs, pathsToOpen: layapath})

        }, e.prototype.getFileOrFolderPaths = function (t, n) {
            var o, s = h.getItem(e.workingDirPickerStorageKey), c = this.getFocusedWindow();
            o = a.isMacintosh ? ["multiSelections", "openDirectory", "openFile", "createDirectory"] : ["multiSelections", t ? "openDirectory" : "openFile", "createDirectory"], i.dialog.showOpenDialog(c && c.win, {
                defaultPath: s,
                properties: o
            }, function (t) {
                t && t.length > 0 ? (h.setItem(e.workingDirPickerStorageKey, r.dirname(t[0])), n(t)) : n(void 0)
            })
        }, e.prototype.focusLastActive = function (e) {
            var t = this.getLastActiveWindow();
            if (t)return t.focus(), t;
            this.windowsState.openedFolders = [];
            var n = this.open({cli: e});
            return n && n[0]
        }, e.prototype.getLastActiveWindow = function () {
            if (e.WINDOWS.length) {
                var t = Math.max.apply(Math, e.WINDOWS.map(function (e) {
                    return e.lastFocusTime
                })), n = e.WINDOWS.filter(function (e) {
                    return e.lastFocusTime === t
                });
                if (n && n.length)return n[0]
            }
            return null
        }, e.prototype.findWindow = function (t, n, r) {
            var o = this;
            if (e.WINDOWS.length) {
                var i = e.WINDOWS.slice(0), a = this.getLastActiveWindow();
                a && (i.splice(i.indexOf(a), 1), i.unshift(a));
                var s = i.filter(function (e) {
                    return "string" == typeof e.openedWorkspacePath && o.isPathEqual(e.openedWorkspacePath, t) ? !0 : "string" == typeof e.openedFilePath && o.isPathEqual(e.openedFilePath, n) ? !0 : "string" == typeof e.openedWorkspacePath && n && f.isEqualOrParent(n, e.openedWorkspacePath) ? !0 : "string" == typeof r && e.extensionDevelopmentPath === r
                });
                if (s && s.length)return s[0]
            }
            return null
        }, e.prototype.openNewWindow = function () {
            this.open({cli: s.cliArgs, forceNewWindow: !0, forceEmpty: !0})
        }, e.prototype.sendToFocused = function (e) {
            for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
            var r = this.getFocusedWindow() || this.getLastActiveWindow();
            r && r.sendWhenReady.apply(r, [e].concat(t))
        }, e.prototype.sendToAll = function (t, n, r) {
            e.WINDOWS.forEach(function (e) {
                r && r.indexOf(e.id) >= 0 || e.sendWhenReady(t, n)
            })
        }, e.prototype.getFocusedWindow = function () {
            var e = i.BrowserWindow.getFocusedWindow();
            return e ? this.getWindowById(e.id) : null
        }, e.prototype.getWindowById = function (t) {
            var n = e.WINDOWS.filter(function (e) {
                return e.id === t
            });
            return n && 1 === n.length ? n[0] : null
        }, e.prototype.getWindows = function () {
            return e.WINDOWS
        }, e.prototype.getWindowCount = function () {
            return e.WINDOWS.length
        }, e.prototype.onWindowError = function (e, t) {
            var n = this;
            console.error(t === S.CRASHED ? "[VS Code]: render process crashed!" : "[VS Code]: detected unresponsive"), t === S.UNRESPONSIVE ? i.dialog.showMessageBox(e.win, {
                title: s.product.nameLong,
                type: "warning",
                buttons: [l.localize(4, null), l.localize(5, null), l.localize(6, null)],
                message: l.localize(7, null),
                detail: l.localize(8, null),
                noLink: !0
            }, function (t) {
                0 === t ? e.reload() : 2 === t && (n.onBeforeWindowClose(e), e.win.destroy())
            }) : i.dialog.showMessageBox(e.win, {
                title: s.product.nameLong,
                type: "warning",
                buttons: [l.localize(9, null), l.localize(10, null)],
                message: l.localize(11, null),
                detail: l.localize(12, null),
                noLink: !0
            }, function (t) {
                0 === t ? e.reload() : 1 === t && (n.onBeforeWindowClose(e), e.win.destroy())
            })
        }, e.prototype.onBeforeWindowClose = function (e) {
            var t = this;
            if (e.readyState === c.ReadyState.READY) {
                var n = {workspacePath: e.openedWorkspacePath, uiState: e.serializeWindowState()};
                e.isPluginDevelopmentHost ? this.windowsState.lastPluginDevelopmentHostWindow = n : (this.windowsState.lastActiveWindow = n, this.windowsState.openedFolders.forEach(function (r) {
                    t.isPathEqual(r.workspacePath, e.openedWorkspacePath) && (r.uiState = n.uiState)
                }))
            }
        }, e.prototype.onWindowClosed = function (t) {
            t.dispose();
            var n = e.WINDOWS.indexOf(t);
            e.WINDOWS.splice(n, 1), b.emit(_.CLOSE, t.id)
        }, e.prototype.isPathEqual = function (e, t) {
            return e === t ? !0 : e && t ? (e = r.normalize(e), t = r.normalize(t), e === t ? !0 : (a.isLinux || (e = e.toLowerCase(), t = t.toLowerCase()), e === t)) : !1
        }, e.openedPathsListStorageKey = "openedPathsList", e.workingDirPickerStorageKey = "pickerWorkingDir", e.windowsStateStorageKey = "windowsState", e.WINDOWS = [], e
    }();
    t.WindowsManager = E, t.manager = new E
}), define("vs/workbench/electron-main/menus", ["require", "exports", "electron", "vs/nls!vs/workbench/electron-main/menus", "vs/base/common/platform", "vs/base/common/arrays", "vs/workbench/electron-main/windows", "vs/workbench/electron-main/env", "vs/workbench/electron-main/storage", "vs/workbench/electron-main/update-manager", "vs/base/common/keyCodes"], function (e, t, n, r, o, i, a, s, c, u, l) {
    "use strict";
    function f() {
        var e = a.manager.getFocusedWindow() || a.manager.getLastActiveWindow();
        n.dialog.showMessageBox(e && e.win, {
            title: s.product.nameLong,
            type: "info",
            message: s.product.nameLong,
            detail: r.localize(92, null, n.app.getVersion(), s.product.commit || "Unknown", s.product.date || "Unknown", process.versions.electron, process.versions.chrome, process.versions.node),
            buttons: [r.localize(93, null)],
            noLink: !0
        }, function (e) {
            return null
        }), h("showAboutDialog")
    }

    function p(e, t) {
        n.shell.openExternal(e), h(t)
    }

    function d() {
        var e = a.manager.getFocusedWindow();
        e && e.win && e.win.webContents.toggleDevTools()
    }

    function h(e) {
        a.manager.sendToFocused("vscode:telemetry", {eventName: "workbenchActionExecuted", data: {id: e, from: "menu"}})
    }

    function m() {
        return new n.MenuItem({type: "separator"})
    }

    function g(e) {
        return o.isMacintosh ? e.replace(/&&/g, "") : e.replace(/&&/g, "&")
    }

    var v = u.Instance, w = function () {
        function e() {
            this.actionIdKeybindingRequests = [], this.mapResolvedKeybindingToActionId = Object.create(null), this.mapLastKnownKeybindingToActionId = c.getItem(e.lastKnownKeybindingsMapStorageKey) || Object.create(null)
        }

        return e.prototype.ready = function () {
            this.registerListeners(), this.install()
        }, e.prototype.registerListeners = function () {
            var t = this;
            n.app.on("will-quit", function () {
                t.isQuitting = !0
            }), a.onOpen(function (e) {
                return t.onOpen(e)
            }), a.onClose(function (e) {
                return t.onClose(a.manager.getWindowCount())
            }), a.onReady(function (e) {
                return t.resolveKeybindings(e)
            }), n.ipcMain.on("vscode:keybindingsResolved", function (n, r) {
                var o = [];
                try {
                    o = JSON.parse(r)
                } catch (i) {
                }
                var a = !1;
                o.forEach(function (e) {
                    var n = new l.Keybinding(e.binding)._toElectronAccelerator();
                    n && (t.mapResolvedKeybindingToActionId[e.id] = n, t.mapLastKnownKeybindingToActionId[e.id] !== n && (a = !0))
                }), Object.keys(t.mapLastKnownKeybindingToActionId).length !== Object.keys(t.mapResolvedKeybindingToActionId).length && (a = !0), a && (c.setItem(e.lastKnownKeybindingsMapStorageKey, t.mapResolvedKeybindingToActionId), t.mapLastKnownKeybindingToActionId = t.mapResolvedKeybindingToActionId, t.updateMenu())
            }), v.on("change", function () {
                return t.updateMenu()
            })
        }, e.prototype.resolveKeybindings = function (e) {
            this.keybindingsResolved || (this.keybindingsResolved = !0, this.actionIdKeybindingRequests.length && e.send("vscode:resolveKeybindings", JSON.stringify(this.actionIdKeybindingRequests)))
        }, e.prototype.updateMenu = function () {
            var e = this;
            this.isQuitting || setTimeout(function () {
                e.isQuitting || e.install()
            }, 10)
        }, e.prototype.onOpen = function (e) {
            this.addToOpenedPathsList(e.filePath || e.workspacePath, !!e.filePath), this.updateMenu()
        }, e.prototype.onClose = function (e) {
            0 === e && o.isMacintosh && this.updateMenu()
        }, e.prototype.install = function () {
            var e, t = new n.Menu;
            if (o.isMacintosh) {
                var i = new n.Menu;
                e = new n.MenuItem({label: s.product.nameShort, submenu: i}), this.setMacApplicationMenu(i)
            }
            var c = new n.Menu, u = new n.MenuItem({label: g(r.localize(0, null)), submenu: c});
            this.setFileMenu(c);
            var l = new n.Menu, f = new n.MenuItem({label: g(r.localize(1, null)), submenu: l});
            this.setEditMenu(l);
            var p = new n.Menu, d = new n.MenuItem({label: g(r.localize(2, null)), submenu: p});
            this.setViewMenu(p);
            var h = new n.Menu, m = new n.MenuItem({label: g(r.localize(3, null)), submenu: h});
            this.setGotoMenu(h);
            var v;
            if (o.isMacintosh) {
                var w = new n.Menu;
                v = new n.MenuItem({
                    label: g(r.localize(4, null)),
                    submenu: w,
                    role: "window"
                }), this.setMacWindowMenu(w)
            }
            var y = new n.Menu, b = new n.MenuItem({label: g(r.localize(5, null)), submenu: y, role: "help"});
            if (this.setHelpMenu(y), e && t.append(e), t.append(u), t.append(f), t.append(d), t.append(m), v && t.append(v), t.append(b), n.Menu.setApplicationMenu(t), o.isMacintosh && !this.appMenuInstalled) {
                this.appMenuInstalled = !0;
                var _ = new n.Menu;
                _.append(new n.MenuItem({
                    label: g(r.localize(6, null)), click: function () {
                        return a.manager.openNewWindow()
                    }
                })), n.app.dock.setMenu(_)
            }
        }, e.prototype.addToOpenedPathsList = function (t, n) {
            if (t) {
                var r = this.getOpenedPathsList();
                n || o.isMacintosh ? (r.files.unshift(t), r.files = i.distinct(r.files, function (e) {
                    return o.isLinux ? e : e.toLowerCase()
                })) : (r.folders.unshift(t), r.folders = i.distinct(r.folders, function (e) {
                    return o.isLinux ? e : e.toLowerCase()
                })), r.folders = r.folders.slice(0, e.MAX_RECENT_ENTRIES), r.files = r.files.slice(0, e.MAX_RECENT_ENTRIES), c.setItem(a.WindowsManager.openedPathsListStorageKey, r)
            }
        }, e.prototype.removeFromOpenedPathsList = function (e) {
            var t = this.getOpenedPathsList(), n = t.files.indexOf(e);
            n >= 0 && t.files.splice(n, 1), n = t.folders.indexOf(e), n >= 0 && t.folders.splice(n, 1), c.setItem(a.WindowsManager.openedPathsListStorageKey, t)
        }, e.prototype.clearOpenedPathsList = function () {
            c.setItem(a.WindowsManager.openedPathsListStorageKey, {
                folders: [],
                files: []
            }), n.app.clearRecentDocuments(), this.updateMenu()
        }, e.prototype.getOpenedPathsList = function () {
            var e = c.getItem(a.WindowsManager.openedPathsListStorageKey);
            return e || (e = {folders: [], files: []}), e
        }, e.prototype.setMacApplicationMenu = function (e) {
            var t = this, o = new n.MenuItem({
                label: r.localize(7, null, s.product.nameLong),
                role: "about"
            }), i = this.getUpdateMenuItems(), a = this.getPreferencesMenu(), c = new n.MenuItem({
                label: r.localize(8, null, s.product.nameLong),
                role: "hide",
                accelerator: "Command+H"
            }), u = new n.MenuItem({
                label: r.localize(9, null),
                role: "hideothers",
                accelerator: "Command+Alt+H"
            }), l = new n.MenuItem({
                label: r.localize(10, null),
                role: "unhide"
            }), f = new n.MenuItem({
                label: r.localize(11, null, s.product.nameLong), click: function () {
                    return t.quit()
                }, accelerator: "Command+Q"
            }), p = [o];
            p.push.apply(p, i), p.push.apply(p, [m(), a, m(), c, u, l, m(), f]), p.forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.setFileMenu = function (e) {
            var t, s = this, c = 0 === a.manager.getWindowCount();
            t = c ? new n.MenuItem({
                label: g(r.localize(12, null)),
                accelerator: this.getAccelerator("workbench.action.files.newUntitledFile"),
                click: function () {
                    return a.manager.openNewWindow()
                }
            }) : this.createMenuItem(r.localize(13, null), "workbench.action.files.newUntitledFile");
            var u = new n.MenuItem({
                label: g(r.localize(14, null)),
                accelerator: this.getAccelerator("workbench.action.files.openFileFolder"),
                click: function () {
                    return a.manager.openFolderPicker()
                }
            }), l = new n.MenuItem({
                label: g(r.localize(15, null)),
                accelerator: this.getAccelerator("workbench.action.files.openFile"),
                click: function () {
                    return a.manager.openFilePicker()
                }
            }), f = new n.MenuItem({
                label: g(r.localize(16, null)),
                accelerator: this.getAccelerator("workbench.action.files.openFolder"),
                click: function () {
                    return a.manager.openFolderPicker()
                }
            }), p = new n.Menu;
            this.setOpenRecentMenu(p);
            var d = new n.MenuItem({
                label: g(r.localize(17, null)),
                submenu: p,
                enabled: p.items.length > 0
            }), h = this.createMenuItem(r.localize(18, null), "workbench.action.files.save", a.manager.getWindowCount() > 0), v = this.createMenuItem(r.localize(19, null), "workbench.action.files.saveAs", a.manager.getWindowCount() > 0), w = this.createMenuItem(r.localize(20, null), "workbench.action.files.saveAll", a.manager.getWindowCount() > 0), y = this.getPreferencesMenu(), b = new n.MenuItem({
                label: g(r.localize(21, null)),
                accelerator: this.getAccelerator("workbench.action.newWindow"),
                click: function () {
                    return a.manager.openNewWindow()
                }
            }), _ = this.createMenuItem(r.localize(22, null), "workbench.action.files.revert", a.manager.getWindowCount() > 0), S = new n.MenuItem({
                label: g(r.localize(23, null)),
                accelerator: this.getAccelerator("workbench.action.closeWindow"),
                click: function () {
                    return a.manager.getLastActiveWindow().win.close()
                },
                enabled: a.manager.getWindowCount() > 0
            }), E = this.createMenuItem(r.localize(24, null), "workbench.action.closeFolder"), P = this.createMenuItem(r.localize(25, null), "workbench.action.closeActiveEditor"), C = this.createMenuItem(r.localize(26, null), function () {
                return s.quit()
            });
            i.coalesce([t, b, m(), o.isMacintosh ? u : null, o.isMacintosh ? null : l, o.isMacintosh ? null : f, d, m(), h, v, w, m(), o.isMacintosh ? null : y, o.isMacintosh ? null : m(), _, P, E, o.isMacintosh ? null : S, o.isMacintosh ? null : m(), o.isMacintosh ? null : C]).forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.getPreferencesMenu = function () {
            var e = this.createMenuItem(r.localize(27, null), "workbench.action.openGlobalSettings"), t = this.createMenuItem(r.localize(28, null), "workbench.action.openWorkspaceSettings"), o = this.createMenuItem(r.localize(29, null), "workbench.action.openGlobalKeybindings"), i = this.createMenuItem(r.localize(30, null), "workbench.action.openSnippets"), a = this.createMenuItem(r.localize(31, null), "workbench.action.selectTheme"), s = new n.Menu;
            return s.append(e), s.append(t), s.append(m()), s.append(o), s.append(m()), s.append(i), s.append(m()), s.append(a), new n.MenuItem({
                label: g(r.localize(32, null)),
                submenu: s
            })
        }, e.prototype.quit = function () {
            var e = this, t = a.manager.getFocusedWindow();
            t && t.isPluginDevelopmentHost && a.manager.getWindowCount() > 1 ? t.win.close() : setTimeout(function () {
                e.isQuitting = !0, n.app.quit()
            }, 10)
        }, e.prototype.setOpenRecentMenu = function (t) {
            var o = this, i = this.getOpenedPathsList();
            i.folders.forEach(function (n, r) {
                r < e.MAX_RECENT_ENTRIES && t.append(o.createOpenRecentMenuItem(n))
            }), i.files.length > 0 && (i.folders.length > 0 && t.append(m()), i.files.forEach(function (n, r) {
                r < e.MAX_RECENT_ENTRIES && t.append(o.createOpenRecentMenuItem(n))
            })), (i.folders.length || i.files.length) && (t.append(m()), t.append(new n.MenuItem({
                label: g(r.localize(33, null)),
                click: function () {
                    return o.clearOpenedPathsList()
                }
            })))
        }, e.prototype.createOpenRecentMenuItem = function (e) {
            var t = this;
            return new n.MenuItem({
                label: e, click: function () {
                    var n = !!a.manager.open({cli: s.cliArgs, pathsToOpen: [e]});
                    n || (t.removeFromOpenedPathsList(e), t.updateMenu())
                }
            })
        }, e.prototype.createRoleMenuItem = function (e, t, r) {
            var o = {label: g(e), accelerator: this.getAccelerator(t), role: r, enabled: !0};
            return new n.MenuItem(o)
        }, e.prototype.setEditMenu = function (e) {
            var t, n, i, a, s, c;
            o.isMacintosh ? (t = this.createDevToolsAwareMenuItem(r.localize(34, null), "undo", function (e) {
                return e.undo()
            }), n = this.createDevToolsAwareMenuItem(r.localize(35, null), "redo", function (e) {
                return e.redo()
            }), i = this.createRoleMenuItem(r.localize(36, null), "editor.action.clipboardCutAction", "cut"), a = this.createRoleMenuItem(r.localize(37, null), "editor.action.clipboardCopyAction", "copy"), s = this.createRoleMenuItem(r.localize(38, null), "editor.action.clipboardPasteAction", "paste"), c = this.createDevToolsAwareMenuItem(r.localize(39, null), "editor.action.selectAll", function (e) {
                return e.selectAll()
            })) : (t = this.createMenuItem(r.localize(40, null), "undo"), n = this.createMenuItem(r.localize(41, null), "redo"), i = this.createMenuItem(r.localize(42, null), "editor.action.clipboardCutAction"), a = this.createMenuItem(r.localize(43, null), "editor.action.clipboardCopyAction"), s = this.createMenuItem(r.localize(44, null), "editor.action.clipboardPasteAction"), c = this.createMenuItem(r.localize(45, null), "editor.action.selectAll"));
            var u = this.createMenuItem(r.localize(46, null), "actions.find"), l = this.createMenuItem(r.localize(47, null), "editor.action.startFindReplaceAction"), f = this.createMenuItem(r.localize(48, null), "workbench.view.search");
            [t, n, m(), i, a, s, c, m(), u, l, m(), f].forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.setViewMenu = function (e) {
            var t = this.createMenuItem(r.localize(49, null), "workbench.view.explorer"), s = this.createMenuItem(r.localize(50, null), "workbench.view.search"), c = this.createMenuItem(r.localize(51, null), "workbench.view.git"), u = this.createMenuItem(r.localize(52, null), "workbench.view.debug"), l = this.createMenuItem(r.localize(53, null), "workbench.action.showCommands"), f = this.createMenuItem(r.localize(54, null), "workbench.action.showErrorsWarnings"), p = this.createMenuItem(r.localize(55, null), "workbench.action.output.toggleOutput"), d = this.createMenuItem(r.localize(56, null), "workbench.debug.action.toggleRepl"), h = new n.MenuItem({
                label: g(r.localize(57, null)), accelerator: this.getAccelerator("workbench.action.toggleFullScreen"),
                click: function () {
                    return a.manager.getLastActiveWindow().toggleFullScreen()
                }, enabled: a.manager.getWindowCount() > 0
            }), v = this.createMenuItem(r.localize(58, null), "workbench.action.toggleMenuBar"), w = this.createMenuItem(r.localize(59, null), "workbench.action.splitEditor"), y = this.createMenuItem(r.localize(60, null), "workbench.action.toggleSidebarVisibility"), b = this.createMenuItem(r.localize(61, null), "workbench.action.toggleSidebarPosition"), _ = this.createMenuItem(r.localize(62, null), "workbench.action.togglePanel"), S = this.createMenuItem(r.localize(63, null), "editor.action.toggleWordWrap"), E = this.createMenuItem(r.localize(64, null), "editor.action.toggleRenderWhitespace"), P = this.createMenuItem(r.localize(65, null), "workbench.action.zoomIn"), C = this.createMenuItem(r.localize(66, null), "workbench.action.zoomOut");
            i.coalesce([t, s, c, u, m(), l, f, m(), p, d, m(), h, o.isWindows || o.isLinux ? v : void 0, m(), w, y, b, _, m(), S, E, m(), P, C]).forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.setGotoMenu = function (e) {
            var t = this.createMenuItem(r.localize(67, null), "workbench.action.navigateBack"), n = this.createMenuItem(r.localize(68, null), "workbench.action.navigateForward"), o = this.createMenuItem(r.localize(69, null), "workbench.action.openPreviousEditor"), i = this.createMenuItem(r.localize(70, null), "workbench.action.quickOpen"), a = this.createMenuItem(r.localize(71, null), "workbench.action.gotoSymbol"), s = this.createMenuItem(r.localize(72, null), "editor.action.goToDeclaration"), c = this.createMenuItem(r.localize(73, null), "workbench.action.gotoLine");
            [t, n, m(), o, m(), i, a, s, c].forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.setMacWindowMenu = function (e) {
            var t = new n.MenuItem({
                label: r.localize(74, null),
                role: "minimize",
                accelerator: "Command+M",
                enabled: a.manager.getWindowCount() > 0
            }), o = new n.MenuItem({
                label: r.localize(75, null),
                role: "close",
                accelerator: "Command+W",
                enabled: a.manager.getWindowCount() > 0
            }), i = new n.MenuItem({
                label: r.localize(76, null),
                role: "front",
                enabled: a.manager.getWindowCount() > 0
            });
            [t, o, m(), i].forEach(function (t) {
                return e.append(t)
            })
        }, e.prototype.setHelpMenu = function (e) {
            var t = new n.MenuItem({
                label: g(r.localize(77, null)),
                accelerator: this.getAccelerator("workbench.action.toggleDevTools"),
                click: d,
                enabled: a.manager.getWindowCount() > 0
            });
            if (i.coalesce([s.product.documentationUrl ? new n.MenuItem({
                    label: g(r.localize(78, null)),
                    click: function () {
                        return p(s.product.documentationUrl, "openDocumentationUrl")
                    }
                }) : null, s.product.releaseNotesUrl ? new n.MenuItem({
                    label: g(r.localize(79, null)),
                    click: function () {
                        return p(s.product.releaseNotesUrl, "openReleaseNotesUrl")
                    }
                }) : null, s.product.documentationUrl || s.product.releaseNotesUrl ? m() : null, s.product.twitterUrl ? new n.MenuItem({
                    label: g(r.localize(80, null)),
                    click: function () {
                        return p(s.product.twitterUrl, "openTwitterUrl")
                    }
                }) : null, s.product.requestFeatureUrl ? new n.MenuItem({
                    label: g(r.localize(81, null)),
                    click: function () {
                        return p(s.product.requestFeatureUrl, "openUserVoiceUrl")
                    }
                }) : null, s.product.reportIssueUrl ? new n.MenuItem({
                    label: g(r.localize(82, null)),
                    click: function () {
                        return p(s.product.reportIssueUrl, "openReportIssues")
                    }
                }) : null, s.product.twitterUrl || s.product.requestFeatureUrl || s.product.reportIssueUrl ? m() : null, s.product.licenseUrl ? new n.MenuItem({
                    label: g(r.localize(83, null)),
                    click: function () {
                        if (o.language) {
                            var e = s.product.licenseUrl.indexOf("?") > 0 ? "&" : "?";
                            p("" + s.product.licenseUrl + e + "lang=" + o.language, "openLicenseUrl")
                        } else p(s.product.licenseUrl, "openLicenseUrl")
                    }
                }) : null, s.product.privacyStatementUrl ? new n.MenuItem({
                    label: g(r.localize(84, null)),
                    click: function () {
                        return p(s.product.privacyStatementUrl, "openPrivacyStatement")
                    }
                }) : null, s.product.licenseUrl || s.product.privacyStatementUrl ? m() : null, t]).forEach(function (t) {
                    return e.append(t)
                }), !o.isMacintosh) {
                var c = this.getUpdateMenuItems();
                c.length && (e.append(m()), c.forEach(function (t) {
                    return e.append(t)
                })), e.append(m()), e.append(new n.MenuItem({label: g(r.localize(85, null)), click: f}))
            }
        }, e.prototype.getUpdateMenuItems = function () {
            switch (v.state) {
                case u.State.Uninitialized:
                    return [];
                case u.State.UpdateDownloaded:
                    var e = v.availableUpdate;
                    return [new n.MenuItem({
                        label: r.localize(86, null), click: function () {
                            h("RestartToUpdate"), e.quitAndUpdate()
                        }
                    })];
                case u.State.CheckingForUpdate:
                    return [new n.MenuItem({label: r.localize(87, null), enabled: !1})];
                case u.State.UpdateAvailable:
                    var t = o.isWindows ? r.localize(88, null) : r.localize(89, null);
                    return [new n.MenuItem({label: t, enabled: !1})];
                default:
                    var i = [new n.MenuItem({
                        label: r.localize(90, null), click: function () {
                            return setTimeout(function () {
                                h("CheckForUpdate"), v.checkForUpdates(!0)
                            }, 0)
                        }
                    })];
                    return v.lastCheckDate && i.push(new n.MenuItem({
                        label: r.localize(91, null, v.lastCheckDate.toLocaleTimeString()),
                        enabled: !1
                    })), i
            }
        }, e.prototype.createMenuItem = function (e, t, r) {
            var o, i = g(e), s = "function" == typeof t ? t : function () {
                return a.manager.sendToFocused("vscode:runAction", t)
            }, c = "boolean" == typeof r ? r : a.manager.getWindowCount() > 0;
            "string" == typeof t && (o = t);
            var u = {label: i, accelerator: this.getAccelerator(o), click: s, enabled: c};
            return new n.MenuItem(u)
        }, e.prototype.createDevToolsAwareMenuItem = function (e, t, r) {
            return new n.MenuItem({
                label: g(e),
                accelerator: this.getAccelerator(t),
                enabled: a.manager.getWindowCount() > 0,
                click: function () {
                    var e = a.manager.getFocusedWindow();
                    e && (e.win.isDevToolsFocused() ? r(e.win.devToolsWebContents) : a.manager.sendToFocused("vscode:runAction", t))
                }
            })
        }, e.prototype.getAccelerator = function (e) {
            if (e) {
                var t = this.mapResolvedKeybindingToActionId[e];
                if (t)return t;
                this.keybindingsResolved || this.actionIdKeybindingRequests.push(e);
                var n = this.mapLastKnownKeybindingToActionId[e];
                return n
            }
        }, e.lastKnownKeybindingsMapStorageKey = "lastKnownKeybindings", e.MAX_RECENT_ENTRIES = 10, e
    }();
    t.VSCodeMenu = w, t.manager = new w
}), define("vs/workbench/parts/git/electron-main/askpassService", ["require", "exports", "vs/nls!vs/workbench/parts/git/electron-main/askpassService", "electron", "vs/base/common/platform", "vs/base/common/winjs.base"], function (e, t, n, r, o, i) {
    "use strict";
    var a = function () {
        function t() {
            var e = this;
            this.askpassCache = Object.create(null), r.ipcMain.on("git:askpass", function (t, n) {
                e.askpassCache[n.id].credentials = n.credentials
            })
        }

        return t.prototype.askpass = function (t, a, s) {
            var c = this;
            return new i.TPromise(function (i, u) {
                var l = c.askpassCache[t];
                if ("undefined" != typeof l)return i(l.credentials);
                if ("fetch" === s)return i({username: "", password: ""});
                var f = new r.BrowserWindow({
                    alwaysOnTop: !0,
                    skipTaskbar: !0,
                    resizable: !1,
                    width: 450,
                    height: o.isWindows ? 280 : 260,
                    show: !0,
                    title: n.localize(0, null)
                });
                f.setMenuBarVisibility(!1), c.askpassCache[t] = {
                    window: f,
                    credentials: null
                }, f.loadURL(e.toUrl("vs/workbench/parts/git/electron-main/index.html")), f.webContents.executeJavaScript("init(" + JSON.stringify({
                        id: t,
                        host: a,
                        command: s
                    }) + ")"), f.once("closed", function () {
                    i(c.askpassCache[t].credentials), setTimeout(function () {
                        return delete c.askpassCache[t]
                    }, 1e4)
                })
            })
        }, t
    }();
    t.GitAskpassService = a
}), define("vs/workbench/electron-main/main", ["require", "exports", "electron", "fs", "vs/nls!vs/workbench/electron-main/main", "vs/base/common/objects", "vs/base/common/platform", "vs/workbench/electron-main/env", "vs/workbench/electron-main/windows", "vs/workbench/electron-main/lifecycle", "vs/workbench/electron-main/menus", "vs/workbench/electron-main/settings", "vs/workbench/electron-main/update-manager", "vs/base/node/service.net", "vs/base/node/env", "vs/base/common/winjs.base", "vs/workbench/parts/git/electron-main/askpassService", "vs/workbench/electron-main/sharedProcess"], function (e, t, n, r, o, i, a, s, c, u, l, f, p, d, h, m, g, v) {
    "use strict";
    function w(e) {
        var t = 0;
        "string" == typeof e ? s.log(e) : (t = 1, e.stack ? console.error(e.stack) : console.error("Startup error: " + e.toString())), process.exit(t)
    }

    function y(t, r) {
        s.log("### VSCode main.js ###"), s.log(s.appRoot, s.cliArgs);
        var i = null;
        try {
            var d = e.__$__nodeRequire("windows-mutex").Mutex;
            i = new d(s.product.win32MutexName)
        } catch (h) {
        }
        t.registerService("LaunchService", new _), t.registerService("GitAskpassService", new g.GitAskpassService), process.env.VSCODE_PID = "" + process.pid, process.env.VSCODE_IPC_HOOK = s.mainIPCHandle, process.env.VSCODE_SHARED_IPC_HOOK = s.sharedIPCHandle;
        var m = v.spawnSharedProcess();
        a.isWindows && s.product.win32AppUserModelId && n.app.setAppUserModelId(s.product.win32AppUserModelId), global.programStart = s.cliArgs.programStart, n.app.on("will-quit", function () {
            s.log("App#dispose: deleting running instance handle"), t && (t.dispose(), t = null), m.dispose(), i && i.release()
        }), u.manager.ready(), f.manager.loadSync(), c.manager.ready(r), //l.manager.ready(),
        a.isWindows && s.isBuilt && n.app.setUserTasks([{
            title: o.localize(0, null),
            program: process.execPath,
            arguments: "-n",
            iconPath: process.execPath,
            iconIndex: 0
        }]), p.Instance.initialize(), s.cliArgs.openNewWindow && 0 === s.cliArgs.pathArguments.length ? c.manager.open({
            cli: s.cliArgs,
            forceNewWindow: !0,
            forceEmpty: !0
        }) : !global.macOpenFiles || !global.macOpenFiles.length || s.cliArgs.pathArguments && s.cliArgs.pathArguments.length ? c.manager.open({
            cli: s.cliArgs,
            forceNewWindow: s.cliArgs.openNewWindow
        }) : c.manager.open({cli: s.cliArgs, pathsToOpen: global.macOpenFiles})
    }

    function b() {
        function e(t) {
            return d.serve(s.mainIPCHandle).then(null, function (o) {
                if ("EADDRINUSE" !== o.code)return m.TPromise.wrapError(o);
                if (a.isMacintosh && n.app.dock.hide(), s.isTestingFromCli) {
                    var i = "Running extension tests from the command line is currently only supported if no other instance of Code is running.";
                    return console.error(i), m.TPromise.wrapError(i)
                }
                return d.connect(s.mainIPCHandle).then(function (e) {
                    s.log("Sending env to running instance...");
                    var t = e.getService("LaunchService", _);
                    return t.start(s.cliArgs, process.env).then(function () {
                        return e.dispose()
                    }).then(function () {
                        return m.TPromise.wrapError("Sent env to running instance. Terminating...")
                    })
                }, function (n) {
                    if (!t || a.isWindows || "ECONNREFUSED" !== n.code)return m.TPromise.wrapError(n);
                    try {
                        r.unlinkSync(s.mainIPCHandle)
                    } catch (o) {
                        return s.log("Fatal error deleting obsolete instance handle", o), m.TPromise.wrapError(o)
                    }
                    return e(!1)
                })
            })
        }

        return e(!0)
    }

    var _ = function () {
        function e() {
        }

        return e.prototype.start = function (e, t) {
            s.log("Received data from other instance", e);
            var n;
            if (e.extensionDevelopmentPath ? c.manager.openPluginDevelopmentHostWindow({
                    cli: e,
                    userEnv: t
                }) : n = 0 === e.pathArguments.length && e.openNewWindow ? c.manager.open({
                    cli: e,
                    userEnv: t,
                    forceNewWindow: !0,
                    forceEmpty: !0
                }) : 0 === e.pathArguments.length ? [c.manager.focusLastActive(e)] : c.manager.open({
                    cli: e,
                    userEnv: t,
                    forceNewWindow: e.waitForWindowClose || e.openNewWindow,
                    preferNewWindow: !e.openInSameWindow
                }), e.waitForWindowClose && n && 1 === n.length && n[0]) {
                var r = n[0].id;
                return new m.TPromise(function (e, t) {
                    var n = c.onClose(function (t) {
                        t === r && (n(), e(null))
                    })
                })
            }
            return m.TPromise.as(null)
        }, e
    }();
    t.LaunchService = _, process.on("uncaughtException", function (e) {
        if (e) {
            var t = {message: e.message, stack: e.stack};
            c.manager.sendToFocused("vscode:reportError", JSON.stringify(t))
        }
        console.error("[uncaught exception in main]: " + e), e.stack && console.error(e.stack)
    }), h.getUserEnvironment().then(function (e) {
        return i.assign(process.env, e), e.VSCODE_NLS_CONFIG = process.env.VSCODE_NLS_CONFIG, b().then(function (t) {
            return y(t, e)
        })
    }).done(null, w)
});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/vs\workbench\electron-main\main.js.map
