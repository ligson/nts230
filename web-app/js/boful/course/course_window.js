try {
    if (!window.___is3b) {
        window.___is3b = "prepare"
    }
    function test3b() {
        window.___is3b = "loading";
        var c = navigator.userAgent.toLowerCase();
        if (!c.match(/msie ([\d.]+)/)) {
            window.___is3b = "false";
            return
        }
        var a = new Image();
        var b = "bdtest___" + Math.floor(Math.random() * 2147483648).toString(36);
        window[b] = a;
        a.onload = function () {
            window.___is3b = "true";
            a.onload = a.onerror = a.onabort = null;
            window[b] = null;
            a = null
        };
        a.onerror = function () {
            window.___is3b = "false";
            a.onload = a.onerror = a.onabort = null;
            window[b] = null;
            a = null
        };
        a.src = "res://360se.exe/2/2025"
    }

    if (window.___is3b === "prepare") {
        test3b()
    }
} catch (ex) {
} finally {
}
var ___baseNamespaceName = "CproNamespace";
(function () {
    var c = ___baseNamespaceName;
    var h = window, a = 0, g = false, b = false;
    while ((h != window.top || h != h.parent) && a < 10) {
        g = true;
        try {
            h.parent.location.toString()
        } catch (f) {
            b = true;
            break
        }
        a++;
        h = h.parent
    }
    if (a >= 10) {
        b = true
    }
    if (!b) {
        var d = "";
        try {
            d = top.location.href
        } catch (f) {
            d = ""
        }
        if (d) {
            if (d.indexOf("union.baidu.com") > 0 || d.indexOf("unionqa.baidu.com") > 0 || d.indexOf("musicmini.baidu.com") > 0 || d.indexOf("qianqianmini.baidu.com") > 0) {
                b = true
            }
        }
    }
    var e = function (i, k, j) {
        i.baseName = c;
        i.isInIframe = k;
        i.isCrossDomain = j;
        i.needInitTop = k && !j;
        i.buildInObject = {"[object Function]": 1, "[object RegExp]": 1, "[object Date]": 1, "[object Error]": 1, "[object Window]": 1};
        i.clone = function (p) {
            var m = p, n, l;
            if (!p || p instanceof Number || p instanceof String || p instanceof Boolean) {
                return m
            } else {
                if (p instanceof Array) {
                    m = [];
                    var o = 0;
                    for (n = 0, l = p.length; n < l; n++) {
                        m[o++] = this.clone(p[n])
                    }
                } else {
                    if ("object" === typeof p) {
                        if (this.buildInObject[Object.prototype.toString.call(p)]) {
                            return m
                        }
                        m = {};
                        for (n in p) {
                            if (p.hasOwnProperty(n)) {
                                m[n] = this.clone(p[n])
                            }
                        }
                    }
                }
            }
            return m
        };
        i.create = function (n, q) {
            var m = Array.prototype.slice.call(arguments, 0);
            m.shift();
            var o = function (r) {
                this.initialize = this.initialize || function () {
                };
                this.initializeDOM = this.initializeDOM || function () {
                };
                this.initializeEvent = this.initializeEvent || function () {
                };
                this.initialize.apply(this, r);
                this.initializeDOM.apply(this, r);
                this.initializeEvent.apply(this, r)
            };
            o.prototype = n;
            var l = new o(m);
            for (var p in n) {
                if (l[p] && typeof l[p] === "object" && l[p].modifier && l[p].modifier.indexOf("dynamic") > -1) {
                    l[p] = this.clone(l[p])
                }
            }
            l.instances = null;
            n.instances = n.instances || [];
            n.instances.push(l);
            return l
        };
        i.registerMethod = function (p, l) {
            var q = {};
            var m = {};
            var t, r, s;
            for (r in l) {
                t = l[r];
                if (!r || !t) {
                    continue
                }
                if (typeof t === "object" && t.modifier && t.modifier === "dynamic") {
                    p[r] = p[r] || {};
                    this.registerMethod(p[r], t)
                } else {
                    if (typeof t === "function") {
                        q[r] = t
                    } else {
                        m[r] = t
                    }
                }
            }
            for (r in q) {
                t = q[r];
                if (r && t) {
                    p[r] = t
                }
            }
            if (p && p.instances && p.instances.length && p.instances.length > 0) {
                for (var n = 0, o = p.instances.length; n < o; n++) {
                    s = p.instances[n];
                    this.registerMethod(s, l)
                }
            }
        };
        i.registerObj = function (n, p) {
            var m = Array.prototype.slice.call(arguments, 0);
            m.shift();
            var o = function (q) {
                this.register = this.register || function () {
                };
                this.register.apply(this, q)
            };
            o.prototype = n;
            o.prototype.instances = null;
            var l = new o(m);
            return l
        };
        i.registerNamespaceByWin = function (n, p) {
            var p = n.win = p || window;
            var m = n.fullName.replace("$baseName", this.baseName);
            var t = m.split(".");
            var q = t.length;
            var u = p;
            var s;
            for (var o = 0; o < q - 1; o++) {
                var l = t[o];
                if (u == p) {
                    u[l] = p[l] = p[l] || {};
                    s = l;
                    n.baseName = s
                } else {
                    u[l] = u[l] || {}
                }
                u = u[l]
            }
            var r = u[t[q - 1]] || {};
            if (r.fullName && r.version) {
                this.registerMethod(r, n)
            } else {
                r = this.registerObj(n);
                r.instances = null;
                u[t[q - 1]] = r
            }
        };
        i.registerNamespace = function (l) {
            if (!l || !l.fullName || !l.version) {
                return
            }
            this.registerNamespaceByWin(l, window);
            if (this.needInitTop) {
                this.registerNamespaceByWin(l, window.top)
            }
        };
        i.registerClass = i.registerNamespace;
        i.using = function (n, q) {
            var l;
            if (!q && this.isInIframe && !this.isCrossDomain && top && typeof top === "object" && top.document && "setInterval" in top) {
                q = top
            } else {
                q = q || window
            }
            n = n.replace("$baseName", this.baseName);
            var m = n.split(".");
            l = q[m[0]];
            for (var o = 1, p = m.length; o < p; o++) {
                if (l && l[m[o]]) {
                    l = l[m[o]]
                } else {
                    l = null
                }
            }
            return l
        }
    };
    window[c] = window[c] || {};
    e(window[c], g, b);
    if (g && !b) {
        window.top[c] = window.top[c] || {};
        e(window.top[c], g, b)
    }
})();
(function (b) {
    var a = {fullName: "$baseName.Utility", version: "1.0.0", register: function () {
        this.browser = this.browser || {};
        if (/msie (\d+\.\d)/i.test(navigator.userAgent)) {
            this.browser.ie = document.documentMode || +RegExp["\x241"];
        }
        if (/opera\/(\d+\.\d)/i.test(navigator.userAgent)) {
            this.browser.opera = +RegExp["\x241"];
        }
        if (/firefox\/(\d+\.\d)/i.test(navigator.userAgent)) {
            this.browser.firefox = +RegExp["\x241"];
        }
        if (/(\d+\.\d)?(?:\.\d)?\s+safari\/?(\d+\.\d+)?/i.test(navigator.userAgent) && !/chrome/i.test(navigator.userAgent)) {
            this.browser.safari = +(RegExp["\x241"] || RegExp["\x242"]);
        }
        if (/chrome\/(\d+\.\d)/i.test(navigator.userAgent)) {
            this.browser.chrome = +RegExp["\x241"];
        }
        try {
            if (/(\d+\.\d)/.test(window.external.max_version)) {
                this.browser.maxthon = +RegExp["\x241"];
            }
        } catch (c) {
        }
        this.browser.isWebkit = /webkit/i.test(navigator.userAgent);
        this.browser.isGecko = /gecko/i.test(navigator.userAgent) && !/like gecko/i.test(navigator.userAgent);
        this.browser.isStrict = document.compatMode == "CSS1Compat";
    }, browser: {}, isWindow: function (e) {
        var c = false;
        try {
            if (e && typeof e === "object" && e.document && "setInterval" in e) {
                c = true;
            }
        } catch (d) {
            c = false;
        }
        return c
    }, isInIframe: function (c) {
        c = c || window;
        return c != window.top && c != c.parent
    }, isInCrossDomainIframe: function (g, d) {
        var c = false;
        g = g || window;
        d = d || window.top;
        var f = 0;
        if (!this.isWindow(d) || !this.isWindow(d.parent)) {
            c = true
        } else {
            while ((g != d) && f < 10) {
                f++;
                if (this.isWindow(g) && this.isWindow(g.parent)) {
                    try {
                        g.parent.location.toString()
                    } catch (e) {
                        c = true;
                        break
                    }
                } else {
                    c = true;
                    break
                }
                g = g.parent
            }
        }
        if (f >= 10) {
            c = true
        }
        return c
    }, g: function (d, c) {
        c = c || window;
        if ("string" === typeof d || d instanceof String) {
            return c.document.getElementById(d)
        } else {
            if (d && d.nodeName && (d.nodeType == 1 || d.nodeType == 9)) {
                return d
            }
        }
        return d
    }, sendRequestViaImage: function (d, f) {
        var c = new Image();
        var e = "cpro_log_" + Math.floor(Math.random() * 2147483648).toString(36);
        f = f || window;
        f[e] = c;
        c.onload = c.onerror = c.onabort = function () {
            c.onload = c.onerror = c.onabort = null;
            f[e] = null;
            c = null
        };
        c.src = d
    }, getDocument: function (c) {
        if (!c) {
            return document
        }
        c = this.g(c);
        return c.nodeType == 9 ? c : c.ownerDocument || c.document
    }, getWindow: function (c) {
        c = this.g(c);
        var d = this.getDocument(c);
        return d.parentWindow || d.defaultView || null
    }, getTopWindow: function (c) {
        c = c || window;
        if (this.isInIframe(c) && !this.isInCrossDomainIframe(c, c.top) && this.isWindow(c.top)) {
            return c.top
        }
        return c
    }, bind: function (c, d, e) {
        c = this.g(c);
        d = d.replace(/^on/i, "").toLowerCase();
        if (c.addEventListener) {
            c.addEventListener(d, e, false)
        } else {
            if (c.attachEvent) {
                c.attachEvent("on" + d, e)
            }
        }
        return c
    }, unBind: function (c, d, e) {
        c = this.g(c);
        d = d.replace(/^on/i, "").toLowerCase();
        if (c.removeEventListener) {
            c.removeEventListener(d, e, false)
        } else {
            if (c.detachEvent) {
                c.detachEvent("on" + d, e)
            }
        }
        return c
    }, proxy: function (e, d, c) {
        var g = e;
        var f = d;
        return function () {
            if (c && c.length) {
                return g.apply(f || {}, c)
            } else {
                return g.apply(f || {}, arguments)
            }
        }
    }, getStyle: function (e, d) {
        var c;
        e = this.g(e);
        var g = this.getDocument(e);
        var h = "";
        if (d.indexOf("-") > -1) {
            h = d.replace(/[-_][^-_]{1}/g, function (i) {
                return i.charAt(1).toUpperCase()
            })
        } else {
            h = d.replace(/[A-Z]{1}/g, function (i) {
                return"-" + i.charAt(0).toLowerCase()
            })
        }
        var f;
        if (g && g.defaultView && g.defaultView.getComputedStyle) {
            f = g.defaultView.getComputedStyle(e, null);
            if (f) {
                c = f.getPropertyValue(d)
            }
            if (typeof c !== "boolean" && !c) {
                c = f.getPropertyValue(h)
            }
        } else {
            if (e.currentStyle) {
                f = e.currentStyle;
                if (f) {
                    c = f[d]
                }
                if (typeof c !== "boolean" && !c) {
                    c = f[h]
                }
            }
        }
        return c
    }, getPositionCore: function (c) {
        c = this.g(c);
        var k = this.getDocument(c), f = this.browser, d = f.isGecko > 0 && k.getBoxObjectFor && this.getStyle(c, "position") == "absolute" && (c.style.top === "" || c.style.left === ""), i = {left: 0, top: 0}, h = (f.ie && !f.isStrict) ? k.body : k.documentElement, l, e;
        if (c == h) {
            return i
        }
        if (c.getBoundingClientRect) {
            e = c.getBoundingClientRect();
            i.left = Math.floor(e.left) + Math.max(k.documentElement.scrollLeft, k.body.scrollLeft);
            i.top = Math.floor(e.top) + Math.max(k.documentElement.scrollTop, k.body.scrollTop);
            i.left -= k.documentElement.clientLeft;
            i.top -= k.documentElement.clientTop;
            var j = k.body, m = parseInt(this.getStyle(j, "borderLeftWidth")), g = parseInt(this.getStyle(j, "borderTopWidth"));
            if (f.ie && !f.isStrict) {
                i.left -= isNaN(m) ? 2 : m;
                i.top -= isNaN(g) ? 2 : g
            }
        } else {
            l = c;
            do {
                i.left += l.offsetLeft;
                i.top += l.offsetTop;
                if (f.isWebkit > 0 && this.getStyle(l, "position") == "fixed") {
                    i.left += k.body.scrollLeft;
                    i.top += k.body.scrollTop;
                    break
                }
                l = l.offsetParent
            } while (l && l != c);
            if (f.opera > 0 || (f.isWebkit > 0 && this.getStyle(c, "position") == "absolute")) {
                i.top -= k.body.offsetTop
            }
            l = c.offsetParent;
            while (l && l != k.body) {
                i.left -= l.scrollLeft;
                if (!f.opera || l.tagName != "TR") {
                    i.top -= l.scrollTop
                }
                l = l.offsetParent
            }
        }
        return i
    }, getPosition: function (i, h) {
        h = h || window;
        var e = this.g(i, h);
        if (!e) {
            return
        }
        var c = this.getPositionCore(e);
        var d;
        var g = 10, f = 0;
        while (h != h.parent && f < g) {
            f++;
            d = {top: 0, left: 0};
            if (!this.isInCrossDomainIframe(h, h.parent) && h.frameElement) {
                d = this.getPositionCore(h.frameElement)
            } else {
                break
            }
            c.left += d.left;
            c.top += d.top;
            h = h.parent
        }
        return c
    }, getOuterWidth: function (e, d) {
        e = this.g(e);
        d = d || false;
        var c = e.offsetWidth;
        if (d) {
            var g = this.getStyle(e, "marginLeft").toString().toLowerCase().replace("px", "").replace("auto", "0");
            var f = this.getStyle(e, "marginRight").toString().toLowerCase().replace("px", "").replace("auto", "0");
            c = c + parseInt(g || 0) + parseInt(f || 0)
        }
        return c
    }, getOuterHeight: function (e, d) {
        e = this.g(e);
        d = d || false;
        var c = e.offsetHeight;
        if (d) {
            var f = this.getStyle(e, "marginTop").toString().toLowerCase().replace("px", "").replace("auto", "0");
            var g = this.getStyle(e, "marginBottom").toString().toLowerCase().replace("px", "").replace("auto", "0");
            c = c + parseInt(f || 0) + parseInt(g || 0)
        }
        return c
    }, getTopIframe: function (f) {
        var c = this.g(f);
        var d = this.getWindow(c);
        var e = 0;
        if (this.isInIframe(window) && !this.isInCrossDomainIframe(window)) {
            while (d.parent != window.top && e < 10) {
                e++;
                d = d.parent
            }
            if (e < 10) {
                c = d.frameElement || c
            }
        }
        return c
    }, getOpacityInWin: function (k) {
        var j = this.g(k);
        var h = this.getWindow(j);
        var c = 100;
        var f = j;
        var i;
        try {
            while (f && f.tagName) {
                i = 100;
                if (this.browser.ie) {
                    if (this.browser.ie > 5) {
                        try {
                            i = f.filters.alpha.opacity || 100
                        } catch (g) {
                        }
                    }
                    c = c > i ? i : c
                } else {
                    try {
                        i = (h.getComputedStyle(f, null).opacity || 1) * 100
                    } catch (g) {
                    }
                    c = c * (i / 100)
                }
                f = f.parentNode
            }
        } catch (d) {
        }
        return c || 100
    }, getOpacity: function (i) {
        var h = this.g(i);
        var g = this.getWindow(h);
        var c = this.getOpacityInWin(h);
        var d = 100;
        var e = 0, f = 10;
        while (this.isInIframe(g)) {
            e++;
            if (!this.isInCrossDomainIframe(g, g.parent)) {
                d = 100;
                if (g.frameElement) {
                    d = this.getOpacityInWin(g.frameElement)
                }
                c = c * (d / 100)
            } else {
                break
            }
            g = g.parent
        }
        return c
    }, dateToString: function (d, c) {
        var g = {"M+": d.getMonth() + 1, "d+": d.getDate(), "h+": d.getHours() % 12 == 0 ? 12 : d.getHours() % 12, "H+": d.getHours(), "m+": d.getMinutes(), "s+": d.getSeconds(), "q+": Math.floor((d.getMonth() + 3) / 3), S: d.getMilliseconds()};
        var f = {"0": "\u65e5", "1": "\u4e00", "2": "\u4e8c", "3": "\u4e09", "4": "\u56db", "5": "\u4e94", "6": "\u516d"};
        if (/(y+)/.test(c)) {
            c = c.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length))
        }
        if (/(E+)/.test(c)) {
            c = c.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + f[d.getDay() + ""])
        }
        for (var e in g) {
            if (new RegExp("(" + e + ")").test(c)) {
                c = c.replace(RegExp.$1, (RegExp.$1.length == 1) ? (g[e]) : (("00" + g[e]).substr(("" + g[e]).length)))
            }
        }
        return c
    }, param: function (h, i) {
        var c = new Array(), g, f, d;
        for (var e in h) {
            d = true;
            if (i) {
                g = i[e] ? i[e] : e;
                d = i[e] ? true : false
            }
            if (!d) {
                continue
            }
            var f = h[e];
            switch (typeof f) {
                case"string":
                case"number":
                    c.push(g + "=" + f.toString());
                    break;
                case"boolean":
                    c.push(g + "=" + (f ? "1" : "0"));
                    break;
                case"object":
                    if (f instanceof Date) {
                        c.push(g + "=" + this.dateToString(f, "yyyyMMddhhmmssS"))
                    }
                    break;
                default:
                    break
            }
        }
        return c.join("&")
    }, getLength: function (e) {
        var c = 0;
        if (typeof e === "object") {
            if (e instanceof Array) {
                c = e.length
            } else {
                var d;
                for (d in e) {
                    if (d) {
                        c++
                    }
                }
            }
        }
        return c
    }, md5: function (s) {
        function N(d, c) {
            return(d << c) | (d >>> (32 - c))
        }

        function M(F, d) {
            var H, c, x, G, k;
            x = (F & 2147483648);
            G = (d & 2147483648);
            H = (F & 1073741824);
            c = (d & 1073741824);
            k = (F & 1073741823) + (d & 1073741823);
            if (H & c) {
                return(k ^ 2147483648 ^ x ^ G)
            }
            if (H | c) {
                if (k & 1073741824) {
                    return(k ^ 3221225472 ^ x ^ G)
                } else {
                    return(k ^ 1073741824 ^ x ^ G)
                }
            } else {
                return(k ^ x ^ G)
            }
        }

        function r(c, k, d) {
            return(c & k) | ((~c) & d)
        }

        function q(c, k, d) {
            return(c & d) | (k & (~d))
        }

        function p(c, k, d) {
            return(c ^ k ^ d)
        }

        function n(c, k, d) {
            return(k ^ (c | (~d)))
        }

        function u(G, F, ac, ab, k, H, I) {
            G = M(G, M(M(r(F, ac, ab), k), I));
            return M(N(G, H), F)
        }

        function g(G, F, ac, ab, k, H, I) {
            G = M(G, M(M(q(F, ac, ab), k), I));
            return M(N(G, H), F)
        }

        function J(G, F, ac, ab, k, H, I) {
            G = M(G, M(M(p(F, ac, ab), k), I));
            return M(N(G, H), F)
        }

        function t(G, F, ac, ab, k, H, I) {
            G = M(G, M(M(n(F, ac, ab), k), I));
            return M(N(G, H), F)
        }

        function e(F) {
            var I;
            var x = F.length;
            var k = x + 8;
            var d = (k - (k % 64)) / 64;
            var H = (d + 1) * 16;
            var ab = Array(H - 1);
            var c = 0;
            var G = 0;
            while (G < x) {
                I = (G - (G % 4)) / 4;
                c = (G % 4) * 8;
                ab[I] = (ab[I] | (F.charCodeAt(G) << c));
                G++
            }
            I = (G - (G % 4)) / 4;
            c = (G % 4) * 8;
            ab[I] = ab[I] | (128 << c);
            ab[H - 2] = x << 3;
            ab[H - 1] = x >>> 29;
            return ab
        }

        function D(k) {
            var d = "", x = "", F, c;
            for (c = 0; c <= 3; c++) {
                F = (k >>> (c * 8)) & 255;
                x = "0" + F.toString(16);
                d = d + x.substr(x.length - 2, 2)
            }
            return d
        }

        function L(k) {
            k = k.replace(/\r\n/g, "\n");
            var d = "";
            for (var F = 0; F < k.length; F++) {
                var x = k.charCodeAt(F);
                if (x < 128) {
                    d += String.fromCharCode(x)
                } else {
                    if ((x > 127) && (x < 2048)) {
                        d += String.fromCharCode((x >> 6) | 192);
                        d += String.fromCharCode((x & 63) | 128)
                    } else {
                        d += String.fromCharCode((x >> 12) | 224);
                        d += String.fromCharCode(((x >> 6) & 63) | 128);
                        d += String.fromCharCode((x & 63) | 128)
                    }
                }
            }
            return d
        }

        var E = Array();
        var R, i, K, v, h, aa, Z, Y, X;
        var U = 7, S = 12, P = 17, O = 22;
        var B = 5, A = 9, z = 14, y = 20;
        var o = 4, m = 11, l = 16, j = 23;
        var W = 6, V = 10, T = 15, Q = 21;
        s = L(s);
        E = e(s);
        aa = 1732584193;
        Z = 4023233417;
        Y = 2562383102;
        X = 271733878;
        for (R = 0; R < E.length; R += 16) {
            i = aa;
            K = Z;
            v = Y;
            h = X;
            aa = u(aa, Z, Y, X, E[R + 0], U, 3614090360);
            X = u(X, aa, Z, Y, E[R + 1], S, 3905402710);
            Y = u(Y, X, aa, Z, E[R + 2], P, 606105819);
            Z = u(Z, Y, X, aa, E[R + 3], O, 3250441966);
            aa = u(aa, Z, Y, X, E[R + 4], U, 4118548399);
            X = u(X, aa, Z, Y, E[R + 5], S, 1200080426);
            Y = u(Y, X, aa, Z, E[R + 6], P, 2821735955);
            Z = u(Z, Y, X, aa, E[R + 7], O, 4249261313);
            aa = u(aa, Z, Y, X, E[R + 8], U, 1770035416);
            X = u(X, aa, Z, Y, E[R + 9], S, 2336552879);
            Y = u(Y, X, aa, Z, E[R + 10], P, 4294925233);
            Z = u(Z, Y, X, aa, E[R + 11], O, 2304563134);
            aa = u(aa, Z, Y, X, E[R + 12], U, 1804603682);
            X = u(X, aa, Z, Y, E[R + 13], S, 4254626195);
            Y = u(Y, X, aa, Z, E[R + 14], P, 2792965006);
            Z = u(Z, Y, X, aa, E[R + 15], O, 1236535329);
            aa = g(aa, Z, Y, X, E[R + 1], B, 4129170786);
            X = g(X, aa, Z, Y, E[R + 6], A, 3225465664);
            Y = g(Y, X, aa, Z, E[R + 11], z, 643717713);
            Z = g(Z, Y, X, aa, E[R + 0], y, 3921069994);
            aa = g(aa, Z, Y, X, E[R + 5], B, 3593408605);
            X = g(X, aa, Z, Y, E[R + 10], A, 38016083);
            Y = g(Y, X, aa, Z, E[R + 15], z, 3634488961);
            Z = g(Z, Y, X, aa, E[R + 4], y, 3889429448);
            aa = g(aa, Z, Y, X, E[R + 9], B, 568446438);
            X = g(X, aa, Z, Y, E[R + 14], A, 3275163606);
            Y = g(Y, X, aa, Z, E[R + 3], z, 4107603335);
            Z = g(Z, Y, X, aa, E[R + 8], y, 1163531501);
            aa = g(aa, Z, Y, X, E[R + 13], B, 2850285829);
            X = g(X, aa, Z, Y, E[R + 2], A, 4243563512);
            Y = g(Y, X, aa, Z, E[R + 7], z, 1735328473);
            Z = g(Z, Y, X, aa, E[R + 12], y, 2368359562);
            aa = J(aa, Z, Y, X, E[R + 5], o, 4294588738);
            X = J(X, aa, Z, Y, E[R + 8], m, 2272392833);
            Y = J(Y, X, aa, Z, E[R + 11], l, 1839030562);
            Z = J(Z, Y, X, aa, E[R + 14], j, 4259657740);
            aa = J(aa, Z, Y, X, E[R + 1], o, 2763975236);
            X = J(X, aa, Z, Y, E[R + 4], m, 1272893353);
            Y = J(Y, X, aa, Z, E[R + 7], l, 4139469664);
            Z = J(Z, Y, X, aa, E[R + 10], j, 3200236656);
            aa = J(aa, Z, Y, X, E[R + 13], o, 681279174);
            X = J(X, aa, Z, Y, E[R + 0], m, 3936430074);
            Y = J(Y, X, aa, Z, E[R + 3], l, 3572445317);
            Z = J(Z, Y, X, aa, E[R + 6], j, 76029189);
            aa = J(aa, Z, Y, X, E[R + 9], o, 3654602809);
            X = J(X, aa, Z, Y, E[R + 12], m, 3873151461);
            Y = J(Y, X, aa, Z, E[R + 15], l, 530742520);
            Z = J(Z, Y, X, aa, E[R + 2], j, 3299628645);
            aa = t(aa, Z, Y, X, E[R + 0], W, 4096336452);
            X = t(X, aa, Z, Y, E[R + 7], V, 1126891415);
            Y = t(Y, X, aa, Z, E[R + 14], T, 2878612391);
            Z = t(Z, Y, X, aa, E[R + 5], Q, 4237533241);
            aa = t(aa, Z, Y, X, E[R + 12], W, 1700485571);
            X = t(X, aa, Z, Y, E[R + 3], V, 2399980690);
            Y = t(Y, X, aa, Z, E[R + 10], T, 4293915773);
            Z = t(Z, Y, X, aa, E[R + 1], Q, 2240044497);
            aa = t(aa, Z, Y, X, E[R + 8], W, 1873313359);
            X = t(X, aa, Z, Y, E[R + 15], V, 4264355552);
            Y = t(Y, X, aa, Z, E[R + 6], T, 2734768916);
            Z = t(Z, Y, X, aa, E[R + 13], Q, 1309151649);
            aa = t(aa, Z, Y, X, E[R + 4], W, 4149444226);
            X = t(X, aa, Z, Y, E[R + 11], V, 3174756917);
            Y = t(Y, X, aa, Z, E[R + 2], T, 718787259);
            Z = t(Z, Y, X, aa, E[R + 9], Q, 3951481745);
            aa = M(aa, i);
            Z = M(Z, K);
            Y = M(Y, v);
            X = M(X, h)
        }
        var w = function (x) {
            var c = x;
            for (var d = 0, k = 8 - x.length; d < k; d++) {
                c = "0" + c
            }
            return c
        };
        var C = ((parseInt("0x" + D(aa), 16) + parseInt("0x" + D(Z), 16)) % 4294967296).toString(16);
        var f = ((parseInt("0x" + D(Y), 16) + parseInt("0x" + D(X), 16)) % 4294967296).toString(16);
        if (C.length < 8) {
            C = w(C)
        }
        if (f.length < 8) {
            f = w(f)
        }
        return C + f
    }, getScrollWidth: function (d) {
        try {
            d = d || window;
            if (d.document.compatMode === "BackCompat") {
                return d.document.body.scrollWidth
            } else {
                return d.document.documentElement.scrollWidth
            }
        } catch (c) {
            return 0
        }
    }, getScrollHeight: function (d) {
        try {
            d = d || window;
            if (d.document.compatMode === "BackCompat") {
                return d.document.body.scrollHeight
            } else {
                return d.document.documentElement.scrollHeight
            }
        } catch (c) {
            return 0
        }
    }, getClientWidth: function (d) {
        try {
            d = d || window;
            if (d.document.compatMode === "BackCompat") {
                return d.document.body.clientWidth
            } else {
                return d.document.documentElement.clientWidth
            }
        } catch (c) {
            return 0
        }
    }, getClientHeight: function (d) {
        try {
            d = d || window;
            if (d.document.compatMode === "BackCompat") {
                return d.document.body.clientHeight
            } else {
                return d.document.documentElement.clientHeight
            }
        } catch (c) {
            return 0
        }
    }, getScrollTop: function (c) {
        c = c || window;
        var e = c.document;
        return window.pageYOffset || e.documentElement.scrollTop || e.body.scrollTop
    }, getScrollLeft: function (c) {
        c = c || window;
        var e = c.document;
        return window.pageXOffset || e.documentElement.scrollLeft || e.body.scrollLeft
    }, escapeToEncode: function (d) {
        var c = d || "";
        if (c) {
            c = c.replace(/%u[\d|\w]{4}/g, function (e) {
                return encodeURIComponent(unescape(e))
            })
        }
        return c
    }, template: function (e, d) {
        var c = /{(.*?)}/g;
        return e.replace(c, function (h, g, f, i) {
            return d[g] || ""
        })
    }, extend: function (e, c) {
        for (var d in c) {
            if (c.hasOwnProperty(d)) {
                e[d] = c[d]
            }
        }
        return e
    }, log: function (f, d) {
        d = typeof d === "undefined" ? true : false;
        if (!this.logMsg) {
            this.logMsg = document.getElementById("baiduCproLogMsg");
            if (!this.logMsg) {
                return
            }
        }
        var c = new Array();
        if (typeof(f) === "object") {
            for (var e in f) {
                if (e !== "analysisUrl") {
                    c.push(e + ":" + f[e])
                }
            }
        } else {
            c.push("" + f)
        }
        this.logMsg.innerHTML = d ? this.logMsg.innerHTML : "";
        this.logMsg.innerHTML += c.join("<br/>") + "<br/>"
    }, getCookieRaw: function (d, h) {
        var c;
        var h = h || window;
        var g = h.document;
        var e = new RegExp("(^| )" + d + "=([^;]*)(;|\x24)");
        var f = e.exec(g.cookie);
        if (f) {
            c = f[2]
        }
        return c
    }, setCookieRaw: function (e, f, d) {
        d = d || {};
        var c = d.expires;
        if ("number" == typeof d.expires) {
            c = new Date();
            c.setTime(c.getTime() + d.expires)
        }
        document.cookie = e + "=" + f + (d.path ? "; path=" + d.path : "") + (c ? "; expires=" + c.toGMTString() : "") + (d.domain ? "; domain=" + d.domain : "") + (d.secure ? "; secure" : "")
    }, removeCookie: function (d) {
        var c = new Date();
        c.setTime(c.getTime() - 86400);
        this.setCookieRaw(d, "", {path: "/", expires: c})
    }, jsonToObj: function (c) {
        return(new Function("return " + c))()
    }, getUrlQueryValue: function (d, e) {
        if (d && e) {
            var f = new RegExp("(^|&|\\?|#)" + e + "=([^&]*)(&|\x24)", "");
            var c = d.match(f);
            if (c) {
                return c[2]
            }
        }
        return null
    }, parseUrlQuery: function (d, p) {
        d = d || "";
        p = p || "?";
        var l = arguments.callee;
        if (!l.hasOwnProperty[p]) {
            l[p] = {}
        }
        var c = l[p];
        if (c.hasOwnProperty(d)) {
            return c[d]
        }
        var k = {}, n = d.indexOf(p), h = d.substring(n + 1), e = h.split("&");
        if (n !== -1) {
            for (var g = 0, j = e.length; g < j; g++) {
                var f = e[g].split("="), o = decodeURIComponent(f[0]), m = decodeURIComponent(f[1]);
                k[o] = m
            }
        }
        c[d] = k;
        return k
    }, ready: function (h, d, g) {
        g = g || this.win || window;
        var f = g.document;
        d = d || 0;
        this.domReadyMonitorRunTimes = 0;
        this.readyFuncArray = this.readyFuncArray || [];
        this.readyFuncArray.push({func: h, delay: d, done: false});
        var c = this.proxy(function () {
            var n = false;
            this.domReadyMonitorRunTimes++;
            var p = false;
            try {
                if (g.frameElement) {
                    p = true
                }
            } catch (o) {
                p = true
            }
            if (this.browser.ie && this.browser.ie < 9 && !p) {
                try {
                    f.documentElement.doScroll("left");
                    n = true
                } catch (o) {
                }
            } else {
                if (f.readyState === "complete" || this.domContentLoaded) {
                    n = true
                } else {
                    if (this.domReadyMonitorRunTimes > 300000) {
                        if (this.domReadyMonitorId) {
                            g.clearInterval(this.domReadyMonitorId);
                            this.domReadyMonitorId = null
                        }
                        return
                    }
                }
            }
            if (n) {
                try {
                    if (this.readyFuncArray && this.readyFuncArray.length) {
                        for (var k = 0, m = this.readyFuncArray.length; k < m; k++) {
                            var l = this.readyFuncArray[k];
                            if (!l || !l.func || l.done) {
                                continue
                            }
                            if (!l.delay) {
                                l.done = true;
                                l.func()
                            } else {
                                l.done = true;
                                g.setTimeout(l.func, l.delay)
                            }
                        }
                    }
                } catch (j) {
                    throw j
                } finally {
                    if (this.domReadyMonitorId) {
                        g.clearInterval(this.domReadyMonitorId);
                        this.domReadyMonitorId = null
                    }
                }
            }
        }, this);
        var e = this.proxy(function () {
            this.domContentLoaded = true;
            c()
        }, this);
        if (!this.domReadyMonitorId) {
            this.domReadyMonitorId = g.setInterval(c, 50);
            if (f.addEventListener) {
                f.addEventListener("DOMContentLoaded", e, false);
                g.addEventListener("load", e, false)
            } else {
                if (f.attachEvent) {
                    g.attachEvent("onload", e, false)
                }
            }
        }
    }, canFixed: function () {
        var c = true;
        if (this.browser.ie && (this.browser.ie < 7 || document.compatMode === "BackCompat")) {
            c = false
        }
        return c
    }, getPara: function (k) {
        var j = {};
        if (k && typeof k == "string" && k.indexOf("?") > -1) {
            var f = k.split("?")[1].split("&");
            for (var g = 0, c = f.length; g < c; g++) {
                var d = f[g].split("=");
                var e = d[0];
                var h = d[1];
                j[e] = h
            }
        }
        return j
    }, noop: function () {
    }};
    b.registerNamespace(a)
})(window[___baseNamespaceName]);
(function (b) {
    var c = {fullName: "$baseName.BusinessLogic", version: "1.0.0", register: function () {
        this.G = b.using("$baseName", this.win);
        this.U = b.using("$baseName.Utility", this.win)
    }, randomArray: [], clientTree: {}, displayCounter: 1, displayTypeCounter: {}, adsArray: [], adsWrapStore: {}, winFocused: true, cproServiceUrl: "http://cpro.baidu.com/cpro/ui/uijs.php", iframeIdPrefix: "cproIframe", isAsyn: false, currentWindowOnUnloadHandler: null, getSlotDataFromUnion: function (j, t, r, p) {
        var m = "http://pos.baidu.com/ecom?";
        if (!j || !t || !window[t]) {
            return null
        }
        var C = j instanceof Array ? true : false;
        var G = C ? j.length : 1;
        var H = this.G.create(this.G.BusinessLogic.Param, {currentWindow: window, timeStamp: (new Date()).getTime()});
        var A = "";
        if (C) {
            A = [];
            var B = j.length;
            while (B--) {
                A.push(H.get("did"))
            }
            A = A.join(",")
        } else {
            A = H.get("did")
        }
        var e = this.U.isInCrossDomainIframe(window);
        var K = this.U.isWindow(top) ? top : window;
        var l = e ? window : K;
        var d = "";
        try {
            var h = document.getElementsByTagName("script");
            var L = h[h.length - 1];
            if (r) {
                for (var z = 0; z < G; z++) {
                    var E = C ? j[z] : j.toString();
                    var g = "cpro_" + E;
                    var n = this.U.g(g, window);
                    if (n) {
                        var M = this.U.getPosition(L, window);
                        if (z > 0) {
                            d += ","
                        }
                        d += M.top + "x" + M.left
                    }
                }
            } else {
                var u = "cproTemp" + parseInt(Math.random() * 10000).toString();
                document.write('<div style="width:0px; height:0px;" id="' + u + '">-</div>');
                var F = this.U.g(u, window);
                var M = null;
                if (F) {
                    M = this.U.getPosition(F, window);
                    F.parentNode.removeChild(F);
                    F = null
                }
                if (!M) {
                    M.top = "-1";
                    M.left = "-1"
                }
                d = M.top + "x" + M.left;
                if (C) {
                    for (var z = 1; z < G; z++) {
                        d += "," + M.top + "x" + M.left
                    }
                }
            }
            if (!d) {
                d = "-1x-1"
            }
        } catch (D) {
            d = "-1x-1"
        }
        var q = "";
        try {
            if (!C) {
                var s = this.Param.getSlot2UIMapping(H);
                q = this.getStyleApi(j.toString(), H, null, s, true);
                q = q.slice(1)
            }
        } catch (D) {
            q = ""
        }
        if (p) {
            if (q && q.length) {
                q += "&rs=" + p
            } else {
                q = "rs=" + p
            }
        }
        var J = [
            ["di", C ? j.join(",") : j.toString()],
            ["dcb", t],
            ["dtm", "BAIDU_CPRO_SETJSONADSLOT"],
            ["dai", A],
            ["jn", H.get("jn")],
            ["ltu", encodeURIComponent(H.get("word").slice(0, 400))],
            ["liu", encodeURIComponent(window.location.href.toString().slice(0, 400))],
            ["ltr", encodeURIComponent(H.get("refer").slice(0, 400))],
            ["ps", d],
            ["psr", H.get("csp").toString().replace(",", "x")],
            ["par", H.get("csn").toString().replace(",", "x")],
            ["pcs", this.U.getClientWidth(l) + "x" + this.U.getClientHeight(l)],
            ["pss", this.U.getScrollWidth(l) + "x" + this.U.getScrollHeight(l)],
            ["pis", this.U.getClientWidth(window) + "x" + this.U.getClientHeight(window)],
            ["cfv", H.get("fv")],
            ["ccd", H.get("ccd")],
            ["col", H.get("csl")],
            ["coa", encodeURIComponent(q)],
            ["cec", ((document.characterSet ? document.characterSet : document.charset) || "")],
            ["tpr", H.get("prt")],
            ["kl", H.get("k")],
            ["dis", H.get("if")]
        ];
        try {
            var x = o(this);
            var w = j;
            var I;
            var k;
            if (x && w == x.sid) {
                m = m + "mid=" + x.mid + "&sid=" + x.vc + "&"
            }
        } catch (D) {
        }
        var f = J.length;
        while (f--) {
            var v = J.shift();
            m += v[0] + "=" + v[1] + "&"
        }
        m = m.replace(/&$/, "");
        if (/u\d+/.test(j)) {
            if (r) {
                var y = document.createElement("script");
                y.setAttribute("type", "text/javascript");
                y.setAttribute("src", m);
                document.getElementsByTagName("head")[0].appendChild(y)
            } else {
                document.write('<script type="text/javascript" charset="utf-8" src="' + m + '"><\/script>')
            }
        } else {
            window[t](null, {_html: j})
        }
        function o(S) {
            if (S.U.isInCrossDomainIframe()) {
                var R = window.location.search.slice(1)
            } else {
                var R = top.location.search.slice(1)
            }
            var i = S.U.getUrlQueryValue(R, "baidu_clb_preview_sid");
            var O = S.U.getUrlQueryValue(R, "baidu_clb_preview_mid");
            var P = S.U.getUrlQueryValue(R, "baidu_clb_preview_vc");
            var Q = +S.U.getUrlQueryValue(R, "baidu_clb_preview_ts");
            var N = +new Date;
            if (N - Q <= 30 * 1000) {
                return{sid: i, mid: O, vc: P}
            } else {
                return null
            }
        }
    }, getSlotDataFromCB: function (f, e) {
        var d = null;
        f = f || window.tempClbCproAdSlotId;
        e = e || window.tempClbCproAdObj;
        if (f && e) {
            d = {};
            d[f] = {_html: e._html}
        }
        return d
    }, clearSlotDataFromCB: function () {
        window.tempClbCproAdSlotId = null;
        window.tempClbCproAdObj = null
    }, parseSlotDataFromUnion: function (e) {
        var m = {};
        var f = "";
        for (var d in e) {
            if (d && e.hasOwnProperty(d)) {
                f = d;
                break
            }
        }
        m.slotId = f;
        if (e[f] && e[f]._html) {
            var g = e[f]._html.split("|");
            var k, l;
            for (var h = 0, j = g.length; h < j; h++) {
                k = g[h];
                if (k) {
                    l = k.split("=");
                    m[l[0]] = l[1]
                }
            }
        } else {
            if (e[f]) {
                if (e[f].sw) {
                    m.cpro_w = e[f].sw
                }
                if (e[f].sh) {
                    m.cpro_h = e[f].sh
                }
                m.cpro_at = "all"
            }
        }
        return m
    }, getSlotDataFromUserOpenApi: function () {
        var d = null;
        if (window.cproApi && typeof window.cproApi === "object" && (this.U.getLength(window.cproApi) > 0)) {
            var f = window.cproApi;
            d = {};
            window.cproApi = null;
            for (var e in f) {
                if (e && f[e]) {
                    d["cpro_" + e] = f[e]
                }
            }
        }
        return d
    }, getStyleApi: function (g, z, m, p, C) {
        var j = {};
        var v, d;
        for (d in m) {
            if (d && m[d] && m.hasOwnProperty(d)) {
                if (!p[d] && typeof j[d] === "undefined") {
                    j[d.replace("cpro_", "")] = encodeURIComponent(m[d]);
                    if (d === "cpro_titFF") {
                        j[d.replace("cpro_", "")] = encodeURIComponent(j[d.replace("cpro_", "")])
                    }
                }
            }
        }
        if (window.cproStyleApi && g && window.cproStyleApi[g]) {
            for (var D in window.cproStyleApi[g]) {
                if (D && typeof window.cproStyleApi[g][D] !== "undefined") {
                    var A = window.cproStyleApi[g][D];
                    if (z[D]) {
                        if (C) {
                            j[D] = encodeURIComponent(A).toString()
                        } else {
                            z.set(D, A)
                        }
                    } else {
                        j[D] = encodeURIComponent(A).toString()
                    }
                    A = null
                }
            }
        }
        if (z.get("tn") === "baiduTlinkInlay" && z.displayType === "inlay") {
            var B = 3;
            var q = 3;
            var n = parseInt(j.titFS) || 12;
            var l = parseInt(j.conBW) || 0;
            var u = parseInt(z.get("rsi0")) - 2 * l;
            var t = parseInt(z.get("rsi1")) - 2 * l;
            var y = 7;
            var w = y * n;
            var i = n + 6;
            var x = 7;
            var h = w + 2 * x;
            var s = i;
            var f = Math.floor(u / h);
            var k = Math.floor(t / s);
            var o = parseInt(z.get("adn")) || 6;
            if (o > f * k) {
                B = f;
                q = k
            } else {
                if (o < f) {
                    B = o;
                    q = 1
                } else {
                    B = f;
                    q = Math.ceil(o / f)
                }
            }
            j.hn = q || 3;
            j.wn = B || 3
        }
        var r = "";
        for (var e in j) {
            if (e && typeof j[e] !== "undefined" && j.hasOwnProperty(e)) {
                r += "&" + e + "=" + j[e]
            }
        }
        return r.slice(0, 1000)
    }, isPreview: function a(q, l, k, d, f) {
        var r = false;
        var j;
        if (f) {
            j = f.substring(f.indexOf("?"))
        } else {
            if (this.U.isInCrossDomainIframe()) {
                j = window.location.search.slice(1)
            } else {
                j = top.location.search.slice(1)
            }
        }
        var g = document.referrer;
        var i = k === "inlay" || k === "ui" ? "bd_cpro_prev" : "bd_cpro_fprev";
        var n = "";
        var m;
        var p;
        try {
            p = document.cookie
        } catch (o) {
        }
        if (j.indexOf(i) !== -1) {
            n = this.U.getUrlQueryValue(j, i)
        }
        if (!n && p && p.indexOf(i) !== -1) {
            n = this.U.getCookieRaw(i)
        }
        if (!n && g.indexOf(i) !== -1) {
            n = this.U.getUrlQueryValue(g, i)
        }
        if (n) {
            n = decodeURIComponent(n).replace(/\\x1e/g, "&").replace(/\\x1d/g, "=").replace(/\\x1c/, "?").replace(/\\x5c/, "\\");
            m = this.U.jsonToObj(n);
            if (d == undefined) {
                d = 1
            }
            if (m.type != 1 && (d & 2) == 2) {
                r = (parseInt(m.imgWidth) === parseInt(q) && parseInt(m.imgHeight) === parseInt(l))
            } else {
                if (m.type == 1 && ((d & 1) == 1 || (d & 64) == 64 || (d & 32) == 32)) {
                    r = true
                }
            }
        }
        return r
    }, getAdsDomId: function (d) {
        d = d || 1;
        return this.iframeIdPrefix + d
    }, checkAdsCounter: function (f, h, e) {
        var d = false;
        var g;
        if (e && (e.indexOf("tlink") > -1 || e.indexOf("baiduTlinkInlay") > -1 || e.indexOf("baiduCustSTagLinkUnit") > -1)) {
            f = "linkunit"
        }
        if (e && e.indexOf("float_xuanfuwin") > -1) {
            f = "xuanfuwin"
        }
        switch (f.toLowerCase()) {
            case"inlay":
                g = 4;
                break;
            case"linkunit":
                g = 6;
                break;
            case"float":
                g = 2;
                break;
            case"xuanfuwin":
                g = 1;
                break;
            case"ui":
                g = 3;
                if (e == "baiduDEFINE") {
                    g = 4
                }
                if (e == "baiduTpclickedDEFINE" || e == "baiduTpclickedDEFINE_mob") {
                    g = 30
                }
                break;
            default:
                g = 3;
                break
        }
        h.__bdcpro__displayTypeCounter = h.__bdcpro__displayTypeCounter || {};
        h.__bdcpro__displayTypeCounter[f] = h.__bdcpro__displayTypeCounter[f] || 0;
        if (h.__bdcpro__displayTypeCounter[f] >= g) {
            d = true
        }
        return d
    }, addAdsCounter: function (e, f, d) {
        if (d && (d.indexOf("tlink") > -1 || d.indexOf("baiduTlinkInlay") > -1 || d.indexOf("baiduCustSTagLinkUnit") > -1)) {
            e = "linkunit"
        }
        if (d && d.indexOf("float_xuanfuwin") > -1) {
            e = "xuanfuwin"
        }
        f.__bdcpro__displayTypeCounter = f.__bdcpro__displayTypeCounter || {};
        f.__bdcpro__displayTypeCounter[e] = f.__bdcpro__displayTypeCounter[e] || 0;
        f.__bdcpro__displayTypeCounter[e]++;
        return true
    }, getAdsWrapArray: function (e) {
        var d = [];
        if (e && typeof e == "string") {
            var j = e.split(",");
            var g = 0;
            for (var f = 0, h = j.length; f < h; f++) {
                if (/u\d+/.test(j[f]) && !this.adsWrapStore[j[f]]) {
                    d[g] = j[f];
                    g++;
                    this.adsWrapStore[j[f]] = true
                }
            }
        }
        return d
    }, getLinkUnitMaxCount: function (i) {
        var h = parseInt(i.get("titFS"));
        var l = parseInt(i.get("conBW"));
        var d = parseInt(i.get("rsi0")) - 2 * l;
        var m = parseInt(i.get("rsi1")) - 2 * l;
        var f = 7;
        var e = f * h;
        var g = h + 6;
        var k = 7;
        var n = e + 2 * k;
        var j = g;
        return{VerticalCount: Math.floor(d / n), HorizontalCount: Math.floor(m / j)}
    }, initParam: function (d) {
        if (!this.U.isInIframe()) {
            return
        }
        var d = d || window;
        this.currentWindowOnUnloadHandler = this.U.proxy(this.currentWindowOnUnload, this, [d]);
        this.U.bind(d, "beforeunload", this.currentWindowOnUnloadHandler)
    }, currentWindowOnUnload: function (d) {
        this.clientTree = {};
        this.displayCounter = 1;
        var d = d || window;
        this.U.unBind(d, "beforeunload", this.currentWindowOnUnloadHandler)
    }, checkFloatLu: function (h) {
        var d = {"test.com": true, "people.com.cn": true, "chinanews.com": true, "cri.cn": true, "chinadaily.com": true, "cnki.com.cn": true, "cnki.net": true, "ku6.com": true, "tgbus.com": true, "5068.com": true, "yzz.cn": true, "aipai.com": true, "stockstar.com": true};
        h = h || window;
        var g = "";
        var e = h.document.domain.split(".");
        var f = e.length;
        if (f && f > 2) {
            if (e[f - 1] === "cn" && e[f - 2] === "com") {
                g = e[f - 3] + "." + e[f - 2] + "." + e[f - 1]
            } else {
                g = e[f - 2] + "." + e[f - 1]
            }
        } else {
            if (f) {
                g = h.document.domain
            }
        }
        if (g && d[g]) {
            return false
        }
        return true
    }, noop: function () {
    }};
    b.registerNamespace(c)
})(window[___baseNamespaceName]);
(function (b) {
    var a = {fullName: "$baseName.BusinessLogic.Param", version: "1.0.0", register: function () {
        this.G = b.using("$baseName", this.win);
        this.U = b.using("$baseName.Utility", this.win);
        this.BL = b.using("$baseName.BusinessLogic", this.win)
    }, initialize: function (c) {
        this.currentWindow = c.currentWindow;
        this.doc = this.win.document;
        this.nav = this.win.navigator;
        this.scr = this.win.screen;
        this.displayType = c.displayType || "inlay";
        this.startTime = (new Date());
        this.BL.pnTypeArray = this.BL.pnTypeArray || [];
        this.BL.pnTypeArray[this.displayType] = this.BL.pnTypeArray[this.displayType] || [];
        this.timeStamp = c.timeStamp || (new Date()).getTime()
    }, getSlot2UIMapping: function (e) {
        var d = {};
        var c;
        for (c in e) {
            if (c && e[c] && e[c].slotParamName) {
                d[e[c].slotParamName] = c
            }
        }
        return d
    }, getCust2UIMapping: function (e) {
        var d = {};
        var c;
        for (c in e) {
            if (c && e[c] && e[c].custParamName) {
                d[e[c].custParamName] = c
            }
        }
        return d
    }, mergeSlot2UI: function (f, e, d) {
        if (!f || !e || !d) {
            return null
        }
        var c, g;
        for (g in e) {
            if (g && e[g] && e.hasOwnProperty(g)) {
                c = d[g];
                if (c) {
                    f.set(c, e[g])
                }
            }
        }
        return f
    }, serialize: function (f) {
        var e = [];
        var d, c;
        for (d in f) {
            if (d && f[d] && (typeof f[d] === "object") && f[d].isUIParam && f[d].isUIParam[f.displayType]) {
                if (d === "pn" && !f.get(d)) {
                    continue
                }
                c = f.get(d);
                if (c == null) {
                    continue
                }
                if (f.displayType == "ui" && c == "baiduCADS") {
                    continue
                }
                if (f[d].encode || f.displayType == "ui") {
                    c = encodeURIComponent(c)
                }
                if (f[d].limit) {
                    c = c.substr(0, f[d].limit)
                }
                e.push(d + "=" + c)
            }
        }
        return e.join("&")
    }, snap: function (f) {
        var e = {};
        var d, c;
        for (d in f) {
            if (d && f[d] && (typeof f[d] === "object") && f[d].defaultValue) {
                c = f.get(d);
                if (c == null) {
                    continue
                }
                if (f[d].encode || f.displayType == "ui") {
                    c = encodeURIComponent(c)
                }
                e[d] = c
            }
        }
        return e
    }, get: function (e) {
        var c;
        if (!this[e]) {
            return c
        }
        if (this[e].get && this[e].get !== "default") {
            var d = Array.prototype.slice.call(arguments, 0);
            d.shift();
            if (!this[e]._init) {
                this[e]._value = this[e].defaultValue[this.displayType]
            }
            c = this.U.proxy(this[e].get, this, d)()
        } else {
            if (!this[e]._init) {
                c = this[e].defaultValue[this.displayType]
            } else {
                c = this[e]._value
            }
        }
        return c
    }, set: function (e, f) {
        var c = false;
        if (this[e].set && this[e].set !== "default") {
            var d = Array.prototype.slice.call(arguments, 0);
            d.shift();
            c = this.U.proxy(this[e].set, this, d)()
        } else {
            this[e]._value = f;
            this[e]._init = true;
            c = true
        }
        return c
    }, k: {slotParamName: "k", custParamName: "k", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: ""}, encode: false, isUIParam: {inlay: false, "float": false, ui: true, post: false, custInlay: false, captcha: false}, get: "default", set: "default"}, cf: {slotParamName: "cf", custParamName: "cf", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: ""}, encode: false, isUIParam: {inlay: false, "float": false, ui: true, post: false, custInlay: false, captcha: false}, get: "default", set: "default"}, tp2jk: {slotParamName: "tp2jk", custParamName: "tp2jk", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: ""}, encode: false, isUIParam: {inlay: false, "float": false, ui: true, post: false, custInlay: false, captcha: false}, get: "default", set: "default"}, rs: {slotParamName: "cpro_rs", custParamName: "rs", modifier: "dynamic", defaultValue: {inlay: 0, "float": 0, ui: 0, post: 0, custInlay: 0, captcha: 0}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: false, custInlay: false, captcha: false}, get: "default", set: "default"}, tu: {slotParamName: "slotId", custParamName: "tu", modifier: "dynamic", defaultValue: {inlay: "", "float": "", captcha: ""}, encode: false, isUIParam: {inlay: true, "float": true, custInlay: true, captcha: true, ui: true}, get: "default", set: "default"}, tn: {slotParamName: "cpro_template", custParamName: "tn", modifier: "dynamic", defaultValue: {inlay: "text_default_125_125", "float": "float_xuanfusld_120_270", ui: null, post: null, custInlay: "baiduCust", captcha: "vcode_captchaF_254_218", pad: "pad_tiepian_400_300"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, n: {slotParamName: "cpro_client", custParamName: "n", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, adn: {slotParamName: "cpro_161", modifier: "dynamic", defaultValue: {inlay: "1", "float": "1", captcha: "1"}, encode: false, isUIParam: {inlay: true, "float": false, custInlay: true, captcha: false}, get: "default", set: "default"}, rsi1: {slotParamName: "cpro_h", custParamName: "h", modifier: "dynamic", defaultValue: {inlay: "125", "float": "270", ui: null, custInlay: null, captcha: "218", pad: null}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, rsi3: {slotParamName: "cpro_adw", custParamName: "adw", modifier: "dynamic", defaultValue: {pad: "430"}, encode: false, isUIParam: {inlay: false, "float": false, ui: false, custInlay: false, captcha: false, pad: true}, get: "default", set: "default"}, rsi4: {slotParamName: "cpro_adh", custParamName: "adh", modifier: "dynamic", defaultValue: {pad: "350"}, encode: false, isUIParam: {inlay: false, "float": false, ui: false, custInlay: false, captcha: false, pad: true}, get: "default", set: "default"}, rsi0: {slotParamName: "cpro_w", custParamName: "w", modifier: "dynamic", defaultValue: {inlay: "125", "float": "120", ui: null, custInlay: null, captcha: "254", pad: null}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, rsi2: {custParamName: "bu", modifier: "dynamic", defaultValue: {ui: null}, encode: true, isUIParam: {ui: true}, get: "default", set: "default"}, rad: {slotParamName: "cpro_rad", custParamName: "rad", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, post: null, custInlay: "", captcha: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true}, get: "default", set: "default"}, rss0: {slotParamName: "cpro_cbd", custParamName: "bd", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, custInlay: true, captcha: true}, get: "default", set: "default"}, rss1: {slotParamName: "cpro_cbg", custParamName: "bg", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, post: null, custInlay: "", captcha: "", pad: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, conOP: {slotParamName: "cpro_conOP", modifier: "dynamic", defaultValue: {inlay: 0}, encode: true, isUIParam: {inlay: true, "float": false, ui: false, post: false, custInlay: true, captcha: false}, get: "default", set: "default"}, rss2: {slotParamName: "cpro_ctitle", custParamName: "tt", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, post: null, custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, post: true, custInlay: true, captcha: true}, get: "default", set: "default"}, rss3: {slotParamName: "cpro_cdesc", custParamName: "ct", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, post: null, custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, post: true, custInlay: true, captcha: true}, get: "default", set: "default"}, rss4: {slotParamName: "cpro_curl", custParamName: "url", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, post: null, custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, post: true, custInlay: "", captcha: true}, get: "default", set: "default"}, rss5: {slotParamName: "cpro_clink", custParamName: "bdl", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: null, captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, ui: true, captcha: true}, get: "default", set: "default"}, rssl0: {custParamName: "ta", modifier: "dynamic", defaultValue: {ui: null, post: null}, encode: true, isUIParam: {ui: true, post: true}, get: "default", set: "default"}, rssl1: {custParamName: "tl", modifier: "dynamic", defaultValue: {ui: null, post: null}, encode: true, isUIParam: {ui: true, post: true}, get: "default", set: "default"}, rss6: {slotParamName: "cpro_cflush", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": false, custInlay: true, captcha: true}, get: "default", set: "default"}, rsi5: {slotParamName: "cpro_flush", custParamName: "nfr", modifier: "dynamic", defaultValue: {inlay: "4", "float": "", ui: null, custInlay: "4", captcha: "4"}, encode: false, isUIParam: {inlay: true, "float": false, ui: true, custInlay: true, captcha: true}, get: "default", set: "default"}, rsi6: {slotParamName: "cpro_ctoph", modifier: "dynamic", defaultValue: {inlay: -1, "float": -1}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, rsi7: {slotParamName: "cpro_ptoph", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0"}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, ts: {slotParamName: "cpro_ts", modifier: "dynamic", defaultValue: {inlay: "1", "float": "", captcha: "1"}, encode: false, isUIParam: {inlay: true, "float": false, captcha: true}, get: "default", set: "default"}, at: {slotParamName: "cpro_at", custParamName: "at", modifier: "dynamic", defaultValue: {inlay: "all", "float": "image_flash", ui: "", post: "", custInlay: "text_tuwen", captcha: "image_flash", pad: "image_flash"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var k = 0;
        var c = this["at"]._value;
        var e = new RegExp("(text){1}", "g");
        var h = new RegExp("(image){1}|(flash){1}", "g");
        var j = new RegExp("(image){1}_(flash){1}", "g");
        var f = new RegExp("(image){1}", "g");
        var g = new RegExp("(video){1}", "g");
        var i = new RegExp("(tuwen){1}", "g");
        var d = new RegExp("(all){1}", "g");
        if (this.displayType == "ui" && this["tn"]._value != "baiduCPROiknow") {
            if (e.test(c)) {
                k |= 1;
                k |= 64
            }
            if (f.test(c)) {
                k |= 2
            }
            if (j.test(c)) {
                k |= 2;
                k |= 4
            }
            if (i.test(c)) {
                k |= 32
            }
            return k
        }
        if (e.test(c)) {
            k |= 1;
            k |= 64
        }
        if (g.test(c)) {
            k |= 8
        }
        if (i.test(c)) {
            k |= 32
        }
        if (this["tn"]._value == "template_inlay_all_mobile") {
            if (f.test(c)) {
                k |= 2
            }
            if (d.test(c)) {
                k |= 99
            }
        } else {
            if (h.test(c)) {
                k |= 2;
                k |= 4
            }
            if (d.test(c)) {
                k |= 103
            }
        }
        if (this["n"]._value == "54009059_cpr") {
            k = 2
        }
        return k
    }, set: "default"}, ch: {slotParamName: "cpro_channel", custParamName: "channel", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0", ui: "0", custInlay: "0", captcha: "0", pad: "0"}, encode: true, isUIParam: {inlay: true, "float": true, ui: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, cad: {slotParamName: "cpro_cad", custParamName: "cad", modifier: "dynamic", defaultValue: {inlay: "1", "float": "1", ui: "0", post: "0", custInlay: "1", captcha: "1", pad: "1"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, aurl: {slotParamName: "cpro_aurl", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: "", captcha: "", pad: ""}, encode: true, isUIParam: {inlay: true, "float": true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, rss7: {slotParamName: "cpro_acolor", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: "", captcha: "", pad: ""}, encode: true, isUIParam: {inlay: true, "float": true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, cpa: {slotParamName: "cpro_uap", custParamName: "uap", modifier: "dynamic", defaultValue: {inlay: "1", "float": "0", ui: "0", custInlay: "1", captcha: "1", pad: "0"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, fv: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0", ui: "", post: "", custInlay: "0", captcha: "0", pad: "0"}, encode: true, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var c = "ShockwaveFlash.ShockwaveFlash", g = this.nav, d, h;
        if (this.nav.plugins && g.mimeTypes.length) {
            d = g.plugins["Shockwave Flash"];
            if (d && d.description) {
                return d.description.replace(/[^\d\.]/g, "").split(".")[0]
            }
        } else {
            if (this.U.browser.ie) {
                h = ActiveXObject;
                try {
                    d = new h(c + ".7")
                } catch (f) {
                    try {
                        d = new h(c + ".6");
                        d.AllowScriptAccess = "always";
                        return 6
                    } catch (f) {
                    }
                    try {
                        d = new h(c)
                    } catch (f) {
                    }
                }
                if (d != null) {
                    try {
                        return d.GetVariable("$version").split(" ")[1].split(",")[0]
                    } catch (f) {
                    }
                }
            }
        }
        return 0
    }, set: "default"}, cn: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        if (!this["n"] || !this["n"].get) {
            return 1
        }
        var c = 0;
        var d = this.get("n");
        var e = this.get("ch") || "0";
        if (d) {
            this.BL.clientTree = this.BL.clientTree || {};
            if (!this.BL.clientTree[d]) {
                c += 1;
                if (e && e !== "0") {
                    c += 2
                }
                return c
            }
            if (e && e !== "0" && this.BL.clientTree[d] && (!this.BL.clientTree[d][e])) {
                c += 2
            }
        }
        return c
    }, set: function () {
        var c = this.get("n");
        var d = this.get("ch") || "0";
        if (c) {
            this.BL.clientTree = this.BL.clientTree || {};
            if (!this.BL.clientTree[c]) {
                this.BL.clientTree[c] = {}
            }
            if (d && d !== "0" && (!this.BL.clientTree[c][d])) {
                this.BL.clientTree[c][d] = true
            }
        }
        return true
    }}, "if": {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0", ui: "0", post: "0", custInlay: "0", captcha: "0", pad: "0"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var d = 0;
        var g = this.currentWindow;
        if (this.U.isInIframe(g)) {
            d += 1
        }
        if (this.U.isInCrossDomainIframe(g, g.top)) {
            d += 2
        }
        if (!this["rsi0"] || !this["rsi0"].get || !this["rsi1"] || !this["rsi1"].get) {
            return d
        }
        var c = this.get("rsi0");
        var f = this.get("rsi1");
        var e = this.U.getClientWidth(this.currentWindow);
        var h = this.U.getClientHeight(this.currentWindow);
        if (e < 40 || h < 10) {
            d += 4
        } else {
            if (e < c || h < f) {
                d += 8
            }
        }
        if ((e >= 2 * c) || (h >= 2 * f)) {
            d += 16
        }
        return d
    }, set: "default"}, word: {slotParamName: "", custParamName: "", modifier: "dynamic", limit: 700, defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: true, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var j = this.currentWindow;
        var p, l = 10, c = 0;
        var g, m;
        if (window.dpClient && window.dpClientDomain) {
            return"http://" + window.dpClientDomain + "/domain_parking.htm?site=" + encodeURIComponent(window.location.href).substring(0, 700)
        }
        try {
            g = this.get("rsi0") || 0;
            m = this.get("rsi1") || 0
        } catch (k) {
            g = 200, m = 60
        }
        p = j.document.location.href;
        if (this.U.isInIframe(j)) {
            var d, f, e;
            for (c = 0; c < l; c++) {
                if (!this.U.isInCrossDomainIframe(j, j.parent)) {
                    d = this.U.getClientWidth(j);
                    f = this.U.getClientHeight(j);
                    e = j.document.location.href;
                    j = j.parent;
                    if (g > 0 && m > 0 && d > 2 * g && f > 2 * m) {
                        p = e;
                        break
                    }
                    if (!this.U.isInIframe(j, j.parent)) {
                        p = j.location.href;
                        break
                    }
                } else {
                    p = j.document.referrer || j.document.location.href;
                    break
                }
            }
            if (c >= 10) {
                p = j.document.referrer || j.document.location.href
            }
        }
        if (((p.search(/cpro.baidu.com/i) != -1) || (p.search(/\?hide=1/i) != -1)) && p.search(/t=tpclicked/i) != -1) {
            var o = p.indexOf("?");
            var p = p.substring(o + 1);
            var n = p.split("&");
            for (var h = 0; h < n.length; h++) {
                if (n[h].search(/^u=/i) != -1) {
                    p = n[h].replace(/^u=/i, "");
                    break
                }
            }
        }
        return p
    }, set: "default"}, refer: {slotParamName: "", custParamName: "", modifier: "dynamic", limit: 700, defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: true, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var c;
        try {
            c = this.win.opener ? this.win.opener.document.location.href : this.doc.referrer
        } catch (d) {
            c = this.doc.referrer
        }
        return this.U.escapeToEncode(c)
    }, set: "default"}, ready: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: ""}, encode: true, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true}, get: function () {
        var d = {uninitialized: 0, loading: 1, loaded: 2, interactive: 3, complete: 4};
        try {
            return d[this.doc.readyState]
        } catch (c) {
            return 5
        }
    }, set: "default"}, jk: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        if (!this["jk"]._value) {
            this["jk"]._value = this.U.md5(this.BL.randomArray.join("") + Math.random() * 1000000 + this.doc.location.href + this.doc.cookie);
            this["jk"]._init = true
        }
        return this["jk"]._value
    }, set: function () {
        this["jk"]._value = ""
    }}, jn: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "3", "float": "3", ui: "3", post: "3", custInlay: "3", captcha: "3", pad: "3"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return 3
    }, set: "default"}, js: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "c", "float": "f", ui: "ui", post: "post", custInlay: "custInlay", captcha: "y"}, encode: false, isUIParam: {inlay: false, "float": false, ui: true, post: true, custInlay: true, captcha: true}, get: "default", set: "default"}, lmt: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return Date.parse(this.doc.lastModified) / 1000
    }, set: "default"}, csp: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.scr.width + "," + this.scr.height
    }, set: "default"}, csn: {slotParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: "", captcha: ""}, encode: false, isUIParam: {inlay: true, "float": true, custInlay: true, captcha: true}, get: function () {
        return this.scr.availWidth + "," + this.scr.availHeight
    }, set: "default"}, ccd: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.scr.colorDepth || 0
    }, set: "default"}, chi: {slotParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.win.history.length || 0
    }, set: "default"}, cja: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.nav.javaEnabled().toString()
    }, set: "default"}, cpl: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.nav.plugins.length || 0
    }, set: "default"}, cmi: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.nav.mimeTypes.length || 0
    }, set: "default"}, cce: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return this.nav.cookieEnabled || 0
    }, set: "default"}, csl: {uuserApiName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return encodeURIComponent(this.nav.language || this.nav.browserLanguage || this.nav.systemLanguage).replace(/[^a-zA-Z0-9\-]/g, "")
    }, set: "default"}, did: {uuserApiName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "1", "float": "1", ui: "1", post: "1", custInlay: "1", captcha: "1", pad: "1"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        this.win.__bdcpro__displayTypeCounter = this.win.__bdcpro__displayTypeCounter || {};
        if (this.get("tn") && this.get("tn").toLowerCase().indexOf("tlink") > -1) {
            return this.win.__bdcpro__displayTypeCounter.lu_total || 1
        } else {
            return this.win.__bdcpro__displayTypeCounter.total || 1
        }
    }, set: function () {
        if (this.get("tn") && this.get("tn").toLowerCase().indexOf("tlink") > -1) {
            this.win.__bdcpro__displayTypeCounter.lu_total = this.win.__bdcpro__displayTypeCounter.lu_total || 1;
            this.win.__bdcpro__displayTypeCounter.lu_total++
        } else {
            this.win.__bdcpro__displayTypeCounter.total = this.win.__bdcpro__displayTypeCounter.total || 1;
            this.win.__bdcpro__displayTypeCounter.total++
        }
        return true
    }}, rt: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        var c = 0;
        if (this.startTime) {
            c = (new Date()).getTime() - this.startTime.getTime()
        }
        return c
    }, set: "default"}, dt: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: function () {
        return Math.round((new Date).getTime() / 1000)
    }, set: "default"}, pn: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", custInlay: "", captcha: ""}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, custInlay: true, captcha: true}, get: function () {
        var c = "";
        var f, j, h, k = [], d = [], g = [];
        var e = this.BL.pnTypeArray[this.displayType] = this.BL.pnTypeArray[this.displayType] || [];
        if (e && e.length > 0) {
            for (f = 0, j = e.length; f < j; f++) {
                h = e[f];
                if (!h || !h.name || !h.num || !h.at) {
                    continue
                }
                k.push(h.name);
                d.push(h.num);
                g.push(h.at)
            }
            c = d.join(":") + "|" + k.join(":") + "|" + g.join(":")
        }
        return c
    }, set: function (d, f, e) {
        var c = true;
        if (!d || !f || !e) {
            d = this.get("tn");
            if (this.displayType == "ui") {
                f = this.get("hn") * this.get("wn") || 0
            } else {
                f = this.get("adn") || 0
            }
            e = this.get("at") || 103
        }
        if (!d || !f || !e) {
            c = false
        } else {
            if (this.displayType != "ui" && this.BL.pnTypeArray[this.displayType].length == 2) {
                c = false
            } else {
                if (this.displayType == "ui" && this.BL.pnTypeArray[this.displayType].length == 3) {
                    c = false
                } else {
                    this.BL.pnTypeArray[this.displayType] = this.BL.pnTypeArray[this.displayType] || [];
                    this.BL.pnTypeArray[this.displayType].push({name: d, num: f, at: e})
                }
            }
        }
        return c
    }}, ev: {slotParamName: "", modifier: "dynamic", defaultValue: {inlay: "", "float": "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": true, captcha: true, pad: true}, get: function () {
        var c = this.get("adn");
        var d = this.get("tn");
        if (d && d.indexOf("tlink_default") > -1) {
            c = 0
        }
        c = c << 24;
        return c
    }, set: "default"}, c01: {slotParamName: "", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0", captcha: ""}, encode: false, isUIParam: {inlay: true, "float": true, captcha: true}, get: "default", set: "default"}, prt: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "0", "float": "0", ui: "0", post: "0", custInlay: "0", captcha: "0"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true}, get: function () {
        var e = 4 * 60 * 1000;
        var f = (new Date()).getTime();
        var d;
        var e = 4 * 60 * 1000;
        var c;
        try {
            window.top.location.toString();
            c = window.top
        } catch (g) {
            c = window
        }
        d = c.BAIDU_DUP2_pageFirstRequestTime;
        if (!d) {
            d = c.BAIDU_DUP2_pageFirstRequestTime = f
        } else {
            if (f - d >= e) {
                d = c.BAIDU_DUP2_pageFirstRequestTime = f
            }
        }
        return d || ""
    }, set: "default"}, fa: {slotParamName: "cpro_float", modifier: "dynamic", defaultValue: {inlay: 1, "float": 1, captcha: "1"}, encode: false, isUIParam: {inlay: false, "float": true, captcha: false}, get: "default", set: "default"}, ls: {slotParamName: "cpro_location", modifier: "dynamic", defaultValue: {inlay: 3, "float": 3}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, pt: {slotParamName: "cpro_position", modifier: "dynamic", defaultValue: {inlay: 1, "float": 1}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, flw: {slotParamName: "cpro_follow", modifier: "dynamic", defaultValue: {inlay: 1, "float": 1}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, ct: {slotParamName: "cpro_close", modifier: "dynamic", defaultValue: {inlay: 1, "float": 1}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, ccw: {slotParamName: "cpro_contw", modifier: "dynamic", defaultValue: {inlay: 900, "float": 900}, encode: false, isUIParam: {inlay: false, "float": true}, get: function () {
        if (typeof this["ccw"]._value === "undefined" || !this["ccw"]._value || this["ccw"]._value < 720) {
            return 10000
        } else {
            return this["ccw"]._value
        }
    }, set: "default"}, ww: {slotParamName: "cpro_clientw", modifier: "dynamic", defaultValue: {inlay: 4095, "float": 4095}, encode: false, isUIParam: {inlay: false, "float": true}, get: "default", set: "default"}, cm: {custParamName: "cm", modifier: "dynamic", defaultValue: {ui: 0, post: 0}, encode: true, isUIParam: {ui: true, post: true}, get: "default", set: "default"}, um: {custParamName: "um", modifier: "dynamic", defaultValue: {ui: 0, post: 0}, encode: true, isUIParam: {ui: true, post: true}, get: "default", set: "default"}, wn: {custParamName: "wn", modifier: "dynamic", defaultValue: {ui: null, post: null, custInlay: 1}, encode: true, isUIParam: {ui: true, post: true, custInlay: true}, get: "default", set: "default"}, tm: {custParamName: "tm", modifier: "dynamic", defaultValue: {ui: 0, post: 0}, encode: true, isUIParam: {ui: true, post: true}, get: "default", set: "default"}, func: {custParamName: "func", modifier: "dynamic", defaultValue: {ui: "renderBaiduCproAds"}, encode: true, isUIParam: {ui: true}, get: "default", set: "default"}, hn: {custParamName: "hn", modifier: "dynamic", defaultValue: {ui: null, post: null, custInlay: 4}, encode: true, isUIParam: {ui: true, post: true, custInlay: true}, get: "default", set: "default"}, ie: {custParamName: "charset", modifier: "dynamic", defaultValue: {ui: null, custInlay: "utf8"}, encode: true, isUIParam: {ui: true, custInlay: true}, get: function () {
        if (typeof(this["ie"]._value) == "string") {
            switch (this["ie"]._value.toLowerCase()) {
                case"gb2312":
                case"gbk":
                    return"0";
                    break;
                case"utf8":
                case"utf-8":
                    return"1";
                    break;
                default:
                    return null;
                    break
            }
        }
    }, set: "default"}, i3: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "p", "float": "p", ui: "p", post: "p", custInlay: "p", captcha: "p"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true}, get: function () {
        var c = "p";
        switch (window.___is3b) {
            case"loading":
                c = "l";
                break;
            case"true":
                c = "t";
                break;
            case"false":
                c = "f";
                break;
            default:
                c = "p";
                break
        }
        return c
    }, set: "default"}, anatp: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: 0, "float": 0, ui: 0, post: 0, custInlay: 0, captcha: 0}, encode: false, isUIParam: {inlay: true, "float": true, ui: false, post: false, custInlay: false, captcha: false}, get: "default", set: "default"}, stid: {slotParamName: "cpro_stid", custParamName: "", modifier: "dynamic", defaultValue: {inlay: 0, "float": 0, ui: 0, post: 0, custInlay: 0, captcha: 0}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: false, custInlay: false, captcha: false}, get: function () {
        try {
            if (this.displayType === "ui") {
                var f = this.currentWindow;
                if (!this.U.isInIframe(f)) {
                    var c = document.location.href;
                    var e = this.U.getPara(c)["stid"];
                    if (e) {
                        return e
                    }
                }
            }
            if (this.BL.checkFloatLu && this.BL.checkFloatLu(this.win) && this.G.BusinessLogic.Distribute.dispatch("floatLu", {displayType: this.displayType, displayWidth: this.get("rsi0"), displayHeight: this.get("rsi1")})) {
                if (this.G.BusinessLogic.Distribute.dispatch("floatLuShow", {displayType: this.displayType, displayWidth: this.get("rsi0"), displayHeight: this.get("rsi1")})) {
                    return 2
                } else {
                    return 1
                }
            } else {
                return this["stid"]._value
            }
        } catch (d) {
            return this["stid"]._value
        }
    }, set: "default"}, distp: {slotParamName: "", custParamName: "", modifier: "dynamic", defaultValue: {inlay: "1001", "float": "2001", ui: "1001", post: "1001", custInlay: "1001", pad: "3001", captcha: "4001"}, encode: false, isUIParam: {inlay: true, "float": true, ui: true, post: true, custInlay: true, captcha: true, pad: true}, get: "default", set: "default"}, lunum: {slotParamName: "cpro_lunum", custParamName: "", modifier: "dynamic", defaultValue: {inlay: 0, "float": 0, ui: 0, post: 0, custInlay: 0, captcha: 0}, encode: false, isUIParam: {inlay: true, "float": true, ui: false, post: false, custInlay: false, captcha: false}, get: function () {
        if ((typeof this["lunum"]._value !== "undefined") && (typeof this["lunum"]._init !== "undefined")) {
            this["lunum"]._value = parseInt(this["lunum"]._value);
            if (this["lunum"]._value > 0) {
                return 6
            } else {
                return 0
            }
        } else {
            try {
                if (this.BL.checkFloatLu && this.BL.checkFloatLu(this.win) && this.G.BusinessLogic.Distribute.dispatch("floatLu", {displayType: this.displayType, displayWidth: this.get("rsi0"), displayHeight: this.get("rsi1")})) {
                    if (this.G.BusinessLogic.Distribute.dispatch("floatLuShow", {displayType: this.displayType, displayWidth: this.get("rsi0"), displayHeight: this.get("rsi1")})) {
                        return 6
                    }
                } else {
                    if (this.displayType === "inlay") {
                        return 6
                    }
                }
            } catch (c) {
            }
            return 0
        }
    }, set: "default"}, scale: {slotParamName: "cpro_scale", custParamName: "scale", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": false, ui: false, post: false, custInlay: false, captcha: false, pad: false}, get: "default", set: "default"}, skin: {slotParamName: "cpro_skin", custParamName: "skin", modifier: "dynamic", defaultValue: {inlay: "", "float": "", ui: "", post: "", custInlay: "", captcha: "", pad: ""}, encode: false, isUIParam: {inlay: true, "float": false, ui: false, post: false, custInlay: false, captcha: false, pad: false}, get: "default", set: "default"}, noop: {custParamName: "", modifier: "dynamic", defaultValue: {ui: null, post: null}, encode: false, isUIParam: {ui: false, post: false}, get: "default", set: "default"}};
    b.registerClass(a)
})(window[___baseNamespaceName]);
(function (b) {
    var a = {fullName: "$baseName.BusinessLogic.Distribute", version: "1.0.0", register: function () {
        this.G = b.using("$baseName", this.win);
        this.U = b.using("$baseName.Utility", this.win)
    }, status: {}, viewtime: 100, viewtimeIE: 100, floatLu: {percent: 100, displayType: "float", displayWidth: "120", displayHeight: "270"}, floatLuShow: {percent: 100, displayType: "float", displayWidth: "120", displayHeight: "270"}, dispatch: function (i, d) {
        if (this.U.isInCrossDomainIframe()) {
            return false
        }
        var c = i;
        if (d) {
            for (var e in d) {
                if (e && d[e]) {
                    c += "_" + d[e].toString()
                }
            }
        }
        if (this.status[c + "Dispatched"]) {
            return this.status[c]
        }
        this.status[c] = false;
        this.status[c + "Dispatched"] = true;
        var g = 0;
        if ((typeof this[i]).toLowerCase() === "object") {
            var f = this[i];
            g = f.percent;
            if (f.displayType) {
                if (!d.displayType || f.displayType !== d.displayType) {
                    return false
                }
            }
            if (f.displayWidth) {
                if (!d.displayWidth || f.displayWidth !== d.displayWidth) {
                    return false
                }
            }
            if (f.displayHeight) {
                if (!d.displayHeight || f.displayHeight !== d.displayHeight) {
                    return false
                }
            }
        } else {
            if ((typeof this[i]).toLowerCase() === "number") {
                g = this[i]
            }
        }
        var h = parseInt(Math.random() * 100);
        if (g && h < g) {
            this.status[c] = true
        }
        return this.status[c]
    }};
    b.registerClass(a)
})(window[___baseNamespaceName]);
(function (b) {
    var a = {fullName: "$baseName.BusinessLogic.ViewWatch", version: "1.0.0", register: function () {
        this.G = b.using("$baseName", this.win);
        this.U = b.using("$baseName.Utility", this.win);
        this.BL = b.using("$baseName.BusinessLogic", this.win)
    }, analysisUrl: "http://eclick.baidu.com/a.js", longTime: 7200000, uiParamMapping: {tu: "tu", did: "did", tn: "tn", word: "word", jk: "jk", "if": "if", rsi0: "aw", rsi1: "ah", ch: "ch", n: "n", js: "js", dt: "dt"}, viewContextParamMapping: {pageStayTime: "pt", pageStayTimeStamp: "ps", inViewTime: "it", inViewTimeStamp: false, currViewStatus: "vs", focusTime: "ft", adViewTime: "vt", currAdViewStatus: false, adViewTimeStamp: false}, clientParamMapping: {opacity: "op", desktopResolution: "csp", browserRegion: "bcl", pageRegion: "pof", top: "top", left: "left", focusSwitch: "fs"}, lastVisitedUrl: {currentIndex: 0, sendIndex: 0, maxSize: 10, paramTimeName: "lvt", paramUrlName: "lvu", paramValue: []}, isIEWatchFocus: true, focusSwitch: true, watchArrayPointer: null, intervalId: null, intervalTimeSpan: 500, intervalStatus: "wait", initialize: function () {
        this.watchArrayPointer = this.BL.adsArray
    }, initializeDOM: function () {
    }, initializeEvent: function () {
        this.windowOnLoad();
        var c = this.U.proxy(this.windowOnLoadDelay, this);
        this.U.ready(c, 2000);
        this.U.bind(this.win, "beforeunload", this.U.proxy(this.windowOnUnload, this))
    }, calculateClientParam: function (f, g, e) {
        f.clientParam = f.clientParam || {};
        var d = this.U.getPosition(g);
        f.clientParam.left = d.left || 0;
        f.clientParam.top = d.top || 0;
        f.clientParam.opacity = this.U.getOpacity(g);
        var h = e.screen.availWidth;
        var c = e.screen.availHeight;
        if (h > 10000) {
            h = 0
        }
        if (c > 10000) {
            c = 0
        }
        f.clientParam.desktopResolution = h + "," + c;
        f.clientParam.browserRegion = this.U.getClientWidth(e) + "," + this.U.getClientHeight(e);
        f.clientParam.pageRegion = this.U.getScrollWidth(e) + "," + this.U.getScrollHeight(e);
        f.clientParam.focusSwitch = this.focusSwitch
    }, updateViewStatus: function (c, f, e) {
        var h = new Date();
        var d = pageTimeSpan = this.intervalTimeSpan;
        var g = d;
        if (this.intervalStatus === "load") {
            this.intervalStatus = "run";
            d = pageTimeSpan = 0;
            g = pageTimeSpan = 0
        }
        if (c.currViewStatus) {
            if (this.intervalStatus === "unload") {
                d = parseInt(h.getTime() - c.inViewTimeStamp.getTime());
                if (d < 0) {
                    d = 0
                } else {
                    if (d > this.intervalTimeSpan) {
                        d = this.intervalTimeSpan
                    }
                }
            }
            c.inViewTime += d;
            c.inViewTimeStamp = h;
            if (c.inViewTime > this.longTime) {
                c.inViewTime = this.longTime
            }
        } else {
            if (f) {
                c.inViewTimeStamp = h
            }
        }
        c.currViewStatus = f;
        if (c.currAdViewStatus) {
            if (this.intervalStatus === "unload") {
                g = parseInt(h.getTime() - c.adViewTimeStamp.getTime());
                if (g < 0) {
                    g = 0
                } else {
                    if (g > this.intervalTimeSpan) {
                        g = this.intervalTimeSpan
                    }
                }
            }
            c.adViewTime += g;
            c.adViewTimeStamp = h;
            if (c.adViewTime > this.longTime) {
                c.adViewTime = this.longTime
            }
        } else {
            if (e) {
                c.adViewTimeStamp = h
            }
        }
        c.currAdViewStatus = e;
        c.pageStayTime = c.pageStayTime || 0;
        if (this.intervalStatus === "unload") {
            pageTimeSpan = parseInt(h.getTime() - c.pageStayTimeStamp.getTime());
            if (pageTimeSpan < 0) {
                pageTimeSpan = 0
            } else {
                if (pageTimeSpan > this.intervalTimeSpan) {
                    pageTimeSpan = this.intervalTimeSpan
                }
            }
        }
        c.pageStayTime += pageTimeSpan;
        if (this.BL.winFocused) {
            c.focusTime += pageTimeSpan
        }
        c.pageStayTimeStamp = h;
        if (c.pageStayTime >= this.longTime) {
            c.pageStayTime = this.longTime
        }
        return c
    }, viewableCompute: function () {
        var t, f;
        for (t = 0, f = this.watchArrayPointer.length; t < f; t++) {
            var u = this.watchArrayPointer[t];
            var c, m = u.win, l = u.domId;
            if (m && l) {
                c = m.document.getElementById(l)
            }
            if (!c) {
                continue
            }
            if (!u.viewContext) {
                var g = new Date();
                u.viewContext = {pageStayTime: 0, pageStayTimeStamp: g, inViewTime: 0, inViewTimeStamp: g, currViewStatus: false, focusTime: 0, adViewTime: 0, currAdViewStatus: false, adViewTimeStamp: g, offlineConditionIndex: 0}
            }
            var y = false;
            var s = false;
            if (!this.BL.winFocused) {
                y = false;
                s = false
            } else {
                try {
                    var p = this.U.getClientWidth(this.win);
                    var e = this.U.getClientHeight(this.win);
                    var w = this.U.getPosition(l, m);
                    var d = this.U.getScrollTop(this.win);
                    var q = this.U.getScrollLeft(this.win);
                    var n = this.U.getOuterWidth(c);
                    var o = this.U.getOuterHeight(c);
                    var h = w.top - d + o * 0.35;
                    var k = w.left - q + n * 0.35;
                    y = h > 0 && h < e;
                    y = y && (k > 0 && k < p);
                    h = w.top - d;
                    k = w.left - q;
                    var r = n * o;
                    var x = (e - h) > o ? o : e - h;
                    var j = (p - k) > n ? n : p - k;
                    s = x * j > 0.5 * r ? true : false
                } catch (v) {
                    y = false;
                    s = false;
                    continue
                }
            }
            u.viewContext = this.updateViewStatus(u.viewContext, y, s);
            u.analysisUrl = this.buildAnalysisUrl(this.analysisUrl, u, c)
        }
    }, buildAnalysisUrl: function (c, h, g) {
        if (!c || !h) {
            return
        }
        var d = c + "?";
        var e = h.uiParamSnap, j = [];
        for (var f in this.uiParamMapping) {
            if (f && this.uiParamMapping[f] && e[f]) {
                j.push(this.uiParamMapping[f] + "=" + e[f])
            }
        }
        d += j.join("&");
        d += "&" + this.U.param(h.viewContext, this.viewContextParamMapping);
        if (!h.clientParam || !h.clientParam.pageRegion) {
            try {
                this.calculateClientParam(h, g, h.win)
            } catch (i) {
            }
        }
        if (h.clientParam) {
            d += "&" + this.U.param(h.clientParam, this.clientParamMapping)
        } else {
            for (var k in this.clientParamMapping) {
                if (k && this.clientParamMapping[k]) {
                    d += "&" + this.clientParamMapping[k] + "="
                }
            }
        }
        return d
    }, viewOnChange: function () {
        this.viewableCompute();
        if (this.watchArrayPointer[0].viewContext.pageStayTime >= this.longTime) {
            this.windowOnUnload(false)
        }
    }, windowOnLoad: function (g) {
        var c, d, f = new Date();
        for (c = 0, d = this.watchArrayPointer.length; c < d; c++) {
            this.watchArrayPointer[c].viewContext = {pageStayTime: 0, pageStayTimeStamp: f, inViewTime: 0, inViewTimeStamp: f, currViewStatus: false, focusTime: 0, adViewTime: 0, currAdViewStatus: false, adViewTimeStamp: f, offlineConditionIndex: 0}
        }
        this.intervalStatus = "load";
        this.focusSwitch = this.winFocusBlurOnChange(this.win, this.isIEWatchFocus);
        if (!this.U.browser.ie || (this.U.browser.ie && this.U.browser.ie > 6)) {
            this.viewOnChange()
        }
        this.intervalId = setInterval(this.U.proxy(this.viewOnChange, this), this.intervalTimeSpan)
    }, windowOnLoadDelay: function (o) {
        var s = this.win.document.getElementsByTagName("a");
        var k = s.length || 0;
        var f = [];
        if (this.U.isInIframe()) {
            f = window.document.getElementsByTagName("a")
        }
        var q = k + f.length;
        var d = false;
        if (this.U.browser.ie && this.U.browser.ie <= 7 && q > 500) {
            d = false
        } else {
            if (q < 1000) {
                d = true
            }
        }
        if (d) {
            for (var j = 0; j < q; j++) {
                var c = this;
                var g;
                if (j - k >= 0 && f[j - k]) {
                    g = f[j - k]
                } else {
                    if (s[j]) {
                        g = s[j]
                    }
                }
                if (!g) {
                    continue
                }
                this.U.bind(g, "click", function () {
                    var i, t, u;
                    var i = window.event ? window.event : arguments[0];
                    if (i) {
                        t = i.target || i.srcElement;
                        if (t && t.href) {
                            u = t.href
                        } else {
                            return
                        }
                    } else {
                        return
                    }
                    var e = c.lastVisitedUrl.currentIndex;
                    c.lastVisitedUrl.paramValue[e] = {};
                    c.lastVisitedUrl.paramValue[e].url = encodeURIComponent(u).substring(0, 300);
                    c.lastVisitedUrl.paramValue[e].time = ((new Date()).getTime()).toString();
                    if (e < c.lastVisitedUrl.maxSize - 1) {
                        c.lastVisitedUrl.sendIndex = c.lastVisitedUrl.currentIndex;
                        c.lastVisitedUrl.currentIndex++
                    } else {
                        c.lastVisitedUrl.sendIndex = c.lastVisitedUrl.currentIndex;
                        c.lastVisitedUrl.currentIndex = 0
                    }
                })
            }
        }
        var j, l, h = new Date(), p, n, r, m;
        for (j = 0, l = this.watchArrayPointer.length; j < l; j++) {
            var p = this.watchArrayPointer[j];
            if (!p) {
                continue
            }
            r = p.win;
            m = p.domId;
            if (r && m) {
                n = r.document.getElementById(m)
            }
            if (!n) {
                continue
            }
            p.clientParam = p.clientParam || {};
            this.calculateClientParam(p, n, r)
        }
    }, windowOnUnload: function (m) {
        try {
            clearInterval(this.intervalId);
            if (document.domain.toLowerCase().indexOf("autohome.com.cn") > -1 || document.domain.toLowerCase().indexOf("sina.com.cn") > -1 || document.domain.toLowerCase().indexOf("pconline.com.cn") > -1 || document.domain.toLowerCase().indexOf("pcauto.com.cn") > -1 || document.domain.toLowerCase().indexOf("pclady.com.cn") > -1 || document.domain.toLowerCase().indexOf("pcgames.com.cn") > -1 || document.domain.toLowerCase().indexOf("pcbaby.com.cn") > -1 || document.domain.toLowerCase().indexOf("pchouse.com.cn") > -1 || document.domain.toLowerCase().indexOf("xcar.com.cn") > -1) {
                return
            }
            if (this.intervalStatus !== "run") {
                this.intervalStatus = "unload";
                return
            }
            this.intervalStatus = "unload";
            var g, f, k, p, n, c;
            this.viewableCompute();
            for (g = 0, k = this.watchArrayPointer.length; g < k; g++) {
                p = this.watchArrayPointer[g];
                if (p && p.analysisUrl && !p.isSended) {
                    p.isSended = true;
                    if (g == 0) {
                        p.analysisUrl += "&total=" + this.watchArrayPointer.length
                    }
                    var j = this.lastVisitedUrl.sendIndex;
                    if (j < 0) {
                        j = this.lastVisitedUrl.maxSize - 1;
                        this.lastVisitedUrl.sendIndex = j
                    }
                    if (this.lastVisitedUrl && this.lastVisitedUrl.paramValue && j < this.lastVisitedUrl.paramValue.length) {
                        p.analysisUrl += "&" + this.lastVisitedUrl.paramUrlName + "1=" + this.lastVisitedUrl.paramValue[j].url;
                        p.analysisUrl += "&" + this.lastVisitedUrl.paramTimeName + "1=" + this.lastVisitedUrl.paramValue[j].time;
                        this.lastVisitedUrl.sendIndex--;
                        j--;
                        if (j < 0) {
                            j = this.lastVisitedUrl.maxSize - 1;
                            this.lastVisitedUrl.sendIndex = j
                        }
                        if (this.lastVisitedUrl && this.lastVisitedUrl.paramValue && j < this.lastVisitedUrl.paramValue.length) {
                            p.analysisUrl += "&" + this.lastVisitedUrl.paramUrlName + "2=" + this.lastVisitedUrl.paramValue[j].url;
                            p.analysisUrl += "&" + this.lastVisitedUrl.paramTimeName + "2=" + this.lastVisitedUrl.paramValue[j].time;
                            this.lastVisitedUrl.sendIndex--;
                            j--
                        }
                    }
                    this.U.sendRequestViaImage(p.analysisUrl, this.win)
                }
            }
            if (m) {
                var h = 200;
                var l = (new Date()).getTime();
                var d;
                if (this.U.browser.ie) {
                    d = l + h;
                    while (d > l) {
                        l = (new Date()).getTime()
                    }
                } else {
                    var k = 100000;
                    for (var g = 0; g < k; g++) {
                    }
                    d = (new Date()).getTime();
                    k = 100000 * h / (d - l);
                    k = k > 10000000 ? 10000000 : k;
                    for (var g = 0; g < k; g++) {
                    }
                }
            }
        } catch (o) {
        }
    }, winFocusBlurOnChange: function (e) {
        var c = false, e = e || this.win;
        this.BL.winFocused = true;
        var f = this.U.proxy(function (g) {
            this.BL.winFocused = true
        }, this);
        var d = this.U.proxy(function (g) {
            this.BL.winFocused = false
        }, this);
        if (this.U.browser.ie || this.U.browser.maxthon) {
            this.U.bind(e, "focusin", f);
            this.U.bind(e, "focusout", d);
            c = true
        } else {
            this.U.bind(e, "focus", f);
            this.U.bind(e, "blur", d);
            c = true
        }
        return c
    }, getInstance: function () {
        if (!this.instances || this.instances.length < 1) {
            this.instances = [];
            var c = this.G.create(this);
            this.instances.push(c)
        }
    }};
    b.registerClass(a)
})(window[___baseNamespaceName]);
(function (b) {
    var a = {fullName: "$baseName.UI.FloatAds_new", version: "1.0.0", register: function () {
        this.G = b.using("$baseName", this.win);
        this.U = b.using("$baseName.Utility", this.win);
        this.BL = b.using("$baseName.BusinessLogic", this.win)
    }, floatConfig: {1: {y_r: 1, y_d: 150}, 2: {y_r: 0, y_d: 40}, 3: {y_r: 0, y_d: 0}}, uiParams: null, initialize: function (c) {
        this.iframeId = c.iframeId;
        this.iframeUrl = c.iframeUrl;
        this.domId = this.iframeId + "holder";
        this.paramSnap = c.paramSnap;
        this.floatType = parseInt(c.floatType);
        this.floatLocation = parseInt(c.floatLocation);
        this.floatPosition = parseInt(c.paramSnap.pt);
        this.floatFollow = parseInt(c.paramSnap.flw);
        this.templateName = c.paramSnap.tn;
        this.adWrapWidth = parseInt(this.paramSnap.rsi0);
        this.adWrapHeight = parseInt(this.paramSnap.rsi1);
        this.adIframeWidth = parseInt(this.paramSnap.rsi0);
        this.adIframeHeight = parseInt(this.paramSnap.rsi1);
        this.lunum = parseInt(this.paramSnap.lunum);
        if (this.lunum > 0 && this.BL.checkFloatLu && this.BL.checkFloatLu(this.win) && this.G.BusinessLogic.Distribute.dispatch("floatLu", {displayType: "float", displayWidth: this.adWrapWidth, displayHeight: this.adWrapHeight})) {
            if (this.G.BusinessLogic.Distribute.dispatch("floatLuShow", {displayType: "float", displayWidth: this.adWrapWidth, displayHeight: this.adWrapHeight})) {
                this.adWrapHeight = parseInt(this.paramSnap.rsi1) + 80;
                this.adIframeHeight = parseInt(this.paramSnap.rsi1) + 80
            }
        } else {
            this.adWrapHeight = parseInt(this.paramSnap.rsi1) + 20
        }
        this.closeBtnPadding = this.floatType == 1 ? 0 : 5;
        this.adWrapWidth = this.adWrapWidth + 10;
        this.adWrapHeight = this.adWrapHeight + 10;
        this.adIframeWidth = this.adIframeWidth + 10;
        this.adIframeHeight = this.adIframeHeight + 10;
        this.templateConfig = this.floatConfig;
        this.closeType = c.paramSnap.ct;
        this.tu = c.paramSnap.tu;
        this.jk = c.paramSnap.jk;
        this.canFixed = this.U.canFixed()
    }, initializeEvent: function (c) {
        this.U.ready(this.U.proxy(this.render, this));
        this.U.bind(this.win, "resize", this.U.proxy(this.setPositionOnChange, this));
        this.U.bind(this.win, "scroll", this.U.proxy(this.setPositionOnChange, this))
    }, getFloatMode: function () {
        var c = 2;
        if (this.floatFollow === 1) {
            if (this.canFixed) {
                if (this.floatPosition === 1) {
                    c = 4
                } else {
                    c = 3
                }
            } else {
                if (this.floatPosition === 1) {
                    c = 2
                } else {
                    c = 1
                }
            }
        } else {
            if (this.floatPosition === 1) {
                c = 6
            } else {
                c = 5
            }
        }
        return c
    }, getFloatMinTop: function () {
        var c = parseInt(this.paramSnap.rsi7);
        c = (c < 0 || c > 9999) ? 0 : Math.floor(c);
        return c
    }, getFollowMinTop: function () {
        var c = parseInt(this.paramSnap.rsi6);
        c = (c < 0 || c > 9999) ? this.templateConfig[this.floatType].y_d : Math.floor(c);
        return c
    }, getCustomerPageWidth: function () {
        var c = parseInt(this.paramSnap.ccw);
        if (c > 4095) {
            c = 4095
        }
        c = Math.floor(c);
        return c
    }, setPositionOnChange: function (c) {
        if (this.setPositionTimer) {
            clearTimeout(this.setPositionTimer)
        }
        this.setPositionTimer = setTimeout(this.U.proxy(this.setPositionEventHandler, this), 50)
    }, setPositionEventHandler: function (c) {
        var d = document.getElementById(this.domId);
        if (d) {
            this.setPosition(d)
        }
    }, setPosition: function (x) {
        if (this.canFixed) {
            if ((this.floatType === 1 || this.floatType === 2) && this.floatFollow === 2) {
                x.style.position = "absolute"
            } else {
                x.style.position = "fixed"
            }
        } else {
            x.style.position = "absolute"
        }
        var r = this.U.getScrollTop(window);
        var k = this.U.getScrollLeft(window);
        var t = this.U.getClientWidth(window);
        var h = this.U.getClientHeight(window);
        var d = this.adWrapWidth;
        var g = this.adWrapHeight + this.closeBtnPadding;
        var j = this.templateConfig[this.floatType].y_r;
        var p = this.templateConfig[this.floatType].y_d;
        var q = this.U.getStyle(document.body, "position").toString();
        var w = this.U.getStyle(document.body, "width").toString().replace("px", "");
        var z = this.getFloatMode();
        var e, f, n = "left", y = "right";
        var v, u;
        var m = this.getFloatMinTop();
        var c = this.getFollowMinTop();
        var i = this.getCustomerPageWidth();
        var o = this.U.getPosition(document.body).left;
        v = Math.floor((t - i) / 2) - d - 10;
        v = (v >= 0 && z % 2 == 0) ? v : 10;
        switch (z) {
            case 1:
            case 2:
                if (q == "relative" && w != "auto" && t > w) {
                    f = t - v - d - o;
                    e = k + v - o
                } else {
                    f = k + t - v - d;
                    e = k + v
                }
                y = "left";
                if (1 == j) {
                    u = (h >= g + c) ? (r + c) : (r + h - g)
                } else {
                    u = (h >= g + c) ? (r + h - c - g) : r
                }
                u = Math.max(u, m);
                break;
            case 3:
            case 4:
                e = f = v;
                if (1 == j) {
                    u = (h >= g + c) ? c : (h - g);
                    u = Math.max(u, m - r)
                } else {
                    u = Math.min((r + h - m - g), c);
                    u = Math.min(u, (h - g))
                }
                break;
            case 5:
            case 6:
                if (q == "relative" && w != "auto" && t > w) {
                    f = t - (t - w) / 2 - v - d;
                    e = k + v - (t - w) / 2
                } else {
                    f = k + t - v - d;
                    e = k + v
                }
                y = "left";
                if (1 == j) {
                    u = c
                } else {
                    u = (h >= g + c) ? (h - c - g) : 0
                }
                u = Math.max(u, m);
                break;
            default:
                e = f = 10
        }
        if (z % 4 == 1 || z % 4 == 2) {
            j = 1
        }
        var l = j ? "top" : "bottom", s;
        if (this.floatLocation === 1) {
            s = x.style;
            s[n] = e + "px";
            s[l] = u + "px";
            s.visibility = "visible"
        } else {
            if (this.floatLocation === 2) {
                s = x.style;
                s[y] = f + "px";
                s[l] = u + "px";
                s.visibility = "visible"
            }
        }
    }, btnCloseOnClick: function (f) {
        var i = document.getElementById(this.domId);
        if (this.closeType == 2) {
            var h = "bd_close_" + this.tu;
            var g = this.U.getCookieRaw(h, this.win);
            if (!g) {
                g = this.floatLocation
            } else {
                g = g | this.floatLocation
            }
            this.U.setCookieRaw(h, g, {path: "/"})
        }
        document.body.removeChild(i);
        var d = "http://eclick.baidu.com/fcb.jpg?jk={jk}&dt={dt}&rnd={rnd}";
        var c = {jk: this.jk || "", dt: new Date().getTime(), rnd: Math.floor(Math.random() * 2147483648)};
        try {
            this.U.sendRequestViaImage(this.U.template(d, c), this.win)
        } catch (f) {
        }
    }, btnCloseOnMouseover: function (g) {
        var f = document.getElementById(this.iframeId + "CloseBtn");
        if (this.floatType == 1) {
            f.style.backgroundColor = "#0066cc"
        } else {
            var c = f.getElementsByTagName("div")[0];
            c.style.backgroundColor = "#0066cc";
            var d = f.getElementsByTagName("a")[0];
            d.style.backgroundImage = "url(http://cpro.baidustatic.com/cpro/ui/noexpire/img/2.0.0/xuanfu_mouseover_close.png)"
        }
    }, btnCloseOnMouseout: function (g) {
        var f = document.getElementById(this.iframeId + "CloseBtn");
        if (this.floatType == 1) {
            f.style.backgroundColor = "#999999"
        } else {
            var c = f.getElementsByTagName("div")[0];
            c.style.backgroundColor = "#999999";
            var d = f.getElementsByTagName("a")[0];
            d.style.backgroundImage = "url(http://cpro.baidustatic.com/cpro/ui/noexpire/img/2.0.1/xuanfu_close.png)"
        }
    }, render: function () {
        var q = this.paramSnap.tn;
        var c = document.createElement("div");
        var m = this.floatType == 1 ? 2147483646 : 2147483647;
        c.style.cssText = "maring:0;padding:0;display:block;visibility:visible;border:none;background:none;float:none;overflow:hidden;position:absolute;z-index:" + m + ";width:" + this.adWrapWidth + "px;height:" + (this.adWrapHeight + this.closeBtnPadding) + "px";
        c.id = this.domId;
        var p = "";
        var l = document.createElement("div");
        l.id = this.iframeId + "CloseBtnWrap";
        var d = document.createElement("div");
        d.id = this.iframeId + "CloseBtn";
        if (this.floatType == 1) {
            l.style.cssText = "position:absolute;top:275px;left:0;cursor:pointer;width:" + this.adWrapWidth + "px;height:28px;z-index:100;opacity:0;filter:alpha(opacity=0);background-color:#999999;";
            d.style.cssText = "position:absolute;width:" + this.adWrapWidth + "px;height:20px;top:280px;left:0;cursor:pointer;background-color:#999999;color:#fff;font-size:12px;font-family: \u5FAE\u8F6F\u96C5\u9ED1;text-align: center;line-height:20px;";
            d.innerHTML = "\u5173\u95ED"
        } else {
            l.style.cssText = "position:absolute;top:0px;left:" + (this.adWrapWidth - 61) + "px;cursor:pointer;width:61px;height:20px;z-index:100;opacity:0;filter:alpha(opacity=0);background-color:#999999;margin:0;paddong:0;";
            d.style.cssText = "position:absolute;width:61px;height:20px;top:0;left:" + (this.adWrapWidth - 61) + "px;margin:0;padding:0;margin-bottom:5px;cursor:pointer;overflow:hidden;";
            d.innerHTML = '<div style="width:40px;height:20px;background-color:#999999;color:#fff;float:left;margin-right:1px;font-size:12px;font-family:\u5FAE\u8F6F\u96C5\u9ED1;;text-align: center;line-height:20px;">\u5173\u95ED</div><a style="maring:0;padding:0;display:inline-block;border:none;overflow:hidden;height:20px;line-height:20px;cursor:pointer;width:20px;background:url(\'http://cpro.baidustatic.com/cpro/ui/noexpire/img/2.0.1/xuanfu_close.png\') no-repeat 0 0;margin-bottom:3px;float:left" ></a>';
            p = "position:absolute;left:0;top:25px;"
        }
        c.appendChild(l);
        c.appendChild(d);
        var n = document.createElement("div");
        n.style.cssText = "width:" + this.adIframeWidth + "px;height:" + this.adIframeHeight + "px;overflow:hidden;" + p;
        iframeHtmlTemplate = '<div style="display:none">-</div> <iframe id="{iframeId}" src="{cproServiceUrl}?{paramString}" width="{iframeWidth}" height="{iframeHeight}" align="center,center" marginwidth="0"  marginheight="0" scrolling="no" frameborder="0" allowtransparency="true" ></iframe></div>';
        this.iframeUrl = this.iframeUrl + "&adclass=1&conW=" + this.adIframeWidth + "&conH=" + this.adIframeHeight;
        var e = {iframeId: this.iframeId, paramString: this.iframeUrl, iframeWidth: this.adIframeWidth, iframeHeight: this.adIframeHeight, cproServiceUrl: this.BL.cproServiceUrl};
        n.innerHTML = this.U.template(iframeHtmlTemplate, e);
        c.appendChild(n);
        this.setPosition(c);
        var j = document.body.children, k = j.length, o = j.length < 10 ? j.length : 10, h = document.body.lastChild;
        for (var g = 0; g < o; g++) {
            var f = j[k - g - 1].getAttribute("data-baidu-dan-id");
            if (!!f || f === "") {
                h = j[k - g - 1];
                break
            }
        }
        h.parentNode.insertBefore(c, h);
        l.onclick = this.U.proxy(this.btnCloseOnClick, this);
        l.onmouseover = this.U.proxy(this.btnCloseOnMouseover, this);
        l.onmouseout = this.U.proxy(this.btnCloseOnMouseout, this)
    }};
    b.registerClass(a)
})(window[___baseNamespaceName]);
(function (a) {
    var b = {fullName: "$baseName.UI.FloatAds", version: "1.0.0", register: function () {
        this.G = a.using("$baseName", this.win);
        this.U = a.using("$baseName.Utility", this.win);
        this.BL = a.using("$baseName.BusinessLogic", this.win)
    }, floatConfig: {css: {all: "maring:0;padding:0;display:block;visibility:visible;border:none;background:none;float:none;overflow:hidden;", main: "position:absolute;z-index:2147483647;", cont: "width:100%;height:100%;", close: "height:20px;line-height:20px;position:absolute;text-decoration:none;color:#333333;text-align:left;font-size:14px;font-family:simsun,arial;cursor:pointer;background:#fff;filter:alpha(opacity=0);opacity:0;"}, float_xuanfusld_126_360: {width: 126, height: 360, y_r: 1, y_d: 150, css: {main: "width:126px;height:360px;line-height:360px;", cont: "", close: "width:53px;right:0px;bottom:0px;height:20px;margin-bottom:61px; margin-right:5px;"}}, float_xuanfusld_120_270: {width: 124, height: 299, y_r: 1, y_d: 150, css: {main: "width:124px;height:299px;line-height:299px;", cont: "", close: "width:50px;right:0px;bottom:0px;"}}, float_xuanfusld_120_600: {width: 124, height: 629, y_r: 1, y_d: 50, css: {main: "width:124px;height:629px;line-height:629px;", cont: "", close: "width:50px;right:0px;bottom:0px;"}}, float_xuanfubtn_100_100: {width: 104, height: 129, y_r: 0, y_d: 40, css: {main: "width:104px;height:129px;line-height:129px;", cont: "", close: "width:30px;right:0px;bottom:0px;"}}, float_xuanfuwin_300_250: {width: 306, height: 276, y_r: 0, y_d: 0, css: {main: "width:306px;height:276px;line-height:276px;", cont: "", close: "width:60px;right:0px;top:0px;"}}, float_xuanfuwin_250_200: {width: 256, height: 226, y_r: 0, y_d: 0, css: {main: "width:256px;height:226px;line-height:226px;", cont: "", close: "width:60px;right:0px;top:0px;"}}, float_xuanfubtn_120_120: {width: 124, height: 149, y_r: 0, y_d: 40, css: {main: "width:124px;height:149px;line-height:149px;", cont: "", close: "width:50px;right:0px;bottom:0px;"}}}, uiParams: null, initialize: function (c) {
        this.iframeId = c.iframeId;
        this.iframeUrl = c.iframeUrl;
        this.domId = this.iframeId + "holder";
        this.paramSnap = c.paramSnap;
        this.floatType = parseInt(c.floatType);
        this.floatLocation = parseInt(c.floatLocation);
        this.floatPosition = parseInt(c.paramSnap.pt);
        this.floatFollow = parseInt(c.paramSnap.flw);
        this.templateName = c.paramSnap.tn;
        if (this.BL.checkFloatLu && this.BL.checkFloatLu(this.win) && this.G.BusinessLogic.Distribute.dispatch("floatLu", {displayType: "float", displayWidth: this.paramSnap.rsi0, displayHeight: this.paramSnap.rsi1})) {
            if (this.G.BusinessLogic.Distribute.dispatch("floatLuShow", {displayType: "float", displayWidth: this.paramSnap.rsi0, displayHeight: this.paramSnap.rsi1})) {
                this.templateName = "float_xuanfusld_126_360"
            }
        }
        this.templateConfig = this.floatConfig[this.templateName];
        this.closeType = c.paramSnap.ct;
        this.tu = c.paramSnap.tu;
        this.jk = c.paramSnap.jk;
        this.canFixed = this.U.canFixed()
    }, initializeEvent: function (c) {
        this.U.ready(this.U.proxy(this.render, this));
        this.U.bind(this.win, "resize", this.U.proxy(this.setPositionOnChange, this));
        this.U.bind(this.win, "scroll", this.U.proxy(this.setPositionOnChange, this))
    }, getFloatMode: function () {
        var c = 2;
        if (this.floatFollow === 1) {
            if (this.canFixed) {
                if (this.floatPosition === 1) {
                    c = 4
                } else {
                    c = 3
                }
            } else {
                if (this.floatPosition === 1) {
                    c = 2
                } else {
                    c = 1
                }
            }
        } else {
            if (this.floatPosition === 1) {
                c = 6
            } else {
                c = 5
            }
        }
        return c
    }, getFloatMinTop: function () {
        var c = parseInt(this.paramSnap.rsi7);
        c = (c < 0 || c > 9999) ? 0 : Math.floor(c);
        return c
    }, getFollowMinTop: function () {
        var c = parseInt(this.paramSnap.rsi6);
        c = (c < 0 || c > 9999) ? this.templateConfig.y_d : Math.floor(c);
        return c
    }, getCustomerPageWidth: function () {
        var c = parseInt(this.paramSnap.ccw);
        if (c > 4095) {
            c = 4095
        }
        c = Math.floor(c);
        return c
    }, setPositionOnChange: function (c) {
        if (this.setPositionTimer) {
            clearTimeout(this.setPositionTimer)
        }
        this.setPositionTimer = setTimeout(this.U.proxy(this.setPositionEventHandler, this), 50)
    }, setPositionEventHandler: function (c) {
        var d = document.getElementById(this.domId);
        if (d) {
            this.setPosition(d)
        }
    }, setPosition: function (x) {
        if (this.canFixed) {
            if ((this.floatType === 1 || this.floatType === 2) && this.floatFollow === 2) {
                x.style.position = "absolute"
            } else {
                x.style.position = "fixed"
            }
        } else {
            x.style.position = "absolute"
        }
        var r = this.U.getScrollTop(window);
        var k = this.U.getScrollLeft(window);
        var t = this.U.getClientWidth(window);
        var h = this.U.getClientHeight(window);
        var d = this.templateConfig.width;
        var g = this.templateConfig.height;
        var j = this.templateConfig.y_r;
        var p = this.templateConfig.y_d;
        var q = this.U.getStyle(document.body, "position").toString();
        var w = this.U.getStyle(document.body, "width").toString().replace("px", "");
        var z = this.getFloatMode();
        var e, f, n = "left", y = "right";
        var v, u;
        var m = this.getFloatMinTop();
        var c = this.getFollowMinTop();
        var i = this.getCustomerPageWidth();
        var o = this.U.getPosition(document.body).left;
        v = Math.floor((t - i) / 2) - d - 10;
        v = (v >= 0 && z % 2 == 0) ? v : 10;
        switch (z) {
            case 1:
            case 2:
                if (q == "relative" && w != "auto" && t > w) {
                    f = t - v - d - o;
                    e = k + v - o
                } else {
                    f = k + t - v - d;
                    e = k + v
                }
                y = "left";
                if (1 == j) {
                    u = (h >= g + c) ? (r + c) : (r + h - g)
                } else {
                    u = (h >= g + c) ? (r + h - c - g) : r
                }
                u = Math.max(u, m);
                break;
            case 3:
            case 4:
                e = f = v;
                if (1 == j) {
                    u = (h >= g + c) ? c : (h - g);
                    u = Math.max(u, m - r)
                } else {
                    u = Math.min((r + h - m - g), c);
                    u = Math.min(u, (h - g))
                }
                break;
            case 5:
            case 6:
                if (q == "relative" && w != "auto" && t > w) {
                    f = t - (t - w) / 2 - v - d;
                    e = k + v - (t - w) / 2
                } else {
                    f = k + t - v - d;
                    e = k + v
                }
                y = "left";
                if (1 == j) {
                    u = c
                } else {
                    u = (h >= g + c) ? (h - c - g) : 0
                }
                u = Math.max(u, m);
                break;
            default:
                e = f = 10
        }
        if (z % 4 == 1 || z % 4 == 2) {
            j = 1
        }
        var l = j ? "top" : "bottom", s;
        if (this.floatLocation === 1) {
            s = x.style;
            s[n] = e + "px";
            s[l] = u + "px";
            s.visibility = "visible"
        } else {
            if (this.floatLocation === 2) {
                s = x.style;
                s[y] = f + "px";
                s[l] = u + "px";
                s.visibility = "visible"
            }
        }
    }, btnCloseOnClick: function (f) {
        var i = document.getElementById(this.domId);
        if (this.closeType == 2) {
            var h = "bd_close_" + this.tu;
            var g = this.U.getCookieRaw(h, this.win);
            if (!g) {
                g = this.floatLocation
            } else {
                g = g | this.floatLocation
            }
            this.U.setCookieRaw(h, g, {path: "/"})
        }
        document.body.removeChild(i);
        var d = "http://eclick.baidu.com/fcb.jpg?jk={jk}&dt={dt}&rnd={rnd}";
        var c = {jk: this.jk || "", dt: new Date().getTime(), rnd: Math.floor(Math.random() * 2147483648)};
        try {
            this.U.sendRequestViaImage(this.U.template(d, c), this.win)
        } catch (f) {
        }
    }, render: function () {
        var j = this.paramSnap.tn;
        if (this.BL.checkFloatLu && this.BL.checkFloatLu(this.win) && this.G.BusinessLogic.Distribute.dispatch("floatLu", {displayType: "float", displayWidth: this.paramSnap.rsi0, displayHeight: this.paramSnap.rsi1})) {
            if (this.G.BusinessLogic.Distribute.dispatch("floatLuShow", {displayType: "float", displayWidth: this.paramSnap.rsi0, displayHeight: this.paramSnap.rsi1})) {
                j = "float_xuanfusld_126_360"
            }
        }
        var u = this.floatConfig.css;
        var m = this.floatConfig[j];
        var c = m.css;
        var s = m.width;
        var l = m.height;
        var n = document.createElement("div");
        var o = this.floatType == 1 ? 2147483646 : 2147483647;
        n.style.cssText = u.all + u.main + c.main + ";z-index:" + o;
        n.id = this.domId;
        var t = document.createElement("div");
        t.style.cssText = u.all + u.cont + c.cont;
        var e = '<div style="display:none">-</div> <iframe id="{iframeId}"src="{cproServiceUrl}?{paramString}" width="{iframeWidth}" height="{iframeHeight}" align="center,center" marginwidth="0"  marginheight="0" scrolling="no" frameborder="0" allowtransparency="true" ></iframe>';
        var h = {iframeId: this.iframeId, paramString: this.iframeUrl, iframeWidth: s, iframeHeight: l, cproServiceUrl: this.BL.cproServiceUrl};
        t.innerHTML = this.U.template(e, h);
        n.appendChild(t);
        var g = document.createElement("div");
        g.style.cssText = u.all + u.close + c.close;
        g.innerHTML = "&nbsp;";
        g.onclick = this.U.proxy(this.btnCloseOnClick, this);
        n.appendChild(g);
        this.setPosition(n);
        var r = document.body.children, f = r.length, d = r.length < 10 ? r.length : 10, k = document.body.lastChild;
        for (var q = 0; q < d; q++) {
            var p = r[f - q - 1].getAttribute("data-baidu-dan-id");
            if (!!p || p === "") {
                k = r[f - q - 1];
                break
            }
        }
        k.parentNode.insertBefore(n, k)
    }};
    a.registerClass(b)
})(window[___baseNamespaceName]);
(function (l) {
    var l = l;
    var f = l.using("$baseName.Utility");
    var i = l.using("$baseName.BusinessLogic");
    if (f.isInIframe(window)) {
        return false
    }
    var e;
    var b = "f";
    var g = "float";
    var j = "BAIDU_CPRO_SETJSONADSLOTFLOAT";
    var k = false;
    i.randomArray.push(Math.random() * 1000000);
    var a = function (o, p, m) {
        var n = o.createElement("script");
        n.type = "text/javascript";
        n.async = true;
        if (m) {
            n.onload = m;
            n.onreadystatechange = function () {
                (n.readyState === "loaded" || n.readyState === "complete") && m()
            }
        }
        n.src = p;
        o.body.insertBefore(n, o.body.firstChild)
    };
    var h = window[j] = function (D) {
        var B;
        for (B in D) {
            if (D.hasOwnProperty(B)) {
                var p = D[B];
                break
            }
        }
        if (p._isMlt && p._isMlt == 3) {
            var n = "baiduAdsInlay" + Math.floor(Math.random() * 10000000000000000);
            document.write('<div id="' + n + '"></div>');
            window.BAIDU_CLB_SLOTS_MAP = window.BAIDU_CLB_SLOTS_MAP || {};
            window.BAIDU_CLB_SLOTS_MAP[B] = p;
            if (window.BAIDU_DAN_showAdArray) {
                window.BAIDU_DAN_showAd ? window.BAIDU_DAN_showAd(B, n) : window.BAIDU_DAN_showAdArray.push([B, n])
            } else {
                window.BAIDU_DAN_showAdArray = window.BAIDU_DAN_showAdArray || [];
                window.BAIDU_DAN_showAdArray.push([B, n]);
                a(document, "http://cbjs.baidu.com/js/dn.js", function () {
                    while (window.BAIDU_DAN_showAdArray.length) {
                        var s = window.BAIDU_DAN_showAdArray.shift();
                        window.BAIDU_DAN_showAd(s[0], s[1])
                    }
                })
            }
            return
        }
        var S = {};
        var C = null;
        var v = {};
        var A = {};
        var T = {};
        var P = 0;
        i.randomArray.push(Math.random() * 1000000);
        S = i.parseSlotDataFromUnion(D);
        C = i.getSlotDataFromUserOpenApi();
        if (C) {
            P = 1;
            v = f.extend(S, C)
        } else {
            v = S
        }
        T = l.create(i.Param, {displayType: g, currentWindow: window, timeStamp: (new Date()).getTime()});
        A = i.Param.getSlot2UIMapping(T);
        T = i.Param.mergeSlot2UI(T, v, A);
        T.set("js", b);
        if (P) {
            T.set("c01", 1)
        }
        var x = i.getStyleApi(T.get("tu"), T, v, A);
        var R = T.get("rsi0");
        var y = T.get("rsi1");
        var Q = T.get("at");
        if (i.isPreview(R, y, g, Q)) {
            window.cpro_template = T.get("tn").toString();
            window.cpro_w = R.toString();
            window.cpro_h = y.toString();
            for (var E in T) {
                if (T[E] && typeof T[E] === "object" && T[E].slotParamName) {
                    if (isNaN(T[E]._value - 0)) {
                        window[T[E].slotParamName] = T[E]._value
                    } else {
                        window[T[E].slotParamName] = T[E]._value - 0
                    }
                }
            }
            window.cpro_at = T.at._value;
            var N = document.createElement("script");
            N.type = "text/javascript";
            N.async = true;
            N.src = "http://cpro.baidu.com/cpro/ui/floatPreview.js";
            var L = document.getElementsByTagName("script")[0];
            L.parentNode.insertBefore(N, L)
        } else {
            var O, J, o, K;
            var G, I;
            var u = false, q = false;
            if (i.checkAdsCounter(g, window, T.get("tn"))) {
                return
            }
            var m = T.get("ww") || 0;
            if (m > 4095) {
                m = 4095
            } else {
                m = Math.floor(m)
            }
            if (m >= screen.width) {
                return
            }
            var M = parseInt(T.get("ct"));
            if (M === 2) {
                var F = "bd_close_" + T.get("tu");
                var w = parseInt(f.getCookieRaw(F));
                if (!isNaN(w)) {
                    if ((w & 1) === 1) {
                        u = true
                    }
                    if ((w & 2) === 2) {
                        q = true
                    }
                }
            }
            var H = parseInt(T.get("fa"));
            var t = parseInt(100 * Math.random());
            var r = T.get("tn");
            floatAds = l.UI.FloatAds_new;
            if (T.get("tn").indexOf("float") != -1) {
                T.set("tn", "template_float_all_normal")
            }
            var z = parseInt(T.get("ls"));
            if (H === 1 || H === 2) {
                if ((z === 2 || z === 3) && !q) {
                    T.set("jk");
                    T.set("distp", "2002");
                    K = i.Param.serialize(T);
                    K += x || "";
                    I = i.Param.snap(T);
                    J = i.getAdsDomId(I.did || parseInt(100 + Math.random() * 1000));
                    l.create(floatAds, {iframeId: J, floatType: H, floatLocation: 2, iframeUrl: K, paramSnap: I});
                    i.adsArray.push({domId: J, uiParamSnap: I, win: window, js: b});
                    T.set("did");
                    T.set("cn");
                    T.set("pn")
                }
                if ((z === 1 || z === 3) && !u) {
                    T.set("jk");
                    T.set("distp", "2001");
                    o = i.Param.serialize(T);
                    o += x || "";
                    G = i.Param.snap(T);
                    O = i.getAdsDomId(G.did || parseInt(100 + Math.random() * 1000));
                    l.create(floatAds, {iframeId: O, floatType: H, floatLocation: 1, iframeUrl: o, paramSnap: G});
                    i.adsArray.push({domId: O, uiParamSnap: G, win: window, js: b});
                    T.set("did");
                    T.set("cn");
                    T.set("pn")
                }
            } else {
                if (!u && !q) {
                    T.set("jk");
                    z = z != 3 ? z : 2;
                    if (z == 1) {
                        T.set("distp", "2003")
                    } else {
                        T.set("distp", "2004")
                    }
                    K = i.Param.serialize(T);
                    K += x || "";
                    I = i.Param.snap(T);
                    J = i.getAdsDomId(I.did || parseInt(100 + Math.random() * 1000));
                    l.create(floatAds, {iframeId: J, floatType: H, floatLocation: z, iframeUrl: K, paramSnap: I});
                    i.adsArray.push({domId: J, uiParamSnap: I, win: window, js: b});
                    T.set("did");
                    T.set("cn");
                    T.set("pn")
                }
            }
            i.addAdsCounter(g, window, r);
            i.ViewWatch.getInstance()
        }
    };
    var d = window.BAIDU_CLB_CPROFSLOT = function (n, m) {
        var o = i.getSlotDataFromCB(n, m);
        if (o) {
            h(o)
        }
    };
    if (!f.browser.hasOwnProperty("isMobile") && !f.browser.hasOwnProperty("isTablet")) {
        f.browser.isMobile = (/iphone|ipod|android|blackberry|opera mini|opera mobi|skyfire|maemo|windows phone|palm|iemobile|symbian|symbianos|fennec/i.test(navigator.userAgent.toLowerCase()));
        f.browser.isTablet = (/ipad|android 3|sch-i800|playbook|tablet|kindle|gt-p1000|sgh-t849|shw-m180s|a510|a511|a100|dell streak|silk|SAMSUNG.*Tablet|Galaxy.*Tab|SC-01C|GT-P1000|GT-P1003|GT-P1010|GT-P3105|GT-P6210|GT-P6800|GT-P6810|GT-P7100|GT-P7300|GT-P7310|GT-P7500|GT-P7510|SCH-I800|SCH-I815|SCH-I905|SGH-I957|SGH-I987|SGH-T849|SGH-T859|SGH-T869|SPH-P100|GT-P3100|GT-P3108|GT-P3110|GT-P5100|GT-P5110|GT-P6200|GT-P7320|GT-P7511|GT-N8000|GT-P8510|SGH-I497|SPH-P500|SGH-T779|SCH-I705|SCH-I915|GT-N8013|GT-P3113|GT-P5113|GT-P8110|GT-N8010|GT-N8005|GT-N8020|GT-P1013|GT-P6201|GT-P7501|GT-N5100|GT-N5110|SHV-E140K|SHV-E140L|SHV-E140S|SHV-E150S|SHV-E230K|SHV-E230L|SHV-E230S|SHW-M180K|SHW-M180L|SHW-M180S|SHW-M180W|SHW-M300W|SHW-M305W|SHW-M380K|SHW-M380S|SHW-M380W|SHW-M430W|SHW-M480K|SHW-M480S|SHW-M480W|SHW-M485W|SHW-M486W|SHW-M500W|GT-I9228|SCH-P739|SCH-I925|GT-I9200|GT-I9205|GT-P5200|GT-P5210|SM-T311|SM-T310|SM-T210|SM-T211|SM-P900|IdeaTab|S2110|S6000|K3011|A3000|A1000|A2107|A2109|A1107/i.test(navigator.userAgent.toLowerCase()))
    }
    if ((screen.width < 1024) && (f.browser.isMobile && !f.browser.isTablet)) {
        return
    }
    if (b === "cf") {
        e = i.getSlotDataFromCB();
        if (e) {
            h(e);
            i.clearSlotDataFromCB()
        }
    } else {
        if (b === "f") {
            var c = window.cpro_id;
            if (c && /cpro_template=/gi.test(c)) {
                k = true;
                window[j]({"0": {_html: c}})
            } else {
                if (c) {
                    i.getSlotDataFromUnion(c, j)
                }
            }
            window.cpro_id = null
        }
    }
})(window[___baseNamespaceName]);
