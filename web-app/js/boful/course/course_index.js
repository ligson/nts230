/*! Copyright 2014 Baidu Inc. All Rights Reserved. */
;
(function () {
    var j = void 0, l = !0, o = null, q = !1;

    function v(d) {
        return function () {
            return d
        }
    }

    var y = "BAIDU_DUP2_require", A = "BAIDU_DUP2_define", C = ["search!"], ga = 3, D = document, F = {}, ha = 0, ia = 1, G = 2, H = 3, I = 4, ja = 5;

    function ka(d) {
        var g = la(d), c = g[0], g = g[1];
        this.id = d;
        this.name = g;
        this.uri = J(g);
        this.gc = !g;
        this.status = ha;
        c && g && (this.mc = K(L(c + "!")) || {load: function () {
        }});
        this.ba = []
    }

    var Q = window[y] || function (d, g, c) {
        O(d, function () {
            for (var b = [], a = 0; a < d.length; a++)b[a] = K(L(d[a]));
            P(g) && g.apply(window, b)
        }, c)
    };

    function O(d, g, c) {
        var b = d.length;
        if (0 === b)g(); else for (var a = b, f = 0; f < b; f++)(function (f) {
            function i() {
                if (f.status < G)e(); else {
                    for (var a = f.ba, i = [], b = 0; b < a.length; b++) {
                        var k = a[b];
                        k && L(k).status < H && i.push(k)
                    }
                    0 === i.length ? e() : O(i, e, c)
                }
            }

            function e() {
                f && f.status < H && (f.status = H);
                0 === --a && g()
            }

            var b = f.mc;
            b && (b.normalize && (f.name = b.normalize(f.name, J)), b.name2url && (f.uri = b.name2url(f.name)));
            f.status < G ? b && P(b.load) ? b.load(f.name, Q, function (a) {
                R(f.id, [], function () {
                    return a
                });
                e()
            }) : ma(f, i, c) : i()
        })(L(d[f]))
    }

    var S = {}, T = {}, U = {};

    function ma(d, g, c) {
        d.status = ia;
        U[d.id] ? g() : T[d.id] ? S[d.id].push(g) : (T[d.id] = l, S[d.id] = [g], c ? (g = d.uri, d = D.createElement("script"), d.charset = "utf-8", d.async = l, d.src = g, g = D.getElementsByTagName("head")[0] || D.body, g.insertBefore(d, g.firstChild)) : D.write('<script charset="utf-8" src="' + d.uri + '"><\/script>'))
    }

    var R = window[A] || function (d, g, c) {
        var b = L(d);
        b.status < G && (b.ba = g, b.factory = c, b.status = b.gc ? H : G);
        if (T[d]) {
            delete T[d];
            U[d] = l;
            g = S[d];
            for (delete S[d]; d = g.shift();)d()
        }
    };

    function K(d) {
        if (!d)return o;
        if (d.status >= I)return d.$a;
        if (d.status < H && d.$a === j)return o;
        d.status = I;
        for (var g = [], c = 0; c < d.ba.length; c++)g[c] = K(L(d.ba[c]));
        var b = c = d.factory;
        P(c) && (b = c.apply(window, g));
        d.status = ja;
        return d.$a = b
    }

    function J(d) {
        return/^https?:\/\//.test(d) ? d : "http://dup.baidustatic.com/painter/" + d + ".js"
    }

    function L(d) {
        return F[d] || (F[d] = new ka(d))
    }

    function la(d) {
        var g, c = d ? d.indexOf("!") : -1;
        -1 < c && (g = d.slice(0, c), d = d.slice(c + 1, d.length));
        return[g, d]
    }

    function P(d) {
        return"[object Function]" === Object.prototype.toString.call(d)
    }

    R("util/lang", [], function () {
        function d(c) {
            for (var b = {}, a = "Array Boolean Date Error Function Number RegExp String".split(" "), f = 0, h = a.length; f < h; f++)b["[object " + a[f] + "]"] = a[f].toLowerCase();
            return c == o ? "null" : b[Object.prototype.toString.call(c)] || "object"
        }

        var g = Object.prototype.hasOwnProperty;
        return{ea: g, c: d, getAttribute: function (c, b) {
            for (var a = c, f = b.split("."); f.length;) {
                if (a === j || a === o)return;
                a = a[f.shift()]
            }
            return a
        }, tb: function (c) {
            if ("object" !== d(c))return"";
            var b = [], a;
            for (a in c)g.call(c, a) &&
            b.push(a + "=" + encodeURIComponent(c[a]));
            return b.join("&")
        }, D: function (c) {
            var b = [];
            switch (d(c)) {
                case "object":
                    b = Array.prototype.slice.call(c);
                    break;
                case "array":
                    b = c;
                    break;
                case "number":
                case "string":
                    b.push(c)
            }
            return b
        }, unique: function (c) {
            for (var b = [], a = {}, f = c.length, h = 0; h < f; h++) {
                var i = c[h];
                a[i] || (b[b.length] = i, a[i] = l)
            }
            return b
        }, removeItem: function (c, b) {
            for (var a = [].slice.call(c), f = a.length - 1; 0 <= f; f--)a[f] === b && a.splice(f, 1);
            return a
        }, Sb: function (c, b) {
            var a = {"M+": c.getMonth() + 1, "d+": c.getDate(), "h+": 0 ===
                c.getHours() % 12 ? 12 : c.getHours() % 12, "H+": c.getHours(), "m+": c.getMinutes(), "s+": c.getSeconds(), "q+": Math.floor((c.getMonth() + 3) / 3), S: c.getMilliseconds()}, f = {"0": "\u65e5", 1: "\u4e00", 2: "\u4e8c", 3: "\u4e09", 4: "\u56db", 5: "\u4e94", 6: "\u516d"};
            /(y+)/.test(b) && (b = b.replace(RegExp.$1, (c.getFullYear() + "").substr(4 - RegExp.$1.length)));
            /(E+)/.test(b) && (b = b.replace(RegExp.$1, (1 < RegExp.$1.length ? 2 < RegExp.$1.length ? "\u661f\u671f" : "\u5468" : "") + f[c.getDay() + ""]));
            for (var h in a)RegExp("(" + h + ")").test(b) && (b = b.replace(RegExp.$1,
                1 == RegExp.$1.length ? a[h] : ("00" + a[h]).substr(("" + a[h]).length)));
            return b
        }, pb: function () {
        }}
    });
    R("util/browser", ["util/lang"], function (d) {
        var g = {}, c = navigator.userAgent, b = window.RegExp;
        /msie (\d+\.\d)/i.test(c) && (g.a = document.documentMode || +b.$1);
        /opera\/(\d+\.\d)/i.test(c) && (g.opera = +b.$1);
        /firefox\/(\d+\.\d)/i.test(c) && (g.Rb = +b.$1);
        /(\d+\.\d)?(?:\.\d)?\s+safari\/?(\d+\.\d+)?/i.test(c) && !/chrome/i.test(c) && (g.wc = +(b.$1 || b.$2));
        if (/chrome\/(\d+\.\d)/i.test(c)) {
            g.Wa = +b.$1;
            var a;
            try {
                a = "scoped"in document.createElement("style")
            } catch (f) {
                a = q
            }
            a && (g.sc = l)
        }
        try {
            /(\d+\.\d)/.test(d.getAttribute(window,
                "external.max_version")) && (g.jc = +b.$1)
        } catch (h) {
        }
        d = "Android iPad iPhone Linux Macintosh Windows".split(" ");
        b = "";
        for (a = 0; a < d.length && !(b = d[a], c.match(RegExp(b.toLowerCase(), "i"))); a++);
        g.platform = b;
        return g
    });
    R("util/dom", ["util/lang"], function (d) {
        function g(a) {
            try {
                if (a && "object" === typeof a && a.document && "setInterval"in a)return l
            } catch (b) {
            }
            return q
        }

        function c(a, b) {
            b = 2 === arguments.length ? b : a.parent;
            return a != b || !g(a)
        }

        function b(a, b) {
            for (var b = 2 === arguments.length ? b : a.parent, i = 0; 10 > i++ && c(a, b);) {
                var e;
                try {
                    e = !!a.parent.location.toString()
                } catch (k) {
                    e = q
                }
                if (!e)return l;
                a = a.parent
            }
            return 10 <= i ? l : q
        }

        function a(a) {
            return 9 === a.nodeType ? a : a.ownerDocument || a.document
        }

        return{e: function (a, b) {
            return"string" === d.c(a) &&
                0 < a.length ? (b || window).document.getElementById(a) : a.nodeName && (1 === a.nodeType || 9 === a.nodeType) ? a : o
        }, ga: g, k: c, j: b, P: a, u: function (b) {
            b = a(b);
            return b.parentWindow || b.defaultView || o
        }, A: function (b) {
            b = g(b) ? b.document : a(b);
            return"CSS1Compat" === b.compatMode ? b.documentElement : b.body
        }, Xb: function (a, d) {
            for (var d = d || 10, i = 0, a = a || window; i++ < d && c(a) && !b(a);)a = a.parent;
            return a
        }}
    });
    R("util/style", ["util/lang", "util/dom", "util/browser"], function (d, g, c) {
        function b(a, e) {
            if (!a)return"";
            var b = "", b = -1 < e.indexOf("-") ? e.replace(/[-][^-]{1}/g, function (e) {
                return e.charAt(1).toUpperCase()
            }) : e.replace(/[A-Z]{1}/g, function (e) {
                return"-" + e.charAt(0).toLowerCase()
            }), f = g.u(a);
            if (f && f.getComputedStyle) {
                if (f = f.getComputedStyle(a, o))return f.getPropertyValue(e) || f.getPropertyValue(b)
            } else if (a.currentStyle)return f = a.currentStyle, f[e] || f[b];
            return""
        }

        function a(a) {
            var e = {top: 0, left: 0};
            if (a === g.A(a))return e;
            var f = g.P(a), c = f.body, f = f.documentElement;
            a.getBoundingClientRect && (a = a.getBoundingClientRect(), e.left = Math.floor(a.left) + Math.max(f.scrollLeft, c.scrollLeft), e.top = Math.floor(a.top) + Math.max(f.scrollTop, c.scrollTop), e.left -= f.clientLeft, e.top -= f.clientTop, a = b(c, "borderLeftWidth"), c = b(c, "borderTopWidth"), a = parseInt(a, 10), c = parseInt(c, 10), e.left -= isNaN(a) ? 2 : a, e.top -= isNaN(c) ? 2 : c);
            return e
        }

        function f(a, e) {
            var f = b(a, "margin" + e).toString().toLowerCase().replace("px", "").replace("auto", "0");
            return parseInt(f,
                10) || 0
        }

        function h(a) {
            for (var e = g.u(a), b = 100; a && a.tagName;) {
                var f = 100;
                if (c.a) {
                    if (5 < c.a)try {
                        f = parseInt(d.getAttribute(a, "filters.alpha.opacity"), 10) || 100
                    } catch (h) {
                    }
                    b = b > f ? f : b
                } else {
                    try {
                        f = 100 * (e.getComputedStyle(a, o).opacity || 1)
                    } catch (s) {
                    }
                    b *= f / 100
                }
                a = a.parentNode
            }
            return 0 === b ? 0 : b || 100
        }

        return{l: b, T: a, z: function (b) {
            var e = g.e(b);
            if (!e)return q;
            b = a(e);
            e = g.u(e);
            if (!e)return b;
            for (var f = 0; e !== e.parent && 10 > f++ && !g.j(e) && e.frameElement;) {
                var c = a(e.frameElement);
                b.left += c.left;
                b.top += c.top;
                e = e.parent
            }
            return b
        },
            Sc: f, R: function (a, e) {
                var b = g.e(a), c = b.offsetWidth;
                e && (c += f(b, "Left") + f(b, "Right"));
                return c
            }, Q: function (a, e) {
                var b = g.e(a), c = b.offsetHeight;
                e && (c += f(b, "Top") + f(b, "Bottom"));
                return c
            }, va: h, fb: function (a) {
                for (var e = g.e(a), a = g.u(e), e = h(e), b = 0; 10 > b++ && g.k(a) && !g.j(a);) {
                    var f = a.frameElement ? h(a.frameElement) : 100, e = e * (f / 100);
                    a = a.parent
                }
                return e
            }, ya: function (a) {
                try {
                    var e = g.A(a || window).scrollWidth;
                    if (e || 0 === e)return e
                } catch (b) {
                }
                return-1
            }, wa: function (a) {
                try {
                    var e = g.A(a || window).scrollHeight;
                    if (e || 0 === e)return e
                } catch (b) {
                }
                return-1
            },
            o: function (a) {
                try {
                    var e = g.A(a || window).clientWidth;
                    if (e || 0 === e)return e
                } catch (b) {
                }
                return-1
            }, m: function (a) {
                try {
                    var e = g.A(a || window).clientHeight;
                    if (e || 0 === e)return e
                } catch (b) {
                }
                return-1
            }, U: function (a) {
                var e = g.A(a);
                return a.pageYOffset || e.scrollTop
            }, xa: function (a) {
                var e = g.A(a);
                return a.pageXOffset || e.scrollLeft
            }}
    });
    R("util/event", ["util/dom"], function (d) {
        return{bind: function (g, c, b) {
            if (g = d.ga(g) ? g : d.e(g))if (g.addEventListener)g.addEventListener(c, b, q); else if (g.attachEvent)g.attachEvent("on" + c, b); else {
                var a = g["on" + c];
                g["on" + c] = function () {
                    a && a.apply(this, arguments);
                    b.apply(this, arguments)
                }
            }
            return g
        }}
    });
    R("util/cookie", ["util/lang"], function (d) {
        return{get: function (d, c) {
            var b = RegExp("(^| )" + d + "=([^;]*)(;|$)").exec(document.cookie);
            return b ? c ? decodeURIComponent(b[2]) : b[2] : ""
        }, set: function (g, c, b, a) {
            var f = b.expires;
            "number" === d.c(f) && (f = new Date, f.setTime(+f + b.expires));
            document.cookie = g + "=" + (a ? encodeURIComponent(c) : c) + (b.path ? "; path=" + b.path : "") + (f ? "; expires=" + f.toGMTString() : "") + (b.domain ? "; domain=" + b.domain : "")
        }}
    });
    R("util/data", ["util/lang", "util/dom"], function (d, g) {
        function c(a, b, c) {
            var c = c ? i : f, h;
            if ("string" === d.c(a)) {
                for (a = a.split("."); a.length;)h = a.shift(), c[h] = a.length ? c[h] !== j ? c[h] : {} : b, c = c[h];
                h = b
            }
            return h
        }

        function b(a, b) {
            var c = b ? i : f, h;
            "string" === d.c(a) && (h = d.getAttribute(c, a));
            return h
        }

        function a(a, f, d) {
            if (!a || !f)return q;
            var h = b(a) || {};
            switch (d) {
                case "+1":
                    d = h[f] || 0;
                    h[f] = ++d;
                    break;
                default:
                    h[f] = parseInt(d, 10)
            }
            c(a, h);
            return h[f]
        }

        var f = {}, h = g.Xb(), i = h.BAIDU_DUP2_info || (h.BAIDU_DUP2_info = {});
        return{G: function (a, b) {
            var f = window;
            return f[a] ? f[a] : f[a] = b
        }, eb: function (a) {
            var b = window, f = b[a];
            b[a] = j;
            return f
        }, B: c, i: b, sb: function (a, b) {
            var c = b ? i : f;
            switch (d.c(a)) {
                case "string":
                    for (var h = a.split("."); h.length;) {
                        var g = h.shift();
                        if (h.length && c[g] !== j)c = c[g]; else return delete c[g], l
                    }
            }
            return q
        }, Ra: function (e, b) {
            return a(e, b, "+1")
        }, ad: function (e, b, f) {
            return a(e, b, f)
        }, count: a, Ub: function (a, f) {
            return!a || !f ? q : (b(a) || {})[f] || 0
        }, rc: function (a, f) {
            if (!a || !f)return q;
            var h = b("pageConfig") || {};
            h[a] = f;
            c("pageConfig", h);
            return l
        },
            Tb: function (a) {
                return!a ? q : (b("pageConfig") || {})[a]
            }}
    });
    R("util/storage", [], function () {
        function d(b, a, f) {
            if (c)try {
                c.setItem(b, f ? encodeURIComponent(a) : a)
            } catch (h) {
            }
        }

        function g(b, a) {
            if (c) {
                var f = c.getItem(b);
                return a && f ? decodeURIComponent(f) : f
            }
            return o
        }

        var c = window.localStorage;
        return{Jb: function () {
            var b = q;
            try {
                c.removeItem("BAIDU_DUP_storage_available"), d("BAIDU_DUP_storage_available", "1"), g("BAIDU_DUP_storage_available") && (b = l), c.removeItem("BAIDU_DUP_storage_available")
            } catch (a) {
            }
            return b
        }, setItem: d, getItem: g, Gb: function (b, a, f) {
            if (c) {
                a = f ? encodeURIComponent(a) :
                    a;
                f = g(b) || "";
                try {
                    d(b, f + ((f && "|") + a))
                } catch (h) {
                }
            }
        }, Ab: function (b, a, f) {
            if (c)if (a = f ? encodeURIComponent(a) : a, f = g(b) || "", f = f.replace(RegExp(a + "\\|?", "g"), "").replace(/\|$/, ""))try {
                d(b, f)
            } catch (h) {
            } else c.removeItem(b)
        }}
    });
    R("util/log", ["util/lang", "util/event", "util/storage"], function (d, g, c) {
        function b(b, c) {
            var d = new Image, e = "BAIDU_DUP_log_" + Math.floor(2147483648 * Math.random()).toString(36);
            window[e] = d;
            d.onload = d.onerror = d.onabort = function () {
                d.onload = d.onerror = d.onabort = o;
                d = window[e] = o;
                c && c(a, b, l)
            };
            d.src = b
        }

        var a = "BAIDU_DUP_log_storage";
        return{Wc: b, cd: function () {
            var f = c.getItem(a);
            if (f)for (var f = f.split("|"), d = 0, i = f.length; d < i; d++)b(decodeURIComponent(f[d]), c.Ab)
        }, ka: function (f) {
            var f = "object" === d.c(f) ? f : {}, h = f.url ||
                "http://cbjslog.baidu.com/log", i = f.option || "now", f = d.tb(f.data || {}), h = h + ((0 <= h.indexOf("?") ? "&" : "?") + f + (f ? "&" : "") + "rdm=" + +new Date);
            switch (i) {
                case "now":
                    b(h);
                    break;
                case "block":
                    break;
                default:
                    c.Gb(a, h, l), g.bind(window, "unload", function () {
                        b(h, c.Ab)
                    })
            }
        }}
    });
    R("util", "util/lang,util/dom,util/style,util/event,util/cookie,util/data,util/storage,util/log,util/browser".split(","), function (d, g, c, b, a, f, h, i, e) {
        return{lang: d, b: g, style: c, event: b, cookie: a, data: f, jd: h, log: i, d: e}
    });
    R("biz", ["util"], function (d) {
        function g(a) {
            var b = {}, e = "", f = window;
            try {
                e = f.top.location.search, "string" !== typeof e && (e = f.location.search)
            } catch (c) {
                e = f.location.search
            }
            e = e || "";
            0 === e.indexOf("?") && (e = e.substring(1));
            e = e.split("&");
            for (f = 0; f < e.length; f++) {
                var d = e[f].split("=");
                b[d[0]] = d[1]
            }
            g = function (a) {
                return b[a]
            };
            return b[a]
        }

        function c(a, b) {
            var e = /^[0-9a-zA-Z]+$/;
            return!a || !e.test(a) || !b ? [] : b = "array" === d.lang.c(b) ? b : Array.prototype.slice.call(arguments, 1)
        }

        function b(b, c, e) {
            if (!c || !c.length)return q;
            var e = e || {Oa: q, nb: q, qb: q}, k = e.nb ? d.data.i(a) : {}, g = e.Oa ? f : a, k = e.qb ? {} : d.data.i(g) || k, e = {}, m;
            for (m in k)d.lang.ea.call(k, m) && (e[m] = "array" === d.lang.c(k[m]) ? k[m].slice() : k[m]);
            var k = e[b] || [], s = c.length;
            for (m = 0; m < s; m++) {
                var t = c[m];
                "string" === typeof t && (t = encodeURIComponent(t), 100 >= t.length && (k[k.length] = t))
            }
            if (!k.length)return q;
            e[b] = d.lang.unique(k);
            d.data.B(g, e);
            return l
        }

        var a = "bizOrientations", f = "bizUrgentOrientations";
        return{$b: g, Sa: function (a, f) {
            var e = c.apply(this, arguments);
            return b(a, e)
        }, Hb: function (a, f) {
            var e = c.apply(this, arguments);
            return b(a, e, {Oa: l, nb: l})
        }, zc: function (a, f) {
            var e = c.apply(this, arguments);
            return b(a, e, {Oa: l, qb: l})
        }, Yb: function (b) {
            var b = Math.max(0, Math.min(b || 500, 500)), c = [], e = d.data.i(f) || d.data.i(a) || {};
            if ("object" === d.lang.c(e))for (var g in e)d.lang.ea.call(e, g) && (c[c.length] = g + "=" + e[g].join(","));
            d.data.B(f, j);
            c.sort(function (a, e) {
                return a.length - e.length
            });
            e = "";
            g = c.length;
            for (var n = 0; n < g && !(e.length + c[n].length >= b); n++)e += (n ? "&" : "") + c[n];
            return e
        }}
    });
    R("preview", ["biz", "util"], function (d, g) {
        function c() {
            var b = d.$b, a = b("baidu_clb_preview_sid") || b("baidu_dup_preview_sid"), f = b("baidu_clb_preview_mid") || b("baidu_dup_preview_mid"), c = b("baidu_clb_preview_vc") || b("baidu_dup_preview_vc"), b = +b("baidu_clb_preview_ts") || +b("baidu_dup_preview_ts");
            return 3E4 >= +new Date - b ? {zb: a, kc: f, Jc: c} : o
        }

        return{ac: function (b) {
            var a = [], f = c();
            f && b == f.zb && (a.push("mid=" + f.kc), a.push("sid=" + f.Jc));
            return a.join("&")
        }, i: c, lb: function (b) {
            var a = q;
            b ? /cpro_template=/gi.test(b) &&
                (g.data.B("#unionPreviewSwitch", l), a = l) : a = !!g.data.i("#unionPreviewSwitch");
            return a
        }, bc: function () {
            var b = g.data.i("#unionPreviewData");
            return b ? "prev=" + encodeURIComponent(b) + "&pt=union" : ""
        }, Cc: function (b) {
            g.data.B("#unionPreviewData", b)
        }, Nc: function () {
            g.data.sb("#unionPreviewSwitch");
            g.data.sb("#unionPreviewData")
        }}
    });
    R("slot", ["util"], function (d) {
        function g() {
            for (var a = {response: {}, holder: "", stack: [], errors: [], status: {}}, b = e.length - 1; 0 <= b; b--)a.status[e[b]] = 0;
            return a
        }

        function c(a, e) {
            var b = q;
            "fillAsync" === e && (b = l);
            m[a] && -1 !== m[a].stack.join(" ").toLowerCase().indexOf("async") && (b = l);
            return b
        }

        function b(a, e) {
            if (!a)return"";
            var b = s + a;
            e && (b += "_" + e);
            return b
        }

        function a(a, e, b) {
            if (!a || !e)return q;
            b === j && (b = +new Date);
            return m[a] ? (m[a].status[e] = b, l) : q
        }

        function f(a, e) {
            h(a, "errors", e)
        }

        function h(a, e, b) {
            a && e && b && (a = m[a]) &&
                "array" === d.lang.c(a[e]) && a[e].push(b)
        }

        function i(a) {
            return!a ? m : m[a] || q
        }

        var e = "add,create,request,response,render,finish".split(","), k = [], n = {}, m = {}, s = "BAIDU_DUP_wrapper_";
        return{add: function () {
            var e = {ids: [], preloadIds: []}, b = d.lang.D(arguments);
            if (!b.length)return e;
            for (var b = b.join(",").split(","), f = [], c = [], h = b.length, s = 0; s < h; s++) {
                var u = b[s];
                if (n.hasOwnProperty(u)) {
                    var w = u + "_" + n[u], x = i(w).stack || [];
                    if ("preload" === x[x.length - 1]) {
                        e.preloadIds.push(w);
                        continue
                    }
                    n[u] += 1
                } else n[u] = 0;
                u = u + "_" + n[u];
                m[u] = new g;
                a(u, "add");
                c.push(u);
                f.push(u)
            }
            k = k.concat(c);
            e.ids = f;
            return e
        }, create: function (e, h, i) {
            if (!e || !h)return q;
            var g = b(e), k = l;
            if (d.b.e(g))return m[e].holder = g, k;
            if (c(e, h)) {
                i = i || "";
                m[e].holder = i;
                i = d.b.e(i);
                try {
                    i && (i.innerHTML = '<div id="' + g + '"></div>', m[e].holder = g)
                } catch (n) {
                    f(e, "Failed to insert wrapper"), k = q
                }
            } else if (document.write('<div id="' + g + '"></div>'), !d.b.e(g))try {
                var s = document.getElementsByTagName("script"), w = s[s.length - 1];
                if (w) {
                    var x = w.parentNode;
                    if (x) {
                        var V = document.createElement("div");
                        V.id =
                            b(e, "b");
                        x.insertBefore(V, w)
                    }
                }
            } catch (oa) {
                f(e, "Failed to create backup wrapper")
            }
            a(e, "create");
            return k
        }, Nb: c, Vb: function (a) {
            return c(a) ? "async" : "sync"
        }, cb: function (a) {
            return!a ? "" : (a = d.b.e(m[a].holder) || d.b.e(b(a)) || d.b.e(b(a, "b"))) && a.id || ""
        }, da: i, Ha: function (e, b) {
            if (!e || !b)return q;
            return m[e] ? (m[e].response = b, a(e, "response"), l) : q
        }, K: a, C: f, oa: function (a, e) {
            h(a, "stack", e)
        }, ua: function (a) {
            a = d.lang.D(a);
            if (!a.length)return q;
            var e = [], b = {}, f;
            for (f = 0; f < k.length; f++)b[k[f]] = f + 1;
            for (f = 0; f < a.length; f++) {
                var c =
                    b["" + a[f]];
                c === j && (c = 0);
                e.push(c)
            }
            return e
        }, z: function (a) {
            a = d.lang.D(a);
            if (!a.length)return["-1x-1"];
            for (var e = [], c = 0; c < a.length; c++) {
                var h = a[c], i;
                try {
                    var g = d.b.e(b(h)) || d.b.e(b(h, "b"));
                    if (g) {
                        var k = d.style.z(g);
                        k && (i = [k.top, k.left])
                    }
                } catch (n) {
                    f(h, "Unable to get ps")
                }
                i = i ? i : [-1, -1];
                e.push(i.join("x"))
            }
            return e
        }}
    });
    R("api", ["slot", "util"], function (d, g) {
        return{getDai: d.ua, getSlots: d.da, getFillType: d.Vb, getFillWrapperId: d.cb, setStatus: d.K, addErrorItem: d.C, addStackItem: d.oa, bind: g.event.bind, getType: g.lang.c, sendLog: g.log.ka, putInfo: g.data.B, getInfo: g.data.i, defineOnce: g.data.G, addCount: g.data.Ra, getCount: g.data.Ub, getConfig: g.data.Tb}
    });
    R("param", ["slot", "preview", "biz", "util"], function (d, g, c, b) {
        function a(a, e) {
            for (var e = e || 0, b = [], f = 0, c = a.length; f < c; f++)b.push(a[f].split("_")[e]);
            return b.join(",")
        }

        function f(a) {
            a = a || window.document.domain;
            0 === a.indexOf("www.") && (a = a.substr(4));
            "." === a.charAt(a.length - 1) && (a = a.substring(0, a.length - 1));
            var e = a.match(RegExp("([a-z0-9][a-z0-9\\-]*?\\.(?:com|cn|net|org|gov|info|la|cc|co|jp|us|hk|tv|me|biz|in|be|io|tk|cm|li|ru|ws|hn|fm|tw|ma|in|vn|name|mx|gd|im)(?:\\.(?:cn|jp|tw|ru|th))?)$", "i"));
            return e ?
                e[0] : a
        }

        var h = window, i = h.document, e = h.screen, k = h.navigator, n = +new Date, m = [
            {key: "di", value: function (e) {
                return a(e.id)
            }},
            {key: "dcb", value: v("BAIDU_DUP2_define")},
            {key: "dtm", value: v("BAIDU_DUP2_SETJSONADSLOT")},
            {key: "dbv", value: function () {
                var a = b.d;
                return a.sc ? "1" : a.Wa ? "2" : "0"
            }},
            {key: "dci", value: function (a) {
                for (var e = "-1", b = {fill: "0", fillOnePiece: "1", fillAsync: "2", preload: "3"}, f = 0; f < a.id.length; f++) {
                    var c = d.da(a.id[f]);
                    if (c) {
                        var c = c.stack, h = c.length;
                        if (1 <= h) {
                            e = b[c[h - 1]];
                            break
                        }
                    }
                }
                return e
            }},
            {key: "dri",
                value: function (e) {
                    return a(e.id, 1)
                }},
            {key: "dis", value: function () {
                var a = 0;
                b.b.k(h) && (a += 1);
                b.b.j(h, h.top) && (a += 2);
                var e = b.style.o(), f = b.style.m();
                if (40 > e || 10 > f)a += 4;
                return a
            }},
            {key: "dai", value: function (a) {
                return d.ua(a.id).join(",")
            }},
            {key: "dds", value: function () {
                var a = b.data.i("dds");
                return b.lang.tb(a)
            }},
            {key: "drs", value: function () {
                var a = {uninitialized: 0, loading: 1, loaded: 2, interactive: 3, complete: 4};
                try {
                    return a[i.readyState]
                } catch (e) {
                    return-1
                }
            }},
            {key: "dvi", value: v("1395372013")},
            {key: "ltu", M: l, value: function () {
                for (var a =
                    0, e = h, f = 0, c = 0; 10 > a++ && b.b.k(e) && !b.b.j(e);) {
                    f = b.style.o(e);
                    c = b.style.m(e);
                    if (400 < f && 120 < c)break;
                    e = e.parent
                }
                f = "";
                f = 10 <= a || b.b.j(e) ? e.document.referrer || e.location.href : e.location.href;
                0 < f.indexOf("cpro_prev") && (f = f.slice(0, f.indexOf("?")));
                return f
            }},
            {key: "liu", M: l, value: function () {
                return b.b.k(h) ? i.URL : ""
            }},
            {key: "ltr", M: l, value: function () {
                for (var a = 0, e = h; 10 > a++ && b.b.k(e) && !b.b.j(e);)e = e.parent;
                a = "";
                try {
                    a = e.opener ? e.opener.document.location.referrer : ""
                } catch (f) {
                }
                return a || e.document.referrer
            }},
            {key: "lcr",
                M: l, value: function () {
                var a = i.referrer, e = a.replace(/^https?:\/\//, ""), e = e.split("/")[0], e = e.split(":")[0], e = f(e), c = f(), d = b.cookie.get("BAIDU_DUP_lcr") || b.cookie.get("BAIDU_CLB_REFER", l);
                if (d && c === e)return d;
                return c !== e ? (b.cookie.set("BAIDU_DUP_lcr", a, {domain: c}), a) : ""
            }},
            {key: "ps", value: function (a) {
                return d.z(a.id).join(",")
            }},
            {key: "psr", value: function () {
                return[e.width, e.height].join("x")
            }},
            {key: "par", value: function () {
                return[e.availWidth, e.availHeight].join("x")
            }},
            {key: "pcs", value: function () {
                return[b.style.o(),
                    b.style.m()].join("x")
            }},
            {key: "pss", value: function () {
                return[b.style.ya(), b.style.wa()].join("x")
            }},
            {key: "pis", value: function () {
                return(b.b.k(h) ? [b.style.o(), b.style.m()] : [-1, -1]).join("x")
            }},
            {key: "cfv", value: function () {
                var a = 0;
                if (k.plugins && k.mimeTypes.length) {
                    var e = k.plugins["Shockwave Flash"];
                    e && e.description && (a = e.description.replace(/([a-zA-Z]|\s)+/, "").replace(/(\s)+r/, ".") + ".0")
                } else if (h.ActiveXObject && !h.opera)for (e = 10; 2 <= e; e--)try {
                    var b = new ActiveXObject("ShockwaveFlash.ShockwaveFlash." + e);
                    b && (a = b.GetVariable("$version").replace(/WIN/g, "").replace(/,/g, "."))
                } catch (f) {
                }
                return parseInt(a, 10)
            }},
            {key: "ccd", value: function () {
                return e.colorDepth || 0
            }},
            {key: "chi", value: function () {
                return h.history.length || 0
            }},
            {key: "cja", value: function () {
                return k.javaEnabled().toString()
            }},
            {key: "cpl", value: function () {
                return k.plugins.length || 0
            }},
            {key: "cmi", value: function () {
                return k.mimeTypes.length || 0
            }},
            {key: "cce", value: function () {
                return k.cookieEnabled || 0
            }},
            {key: "col", value: function () {
                return(k.language || k.browserLanguage ||
                    k.systemLanguage).replace(/[^a-zA-Z0-9\-]/g, "")
            }},
            {key: "cec", value: function () {
                return(i.characterSet ? i.characterSet : i.charset) || ""
            }},
            {key: "cdo", value: function () {
                var a = window.orientation;
                a === j && (a = -1);
                return a
            }},
            {key: "tsr", value: function () {
                var a = 0, e = +new Date;
                n && (a = e - n);
                return a
            }},
            {key: "tlm", value: function () {
                return Date.parse(i.lastModified) / 1E3
            }},
            {key: "tcn", value: function () {
                return Math.round(+new Date / 1E3)
            }},
            {key: "tpr", value: function (a) {
                var a = a && a.max_age ? a.max_age : 24E4, e = (new Date).getTime(), b, f;
                try {
                    b = !!window.top.location.toString()
                } catch (c) {
                    b = q
                }
                f = b ? window.top : window;
                (b = f.BAIDU_DUP2_pageFirstRequestTime) ? e - b >= a && (b = f.BAIDU_DUP2_pageFirstRequestTime = e) : b = f.BAIDU_DUP2_pageFirstRequestTime = e;
                return b || ""
            }},
            {key: "_preview", value: function (e) {
                return g.ac(a(e.id))
            }},
            {key: "dpt", value: function () {
                var a = "none";
                g.lb() && (a = "union");
                return a
            }},
            {key: "coa", M: l, value: function (a) {
                var e = a.id, e = e[0].split("_")[0], a = {}, f = q, c = b.data.i("#novaOpenApi");
                if (c && e && c[e]) {
                    var f = l, e = c[e], d;
                    for (d in e)d && e.hasOwnProperty(d) &&
                        "undefined" !== typeof e[d] && (a[d] = encodeURIComponent(e[d]).toString())
                }
                a.c01 = f ? 1 : 0;
                d = "";
                for (var h in a)h && a.hasOwnProperty(h) && "undefined" !== typeof a[h] && (d += "&" + h + "=" + a[h]);
                return d = d.slice(1)
            }},
            {key: "_unionpreview", value: function () {
                return g.bc()
            }},
            {key: "baidu_id", value: v("")},
            {key: "_orientation", value: function () {
                return c.Yb()
            }}
        ];
        return{get: function (a, e) {
            for (var b = [], f = 0, c = m.length; f < c; f++) {
                var d;
                try {
                    var h = m[f], i = h.key, g = h.M, k = h.value, k = "function" === typeof k ? k(a) : k, k = g ? encodeURIComponent(k) : k;
                    if (e &&
                        e === i)return k;
                    d = i && 0 !== i.indexOf("_") ? i + "=" + k : k
                } catch (n) {
                    d = encodeURIComponent(n.toString()), d = d.slice(0, 100)
                }
                d && b.push(d)
            }
            b = b.join("&");
            return b.slice(0, 2048)
        }}
    });
    R("request", ["param", "slot", "util"], function (d, g, c) {
        R("request!", [], {name2url: function (b) {
            return"http://pos.baidu.com/ecom?" + d.get({id: b.split(",")})
        }});
        R("batch!", [], {name2url: function (b) {
            return"http://pos.baidu.com/ecom?" + d.get({id: b.split(",")})
        }});
        return{send: function (b, a, f) {
            if (!b || !a || f === j)return q;
            var d = [];
            if ("array" !== c.lang.c(b))g.K(b, "request"), d = ["request!" + b]; else {
                for (d = 0; d < b.length; d++)g.K(b[d], "request");
                d = 1 === b.length ? ["request!" + b[0]] : ["batch!" + b.join(",")]
            }
            Q(d, a, f);
            return l
        }}
    });
    R("control", ["slot", "request", "preview", "util"], function (d, g, c, b) {
        function a(a, e, f) {
            var c = e.deps, h = e.data, g = d.cb(a);
            f && !g ? d.C(a, "HolderNotFound") : c && (0 > c[0].indexOf("clb/") && d.K(a, "finish"), Q(c, function (e) {
                if ("object" === b.lang.c(h)) {
                    h.id = a;
                    if (e.hasOwnProperty("validate"))try {
                        var f = e.validate(h);
                        f !== l && b.log.ka({data: {type: f || "ResponseError", errorPainter: c[0], id: a, slotType: h._stype, materialType: h._isMlt, html: !!h._html}})
                    } catch (k) {
                        d.C(a, "validateException")
                    }
                    if (e.hasOwnProperty("render"))try {
                        d.K(a, "render"),
                            e.render(h, g)
                    } catch (r) {
                        d.C(a, "RenderException")
                    } else d.C(a, "RenderNotFound")
                } else d.C(a, "ResponseFormatError")
            }, f))
        }

        function f(b, e, f) {
            if (!b)return q;
            var f = f || "", c = d.add(b), b = c.ids[0] || c.preloadIds[0];
            if (!b)return q;
            var h = d.Nb(b, e);
            d.oa(b, e);
            d.create(b, e, f);
            c.ids.length ? g.send(b, function (e) {
                d.Ha(b, e);
                a(b, e, h)
            }, h) : c.preloadIds.length && (e = d.da(b).response, a(b, e, h));
            return l
        }

        function h(a) {
            for (var e = 0, b = a + "_" + e; 0 !== d.ua([b])[0];) {
                var f = d.da(b);
                if ((f = f && f.response) && 0 === f.deps[0].indexOf("clb/")) {
                    var c =
                        f.data, f = c._isMlt;
                    (0 === f && "" !== c._html || f === q && c._fxp) && d.K(b, "finish", 0)
                }
                b = a + "_" + ++e
            }
            if (a !== j && (a = (e = window.BAIDU_CLB_SLOTS_MAP) && e[a], a !== j && (f = a._isMlt, 0 === f && "" !== a._html || f === q && a._fxp)))a._done = q
        }

        window.BAIDU_CLB_prepareMoveSlot = h;
        return{fill: function (a) {
            return f(a, "fill")
        }, bb: function (a, e) {
            return f(a, "fillAsync", e)
        }, nc: function () {
            function a(e) {
                g.send(e, function (a) {
                    if ("array" === b.lang.c(a)) {
                        if (a && a.length === e.length)for (var f = 0; f < e.length; f++)d.Ha(e[f], a[f])
                    } else"object" === b.lang.c(a) && a &&
                        1 === e.length && d.Ha(e[0], a)
                }, q)
            }

            var e = b.lang.D(arguments), e = b.lang.unique(e), f = c.i();
            if (f)for (var h = 0, m = e.length; h < m; h++)e[h] == f.zb && (e.splice(h, 1), h--);
            for (e = d.add(e).ids; e.length;) {
                f = e.splice(0, 16);
                for (h = 0; h < f.length; h++)d.oa(f[h], "preload");
                a(f)
            }
        }, pc: h}
    });
    R("global", ["control", "biz", "util", "preview"], function (d, g, c, b) {
        function a(a) {
            a = a.split(".");
            return k[a[0]] + a[1]
        }

        function f() {
            var a = e.BAIDU_DUP2;
            if (!("object" === c.lang.c(a) && a.push)) {
                if ("array" === c.lang.c(a) && a.length)for (var b = 0; b < a.length; b++)h(a[b]);
                e.BAIDU_DUP2 = j;
                c.data.G("BAIDU_DUP2", {push: h});
                c.data.G("BAIDU_DUP2_proxy", function (a) {
                    if (a)return function () {
                        try {
                            return h([a].concat(c.lang.D(arguments)))
                        } catch (e) {
                            0 < ga-- && c.log.ka({data: {type: "ExecuteException", errorName: a, args: c.lang.D(arguments).join("|"),
                                isQuirksMode: "CSS1Compat" !== document.compatMode, documentMode: document.documentMode || "", readyState: document.readyState || "", message: e.message}})
                        }
                    }
                });
                for (b in m)b && c.lang.ea.call(m, b) && c.data.G(b, e.BAIDU_DUP2_proxy(b));
                i()
            }
        }

        function h(a) {
            if ("array" !== c.lang.c(a))return q;
            var e = a.shift();
            c.data.Ra("apiCount", e);
            return(e = m[e] || s[e] || q) && e.apply(o, a)
        }

        function i() {
            function a(e) {
                for (var b = 0, f = C.length; b < f; b++)if (0 === e.indexOf(C[b]))return l;
                return q
            }

            c.data.G(y, function (e) {
                for (var b = 0, f = e.length; b < f; b++)if (a(e[b]))return;
                Q.apply(o, arguments)
            });
            c.data.G(A, function (e, b) {
                for (var f = 0, c = b.length; f < c; f++)if (a(b[f]))return;
                R.apply(o, arguments)
            })
        }

        var e = window, k = {clb: "BAIDU_CLB_DUP2_", dan: "BAIDU_DAN_DUP2_", nova: "cpro"}, n = [
            {q: ["clb.fillSlot", "clb.singleFillSlot", "clb.fillSlotWithSize"], r: ["fill"], p: d.fill},
            {q: ["clb.fillSlotAsync"], r: ["fillAsync"], p: d.bb},
            {q: ["clb.preloadSlots"], r: ["preload"], p: d.nc},
            {q: ["clb.prepareMoveSlot"], r: ["prepareMove"], p: d.pc},
            {q: ["clb.addOrientation"], r: ["addOrientation"], p: g.Sa},
            {q: ["clb.addOrientationOnce"],
                r: ["addOrientationOnce"], p: g.Hb},
            {q: ["clb.setOrientationOnce"], r: ["setOrientationOnce"], p: g.zc},
            {q: ["clb.setConfig"], r: ["putConfig"], p: c.data.rc},
            {q: ["clb.addSlot", "clb.enableAllSlots", "clb.SETHTMLSLOT"], r: [], p: c.lang.pb}
        ], n = function (e) {
            for (var b = {}, f = {}, c = 0; c < e.length; c++) {
                for (var d = e[c], h = d.q, g = d.r, d = d.p; h.length;)b[a(h.shift())] = d;
                for (; g.length;)f[g.shift()] = d
            }
            return{lc: b, qc: f}
        }(n), m = n.lc, s = n.qc;
        return{ec: function () {
            var e = c.data.eb(a("clb.ORIENTATIONS"));
            if (e)for (var h in e)Object.prototype.hasOwnProperty.call(e,
                h) && g.Sa(h, e[h]);
            c.data.B("#novaOpenApi", window.cproStyleApi);
            if (e = window.cproArray) {
                h = 0;
                for (var i = e.length; h < i; h++)e[h] && e[h].id && d.bb(e[h].id, "cpro_" + e[h].id)
            }
            if (e = window.cpro_id)b.lb(e) && (b.Cc(e), e = "u0"), d.fill(e);
            d.fill(c.data.eb(a("clb.SLOT_ID")));
            f()
        }}
    });
    R("logService", ["util/lang", "util/event"], function (d, g) {
        g.bind(window, "load", function () {
            Q(["detect"], d.pb, l)
        })
    });
    R("fingerprint", ["util/storage", "util/event", "util/browser", "util/data"], function (d, g, c, b) {
        var a = window, f = q;
        c.a ? 7 <= c.a && (f = l) : d.Jb() && (f = l);
        f && (b.i("isFPLoaded", l) === l ? f = q : b.B("isFPLoaded", l, l));
        f && g.bind(a, "load", function () {
            var b = a.document, f = b.body, e = b.createElement("div");
            e.id = "BAIDU_DUP_fp_wrapper";
            e.style.position = "absolute";
            e.style.left = "-1px";
            e.style.bottom = "-1px";
            e.style.zIndex = 0;
            e.style.width = 0;
            e.style.height = 0;
            e.style.overflow = "hidden";
            e.style.visibility = "hidden";
            e.style.display = "none";
            b = b.createElement("iframe");
            b.id = "BAIDU_DUP_fp_iframe";
            b.src = "http://pos.baidu.com/wh/o.htm?cf=u";
            b.style.width = 0;
            b.style.height = 0;
            b.style.visibility = "hidden";
            b.style.display = "none";
            try {
                e.insertBefore(b, e.firstChild), f && f.insertBefore(e, f.firstChild)
            } catch (c) {
            }
        })
    });
    Q(["global"], function (d) {
        d.ec()
    });
    Q(["logService"]);
    Q(["fingerprint"]);
    window[A]("detect", ["api"], function (d) {
        function g(b) {
            b.url = "";
            b.host = window.location.hostname;
            b.from = "DUP2";
            d.sendLog({data: b, Zc: "now"})
        }

        try {
            setTimeout(function () {
                var b = d.getSlots(), a;
                for (a in b) {
                    var f = b[a], c = f.response, i = q;
                    if ("object" !== d.getType(c))i = l; else {
                        var i = l, e;
                        for (e in c)if (Object.prototype.hasOwnProperty.call(c, e)) {
                            i = q;
                            break
                        }
                    }
                    var k = f.status, f = f.stack;
                    i ? g({type: "preload" === f[0] ? "preloadFail" : "loadFail", id: a}) : !k.render && !k.finish && g({type: "renderFail", id: a, error: "preload" === f[0] ? "PreloadNotFilled" :
                        "NotFilled", empty: !(!c.data || !c.data._html)})
                }
            }, 0)
        } catch (c) {
        }
    });
    window[A] && window[A]("viewWatch", ["util", "param"], function (d, g) {
        function c() {
            var a = +new Date, f = 500;
            r === e && E && (f = a - E);
            E = a;
            for (var c in t)if (s.call(t, c)) {
                r === h && (r = i);
                var g = t[c];
                g.V && (g.Aa += f);
                g.ia && (g.za += f);
                g.Ca = a - g.timestamp;
                if (r === e)B && (g.O += a - g.ha); else if (72E5 <= g.Ca)b(q); else {
                    var k = g = j, n = j;
                    for (n in t)if (s.call(t, n)) {
                        var p = t[n];
                        if (B) {
                            var u = d.b.e(p.Kc);
                            if (!u)break;
                            try {
                                var x = m.o(w), z = m.m(w), W = m.z(u), X = m.U(w), Y = m.xa(w), Z = m.R(u), $ = m.Q(u), aa = W.top - X + 0.35 * $, ba = W.left - Y + 0.35 * Z;
                                p.V = 0 < aa && aa < z && 0 < ba && ba <
                                    x;
                                var na = Z * $, ca = m.z(u), M = ca.top - X, N = ca.left - Y, da = m.R(u), ea = m.Q(u), fa = u = 0, u = 0 > M ? Math.max(M + ea, 0) : Math.min(ea, Math.max(z - M, 0)), fa = 0 > N ? Math.max(N + da, 0) : Math.min(da, Math.max(x - N, 0));
                                g = fa;
                                k = u;
                                p.ia = k * g > 0.5 * na
                            } catch (pa) {
                                p.V = q, p.ia = q
                            }
                        } else p.V = q, p.ia = q
                    }
                }
            }
        }

        function b(b) {
            clearInterval(z);
            var f = document.domain.toLowerCase();
            if (!(-1 < f.indexOf("autohome.com.cn") || -1 < f.indexOf("sina.com.cn") || -1 < f.indexOf("pconline.com.cn") || -1 < f.indexOf("pcauto.com.cn") || -1 < f.indexOf("pclady.com.cn") || -1 < f.indexOf("pcgames.com.cn") ||
                -1 < f.indexOf("pcbaby.com.cn") || -1 < f.indexOf("pchouse.com.cn") || -1 < f.indexOf("xcar.com.cn")))if (r !== i)r = e; else {
                r = e;
                c();
                var f = q, h;
                for (h in t)if (h && t[h] && t.hasOwnProperty(h)) {
                    var g = t[h];
                    "block" === g.ic && (f = l);
                    g.total = p;
                    d.log.ka({url: a(g)})
                }
                if (b && f)if (b = +new Date, k.a)for (f = b + 200; f > +new Date;); else {
                    h = 1E5;
                    for (f = 0; f < h; f++);
                    f = +new Date;
                    h = Math.min(200 * h / (f - b), 1E7);
                    for (f = 0; f < h; f++);
                }
            }
        }

        function a(a) {
            for (var e = ["tu=" + a.id, "word=" + g.get(j, "ltu"), "if=" + g.get(j, "dis"), "aw=" + a.width, "ah=" + a.height, "dt=" + Math.round(f /
                1E3), "pt=" + a.Ca, "ps=" + d.lang.Sb(new Date(a.timestamp), "yyyyMMddhhmmssS"), "it=" + a.Aa, "vs=" + (a.V ? 1 : 0), "vt=" + a.za, "ft=" + a.O, "op=" + a.opacity, "csp=" + u, "bcl=" + a.Lb, "pof=" + a.xc, "top=" + a.top, "left=" + a.left, "fs=1", "total=" + a.total], b = 0; 2 > b && x.length;) {
                var c = x.pop();
                e.push("lvu" + b + "=" + c.url);
                e.push("lvt" + b + "=" + c.time);
                b++
            }
            return a.url + (a.ab ? a.ab + "&" : "") + e.join("&")
        }

        var f = +new Date, h = 1, i = 2, e = 3, k = d.d, n = d.event.bind, m = d.style, s = d.lang.ea, t = [], p = 0, z = 0, r = h, B = l, E = 0, u = [1E4 < screen.availWidth ? 0 : screen.availWidth, 1E4 <
            screen.availHeight ? 0 : screen.availHeight].join(), w = window;
        d.b.k(window) && !d.b.j(window) && (w = window.top);
        z = setInterval(c, 500);
        (function () {
            function a() {
                var e = +new Date, b;
                for (b in t)if (s.call(t, b)) {
                    var f = t[b];
                    f.O += e - f.ha;
                    f.ha = e
                }
                B = q
            }

            function e() {
                var a = +new Date, b;
                for (b in t)s.call(t, b) && (t[b].ha = a);
                B = l
            }

            k.a ? (n(document, "focusin", e), n(document, "focusout", a)) : (n(window, "focus", e), n(window, "blur", a))
        })();
        (function () {
            function a(e) {
                if (e = (e.target || e.srcElement).href)x.push({url: encodeURIComponent(e), time: +new Date}),
                    10 < x.length && x.shift()
            }

            n(document, "click", a);
            w != window && n(w.document, "click", a)
        })();
        n(window, "beforeunload", b);
        var x = [];
        return{register: function (a) {
            var e = +new Date, b = a.id, f = a.wrapperId, c = a.url || "http://eclick.baidu.com/a.js?", h = a.logType || "storage", a = a.extra || "";
            if (f && !t[f]) {
                var g = d.b.e(f);
                if (g) {
                    var i = m.z(g);
                    t[f] = {id: b, Kc: f, url: c, ic: h, ab: a, timestamp: e, Aa: 0, V: q, za: 0, ia: q, Ca: 0, O: 0, ha: e, top: i.top, left: i.left, dd: u, opacity: m.fb(g), Lb: [m.o(), m.m()].join(), xc: [m.ya(), m.wa()].join(), width: m.R(g), height: m.Q(g)};
                    p++
                }
            }
        }, getWatchCount: function () {
            return p
        }}
    });
    R && R("nova/preview", ["nova/common/bom", "nova/common/logic", "nova/common/cookie"], function (d, g, c) {
        function b(a) {
            a = decodeURIComponent(a).replace(/\\x1e/g, "&").replace(/\\x1d/g, "=").replace(/\\x1c/g, "?").replace(/\\x5c/g, "\\");
            return g.hc(a)
        }

        function a(a, b) {
            var i;
            i = b ? b.substring(b.indexOf("?")) : d.j(window) ? window.location.search.slice(1) : window.top.location.search.slice(1);
            var e = document.referrer, k = 0 <= a.indexOf("inlay") || "ui" === a ? "bd_cpro_prev" : "bd_cpro_fprev", n = "", m;
            try {
                m = document.cookie
            } catch (s) {
            }
            -1 !==
                i.indexOf(k) && (n = g.hb(i, k));
            !n && m && -1 !== m.indexOf(k) && (n = c.gb(k));
            !n && -1 !== e.indexOf(k) && (n = g.hb(e, k));
            return n
        }

        return{Zb: function (f, c) {
            var d = window.location.href, e = parseInt(f.rsi0), g = parseInt(f.rsi1), n = parseInt(f.at), m = q, s = a(c, d);
            if (s)if (s = b(s), n === j && (n = 1), 1 !== parseInt(s.type) && 2 === (n & 2))m = parseInt(s.imgWidth) === parseInt(e) && parseInt(s.imgHeight) === parseInt(g); else if (1 === parseInt(s.type) && (1 === (n & 1) || 64 === (n & 64) || 32 === (n & 32)))m = l;
            return m ? (e = 0 <= c.indexOf("inlay") || "ui" === c ? "bd_cpro_prev" : "bd_cpro_fprev",
                d = a(c, d), g = f.tn, n = b(d), m = o, 0 <= c.indexOf("inlay") ? m = {serviceUrl: "http://cpro.baidu.com/cpro/ui/preview/templates/" + (1 === parseInt(n.type) ? g + ".html" : 2 === parseInt(n.type) ? "image.html" : 4 === parseInt(n.type) ? "flash.html" : "blank_tips.html") + "?", paramString: ("" + e + "=#" + d + "&ut=" + +new Date).replace(/\.(?!swf)/g, "%252e")} : "float" === c && (n = parseInt(n.type), n = "http://cpro.baidu.com/cpro/ui/preview/templates/" + (2 === n ? "float_image.html" : 4 === n ? "float_flash.html" : "blank_tips.html") + "?", d = "tn=" + g + ("&" + e + "=" + d).replace(/\./g,
                "%252e") + "&ut=" + +new Date, m = {serviceUrl: n, paramString: d}), m) : o
        }}
    });
    R && R("nova/business/businessLogic", ["nova/preview"], function (d) {
        var g = {inlay: 4, "float": 2, patch: 1, linkunit: 8}, c = {inlay: 0, "float": 0, patch: 0, linkunit: 0};
        return{rb: function (b) {
            var a = b._html || {}, f = "", c = "http://pos.baidu.com/ecom?", g = b.id.split("_")[0], e = parseInt(a.conW || 0) || parseInt(b.sw) || parseInt(a.rsi0), k = parseInt(a.conH || 0) || parseInt(b.sh) || parseInt(a.rsi1), n = b.displayType, m = a.tn || "", s = m.toLowerCase(), t = a.ch || 0, b = b.qn || "", p = a.n || "", z = a.dai || 0;
            a.dtm = "BAIDU_DUP2_SETJSONADSLOT";
            a.dc = "2";
            a.di = g;
            var f =
                [], r;
            for (r in a)r && a.hasOwnProperty(r) && f.push("" + r + "=" + encodeURIComponent(a[r].toString()));
            f = f.join("&");
            if ((r = d.Zb(a, n)) && r.serviceUrl !== j && r.paramString !== j)c = r.serviceUrl, f = r.paramString;
            return{slotId: g, slotWidth: e, slotHeight: k, displayType: n, styleType: s, unionAccount: p, adIndex: z, channel: t, pvId: b, stuffType: "unknown", serviceUrl: c, paramString: f, delayIn: a.delayIn, delayOut: a.delayOut, sessionSync: a.sessionSync !== q && "false" !== a.sessionSync, closeFor: a.closeFor, xuantingType: a.xuanting, tn: m}
        }, Ea: function (b) {
            var a =
            {};
            a.Ob = (b.Ob || "pc").toLowerCase();
            a.L = (b.L || "inlay-fixed").toLowerCase();
            a.v = (b.v || "template_inlay_all_normal").toLowerCase();
            a.Ja = (b.Ja || "text").toLowerCase();
            if (-1 < a.v.indexOf("tlink") || -1 < a.v.indexOf("linkunit"))a.L = "linkunit-fixed";
            b = a.L.split("-");
            a.ca = b[0] || "inlay";
            a.Oc = b[1] || "fixed";
            return a
        }, Va: function (b) {
            b = this.Ea(b);
            b = b.ca;
            return c[b] <= g[b]
        }, Rc: function (b) {
            b = this.Ea(b);
            return c[b.ca]
        }, ub: function (b) {
            b = this.Ea(b);
            c[b.ca] += 1;
            return l
        }, ib: function (b, a) {
            var f = document.getElementById("cpro_" +
                b);
            f || (f = document.getElementById(a));
            return f
        }}
    });
    R && R("nova/common/bom", [], function () {
        var d = {};
        /msie (\d+\.\d)/i.test(navigator.userAgent) && (d.a = document.documentMode || +RegExp.$1);
        /opera\/(\d+\.\d)/i.test(navigator.userAgent) && (d.opera = +RegExp.$1);
        /firefox\/(\d+\.\d)/i.test(navigator.userAgent) && (d.Rb = +RegExp.$1);
        /(\d+\.\d)?(?:\.\d)?\s+safari\/?(\d+\.\d+)?/i.test(navigator.userAgent) && !/chrome/i.test(navigator.userAgent) && (d.wc = +(RegExp.$1 || RegExp.$2));
        /chrome\/(\d+\.\d)/i.test(navigator.userAgent) && (d.Wa = +RegExp.$1);
        try {
            /(\d+\.\d)/.test(window.external.Xc) &&
            (d.jc = +RegExp.$1)
        } catch (g) {
        }
        d.mb = /webkit/i.test(navigator.userAgent);
        d.fc = /gecko/i.test(navigator.userAgent) && !/like gecko/i.test(navigator.userAgent);
        d.kb = "CSS1Compat" == document.compatMode;
        return{d: d, pa: function () {
            var c = l;
            if (this.d.a && (7 > this.d.a || "BackCompat" === document.compatMode))c = q;
            return c
        }, ya: function (c) {
            try {
                return c = c || window, "BackCompat" === c.document.compatMode ? c.document.body.scrollWidth : c.document.documentElement.scrollWidth
            } catch (b) {
                return 0
            }
        }, wa: function (c) {
            try {
                return c = c || window, "BackCompat" ===
                    c.document.compatMode ? c.document.body.scrollHeight : c.document.documentElement.scrollHeight
            } catch (b) {
                return 0
            }
        }, o: function (c) {
            try {
                return c = c || window, "BackCompat" === c.document.compatMode ? c.document.body.clientWidth : c.document.documentElement.clientWidth
            } catch (b) {
                return 0
            }
        }, m: function (c) {
            try {
                return c = c || window, "BackCompat" === c.document.compatMode ? c.document.body.clientHeight : c.document.documentElement.clientHeight
            } catch (b) {
                return 0
            }
        }, U: function (c) {
            c = (c || window).document;
            return window.pageYOffset || c.documentElement.scrollTop ||
                c.body.scrollTop
        }, xa: function (c) {
            c = (c || window).document;
            return window.pageXOffset || c.documentElement.scrollLeft || c.body.scrollLeft
        }, ga: function (c) {
            var b = q;
            try {
                c && "object" === typeof c && c.document && "setInterval"in c && (b = l)
            } catch (a) {
                b = q
            }
            return b
        }, k: function (c) {
            c = c || window;
            return c != window.top && c != c.parent || !this.ga(c)
        }, j: function (c, b) {
            for (var b = 2 === arguments.length ? b : c.parent, a = 0; 10 > a++ && this.k(c, b);) {
                var f;
                try {
                    f = !!c.parent.location.toString()
                } catch (d) {
                    f = q
                }
                if (!f)return l;
                c = c.parent
            }
            return 10 <= a ? l : q
        },
            gd: function (c, b) {
                var a = new Image, f = "cpro_log_" + Math.floor(2147483648 * Math.random()).toString(36), b = b || window;
                b[f] = a;
                a.onload = a.onerror = a.onabort = function () {
                    a.onload = a.onerror = a.onabort = o;
                    a = b[f] = o
                };
                a.src = c
            }, P: function (c) {
                if (!c)return document;
                "string" === typeof c && (c = document.getElementById(c));
                return 9 === c.nodeType ? c : c.ownerDocument || c.document
            }, u: function (c) {
                "string" === typeof c && (c = document.getElementById(c));
                c = this.P(c);
                return c.parentWindow || c.defaultView || o
            }, Uc: function (c) {
                c = c || window;
                return this.k(c) && !this.j(c, c.top) && this.ga(c.top) ? c.top : c
            }}
    });
    R && R("nova/common/cookie", [], function () {
        return{gb: function (d, g) {
            var c, b = RegExp("(^| )" + d + "=([^;]*)(;|$)").exec((g || window).document.cookie);
            b && (c = b[2]);
            return c
        }, wb: function (d, g, c) {
            var c = c || {}, b = c.N;
            "number" == typeof c.N && (b = new Date, b.setTime(b.getTime() + c.N));
            document.cookie = "" + d + "=" + g + (c.path ? "; path=" + c.path : "") + (b ? "; expires=" + b.toGMTString() : "") + (c.domain ? "; domain=" + c.domain : "") + (c.fd ? "; secure" : "")
        }, remove: function (d) {
            var g = new Date;
            g.setTime(g.getTime() - 86400);
            this.hd(d, "", {path: "/", N: g})
        }}
    });
    R && R("nova/common/dom", ["nova/common/oo", "nova/common/bom"], function (d, g) {
        return d(function (c) {
            var b = g.d;
            return{e: function (a, b) {
                return"string" === typeof a || a instanceof String ? (b || window).document.getElementById(a) : a
            }, jb: function (a, b) {
                var d = l;
                if ("string" === typeof b)return a.id === b;
                if (b.constructor === Object)return c.Qb(b, function (e, b) {
                    var f = (a.getAttribute ? a.getAttribute(b) : a[b]) || a[b];
                    if ("tagName" === b) {
                        if (f.toUpperCase() != e.toUpperCase())return d = q
                    } else if (f != e)return d = q
                }), d;
                if (b.constructor === Array) {
                    var g =
                        b.concat([]);
                    g.reverse();
                    for (var e = a; e && g.length; e = e.parentNode)this.jb(e, g[0]) && g.shift();
                    return!g.length ? l : q
                }
            }, Db: function (a, b) {
                if (a && b(a) !== q) {
                    var c = a.childNodes;
                    if (c)for (var d = 0, e = c.length; d < e; d++)if (this.Db(c[d], b) === q)return q
                }
            }, Bb: function (a, b) {
                var c = this;
                a.constructor === Object && (a = this.h(a));
                if ("string" === typeof b) {
                    for (var d = document.getElementById(b), e = d; e;) {
                        if (e === a)return d;
                        e = e.parentNode
                    }
                    return o
                }
                if (b.constructor === Object) {
                    var g = o;
                    c.Db(a, function (a) {
                        if (c.jb(a, b))return g = a, q
                    });
                    return g
                }
            },
                h: function (a) {
                    if (a) {
                        if (a.nodeName)return a;
                        1 < arguments.length && (a = Array.prototype.slice.call(arguments, 0));
                        if ("string" === typeof a)return document.getElementById(a);
                        if (a.constructor === Object)return this.Bb(document.documentElement, a);
                        if (a.constructor === Array) {
                            for (var b = a.concat([]), c = document.documentElement; b.length && c;)c = this.Bb(c, b.shift());
                            return c
                        }
                    }
                }, bd: function (a, f, d) {
                    var d = d || this.md || window, g = d.document;
                    this.Za = 0;
                    this.J = this.J || [];
                    this.J.push({ta: a, Ya: f || 0, sa: q});
                    var e = c.I(function () {
                        var a =
                            q;
                        this.Za++;
                        var e = q;
                        try {
                            d.frameElement && (e = l)
                        } catch (f) {
                            e = l
                        }
                        if (b.a && 9 > b.a && !e)try {
                            g.documentElement.doScroll("left"), a = l
                        } catch (c) {
                        } else if ("complete" === g.readyState || this.Pb)a = l; else if (3E5 < this.Za) {
                            this.w && (d.clearInterval(this.w), this.w = o);
                            return
                        }
                        if (a)try {
                            if (this.J && this.J.length)for (var a = 0, t = this.J.length; a < t; a++) {
                                var p = this.J[a];
                                p && p.ta && !p.sa && (p.Ya ? (p.sa = l, d.setTimeout(p.ta, p.Ya)) : (p.sa = l, p.ta()))
                            }
                        } catch (z) {
                            throw z;
                        } finally {
                            this.w && (d.clearInterval(this.w), this.w = o)
                        }
                    }, this), a = c.I(function () {
                        this.Pb =
                            l;
                        e()
                    }, this);
                    this.w || (this.w = d.setInterval(e, 50), g.addEventListener ? (g.addEventListener("DOMContentLoaded", a, q), d.addEventListener("load", a, q)) : g.attachEvent && d.attachEvent("onload", a, q))
                }, pa: function () {
                    var a = l;
                    if (b.a && (7 > b.a || "BackCompat" === document.compatMode))a = q;
                    return a
                }, bind: function (a, b, c) {
                    "string" === typeof a && (a = this.h(a));
                    b = b.replace(/^on/i, "").toLowerCase();
                    a.addEventListener ? a.addEventListener(b, c, q) : a.attachEvent && a.attachEvent("on" + b, c);
                    return a
                }, ld: function (a, b, c) {
                    a = this.h(a);
                    b = b.replace(/^on/i,
                        "").toLowerCase();
                    a.removeEventListener ? a.removeEventListener(b, c, q) : a.detachEvent && a.detachEvent("on" + b, c);
                    return a
                }, l: function (a, b) {
                    var c;
                    "string" === typeof a && (a = this.h(a));
                    var d = g.P(a), e = "", e = -1 < b.indexOf("-") ? b.replace(/[-_][^-_]{1}/g, function (a) {
                        return a.charAt(1).toUpperCase()
                    }) : b.replace(/[A-Z]{1}/g, function (a) {
                        return"-" + a.charAt(0).toLowerCase()
                    });
                    d && d.defaultView && d.defaultView.getComputedStyle ? ((d = d.defaultView.getComputedStyle(a, o)) && (c = d.getPropertyValue(b)), "boolean" !== typeof c && !c &&
                        (c = d.getPropertyValue(e))) : a.currentStyle && ((d = a.currentStyle) && (c = d[b]), "boolean" !== typeof c && !c && (c = d[e]));
                    return c
                }, z: function (a, b) {
                    b = b || window;
                    "string" === typeof a && (a = this.h(a));
                    if (a) {
                        for (var c = this.T(a), d, e = 0; b != b.parent && 10 > e;)e++, d = this.T(b.frameElement), c.left += d.left, c.top += d.top, b = b.parent;
                        return c
                    }
                }, T: function (a) {
                    "string" === typeof a && (a = this.h(a));
                    var b = g.P(a), c = g.d;
                    0 < c.fc && b.getBoxObjectFor && this.l(a, "position");
                    var d = {left: 0, top: 0}, e;
                    if (a == (c.a && !c.kb ? b.body : b.documentElement) || !a)return d;
                    if (a.getBoundingClientRect)a = a.getBoundingClientRect(), d.left = Math.floor(a.left) + Math.max(b.documentElement.scrollLeft, b.body.scrollLeft), d.top = Math.floor(a.top) + Math.max(b.documentElement.scrollTop, b.body.scrollTop), d.left -= b.documentElement.clientLeft, d.top -= b.documentElement.clientTop, a = b.body, b = parseInt(this.l(a, "borderLeftWidth"), 10), a = parseInt(this.l(a, "borderTopWidth"), 10), c.a && !c.kb && (d.left -= isNaN(b) ? 2 : b, d.top -= isNaN(a) ? 2 : a); else {
                        e = a;
                        do {
                            d.left += e.offsetLeft;
                            d.top += e.offsetTop;
                            if (0 < c.mb &&
                                "fixed" == this.l(e, "position")) {
                                d.left += b.body.scrollLeft;
                                d.top += b.body.scrollTop;
                                break
                            }
                            e = e.offsetParent
                        } while (e && e != a);
                        if (0 < c.opera || 0 < c.mb && "absolute" == this.l(a, "position"))d.top -= b.body.offsetTop;
                        for (e = a.offsetParent; e && e != b.body;) {
                            d.left -= e.scrollLeft;
                            if (!c.opera || "TR" != e.tagName)d.top -= e.scrollTop;
                            e = e.offsetParent
                        }
                    }
                    return d
                }, R: function (a, b) {
                    var a = this.h(a), c = a.offsetWidth;
                    if (b || q)var d = this.l(a, "marginLeft").toString().toLowerCase().replace("px", "").replace("auto", "0"), e = this.l(a, "marginRight").toString().toLowerCase().replace("px",
                        "").replace("auto", "0"), c = c + (parseInt(d || 0) + parseInt(e || 0));
                    return c
                }, Q: function (a, b) {
                    var a = this.h(a), c = a.offsetHeight;
                    if (b || q)var d = this.l(a, "marginTop").toString().toLowerCase().replace("px", "").replace("auto", "0"), e = this.l(a, "marginBottom").toString().toLowerCase().replace("px", "").replace("auto", "0"), c = c + (parseInt(d || 0) + parseInt(e || 0));
                    return c
                }, Tc: function (a) {
                    var a = this.h(a), b = this.u(a), c = 0;
                    if (this.k(window) && !g.j(window)) {
                        for (; b.parent != window.top && 10 > c;)c++, b = b.parent;
                        10 > c && (a = b.frameElement ||
                            a)
                    }
                    return a
                }, va: function (a) {
                    var b = this.h(a), a = this.u(b), c = 100, d;
                    try {
                        for (; b && b.tagName;) {
                            d = 100;
                            if (this.d.a) {
                                if (5 < this.d.a)try {
                                    d = b.Qc.alpha.opacity || 100
                                } catch (e) {
                                }
                                c = c > d ? d : c
                            } else {
                                try {
                                    d = 100 * (a.getComputedStyle(b, o).opacity || 1)
                                } catch (g) {
                                }
                                c *= d / 100
                            }
                            b = b.parentNode
                        }
                    } catch (n) {
                    }
                    return c || 100
                }, fb: function (a) {
                    for (var b = this.h(a), a = this.u(b), b = this.va(b), c = 100, d = 0; this.k(a);) {
                        d++;
                        if (g.j(a, a.parent))break; else c = 100, a.frameElement && (c = this.va(a.frameElement)), b *= c / 100;
                        a = a.parent
                    }
                    return b
                }}
        })
    });
    R && R("nova/common/logic", [], function () {
        return{Pc: function (d) {
            (d = d || "") && (d = d.replace(/%u[\d|\w]{4}/g, function (d) {
                return encodeURIComponent(unescape(d))
            }));
            return d
        }, kd: function (d, g) {
            return d.replace(/{(.*?)}/g, function (c, b) {
                return g[b] || ""
            })
        }, hc: function (d) {
            return(new Function("return " + d))()
        }, hb: function (d, g) {
            if (d && g) {
                var c = d.match(RegExp("(^|&|\\?|#)" + g + "=([^&]*)(&|$)", ""));
                if (c)return c[2]
            }
            return o
        }, $c: function (d, g) {
            var d = d || "", g = g || "?", c = arguments.callee;
            c.hasOwnProperty[g] || (c[g] = {});
            c = c[g];
            if (c.hasOwnProperty(d))return c[d];
            var b = {}, a = d.indexOf(g), f = d.substring(a + 1).split("&");
            if (-1 !== a)for (var a = 0, h = f.length; a < h; a++) {
                var i = f[a].split("="), e = decodeURIComponent(i[0]), i = decodeURIComponent(i[1]);
                b.hasOwnProperty(e) ? (b[e].constructor !== Array && (b[e] = [b[e]]), b[e].push(i)) : b[e] = i
            }
            return c[d] = b
        }}
    });
    R && R("nova/common/oo", [], function () {
        function d(a) {
            var b = d.create(d);
            return a.call(b, b, b.Qa)
        }

        function g(a, b) {
            if (a.constructor === Array)for (var c = 0, d = a.length; c < d; c++) {
                if (b.call(a, a[c], c, a) === q)return q
            } else {
                var c = !{toString: 1}.propertyIsEnumerable("toString"), e = "toString,toLocaleString,valueOf,constructor,propertyIsEnumerable,hasOwnProperty,isPrototypeOf".split(",");
                for (d in a)if (a.hasOwnProperty(d) && b.call(a, a[d], d, a) === q)return q;
                if (c) {
                    c = 0;
                    for (d = e.length; c < d; c++) {
                        var g = e[c];
                        if (a.hasOwnProperty(g) &&
                            b.call(a, g, c, a) === q)return q
                    }
                }
            }
            return l
        }

        function c(a, b, c) {
            g(b, function (b, e) {
                if (!a.hasOwnProperty(e) || c)a[e] = b
            })
        }

        function b(a) {
            function b() {
            }

            if (Object.create)return Object.create(a);
            b.prototype = a;
            return new b
        }

        d.Qa = {};
        d.create = b;
        d.Qb = g;
        d.Fb = function (a) {
            var b, d = a.hasOwnProperty("constructor") ? a.constructor : function () {
            };
            d.prototype = a;
            d.prototype.constructor = d;
            b = b || {};
            b.Ia && c(d, b.Ia);
            return d
        };
        d.extend = function (a, d, g) {
            var i;
            i = d.hasOwnProperty("constructor") ? d.constructor : function () {
                a.constructor.apply(this,
                    arguments)
            };
            i.prototype = b(a.prototype);
            c(i.prototype, d, l);
            i.prototype.constructor = i;
            i.prototype.Lc = a.prototype;
            c(i, a);
            g = g || {};
            g.Ia && c(i, g.Ia, l);
            return i
        };
        d.Yc = function (a) {
            var b = this.Qa;
            g(a.split("."), function (a) {
                b.hasOwnProperty(a) || (b[a] = {});
                b = b[a]
            });
            return b
        };
        d.I = function (a, b) {
            var c;
            return function () {
                c = c || [];
                for (var d = 0, e = arguments.length; d < e; d++)c.push(arguments[d]);
                return a.apply(b || {}, c)
            }
        };
        return d
    });
    R && R("nova/painter/inlayFixed1392089005", ["nova/business/businessLogic"], function (d) {
        function g(c) {
            return'<iframe width="{slotWidth}" height="{slotHeight}" src="{serviceUrl}{paramString}" align="center,center" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" allowtransparency="true"></iframe>'.replace(/{(.*?)}/g, function (b, a) {
                return c[a] || ""
            })
        }

        return{render: function (c, b) {
            c.displayType = "inlay-fixed";
            var a = d.rb(c), f = {L: a.displayType, v: a.styleType, Ja: a.stuffType};
            if (!d.Va(f))return q;
            d.ib(a.slotId, b).innerHTML = g(a);
            d.ub(f);
            (function () {
                var c = a.slotId, d = a.adIndex || 0;
                Q(["viewWatch"], function (e) {
                    e.register({id: c, wrapperId: b, logType: "block", extra: "did=" + d + "&ch=" + a.channel + "&jk=" + a.pvId + "&tn=" + a.tn + "&n=" + a.unionAccount + "&js=c"})
                }, l)
            })()
        }}
    });
    R && R("nova/painter/xuanting1392089005", "nova/common/cookie,nova/common/bom,nova/common/dom,nova/common/logic,nova/common/oo,nova/business/businessLogic".split(","), function (d, g, c, b, a, f) {
        var h;
        a(function (a) {
            h = a.Fb({constructor: function (a) {
                var b = a.Y.id;
                this.Y = c.h(a.Y);
                this.type = +a.type;
                this.src = a.src;
                this.width = a.width;
                this.height = a.height;
                this.v = a.v || "";
                this.Ka = a.Ka || "";
                this.qa = a.qa || "0";
                this.Na = a.Na || "";
                this.Fa = a.Fa || "";
                this.Z = this.Ma = 5;
                this.Da = a.Da;
                this.Ga = a.Ga;
                this.X = a.X;
                this.ra = "bd_close_" + this.X;
                this.Ic = !!d.gb(this.ra);
                this.H = this.Wb(this.X);
                this.g = b;
                this.s = "";
                this.fileName = "c";
                this.na = a.na || 0;
                2 === this.type ? this.s = "top" : 3 === this.type && (this.s = "bottom");
                this.s && (this.Eb = l, this.$ = +a.$ || 0, this.aa = +a.aa || 0, this.W = !!a.W || q, this.F = +a.F || 0, this.Ib = 500);
                this.ob = a.ob || q
            }, Vc: function (a) {
                return"string" === typeof a ? document.getElementById(a) : a
            }, Dc: function (a, b) {
                return(b || document).getElementsByTagName(a)[0]
            }, Cb: function (a, b) {
                return a.replace(/\{(.*?)\}/g, function (a, e) {
                    return b.hasOwnProperty(e) ? b[e] :
                        a
                })
            }, Wb: function (a) {
                var b = {};
                return function () {
                    b.hasOwnProperty(a) || (b[a] = 0);
                    ++b[a];
                    return"cproIframe" + b[a]
                }
            }(), d: g.d, yc: function () {
                var a = {path: ""};
                if (this.F && !this.W) {
                    var b = new Date;
                    b.setTime(b.getTime() + this.F);
                    a.N = b
                }
                d.wb(this.ra, 1, a)
            }, uc: function (a) {
                var b = new Date;
                b.setTime(b.getTime() - 86400);
                d.wb(a, "", {path: "/", N: b})
            }, Bc: function () {
                this.clientWidth = g.o(window);
                this.clientHeight = g.m(window);
                this.s && (this.f && (this.f.style.width = this.clientWidth + "px"), this.Pa && (this.Pa.style.width = this.clientWidth +
                    "px"));
                this.vb && clearTimeout(this.vb);
                this.vb = setTimeout(a.I(this.Ba, this), 5)
            }, Ba: function () {
                var a = this.f;
                if (a)if (c.pa()) {
                    if (a.style.zIndex = 2147483646, 1 === this.type)if ("fixed" == a.style.position)this.Ta(), this.Kb() && (a.style.cssText = o, this.tc()); else {
                        var b = this.Fc();
                        b && (this.Xa(), a.style.position = "fixed", a.style.top = b + "px", this.Ta())
                    }
                } else this.Ac(this.f)
            }, Kb: function (a) {
                var b;
                a ? (b = document.getElementById(a), a = document.getElementById("" + a + "placeholder")) : (b = this.f || document.getElementById(this.g),
                    a = document.getElementById("" + this.g + "placeholder"));
                return b && a && (a = this.t(a).ma, this.t(b).ma <= a) ? l : q
            }, Ta: function (a) {
                var b;
                a ? (b = document.getElementById(a), a = document.getElementById("" + a + "placeholder")) : (b = this.f || document.getElementById(this.g), a = document.getElementById("" + this.g + "placeholder"));
                b && a && (a = this.t(a).left, b.style.left = a + "px")
            }, t: function (a) {
                var b = c.T(a), d = g.xa(window), f = g.U(window), h = c.R(a, q), a = c.Q(a, q);
                return{top: b.top - f, bottom: b.top - f + a, left: b.left - d, right: b.left - d + h, ma: b.top, Mc: b.top +
                    a, ja: b.left, ed: b.left + h}
            }, Ac: function () {
                this.clientWidth = g.o(window);
                this.clientHeight = g.m(window);
                var a = g.U(window), b = c.l(document.body, "position").toString(), d = c.T(document.body), f = d.left, h = d.top;
                if (d = this.f)if (d.style.position = "absolute", d.style.zIndex = 2147483646, 1 === this.type)if (document.getElementById("" + this.g + "placeholder")) {
                    var i = document.getElementById("" + this.g + "placeholder"), p = this.t(i);
                    d.style.top = "" + a + this.Z + "px";
                    d.style.left = "" + p.ja + "px";
                    "relative" == b && (d.style.top = a + this.Z - h + "px", d.style.left =
                        p.ja - f + "px");
                    d.style.visibility = "visible";
                    a = this.t(d);
                    p.ma >= a.ma && (d.parentNode.removeChild(d), i.parentNode.insertBefore(d, i), i.parentNode.removeChild(i), d.style.cssText = o)
                } else {
                    if (i = this.Gc(this.g))this.Z = i, this.Xa(this.g), i = document.getElementById("" + this.g + "placeholder"), p = this.t(i), d.parentNode.removeChild(d), document.body.appendChild(d), d.style.zIndex = 2147483646, d.style.top = a + this.Z + "px", d.style.left = p.ja + "px", "relative" == b && (d.style.top = a + this.Z - h + "px", d.style.left = p.ja - f + "px"), d.style.visibility =
                        "visible", d.style.position = "absolute"
                } else 2 === this.type ? d.style.top = a + "px" : 3 === this.type && (d.style.top = a + this.clientHeight - (this.height + 10) + "px")
            }, vc: function () {
                if (!this.ob) {
                    var a = this.type, b = this.width, d = this.height, f = {srcAttrName: a === j || 1 == a ? "src" : "_src", iframeWidth: b, iframeHeight: d, iframeId: this.H, paramString: this.Da || "", serviceUrl: this.Ga};
                    this.oc();
                    var g = q;
                    if (a && (1 === a || 2 === a || 3 === a)) {
                        var h = g = "auto", i;
                        if (1 === a)i = "inline-block", g = b + "px", h = d + "px"; else if (2 === a || 3 === a)i = "block", g = "100%", h = +d + 10 +
                            "px";
                        f.widthValue = g;
                        f.heightValue = h;
                        f.displayValue = i;
                        a = this.Y;
                        a.setAttribute("width", g);
                        a.setAttribute("height", h);
                        a.style.cssText = this.Cb("width:{widthValue};height:{heightValue};display:{displayValue};", f);
                        g = l
                    }
                    f = this.Cb('<iframe id="{iframeId}" {srcAttrName}="{serviceUrl}{paramString}" width="{iframeWidth}" height="{iframeHeight}" align="center,center" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" allowtransparency="true" ></iframe>', f);
                    this.Y.innerHTML = f;
                    this.fa = c.h(this.H);
                    g &&
                    (this.f = this.fa.parentNode);
                    this.Mb();
                    this.Hc()
                }
            }, Mb: function () {
                var a = this.type, b = this.fa, d = this.f;
                if (a) {
                    var f = 1;
                    if (2 === a)f = 2; else if (3 === a)f = 1; else if (1 !== a && 0 !== a && this.f) {
                        this.f.style.display = "none";
                        return
                    }
                    var h = 2 === a || 3 === a, i = "";
                    switch (a) {
                        case 2:
                        case 3:
                            var i = "display:none;", p = "";
                            this.d.a && 7 > this.d.a && (p = "_background-image:none;_filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk" + f + ".png');");
                            f = h ? '<div id="' + this.H + 'WrapToggle" style="z-index:2147483646;cursor:pointer;position:absolute;right:0;' +
                                this.s + ':0;width:40px;height:100%;background-color:#3f3f3f;"><div style="width:20px;height:22px;position:absolute;top:50%;margin-top:-11px;left:50%;margin-left:-10px;background:no-repeat url(http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk' + f + ".png);" + p + '"></div></div>' : "";
                            h = h ? '<div id="' + this.H + 'WrapBk" style="' + this.s + ':0;left:0;position:absolute;width:100%;height:100%;background-color:#666;-moz-opacity:.6;filter:alpha(opacity=60);opacity:.6;"></div>' : "";
                            p = "";
                            c.pa() ? 1 === a ? p = "position:fixed;top:0;" :
                                2 === a ? p = "position:fixed;top:0;width:100%;" : 3 === a && (p = "position:fixed;bottom:0;width:100%;") : 1 === a ? p = "position:absolute;top:0;" : 2 === a ? p = "position:absolute;top:0;width:100%;" : 3 === a && (p = "position:absolute;top:" + (g.U(window) + g.m(window) - this.width) + "px;width:100%;");
                            d.insertAdjacentHTML("afterBegin", h + f);
                            d.style.cssText = [i, "height:", this.height + 10, "px;right:0;z-index:2147483646;text-align:center;font-size:0;_overflow-y:hidden;", p].join("");
                            b.style.cssText = "position:relative;margin:5px 0;";
                            this.La = c.h("" +
                                this.H + "WrapToggle");
                            this.la = this.Dc("DIV", this.La);
                            this.Pa = c.h(this.H + "WrapBk");
                            this.Bc()
                    }
                }
            }, yb: function () {
                var a = this.X, b = this.g, c = this;
                Q(["viewWatch"], function (d) {
                    d.register({id: a, wrapperId: b, logType: "block", extra: "did=" + c.na + "&ch=" + c.qa + "&jk=" + c.Fa + "&tn=" + c.Ka + "&n=" + c.Na + "&js=" + c.fileName})
                }, l)
            }, Hc: function () {
                var b = this, d = b.f, f = b.type, g = b.fa, b = this;
                this.s ? this.Ic ? d.parentNode.removeChild(d) : (setTimeout(function () {
                    d.style.display = "block";
                    if (2 === f || 3 === f) {
                        var a = g.getAttribute("_src");
                        a && (g.setAttribute("src",
                            a), g.removeAttribute("_src"), b.yb())
                    }
                }, this.$), this.aa && setTimeout(function () {
                    d.style.display = "none"
                }, this.$ + this.aa)) : this.yb();
                this.La && (2 === this.type || 3 === this.type) && c.bind(this.La, "click", a.I(this.Ec, this));
                c.bind(window, "scroll", a.I(this.Ba, this));
                c.bind(window, "resize", a.I(this.Ba, this))
            }, oc: function () {
                for (var a = 1; 2 >= a; a++)(function (a) {
                    var b = "bkimg_" + +new Date + Math.floor(1E5 * Math.random()), c = window[b] = new Image;
                    c.onload = c.onerror = function () {
                        c.onload = c.onerror = o;
                        c = window[b] = o
                    };
                    c.src = "http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk" +
                        a + ".png"
                })(a)
            }, Ec: function () {
                this.Eb ? this.cc() : this.show()
            }, xb: function (a) {
                if (!this.Ua) {
                    this.Ua = l;
                    var b = this.f, c = this.Pa, d = this.fa, f = this.s, g = b.offsetHeight, h = Math.round(this.Ib / g), i = 0, r = this;
                    a && (b.style.width = "100%");
                    var B = +new Date, E = setInterval(function () {
                        var b = i = Math.round((+new Date - B) / h), k = b;
                        a && (k = g - b);
                        c.style[f] = -k + "px";
                        d.style[f] = -k + "px";
                        b >= g && (r.Ua = q, (r.Eb = a) && "top" === f || !a && "bottom" === f ? r.d.a && 7 > r.d.a ? r.la.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk2.png');" :
                            r.la.style.backgroundImage = "url(http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk2.png)" : r.d.a && 7 > r.d.a ? r.la.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk1.png');" : r.la.style.backgroundImage = "url(http://cpro.baidustatic.com/cpro/ui/noexpire/img/toggle_btn_bk1.png)", k = g, a && (k = 0), c.style[f] = -k + "px", d.style[f] = -k + "px", clearInterval(E))
                    }, h)
                }
            }, show: function () {
                (this.W || this.F) && this.uc(this.ra);
                this.xb(l)
            },
                cc: function () {
                    (this.W || this.F) && this.yc();
                    this.xb(q)
                }, Xa: function (a) {
                    var b;
                    a ? (b = document.getElementById(a), a += "placeholder") : (b = this.f || document.getElementById(this.g), a = this.g + "placeholder");
                    var c = document.createElement("div");
                    c.id = a;
                    c.align && (c.align = b.getAttribute("align"));
                    c.style.width = "" + parseInt(b.getAttribute("width"), 10) + "px";
                    c.style.height = "" + parseInt(b.getAttribute("height"), 10) + "px";
                    c.style.margin = "0";
                    c.style.padding = "0";
                    c.style.background = "none";
                    c.style.border = "none";
                    1 === this.type && (c.style.display =
                        "inline-block");
                    b.parentNode.insertBefore(c, b);
                    return l
                }, tc: function (a) {
                    a = document.getElementById(a ? a + "placeholder" : this.g + "placeholder");
                    a.parentNode.removeChild(a);
                    return l
                }, Fc: function (a) {
                    var b = this.Ma;
                    return this.t(a ? document.getElementById(a) : this.f || document.getElementById(this.g)).top < b ? b : q
                }, Gc: function (a) {
                    var b = this.Ma;
                    return this.t(a ? document.getElementById(a) : this.f || document.getElementById(this.g)).top < b ? b : q
                }})
        });
        return{render: function (a, b) {
            switch (parseInt(a._html.xuanting)) {
                case 1:
                    a.displayType =
                        "inlay-float";
                    break;
                case 2:
                    a.displayType = "float-top";
                    break;
                case 3:
                    a.displayType = "float-bottom";
                    break;
                default:
                    a.displayType = "inlay-float"
            }
            var c = f.rb(a), d = {L: c.displayType, v: c.styleType, Ja: c.stuffType};
            if (!f.Va(d))return q;
            (new h({Y: f.ib(c.slotId, b), X: c.slotId, type: c.xuantingType, src: "", width: c.slotWidth, height: c.slotHeight, v: c.styleType, Ka: c.tn, qa: c.channel, Na: c.unionAccount, na: c.adIndex, Fa: c.pvId, $: c.delayIn, aa: c.delayOut, W: c.sessionSync, F: c.closeFor, Da: c.paramString, Ga: c.serviceUrl})).vc();
            f.ub(d)
        }}
    });
})();