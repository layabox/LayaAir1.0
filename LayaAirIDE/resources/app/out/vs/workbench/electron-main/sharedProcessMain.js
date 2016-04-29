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
            var i = (r + o) / 2 | 0, s = n(e[i], t);
            if (0 > s)r = i + 1; else {
                if (!(s > 0))return i;
                o = i - 1
            }
        }
        return -(r + 1)
    }

    function s(e, t) {
        var n = 0, r = e.length;
        if (0 === r)return 0;
        for (; r > n;) {
            var o = Math.floor((n + r) / 2);
            t(e[o]) ? r = o : n = o + 1
        }
        return n
    }

    function a(e, t) {
        var n = new Array;
        if (t)for (var r = {}, o = 0; o < e.length; o++)for (var i = 0; i < e[o].length; i++) {
            var s = e[o][i], a = t(s);
            r.hasOwnProperty(a) || (r[a] = !0, n.push(s))
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

    function h(e, t) {
        if (!t)return e.filter(function (t, n) {
            return e.indexOf(t) === n
        });
        var n = {};
        return e.filter(function (e) {
            var r = t(e);
            return n[r] ? !1 : (n[r] = !0, !0)
        })
    }

    function d(e, t, n) {
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

    function v(e) {
        return e.reduce(function (e, t) {
            return e.concat(t)
        }, [])
    }

    t.tail = n, t.forEach = r, t.equals = o, t.binarySearch = i, t.findFirst = s, t.merge = a, t.coalesce = c, t.contains = u, t.swap = l, t.move = f, t.isFalsyOrEmpty = p, t.distinct = h, t.first = d, t.commonPrefixLength = m, t.flatten = v
}), define("vs/base/common/assert", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e, t) {
        if (!e || null === e)throw new Error(t ? "Assertion failed (" + t + ")" : "Assertion Failed")
    }

    t.ok = n
}), define("vs/base/common/collections", ["require", "exports"], function (e, t) {
    "use strict";
    function n() {
        return Object.create(null)
    }

    function r() {
        return Object.create(null)
    }

    function o(e, t, n) {
        void 0 === n && (n = null);
        var r = String(t);
        return a(e, r) ? e[r] : n
    }

    function i(e, t, n) {
        var r = String(t);
        return a(e, r) ? e[r] : ("function" == typeof n && (n = n()), e[r] = n, n)
    }

    function s(e, t, n) {
        e[n(t)] = t
    }

    function a(e, t) {
        return p.call(e, t)
    }

    function c(e) {
        var t = [];
        for (var n in e)p.call(e, n) && t.push(e[n]);
        return t
    }

    function u(e, t) {
        for (var n in e)if (p.call(e, n)) {
            var r = t({key: n, value: e[n]}, function () {
                delete e[n]
            });
            if (r === !1)return
        }
    }

    function l(e, t) {
        return p.call(e, t) ? (delete e[t], !0) : !1
    }

    function f(e, t) {
        var r = n();
        return e.forEach(function (e) {
            return i(r, t(e), []).push(e)
        }), r
    }

    t.createStringDictionary = n, t.createNumberDictionary = r, t.lookup = o, t.lookupOrInsert = i, t.insert = s;
    var p = Object.prototype.hasOwnProperty;
    t.contains = a, t.values = c, t.forEach = u, t.remove = l, t.groupBy = f
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/base/common/events", ["require", "exports"], function (e, t) {
    "use strict";
    var n = function () {
        function e(e) {
            this.time = (new Date).getTime(), this.originalEvent = e, this.source = null
        }

        return e
    }();
    t.Event = n;
    var r = function (e) {
        function t(t, n, r, o) {
            e.call(this, o), this.key = t, this.oldValue = n, this.newValue = r
        }

        return __extends(t, e), t
    }(n);
    t.PropertyChangeEvent = r;
    var o = function (e) {
        function t(t, n) {
            e.call(this, n), this.element = t
        }

        return __extends(t, e), t
    }(n);
    t.ViewerEvent = o, t.EventType = {
        PROPERTY_CHANGED: "propertyChanged",
        SELECTION: "selection",
        FOCUS: "focus",
        BLUR: "blur",
        HIGHLIGHT: "highlight",
        EXPAND: "expand",
        COLLAPSE: "collapse",
        TOGGLE: "toggle",
        CONTENTS_CHANGED: "contentsChanged",
        BEFORE_RUN: "beforeRun",
        RUN: "run",
        EDIT: "edit",
        SAVE: "save",
        CANCEL: "cancel",
        CHANGE: "change",
        DISPOSE: "dispose"
    }
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

    function s(e) {
        return {
            dispose: function () {
                return e()
            }
        }
    }

    function a() {
        for (var e = [], t = 0; t < arguments.length; t++)e[t - 0] = arguments[t];
        return i(e.map(s))
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
    }), t.dispose = n, t.disposeAll = r, t.combinedDispose = o, t.combinedDispose2 = i, t.fnToDisposable = s, t.toDisposable = a, t.cAll = c;
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
        return "undefined" != typeof g.Worker
    }

    var r = !1, o = !1, i = !1, s = !1, a = !1, c = !1, u = void 0, l = void 0;
    if ("object" == typeof process) {
        r = "win32" === process.platform, o = "darwin" === process.platform, i = "linux" === process.platform;
        var f = process.env.VSCODE_NLS_CONFIG;
        if (f)try {
            var p = JSON.parse(f), h = p.availableLanguages["*"];
            u = p.locale, l = h ? h : "en"
        } catch (d) {
        }
        s = !0
    } else if ("object" == typeof navigator) {
        var m = navigator.userAgent;
        r = m.indexOf("Windows") >= 0, o = m.indexOf("Macintosh") >= 0, i = m.indexOf("Linux") >= 0, a = !0, u = navigator.language, l = u, c = !!self.QUnit
    }
    !function (e) {
        e[e.Web = 0] = "Web", e[e.Mac = 1] = "Mac", e[e.Linux = 2] = "Linux", e[e.Windows = 3] = "Windows"
    }(t.Platform || (t.Platform = {}));
    var v = t.Platform;
    t._platform = v.Web, s && (o ? t._platform = v.Mac : r ? t._platform = v.Windows : i && (t._platform = v.Linux)), t.isWindows = r, t.isMacintosh = o, t.isLinux = i, t.isNative = s, t.isWeb = a, t.isQunit = c, t.platform = t._platform, t.language = l, t.locale = u;
    var g = "object" == typeof self ? self : global;
    t.globals = g, t.hasWebWorkerSupport = n, t.setTimeout = g.setTimeout.bind(g), t.clearTimeout = g.clearTimeout.bind(g), t.setInterval = g.setInterval.bind(g), t.clearInterval = g.clearInterval.bind(g)
}), define("vs/base/common/stopwatch", ["require", "exports", "vs/base/common/platform"], function (e, t, n) {
    "use strict";
    var r = n.globals.performance && "function" == typeof n.globals.performance.now, o = function () {
        function e(e) {
            this._highResolution = r && e, this._startTime = this._now(), this._stopTime = -1
        }

        return e.create = function (t) {
            return void 0 === t && (t = !0), new e(t)
        }, e.prototype.stop = function () {
            this._stopTime = this._now()
        }, e.prototype.elapsed = function () {
            return -1 !== this._stopTime ? this._stopTime - this._startTime : this._now() - this._startTime
        }, e.prototype._now = function () {
            return this._highResolution ? n.globals.performance.now() : (new Date).getTime()
        }, e
    }();
    t.StopWatch = o
}), define("vs/base/common/strings", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e, t, n) {
        void 0 === n && (n = "0");
        for (var r = "" + e, o = [r], i = r.length; t > i; i++)o.push(n);
        return o.reverse().join("")
    }

    function r(e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        return 0 === t.length ? e : e.replace(A, function (e, n) {
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

    function s(e, t) {
        void 0 === t && (t = " ");
        var n = a(e, t);
        return c(n, t)
    }

    function a(e, t) {
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

    function h(e, t, n, r, o) {
        if ("" === e)throw new Error("Cannot create regex from empty string");
        t || (e = e.replace(/[\-\\\{\}\*\+\?\|\^\$\.\,\[\]\(\)\#\s]/g, "\\$&")), r && (/\B/.test(e.charAt(0)) || (e = "\\b" + e), /\B/.test(e.charAt(e.length - 1)) || (e += "\\b"));
        var i = "";
        return o && (i += "g"), n || (i += "i"), new RegExp(e, i)
    }

    function d(e, t, n, r) {
        if ("" === e)return null;
        var o = null;
        try {
            o = h(e, t, n, r, !0)
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

    function v(e) {
        if (!t.canNormalize || !e)return e;
        var n = j[e];
        if (n)return n;
        var r;
        return r = L.test(e) ? e.normalize("NFC") : e, 1e4 > D && (j[e] = r, D++), r
    }

    function g(e) {
        for (var t = 0, n = e.length; n > t; t++)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return t;
        return -1
    }

    function y(e) {
        for (var t = 0, n = e.length; n > t; t++)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return e.substring(0, t);
        return e
    }

    function _(e) {
        for (var t = e.length - 1; t >= 0; t--)if (" " !== e.charAt(t) && "	" !== e.charAt(t))return t;
        return -1
    }

    function b(e, t) {
        return e.localeCompare(t)
    }

    function E(e) {
        return e >= 97 && 122 >= e || e >= 65 && 90 >= e
    }

    function S(e, t) {
        var n = e.length, r = t.length;
        if (n !== r)return !1;
        for (var o = 0; n > o; o++) {
            var i = e.charCodeAt(o), s = t.charCodeAt(o);
            if (i !== s)if (E(i) && E(s)) {
                var a = Math.abs(i - s);
                if (0 !== a && 32 !== a)return !1
            } else if (String.fromCharCode(i).toLocaleLowerCase() !== String.fromCharCode(s).toLocaleLowerCase())return !1
        }
        return !0
    }

    function w(e, t) {
        var n, r = Math.min(e.length, t.length);
        for (n = 0; r > n; n++)if (e.charCodeAt(n) !== t.charCodeAt(n))return n;
        return r
    }

    function x(e, t) {
        var n, r = Math.min(e.length, t.length), o = e.length - 1, i = t.length - 1;
        for (n = 0; r > n; n++)if (e.charCodeAt(o - n) !== t.charCodeAt(i - n))return n;
        return r
    }

    function O(e) {
        return e >= 11904 && 55215 >= e || e >= 63744 && 64255 >= e || e >= 65281 && 65374 >= e
    }

    function T(e, t, n) {
        void 0 === n && (n = 4);
        var r = Math.abs(e.length - t.length);
        if (r > n)return 0;
        var o, i, s = [], a = [];
        for (o = 0; o < t.length + 1; ++o)a.push(0);
        for (o = 0; o < e.length + 1; ++o)s.push(a);
        for (o = 1; o < e.length + 1; ++o)for (i = 1; i < t.length + 1; ++i)e[o - 1] === t[i - 1] ? s[o][i] = s[o - 1][i - 1] + 1 : s[o][i] = Math.max(s[o - 1][i], s[o][i - 1]);
        return s[e.length][t.length] - Math.sqrt(r)
    }

    function C(e) {
        for (var t, n = /\r\n|\r|\n/g, r = [0]; t = n.exec(e);)r.push(n.lastIndex);
        return r
    }

    function k(e, n) {
        if (e.length < n)return e;
        for (var r = e.split(/\b/), o = 0, i = r.length - 1; i >= 0; i--)if (o += r[i].length, o > n) {
            r.splice(0, i);
            break
        }
        return r.join(t.empty).replace(/^\s/, t.empty)
    }

    function P(e) {
        return e && (e = e.replace(R, ""), e = e.replace(N, "\n"), e = e.replace(q, ""), e = e.replace(F, "")), e
    }

    function I(e) {
        return e && e.length > 0 && e.charCodeAt(0) === U
    }

    t.empty = "", t.pad = n;
    var A = /{(\d+)}/g;
    t.format = r, t.escape = o, t.escapeRegExpCharacters = i, t.trim = s, t.ltrim = a, t.rtrim = c, t.convertSimple2RegExpPattern = u, t.stripWildcards = l, t.startsWith = f, t.endsWith = p, t.createRegExp = h, t.createSafeRegExp = d, t.regExpLeadsToEndlessLoop = m, t.canNormalize = "function" == typeof"".normalize;
    var L = /[^\u0000-\u0080]/, j = Object.create(null), D = 0;
    t.normalizeNFC = v, t.firstNonWhitespaceIndex = g, t.getLeadingWhitespace = y, t.lastNonWhitespaceIndex = _, t.localeCompare = b, t.equalsIgnoreCase = S, t.commonPrefixLength = w, t.commonSuffixLength = x, t.isFullWidthCharacter = O, t.difference = T, t.computeLineStarts = C, t.lcut = k;
    var R = /\x1B\x5B[12]?K/g, N = /\xA/g, q = /\x1b\[\d+m/g, F = /\x1b\[0?m/g;
    t.removeAnsiEscapeCodes = P;
    var U = 65279;
    t.UTF8_BOM_CHARACTER = String.fromCharCode(U), t.startsWithUTF8BOM = I
}), define("vs/base/common/paths", ["require", "exports", "vs/base/common/platform", "vs/base/common/strings"], function (e, t, n, r) {
    "use strict";
    function o(e, n) {
        e = i(e), n = i(n);
        for (var r = e.split(t.sep), o = n.split(t.sep); r.length > 0 && o.length > 0 && r[0] === o[0];)r.shift(), o.shift();
        for (var s = 0, a = r.length; a > s; s++)o.unshift("..");
        return o.join(t.sep)
    }

    function i(e, r) {
        if (!e)return e;
        if (!_.test(e)) {
            var o = r && n.isWindows ? "/" : "\\";
            if (-1 === e.indexOf(o))return e
        }
        for (var i = e.split(/[\\\/]/), s = 0, a = i.length; a > s; s++)"." === i[s] && i[s + 1] ? (i.splice(s, 1), s -= 1) : ".." === i[s] && i[s - 1] && (i.splice(s - 1, 2), s -= 2);
        return i.join(r ? t.nativeSep : t.sep)
    }

    function s(e) {
        function t() {
            return "." === n || "/" === n || "\\" === n ? (n = void 0, r = !0) : n = a(n), {value: n, done: r}
        }

        var n = e, r = !1;
        return {next: t}
    }

    function a(e) {
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
        for (var o = [], i = /[\\\/]$/.test(e[e.length - 1]), s = 0; s < e.length; s++)o.push.apply(o, e[s].split(/\/|\\/));
        for (var s = 0; s < o.length; s++) {
            var a = o[s];
            "." === a || 0 === a.length ? (o.splice(s, 1), s -= 1) : ".." === a && o[s - 1] && ".." !== o[s - 1] && (o.splice(s - 1, 2), s -= 2)
        }
        i && o.push("");
        var c = o.join("/");
        return n && (c = n.replace(/\/|\\/g, "/") + c), c
    }

    function p(e) {
        return n.isWindows && e ? (e = this.normalize(e, !0), e[0] === t.nativeSep && e[1] === t.nativeSep) : !1
    }

    function h(e) {
        return e && "/" === e[0]
    }

    function d(e, n) {
        return h(n ? e : i(e)) ? e : t.sep + e
    }

    function m(e) {
        return e && e.length > 1 && "." === e[0]
    }

    function v(e, t) {
        if (e === t)return !0;
        e = i(e), t = i(t);
        var r = t.length, o = t.charCodeAt(r - 1);
        if (o === b && (t = t.substring(0, r - 1), r -= 1), e === t)return !0;
        if (n.isLinux || (e = e.toLowerCase(), t = t.toLowerCase()), e === t)return !0;
        if (0 !== e.indexOf(t))return !1;
        var s = e.charCodeAt(r);
        return s === b
    }

    function g(e) {
        return !e || 0 === e.length || /^\s+$/.test(e) ? !1 : (E.lastIndex = 0, E.test(e) ? !1 : n.isWindows && S.test(e) ? !1 : "." === e || ".." === e ? !1 : n.isWindows && r.endsWith(e, ".") ? !1 : !n.isWindows || e.length === e.trim().length)
    }

    function y(e) {
        return t.isAbsoluteRegex.test(e)
    }

    t.sep = "/", t.nativeSep = n.isWindows ? "\\" : "/", t.relative = o;
    var _ = /[\\\/]\.\.?[\\\/]?|[\\\/]?\.\.?[\\\/]/;
    t.normalize = i, t.dirnames = s, t.dirname = a, t.basename = c, t.extname = u, t.join = f, t.isUNC = p, t.makeAbsolute = d, t.isRelative = m;
    var b = "/".charCodeAt(0);
    t.isEqualOrParent = v;
    var E = n.isWindows ? /[\\/:\*\?"<>\|]/g : /[\\/]/g, S = /^(con|prn|aux|clock\$|nul|lpt[0-9]|com[0-9])$/i;
    t.isValidBasename = g, t.isAbsoluteRegex = /^((\/|[a-zA-Z]:\\)[^\(\)<>\\'\"\[\]]+)/, t.isAbsolute = y
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

    function s(e) {
        return ("number" == typeof e || e instanceof Number) && !isNaN(e)
    }

    function a(e) {
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
        for (var t in e)if (v.call(e, t))return !1;
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

    function h(e, t) {
        for (var n = Math.min(e.length, t.length), r = 0; n > r; r++)d(e[r], t[r])
    }

    function d(e, t) {
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

    t.isArray = n, t.isString = r, t.isStringArray = o, t.isObject = i, t.isNumber = s, t.isBoolean = a, t.isUndefined = c, t.isUndefinedOrNull = u;
    var v = Object.prototype.hasOwnProperty;
    t.isEmptyObject = l, t.isFunction = f, t.areFunctions = p, t.validateConstraints = h, t.validateConstraint = d, t.create = m
}), define("vs/base/common/graph", ["require", "exports", "vs/base/common/types", "vs/base/common/collections"], function (e, t, n, r) {
    "use strict";
    function o(e) {
        return {data: e, incoming: {}, outgoing: {}}
    }

    t.newNode = o;
    var i = function () {
        function e(e) {
            this._hashFn = e, this._nodes = Object.create(null)
        }

        return e.prototype.roots = function () {
            var e = [];
            return r.forEach(this._nodes, function (t) {
                n.isEmptyObject(t.value.outgoing) && e.push(t.value)
            }), e
        }, e.prototype.traverse = function (e, t, n) {
            var r = this.lookup(e);
            r && this._traverse(r, t, {}, n)
        }, e.prototype._traverse = function (e, t, n, o) {
            var i = this, s = this._hashFn(e.data);
            if (!r.contains(n, s)) {
                n[s] = !0, o(e.data);
                var a = t ? e.outgoing : e.incoming;
                r.forEach(a, function (e) {
                    return i._traverse(e.value, t, n, o)
                })
            }
        }, e.prototype.insertEdge = function (e, t) {
            var n = this.lookupOrInsertNode(e), r = this.lookupOrInsertNode(t);
            n.outgoing[this._hashFn(t)] = r, r.incoming[this._hashFn(e)] = n
        }, e.prototype.removeNode = function (e) {
            var t = this._hashFn(e);
            delete this._nodes[t], r.forEach(this._nodes, function (e) {
                delete e.value.outgoing[t], delete e.value.incoming[t]
            })
        }, e.prototype.lookupOrInsertNode = function (e) {
            var t = this._hashFn(e), n = r.lookup(this._nodes, t);
            return n || (n = o(e), this._nodes[t] = n), n
        }, e.prototype.lookup = function (e) {
            return r.lookup(this._nodes, this._hashFn(e))
        }, Object.defineProperty(e.prototype, "length", {
            get: function () {
                return Object.keys(this._nodes).length
            }, enumerable: !0, configurable: !0
        }), e
    }();
    t.Graph = i
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
        return s(e, t, [])
    }

    function s(e, t, r) {
        if (n.isUndefinedOrNull(e))return e;
        var o = t(e);
        if ("undefined" != typeof o)return o;
        if (n.isArray(e)) {
            for (var i = [], a = 0; a < e.length; a++)i.push(s(e[a], t, r));
            return i
        }
        if (n.isObject(e)) {
            if (r.indexOf(e) >= 0)throw new Error("Cannot clone recursive data-structure");
            r.push(e);
            var c = {};
            for (var u in e)g.call(e, u) && (c[u] = s(e[u], t, r));
            return r.pop(), c
        }
        return e
    }

    function a(e, t, r) {
        return void 0 === r && (r = !0), n.isObject(e) ? (n.isObject(t) && Object.keys(t).forEach(function (o) {
            o in e ? r && (n.isObject(e[o]) && n.isObject(t[o]) ? a(e[o], t[o], r) : e[o] = t[o]) : e[o] = t[o]
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
        return a(r(t), e || {})
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

    function h(e) {
        for (var t = {}, n = 0; n < e.length; ++n)t[e[n]] = !0;
        return t
    }

    function d(e, t) {
        void 0 === t && (t = !1), t && (e = e.map(function (e) {
            return e.toLowerCase()
        }));
        var n = h(e);
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

    function v(e) {
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
    var g = Object.prototype.hasOwnProperty;
    t.cloneAndChange = i, t.mixin = a, t.assign = c, t.toObject = u, t.withDefaults = l, t.equals = f, t.ensureProperty = p, t.arrayToHash = h, t.createKeywordMatcher = d, t.derive = m, t.safeStringify = v
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
            var s = new e;
            return s._scheme = t || this.scheme, s._authority = n || this.authority, s._path = r || this.path, s._query = o || this.query, s._fragment = i || this.fragment, e._validate(s), s
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
                    var i, s = this._path;
                    e._driveLetterPath.test(s) ? s = "/" + s[1].toLowerCase() + s.substr(2) : e._driveLetter.test(s) && (s = s[0].toLowerCase() + s.substr(1)), i = s.split("/");
                    for (var a = 0, c = i.length; c > a; a++)i[a] = r(i[a]);
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
        return new s
    }

    function r(e) {
        if (!a.test(e))throw new Error("invalid uuid");
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
    }(), s = function (e) {
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
    var a = /^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$/;
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
        var r, o, i, s = Object.keys(n);
        for (o = 0, i = s.length; i > o; o++) {
            var a = s[o], c = 95 !== a.charCodeAt(0), u = n[a];
            !u || "object" != typeof u || u.value === t && "function" != typeof u.get && "function" != typeof u.set ? c ? e[a] = u : (r = r || {}, r[a] = {
                value: u,
                enumerable: c,
                configurable: !0,
                writable: !0
            }) : (u.enumerable === t && (u.enumerable = c), r = r || {}, r[a] = u)
        }
        r && Object.defineProperties(e, r)
    }

    !function (t) {
        function r(e, t, r) {
            for (var o = e, i = t.split("."), s = 0, a = i.length; a > s; s++) {
                var c = i[s];
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

        function r(r, o, i, s) {
            if (r) {
                o = o || function () {
                    };
                var a = r.prototype;
                return o.prototype = Object.create(a), e.Utilities.markSupportedForProcessing(o), Object.defineProperty(o.prototype, "constructor", {
                    value: o,
                    writable: !0,
                    configurable: !0,
                    enumerable: !0
                }), i && n(o.prototype, i), s && n(o, s), o
            }
            return t(o, i, s)
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
                function s() {
                    if (n)try {
                        n(), o()
                    } catch (e) {
                        i(e)
                    } else o()
                }

                var a = t.Utilities.testReadyState;
                a || (a = e.document ? document.readyState : "complete"), "complete" === a || e.document && null !== document.body ? r ? e.setImmediate(s) : s() : e.addEventListener("DOMContentLoaded", s, !1)
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
                        for (var o = 0, s = e.frames.length; r && s > o; o++)r = r && !(n === e.frames[o])
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
            var i = t.type && new RegExp("^(" + r(t.type).replace(o, " ").split(" ").join("|") + ")$"), s = t.excludeTags && new RegExp("(^|\\s)(" + r(t.excludeTags).replace(o, " ").split(" ").join("|") + ")(\\s|$)", "i"), a = t.tags && new RegExp("(^|\\s)(" + r(t.tags).replace(o, " ").split(" ").join("|") + ")(\\s|$)", "i"), c = t.action || n;
            if (!(i || s || a || e.log))return void(e.log = c);
            var u = function (e, t, n) {
                i && !i.test(n) || s && s.test(t) || a && !a.test(t) || c(e, t, n), u.next && u.next(e, t, n)
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
            t["on" + i] = n(i);
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
                var s = r[o];
                if (s.useCapture === n && s.listener === t)return
            }
            r.push({listener: t, useCapture: n})
        }, dispatchEvent: function (e, t) {
            var n = this._listeners && this._listeners[e];
            if (n) {
                var r = new o(e, t, this);
                n = n.slice(0, n.length);
                for (var i = 0, s = n.length; s > i && !r._stopImmediatePropagationCalled; i++)n[i].listener(r);
                return r.defaultPrevented || !1
            }
            return !1
        }, removeEventListener: function (e, t, n) {
            n = n || !1;
            var r = this._listeners && this._listeners[e];
            if (r)for (var o = 0, i = r.length; i > o; o++) {
                var s = r[o];
                if (s.listener === t && s.useCapture === n) {
                    r.splice(o, 1), 0 === r.length && delete this._listeners[e];
                    break
                }
            }
        }
    };
    e.Namespace.define("WinJS.Utilities", {_createEventProperty: n, createEventProperties: r, eventMixin: i})
}(this.WinJS), function (e, t, n) {
    "use strict";
    var r, o = !1, i = "contextchanged", s = t.Class.mix(t.Class.define(null, {}, {supportedForProcessing: !1}), t.Utilities.eventMixin), a = new s, c = {malformedFormatStringInput: "Malformed, did you mean to escape your '{0}'?"};
    t.Namespace.define("WinJS.Resources", {
        addEventListener: function (e, n, r) {
            if (t.Utilities.hasWinRT && !o && e === i)try {
                Windows.ApplicationModel.Resources.Core.ResourceManager.current.defaultContext.qualifierValues.addEventListener("mapchanged", function (e) {
                    t.Resources.dispatchEvent(i, {qualifier: e.key, changed: e.target[e.key]})
                }, !1), o = !0
            } catch (s) {
            }
            a.addEventListener(e, n, r)
        },
        removeEventListener: a.removeEventListener.bind(a),
        dispatchEvent: a.dispatchEvent.bind(a),
        _formatString: function (e) {
            var n = arguments;
            return n.length > 1 && (e = e.replace(/({{)|(}})|{(\d+)}|({)|(})/g, function (e, r, o, i, s, a) {
                if (s || a)throw t.Resources._formatString(c.malformedFormatStringInput, s || a);
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
            var i, s, a;
            try {
                a = r.getValue(e), a && (i = a.valueAsString, i === n && (i = a.toString()))
            } catch (o) {
            }
            if (!i)return {value: e, empty: !0};
            try {
                s = a.getQualifierValue("Language")
            } catch (o) {
                return {value: i}
            }
            return {value: i, lang: s}
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
        n = t && "object" == typeof t && "function" == typeof t.then ? A : R, e._value = t, e._setState(n)
    }

    function i(e, t, n, r, o, i) {
        return {exception: e, error: t, promise: n, handler: i, id: r, parent: o}
    }

    function s(e, t, n, r) {
        var o = n._isException, s = n._errorId;
        return i(o ? t : null, o ? null : t, e, s, n, r)
    }

    function a(e, t, n) {
        var r = n._isException, o = n._errorId;
        return g(e, o, r), i(r ? t : null, r ? null : t, e, o, n)
    }

    function c(e, t) {
        var n = ++U;
        return g(e, n), i(null, t, e, n)
    }

    function u(e, t) {
        var n = ++U;
        return g(e, n, !0), i(t, null, e, n)
    }

    function l(e, t, n, r) {
        v(e, {c: t, e: n, p: r})
    }

    function f(e, t, n, r) {
        e._value = t, d(e, t, n, r), e._setState(q)
    }

    function p(e, t) {
        var n = e._value, r = e._listeners;
        if (r) {
            e._listeners = null;
            var o, i;
            for (o = 0, i = Array.isArray(r) ? r.length : 1; i > o; o++) {
                var s = 1 === i ? r : r[o], a = s.c, c = s.promise;
                if (c) {
                    try {
                        c._setCompleteValue(a ? a(n) : n)
                    } catch (u) {
                        c._setExceptionValue(u)
                    }
                    c._state !== A && c._listeners && t.push(c)
                } else V.prototype.done.call(e, a)
            }
        }
    }

    function h(e, t) {
        var n = e._value, r = e._listeners;
        if (r) {
            e._listeners = null;
            var o, i;
            for (o = 0, i = Array.isArray(r) ? r.length : 1; i > o; o++) {
                var a = 1 === i ? r : r[o], c = a.e, u = a.promise;
                if (u) {
                    try {
                        c ? (c.handlesOnError || d(u, n, s, e, c), u._setCompleteValue(c(n))) : u._setChainedErrorValue(n, e)
                    } catch (l) {
                        u._setExceptionValue(l)
                    }
                    u._state !== A && u._listeners && t.push(u)
                } else H.prototype.done.call(e, null, c)
            }
        }
    }

    function d(e, t, n, r, o) {
        if (x._listeners[O]) {
            if (t instanceof Error && t.message === T)return;
            x.dispatchEvent(O, n(e, t, r, o))
        }
    }

    function m(e, t) {
        var n = e._listeners;
        if (n) {
            var r, o;
            for (r = 0, o = Array.isArray(n) ? n.length : 1; o > r; r++) {
                var i = 1 === o ? n : n[r], s = i.p;
                if (s)try {
                    s(t)
                } catch (a) {
                }
                i.c || i.e || !i.promise || i.promise._progress(t)
            }
        }
    }

    function v(e, t) {
        var n = e._listeners;
        n ? (n = Array.isArray(n) ? n : [n], n.push(t)) : n = t, e._listeners = n
    }

    function g(e, t, n) {
        e._isException = n || !1, e._errorId = t
    }

    function y(e, t, n, r) {
        e._value = t, d(e, t, n, r), e._setState(F)
    }

    function _(e, t) {
        var n;
        n = t && "object" == typeof t && "function" == typeof t.then ? A : N, e._value = t, e._setState(n)
    }

    function b(e, t, n, r) {
        var o = new W(e);
        return v(e, {promise: o, c: t, e: n, p: r}), o
    }

    function E(e) {
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
    var w = t.Class.mix(t.Class.define(null, {}, {supportedForProcessing: !1}), t.Utilities.eventMixin), x = new w;
    x._listeners = {};
    var O = "error", T = "Canceled", C = !1, k = {
        promise: 1,
        thenPromise: 2,
        errorPromise: 4,
        exceptionPromise: 8,
        completePromise: 16
    };
    k.all = k.promise | k.thenPromise | k.errorPromise | k.exceptionPromise | k.completePromise;
    var P, I, A, L, j, D, R, N, q, F, U = 1;
    P = {
        name: "created",
        enter: function (e) {
            e._setState(I)
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
    }, I = {
        name: "working", enter: r, cancel: function (e) {
            e._setState(j)
        }, done: l, then: b, _completed: o, _error: f, _notify: r, _progress: m, _setCompleteValue: _, _setErrorValue: y
    }, A = {
        name: "waiting", enter: function (e) {
            var t = e._value, n = function (r) {
                t._errorId ? e._chainedError(r, t) : (d(e, r, s, t, n), e._error(r))
            };
            n.handlesOnError = !0, t.then(e._completed.bind(e), n, e._progress.bind(e))
        }, cancel: function (e) {
            e._setState(L)
        }, done: l, then: b, _completed: o, _error: f, _notify: r, _progress: m, _setCompleteValue: _, _setErrorValue: y
    }, L = {
        name: "waiting_canceled",
        enter: function (e) {
            e._setState(D);
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
        _setCompleteValue: _,
        _setErrorValue: y
    }, j = {
        name: "canceled",
        enter: function (e) {
            e._setState(D), e._cancelAction()
        },
        cancel: r,
        done: l,
        then: b,
        _completed: o,
        _error: f,
        _notify: r,
        _progress: m,
        _setCompleteValue: _,
        _setErrorValue: y
    }, D = {
        name: "canceling",
        enter: function (e) {
            var t = new Error(T);
            t.name = t.message, e._value = t, e._setState(q)
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
    }, R = {
        name: "complete_notify",
        enter: function (e) {
            if (e.done = V.prototype.done, e.then = V.prototype.then, e._listeners)for (var t, n = [e]; n.length;)t = n.pop(), t._state._notify(t, n);
            e._setState(N)
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
    }, N = {
        name: "success",
        enter: function (e) {
            e.done = V.prototype.done, e.then = V.prototype.then, e._cleanupAction()
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
    }, q = {
        name: "error_notify",
        enter: function (e) {
            if (e.done = H.prototype.done, e.then = H.prototype.then, e._listeners)for (var t, n = [e]; n.length;)t = n.pop(), t._state._notify(t, n);
            e._setState(F)
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: h,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    }, F = {
        name: "error",
        enter: function (e) {
            e.done = H.prototype.done, e.then = H.prototype.then, e._cleanupAction()
        },
        cancel: r,
        done: null,
        then: null,
        _completed: r,
        _error: r,
        _notify: h,
        _progress: r,
        _setCompleteValue: r,
        _setErrorValue: r
    };
    var M, z = t.Class.define(null, {
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
            var n = this._state._error(this, e, a, t);
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
            var n = this._state._setErrorValue(this, e, a, t);
            return this._run(), n
        },
        _setExceptionValue: function (e) {
            var t = this._state._setErrorValue(this, e, u);
            return this._run(), t
        },
        _run: function () {
            for (; this._nextState;)this._state = this._nextState, this._nextState = null, this._state.enter(this)
        }
    }, {supportedForProcessing: !1}), W = t.Class.derive(z, function (e) {
        C && (C === !0 || C & k.thenPromise) && (this._stack = t.Promise._getStack()), this._creator = e, this._setState(P), this._run()
    }, {
        _creator: null, _cancelAction: function () {
            this._creator && this._creator.cancel()
        }, _cleanupAction: function () {
            this._creator = null
        }
    }, {supportedForProcessing: !1}), H = t.Class.define(function (e) {
        C && (C === !0 || C & k.errorPromise) && (this._stack = t.Promise._getStack()), this._value = e, d(this, e, c)
    }, {
        cancel: function () {
        }, done: function (e, t) {
            var n = this._value;
            if (t)try {
                t.handlesOnError || d(null, n, s, this, t);
                var r = t(n);
                return void(r && "object" == typeof r && "function" == typeof r.done && r.done())
            } catch (o) {
                n = o
            }
            n instanceof Error && n.message === T || setImmediate(function () {
                throw n
            })
        }, then: function (e, t) {
            if (!t)return this;
            var n, r = this._value;
            try {
                t.handlesOnError || d(null, r, s, this, t), n = new V(t(r))
            } catch (o) {
                n = o === r ? this : new B(o)
            }
            return n
        }
    }, {supportedForProcessing: !1}), B = t.Class.derive(H, function (e) {
        C && (C === !0 || C & k.exceptionPromise) && (this._stack = t.Promise._getStack()), this._value = e, d(this, e, u)
    }, {}, {supportedForProcessing: !1}), V = t.Class.define(function (e) {
        if (C && (C === !0 || C & k.completePromise) && (this._stack = t.Promise._getStack()), e && "object" == typeof e && "function" == typeof e.then) {
            var n = new W(null);
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
                return t === this._value ? this : new V(t)
            } catch (n) {
                return new B(n)
            }
        }
    }, {supportedForProcessing: !1}), G = t.Class.derive(z, function (e, n) {
        C && (C === !0 || C & k.promise) && (this._stack = t.Promise._getStack()), this._oncancel = n, this._setState(P), this._run();
        try {
            var r = this._completed.bind(this), o = this._error.bind(this), i = this._progress.bind(this);
            e(r, o, i)
        } catch (s) {
            this._setExceptionValue(s)
        }
    }, {
        _oncancel: null, _cancelAction: function () {
            try {
                if (!this._oncancel)throw new Error("Promise did not implement oncancel");
                this._oncancel()
            } catch (e) {
                e.message, e.stack;
                x.dispatchEvent("error", e)
            }
        }, _cleanupAction: function () {
            this._oncancel = null
        }
    }, {
        addEventListener: function (e, t, n) {
            x.addEventListener(e, t, n)
        }, any: function (e) {
            return new G(function (n, r, o) {
                var i = Object.keys(e);
                Array.isArray(e) ? [] : {};
                0 === i.length && n();
                var s = 0;
                i.forEach(function (o) {
                    G.as(e[o]).then(function () {
                        n({key: o, value: e[o]})
                    }, function (a) {
                        return a instanceof Error && a.name === T ? void(++s === i.length && n(t.Promise.cancel)) : void r({
                            key: o,
                            value: e[o]
                        })
                    })
                })
            }, function () {
                var t = Object.keys(e);
                t.forEach(function (t) {
                    var n = G.as(e[t]);
                    "function" == typeof n.cancel && n.cancel()
                })
            })
        }, as: function (e) {
            return e && "object" == typeof e && "function" == typeof e.then ? e : new V(e)
        }, cancel: {
            get: function () {
                return M = M || new H(new t.ErrorFromName(T))
            }
        }, dispatchEvent: function (e, t) {
            return x.dispatchEvent(e, t)
        }, is: function (e) {
            return e && "object" == typeof e && "function" == typeof e.then
        }, join: function (e) {
            return new G(function (r, o, i) {
                var s = Object.keys(e), a = Array.isArray(e) ? [] : {}, c = Array.isArray(e) ? [] : {}, u = 0, l = s.length, f = function (e) {
                    if (0 === --l) {
                        var n = Object.keys(a).length;
                        if (0 === n)r(c); else {
                            var u = 0;
                            s.forEach(function (e) {
                                var t = a[e];
                                t instanceof Error && t.name === T && u++
                            }), u === n ? r(t.Promise.cancel) : o(a)
                        }
                    } else i({Key: e, Done: !0})
                };
                return s.forEach(function (t) {
                    var r = e[t];
                    r === n ? u++ : G.then(r, function (e) {
                        c[t] = e, f(t)
                    }, function (e) {
                        a[t] = e, f(t)
                    })
                }), l -= u, 0 === l ? void r(c) : void 0
            }, function () {
                Object.keys(e).forEach(function (t) {
                    var n = G.as(e[t]);
                    "function" == typeof n.cancel && n.cancel()
                })
            })
        }, removeEventListener: function (e, t, n) {
            x.removeEventListener(e, t, n)
        }, supportedForProcessing: !1, then: function (e, t, n, r) {
            return G.as(e).then(t, n, r)
        }, thenEach: function (e, t, n, r) {
            var o = Array.isArray(e) ? [] : {};
            return Object.keys(e).forEach(function (i) {
                o[i] = G.as(e[i]).then(t, n, r)
            }), G.join(o)
        }, timeout: function (e, t) {
            var n = E(e);
            return t ? S(n, t) : n
        }, wrap: function (e) {
            return new V(e)
        }, wrapError: function (e) {
            return new H(e)
        }, _veryExpensiveTagWithStack: {
            get: function () {
                return C
            }, set: function (e) {
                C = e
            }
        }, _veryExpensiveTagWithStack_tag: k, _getStack: function () {
            if (Debug.debuggerEnabled)try {
                throw new Error
            } catch (e) {
                return e.stack
            }
        }
    });
    Object.defineProperties(G, t.Utilities.createEventProperties(O));
    var J = t.Class.derive(z, function (e) {
        this._oncancel = e, this._setState(P), this._run()
    }, {
        _cancelAction: function () {
            this._oncancel && this._oncancel()
        }, _cleanupAction: function () {
            this._oncancel = null
        }
    }, {supportedForProcessing: !1}), $ = t.Class.define(function (e) {
        this._promise = new J(e)
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
    t.Namespace.define("WinJS", {Promise: G, _Signal: $})
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
    var r, o, i, s, a, c, u = {nonStaticHTML: "Unable to add dynamic content. A script attempted to inject dynamic content, or elements previously modified dynamically, that might be unsafe. For example, using the innerHTML property or the document.write method to add a script element will generate this exception. If the content is safe and from a trusted source, use a method to explicitly manipulate elements and attributes, such as createElement, or use setInnerHTMLUnsafe (or other unsafe method)."};
    r = o = function (e, t) {
        e.innerHTML = t
    }, i = s = function (e, t) {
        e.outerHTML = t
    }, a = c = function (e, t, n) {
        e.insertAdjacentHTML(t, n)
    };
    var l = e.MSApp;
    if (l)o = function (e, t) {
        l.execUnsafeLocalFunction(function () {
            e.innerHTML = t
        })
    }, s = function (e, t) {
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
        }, a = function (e, t, n) {
            f(n), e.insertAdjacentHTML(t, n)
        }
    }
    t.Namespace.define("WinJS.Utilities", {
        setInnerHTML: r,
        setInnerHTMLUnsafe: o,
        setOuterHTML: i,
        setOuterHTMLUnsafe: s,
        insertAdjacentHTML: a,
        insertAdjacentHTMLUnsafe: c
    })
}(this, this.WinJS)), function (e) {
    "undefined" == typeof exports && "function" == typeof define && define.amd ? define("vs/base/common/winjs.base.raw", e.WinJS) : module.exports = e.WinJS
}(this), define("vs/base/node/flow", ["require", "exports", "assert"], function (e, t, n) {
    "use strict";
    function r(e, t, n) {
        var r = new Array(e.length), o = new Array(e.length), i = !1, s = 0;
        return 0 === e.length ? n(null, []) : void e.forEach(function (a, c) {
            t(a, function (t, a) {
                return t ? (i = !0, r[c] = null, o[c] = t) : (r[c] = a, o[c] = null), ++s === e.length ? n(i ? o : null, r) : void 0
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
            var s = [], a = function (n) {
                if (n < e.length)try {
                    t(e[n], function (e, t) {
                        e !== !0 && e !== !1 || (t = e, e = null), e ? r(e, null) : (t && s.push(t), process.nextTick(function () {
                            a(n + 1)
                        }))
                    }, n, e.length)
                } catch (o) {
                    r(o, null)
                } else r(null, s)
            };
            a(0)
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

    function s(e) {
        i(Array.isArray(e) ? e : Array.prototype.slice.call(arguments))
    }

    t.parallel = r, t.loop = o, t.sequence = s
}), define("vs/base/node/extfs", ["require", "exports", "vs/base/common/uuid", "vs/base/common/strings", "vs/base/common/platform", "vs/base/node/flow", "fs", "path"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    function c(e, t) {
        return o.isMacintosh ? u(e, function (e, n) {
            return e ? t(e, null) : t(null, n.map(function (e) {
                return r.normalizeNFC(e)
            }))
        }) : u(e, t)
    }

    function u(e, t) {
        s.readdir(e, function (e, n) {
            return e ? t(e, null) : t(null, n.filter(function (e) {
                return "." !== e && ".." !== e
            }))
        })
    }

    function l(e, t, n) {
        s.exists(e, function (r) {
            return r ? f(e, function (t, r) {
                return t ? n(t) : r ? void n(null) : n(new Error('"' + e + '" is not a directory.'))
            }) : void l(a.dirname(e), t, function (r) {
                return r ? void n(r) : void(t ? s.mkdir(e, t, function (r) {
                    return r ? n(r) : void s.chmod(e, t, n)
                }) : s.mkdir(e, null, n))
            })
        })
    }

    function f(e, t) {
        s.stat(e, function (e, n) {
            return e ? t(e) : void t(null, n.isDirectory())
        })
    }

    function p(e, t, n, r) {
        r || (r = Object.create(null)), s.stat(e, function (o, i) {
            return o ? n(o) : i.isDirectory() ? r[e] ? n(null) : (r[e] = !0, void l(t, 511 & i.mode, function (o) {
                c(e, function (o, i) {
                    g(i, function (n, o) {
                        p(a.join(e, n), a.join(t, n), o, r)
                    }, n)
                })
            })) : h(e, t, 511 & i.mode, n)
        })
    }

    function h(e, t, n, r) {
        var o = !1, i = s.createReadStream(e), a = s.createWriteStream(t, {mode: n}), c = function (e) {
            o || (o = !0, r(e))
        };
        i.on("error", c), a.on("error", c), i.on("end", function () {
            a.end(function () {
                o || (o = !0, s.chmod(t, n, r))
            })
        }), i.pipe(a, {end: !1})
    }

    function d(e, t, o, i) {
        s.exists(e, function (c) {
            return c ? void s.stat(e, function (c, u) {
                if (c || !u)return o(c);
                if ("." === e[e.length - 1] || r.endsWith(e, "./") || r.endsWith(e, ".\\"))return m(e, o);
                var l = a.join(t, n.generateUuid());
                s.rename(e, l, function (t) {
                    return t ? m(e, o) : (o(null), void m(l, function (e) {
                        e && console.error(e), i && i(e)
                    }))
                })
            }) : o(null)
        })
    }

    function m(e, t) {
        return "\\" === e || "/" === e ? t(new Error("Will not delete root!")) : void s.exists(e, function (n) {
            n ? s.lstat(e, function (n, r) {
                if (n || !r)t(n); else if (!r.isDirectory() || r.isSymbolicLink()) {
                    var o = r.mode;
                    128 & o ? s.unlink(e, t) : s.chmod(e, 128 | o, function (n) {
                        n ? t(n) : s.unlink(e, t)
                    })
                } else c(e, function (n, r) {
                    if (n || !r)t(n); else if (0 === r.length)s.rmdir(e, t); else {
                        var o = null, i = r.length;
                        r.forEach(function (n) {
                            m(a.join(e, n), function (n) {
                                i--, n && (o = o || n), 0 === i && (o ? t(o) : s.rmdir(e, t))
                            })
                        })
                    }
                })
            }) : t(null)
        })
    }

    function v(e, t, n) {
        function o(e) {
            return e ? n(e) : void s.stat(t, function (e, r) {
                return e ? n(e) : r.isDirectory() ? n(null) : void s.open(t, "a", null, function (e, t) {
                    return e ? n(e) : void s.futimes(t, r.atime, new Date, function (e) {
                        return e ? n(e) : void s.close(t, n)
                    })
                })
            })
        }

        return e === t ? n(null) : void s.rename(e, t, function (i) {
            return i ? i && e.toLowerCase() !== t.toLowerCase() && "EXDEV" === i.code || r.endsWith(e, ".") ? p(e, t, function (t) {
                return t ? n(t) : void m(e, o)
            }) : n(i) : o(null)
        })
    }

    var g = i.loop;
    t.readdir = c, t.mkdirp = l, t.copy = p, t.del = d, t.mv = v
}), define("vs/base/node/proxy", ["require", "exports", "url", "vs/base/common/types", "http-proxy-agent", "https-proxy-agent"], function (e, t, n, r, o, i) {
    "use strict";
    function s(e) {
        return "http:" === e.protocol ? process.env.HTTP_PROXY || process.env.http_proxy || null : "https:" === e.protocol ? process.env.HTTPS_PROXY || process.env.https_proxy || process.env.HTTP_PROXY || process.env.http_proxy || null : null
    }

    function a(e, t) {
        void 0 === t && (t = {});
        var a = n.parse(e), c = t.proxyUrl || s(a);
        if (!c)return null;
        var u = n.parse(c);
        if (!/^https?:$/.test(u.protocol))return null;
        var l = {
            host: u.hostname,
            port: Number(u.port),
            auth: u.auth,
            rejectUnauthorized: r.isBoolean(t.strictSSL) ? t.strictSSL : !0
        };
        return "http:" === a.protocol ? new o(l) : new i(l)
    }

    t.getProxyAgent = a
}), define("vs/nls!vs/base/common/errors", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/base/common/errors", t)
}), define("vs/base/common/errors", ["require", "exports", "vs/nls!vs/base/common/errors", "vs/base/common/objects", "vs/base/common/platform", "vs/base/common/types", "vs/base/common/arrays", "vs/base/common/strings"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    function c(e) {
        t.errorHandler.setUnexpectedErrorHandler(e)
    }

    function u(e) {
        v(e) || t.errorHandler.onUnexpectedError(e)
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
        var n = new O(e);
        return t ? n.verboseMessage : n.message
    }

    function h(e, t) {
        return e.message ? t && (e.stack || e.stacktrace) ? n.localize(7, null, d(e), e.stack || e.stacktrace) : d(e) : n.localize(8, null)
    }

    function d(e) {
        return "string" == typeof e.code && "number" == typeof e.errno && "string" == typeof e.syscall ? n.localize(9, null, e.message) : e.message
    }

    function m(e, t) {
        if (void 0 === e && (e = null), void 0 === t && (t = !1), !e)return n.localize(10, null);
        if (Array.isArray(e)) {
            var r = s.coalesce(e), o = m(r[0], t);
            return r.length > 1 ? n.localize(11, null, o, r.length) : o
        }
        if (i.isString(e))return e;
        if (!i.isUndefinedOrNull(e.status))return p(e, t);
        if (e.detail) {
            var a = e.detail;
            if (a.error) {
                if (a.error && !i.isUndefinedOrNull(a.error.status))return p(a.error, t);
                if (!i.isArray(a.error))return h(a.error, t);
                for (var c = 0; c < a.error.length; c++)if (a.error[c] && !i.isUndefinedOrNull(a.error[c].status))return p(a.error[c], t)
            }
            if (a.exception)return i.isUndefinedOrNull(a.exception.status) ? h(a.exception, t) : p(a.exception, t)
        }
        return e.stack ? h(e, t) : e.message ? e.message : n.localize(12, null)
    }

    function v(e) {
        return e instanceof Error && e.name === T && e.message === T
    }

    function g() {
        var e = new Error(T);
        return e.name = e.message, e
    }

    function y() {
        return new Error(n.localize(13, null))
    }

    function _(e) {
        return e ? new Error(n.localize(14, null, e)) : new Error(n.localize(15, null))
    }

    function b(e) {
        return e ? new Error(n.localize(16, null, e)) : new Error(n.localize(17, null))
    }

    function E() {
        return new Error("readonly property cannot be changed")
    }

    function S(e) {
        return o.isWeb ? new Error(n.localize(18, null)) : new Error(n.localize(19, null, JSON.stringify(e)))
    }

    function w(e, t) {
        void 0 === t && (t = {});
        var n = new Error(e);
        return i.isNumber(t.severity) && (n.severity = t.severity), t.actions && (n.actions = t.actions), n
    }

    var x = function () {
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
    t.ErrorHandler = x, t.errorHandler = new x, t.setUnexpectedErrorHandler = c, t.onUnexpectedError = u, t.onUnexpectedPromiseError = l, t.transformErrorForSerialization = f;
    var O = function () {
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
            return null !== r && null !== o ? n.localize(0, null, a.rtrim(o, "."), r) : null !== o ? o : t && null !== e.responseText ? e.responseText : null
        }, e.prototype.connectionErrorToMessage = function (e, t) {
            var r = this.connectionErrorDetailsToMessage(e, t);
            return 401 === e.status ? null !== r ? n.localize(1, null, r) : n.localize(2, null) : r ? r : e.status > 0 && null !== e.statusText ? t && null !== e.responseText && e.responseText.length > 0 ? n.localize(3, null, e.statusText, e.status, e.responseText) : n.localize(4, null, e.statusText, e.status) : t && null !== e.responseText && e.responseText.length > 0 ? n.localize(5, null, e.responseText) : n.localize(6, null)
        }, e
    }();
    t.ConnectionError = O, r.derive(Error, O), t.toErrorMessage = m;
    var T = "Canceled";
    t.isPromiseCanceledError = v, t.canceled = g, t.notImplemented = y, t.illegalArgument = _, t.illegalState = b, t.readonly = E, t.loaderError = S, t.create = w
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
                for (var r = [], o = this._callbacks.slice(0), i = this._contexts.slice(0), s = 0, a = o.length; a > s; s++)try {
                    r.push(o[s].apply(i[s], e))
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
    var s = function () {
        function e(e) {
            this._options = e
        }

        return Object.defineProperty(e.prototype, "event", {
            get: function () {
                var t = this;
                return this._event || (this._event = function (r, o, i) {
                    t._callbacks || (t._callbacks = new n["default"]), t._options && t._options.onFirstListenerAdd && t._callbacks.isEmpty() && t._options.onFirstListenerAdd(t), t._callbacks.add(r, o);
                    var s;
                    return s = {
                        dispose: function () {
                            s.dispose = e._noop, t._disposed || (t._callbacks.remove(r, o), t._options && t._options.onLastListenerRemove && t._callbacks.isEmpty() && t._options.onLastListenerRemove(t))
                        }
                    }, Array.isArray(i) && i.push(s), s
                }), this._event
            }, enumerable: !0, configurable: !0
        }), e.prototype.fire = function (e) {
            this._callbacks && this._callbacks.invoke.call(this._callbacks, e)
        }, e.prototype.dispose = function () {
            this._callbacks && (this._callbacks.dispose(), this._callbacks = void 0, this._disposed = !0)
        }, e._noop = function () {
        }, e
    }();
    t.Emitter = s, t.fromEventEmitter = r, t.mapEvent = o;
    var a;
    !function (e) {
        e[e.Idle = 0] = "Idle", e[e.Running = 1] = "Running"
    }(a || (a = {}));
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
    }(), s = function () {
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
    t.CancellationTokenSource = s
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/base/common/eventEmitter", ["require", "exports", "vs/base/common/errors"], function (e, t, n) {
    "use strict";
    var r = function () {
        function e(e, t, n) {
            void 0 === n && (n = null), this._type = e, this._data = t, this._emitterType = n
        }

        return e.prototype.getType = function () {
            return this._type
        }, e.prototype.getData = function () {
            return this._data
        }, e.prototype.getEmitterType = function () {
            return this._emitterType
        }, e
    }();
    t.EmitterEvent = r;
    var o = function () {
        function e(e) {
            if (void 0 === e && (e = null), this._listeners = {}, this._bulkListeners = [], this._collectedEvents = [], this._deferredCnt = 0, e) {
                this._allowedEventTypes = {};
                for (var t = 0; t < e.length; t++)this._allowedEventTypes[e[t]] = !0
            } else this._allowedEventTypes = null
        }

        return e.prototype.dispose = function () {
            this._listeners = {}, this._bulkListeners = [], this._collectedEvents = [], this._deferredCnt = 0, this._allowedEventTypes = null
        }, e.prototype.addListener = function (e, t) {
            if ("*" === e)throw new Error("Use addBulkListener(listener) to register your listener!");
            if (this._allowedEventTypes && !this._allowedEventTypes.hasOwnProperty(e))throw new Error("This object will never emit this event type!");
            this._listeners.hasOwnProperty(e) ? this._listeners[e].push(t) : this._listeners[e] = [t];
            var n = this;
            return function () {
                n && (n._removeListener(e, t), n = null, t = null)
            }
        }, e.prototype.addListener2 = function (e, t) {
            var n = this.addListener(e, t);
            return {dispose: n}
        }, e.prototype.on = function (e, t) {
            return this.addListener(e, t)
        }, e.prototype.addOneTimeListener = function (e, t) {
            var n = this.addListener(e, function (e) {
                n(), t(e)
            });
            return n
        }, e.prototype.addOneTimeDisposableListener = function (e, t) {
            var n = this.addOneTimeListener(e, t);
            return {dispose: n}
        }, e.prototype.addBulkListener = function (e) {
            var t = this;
            return this._bulkListeners.push(e), function () {
                t._removeBulkListener(e)
            }
        }, e.prototype.addBulkListener2 = function (e) {
            var t = this.addBulkListener(e);
            return {dispose: t}
        }, e.prototype.addEmitter = function (e, t) {
            var n = this;
            return void 0 === t && (t = null), e.addBulkListener(function (e) {
                var o = e;
                if (t) {
                    o = [];
                    for (var i = 0, s = e.length; s > i; i++)o.push(new r(e[i].getType(), e[i].getData(), t))
                }
                0 === n._deferredCnt ? n._emitEvents(o) : n._collectedEvents.push.apply(n._collectedEvents, o)
            })
        }, e.prototype.addEmitter2 = function (e, t) {
            var n = this.addEmitter(e, t);
            return {dispose: n}
        }, e.prototype.addEmitterTypeListener = function (e, t, n) {
            if (t) {
                if ("*" === e)throw new Error("Bulk listeners cannot specify an emitter type");
                return this.addListener(e + "/" + t, n)
            }
            return this.addListener(e, n)
        }, e.prototype._removeListener = function (e, t) {
            if (this._listeners.hasOwnProperty(e))for (var n = this._listeners[e], r = 0, o = n.length; o > r; r++)if (n[r] === t) {
                n.splice(r, 1);
                break
            }
        }, e.prototype._removeBulkListener = function (e) {
            for (var t = 0, n = this._bulkListeners.length; n > t; t++)if (this._bulkListeners[t] === e) {
                this._bulkListeners.splice(t, 1);
                break
            }
        }, e.prototype._emitToSpecificTypeListeners = function (e, t) {
            if (this._listeners.hasOwnProperty(e))for (var r = this._listeners[e].slice(0), o = 0, i = r.length; i > o; o++)try {
                r[o](t)
            } catch (s) {
                n.onUnexpectedError(s)
            }
        }, e.prototype._emitToBulkListeners = function (e) {
            for (var t = this._bulkListeners.slice(0), r = 0, o = t.length; o > r; r++)try {
                t[r](e)
            } catch (i) {
                n.onUnexpectedError(i)
            }
        }, e.prototype._emitEvents = function (e) {
            this._bulkListeners.length > 0 && this._emitToBulkListeners(e);
            for (var t = 0, n = e.length; n > t; t++) {
                var r = e[t];
                this._emitToSpecificTypeListeners(r.getType(), r.getData()), r.getEmitterType() && this._emitToSpecificTypeListeners(r.getType() + "/" + r.getEmitterType(), r.getData())
            }
        }, e.prototype.emit = function (e, t) {
            if (void 0 === t && (t = {}), this._allowedEventTypes && !this._allowedEventTypes.hasOwnProperty(e))throw new Error("Cannot emit this event type because it wasn't white-listed!");
            if (this._listeners.hasOwnProperty(e) || 0 !== this._bulkListeners.length) {
                var n = new r(e, t);
                0 === this._deferredCnt ? this._emitEvents([n]) : this._collectedEvents.push(n)
            }
        }, e.prototype.deferredEmit = function (e) {
            this._deferredCnt = this._deferredCnt + 1;
            var t = null;
            try {
                t = e()
            } catch (r) {
                n.onUnexpectedError(r)
            }
            return this._deferredCnt = this._deferredCnt - 1, 0 === this._deferredCnt && this._emitCollected(), t
        }, e.prototype._emitCollected = function () {
            var e = this._collectedEvents;
            this._collectedEvents = [], e.length > 0 && this._emitEvents(e)
        }, e
    }();
    t.EventEmitter = o;
    var i = function () {
        function e(e, t) {
            this.target = e, this.arg = t
        }

        return e
    }(), s = function (e) {
        function t(t) {
            void 0 === t && (t = null), e.call(this, t), this._emitQueue = []
        }

        return __extends(t, e), t.prototype._emitToSpecificTypeListeners = function (e, t) {
            if (this._listeners.hasOwnProperty(e))for (var n = this._listeners[e], r = 0, o = n.length; o > r; r++)this._emitQueue.push(new i(n[r], t))
        }, t.prototype._emitToBulkListeners = function (e) {
            for (var t = this._bulkListeners, n = 0, r = t.length; r > n; n++)this._emitQueue.push(new i(t[n], e))
        }, t.prototype._emitEvents = function (t) {
            for (e.prototype._emitEvents.call(this, t); this._emitQueue.length > 0;) {
                var r = this._emitQueue.shift();
                try {
                    r.target(r.arg)
                } catch (o) {
                    n.onUnexpectedError(o)
                }
            }
        }, t
    }(o);
    t.OrderGuaranteeEventEmitter = s
}), define("vs/base/common/timer", ["require", "exports", "vs/base/common/platform", "vs/base/common/errors", "vs/base/common/stopwatch"], function (e, t, n, r, o) {
    "use strict";
    function i(e, t, n, r) {
        return p.start(e, t, n, r)
    }

    function s() {
        return p
    }

    t.ENABLE_TIMER = !1;
    var a = n.globals.msWriteProfilerMark;
    !function (e) {
        e[e.EDITOR = 0] = "EDITOR", e[e.LANGUAGES = 1] = "LANGUAGES", e[e.WORKER = 2] = "WORKER", e[e.WORKBENCH = 3] = "WORKBENCH", e[e.STARTUP = 4] = "STARTUP"
    }(t.Topic || (t.Topic = {}));
    var c = t.Topic, u = function () {
        function e() {
        }

        return e.prototype.stop = function () {
        }, e.prototype.timeTaken = function () {
            return -1
        }, e
    }(), l = function () {
        function e(e, t, n, r, i) {
            if (this.timeKeeper = e, this.name = t, this.description = i, this.topic = n, this.stopTime = null, r)return void(this.startTime = r);
            if (this.startTime = new Date, this.sw = o.StopWatch.create(), a) {
                var s = ["Monaco", this.topic, this.name, "start"];
                a(s.join("|"))
            }
        }

        return e.prototype.stop = function (e) {
            if (null === this.stopTime) {
                if (e)return this.stopTime = e, this.sw = null, void this.timeKeeper._onEventStopped(this);
                if (this.stopTime = new Date, this.sw && this.sw.stop(), this.timeKeeper._onEventStopped(this), a) {
                    var t = ["Monaco", this.topic, this.name, "stop"];
                    a(t.join("|"))
                }
            }
        }, e.prototype.timeTaken = function () {
            return this.sw ? this.sw.elapsed() : this.stopTime ? this.stopTime.getTime() - this.startTime.getTime() : -1
        }, e
    }(), f = function () {
        function e() {
            this.cleaningIntervalId = -1, this.collectedEvents = [], this.listeners = []
        }

        return e.prototype.isEnabled = function () {
            return t.ENABLE_TIMER
        }, e.prototype.start = function (e, n, r, o) {
            if (!this.isEnabled())return t.nullEvent;
            var i;
            "string" == typeof e ? i = e : e === c.EDITOR ? i = "Editor" : e === c.LANGUAGES ? i = "Languages" : e === c.WORKER ? i = "Worker" : e === c.WORKBENCH ? i = "Workbench" : e === c.STARTUP && (i = "Startup"), this.initAutoCleaning();
            var s = new l(this, n, i, r, o);
            return this.addEvent(s), s
        }, e.prototype.dispose = function () {
            -1 !== this.cleaningIntervalId && (n.clearInterval(this.cleaningIntervalId), this.cleaningIntervalId = -1)
        }, e.prototype.addListener = function (e) {
            this.listeners.push(e)
        }, e.prototype.removeListener = function (e) {
            for (var t = 0; t < this.listeners.length; t++)if (this.listeners[t] === e)return void this.listeners.splice(t, 1)
        }, e.prototype.addEvent = function (t) {
            t.id = e.EVENT_ID, e.EVENT_ID++, this.collectedEvents.push(t), this.collectedEvents.length > e._EVENT_CACHE_LIMIT && this.collectedEvents.shift()
        }, e.prototype.initAutoCleaning = function () {
            var t = this;
            -1 === this.cleaningIntervalId && (this.cleaningIntervalId = n.setInterval(function () {
                var n = Date.now();
                t.collectedEvents.forEach(function (t) {
                    !t.stopTime && n - t.startTime.getTime() >= e._MAX_TIMER_LENGTH && t.stop()
                })
            }, e._CLEAN_UP_INTERVAL))
        }, e.prototype.getCollectedEvents = function () {
            return this.collectedEvents.slice(0)
        }, e.prototype.clearCollectedEvents = function () {
            this.collectedEvents = []
        }, e.prototype._onEventStopped = function (e) {
            for (var t = [e], n = this.listeners.slice(0), o = 0; o < n.length; o++)try {
                n[o](t)
            } catch (i) {
                r.onUnexpectedError(i)
            }
        }, e.prototype.setInitialCollectedEvents = function (t, n) {
            var r = this;
            this.isEnabled() && (n && (e.PARSE_TIME = n), t.forEach(function (e) {
                var t = new l(r, e.name, e.topic, e.startTime, e.description);
                t.stop(e.stopTime), r.addEvent(t)
            }))
        }, e._MAX_TIMER_LENGTH = 6e4, e._CLEAN_UP_INTERVAL = 12e4, e._EVENT_CACHE_LIMIT = 1e3, e.EVENT_ID = 1, e.PARSE_TIME = new Date, e
    }();
    t.TimeKeeper = f;
    var p = new f;
    t.nullEvent = new u, t.start = i, t.getTimeKeeper = s
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
        var r, i, s, a = new o.Promise(function (e, t, n) {
            r = e, i = t, s = n
        }, function () {
            e.cancel()
        });
        return e.then(function (e) {
            t && t(e), r(e)
        }, function (e) {
            n && n(e), i(e)
        }, s), a
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
define("vs/base/common/async", ["require", "exports", "vs/base/common/errors", "vs/base/common/winjs.base", "vs/base/common/platform", "vs/base/common/cancellation", "vs/base/common/lifecycle"], function (e, t, n, r, o, i, s) {
    "use strict";
    function a(e) {
        return e && "function" == typeof e.then
    }

    function c(e) {
        var t = new i.CancellationTokenSource;
        return new r.TPromise(function (n, r) {
            var o = e(t.token);
            a(o) ? o.then(n, r) : n(o)
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

    function h(e, t) {
        for (var n = [], o = 2; o < arguments.length; o++)n[o - 2] = arguments[o];
        return new r.Promise(function (r, o) {
            return t.call.apply(t, [e].concat(n, [function (e, t) {
                return e ? o(e) : r(t)
            }]))
        })
    }

    t.asWinJsPromise = c;
    var d = function () {
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
    t.Throttler = d;
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
    var v = function (e) {
        function t(t) {
            e.call(this, t), this.throttler = new d
        }

        return __extends(t, e), t.prototype.trigger = function (t, n) {
            var r = this;
            return e.prototype.trigger.call(this, function () {
                return r.throttler.queue(t)
            }, n)
        }, t
    }(m);
    t.ThrottledDelayer = v;
    var g = function (e) {
        function t(t, n) {
            void 0 === n && (n = 0), e.call(this, t), this.minimumPeriod = n, this.periodThrottler = new d
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
    }(v);
    t.PeriodThrottledDelayer = g;
    var y = function () {
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
    t.PromiseSource = y;
    var _ = function (e) {
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
    t.ShallowCancelThenPromise = _, t.always = u, t.sequence = l, t.once = f;
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
    var E = function (e) {
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
    }(s.Disposable);
    t.TimeoutTimer = E;
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
    }(s.Disposable);
    t.IntervalTimer = S;
    var w = function () {
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
    t.RunOnceScheduler = w, t.nfcall = p, t.ninvoke = h
}), define("vs/base/common/service", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/objects", "vs/base/common/lifecycle", "vs/base/common/event"], function (e, t, n, r, o, i) {
    "use strict";
    function s(e, t) {
        e[t] = (n = {}, n[p] = !0, n);
        var n
    }

    function a(e) {
        return e[p]
    }

    function c(e, t, n) {
        var o, s = function () {
            return o || (o = e.then(function (e) {
                return e.getService(t, n)
            })), o
        };
        return Object.keys(n.prototype).filter(function (e) {
            return "constructor" !== e
        }).reduce(function (e, t) {
            if (a(n.prototype[t])) {
                var o, c, u = new i.Emitter({
                    onFirstListenerAdd: function () {
                        o = s().then(function (e) {
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
                return s().then(function (n) {
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
    t.ServiceEvent = s, t.isServiceEvent = a;
    var h = function () {
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
            var t, r = this.services[e.serviceName], o = r.constructor.prototype, i = o && o[e.name], s = i && i[p], a = r[e.name];
            if (s) {
                var c;
                t = new n.Promise(function (e, t, n) {
                    return c = a.call(r, n)
                }, function () {
                    return c.dispose()
                })
            } else {
                if (a)try {
                    t = a.call.apply(a, [r].concat(e.args))
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
    t.Server = h;
    var d = function () {
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
            return o.reduce(function (o, s) {
                if (t.prototype[s][p]) {
                    var a, c = new i.Emitter({
                        onFirstListenerAdd: function () {
                            a = n.request(e, s).then(null, null, function (e) {
                                return c.fire(e)
                            })
                        }, onLastListenerRemove: function () {
                            a.cancel(), a = null
                        }
                    });
                    return r.assign(o, (u = {}, u[s] = c.event, u))
                }
                return r.assign(o, (l = {}, l[s] = function () {
                    for (var t = [], r = 0; r < arguments.length; r++)t[r - 0] = arguments[r];
                    return n.request.apply(n, [e, s].concat(t))
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
                            var s = new Error(e.data.message);
                            s.stack = e.data.stack, s.name = e.data.name, o(s);
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
    t.Client = d, t.getService = c
}), define("vs/base/node/pfs", ["require", "exports", "vs/base/common/winjs.base", "vs/base/node/extfs", "vs/base/common/paths", "path", "vs/base/common/async", "fs"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    function c(e) {
        return e === i.dirname(e)
    }

    function u(e) {
        return s.nfcall(r.readdir, e)
    }

    function l(e) {
        return new n.Promise(function (t) {
            return a.exists(e, t)
        })
    }

    function f(e, t) {
        return s.nfcall(a.chmod, e, t)
    }

    function p(e, t) {
        var r = function () {
            return s.nfcall(a.mkdir, e, t).then(null, function (t) {
                return "EEXIST" === t.code ? s.nfcall(a.stat, e).then(function (t) {
                    return t.isDirectory ? null : n.Promise.wrapError(new Error("'" + e + "' exists and is not a directory."))
                }) : n.TPromise.wrapError(t)
            })
        };
        return c(e) ? n.TPromise.as(!0) : r().then(null, function (o) {
            return "ENOENT" === o.code ? p(i.dirname(e), t).then(r) : n.TPromise.wrapError(o)
        })
    }

    function h(e) {
        return m(e).then(function (t) {
            return t.isDirectory() ? u(e).then(function (t) {
                return n.TPromise.join(t.map(function (t) {
                    return h(i.join(e, t))
                }))
            }).then(function () {
                return _(e)
            }) : b(e)
        }, function (e) {
            return "ENOENT" !== e.code ? n.TPromise.wrapError(e) : void 0
        })
    }

    function d(e) {
        return s.nfcall(a.realpath, e, null)
    }

    function m(e) {
        return s.nfcall(a.stat, e)
    }

    function v(e) {
        return s.nfcall(a.lstat, e)
    }

    function g(e) {
        return w(e.slice(0))
    }

    function y(e, t) {
        return s.nfcall(a.rename, e, t)
    }

    function _(e) {
        return s.nfcall(a.rmdir, e)
    }

    function b(e) {
        return s.nfcall(a.unlink, e)
    }

    function E(e, t, n) {
        return s.nfcall(a.symlink, e, t, n)
    }

    function S(e) {
        return s.nfcall(a.readlink, e)
    }

    function w(e) {
        var t = e.shift();
        return m(t).then(function (e) {
            return {path: t, stats: e}
        }, function (t) {
            return 0 === e.length ? t : g(e)
        })
    }

    function x(e, t) {
        return s.nfcall(a.readFile, e, t)
    }

    function O(e, t, n) {
        return void 0 === n && (n = "utf8"), s.nfcall(a.writeFile, e, t, n)
    }

    function T(e) {
        return u(e).then(function (t) {
            return n.TPromise.join(t.map(function (t) {
                return C(o.join(e, t), t)
            })).then(function (e) {
                return L(e)
            })
        })
    }

    function C(e, t) {
        return k(e).then(function (e) {
            return e ? t : null
        })
    }

    function k(e) {
        return m(e).then(function (e) {
            return e.isDirectory()
        }, function () {
            return !1
        })
    }

    function P(e) {
        return m(e).then(function (e) {
            return e.isFile()
        }, function () {
            return !1
        })
    }

    function I(e, t) {
        return u(e).then(function (r) {
            r = r.filter(function (e) {
                return t.test(e)
            });
            var i = r.map(function (t) {
                return A(o.join(e, t), t)
            });
            return n.TPromise.join(i).then(function (e) {
                return L(e)
            })
        })
    }

    function A(e, t) {
        return P(e).then(function (e) {
            return e ? t : null
        }, function (e) {
            return n.TPromise.wrapError(e)
        })
    }

    function L(e) {
        return e.filter(function (e) {
            return null !== e
        })
    }

    t.isRoot = c, t.readdir = u, t.exists = l, t.chmod = f, t.mkdirp = p, t.rimraf = h, t.realpath = d, t.stat = m, t.lstat = v, t.mstat = g, t.rename = y, t.rmdir = _, t.unlink = b, t.symlink = E, t.readlink = S, t.readFile = x, t.writeFile = O, t.readDirsInDir = T, t.dirExists = k, t.fileExists = P, t.readFiles = I, t.fileExistsWithResult = A
}), define("vs/base/node/request", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/types", "https", "http", "url", "fs", "vs/base/common/objects"], function (e, t, n, r, o, i, s, a, c) {
    "use strict";
    function u(e) {
        var t;
        return new n.TPromise(function (n, a) {
            var l = s.parse(e.url), f = {
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
            }), t.on("error", a), e.timeout && t.setTimeout(e.timeout), e.data && t.write(e.data), t.end()
        }, function () {
            return t && t.abort()
        })
    }

    function l(e, t) {
        return u(c.assign(t, {followRedirects: 3})).then(function (t) {
            return new n.TPromise(function (n, r) {
                var o = a.createWriteStream(e);
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
    function s(e, t, n) {
        for (void 0 === n && (n = 0); n < e.length && e[n] !== t;)n++;
        return n
    }

    function a(e) {
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
                for (var r = 0, o = 0; (o = s(n, 0, r)) < n.length;) {
                    var i = n.slice(r, o);
                    t.buffer ? (e(JSON.parse(Buffer.concat([t.buffer, i]).toString("utf8"))), t.buffer = null) : e(JSON.parse(i.toString("utf8"))), r = o + 1
                }
                if (o - r > 0) {
                    var a = n.slice(r, o);
                    t.buffer ? t.buffer = Buffer.concat([t.buffer, a]) : t.buffer = a
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
    t.Client = f, t.serve = a, t.connect = c
}), define("vs/nls!vs/base/common/json", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/base/common/json", t)
}), define("vs/base/common/json", ["require", "exports", "vs/nls!vs/base/common/json"], function (e, t, n) {
    "use strict";
    function r(e, t) {
        function n(t, n) {
            for (var r = 0, o = 0; t > r || !n;) {
                var i = e.charCodeAt(d);
                if (i >= p._0 && i <= p._9)o = 16 * o + i - p._0; else if (i >= p.A && i <= p.F)o = 16 * o + i - p.A + 10; else {
                    if (!(i >= p.a && i <= p.f))break;
                    o = 16 * o + i - p.a + 10
                }
                d++, r++
            }
            return t > r && (o = -1), o
        }

        function r() {
            var t = d;
            if (e.charCodeAt(d) === p._0)d++; else for (d++; d < e.length && s(e.charCodeAt(d));)d++;
            if (d < e.length && e.charCodeAt(d) === p.dot) {
                if (d++, !(d < e.length && s(e.charCodeAt(d))))return _ = l.UnexpectedEndOfNumber, e.substring(t, n);
                for (d++; d < e.length && s(e.charCodeAt(d));)d++
            }
            var n = d;
            if (d < e.length && (e.charCodeAt(d) === p.E || e.charCodeAt(d) === p.e))if (d++, (d < e.length && e.charCodeAt(d) === p.plus || e.charCodeAt(d) === p.minus) && d++, d < e.length && s(e.charCodeAt(d))) {
                for (d++; d < e.length && s(e.charCodeAt(d));)d++;
                n = d
            } else _ = l.UnexpectedEndOfNumber;
            return e.substring(t, n)
        }

        function a() {
            for (var t = "", r = d; ;) {
                if (d >= m) {
                    t += e.substring(r, d), _ = l.UnexpectedEndOfString;
                    break
                }
                var o = e.charCodeAt(d);
                if (o === p.doubleQuote) {
                    t += e.substring(r, d), d++;
                    break
                }
                if (o !== p.backslash) {
                    if (i(o)) {
                        t += e.substring(r, d), _ = l.UnexpectedEndOfString;
                        break
                    }
                    d++
                } else {
                    if (t += e.substring(r, d), d++, d >= m) {
                        _ = l.UnexpectedEndOfString;
                        break
                    }
                    switch (o = e.charCodeAt(d++)) {
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
                            o >= 0 ? t += String.fromCharCode(o) : _ = l.InvalidUnicode;
                            break;
                        default:
                            _ = l.InvalidEscapeCharacter
                    }
                    r = d
                }
            }
            return t
        }

        function c() {
            if (v = "", _ = l.None, g = d, d >= m)return g = m, y = f.EOF;
            var t = e.charCodeAt(d);
            if (o(t)) {
                do d++, v += String.fromCharCode(t), t = e.charCodeAt(d); while (o(t));
                return y = f.Trivia
            }
            if (i(t))return d++, v += String.fromCharCode(t), t === p.carriageReturn && e.charCodeAt(d) === p.lineFeed && (d++, v += "\n"), y = f.LineBreakTrivia;
            switch (t) {
                case p.openBrace:
                    return d++, y = f.OpenBraceToken;
                case p.closeBrace:
                    return d++, y = f.CloseBraceToken;
                case p.openBracket:
                    return d++, y = f.OpenBracketToken;
                case p.closeBracket:
                    return d++, y = f.CloseBracketToken;
                case p.colon:
                    return d++, y = f.ColonToken;
                case p.comma:
                    return d++, y = f.CommaToken;
                case p.doubleQuote:
                    return d++, v = a(), y = f.StringLiteral;
                case p.slash:
                    var n = d - 1;
                    if (e.charCodeAt(d + 1) === p.slash) {
                        for (d += 2; m > d && !i(e.charCodeAt(d));)d++;
                        return v = e.substring(n, d), y = f.LineCommentTrivia
                    }
                    if (e.charCodeAt(d + 1) === p.asterisk) {
                        d += 2;
                        for (var c = m - 1, h = !1; c > d;) {
                            var b = e.charCodeAt(d);
                            if (b === p.asterisk && e.charCodeAt(d + 1) === p.slash) {
                                d += 2, h = !0;
                                break
                            }
                            d++
                        }
                        return h || (d++, _ = l.UnexpectedEndOfComment), v = e.substring(n, d), y = f.BlockCommentTrivia
                    }
                    return v += String.fromCharCode(t), d++, y = f.Unknown;
                case p.minus:
                    if (v += String.fromCharCode(t), d++, d === m || !s(e.charCodeAt(d)))return y = f.Unknown;
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
                    return v += r(), y = f.NumericLiteral;
                default:
                    for (; m > d && u(t);)d++, t = e.charCodeAt(d);
                    if (g !== d) {
                        switch (v = e.substring(g, d)) {
                            case"true":
                                return y = f.TrueKeyword;
                            case"false":
                                return y = f.FalseKeyword;
                            case"null":
                                return y = f.NullKeyword
                        }
                        return y = f.Unknown
                    }
                    return v += String.fromCharCode(t), d++, y = f.Unknown
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

        function h() {
            var e;
            do e = c(); while (e >= f.LineCommentTrivia && e <= f.Trivia);
            return e
        }

        void 0 === t && (t = !1);
        var d = 0, m = e.length, v = "", g = 0, y = f.Unknown, _ = l.None;
        return {
            getPosition: function () {
                return d
            }, scan: t ? h : c, getToken: function () {
                return y
            }, getTokenValue: function () {
                return v
            }, getTokenOffset: function () {
                return g
            }, getTokenLength: function () {
                return d - g
            }, getTokenError: function () {
                return _
            }
        }
    }

    function o(e) {
        return e === p.space || e === p.tab || e === p.verticalTab || e === p.formFeed || e === p.nonBreakingSpace || e === p.ogham || e >= p.enQuad && e <= p.zeroWidthSpace || e === p.narrowNoBreakSpace || e === p.mathematicalSpace || e === p.ideographicSpace || e === p.byteOrderMark
    }

    function i(e) {
        return e === p.lineFeed || e === p.carriageReturn || e === p.lineSeparator || e === p.paragraphSeparator
    }

    function s(e) {
        return e >= p._0 && e <= p._9
    }

    function a(e) {
        return e >= p.a && e <= p.z || e >= p.A && e <= p.Z
    }

    function c(e, t) {
        var n, o, i = r(e), s = [], a = 0;
        do switch (o = i.getPosition(), n = i.scan()) {
            case f.LineCommentTrivia:
            case f.BlockCommentTrivia:
            case f.EOF:
                a !== o && s.push(e.substring(a, o)), void 0 !== t && s.push(i.getTokenValue().replace(/[^\r\n]/g, t)), a = i.getPosition()
        } while (n !== f.EOF);
        return s.join("")
    }

    function u(e, t) {
        function o() {
            for (var e = d.scan(); e === f.Unknown;)i(n.localize(0, null)), e = d.scan();
            return e
        }

        function i(e, n, r) {
            if (void 0 === n && (n = []), void 0 === r && (r = []), t.push(e), n.length + r.length > 0)for (var i = d.getToken(); i !== f.EOF;) {
                if (-1 !== n.indexOf(i)) {
                    o();
                    break
                }
                if (-1 !== r.indexOf(i))break;
                i = o()
            }
        }

        function s() {
            if (d.getToken() !== f.StringLiteral)return h;
            var e = d.getTokenValue();
            return o(), e
        }

        function a() {
            var e;
            switch (d.getToken()) {
                case f.NumericLiteral:
                    try {
                        e = JSON.parse(d.getTokenValue()), "number" != typeof e && (i(n.localize(1, null)), e = 0)
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
                    return h
            }
            return o(), e
        }

        function c(e) {
            var t = s();
            if (t === h)return i(n.localize(2, null), [], [f.CloseBraceToken, f.CommaToken]), !1;
            if (d.getToken() === f.ColonToken) {
                o();
                var r = p();
                r !== h ? e[t] = r : i(n.localize(3, null), [], [f.CloseBraceToken, f.CommaToken])
            } else i(n.localize(4, null), [], [f.CloseBraceToken, f.CommaToken]);
            return !0
        }

        function u() {
            if (d.getToken() !== f.OpenBraceToken)return h;
            var e = {};
            o();
            for (var t = !1; d.getToken() !== f.CloseBraceToken && d.getToken() !== f.EOF;) {
                d.getToken() === f.CommaToken ? (t || i(n.localize(5, null), [], []), o()) : t && i(n.localize(6, null), [], []);
                var r = c(e);
                r || i(n.localize(7, null), [], [f.CloseBraceToken, f.CommaToken]), t = !0
            }
            return d.getToken() !== f.CloseBraceToken ? i(n.localize(8, null), [f.CloseBraceToken], []) : o(), e
        }

        function l() {
            if (d.getToken() !== f.OpenBracketToken)return h;
            var e = [];
            o();
            for (var t = !1; d.getToken() !== f.CloseBracketToken && d.getToken() !== f.EOF;) {
                d.getToken() === f.CommaToken ? (t || i(n.localize(9, null), [], []), o()) : t && i(n.localize(10, null), [], []);
                var r = p();
                r === h ? i(n.localize(11, null), [], [f.CloseBracketToken, f.CommaToken]) : e.push(r), t = !0
            }
            return d.getToken() !== f.CloseBracketToken ? i(n.localize(12, null), [f.CloseBracketToken], []) : o(), e
        }

        function p() {
            var e = l();
            return e !== h ? e : (e = u(), e !== h ? e : (e = s(), e !== h ? e : a()))
        }

        void 0 === t && (t = []);
        var h = Object(), d = r(e, !0);
        o();
        var m = p();
        return m === h ? void i(n.localize(13, null), [], []) : (d.getToken() !== f.EOF && i(n.localize(14, null), [], []),
            m)
    }

    !function (e) {
        e[e.None = 0] = "None", e[e.UnexpectedEndOfComment = 1] = "UnexpectedEndOfComment", e[e.UnexpectedEndOfString = 2] = "UnexpectedEndOfString", e[e.UnexpectedEndOfNumber = 3] = "UnexpectedEndOfNumber", e[e.InvalidUnicode = 4] = "InvalidUnicode", e[e.InvalidEscapeCharacter = 5] = "InvalidEscapeCharacter"
    }(t.ScanError || (t.ScanError = {}));
    var l = t.ScanError;
    !function (e) {
        e[e.Unknown = 0] = "Unknown", e[e.OpenBraceToken = 1] = "OpenBraceToken", e[e.CloseBraceToken = 2] = "CloseBraceToken", e[e.OpenBracketToken = 3] = "OpenBracketToken", e[e.CloseBracketToken = 4] = "CloseBracketToken", e[e.CommaToken = 5] = "CommaToken", e[e.ColonToken = 6] = "ColonToken", e[e.NullKeyword = 7] = "NullKeyword", e[e.TrueKeyword = 8] = "TrueKeyword", e[e.FalseKeyword = 9] = "FalseKeyword", e[e.StringLiteral = 10] = "StringLiteral", e[e.NumericLiteral = 11] = "NumericLiteral", e[e.LineCommentTrivia = 12] = "LineCommentTrivia", e[e.BlockCommentTrivia = 13] = "BlockCommentTrivia", e[e.LineBreakTrivia = 14] = "LineBreakTrivia", e[e.Trivia = 15] = "Trivia", e[e.EOF = 16] = "EOF"
    }(t.SyntaxKind || (t.SyntaxKind = {}));
    var f = t.SyntaxKind;
    t.createScanner = r, t.isLetter = a;
    var p;
    !function (e) {
        e[e.nullCharacter = 0] = "nullCharacter", e[e.maxAsciiCharacter = 127] = "maxAsciiCharacter", e[e.lineFeed = 10] = "lineFeed", e[e.carriageReturn = 13] = "carriageReturn", e[e.lineSeparator = 8232] = "lineSeparator", e[e.paragraphSeparator = 8233] = "paragraphSeparator", e[e.nextLine = 133] = "nextLine", e[e.space = 32] = "space", e[e.nonBreakingSpace = 160] = "nonBreakingSpace", e[e.enQuad = 8192] = "enQuad", e[e.emQuad = 8193] = "emQuad", e[e.enSpace = 8194] = "enSpace", e[e.emSpace = 8195] = "emSpace", e[e.threePerEmSpace = 8196] = "threePerEmSpace", e[e.fourPerEmSpace = 8197] = "fourPerEmSpace", e[e.sixPerEmSpace = 8198] = "sixPerEmSpace", e[e.figureSpace = 8199] = "figureSpace", e[e.punctuationSpace = 8200] = "punctuationSpace", e[e.thinSpace = 8201] = "thinSpace", e[e.hairSpace = 8202] = "hairSpace", e[e.zeroWidthSpace = 8203] = "zeroWidthSpace", e[e.narrowNoBreakSpace = 8239] = "narrowNoBreakSpace", e[e.ideographicSpace = 12288] = "ideographicSpace", e[e.mathematicalSpace = 8287] = "mathematicalSpace", e[e.ogham = 5760] = "ogham", e[e._ = 95] = "_", e[e.$ = 36] = "$", e[e._0 = 48] = "_0", e[e._1 = 49] = "_1", e[e._2 = 50] = "_2", e[e._3 = 51] = "_3", e[e._4 = 52] = "_4", e[e._5 = 53] = "_5", e[e._6 = 54] = "_6", e[e._7 = 55] = "_7", e[e._8 = 56] = "_8", e[e._9 = 57] = "_9", e[e.a = 97] = "a", e[e.b = 98] = "b", e[e.c = 99] = "c", e[e.d = 100] = "d", e[e.e = 101] = "e", e[e.f = 102] = "f", e[e.g = 103] = "g", e[e.h = 104] = "h", e[e.i = 105] = "i", e[e.j = 106] = "j", e[e.k = 107] = "k", e[e.l = 108] = "l", e[e.m = 109] = "m", e[e.n = 110] = "n", e[e.o = 111] = "o", e[e.p = 112] = "p", e[e.q = 113] = "q", e[e.r = 114] = "r", e[e.s = 115] = "s", e[e.t = 116] = "t", e[e.u = 117] = "u", e[e.v = 118] = "v", e[e.w = 119] = "w", e[e.x = 120] = "x", e[e.y = 121] = "y", e[e.z = 122] = "z", e[e.A = 65] = "A", e[e.B = 66] = "B", e[e.C = 67] = "C", e[e.D = 68] = "D", e[e.E = 69] = "E", e[e.F = 70] = "F", e[e.G = 71] = "G", e[e.H = 72] = "H", e[e.I = 73] = "I", e[e.J = 74] = "J", e[e.K = 75] = "K", e[e.L = 76] = "L", e[e.M = 77] = "M", e[e.N = 78] = "N", e[e.O = 79] = "O", e[e.P = 80] = "P", e[e.Q = 81] = "Q", e[e.R = 82] = "R", e[e.S = 83] = "S", e[e.T = 84] = "T", e[e.U = 85] = "U", e[e.V = 86] = "V", e[e.W = 87] = "W", e[e.X = 88] = "X", e[e.Y = 89] = "Y", e[e.Z = 90] = "Z", e[e.ampersand = 38] = "ampersand", e[e.asterisk = 42] = "asterisk", e[e.at = 64] = "at", e[e.backslash = 92] = "backslash", e[e.bar = 124] = "bar", e[e.caret = 94] = "caret", e[e.closeBrace = 125] = "closeBrace", e[e.closeBracket = 93] = "closeBracket", e[e.closeParen = 41] = "closeParen", e[e.colon = 58] = "colon", e[e.comma = 44] = "comma", e[e.dot = 46] = "dot",e[e.doubleQuote = 34] = "doubleQuote",e[e.equals = 61] = "equals",e[e.exclamation = 33] = "exclamation",e[e.greaterThan = 62] = "greaterThan",e[e.lessThan = 60] = "lessThan",e[e.minus = 45] = "minus",e[e.openBrace = 123] = "openBrace",e[e.openBracket = 91] = "openBracket",e[e.openParen = 40] = "openParen",e[e.percent = 37] = "percent",e[e.plus = 43] = "plus",e[e.question = 63] = "question",e[e.semicolon = 59] = "semicolon",e[e.singleQuote = 39] = "singleQuote",e[e.slash = 47] = "slash",e[e.tilde = 126] = "tilde",e[e.backspace = 8] = "backspace",e[e.formFeed = 12] = "formFeed",e[e.byteOrderMark = 65279] = "byteOrderMark",e[e.tab = 9] = "tab",e[e.verticalTab = 11] = "verticalTab"
    }(p || (p = {})), t.stripComments = c, t.parse = u
}), define("vs/nls!vs/base/common/severity", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/base/common/severity", t)
}), define("vs/base/common/severity", ["require", "exports", "vs/nls!vs/base/common/severity", "vs/base/common/strings"], function (e, t, n, r) {
    "use strict";
    var o;
    !function (e) {
        e[e.Ignore = 0] = "Ignore", e[e.Info = 1] = "Info", e[e.Warning = 2] = "Warning", e[e.Error = 3] = "Error"
    }(o || (o = {}));
    var o;
    !function (e) {
        function t(t) {
            return t ? r.equalsIgnoreCase(s, t) ? e.Error : r.equalsIgnoreCase(a, t) || r.equalsIgnoreCase(c, t) ? e.Warning : r.equalsIgnoreCase(u, t) ? e.Info : e.Ignore : e.Ignore
        }

        function o(e) {
            return l[e] || r.empty
        }

        function i(e, t) {
            return t - e
        }

        var s = "error", a = "warning", c = "warn", u = "info", l = Object.create(null);
        l[e.Error] = n.localize(0, null), l[e.Warning] = n.localize(1, null), l[e.Info] = n.localize(2, null), e.fromValue = t, e.toString = o, e.compare = i
    }(o || (o = {})), Object.defineProperty(t, "__esModule", {value: !0}), t["default"] = o
}), define("vs/nls!vs/base/node/zip", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/base/node/zip", t)
}), define("vs/nls!vs/platform/configuration/common/configurationRegistry", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/platform/configuration/common/configurationRegistry", t)
}), define("vs/nls!vs/platform/extensions/common/extensionsRegistry", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/platform/extensions/common/extensionsRegistry", t)
}), define("vs/nls!vs/platform/extensions/node/extensionValidator", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/platform/extensions/node/extensionValidator", t)
}), define("vs/nls!vs/platform/jsonschemas/common/jsonContributionRegistry", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/platform/jsonschemas/common/jsonContributionRegistry", t)
}), define("vs/nls!vs/workbench/parts/extensions/common/extensions", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/workbench/parts/extensions/common/extensions", t)
}), define("vs/nls!vs/workbench/parts/extensions/node/extensionsService", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/workbench/parts/extensions/node/extensionsService", t)
}), define("vs/nls!vs/workbench/services/request/node/requestService", ["vs/nls", "vs/nls!vs/workbench/electron-main/sharedProcessMain"], function (e, t) {
    return e.create("vs/workbench/services/request/node/requestService", t)
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/platform/instantiation/common/descriptors", ["require", "exports", "vs/base/common/errors"], function (e, t, n) {
    "use strict";
    var r = function () {
        function e(e) {
            this._staticArguments = e
        }

        return e.prototype.appendStaticArguments = function (e) {
            this._staticArguments.push.apply(this._staticArguments, e)
        }, e.prototype.staticArguments = function (e) {
            return isNaN(e) ? this._staticArguments.slice(0) : this._staticArguments[e]
        }, e.prototype._validate = function (e) {
            if (!e)throw n.illegalArgument("can not be falsy")
        }, e
    }();
    t.AbstractDescriptor = r;
    var o = function (e) {
        function t(t) {
            for (var n = [], r = 1; r < arguments.length; r++)n[r - 1] = arguments[r];
            e.call(this, n), this._ctor = t
        }

        return __extends(t, e), Object.defineProperty(t.prototype, "ctor", {
            get: function () {
                return this._ctor
            }, enumerable: !0, configurable: !0
        }), t.prototype.equals = function (e) {
            return e === this ? !0 : e instanceof t ? e.ctor === this.ctor : !1
        }, t.prototype.bind = function () {
            for (var e = [], n = 0; n < arguments.length; n++)e[n - 0] = arguments[n];
            var r = [];
            return r = r.concat(this.staticArguments()), r = r.concat(e), new (t.bind.apply(t, [void 0].concat([this._ctor], r)))
        }, t
    }(r);
    t.SyncDescriptor = o, t.createSyncDescriptor = function (e) {
        for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
        return new (o.bind.apply(o, [void 0].concat([e], t)))
    };
    var i = function (e) {
        function t(t, n) {
            for (var r = [], o = 2; o < arguments.length; o++)r[o - 2] = arguments[o];
            if (e.call(this, r), this._moduleName = t, this._ctorName = n, "string" != typeof t)throw new Error("Invalid AsyncDescriptor arguments, expected `moduleName` to be a string!")
        }

        return __extends(t, e), t.create = function (e, n) {
            return new t(e, n)
        }, Object.defineProperty(t.prototype, "moduleName", {
            get: function () {
                return this._moduleName
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(t.prototype, "ctorName", {
            get: function () {
                return this._ctorName
            }, enumerable: !0, configurable: !0
        }), t.prototype.equals = function (e) {
            return e === this ? !0 : e instanceof t ? e.moduleName === this.moduleName && e.ctorName === this.ctorName : !1
        }, t.prototype.bind = function () {
            for (var e = [], n = 0; n < arguments.length; n++)e[n - 0] = arguments[n];
            var r = [];
            return r = r.concat(this.staticArguments()), r = r.concat(e), new (t.bind.apply(t, [void 0].concat([this.moduleName, this.ctorName], r)))
        }, t
    }(r);
    t.AsyncDescriptor = i;
    var s = function (e, t) {
        for (var n = [], r = 2; r < arguments.length; r++)n[r - 2] = arguments[r];
        return new (i.bind.apply(i, [void 0].concat([e, t], n)))
    };
    t.createAsyncDescriptor0 = s, t.createAsyncDescriptor1 = s, t.createAsyncDescriptor2 = s, t.createAsyncDescriptor3 = s, t.createAsyncDescriptor4 = s, t.createAsyncDescriptor5 = s, t.createAsyncDescriptor6 = s, t.createAsyncDescriptor7 = s
}), define("vs/platform/instantiation/common/instantiation", ["require", "exports"], function (e, t) {
    "use strict";
    function n(e) {
        var t = function (t, n, o) {
            if (3 !== arguments.length)throw new Error("@IServiceName-decorator can only be used to decorate a parameter");
            t[r.DI_TARGET] === t ? t[r.DI_DEPENDENCIES].push({
                serviceId: e,
                index: o
            }) : (t[r.DI_DEPENDENCIES] = [{serviceId: e, index: o}], t[r.DI_TARGET] = t)
        };
        return t[r.DI_PROVIDES] = e, t
    }

    var r;
    !function (e) {
        function t(t) {
            return t[e.DI_PROVIDES]
        }

        function n(t) {
            return t[e.DI_DEPENDENCIES]
        }

        e.DI_TARGET = "$di$target", e.DI_DEPENDENCIES = "$di$dependencies", e.DI_PROVIDES = "$di$provides_service", e.getServiceId = t, e.getServiceDependencies = n
    }(r = t._util || (t._util = {})), t.IInstantiationService = n("instantiationService"), t.createDecorator = n
}), define("vs/platform/configuration/common/configuration", ["require", "exports", "vs/platform/instantiation/common/instantiation"], function (e, t, n) {
    "use strict";
    function r(e, t) {
        function n(e, t) {
            for (var n = e, r = 0; r < t.length; r++)if (n = n[t[r]], !n)return;
            return n
        }

        var r = t.split(".");
        return n(e, r)
    }

    t.IConfigurationService = n.createDecorator("configurationService");
    var o = function () {
        function e() {
        }

        return e.UPDATED = "update", e
    }();
    t.ConfigurationServiceEventTypes = o, t.extractSetting = r
}), define("vs/platform/event/common/event", ["require", "exports", "vs/platform/instantiation/common/instantiation"], function (e, t, n) {
    "use strict";
    t.IEventService = n.createDecorator("eventService")
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/platform/event/common/eventService", ["require", "exports", "vs/base/common/eventEmitter", "./event"], function (e, t, n, r) {
    "use strict";
    var o = function (e) {
        function t() {
            e.call(this), this.serviceId = r.IEventService
        }

        return __extends(t, e), t
    }(n.EventEmitter);
    t.EventService = o
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/platform/files/common/files", ["require", "exports", "vs/base/common/paths", "vs/base/common/events", "vs/platform/instantiation/common/instantiation"], function (e, t, n, r, o) {
    "use strict";
    t.IFileService = o.createDecorator("fileService"), function (e) {
        e[e.UPDATED = 0] = "UPDATED", e[e.ADDED = 1] = "ADDED", e[e.DELETED = 2] = "DELETED"
    }(t.FileChangeType || (t.FileChangeType = {}));
    var i = t.FileChangeType;
    t.EventType = {FILE_CHANGES: "files:fileChanges"};
    var s = function (e) {
        function t(t) {
            e.call(this), this._changes = t
        }

        return __extends(t, e), Object.defineProperty(t.prototype, "changes", {
            get: function () {
                return this._changes
            }, enumerable: !0, configurable: !0
        }), t.prototype.contains = function (e, t) {
            return e ? this.containsAny([e], t) : !1
        }, t.prototype.containsAny = function (e, t) {
            return e && e.length ? this._changes.some(function (r) {
                return r.type !== t ? !1 : t === i.DELETED ? e.some(function (e) {
                    return e ? n.isEqualOrParent(e.fsPath, r.resource.fsPath) : !1
                }) : e.some(function (e) {
                    return e ? e.fsPath === r.resource.fsPath : !1
                })
            }) : !1
        }, t.prototype.getAdded = function () {
            return this.getOfType(i.ADDED)
        }, t.prototype.gotAdded = function () {
            return this.hasType(i.ADDED)
        }, t.prototype.getDeleted = function () {
            return this.getOfType(i.DELETED)
        }, t.prototype.gotDeleted = function () {
            return this.hasType(i.DELETED)
        }, t.prototype.getUpdated = function () {
            return this.getOfType(i.UPDATED)
        }, t.prototype.gotUpdated = function () {
            return this.hasType(i.UPDATED)
        }, t.prototype.getOfType = function (e) {
            return this._changes.filter(function (t) {
                return t.type === e
            })
        }, t.prototype.hasType = function (e) {
            return this._changes.some(function (t) {
                return t.type === e
            })
        }, t
    }(r.Event);
    t.FileChangesEvent = s, function (e) {
        e[e.FILE_IS_BINARY = 0] = "FILE_IS_BINARY", e[e.FILE_IS_DIRECTORY = 1] = "FILE_IS_DIRECTORY", e[e.FILE_NOT_FOUND = 2] = "FILE_NOT_FOUND", e[e.FILE_NOT_MODIFIED_SINCE = 3] = "FILE_NOT_MODIFIED_SINCE", e[e.FILE_MODIFIED_SINCE = 4] = "FILE_MODIFIED_SINCE", e[e.FILE_MOVE_CONFLICT = 5] = "FILE_MOVE_CONFLICT", e[e.FILE_READ_ONLY = 6] = "FILE_READ_ONLY", e[e.FILE_TOO_LARGE = 7] = "FILE_TOO_LARGE"
    }(t.FileOperationResult || (t.FileOperationResult = {}));
    t.FileOperationResult;
    t.MAX_FILE_SIZE = 52428800, t.AutoSaveConfiguration = {
        OFF: "off",
        AFTER_DELAY: "afterDelay",
        ON_FOCUS_CHANGE: "onFocusChange"
    }, t.SUPPORTED_ENCODINGS = {
        utf8: {labelLong: "UTF-8", labelShort: "UTF-8", order: 1, alias: "utf8bom"},
        utf8bom: {labelLong: "UTF-8 with BOM", labelShort: "UTF-8 with BOM", encodeOnly: !0, order: 2, alias: "utf8"},
        utf16le: {labelLong: "UTF-16 LE", labelShort: "UTF-16 LE", order: 3},
        utf16be: {labelLong: "UTF-16 BE", labelShort: "UTF-16 BE", order: 4},
        windows1252: {labelLong: "Western (Windows 1252)", labelShort: "Windows 1252", order: 5},
        iso88591: {labelLong: "Western (ISO 8859-1)", labelShort: "ISO 8859-1", order: 6},
        iso88593: {labelLong: "Western (ISO 8859-3)", labelShort: "ISO 8859-3", order: 7},
        iso885915: {labelLong: "Western (ISO 8859-15)", labelShort: "ISO 8859-15", order: 8},
        macroman: {labelLong: "Western (Mac Roman)", labelShort: "Mac Roman", order: 9},
        cp437: {labelLong: "DOS (CP 437)", labelShort: "CP437", order: 10},
        windows1256: {labelLong: "Arabic (Windows 1256)", labelShort: "Windows 1256", order: 11},
        iso88596: {labelLong: "Arabic (ISO 8859-6)", labelShort: "ISO 8859-6", order: 12},
        windows1257: {labelLong: "Baltic (Windows 1257)", labelShort: "Windows 1257", order: 13},
        iso88594: {labelLong: "Baltic (ISO 8859-4)", labelShort: "ISO 8859-4", order: 14},
        iso885914: {labelLong: "Celtic (ISO 8859-14)", labelShort: "ISO 8859-14", order: 15},
        windows1250: {labelLong: "Central European (Windows 1250)", labelShort: "Windows 1250", order: 16},
        iso88592: {labelLong: "Central European (ISO 8859-2)", labelShort: "ISO 8859-2", order: 17},
        windows1251: {labelLong: "Cyrillic (Windows 1251)", labelShort: "Windows 1251", order: 18},
        cp866: {labelLong: "Cyrillic (CP 866)", labelShort: "CP 866", order: 19},
        iso88595: {labelLong: "Cyrillic (ISO 8859-5)", labelShort: "ISO 8859-5", order: 20},
        koi8r: {labelLong: "Cyrillic (KOI8-R)", labelShort: "KOI8-R", order: 21},
        koi8u: {labelLong: "Cyrillic (KOI8-U)", labelShort: "KOI8-U", order: 22},
        iso885913: {labelLong: "Estonian (ISO 8859-13)", labelShort: "ISO 8859-13", order: 23},
        windows1253: {labelLong: "Greek (Windows 1253)", labelShort: "Windows 1253", order: 24},
        iso88597: {labelLong: "Greek (ISO 8859-7)", labelShort: "ISO 8859-7", order: 25},
        windows1255: {labelLong: "Hebrew (Windows 1255)", labelShort: "Windows 1255", order: 26},
        iso88598: {labelLong: "Hebrew (ISO 8859-8)", labelShort: "ISO 8859-8", order: 27},
        iso885910: {labelLong: "Nordic (ISO 8859-10)", labelShort: "ISO 8859-10", order: 28},
        iso885916: {labelLong: "Romanian (ISO 8859-16)", labelShort: "ISO 8859-16", order: 29},
        windows1254: {labelLong: "Turkish (Windows 1254)", labelShort: "Windows 1254", order: 30},
        iso88599: {labelLong: "Turkish (ISO 8859-9)", labelShort: "ISO 8859-9", order: 31},
        windows1258: {labelLong: "Vietnamese (Windows 1258)", labelShort: "Windows 1258", order: 32},
        gbk: {labelLong: "Chinese (GBK)", labelShort: "GBK", order: 33},
        gb18030: {labelLong: "Chinese (GB18030)", labelShort: "GB18030", order: 34},
        cp950: {labelLong: "Traditional Chinese (Big5)", labelShort: "Big5", order: 35},
        big5hkscs: {labelLong: "Traditional Chinese (Big5-HKSCS)", labelShort: "Big5-HKSCS", order: 36},
        shiftjis: {labelLong: "Japanese (Shift JIS)", labelShort: "Shift JIS", order: 37},
        eucjp: {labelLong: "Japanese (EUC-JP)", labelShort: "EUC-JP", order: 38},
        euckr: {labelLong: "Korean (EUC-KR)", labelShort: "EUC-KR", order: 39},
        windows874: {labelLong: "Thai (Windows 874)", labelShort: "Windows 874", order: 40},
        iso885911: {labelLong: "Latin/Thai (ISO 8859-11)", labelShort: "ISO 8859-11", order: 41},
        "koi8-ru": {labelLong: "Cyrillic (KOI8-RU)", labelShort: "KOI8-RU", order: 42},
        "koi8-t": {labelLong: "Tajik (KOI8-T)", labelShort: "KOI8-T", order: 43},
        GB2312: {labelLong: "Simplified Chinese (GB 2312)", labelShort: "GB 2312", order: 44}
    }
}), define("vs/platform/instantiation/common/instantiationService", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/errors", "vs/base/common/strings", "vs/base/common/types", "vs/base/common/collections", "./descriptors", "vs/base/common/graph", "./instantiation"], function (e, t, n, r, o, i, s, a, c, u) {
    "use strict";
    function l(e) {
        void 0 === e && (e = Object.create(null));
        var t = new d(e, new p);
        return t
    }

    var f = u.IInstantiationService;
    t.createInstantiationService = l;
    var p = function () {
        function e() {
            this._value = 0
        }

        return Object.defineProperty(e.prototype, "locked", {
            get: function () {
                return 0 === this._value
            }, enumerable: !0, configurable: !0
        }), e.prototype.runUnlocked = function (e) {
            this._value++;
            try {
                return e()
            } finally {
                this._value--
            }
        }, e
    }(), h = function () {
        function e(e, t) {
            var n = this;
            this._services = e, this._lock = t, s.forEach(this._services, function (e) {
                n.registerService(e.key, e.value)
            })
        }

        return e.prototype.registerService = function (e, t) {
            var n = this;
            Object.defineProperty(this, e, {
                get: function () {
                    if (n._lock.locked)throw r.illegalState("the services map can only be used during construction");
                    if (!t)throw r.illegalArgument(o.format("service with '{0}' not found", e));
                    if (t instanceof a.SyncDescriptor) {
                        var i = n._services[e];
                        i instanceof a.SyncDescriptor ? (n._ensureInstances(e, t), t = n._services[e]) : t = i
                    }
                    return t
                }, set: function (e) {
                    throw r.illegalState("services cannot be changed")
                }, configurable: !1, enumerable: !1
            }), this._services[e] = t
        }, Object.defineProperty(e.prototype, "lock", {
            get: function () {
                return this._lock
            }, enumerable: !0, configurable: !0
        }), Object.defineProperty(e.prototype, "services", {
            get: function () {
                return this._services
            }, enumerable: !0, configurable: !0
        }), e.prototype._ensureInstances = function (e, t) {
            for (var n = Object.create(null), r = new c.Graph(function (e) {
                return e.serviceId
            }), o = [{serviceId: e, desc: t}]; o.length;) {
                var i = o.pop();
                if (r.lookupOrInsertNode(i), n[i.serviceId])throw new Error("[createInstance] cyclic dependency: " + Object.keys(n).join(">>"));
                n[i.serviceId] = !0;
                var s = u._util.getServiceDependencies(i.desc.ctor);
                if (Array.isArray(s))for (var l = 0, f = s; l < f.length; l++) {
                    var p = f[l], h = this.services[p.serviceId];
                    if (!h)throw new Error("[createInstance] " + e + " depends on " + p.serviceId + " which is NOT registered.");
                    if (h instanceof a.SyncDescriptor) {
                        var d = {serviceId: p.serviceId, desc: h};
                        o.push(d), r.insertEdge(i, d)
                    }
                }
            }
            for (; ;) {
                var m = r.roots();
                if (0 === m.length) {
                    if (0 !== r.length)throw new Error("[createInstance] cyclinc dependency!");
                    break
                }
                for (var v = 0, g = m; v < g.length; v++) {
                    var y = g[v], _ = this.createInstance(y.data.desc, []);
                    this._services[y.data.serviceId] = _, r.removeNode(y.data)
                }
            }
        }, e.prototype.invokeFunction = function (e, t) {
            var n = this;
            return this._lock.runUnlocked(function () {
                var r = {
                    get: function (e) {
                        var t = u._util.getServiceId(e);
                        return n[t]
                    }
                };
                return e.apply(void 0, [r].concat(t))
            })
        }, e.prototype.createInstance = function (e, t) {
            var n = this, r = [], o = u._util.getServiceDependencies(e.ctor) || [], s = e.staticArguments().concat(t), a = s.length, c = Number.MAX_VALUE;
            o.forEach(function (e) {
                var t = e.serviceId, o = e.index, i = n._lock.runUnlocked(function () {
                    return n[t]
                });
                r[o] = i, c = Math.min(c, e.index)
            });
            for (var l = 0, f = 0, p = s; f < p.length; f++) {
                var h = p[f], d = void 0 !== r[l];
                d || (r[l] = h), l += 1
            }
            if (r.unshift(e.ctor), c !== Number.MAX_VALUE && c !== a) {
                var m = "[createInstance] constructor '" + e.ctor.name + "' has first" + (" service dependency at position " + (c + 1) + " but is called with") + (" " + (a - 1) + " static arguments that are expected to come first");
                console.warn(m)
            }
            return this._lock.runUnlocked(function () {
                var t = i.create.apply(null, r);
                return e._validate(t), t
            })
        }, e
    }(), d = function () {
        function t(e, t) {
            this.serviceId = f, e.instantiationService = this, this._servicesMap = new h(e, t)
        }

        return t.prototype.createChild = function (e) {
            var n = {};
            return s.forEach(this._servicesMap.services, function (e) {
                n[e.key] = e.value
            }), s.forEach(e, function (e) {
                n[e.key] = e.value
            }), new t(n, this._servicesMap.lock)
        }, t.prototype.registerService = function (e, t) {
            this._servicesMap.registerService(e, t)
        }, t.prototype.addSingleton = function (e, t) {
            var n = u._util.getServiceId(e);
            this._servicesMap.registerService(n, t)
        }, t.prototype.getInstance = function (e) {
            var t = this, n = u._util.getServiceId(e), r = this._servicesMap.lock.runUnlocked(function () {
                return t._servicesMap[n]
            });
            return r
        }, t.prototype.createInstance = function (e) {
            for (var t = new Array(arguments.length - 1), n = 1, r = arguments.length; r > n; n++)t[n - 1] = arguments[n];
            return e instanceof a.SyncDescriptor ? this._servicesMap.createInstance(e, t) : e instanceof a.AsyncDescriptor ? this._createInstanceAsync(e, t) : this._servicesMap.createInstance(new a.SyncDescriptor(e), t)
        }, t.prototype._createInstanceAsync = function (t, o) {
            var i, s = this;
            return new n.TPromise(function (n, c, u) {
                e([t.moduleName], function (e) {
                    if (i && c(i), !e)return c(r.illegalArgument("module not found: " + t.moduleName));
                    var u;
                    if (u = t.ctorName ? e[t.ctorName] : e, "function" != typeof u)return c(r.illegalArgument("not a function: " + t.ctorName || t.moduleName));
                    try {
                        o.unshift.apply(o, t.staticArguments()), n(s._servicesMap.createInstance(new a.SyncDescriptor(u), o))
                    } catch (l) {
                        return c(l)
                    }
                }, c)
            }, function () {
                i = r.canceled()
            })
        }, t.prototype.invokeFunction = function (e) {
            for (var t = [], n = 1; n < arguments.length; n++)t[n - 1] = arguments[n];
            return this._servicesMap.invokeFunction(e, t)
        }, t
    }()
}), define("vs/platform/platform", ["require", "exports", "vs/base/common/types", "vs/base/common/assert"], function (e, t, n, r) {
    "use strict";
    var o = function () {
        function e() {
            this.data = {}
        }

        return e.prototype.add = function (e, t) {
            r.ok(n.isString(e)), r.ok(n.isObject(t)), r.ok(!this.data.hasOwnProperty(e), "There is already an extension with this id"), this.data[e] = t
        }, e.prototype.knows = function (e) {
            return this.data.hasOwnProperty(e)
        }, e.prototype.as = function (e) {
            return this.data[e] || null
        }, e
    }();
    t.Registry = new o;
    var i = function () {
        function e() {
            this.toBeInstantiated = [], this.instances = []
        }

        return e.prototype.setInstantiationService = function (e) {
            for (this.instantiationService = e; this.toBeInstantiated.length > 0;) {
                var t = this.toBeInstantiated.shift();
                this.instantiate(t)
            }
        }, e.prototype.instantiate = function (e) {
            var t = this.instantiationService.createInstance(e);
            this.instances.push(t)
        }, e.prototype._register = function (e) {
            this.instantiationService ? this.instantiate(e) : this.toBeInstantiated.push(e)
        }, e.prototype._getInstances = function () {
            return this.instances.slice(0)
        }, e.prototype._setInstances = function (e) {
            this.instances = e
        }, e
    }();
    t.BaseRegistry = i
}), define("vs/platform/jsonschemas/common/jsonContributionRegistry", ["require", "exports", "vs/nls!vs/platform/jsonschemas/common/jsonContributionRegistry", "vs/platform/platform", "vs/base/common/eventEmitter"], function (e, t, n, r, o) {
    "use strict";
    function i(e) {
        return e.length > 0 && "#" === e.charAt(e.length - 1) ? e.substring(0, e.length - 1) : e
    }

    t.Extensions = {JSONContribution: "base.contributions.json"};
    var s = function () {
        function e() {
            this.schemasById = {}, this.schemaAssociations = {}, this.eventEmitter = new o.EventEmitter
        }

        return e.prototype.addRegistryChangedListener = function (e) {
            return this.eventEmitter.addListener2("registryChanged", e)
        }, e.prototype.registerSchema = function (e, t) {
            this.schemasById[i(e)] = t, this.eventEmitter.emit("registryChanged", {})
        }, e.prototype.addSchemaFileAssociation = function (e, t) {
            var n = this.schemaAssociations[e];
            n || (n = [], this.schemaAssociations[e] = n), n.push(t), this.eventEmitter.emit("registryChanged", {})
        }, e.prototype.getSchemaContributions = function () {
            return {schemas: this.schemasById, schemaAssociations: this.schemaAssociations}
        }, e
    }(), a = new s;
    r.Registry.add(t.Extensions.JSONContribution, a), a.registerSchema("http://json-schema.org/draft-04/schema#", {
        id: "http://json-schema.org/draft-04/schema#",
        title: n.localize(0, null),
        $schema: "http://json-schema.org/draft-04/schema#",
        definitions: {
            schemaArray: {type: "array", minItems: 1, items: {$ref: "#"}},
            positiveInteger: {type: "integer", minimum: 0},
            positiveIntegerDefault0: {allOf: [{$ref: "#/definitions/positiveInteger"}, {"default": 0}]},
            simpleTypes: {
                type: "string",
                "enum": ["array", "boolean", "integer", "null", "number", "object", "string"]
            },
            stringArray: {type: "array", items: {type: "string"}, minItems: 1, uniqueItems: !0}
        },
        type: "object",
        properties: {
            id: {type: "string", format: "uri", description: n.localize(1, null)},
            $schema: {type: "string", format: "uri", description: n.localize(2, null)},
            title: {type: "string", description: n.localize(3, null)},
            description: {type: "string", description: n.localize(4, null)},
            "default": {description: n.localize(5, null)},
            multipleOf: {type: "number", minimum: 0, exclusiveMinimum: !0, description: n.localize(6, null)},
            maximum: {type: "number", description: n.localize(7, null)},
            exclusiveMaximum: {type: "boolean", "default": !1, description: n.localize(8, null)},
            minimum: {type: "number", description: n.localize(9, null)},
            exclusiveMinimum: {type: "boolean", "default": !1, description: n.localize(10, null)},
            maxLength: {allOf: [{$ref: "#/definitions/positiveInteger"}], description: n.localize(11, null)},
            minLength: {allOf: [{$ref: "#/definitions/positiveIntegerDefault0"}], description: n.localize(12, null)},
            pattern: {type: "string", format: "regex", description: n.localize(13, null)},
            additionalItems: {
                anyOf: [{type: "boolean"}, {$ref: "#"}],
                "default": {},
                description: n.localize(14, null)
            },
            items: {
                anyOf: [{$ref: "#"}, {$ref: "#/definitions/schemaArray"}],
                "default": {},
                description: n.localize(15, null)
            },
            maxItems: {allOf: [{$ref: "#/definitions/positiveInteger"}], description: n.localize(16, null)},
            minItems: {allOf: [{$ref: "#/definitions/positiveIntegerDefault0"}], description: n.localize(17, null)},
            uniqueItems: {type: "boolean", "default": !1, description: n.localize(18, null)},
            maxProperties: {allOf: [{$ref: "#/definitions/positiveInteger"}], description: n.localize(19, null)},
            minProperties: {
                allOf: [{$ref: "#/definitions/positiveIntegerDefault0"}],
                description: n.localize(20, null)
            },
            required: {allOf: [{$ref: "#/definitions/stringArray"}], description: n.localize(21, null)},
            additionalProperties: {
                anyOf: [{type: "boolean"}, {$ref: "#"}],
                "default": {},
                description: n.localize(22, null)
            },
            definitions: {
                type: "object",
                additionalProperties: {$ref: "#"},
                "default": {},
                description: n.localize(23, null)
            },
            properties: {
                type: "object",
                additionalProperties: {$ref: "#"},
                "default": {},
                description: n.localize(24, null)
            },
            patternProperties: {
                type: "object",
                additionalProperties: {$ref: "#"},
                "default": {},
                description: n.localize(25, null)
            },
            dependencies: {
                type: "object",
                additionalProperties: {anyOf: [{$ref: "#"}, {$ref: "#/definitions/stringArray"}]},
                description: n.localize(26, null)
            },
            "enum": {type: "array", minItems: 1, uniqueItems: !0, description: n.localize(27, null)},
            type: {
                anyOf: [{$ref: "#/definitions/simpleTypes"}, {
                    type: "array",
                    items: {$ref: "#/definitions/simpleTypes"},
                    minItems: 1,
                    uniqueItems: !0
                }], description: n.localize(28, null)
            },
            format: {
                anyOf: [{
                    type: "string",
                    description: n.localize(29, null),
                    "enum": ["date-time", "uri", "email", "hostname", "ipv4", "ipv6", "regex"]
                }, {type: "string"}]
            },
            allOf: {allOf: [{$ref: "#/definitions/schemaArray"}], description: n.localize(30, null)},
            anyOf: {allOf: [{$ref: "#/definitions/schemaArray"}], description: n.localize(31, null)},
            oneOf: {allOf: [{$ref: "#/definitions/schemaArray"}], description: n.localize(32, null)},
            not: {allOf: [{$ref: "#"}], description: n.localize(33, null)}
        },
        dependencies: {exclusiveMaximum: ["maximum"], exclusiveMinimum: ["minimum"]},
        "default": {}
    })
}), define("vs/platform/extensions/common/extensionsRegistry", ["require", "exports", "vs/nls!vs/platform/extensions/common/extensionsRegistry", "vs/base/common/errors", "vs/base/common/paths", "vs/base/common/severity", "vs/platform/jsonschemas/common/jsonContributionRegistry", "vs/platform/platform"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    function c(e, t, r) {
        if (!t)return r.push(n.localize(0, null)), !1;
        if ("string" != typeof t.publisher)return r.push(n.localize(1, null, "publisher")), !1;
        if ("string" != typeof t.name)return r.push(n.localize(2, null, "name")), !1;
        if ("string" != typeof t.version)return r.push(n.localize(3, null, "version")), !1;
        if (!t.engines)return r.push(n.localize(4, null, "engines")), !1;
        if ("string" != typeof t.engines.vscode)return r.push(n.localize(5, null, "engines.vscode")), !1;
        if ("undefined" != typeof t.extensionDependencies && !u(t.extensionDependencies))return r.push(n.localize(6, null, "extensionDependencies")), !1;
        if ("undefined" != typeof t.activationEvents) {
            if (!u(t.activationEvents))return r.push(n.localize(7, null, "activationEvents")), !1;
            if ("undefined" == typeof t.main)return r.push(n.localize(8, null, "activationEvents", "main")), !1
        }
        if ("undefined" != typeof t.main) {
            if ("string" != typeof t.main)return r.push(n.localize(9, null, "main")), !1;
            var i = o.normalize(o.join(e, t.main));
            if (i.indexOf(e) && r.push(n.localize(10, null, i, e)), "undefined" == typeof t.activationEvents)return r.push(n.localize(11, null, "activationEvents", "main")), !1
        }
        return !0
    }

    function u(e) {
        if (!Array.isArray(e))return !1;
        for (var t = 0, n = e.length; n > t; t++)if ("string" != typeof e[t])return !1;
        return !0
    }

    var l = function () {
        function e(e, t) {
            this._messageHandler = e, this._source = t
        }

        return e.prototype._msg = function (e, t) {
            this._messageHandler({type: e, message: t, source: this._source})
        }, e.prototype.error = function (e) {
            this._msg(i["default"].Error, e)
        }, e.prototype.warn = function (e) {
            this._msg(i["default"].Warning, e)
        }, e.prototype.info = function (e) {
            this._msg(i["default"].Info, e)
        }, e
    }();
    t.isValidExtensionDescription = c;
    var f = Object.hasOwnProperty, p = a.Registry.as(s.Extensions.JSONContribution), h = function () {
        function e(e, t) {
            this.name = e, this._registry = t, this._handler = null, this._messageHandler = null
        }

        return e.prototype.setHandler = function (e) {
            if (this._handler)throw new Error("Handler already set!");
            this._handler = e, this._handle()
        }, e.prototype.handle = function (e) {
            this._messageHandler = e, this._handle()
        }, e.prototype._handle = function () {
            var e = this;
            this._handler && this._messageHandler && this._registry.registerPointListener(this.name, function (t) {
                var n = t.map(function (t) {
                    return {
                        description: t,
                        value: t.contributes[e.name],
                        collector: new l(e._messageHandler, t.extensionFolderPath)
                    }
                });
                e._handler(n)
            })
        }, e
    }(), d = "vscode://schemas/vscode-extensions", m = {
        "default": {
            name: "{{name}}",
            description: "{{description}}",
            author: "{{author}}",
            version: "{{1.0.0}}",
            main: "{{pathToMain}}",
            dependencies: {}
        },
        properties: {
            displayName: {description: n.localize(12, null), type: "string"},
            categories: {
                description: n.localize(13, null),
                type: "array",
                items: {type: "string", "enum": ["Languages", "Snippets", "Linters", "Themes", "Debuggers", "Other"]}
            },
            galleryBanner: {
                type: "object",
                description: n.localize(14, null),
                properties: {
                    color: {description: n.localize(15, null), type: "string"},
                    theme: {description: n.localize(16, null), type: "string", "enum": ["dark", "light"]}
                }
            },
            publisher: {description: n.localize(17, null), type: "string"},
            activationEvents: {description: n.localize(18, null), type: "array", items: {type: "string"}},
            extensionDependencies: {description: n.localize(19, null), type: "array", items: {type: "string"}},
            scripts: {
                type: "object",
                properties: {"vscode:prepublish": {description: n.localize(20, null), type: "string"}}
            },
            contributes: {description: n.localize(21, null), type: "object", properties: {}, "default": {}}
        }
    }, v = function () {
        function e() {
            this._extensionsMap = {}, this._extensionsArr = [], this._activationMap = {}, this._pointListeners = [], this._extensionPoints = {}, this._oneTimeActivationEventListeners = {}
        }

        return e.prototype.registerPointListener = function (t, n) {
            var r = {extensionPoint: t, listener: n};
            this._pointListeners.push(r), this._triggerPointListener(r, e._filterWithExtPoint(this.getAllExtensionDescriptions(), t))
        }, e.prototype.registerExtensionPoint = function (e, t) {
            if (f.call(this._extensionPoints, e))throw new Error("Duplicate extension point: " + e);
            var n = new h(e, this);
            return this._extensionPoints[e] = n,
                m.properties.contributes.properties[e] = t, p.registerSchema(d, m), n
        }, e.prototype.handleExtensionPoints = function (e) {
            var t = this;
            Object.keys(this._extensionPoints).forEach(function (n) {
                t._extensionPoints[n].handle(e)
            })
        }, e.prototype._triggerPointListener = function (e, t) {
            if (t && 0 !== t.length)try {
                e.listener(t)
            } catch (n) {
                r.onUnexpectedError(n)
            }
        }, e.prototype.registerExtensions = function (t) {
            for (var n = 0, r = t.length; r > n; n++) {
                var o = t[n];
                if (f.call(this._extensionsMap, o.id))console.error("Extension `" + o.id + "` is already registered"); else if (this._extensionsMap[o.id] = o, this._extensionsArr.push(o), Array.isArray(o.activationEvents))for (var i = 0, s = o.activationEvents.length; s > i; i++) {
                    var a = o.activationEvents[i];
                    this._activationMap[a] = this._activationMap[a] || [], this._activationMap[a].push(o)
                }
            }
            for (var n = 0, r = this._pointListeners.length; r > n; n++) {
                var c = this._pointListeners[n], u = e._filterWithExtPoint(t, c.extensionPoint);
                this._triggerPointListener(c, u)
            }
        }, e._filterWithExtPoint = function (e, t) {
            return e.filter(function (e) {
                return e.contributes && f.call(e.contributes, t)
            })
        }, e.prototype.getExtensionDescriptionsForActivationEvent = function (e) {
            return f.call(this._activationMap, e) ? this._activationMap[e].slice(0) : []
        }, e.prototype.getAllExtensionDescriptions = function () {
            return this._extensionsArr.slice(0)
        }, e.prototype.getExtensionDescription = function (e) {
            return f.call(this._extensionsMap, e) ? this._extensionsMap[e] : null
        }, e.prototype.registerOneTimeActivationEventListener = function (e, t) {
            f.call(this._oneTimeActivationEventListeners, e) || (this._oneTimeActivationEventListeners[e] = []), this._oneTimeActivationEventListeners[e].push(t)
        }, e.prototype.triggerActivationEventListeners = function (e) {
            if (f.call(this._oneTimeActivationEventListeners, e)) {
                var t = this._oneTimeActivationEventListeners[e];
                delete this._oneTimeActivationEventListeners[e];
                for (var n = 0, o = t.length; o > n; n++) {
                    var i = t[n];
                    try {
                        i()
                    } catch (s) {
                        r.onUnexpectedError(s)
                    }
                }
            }
        }, e
    }(), g = {ExtensionsRegistry: "ExtensionsRegistry"};
    a.Registry.add(g.ExtensionsRegistry, new v), t.ExtensionsRegistry = a.Registry.as(g.ExtensionsRegistry), p.registerSchema(d, m), p.addSchemaFileAssociation("/package.json", d)
}), define("vs/platform/configuration/common/configurationRegistry", ["require", "exports", "vs/nls!vs/platform/configuration/common/configurationRegistry", "vs/base/common/event", "vs/platform/platform", "vs/base/common/objects", "vs/platform/extensions/common/extensionsRegistry", "vs/platform/jsonschemas/common/jsonContributionRegistry"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    t.Extensions = {Configuration: "base.contributions.configuration"};
    var c = "vscode://schemas/settings", u = o.Registry.as(a.Extensions.JSONContribution), l = function () {
        function e() {
            this.configurationContributors = [], this.configurationSchema = {allOf: []}, this._onDidRegisterConfiguration = new r.Emitter, u.registerSchema(c, this.configurationSchema), u.addSchemaFileAssociation("vscode://defaultsettings/settings.json", c), u.addSchemaFileAssociation("%APP_SETTINGS_HOME%/settings.json", c), u.addSchemaFileAssociation("/.vscode/settings.json", c)
        }

        return Object.defineProperty(e.prototype, "onDidRegisterConfiguration", {
            get: function () {
                return this._onDidRegisterConfiguration.event
            }, enumerable: !0, configurable: !0
        }), e.prototype.registerConfiguration = function (e) {
            this.configurationContributors.push(e), this.registerJSONConfiguration(e), this._onDidRegisterConfiguration.fire(this)
        }, e.prototype.getConfigurations = function () {
            return this.configurationContributors.slice(0)
        }, e.prototype.registerJSONConfiguration = function (e) {
            var t = i.clone(e);
            this.configurationSchema.allOf.push(t), u.registerSchema(c, this.configurationSchema)
        }, e
    }(), f = new l;
    o.Registry.add(t.Extensions.Configuration, f);
    var p = s.ExtensionsRegistry.registerExtensionPoint("configuration", {
        description: n.localize(0, null),
        type: "object",
        defaultSnippets: [{body: {title: "", properties: {}}}],
        properties: {
            title: {description: n.localize(1, null), type: "string"},
            properties: {
                description: n.localize(2, null),
                type: "object",
                additionalProperties: {$ref: "http://json-schema.org/draft-04/schema#"}
            }
        }
    });
    p.setHandler(function (e) {
        for (var t = 0; t < e.length; t++) {
            var r = e[t].value, o = e[t].collector;
            if (r.type && "object" !== r.type ? o.warn(n.localize(3, null)) : r.type = "object", r.title && "string" != typeof r.title && o.error(n.localize(4, null)), r.properties && "object" != typeof r.properties)return void o.error(n.localize(5, null));
            var s = i.clone(r);
            s.id = e[t].description.id, f.registerConfiguration(s)
        }
    })
}), define("vs/platform/configuration/common/model", ["require", "exports", "vs/base/common/objects", "vs/platform/platform", "vs/base/common/types", "vs/base/common/json", "./configurationRegistry"], function (e, t, n, r, o, i, s) {
    "use strict";
    function a(e, t, n) {
        var r = t.split("."), o = r.pop(), i = e;
        r.forEach(function (e) {
            var n = i[e];
            switch (typeof n) {
                case"undefined":
                    n = i[e] = Object.create(null);
                    break;
                case"object":
                    break;
                default:
                    console.log("Conflicting configuration setting: " + t + " at " + e + " with " + JSON.stringify(n))
            }
            i = n
        }), i[o] = n
    }

    function c(e) {
        try {
            var t = Object.create(null), n = i.parse(e) || {};
            for (var r in n)a(t, r, n[r]);
            return {contents: t}
        } catch (o) {
            return {contents: {}, parseError: o}
        }
    }

    function u(e, t, n) {
        Object.keys(t).forEach(function (r) {
            r in e ? o.isObject(e[r]) && o.isObject(t[r]) ? u(e[r], t[r], n) : n && (e[r] = t[r]) : e[r] = t[r]
        })
    }

    function l(e) {
        var r = Object.create(null), o = [], i = /\/(team\.)?([^\.]*)*\.json/;
        return Object.keys(e).forEach(function (s) {
            var a = n.clone(e[s]), c = i.exec(s);
            if (c) {
                var l = !!c[1], f = r;
                if (c && c[2] && c[2] !== t.CONFIG_DEFAULT_NAME) {
                    var p = c[2], h = f[p];
                    h || (h = Object.create(null), f[p] = h), f = h
                }
                u(f, a.contents, !l), a.parseError && o.push(s)
            }
        }), {contents: r, parseErrors: o}
    }

    function f(e) {
        var t = r.Registry.as(s.Extensions.Configuration).getConfigurations(), n = function (t, r) {
            e(t, r), Array.isArray(t.allOf) && t.allOf.forEach(function (e) {
                n(e, !1)
            })
        };
        t.sort(function (e, t) {
            return "number" != typeof e.order ? 1 : "number" != typeof t.order ? -1 : e.order - t.order
        }).forEach(function (e) {
            n(e, !0)
        })
    }

    function p() {
        var e = Object.create(null), t = function (t, n) {
            t.properties && Object.keys(t.properties).forEach(function (n) {
                var r = t.properties[n], i = r["default"];
                o.isUndefined(r["default"]) && (i = m(r.type)), a(e, n, i)
            })
        };
        return f(t), e
    }

    function h() {
        var e = -1, t = [];
        t.push("{");
        var n = function (n, r) {
            n.title && (r ? (t.push(""), t.push("	//-------- " + n.title + " --------")) : t.push("	// " + n.title), t.push("")), n.properties && Object.keys(n.properties).forEach(function (r) {
                var i = n.properties[r], s = i["default"];
                o.isUndefined(s) && (s = m(i.type)), i.description && t.push("	// " + i.description);
                var a = JSON.stringify(s, null, "	");
                a && "object" == typeof s && (a = d(a)), -1 !== e && (t[e] += ","), e = t.length, t.push("	" + JSON.stringify(r) + ": " + a), t.push("")
            })
        };
        return f(n), t.push("}"), t.join("\n")
    }

    function d(e) {
        return e.split("\n").join("\n	")
    }

    function m(e) {
        var t = Array.isArray(e) ? e[0] : e;
        switch (t) {
            case"boolean":
                return !1;
            case"integer":
                return 0;
            case"string":
                return "";
            case"array":
                return [];
            case"object":
                return {};
            default:
                return null
        }
    }

    t.CONFIG_DEFAULT_NAME = "settings", t.newConfigFile = c, t.merge = u, t.consolidate = l, t.getDefaultValues = p, t.getDefaultValuesContent = h
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/platform/configuration/common/configurationService", ["require", "exports", "vs/base/common/paths", "vs/base/common/winjs.base", "vs/base/common/eventEmitter", "vs/base/common/objects", "vs/base/common/errors", "./model", "vs/base/common/lifecycle", "vs/base/common/collections", "./configuration", "vs/platform/files/common/files", "./configurationRegistry", "vs/platform/platform", "vs/base/common/event"], function (e, t, n, r, o, i, s, a, c, u, l, f, p, h, d) {
    "use strict";
    var m = function (e) {
        function t(t, n, r) {
            var o = this;
            void 0 === r && (r = ".vscode"), e.call(this), this.serviceId = l.IConfigurationService, this.contextService = t, this.eventService = n, this.workspaceSettingsRootFolder = r, this.workspaceFilePathToConfiguration = Object.create(null);
            var i = this.eventService.addListener(f.EventType.FILE_CHANGES, function (e) {
                return o.handleFileEvents(e)
            }), s = h.Registry.as(p.Extensions.Configuration).onDidRegisterConfiguration(function () {
                return o.reloadAndEmit()
            });
            this.callOnDispose = function () {
                i(), s.dispose()
            }, this.onDidUpdateConfiguration = d.fromEventEmitter(this, l.ConfigurationServiceEventTypes.UPDATED)
        }

        return __extends(t, e), t.prototype.dispose = function () {
            this.callOnDispose = c.cAll(this.callOnDispose), e.prototype.dispose.call(this)
        }, t.prototype.loadConfiguration = function (e) {
            return this.loadConfigurationPromise || (this.loadConfigurationPromise = this.doLoadConfiguration()), this.loadConfigurationPromise.then(function (t) {
                var n = e ? t.merged[e] : t.merged, r = t.consolidated.parseErrors;
                return t.globals.parseErrors && r.push.apply(r, t.globals.parseErrors), r.length > 0 && (n || (n = {}), n.$parseErrors = r), n
            })
        }, t.prototype.doLoadConfiguration = function () {
            var e = this;
            return this.loadGlobalConfiguration().then(function (t) {
                return e.loadWorkspaceConfiguration().then(function (e) {
                    var n = a.consolidate(e), r = i.mixin(i.clone(t.contents), n.contents, !0);
                    return {merged: r, consolidated: n, globals: t}
                })
            })
        }, t.prototype.loadGlobalConfiguration = function () {
            return r.TPromise.as({contents: a.getDefaultValues()})
        }, t.prototype.hasWorkspaceConfiguration = function () {
            return !!this.workspaceFilePathToConfiguration[".vscode/" + a.CONFIG_DEFAULT_NAME + ".json"]
        }, t.prototype.loadWorkspaceConfiguration = function (e) {
            var t = this;
            return this.bulkFetchFromWorkspacePromise || (this.bulkFetchFromWorkspacePromise = this.resolveStat(this.contextService.toResource(this.workspaceSettingsRootFolder)).then(function (e) {
                return e.isDirectory ? t.resolveContents(e.children.filter(function (e) {
                    return ".json" === n.extname(e.resource.fsPath)
                }).map(function (e) {
                    return e.resource
                })) : r.TPromise.as([])
            }, function (e) {
                return e ? [] : void 0
            }).then(function (e) {
                e.forEach(function (e) {
                    return t.workspaceFilePathToConfiguration[t.contextService.toWorkspaceRelativePath(e.resource)] = r.TPromise.as(a.newConfigFile(e.value))
                })
            }, s.onUnexpectedError)), this.bulkFetchFromWorkspacePromise.then(function () {
                return r.TPromise.join(t.workspaceFilePathToConfiguration)
            })
        }, t.prototype.reloadAndEmit = function () {
            var e = this;
            return this.reloadConfiguration().then(function (t) {
                return e.emit(l.ConfigurationServiceEventTypes.UPDATED, {config: t})
            })
        }, t.prototype.reloadConfiguration = function (e) {
            return this.loadConfigurationPromise = null, this.loadConfiguration(e)
        }, t.prototype.handleFileEvents = function (e) {
            for (var t = e.changes, r = !1, o = 0, i = t.length; i > o; o++) {
                var c = this.contextService.toWorkspaceRelativePath(t[o].resource);
                if (c && (c === this.workspaceSettingsRootFolder && t[o].type === f.FileChangeType.DELETED && (this.workspaceFilePathToConfiguration = Object.create(null), r = !0), ".json" === n.extname(c) && n.isEqualOrParent(c, this.workspaceSettingsRootFolder)))switch (t[o].type) {
                    case f.FileChangeType.DELETED:
                        r = u.remove(this.workspaceFilePathToConfiguration, c);
                        break;
                    case f.FileChangeType.UPDATED:
                    case f.FileChangeType.ADDED:
                        this.workspaceFilePathToConfiguration[c] = this.resolveContent(t[o].resource).then(function (e) {
                            return a.newConfigFile(e.value)
                        }, s.onUnexpectedError), r = !0
                }
            }
            r && this.reloadAndEmit()
        }, t
    }(o.EventEmitter);
    t.ConfigurationService = m
}), define("vs/platform/extensions/node/extensionValidator", ["require", "exports", "vs/nls!vs/platform/extensions/node/extensionValidator", "vs/platform/extensions/common/extensionsRegistry", "semver"], function (e, t, n, r, o) {
    "use strict";
    function i(e) {
        return e = e.trim(), "*" === e || f.test(e)
    }

    function s(e) {
        if (!i(e))return null;
        if (e = e.trim(), "*" === e)return {
            hasCaret: !1,
            majorBase: 0,
            majorMustEqual: !1,
            minorBase: 0,
            minorMustEqual: !1,
            patchBase: 0,
            patchMustEqual: !1,
            preRelease: null
        };
        var t = e.match(f);
        return {
            hasCaret: !!t[1],
            majorBase: "x" === t[2] ? 0 : parseInt(t[2], 10),
            majorMustEqual: "x" !== t[2],
            minorBase: "x" === t[4] ? 0 : parseInt(t[4], 10),
            minorMustEqual: "x" !== t[4],
            patchBase: "x" === t[6] ? 0 : parseInt(t[6], 10),
            patchMustEqual: "x" !== t[6],
            preRelease: t[8] || null
        }
    }

    function a(e) {
        if (!e)return null;
        var t = e.majorBase, n = e.majorMustEqual, r = e.minorBase, o = e.minorMustEqual, i = e.patchBase, s = e.patchMustEqual;
        return e.hasCaret && (0 === t ? s = !1 : (o = !1, s = !1)), {
            majorBase: t,
            majorMustEqual: n,
            minorBase: r,
            minorMustEqual: o,
            patchBase: i,
            patchMustEqual: s
        }
    }

    function c(e, t) {
        var n;
        n = "string" == typeof e ? a(s(e)) : e;
        var r;
        if (r = "string" == typeof t ? a(s(t)) : t, !n || !r)return !1;
        var o = n.majorBase, i = n.minorBase, c = n.patchBase, u = r.majorBase, l = r.minorBase, f = r.patchBase, p = r.majorMustEqual, h = r.minorMustEqual, d = r.patchMustEqual;
        return 1 !== o || 0 !== u || p && h && d || (u = 1, l = 0, f = 0, p = !0, h = !1, d = !1), u > o ? !1 : o > u ? !p : l > i ? !1 : i > l ? !h : f > c ? !1 : c > f ? !d : !0
    }

    function u(e, t, r) {
        if (t.isBuiltin || "undefined" == typeof t.main)return !0;
        var o = a(s(t.engines.vscode));
        if (!o)return r.push(n.localize(0, null, t.engines.vscode)), !1;
        if (0 === o.majorBase) {
            if (!o.majorMustEqual || !o.minorMustEqual)return r.push(n.localize(1, null, t.engines.vscode)), !1
        } else if (!o.majorMustEqual)return r.push(n.localize(2, null, t.engines.vscode)), !1;
        return c(e, o) ? !0 : (r.push(n.localize(3, null, e, t.engines.vscode)), !1)
    }

    function l(e, t, i, s) {
        return r.isValidExtensionDescription(t, i, s) ? o.valid(i.version) ? u(e, i, s) : (s.push(n.localize(4, null)), !1) : !1
    }

    var f = /^(\^)?((\d+)|x)\.((\d+)|x)\.((\d+)|x)(\-.*)?$/;
    t.isValidVersionStr = i, t.parseVersion = s, t.normalizeVersion = a, t.isValidVersion = c, t.isValidExtensionVersion = u, t.isValidExtensionDescription = l
}), define("vs/platform/request/common/request", ["require", "exports", "vs/platform/instantiation/common/instantiation"], function (e, t, n) {
    "use strict";
    t.IRequestService = n.createDecorator("requestService")
}), define("vs/platform/request/common/baseRequestService", ["require", "exports", "vs/base/common/uri", "vs/base/common/strings", "vs/base/common/timer", "vs/base/common/async", "vs/base/common/winjs.base", "vs/base/common/objects", "vs/platform/request/common/request"], function (e, t, n, r, o, i, s, a, c) {
    "use strict";
    var u = function () {
        function e(e, t) {
            this.serviceId = c.IRequestService;
            var n = null, o = e.getWorkspace();
            this._serviceMap = o || Object.create(null), this._telemetryService = t, o && (n = r.rtrim(o.resource.toString(), "/") + "/"), this.computeOrigin(n)
        }

        return e.prototype.computeOrigin = function (e) {
            if (e) {
                this._origin = e;
                var t = n["default"].parse(this._origin).path;
                t && t.length > 0 && (this._origin = this._origin.substring(0, this._origin.length - t.length + 1)), r.endsWith(this._origin, "/") || (this._origin += "/")
            } else this._origin = "/"
        }, e.prototype.makeCrossOriginRequest = function (e) {
            return null
        }, e.prototype.makeRequest = function (e) {
            var t = o.nullEvent, n = !1, c = e.url;
            if (!c)throw new Error("IRequestService.makeRequest: Url is required");
            if ((r.startsWith(c, "http://") || r.startsWith(c, "https://")) && this._origin && !r.startsWith(c, this._origin)) {
                var u = this.makeCrossOriginRequest(e);
                if (u)return u;
                n = !0
            }
            var l = e;
            if (!n) {
                var f = {};
                this._telemetryService && (f["X-TelemetrySession"] = this._telemetryService.getSessionId()), f["X-Requested-With"] = "XMLHttpRequest", l.headers = a.mixin(l.headers, f)
            }
            return e.timeout && (l.customRequestInitializer = function (t) {
                t.timeout = e.timeout
            }), i.always(s.xhr(l), function (e) {
                t.data && (t.data.status = e.status), t.stop()
            })
        }, e
    }();
    t.BaseRequestService = u
}), define("vs/platform/workspace/common/workspace", ["require", "exports", "vs/platform/instantiation/common/instantiation"], function (e, t, n) {
    "use strict";
    t.IWorkspaceContextService = n.createDecorator("contextService")
}), define("vs/platform/workspace/common/baseWorkspaceContextService", ["require", "exports", "vs/base/common/uri", "vs/base/common/paths", "./workspace"], function (e, t, n, r, o) {
    "use strict";
    var i = function () {
        function e(e, t, n) {
            void 0 === n && (n = {}), this.serviceId = o.IWorkspaceContextService, this.workspace = e, this.configuration = t, this.options = n
        }

        return e.prototype.getWorkspace = function () {
            return this.workspace
        }, e.prototype.getConfiguration = function () {
            return this.configuration
        }, e.prototype.getOptions = function () {
            return this.options
        }, e.prototype.isInsideWorkspace = function (e) {
            return e && this.workspace ? r.isEqualOrParent(e.fsPath, this.workspace.resource.fsPath) : !1
        }, e.prototype.toWorkspaceRelativePath = function (e) {
            return this.isInsideWorkspace(e) ? r.normalize(r.relative(this.workspace.resource.fsPath, e.fsPath)) : null
        }, e.prototype.toResource = function (e) {
            return "string" == typeof e && this.workspace ? n["default"].file(r.join(this.workspace.resource.fsPath, e)) : null
        }, e
    }();
    t.BaseWorkspaceContextService = i
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/common/events", ["require", "exports", "vs/base/common/events"], function (e, t, n) {
    "use strict";
    var r = function () {
        function e() {
        }

        return e.EDITOR_OPENED = "editorOpened", e.EDITOR_CLOSED = "editorClosed", e.EDITOR_INPUT_OPENING = "editorInputOpening", e.EDITOR_INPUT_CHANGING = "editorInputChanging", e.EDITOR_OPTIONS_CHANGING = "editorOptionsChanging", e.EDITOR_INPUT_CHANGED = "editorInputChanged", e.EDITOR_INPUT_STATE_CHANGED = "editorInputStateChanged", e.EDITOR_SET_INPUT_ERROR = "editorSetInputError", e.EDITOR_POSITION_CHANGED = "editorPositionChanged", e.TEXT_EDITOR_SELECTION_CHANGED = "textEditorSelectionChanged", e.TEXT_EDITOR_MODE_CHANGED = "textEditorModeChanged", e.TEXT_EDITOR_CONTENT_CHANGED = "textEditorContentChanged", e.TEXT_EDITOR_CONTENT_OPTIONS_CHANGED = "textEditorContentOptionsChanged", e.TEXT_EDITOR_CONFIGURATION_CHANGED = "textEditorOptionsChanged", e.COMPOSITE_OPENING = "compositeOpening", e.COMPOSITE_OPENED = "compositeOpened", e.COMPOSITE_CLOSED = "compositeClosed", e.WORKBENCH_CREATED = "workbenchCreated", e.WORKBENCH_DISPOSING = "workbenchDisposing", e.WORKBENCH_DISPOSED = "workbenchDisposed", e.UNTITLED_FILE_DIRTY = "untitledFileDirty", e.UNTITLED_FILE_DELETED = "untitledFileDeleted", e.RESOURCE_ENCODING_CHANGED = "resourceEncodingChanged", e.WORKBENCH_OPTIONS_CHANGED = "workbenchOptionsChanged", e
    }();
    t.EventType = r;
    var o = function (e) {
        function t(t, n, r, o, i, s) {
            e.call(this, s), this.editor = t, this.editorId = n, this.editorInput = r, this.editorOptions = o, this.position = i
        }

        return __extends(t, e), t.prototype.prevent = function () {
            this.prevented = !0
        }, t.prototype.isPrevented = function () {
            return this.prevented
        }, t
    }(n.Event);
    t.EditorEvent = o;
    var i = function (e) {
        function t(t, n) {
            e.call(this, n), this.editorInput = t
        }

        return __extends(t, e), t
    }(n.Event);
    t.EditorInputEvent = i;
    var s = function (e) {
        function t(t, n, r, o, i, s, a) {
            e.call(this, n, r, o, i, s, a), this.selection = t
        }

        return __extends(t, e), t
    }(o);
    t.TextEditorSelectionEvent = s;
    var a = function (e) {
        function t(t, n, r, o) {
            e.call(this, o), this.key = t, this.before = n, this.after = r
        }

        return __extends(t, e), t
    }(n.Event);
    t.OptionsChangeEvent = a;
    var c = function (e) {
        function t(t, n) {
            e.call(this, n), this.actionId = t
        }

        return __extends(t, e), t
    }(n.Event);
    t.CommandEvent = c;
    var u = function (e) {
        function t(t, n) {
            e.call(this, n), this.compositeId = t
        }

        return __extends(t, e), t
    }(n.Event);
    t.CompositeEvent = u;
    var l = function (e) {
        function t(t, n) {
            e.call(this, n), this.resource = t
        }

        return __extends(t, e), t
    }(n.Event);
    t.ResourceEvent = l;
    var f = function (e) {
        function t() {
            e.apply(this, arguments)
        }

        return __extends(t, e), t
    }(l);
    t.UntitledEditorEvent = f
}), define("vs/workbench/node/userSettings", ["require", "exports", "fs", "path", "vs/base/common/json", "vs/base/common/objects", "vs/base/common/winjs.base", "vs/base/common/event"], function (e, t, n, r, o, i, s, a) {
    "use strict";
    var c = function () {
        function e(e, t) {
            this.appSettingsPath = e, this.appKeybindingsPath = t, this._onChange = new a.Emitter, this.registerWatchers()
        }

        return e.getValue = function (t, r, i) {
            return new s.TPromise(function (s, a) {
                var c = t.getConfiguration().env.appSettingsPath;
                n.readFile(c, function (t, n) {
                    var a = Object.create(null), c = n ? n.toString() : "{}", u = Object.create(null);
                    try {
                        u = o.parse(c)
                    } catch (t) {
                    }
                    for (var l in u)e.setNode(a, l, u[l]);
                    return s(e.doGetValue(a, r, i))
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
            var s = Object.create(null);
            try {
                s = o.parse(r)
            } catch (i) {
                return {contents: Object.create(null), parseErrors: [this.appSettingsPath]}
            }
            for (var a in s)e.setNode(t, a, s[a]);
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
}), define("vs/workbench/parts/extensions/common/extensions", ["require", "exports", "vs/nls!vs/workbench/parts/extensions/common/extensions", "vs/platform/instantiation/common/instantiation"], function (e, t, n, r) {
    "use strict";
    t.IExtensionsService = r.createDecorator("extensionsService"), t.IGalleryService = r.createDecorator("galleryService"), t.IExtensionTipsService = r.createDecorator("extensionTipsService"), t.ExtensionsLabel = n.localize(0, null)
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/services/configuration/node/configurationService", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/uri", "vs/base/common/strings", "vs/base/common/platform", "vs/base/common/paths", "vs/base/node/extfs", "vs/base/common/objects", "vs/platform/configuration/common/configurationService", "vs/workbench/common/events", "vs/platform/configuration/common/configuration", "fs"], function (e, t, n, r, o, i, s, a, c, u, l, f, p) {
    "use strict";
    var h = function (e) {
        function t(t, n) {
            e.call(this, t, n), this.serviceId = f.IConfigurationService, this.registerListeners()
        }

        return __extends(t, e), t.prototype.resolveContents = function (e) {
            var t = this, r = [];
            return n.TPromise.join(e.map(function (e) {
                return t.resolveContent(e).then(function (e) {
                    r.push(e)
                })
            })).then(function () {
                return r
            })
        }, t.prototype.resolveContent = function (e) {
            return new n.TPromise(function (t, n) {
                p.readFile(e.fsPath, function (r, o) {
                    r ? n(r) : t({resource: e, value: o.toString()})
                })
            })
        }, t.prototype.resolveStat = function (e) {
            return new n.TPromise(function (t, n) {
                a.readdir(e.fsPath, function (a, c) {
                    a ? "ENOTDIR" === a.code ? t({resource: e, isDirectory: !1}) : n(a) : t({
                        resource: e,
                        isDirectory: !0,
                        children: c.map(function (t) {
                            return i.isMacintosh && (t = o.normalizeNFC(t)), {resource: r["default"].file(s.join(e.fsPath, t))}
                        })
                    })
                })
            })
        }, t.prototype.registerListeners = function () {
            var e = this;
            this.toDispose = this.eventService.addListener(l.EventType.WORKBENCH_OPTIONS_CHANGED, function (t) {
                return e.onOptionsChanged(t)
            })
        }, t.prototype.onOptionsChanged = function (e) {
            "globalSettings" === e.key && this.reloadAndEmit()
        }, t.prototype.loadWorkspaceConfiguration = function (t) {
            return this.contextService.getWorkspace() ? e.prototype.loadWorkspaceConfiguration.call(this, t) : n.TPromise.as({})
        }, t.prototype.loadGlobalConfiguration = function () {
            var t = this;
            return e.prototype.loadGlobalConfiguration.call(this).then(function (e) {
                var n = t.contextService.getOptions().globalSettings;
                return {contents: c.mixin(c.clone(e.contents), n.settings, !0), parseErrors: n.settingsParseErrors}
            })
        }, t.prototype.dispose = function () {
            this.toDispose()
        }, t
    }(u.ConfigurationService);
    t.ConfigurationService = h
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/services/workspace/common/contextService", ["require", "exports", "vs/workbench/common/events", "vs/platform/instantiation/common/instantiation", "vs/platform/workspace/common/baseWorkspaceContextService"], function (e, t, n, r, o) {
    "use strict";
    t.IWorkspaceContextService = r.createDecorator("contextService");
    var i = function (e) {
        function r(n, r, o, i) {
            void 0 === i && (i = {}), e.call(this, r, o, i), this.eventService = n, this.serviceId = t.IWorkspaceContextService
        }

        return __extends(r, e), r.prototype.updateOptions = function (e, t) {
            var r = this.options[e];
            this.options[e] = t, this.eventService.emit(n.EventType.WORKBENCH_OPTIONS_CHANGED, new n.OptionsChangeEvent(e, r, t))
        }, r
    }(o.BaseWorkspaceContextService);
    t.WorkspaceContextService = i
}), define("vs/base/node/zip", ["require", "exports", "vs/nls!vs/base/node/zip", "path", "fs", "vs/base/common/async", "vs/base/node/pfs", "vs/base/common/winjs.base", "yauzl"], function (e, t, n, r, o, i, s, a, c) {
    "use strict";
    function u(e) {
        var t = e.externalFileAttributes >> 16 || 33188;
        return [448, 56, 7].map(function (e) {
            return t & e
        }).reduce(function (e, t) {
            return e + t
        }, 61440 & t)
    }

    function l(e, t, n, c) {
        var l = t.fileName.replace(c.sourcePathRegex, ""), f = r.dirname(l), p = r.join(n, f), h = r.join(n, l), d = u(t);
        return i.ninvoke(e, e.openReadStream, t).then(function (e) {
            return s.mkdirp(p).then(function () {
                return new a.Promise(function (t, n) {
                    var r = o.createWriteStream(h, {mode: d});
                    r.once("finish", function () {
                        return t(null)
                    }), r.once("error", n), e.once("error", n), e.pipe(r)
                })
            })
        })
    }

    function f(e, t, n) {
        return new a.Promise(function (r, o) {
            var i = [];
            e.once("error", o), e.on("entry", function (r) {
                n.sourcePathRegex.test(r.fileName) && i.push(l(e, r, t, n))
            }), e.once("close", function () {
                return a.Promise.join(i).done(r, o)
            })
        })
    }

    function p(e, t, n) {
        var r = new RegExp(n.sourcePath ? "^" + n.sourcePath : ""), o = i.nfcall(c.open, e);
        return n.overwrite && (o = o.then(function (e) {
            return s.rimraf(t), e
        })), o.then(function (e) {
            return f(e, t, {sourcePathRegex: r})
        })
    }

    function h(e, t) {
        return i.nfcall(c.open, e).then(function (e) {
            return new a.TPromise(function (r, o) {
                e.on("entry", function (n) {
                    n.fileName === t && i.ninvoke(e, e.openReadStream, n).done(function (e) {
                        return r(e)
                    }, function (e) {
                        return o(e)
                    })
                }), e.once("close", function () {
                    return o(new Error(n.localize(0, null, t)))
                })
            })
        })
    }

    function d(e, t) {
        return h(e, t).then(function (e) {
            return new a.TPromise(function (t, n) {
                var r = [];
                e.once("error", n), e.on("data", function (e) {
                    return r.push(e)
                }), e.on("end", function () {
                    return t(Buffer.concat(r))
                })
            })
        })
    }

    t.extract = p, t.buffer = d
});
var __decorate = this && this.__decorate || function (e, t, n, r) {
        var o, i = arguments.length, s = 3 > i ? t : null === r ? r = Object.getOwnPropertyDescriptor(t, n) : r;
        if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)s = Reflect.decorate(e, t, n, r); else for (var a = e.length - 1; a >= 0; a--)(o = e[a]) && (s = (3 > i ? o(s) : i > 3 ? o(t, n, s) : o(t, n)) || s);
        return i > 3 && s && Object.defineProperty(t, n, s), s
    }, __param = this && this.__param || function (e, t) {
        return function (n, r) {
            t(n, r, e)
        }
    };
define("vs/workbench/parts/extensions/node/extensionsService", ["require", "exports", "vs/nls!vs/workbench/parts/extensions/node/extensionsService", "os", "path", "vs/base/common/types", "vs/base/common/service", "vs/base/node/pfs", "vs/base/common/objects", "vs/base/common/arrays", "vs/base/node/zip", "vs/base/common/winjs.base", "vs/workbench/parts/extensions/common/extensions", "vs/base/node/request", "vs/base/node/proxy", "vs/workbench/services/workspace/common/contextService", "vs/base/common/async", "vs/base/common/event", "vs/workbench/node/userSettings", "semver", "vs/base/common/collections", "vs/platform/extensions/node/extensionValidator"], function (e, t, n, r, o, i, s, a, c, u, l, f, p, h, d, m, v, g, y, _, b, E) {
    "use strict";
    function S(e) {
        return new f.Promise(function (t, r) {
            try {
                t(JSON.parse(e))
            } catch (o) {
                r(new Error(n.localize(0, null)))
            }
        })
    }

    function w(e, t, r) {
        return void 0 === r && (r = t && t.version), l.buffer(e, "extension/package.json").then(function (e) {
            return S(e.toString("utf8"))
        }).then(function (e) {
            if (t) {
                if (t.name !== e.name)return f.Promise.wrapError(Error(n.localize(1, null)));
                if (t.publisher !== e.publisher)return f.Promise.wrapError(Error(n.localize(2, null)));
                if (r !== e.version)return f.Promise.wrapError(Error(n.localize(3, null)))
            }
            return f.TPromise.as(e)
        })
    }

    function x(e, t, n) {
        var r = {
            name: e.name,
            displayName: e.displayName || e.name,
            publisher: e.publisher,
            version: e.version,
            engines: {vscode: e.engines.vscode},
            description: e.description || ""
        };
        return t && (r.galleryInformation = t), n && (r.path = n), r
    }

    function O(e, t) {
        return void 0 === t && (t = e.version), e.publisher + "." + e.name + "-" + t
    }

    var T = function () {
        function e(e) {
            this.contextService = e, this.serviceId = p.IExtensionsService, this._onInstallExtension = new g.Emitter, this.onInstallExtension = this._onInstallExtension.event, this._onDidInstallExtension = new g.Emitter, this.onDidInstallExtension = this._onDidInstallExtension.event, this._onUninstallExtension = new g.Emitter, this.onUninstallExtension = this._onUninstallExtension.event, this._onDidUninstallExtension = new g.Emitter, this.onDidUninstallExtension = this._onDidUninstallExtension.event;
            var t = e.getConfiguration().env;
            this.extensionsPath = t.userExtensionsHome, this.obsoletePath = o.join(this.extensionsPath, ".obsolete"), this.obsoleteFileLimiter = new v.Limiter(1)
        }

        return e.prototype.install = function (e) {
            var t = this;
            if (i.isString(e))return this.installFromZip(e);
            var r = e;
            return this.isObsolete(r).then(function (o) {
                return o ? f.TPromise.wrapError(new Error(n.localize(4, null, r.name))) : t.installFromGallery(e)
            })
        }, e.prototype.installFromGallery = function (e) {
            var t = this, i = e.galleryInformation;
            return i ? (this._onInstallExtension.fire(e), this.getLastValidExtensionVersion(e, e.galleryInformation.versions).then(function (n) {
                var s = n.version, u = n.downloadUrl, p = n.downloadHeaders, d = o.join(r.tmpdir(), i.id), m = o.join(t.extensionsPath, O(e, s)), v = o.join(m, "package.json");
                return t.request(u).then(function (e) {
                    return c.assign(e, {headers: p})
                }).then(function (e) {
                    return h.download(d, e)
                }).then(function () {
                    return w(d, e, s)
                }).then(function (e) {
                    return l.extract(d, m, {sourcePath: "extension", overwrite: !0}).then(function () {
                        return e
                    })
                }).then(function (e) {
                    return c.assign({__metadata: i}, e)
                }).then(function (e) {
                    return a.writeFile(v, JSON.stringify(e, null, "	"))
                }).then(function () {
                    return t._onDidInstallExtension.fire({extension: e}), e
                }).then(null, function (n) {
                    return t._onDidInstallExtension.fire({extension: e, error: n}), f.TPromise.wrapError(n)
                })
            })) : f.TPromise.wrapError(new Error(n.localize(5, null)))
        }, e.prototype.getLastValidExtensionVersion = function (e, t) {
            var r = this;
            if (!t.length)return f.TPromise.wrapError(new Error(n.localize(6, null, e.displayName)));
            var o = t[0];
            return this.request(o.manifestUrl).then(function (e) {
                return h.json(e)
            }).then(function (n) {
                var i = r.contextService.getConfiguration().env.version, s = {
                    isBuiltin: !1,
                    engines: {vscode: n.engines.vscode},
                    main: n.main
                };
                return E.isValidExtensionVersion(i, s, []) ? o : r.getLastValidExtensionVersion(e, t.slice(1))
            })
        }, e.prototype.installFromZip = function (e) {
            var t = this;
            return w(e).then(function (n) {
                var r = o.join(t.extensionsPath, O(n));
                return t._onInstallExtension.fire(n), l.extract(e, r, {
                    sourcePath: "extension",
                    overwrite: !0
                }).then(function () {
                    return x(n, n.__metadata, r)
                }).then(function (e) {
                    return t._onDidInstallExtension.fire({extension: e}), e
                })
            })
        }, e.prototype.uninstall = function (e) {
            var t = this, r = e.path || o.join(this.extensionsPath, O(e));
            return a.exists(r).then(function (e) {
                return e ? null : f.Promise.wrapError(new Error(n.localize(7, null)))
            }).then(function () {
                return t._onUninstallExtension.fire(e)
            }).then(function () {
                return t.setObsolete(e)
            }).then(function () {
                return a.rimraf(r)
            }).then(function () {
                return t.unsetObsolete(e)
            }).then(function () {
                return t._onDidUninstallExtension.fire(e)
            })
        }, e.prototype.getInstalled = function (e) {
            void 0 === e && (e = !1);
            var t = this.getAllInstalled();
            return e ? t : t.then(function (e) {
                var t = b.values(b.groupBy(e, function (e) {
                    return e.publisher + "." + e.name
                }));
                return t.map(function (e) {
                    return e.sort(function (e, t) {
                        return _.rcompare(e.version, t.version)
                    })[0]
                })
            })
        }, e.prototype.getAllInstalled = function () {
            var e = this, t = new v.Limiter(10);
            return this.getObsoleteExtensions().then(function (n) {
                return a.readdir(e.extensionsPath).then(function (e) {
                    return e.filter(function (e) {
                        return !n[e]
                    })
                }).then(function (n) {
                    return f.Promise.join(n.map(function (n) {
                        var r = o.join(e.extensionsPath, n);
                        return t.queue(function () {
                            return a.readFile(o.join(r, "package.json"), "utf8").then(function (e) {
                                return S(e)
                            }).then(function (e) {
                                return x(e, e.__metadata, r)
                            }).then(null, function () {
                                return null
                            })
                        })
                    }))
                }).then(function (e) {
                    return e.filter(function (e) {
                        return !!e
                    })
                })
            })
        }, e.prototype.removeDeprecatedExtensions = function () {
            var e = this, t = this.getOutdatedExtensions().then(function (e) {
                return e.map(function (e) {
                    return O(e)
                })
            }), n = this.getObsoleteExtensions().then(function (e) {
                return Object.keys(e)
            });
            return f.TPromise.join([t, n]).then(function (e) {
                return u.flatten(e)
            }).then(function (t) {
                return f.TPromise.join(t.map(function (t) {
                    return a.rimraf(o.join(e.extensionsPath, t)).then(function () {
                        return e.withObsoleteExtensions(function (e) {
                            return delete e[t]
                        })
                    })
                }))
            })
        }, e.prototype.getOutdatedExtensions = function () {
            return this.getAllInstalled().then(function (e) {
                var t = b.values(b.groupBy(e, function (e) {
                    return e.publisher + "." + e.name
                })), n = u.flatten(t.map(function (e) {
                    return e.sort(function (e, t) {
                        return _.rcompare(e.version, t.version)
                    }).slice(1)
                }));
                return n.filter(function (e) {
                    return !!e.path
                })
            })
        }, e.prototype.isObsolete = function (e) {
            var t = O(e);
            return this.withObsoleteExtensions(function (e) {
                return !!e[t]
            })
        }, e.prototype.setObsolete = function (e) {
            var t = O(e);
            return this.withObsoleteExtensions(function (e) {
                return c.assign(e, (n = {}, n[t] = !0, n));
                var n
            })
        }, e.prototype.unsetObsolete = function (e) {
            var t = O(e);
            return this.withObsoleteExtensions(function (e) {
                return delete e[t]
            })
        }, e.prototype.getObsoleteExtensions = function () {
            return this.withObsoleteExtensions(function (e) {
                return e
            })
        }, e.prototype.withObsoleteExtensions = function (e) {
            var t = this;
            return this.obsoleteFileLimiter.queue(function () {
                var n = null;
                return a.readFile(t.obsoletePath, "utf8").then(null, function (e) {
                    return "ENOENT" === e.code ? f.TPromise.as("{}") : f.TPromise.wrapError(e)
                }).then(function (e) {
                    return JSON.parse(e)
                }).then(function (t) {
                    return n = e(t), t
                }).then(function (e) {
                    if (0 === Object.keys(e).length)return a.rimraf(t.obsoletePath);
                    var n = JSON.stringify(e);
                    return a.writeFile(t.obsoletePath, n)
                }).then(function () {
                    return n
                })
            })
        }, e.prototype.request = function (e) {
            var t = f.TPromise.join([y.UserSettings.getValue(this.contextService, "http.proxy"), y.UserSettings.getValue(this.contextService, "http.proxyStrictSSL")]);
            return t.then(function (t) {
                var n = t[0], r = t[1], o = d.getProxyAgent(e, {proxyUrl: n, strictSSL: r});
                return {url: e, agent: o, strictSSL: r}
            })
        }, __decorate([s.ServiceEvent], e.prototype, "onInstallExtension", void 0), __decorate([s.ServiceEvent], e.prototype, "onDidInstallExtension", void 0), __decorate([s.ServiceEvent], e.prototype, "onUninstallExtension", void 0), __decorate([s.ServiceEvent], e.prototype, "onDidUninstallExtension", void 0), e = __decorate([__param(0, m.IWorkspaceContextService)], e)
    }();
    t.ExtensionsService = T
}), define("vs/workbench/services/request/node/rawHttpService", ["require", "exports", "vs/base/common/winjs.base", "vs/base/common/objects", "vs/base/node/request", "vs/base/node/proxy", "zlib"], function (e, t, n, r, o, i, s) {
    "use strict";
    function a(e, t) {
        u = e, l = t
    }

    function c(e) {
        var t = i.getProxyAgent(e.url, {proxyUrl: u, strictSSL: l});
        return e = r.assign({}, e), e = r.assign(e, {agent: t, strictSSL: l}), o.request(e).then(function (r) {
            return new n.TPromise(function (t, n, o) {
                var i = r.res, a = i;
                "gzip" === i.headers["content-encoding"] && (a = a.pipe(s.createGunzip()));
                var u = [];
                a.on("data", function (e) {
                    return u.push(e)
                }), a.on("end", function () {
                    var r = i.statusCode;
                    if (e.followRedirects > 0 && (r >= 300 && 303 >= r || 307 === r)) {
                        var s = i.headers.location;
                        if (s) {
                            var a = {
                                type: e.type,
                                url: s,
                                user: e.user,
                                password: e.password,
                                responseType: e.responseType,
                                headers: e.headers,
                                timeout: e.timeout,
                                followRedirects: e.followRedirects - 1,
                                data: e.data
                            };
                            return void c(a).done(t, n, o)
                        }
                    }
                    var l = {
                        responseText: u.join(""), status: r, getResponseHeader: function (e) {
                            return i.headers[e]
                        }, readyState: 4
                    };
                    r >= 200 && 300 > r || 1223 === r ? t(l) : n(l)
                })
            }, function (r) {
                var o;
                return o = t ? "Unable to to connect to " + e.url + " through a proxy . Error: " + r.message : "Unable to to connect to " + e.url + ". Error: " + r.message, n.TPromise.wrapError({
                    responseText: o,
                    status: 404
                })
            })
        })
    }

    var u = null, l = !0;
    t.configure = a, t.xhr = c
});
var __extends = this && this.__extends || function (e, t) {
        function n() {
            this.constructor = e
        }

        for (var r in t)t.hasOwnProperty(r) && (e[r] = t[r]);
        e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    };
define("vs/workbench/services/request/node/requestService", ["require", "exports", "vs/base/common/winjs.base", "vs/platform/configuration/common/configurationRegistry", "vs/base/common/strings", "vs/nls!vs/workbench/services/request/node/requestService", "vs/base/common/lifecycle", "vs/base/common/timer", "vs/platform/platform", "vs/base/common/async", "vs/platform/configuration/common/configuration", "vs/platform/request/common/baseRequestService", "vs/workbench/services/request/node/rawHttpService"], function (e, t, n, r, o, i, s, a, c, u, l, f, p) {
    "use strict";
    var h = function (e) {
        function t(t, n, r) {
            var o = this;
            e.call(this, t, r), this.configurationService = n, this.callOnDispose = [], this.callOnDispose.push(n.addListener(l.ConfigurationServiceEventTypes.UPDATED, function (e) {
                o.rawHttpServicePromise.then(function (t) {
                    t.configure(e.config.http && e.config.http.proxy, e.config.http.proxyStrictSSL)
                })
            }))
        }

        return __extends(t, e), Object.defineProperty(t.prototype, "rawHttpServicePromise", {
            get: function () {
                return this._rawHttpServicePromise || (this._rawHttpServicePromise = this.configurationService.loadConfiguration().then(function (e) {
                    return p.configure(e.http && e.http.proxy, e.http.proxyStrictSSL), p
                })), this._rawHttpServicePromise
            }, enumerable: !0, configurable: !0
        }), t.prototype.dispose = function () {
            s.cAll(this.callOnDispose)
        }, t.prototype.makeRequest = function (t) {
            var r = t.url;
            if (!r)throw new Error("IRequestService.makeRequest: Url is required.");
            return o.startsWith(r, "file://") ? n.xhr(t).then(null, function (e) {
                return 0 === e.status && e.responseText ? e : n.Promise.wrapError({
                    status: 404,
                    responseText: i.localize(0, null)
                })
            }) : e.prototype.makeRequest.call(this, t)
        }, t.prototype.makeCrossOriginRequest = function (e) {
            var t = a.nullEvent;
            return this.rawHttpServicePromise.then(function (n) {
                return u.always(n.xhr(e), function (e) {
                    t.data && (t.data.status = e.status), t.stop()
                })
            })
        }, t
    }(f.BaseRequestService);
    t.RequestService = h;
    var d = c.Registry.as(r.Extensions.Configuration);
    d.registerConfiguration({
        id: "http",
        order: 9,
        title: i.localize(1, null),
        type: "object",
        properties: {
            "http.proxy": {type: "string", description: i.localize(2, null)},
            "http.proxyStrictSSL": {type: "boolean", "default": !0, description: i.localize(3, null)}
        }
    })
}), define("vs/workbench/electron-main/sharedProcessMain", ["require", "exports", "fs", "vs/base/common/platform", "vs/base/node/service.net", "vs/base/common/winjs.base", "vs/platform/instantiation/common/instantiationService", "vs/platform/instantiation/common/descriptors", "vs/platform/request/common/request", "vs/workbench/services/request/node/requestService", "vs/platform/workspace/common/workspace", "vs/workbench/services/workspace/common/contextService", "vs/platform/event/common/event", "vs/platform/event/common/eventService", "vs/platform/configuration/common/configuration", "vs/workbench/services/configuration/node/configurationService", "vs/workbench/parts/extensions/common/extensions", "vs/workbench/parts/extensions/node/extensionsService"], function (e, t, n, r, o, i, s, a, c, u, l, f, p, h, d, m, v, g) {
    "use strict";
    function y(e) {
        e && console.error(e), process.exit(e ? 1 : 0)
    }

    function _(e) {
        setInterval(function () {
            try {
                process.kill(e, 0)
            } catch (t) {
                process.exit()
            }
        }, 5e3)
    }

    function b(e, t) {
        var n = new h.EventService, r = new f.WorkspaceContextService(n, null, t.configuration, t.contextServiceOptions), o = new m.ConfigurationService(r, n), i = new u.RequestService(r, o), y = s.createInstantiationService();
        y.addSingleton(p.IEventService, n), y.addSingleton(l.IWorkspaceContextService, r), y.addSingleton(d.IConfigurationService, o), y.addSingleton(c.IRequestService, i), y.addSingleton(v.IExtensionsService, new a.SyncDescriptor(g.ExtensionsService));
        var _ = y.getInstance(v.IExtensionsService);
        e.registerService("ExtensionService", _), setTimeout(function () {
            return _.removeDeprecatedExtensions()
        }, 5e3)
    }

    function E(e) {
        function t(s) {
            return o.serve(e).then(null, function (a) {
                return !s || r.isWindows || "EADDRINUSE" !== a.code ? i.TPromise.wrapError(a) : o.connect(e).then(function (e) {
                    return e.dispose(), i.TPromise.wrapError(new Error("There is an instance already running."))
                }, function (r) {
                    try {
                        n.unlinkSync(e)
                    } catch (o) {
                        return i.TPromise.wrapError(new Error("Error deleting the shared ipc hook."))
                    }
                    return t(!1)
                })
            })
        }

        return t(!0)
    }

    function S() {
        return new i.TPromise(function (e, t) {
            process.once("message", e), process.once("error", t), process.send("hello")
        })
    }

    i.TPromise.join([E(process.env.VSCODE_SHARED_IPC_HOOK), S()]).then(function (e) {
        return b(e[0], e[1])
    }).then(function () {
        return _(process.env.VSCODE_PID)
    }).done(null, y)
});
//# sourceMappingURL=https://ticino.blob.core.windows.net/sourcemaps/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/vs\workbench\electron-main\sharedProcessMain.js.map
