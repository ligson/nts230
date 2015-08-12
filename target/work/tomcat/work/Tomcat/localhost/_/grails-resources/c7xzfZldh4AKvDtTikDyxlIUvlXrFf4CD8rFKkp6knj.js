if (typeof jwplayer == "undefined") {
    jwplayer = function (a) {
        if (jwplayer.api) {
            return jwplayer.api.selectPlayer(a)
        }
    };
    jwplayer.version = "6.11.0";
    jwplayer.vid = document.createElement("video");
    jwplayer.audio = document.createElement("audio");
    jwplayer.source = document.createElement("source");
    (function () {
        var l = this;
        var a = {};
        var f = Array.prototype, r = Object.prototype, t = Function.prototype;
        var k = f.slice, d = f.concat, n = r.toString, i = r.hasOwnProperty;
        var e = f.map, h = f.forEach, g = f.filter, p = f.some, m = f.indexOf, b = Array.isArray, q = Object.keys;
        var s = function (u) {
            if (u instanceof s) {
                return u
            }
            if (!(this instanceof s)) {
                return new s(u)
            }
        };
        var c = s.each = s.forEach = function (z, w, v) {
            if (z == null) {
                return z
            }
            if (h && z.forEach === h) {
                z.forEach(w, v)
            } else {
                if (z.length === +z.length) {
                    for (var u = 0, y = z.length; u < y; u++) {
                        if (w.call(v, z[u], u, z) === a) {
                            return
                        }
                    }
                } else {
                    var x = s.keys(z);
                    for (var u = 0, y = x.length; u < y; u++) {
                        if (w.call(v, z[x[u]], x[u], z) === a) {
                            return
                        }
                    }
                }
            }
            return z
        };
        s.map = s.collect = function (x, w, v) {
            var u = [];
            if (x == null) {
                return u
            }
            if (e && x.map === e) {
                return x.map(w, v)
            }
            c(x, function (A, y, z) {
                u.push(w.call(v, A, y, z))
            });
            return u
        };
        s.find = s.detect = function (x, v, w) {
            var u;
            j(x, function (A, y, z) {
                if (v.call(w, A, y, z)) {
                    u = A;
                    return true
                }
            });
            return u
        };
        s.filter = s.select = function (x, u, w) {
            var v = [];
            if (x == null) {
                return v
            }
            if (g && x.filter === g) {
                return x.filter(u, w)
            }
            c(x, function (A, y, z) {
                if (u.call(w, A, y, z)) {
                    v.push(A)
                }
            });
            return v
        };
        var j = s.some = s.any = function (x, v, w) {
            v || (v = s.identity);
            var u = false;
            if (x == null) {
                return u
            }
            if (p && x.some === p) {
                return x.some(v, w)
            }
            c(x, function (A, y, z) {
                if (u || (u = v.call(w, A, y, z))) {
                    return a
                }
            });
            return !!u
        };
        s.size = function (u) {
            if (u == null) {
                return 0
            }
            return u.length === +u.length ? u.length : s.keys(u).length
        };
        s.after = function (v, u) {
            return function () {
                if (--v < 1) {
                    return u.apply(this, arguments)
                }
            }
        };
        var o = function (u) {
            if (u == null) {
                return s.identity
            }
            if (s.isFunction(u)) {
                return u
            }
            return s.property(u)
        };
        s.sortedIndex = function (B, A, x, w) {
            x = o(x);
            var z = x.call(w, A);
            var u = 0, y = B.length;
            while (u < y) {
                var v = (u + y) >>> 1;
                x.call(w, B[v]) < z ? u = v + 1 : y = v
            }
            return u
        };
        s.find = s.detect = function (x, v, w) {
            var u;
            j(x, function (A, y, z) {
                if (v.call(w, A, y, z)) {
                    u = A;
                    return true
                }
            });
            return u
        };
        var j = s.some = s.any = function (x, v, w) {
            v || (v = s.identity);
            var u = false;
            if (x == null) {
                return u
            }
            if (p && x.some === p) {
                return x.some(v, w)
            }
            c(x, function (A, y, z) {
                if (u || (u = v.call(w, A, y, z))) {
                    return a
                }
            });
            return !!u
        };
        s.contains = s.include = function (v, u) {
            if (v == null) {
                return false
            }
            if (v.length !== +v.length) {
                v = s.values(v)
            }
            return s.indexOf(v, u) >= 0
        };
        s.difference = function (v) {
            var u = d.apply(f, k.call(arguments, 1));
            return s.filter(v, function (w) {
                return !s.contains(u, w)
            })
        };
        s.without = function (u) {
            return s.difference(u, k.call(arguments, 1))
        };
        s.indexOf = function (y, w, x) {
            if (y == null) {
                return -1
            }
            var u = 0, v = y.length;
            if (x) {
                if (typeof x == "number") {
                    u = (x < 0 ? Math.max(0, v + x) : x)
                } else {
                    u = s.sortedIndex(y, w);
                    return y[u] === w ? u : -1
                }
            }
            if (m && y.indexOf === m) {
                return y.indexOf(w, x)
            }
            for (; u < v; u++) {
                if (y[u] === w) {
                    return u
                }
            }
            return -1
        };
        s.memoize = function (w, v) {
            var u = {};
            v || (v = s.identity);
            return function () {
                var x = v.apply(this, arguments);
                return s.has(u, x) ? u[x] : (u[x] = w.apply(this, arguments))
            }
        };
        s.keys = function (w) {
            if (!s.isObject(w)) {
                return []
            }
            if (q) {
                return q(w)
            }
            var v = [];
            for (var u in w) {
                if (s.has(w, u)) {
                    v.push(u)
                }
            }
            return v
        };
        s.pick = function (v) {
            var w = {};
            var u = d.apply(f, k.call(arguments, 1));
            c(u, function (x) {
                if (x in v) {
                    w[x] = v[x]
                }
            });
            return w
        };
        s.isArray = b || function (u) {
            return n.call(u) == "[object Array]"
        };
        s.isObject = function (u) {
            return u === Object(u)
        };
        c(["Arguments", "Function", "String", "Number", "Date", "RegExp"], function (u) {
            s["is" + u] = function (v) {
                return n.call(v) == "[object " + u + "]"
            }
        });
        if (!s.isArguments(arguments)) {
            s.isArguments = function (u) {
                return !!(u && s.has(u, "callee"))
            }
        }
        if (typeof(/./) !== "function") {
            s.isFunction = function (u) {
                return typeof u === "function"
            }
        }
        s.isFinite = function (u) {
            return isFinite(u) && !isNaN(parseFloat(u))
        };
        s.isNaN = function (u) {
            return s.isNumber(u) && u != +u
        };
        s.isBoolean = function (u) {
            return u === true || u === false || n.call(u) == "[object Boolean]"
        };
        s.isNull = function (u) {
            return u === null
        };
        s.isUndefined = function (u) {
            return u === void 0
        };
        s.has = function (v, u) {
            return i.call(v, u)
        };
        s.identity = function (u) {
            return u
        };
        s.constant = function (u) {
            return function () {
                return u
            }
        };
        s.property = function (u) {
            return function (v) {
                return v[u]
            }
        };
        l._ = s
    }).call(jwplayer);
    (function (c) {
        var h = c.utils = {};
        var i = c._;
        h.exists = function (m) {
            switch (typeof(m)) {
                case"string":
                    return (m.length > 0);
                case"object":
                    return (m !== null);
                case"undefined":
                    return false
            }
            return true
        };
        h.styleDimension = function (m) {
            return m + (m.toString().indexOf("%") > 0 ? "" : "px")
        };
        h.getAbsolutePath = function (s, r) {
            if (!h.exists(r)) {
                r = document.location.href
            }
            if (!h.exists(s)) {
                return
            }
            if (a(s)) {
                return s
            }
            var t = r.substring(0, r.indexOf("://") + 3);
            var q = r.substring(t.length, r.indexOf("/", t.length + 1));
            var n;
            if (s.indexOf("/") === 0) {
                n = s.split("/")
            } else {
                var o = r.split("?")[0];
                o = o.substring(t.length + q.length + 1, o.lastIndexOf("/"));
                n = o.split("/").concat(s.split("/"))
            }
            var m = [];
            for (var p = 0; p < n.length; p++) {
                if (!n[p] || !h.exists(n[p]) || n[p] === ".") {
                    continue
                } else {
                    if (n[p] === "..") {
                        m.pop()
                    } else {
                        m.push(n[p])
                    }
                }
            }
            return t + q + "/" + m.join("/")
        };
        function a(n) {
            if (!h.exists(n)) {
                return
            }
            var o = n.indexOf("://");
            var m = n.indexOf("?");
            return (o > 0 && (m < 0 || (m > o)))
        }

        h.extend = function () {
            var n = Array.prototype.slice.call(arguments, 0);
            if (n.length > 1) {
                var p = n[0], m = function (r, q) {
                    if (q !== undefined && q !== null) {
                        p[r] = q
                    }
                };
                for (var o = 1; o < n.length; o++) {
                    h.foreach(n[o], m)
                }
                return p
            }
            return null
        };
        var d = window.console = window.console || {
            log: function () {
            }
        };
        h.log = function () {
            var m = Array.prototype.slice.call(arguments, 0);
            if (typeof d.log === "object") {
                d.log(m)
            } else {
                d.log.apply(d, m)
            }
        };
        var e = i.memoize(function (n) {
            var m = navigator.userAgent.toLowerCase();
            return (m.match(n) !== null)
        });

        function l(m) {
            return function () {
                return e(m)
            }
        }

        h.isFF = l(/firefox/i);
        h.isChrome = l(/chrome/i);
        h.isIPod = l(/iP(hone|od)/i);
        h.isIPad = l(/iPad/i);
        h.isSafari602 = l(/Macintosh.*Mac OS X 10_8.*6\.0\.\d* Safari/i);
        h.isIETrident = function (m) {
            if (m) {
                m = parseFloat(m).toFixed(1);
                return e(new RegExp("trident/.+rv:\\s*" + m, "i"))
            }
            return e(/trident/i)
        };
        h.isMSIE = function (m) {
            if (m) {
                m = parseFloat(m).toFixed(1);
                return e(new RegExp("msie\\s*" + m, "i"))
            }
            return e(/msie/i)
        };
        h.isIE = function (m) {
            if (m) {
                m = parseFloat(m).toFixed(1);
                if (m >= 11) {
                    return h.isIETrident(m)
                } else {
                    return h.isMSIE(m)
                }
            }
            return h.isMSIE() || h.isIETrident()
        };
        h.isSafari = function () {
            return (e(/safari/i) && !e(/chrome/i) && !e(/chromium/i) && !e(/android/i))
        };
        h.isIOS = function (m) {
            if (m) {
                return e(new RegExp("iP(hone|ad|od).+\\sOS\\s" + m, "i"))
            }
            return e(/iP(hone|ad|od)/i)
        };
        h.isAndroidNative = function (m) {
            return h.isAndroid(m, true)
        };
        h.isAndroid = function (m, n) {
            if (n && e(/chrome\/[123456789]/i) && !e(/chrome\/18/)) {
                return false
            }
            if (m) {
                if (h.isInt(m) && !/\./.test(m)) {
                    m = "" + m + "."
                }
                return e(new RegExp("Android\\s*" + m, "i"))
            }
            return e(/Android/i)
        };
        h.isMobile = function () {
            return h.isIOS() || h.isAndroid()
        };
        h.isIframe = function () {
            return (window.frameElement && (window.frameElement.nodeName === "IFRAME"))
        };
        h.saveCookie = function (m, n) {
            document.cookie = "jwplayer." + m + "=" + n + "; path=/"
        };
        h.getCookies = function () {
            var p = {};
            var o = document.cookie.split("; ");
            for (var n = 0; n < o.length; n++) {
                var m = o[n].split("=");
                if (m[0].indexOf("jwplayer.") === 0) {
                    p[m[0].substring(9, m[0].length)] = m[1]
                }
            }
            return p
        };
        h.isInt = function (m) {
            return parseFloat(m) % 1 === 0
        };
        h.typeOf = function (n) {
            if (n === null) {
                return "null"
            }
            var m = typeof n;
            if (m === "object") {
                if (i.isArray(n)) {
                    return "array"
                }
            }
            return m
        };
        h.translateEventResponse = function (o, m) {
            var q = h.extend({}, m);
            if (o === c.events.JWPLAYER_FULLSCREEN && !q.fullscreen) {
                q.fullscreen = (q.message === "true");
                delete q.message
            } else {
                if (typeof q.data === "object") {
                    var p = q.data;
                    delete q.data;
                    q = h.extend(q, p)
                } else {
                    if (typeof q.metadata === "object") {
                        h.deepReplaceKeyName(q.metadata, ["__dot__", "__spc__", "__dsh__", "__default__"], [".", " ", "-", "default"])
                    }
                }
            }
            var n = ["position", "duration", "offset"];
            h.foreach(n, function (r, s) {
                if (q[s]) {
                    q[s] = Math.round(q[s] * 1000) / 1000
                }
            });
            return q
        };
        h.flashVersion = function () {
            if (h.isAndroid()) {
                return 0
            }
            var m = navigator.plugins, n;
            try {
                if (m !== "undefined") {
                    n = m["Shockwave Flash"];
                    if (n) {
                        return parseInt(n.description.replace(/\D+(\d+)\..*/, "$1"), 10)
                    }
                }
            } catch (p) {
            }
            if (typeof window.ActiveXObject !== "undefined") {
                try {
                    n = new window.ActiveXObject("ShockwaveFlash.ShockwaveFlash");
                    if (n) {
                        return parseInt(n.GetVariable("$version").split(" ")[1].split(",")[0], 10)
                    }
                } catch (o) {
                }
            }
            return 0
        };
        h.getScriptPath = function (o) {
            var m = document.getElementsByTagName("script");
            for (var n = 0; n < m.length; n++) {
                var p = m[n].src;
                if (p && p.indexOf(o) >= 0) {
                    return p.substr(0, p.indexOf(o))
                }
            }
            return ""
        };
        h.deepReplaceKeyName = function (p, n, m) {
            switch (c.utils.typeOf(p)) {
                case"array":
                    for (var o = 0; o < p.length; o++) {
                        p[o] = c.utils.deepReplaceKeyName(p[o], n, m)
                    }
                    break;
                case"object":
                    h.foreach(p, function (s, u) {
                        var t;
                        if (n instanceof Array && m instanceof Array) {
                            if (n.length !== m.length) {
                                return
                            } else {
                                t = n
                            }
                        } else {
                            t = [n]
                        }
                        var q = s;
                        for (var r = 0; r < t.length; r++) {
                            q = q.replace(new RegExp(n[r], "g"), m[r])
                        }
                        p[q] = c.utils.deepReplaceKeyName(u, n, m);
                        if (s !== q) {
                            delete p[s]
                        }
                    });
                    break
            }
            return p
        };
        var f = h.pluginPathType = {ABSOLUTE: 0, RELATIVE: 1, CDN: 2};
        h.getPluginPathType = function (n) {
            if (typeof n !== "string") {
                return
            }
            n = n.split("?")[0];
            var o = n.indexOf("://");
            if (o > 0) {
                return f.ABSOLUTE
            }
            var m = n.indexOf("/");
            var p = h.extension(n);
            if (o < 0 && m < 0 && (!p || !isNaN(p))) {
                return f.CDN
            }
            return f.RELATIVE
        };
        h.getPluginName = function (m) {
            return m.replace(/^(.*\/)?([^-]*)-?.*\.(swf|js)$/, "$2")
        };
        h.getPluginVersion = function (m) {
            return m.replace(/[^-]*-?([^\.]*).*$/, "$1")
        };
        h.isYouTube = function (n, m) {
            return (m === "youtube") || (/^(http|\/\/).*(youtube\.com|youtu\.be)\/.+/).test(n)
        };
        h.youTubeID = function (n) {
            try {
                return (/v[=\/]([^?&]*)|youtu\.be\/([^?]*)|^([\w-]*)$/i).exec(n).slice(1).join("").replace("?", "")
            } catch (m) {
                return ""
            }
        };
        h.isRtmp = function (m, n) {
            return (m.indexOf("rtmp") === 0 || n === "rtmp")
        };
        h.foreach = function (n, m) {
            var o, p;
            for (o in n) {
                if (h.typeOf(n.hasOwnProperty) === "function") {
                    if (n.hasOwnProperty(o)) {
                        p = n[o];
                        m(o, p)
                    }
                } else {
                    p = n[o];
                    m(o, p)
                }
            }
        };
        h.isHTTPS = function () {
            return (window.location.href.indexOf("https") === 0)
        };
        h.repo = function () {
            var m = "http://developer.ouknow.com/js/jwplayer/img/";
            try {
                if (h.isHTTPS()) {
                    m = m.replace("http://", "https://ssl.")
                }
            } catch (n) {
            }
            return m
        };
        h.versionCheck = function (o) {
            var q = ("0" + o).split(/\W/);
            var p = c.version.split(/\W/);
            var n = parseFloat(q[0]);
            var m = parseFloat(p[0]);
            if (n > m) {
                return false
            } else {
                if (n === m) {
                    if (parseFloat("0" + q[1]) > parseFloat(p[1])) {
                        return false
                    }
                }
            }
            return true
        };
        h.ajax = function (s, q, m, r) {
            var o;
            var p = false;
            if (s.indexOf("#") > 0) {
                s = s.replace(/#.*$/, "")
            }
            if (b(s) && h.exists(window.XDomainRequest)) {
                o = new window.XDomainRequest();
                o.onload = k(o, s, q, m, r);
                o.ontimeout = o.onprogress = function () {
                };
                o.timeout = 5000
            } else {
                if (h.exists(window.XMLHttpRequest)) {
                    o = new window.XMLHttpRequest();
                    o.onreadystatechange = g(o, s, q, m, r)
                } else {
                    if (m) {
                        m("", s, o)
                    }
                    return o
                }
            }
            if (o.overrideMimeType) {
                o.overrideMimeType("text/xml")
            }
            o.onerror = j(m, s, o);
            try {
                o.open("GET", s, true)
            } catch (n) {
                p = true
            }
            setTimeout(function () {
                if (p) {
                    if (m) {
                        m(s, s, o)
                    }
                    return
                }
                try {
                    o.send()
                } catch (t) {
                    if (m) {
                        m(s, s, o)
                    }
                }
            }, 0);
            return o
        };
        function b(m) {
            return (m && m.indexOf("://") >= 0) && (m.split("/")[2] !== window.location.href.split("/")[2])
        }

        function j(m, o, n) {
            return function () {
                m("Error loading file", o, n)
            }
        }

        function g(n, q, o, m, p) {
            return function () {
                if (n.readyState === 4) {
                    switch (n.status) {
                        case 200:
                            k(n, q, o, m, p)();
                            break;
                        case 404:
                            m("File not found", q, n)
                    }
                }
            }
        }

        function k(n, q, o, m, p) {
            return function () {
                var r, u;
                if (p) {
                    o(n)
                } else {
                    try {
                        r = n.responseXML;
                        if (r) {
                            u = r.firstChild;
                            if (r.lastChild && r.lastChild.nodeName === "parsererror") {
                                if (m) {
                                    m("Invalid XML", q, n)
                                }
                                return
                            }
                        }
                    } catch (t) {
                    }
                    if (r && u) {
                        return o(n)
                    }
                    var s = h.parseXML(n.responseText);
                    if (s && s.firstChild) {
                        n = h.extend({}, n, {responseXML: s})
                    } else {
                        if (m) {
                            m(n.responseText ? "Invalid XML" : q, q, n)
                        }
                        return
                    }
                    o(n)
                }
            }
        }

        h.parseXML = function (m) {
            var n;
            try {
                if (window.DOMParser) {
                    n = (new window.DOMParser()).parseFromString(m, "text/xml");
                    if (n.childNodes && n.childNodes.length && n.childNodes[0].firstChild.nodeName === "parsererror") {
                        return
                    }
                } else {
                    n = new window.ActiveXObject("Microsoft.XMLDOM");
                    n.async = "false";
                    n.loadXML(m)
                }
            } catch (o) {
                return
            }
            return n
        };
        h.between = function (n, o, m) {
            return Math.max(Math.min(n, m), o)
        };
        h.seconds = function (o) {
            if (i.isNumber(o)) {
                return o
            }
            o = o.replace(",", ".");
            var m = o.split(":");
            var n = 0;
            if (o.slice(-1) === "s") {
                n = parseFloat(o)
            } else {
                if (o.slice(-1) === "m") {
                    n = parseFloat(o) * 60
                } else {
                    if (o.slice(-1) === "h") {
                        n = parseFloat(o) * 3600
                    } else {
                        if (m.length > 1) {
                            n = parseFloat(m[m.length - 1]);
                            n += parseFloat(m[m.length - 2]) * 60;
                            if (m.length === 3) {
                                n += parseFloat(m[m.length - 3]) * 3600
                            }
                        } else {
                            n = parseFloat(o)
                        }
                    }
                }
            }
            return n
        };
        h.serialize = function (m) {
            if (m === null) {
                return null
            } else {
                if (m.toString().toLowerCase() === "true") {
                    return true
                } else {
                    if (m.toString().toLowerCase() === "false") {
                        return false
                    } else {
                        if (isNaN(Number(m)) || m.length > 5 || m.length === 0) {
                            return m
                        } else {
                            return Number(m)
                        }
                    }
                }
            }
        };
        h.addClass = function (o, n) {
            var m = i.isString(o.className) ? o.className.split(" ") : [];
            var p = i.isArray(n) ? n : n.split(" ");
            i.each(p, function (q) {
                if (!i.contains(m, q)) {
                    m.push(q)
                }
            });
            o.className = h.trim(m.join(" "))
        };
        h.removeClass = function (o, p) {
            var n = i.isString(o.className) ? o.className.split(" ") : [];
            var m = i.isArray(p) ? p : p.split(" ");
            o.className = h.trim(i.difference(n, m).join(" "))
        };
        h.indexOf = i.indexOf;
        h.noop = function () {
        };
        h.canCast = function () {
            var m = c.cast;
            return !!(m && i.isFunction(m.available) && m.available())
        }
    })(jwplayer);
    (function (j) {
        var p = j.utils, g = 50000, b = {}, s, a = {}, i = null, o = {}, c = false;

        function q(u) {
            var v = document.createElement("style");
            if (u) {
                v.appendChild(document.createTextNode(u))
            }
            v.type = "text/css";
            document.getElementsByTagName("head")[0].appendChild(v);
            return v
        }

        p.cssKeyframes = function (x, y) {
            var v = b.keyframes;
            if (!v) {
                v = q();
                b.keyframes = v
            }
            var w = v.sheet;
            var u = "@keyframes " + x + " { " + y + " }";
            n(w, u, w.cssRules.length);
            n(w, u.replace(/(keyframes|transform)/g, "-webkit-$1"), w.cssRules.length)
        };
        var k = p.css = function (v, x, w) {
            w = w || false;
            if (!a[v]) {
                a[v] = {}
            }
            if (!d(a[v], x, w)) {
                return
            }
            if (c) {
                if (b[v]) {
                    b[v].parentNode.removeChild(b[v])
                }
                b[v] = q(r(v));
                return
            }
            if (!b[v]) {
                var u = s && s.sheet && s.sheet.cssRules && s.sheet.cssRules.length || 0;
                if (!s || u > g) {
                    s = q()
                }
                b[v] = s
            }
            if (i !== null) {
                i.styleSheets[v] = a[v];
                return
            }
            f(v)
        };
        k.style = function (x, w, u) {
            if (x === undefined || x === null) {
                return
            }
            if (x.length === undefined) {
                x = [x]
            }
            var v = {};
            t(v, w);
            if (i !== null && !u) {
                x.__cssRules = e(x.__cssRules, v);
                if (i.elements.indexOf(x) < 0) {
                    i.elements.push(x)
                }
                return
            }
            m(x, v)
        };
        k.block = function (u) {
            if (i === null) {
                i = {id: u, styleSheets: {}, elements: []}
            }
        };
        k.unblock = function (x) {
            if (i && (!x || i.id === x)) {
                for (var u in i.styleSheets) {
                    f(u)
                }
                for (var v = 0; v < i.elements.length; v++) {
                    var w = i.elements[v];
                    m(w, w.__cssRules)
                }
                i = null
            }
        };
        function e(v, u) {
            v = v || {};
            for (var w in u) {
                v[w] = u[w]
            }
            return v
        }

        function d(v, y, u) {
            var x = false, w, z;
            for (w in y) {
                z = h(w, y[w], u);
                if (z !== "") {
                    if (z !== v[w]) {
                        v[w] = z;
                        x = true
                    }
                } else {
                    if (v[w] !== undefined) {
                        delete v[w];
                        x = true
                    }
                }
            }
            return x
        }

        function t(u, w) {
            for (var v in w) {
                u[v] = h(v, w[v])
            }
        }

        function l(u) {
            u = u.split("-");
            for (var v = 1; v < u.length; v++) {
                u[v] = u[v].charAt(0).toUpperCase() + u[v].slice(1)
            }
            return u.join("")
        }

        function h(w, x, u) {
            if (!p.exists(x)) {
                return ""
            }
            var v = u ? " !important" : "";
            if (typeof x === "string" && isNaN(x)) {
                if ((/png|gif|jpe?g/i).test(x) && x.indexOf("url") < 0) {
                    return "url(" + x + ")"
                }
                return x + v
            }
            if (x === 0 || w === "z-index" || w === "opacity") {
                return "" + x + v
            }
            if ((/color/i).test(w)) {
                return "#" + p.pad(x.toString(16).replace(/^0x/i, ""), 6) + v
            }
            return Math.ceil(x) + "px" + v
        }

        function m(z, u) {
            for (var x = 0; x < z.length; x++) {
                var w = z[x], y, v;
                if (w !== undefined && w !== null) {
                    for (y in u) {
                        v = l(y);
                        if (w.style[v] !== u[y]) {
                            w.style[v] = u[y]
                        }
                    }
                }
            }
        }

        function f(u) {
            var x = b[u].sheet, w, y, v;
            if (x) {
                w = x.cssRules;
                y = o[u];
                v = r(u);
                if (y !== undefined && y < w.length && w[y].selectorText === u) {
                    if (v === w[y].cssText) {
                        return
                    }
                    x.deleteRule(y)
                } else {
                    y = w.length;
                    o[u] = y
                }
                n(x, v, y)
            }
        }

        function n(v, x, u) {
            try {
                v.insertRule(x, u)
            } catch (w) {
            }
        }

        function r(u) {
            var w = a[u];
            u += " { ";
            for (var v in w) {
                u += v + ": " + w[v] + "; "
            }
            return u + "}"
        }

        p.clearCss = function (v) {
            for (var w in a) {
                if (w.indexOf(v) >= 0) {
                    delete a[w]
                }
            }
            for (var u in b) {
                if (u.indexOf(v) >= 0) {
                    f(u)
                }
            }
        };
        p.transform = function (v, x) {
            var u = "transform", w = {};
            x = x || "";
            w[u] = x;
            w["-webkit-" + u] = x;
            w["-ms-" + u] = x;
            w["-moz-" + u] = x;
            w["-o-" + u] = x;
            if (typeof v === "string") {
                k(v, w)
            } else {
                k.style(v, w)
            }
        };
        p.dragStyle = function (u, v) {
            k(u, {
                "-webkit-user-select": v,
                "-moz-user-select": v,
                "-ms-user-select": v,
                "-webkit-user-drag": v,
                "user-select": v,
                "user-drag": v
            })
        };
        p.transitionStyle = function (u, v) {
            if (navigator.userAgent.match(/5\.\d(\.\d)? safari/i)) {
                return
            }
            k(u, {"-webkit-transition": v, "-moz-transition": v, "-o-transition": v, transition: v})
        };
        p.rotate = function (u, v) {
            p.transform(u, "rotate(" + v + "deg)")
        };
        p.rgbHex = function (u) {
            var v = String(u).replace("#", "");
            if (v.length === 3) {
                v = v[0] + v[0] + v[1] + v[1] + v[2] + v[2]
            }
            return "#" + v.substr(-6)
        };
        p.hexToRgba = function (w, v) {
            var x = "rgb";
            var u = [parseInt(w.substr(1, 2), 16), parseInt(w.substr(3, 2), 16), parseInt(w.substr(5, 2), 16)];
            if (v !== undefined && v !== 100) {
                x += "a";
                u.push(v / 100)
            }
            return x + "(" + u.join(",") + ")"
        }
    })(jwplayer);
    (function (o) {
        var e = "video/", h = "audio/", j = "mp4", c = "webm", n = "ogg", b = "aac", k = "mp3", l = "vorbis", d = o.foreach, m = {
            mp4: e + j,
            ogg: e + n,
            oga: h + n,
            vorbis: h + n,
            webm: e + c,
            aac: h + j,
            mp3: h + "mpeg",
            hls: "application/vnd.apple.mpegurl"
        }, g = {
            mp4: m[j],
            f4v: m[j],
            m4v: m[j],
            mov: m[j],
            m4a: m[b],
            f4a: m[b],
            aac: m[b],
            mp3: m[k],
            ogv: m[n],
            ogg: m[n],
            oga: m[l],
            vorbis: m[l],
            webm: m[c],
            m3u8: m.hls,
            m3u: m.hls,
            hls: m.hls
        }, i = "video", f = {
            flv: i,
            f4v: i,
            mov: i,
            m4a: i,
            m4v: i,
            mp4: i,
            aac: i,
            f4a: i,
            mp3: "sound",
            smil: "rtmp",
            m3u8: "hls",
            hls: "hls"
        };
        var a = o.extensionmap = {};
        d(g, function (p, q) {
            a[p] = {html5: q}
        });
        d(f, function (p, q) {
            if (!a[p]) {
                a[p] = {}
            }
            a[p].flash = q
        });
        a.types = m;
        a.mimeType = function (q) {
            var p;
            d(m, function (r, s) {
                if (!p && s == q) {
                    p = r
                }
            });
            return p
        };
        a.extType = function (p) {
            return a.mimeType(g[p])
        }
    })(jwplayer.utils);
    (function (b) {
        var a = b.loaderstatus = {NEW: 0, LOADING: 1, ERROR: 2, COMPLETE: 3}, c = document;
        b.scriptloader = function (d) {
            var g = jwplayer.events, i = b.extend(this, new g.eventdispatcher()), e = a.NEW;
            this.load = function () {
                if (e == a.NEW) {
                    var k = b.scriptloader.loaders[d];
                    if (k) {
                        e = k.getStatus();
                        if (e < 2) {
                            k.addEventListener(g.ERROR, f);
                            k.addEventListener(g.COMPLETE, h);
                            return
                        }
                    }
                    var j = c.createElement("script");
                    if (j.addEventListener) {
                        j.onload = h;
                        j.onerror = f
                    } else {
                        if (j.readyState) {
                            j.onreadystatechange = function (l) {
                                if (j.readyState == "loaded" || j.readyState == "complete") {
                                    h(l)
                                }
                            }
                        }
                    }
                    c.getElementsByTagName("head")[0].appendChild(j);
                    j.src = d;
                    e = a.LOADING;
                    b.scriptloader.loaders[d] = this
                }
            };
            function f(j) {
                e = a.ERROR;
                i.sendEvent(g.ERROR, j)
            }

            function h(j) {
                e = a.COMPLETE;
                i.sendEvent(g.COMPLETE, j)
            }

            this.getStatus = function () {
                return e
            }
        };
        b.scriptloader.loaders = {}
    })(jwplayer.utils);
    (function (a) {
        a.trim = function (c) {
            return c.replace(/^\s+|\s+$/g, "")
        };
        a.pad = function (e, d, c) {
            if (!c) {
                c = "0"
            }
            while (e.length < d) {
                e = c + e
            }
            return e
        };
        a.xmlAttribute = function (c, d) {
            for (var e = 0; e < c.attributes.length; e++) {
                if (c.attributes[e].name && c.attributes[e].name.toLowerCase() === d.toLowerCase()) {
                    return c.attributes[e].value.toString()
                }
            }
            return ""
        };
        function b(c) {
            if (c.indexOf("(format=m3u8-") > -1) {
                return "m3u8"
            } else {
                return false
            }
        }

        a.extension = function (d) {
            if (!d || d.substr(0, 4) === "rtmp") {
                return ""
            }
            var c = b(d);
            if (c) {
                return c
            }
            d = d.substring(d.lastIndexOf("/") + 1, d.length).split("?")[0].split("#")[0];
            if (d.lastIndexOf(".") > -1) {
                return d.substr(d.lastIndexOf(".") + 1, d.length).toLowerCase()
            }
        };
        a.stringToColor = function (c) {
            c = c.replace(/(#|0x)?([0-9A-F]{3,6})$/gi, "$2");
            if (c.length === 3) {
                c = c.charAt(0) + c.charAt(0) + c.charAt(1) + c.charAt(1) + c.charAt(2) + c.charAt(2)
            }
            return parseInt(c, 16)
        }
    })(jwplayer.utils);
    (function (b) {
        var c = "touchmove", d = "touchstart", a = "touchend", e = "touchcancel";
        b.touch = function (f) {
            var q = f, k = false, g = {}, i = null, l = false, j = b.touchEvents;
            document.addEventListener(c, h);
            document.addEventListener(a, n);
            document.addEventListener(e, h);
            f.addEventListener(d, h);
            f.addEventListener(a, h);
            function n(r) {
                if (k) {
                    if (l) {
                        o(j.DRAG_END, r)
                    }
                }
                l = false;
                k = false;
                i = null
            }

            function h(r) {
                if (r.type === d) {
                    k = true;
                    i = p(j.DRAG_START, r)
                } else {
                    if (r.type === c) {
                        if (k) {
                            if (l) {
                                o(j.DRAG, r)
                            } else {
                                o(j.DRAG_START, r, i);
                                l = true;
                                o(j.DRAG, r)
                            }
                        }
                    } else {
                        if (k) {
                            if (l) {
                                o(j.DRAG_END, r)
                            } else {
                                r.cancelBubble = true;
                                o(j.TAP, r)
                            }
                        }
                        l = false;
                        k = false;
                        i = null
                    }
                }
            }

            function o(s, t, u) {
                if (g[s]) {
                    m(t);
                    var r = u ? u : p(s, t);
                    if (r) {
                        g[s](r)
                    }
                }
            }

            function p(s, u) {
                var v = null;
                if (u.touches && u.touches.length) {
                    v = u.touches[0]
                } else {
                    if (u.changedTouches && u.changedTouches.length) {
                        v = u.changedTouches[0]
                    }
                }
                if (!v) {
                    return null
                }
                var t = q.getBoundingClientRect();
                var r = {
                    type: s,
                    target: q,
                    x: ((v.pageX - window.pageXOffset) - t.left),
                    y: v.pageY,
                    deltaX: 0,
                    deltaY: 0
                };
                if (s !== j.TAP && i) {
                    r.deltaX = r.x - i.x;
                    r.deltaY = r.y - i.y
                }
                return r
            }

            function m(r) {
                if (r.preventManipulation) {
                    r.preventManipulation()
                }
                if (r.preventDefault) {
                    r.preventDefault()
                }
            }

            this.addEventListener = function (s, r) {
                g[s] = r
            };
            this.removeEventListener = function (r) {
                delete g[r]
            };
            return this
        }
    })(jwplayer.utils);
    (function (a) {
        a.touchEvents = {
            DRAG: "jwplayerDrag",
            DRAG_START: "jwplayerDragStart",
            DRAG_END: "jwplayerDragEnd",
            TAP: "jwplayerTap"
        }
    })(jwplayer.utils);
    (function (a) {
        a.events = {
            COMPLETE: "COMPLETE",
            ERROR: "ERROR",
            API_READY: "jwplayerAPIReady",
            JWPLAYER_READY: "jwplayerReady",
            JWPLAYER_FULLSCREEN: "jwplayerFullscreen",
            JWPLAYER_RESIZE: "jwplayerResize",
            JWPLAYER_ERROR: "jwplayerError",
            JWPLAYER_SETUP_ERROR: "jwplayerSetupError",
            JWPLAYER_MEDIA_BEFOREPLAY: "jwplayerMediaBeforePlay",
            JWPLAYER_MEDIA_BEFORECOMPLETE: "jwplayerMediaBeforeComplete",
            JWPLAYER_COMPONENT_SHOW: "jwplayerComponentShow",
            JWPLAYER_COMPONENT_HIDE: "jwplayerComponentHide",
            JWPLAYER_MEDIA_BUFFER: "jwplayerMediaBuffer",
            JWPLAYER_MEDIA_BUFFER_FULL: "jwplayerMediaBufferFull",
            JWPLAYER_MEDIA_ERROR: "jwplayerMediaError",
            JWPLAYER_MEDIA_LOADED: "jwplayerMediaLoaded",
            JWPLAYER_MEDIA_COMPLETE: "jwplayerMediaComplete",
            JWPLAYER_MEDIA_SEEK: "jwplayerMediaSeek",
            JWPLAYER_MEDIA_TIME: "jwplayerMediaTime",
            JWPLAYER_MEDIA_VOLUME: "jwplayerMediaVolume",
            JWPLAYER_MEDIA_META: "jwplayerMediaMeta",
            JWPLAYER_MEDIA_MUTE: "jwplayerMediaMute",
            JWPLAYER_AUDIO_TRACKS: "jwplayerAudioTracks",
            JWPLAYER_AUDIO_TRACK_CHANGED: "jwplayerAudioTrackChanged",
            JWPLAYER_MEDIA_LEVELS: "jwplayerMediaLevels",
            JWPLAYER_MEDIA_LEVEL_CHANGED: "jwplayerMediaLevelChanged",
            JWPLAYER_CAPTIONS_CHANGED: "jwplayerCaptionsChanged",
            JWPLAYER_CAPTIONS_LIST: "jwplayerCaptionsList",
            JWPLAYER_CAPTIONS_LOADED: "jwplayerCaptionsLoaded",
            JWPLAYER_PLAYER_STATE: "jwplayerPlayerState",
            state: {BUFFERING: "BUFFERING", IDLE: "IDLE", PAUSED: "PAUSED", PLAYING: "PLAYING"},
            JWPLAYER_PLAYLIST_LOADED: "jwplayerPlaylistLoaded",
            JWPLAYER_PLAYLIST_ITEM: "jwplayerPlaylistItem",
            JWPLAYER_PLAYLIST_COMPLETE: "jwplayerPlaylistComplete",
            JWPLAYER_DISPLAY_CLICK: "jwplayerViewClick",
            JWPLAYER_PROVIDER_CLICK: "jwplayerProviderClick",
            JWPLAYER_VIEW_TAB_FOCUS: "jwplayerViewTabFocus",
            JWPLAYER_CONTROLS: "jwplayerViewControls",
            JWPLAYER_USER_ACTION: "jwplayerUserAction",
            JWPLAYER_INSTREAM_CLICK: "jwplayerInstreamClicked",
            JWPLAYER_INSTREAM_DESTROYED: "jwplayerInstreamDestroyed",
            JWPLAYER_AD_TIME: "jwplayerAdTime",
            JWPLAYER_AD_ERROR: "jwplayerAdError",
            JWPLAYER_AD_CLICK: "jwplayerAdClicked",
            JWPLAYER_AD_COMPLETE: "jwplayerAdComplete",
            JWPLAYER_AD_IMPRESSION: "jwplayerAdImpression",
            JWPLAYER_AD_COMPANIONS: "jwplayerAdCompanions",
            JWPLAYER_AD_SKIPPED: "jwplayerAdSkipped",
            JWPLAYER_AD_PLAY: "jwplayerAdPlay",
            JWPLAYER_AD_PAUSE: "jwplayerAdPause",
            JWPLAYER_AD_META: "jwplayerAdMeta",
            JWPLAYER_CAST_AVAILABLE: "jwplayerCastAvailable",
            JWPLAYER_CAST_SESSION: "jwplayerCastSession",
            JWPLAYER_CAST_AD_CHANGED: "jwplayerCastAdChanged"
        }
    })(jwplayer);
    (function (a) {
        var b = a.events, c = a.utils;
        b.eventdispatcher = function (j, d) {
            var f = j, h = d, g, e;
            this.resetEventListeners = function () {
                g = {};
                e = []
            };
            this.resetEventListeners();
            this.addEventListener = function (k, n, m) {
                try {
                    if (!c.exists(g[k])) {
                        g[k] = []
                    }
                    if (c.typeOf(n) === "string") {
                        n = (new Function("return " + n))()
                    }
                    g[k].push({listener: n, count: m || null})
                } catch (l) {
                    c.log("error", l)
                }
                return false
            };
            this.removeEventListener = function (l, n) {
                var k;
                if (!g[l]) {
                    return
                }
                try {
                    if (n === undefined) {
                        g[l] = [];
                        return
                    }
                    for (k = 0; k < g[l].length; k++) {
                        if (g[l][k].listener.toString() === n.toString()) {
                            g[l].splice(k, 1);
                            break
                        }
                    }
                } catch (m) {
                    c.log("error", m)
                }
                return false
            };
            this.addGlobalListener = function (m, l) {
                try {
                    if (c.typeOf(m) === "string") {
                        m = (new Function("return " + m))()
                    }
                    e.push({listener: m, count: l || null})
                } catch (k) {
                    c.log("error", k)
                }
                return false
            };
            this.removeGlobalListener = function (m) {
                if (!m) {
                    return
                }
                try {
                    for (var k = e.length; k--;) {
                        if (e[k].listener.toString() === m.toString()) {
                            e.splice(k, 1)
                        }
                    }
                } catch (l) {
                    c.log("error", l)
                }
                return false
            };
            this.sendEvent = function (k, l) {
                if (!c.exists(l)) {
                    l = {}
                }
                c.extend(l, {id: f, version: a.version, type: k});
                if (h) {
                    c.log(k, l)
                }
                i(g[k], l, k);
                i(e, l, k)
            };
            function i(m, p, l) {
                if (!m) {
                    return
                }
                for (var k = 0; k < m.length; k++) {
                    var o = m[k];
                    if (o) {
                        if (o.count !== null && --o.count === 0) {
                            delete m[k]
                        }
                        try {
                            o.listener(p)
                        } catch (n) {
                            c.log('Error handling "' + l + '" event listener [' + k + "]: " + n.toString(), o.listener, p)
                        }
                    }
                }
            }
        }
    })(window.jwplayer);
    (function (a) {
        var c = {}, b = {};
        a.plugins = function () {
        };
        a.plugins.loadPlugins = function (e, d) {
            b[e] = new a.plugins.pluginloader(new a.plugins.model(c), d);
            return b[e]
        };
        a.plugins.registerPlugin = function (h, g, f, e) {
            var d = a.utils.getPluginName(h);
            if (!c[d]) {
                c[d] = new a.plugins.plugin(h)
            }
            c[d].registerPlugin(h, g, f, e)
        }
    })(jwplayer);
    (function (a) {
        a.plugins.model = function (b) {
            this.addPlugin = function (c) {
                var d = a.utils.getPluginName(c);
                if (!b[d]) {
                    b[d] = new a.plugins.plugin(c)
                }
                return b[d]
            };
            this.getPlugins = function () {
                return b
            }
        }
    })(jwplayer);
    (function (b) {
        var a = jwplayer.utils, c = jwplayer.events, d = "undefined";
        b.pluginmodes = {FLASH: 0, JAVASCRIPT: 1, HYBRID: 2};
        b.plugin = function (e) {
            var l = a.loaderstatus.NEW, m, k, f, n;
            var g = new c.eventdispatcher();
            a.extend(this, g);
            function h() {
                switch (a.getPluginPathType(e)) {
                    case a.pluginPathType.ABSOLUTE:
                        return e;
                    case a.pluginPathType.RELATIVE:
                        return a.getAbsolutePath(e, window.location.href)
                }
            }

            function j() {
                n = setTimeout(function () {
                    l = a.loaderstatus.COMPLETE;
                    g.sendEvent(c.COMPLETE)
                }, 1000)
            }

            function i() {
                l = a.loaderstatus.ERROR;
                g.sendEvent(c.ERROR, {url: e})
            }

            this.load = function () {
                if (l === a.loaderstatus.NEW) {
                    if (e.lastIndexOf(".swf") > 0) {
                        m = e;
                        l = a.loaderstatus.COMPLETE;
                        g.sendEvent(c.COMPLETE);
                        return
                    } else {
                        if (a.getPluginPathType(e) === a.pluginPathType.CDN) {
                            l = a.loaderstatus.COMPLETE;
                            g.sendEvent(c.COMPLETE);
                            return
                        }
                    }
                    l = a.loaderstatus.LOADING;
                    var o = new a.scriptloader(h());
                    o.addEventListener(c.COMPLETE, j);
                    o.addEventListener(c.ERROR, i);
                    o.load()
                }
            };
            this.registerPlugin = function (r, q, p, o) {
                if (n) {
                    clearTimeout(n);
                    n = undefined
                }
                f = q;
                if (p && o) {
                    m = o;
                    k = p
                } else {
                    if (typeof p === "string") {
                        m = p
                    } else {
                        if (typeof p === "function") {
                            k = p
                        } else {
                            if (!p && !o) {
                                m = r
                            }
                        }
                    }
                }
                l = a.loaderstatus.COMPLETE;
                g.sendEvent(c.COMPLETE)
            };
            this.getStatus = function () {
                return l
            };
            this.getPluginName = function () {
                return a.getPluginName(e)
            };
            this.getFlashPath = function () {
                if (m) {
                    switch (a.getPluginPathType(m)) {
                        case a.pluginPathType.ABSOLUTE:
                            return m;
                        case a.pluginPathType.RELATIVE:
                            if (e.lastIndexOf(".swf") > 0) {
                                return a.getAbsolutePath(m, window.location.href)
                            }
                            return a.getAbsolutePath(m, h())
                    }
                }
                return null
            };
            this.getJS = function () {
                return k
            };
            this.getTarget = function () {
                return f
            };
            this.getPluginmode = function () {
                if (typeof m !== d && typeof k !== d) {
                    return b.pluginmodes.HYBRID
                } else {
                    if (typeof m !== d) {
                        return b.pluginmodes.FLASH
                    } else {
                        if (typeof k !== d) {
                            return b.pluginmodes.JAVASCRIPT
                        }
                    }
                }
            };
            this.getNewInstance = function (p, o, q) {
                return new k(p, o, q)
            };
            this.getURL = function () {
                return e
            }
        }
    })(jwplayer.plugins);
    (function (c) {
        var a = c.utils, d = c.events, b = c._, e = a.foreach;
        c.plugins.pluginloader = function (l, j) {
            var p = a.loaderstatus.NEW, i = false, f = false, n = j, k = b.size(n), q, g = new d.eventdispatcher();
            a.extend(this, g);
            function h() {
                if (!f) {
                    f = true;
                    p = a.loaderstatus.COMPLETE;
                    g.sendEvent(d.COMPLETE)
                }
            }

            function o() {
                if (!n || b.keys(n).length === 0) {
                    h()
                }
                if (!f) {
                    var r = l.getPlugins();
                    q = b.after(k, h);
                    a.foreach(n, function (t) {
                        var u = a.getPluginName(t), x = r[u], w = x.getJS(), v = x.getTarget(), s = x.getStatus();
                        if (s === a.loaderstatus.LOADING || s === a.loaderstatus.NEW) {
                            return
                        } else {
                            if (w && !a.versionCheck(v)) {
                                g.sendEvent(d.ERROR, {message: "Incompatible player version"})
                            }
                        }
                        q()
                    })
                }
            }

            function m(s) {
                var r = "File not found";
                g.sendEvent(d.ERROR, {message: r});
                if (s.url) {
                    a.log(r, s.url)
                }
                q()
            }

            this.setupPlugins = function (u, s, w) {
                var t = {length: 0, plugins: {}}, v = {length: 0, plugins: {}}, r = l.getPlugins();
                e(s.plugins, function (A, C) {
                    var B = a.getPluginName(A), D = r[B], E = D.getFlashPath(), F = D.getJS(), x = D.getURL();
                    if (E) {
                        t.plugins[E] = a.extend({}, C);
                        t.plugins[E].pluginmode = D.getPluginmode();
                        t.length++
                    }
                    try {
                        if (F && s.plugins && s.plugins[x]) {
                            var y = document.createElement("div");
                            y.id = u.id + "_" + B;
                            y.style.position = "absolute";
                            y.style.top = 0;
                            y.style.zIndex = v.length + 10;
                            v.plugins[B] = D.getNewInstance(u, a.extend({}, s.plugins[x]), y);
                            v.length++;
                            u.onReady(w(v.plugins[B], y, true));
                            u.onResize(w(v.plugins[B], y))
                        }
                    } catch (z) {
                        a.log("ERROR: Failed to load " + B + ".")
                    }
                });
                u.plugins = v.plugins;
                return t
            };
            this.load = function () {
                if (a.exists(j) && a.typeOf(j) !== "object") {
                    o();
                    return
                }
                p = a.loaderstatus.LOADING;
                i = true;
                e(j, function (s) {
                    if (a.exists(s)) {
                        var t = l.addPlugin(s);
                        t.addEventListener(d.COMPLETE, o);
                        t.addEventListener(d.ERROR, m)
                    }
                });
                var r = l.getPlugins();
                e(r, function (s, t) {
                    t.load()
                });
                i = false;
                o()
            };
            this.destroy = function () {
                if (g) {
                    g.resetEventListeners();
                    g = null
                }
            };
            this.pluginFailed = m;
            this.getStatus = function () {
                return p
            }
        }
    })(jwplayer);
    (function (a) {
        a.parsers = {
            localName: function (b) {
                if (!b) {
                    return ""
                } else {
                    if (b.localName) {
                        return b.localName
                    } else {
                        if (b.baseName) {
                            return b.baseName
                        } else {
                            return ""
                        }
                    }
                }
            }, textContent: function (b) {
                if (!b) {
                    return ""
                } else {
                    if (b.textContent) {
                        return a.utils.trim(b.textContent)
                    } else {
                        if (b.text) {
                            return a.utils.trim(b.text)
                        } else {
                            return ""
                        }
                    }
                }
            }, getChildNode: function (c, b) {
                return c.childNodes[b]
            }, numChildren: function (b) {
                if (b.childNodes) {
                    return b.childNodes.length
                } else {
                    return 0
                }
            }
        }
    })(jwplayer);
    (function (b) {
        var a = b.parsers;
        var d = a.jwparser = function () {
        };
        var c = "jwplayer";
        d.parseEntry = function (l, p) {
            var e = [], n = [], m = b.utils.xmlAttribute, f = "default", q = "label", j = "file", o = "type";
            for (var k = 0; k < l.childNodes.length; k++) {
                var h = l.childNodes[k];
                if (h.prefix == c) {
                    var g = a.localName(h);
                    if (g == "source") {
                        delete p.sources;
                        e.push({file: m(h, j), "default": m(h, f), label: m(h, q), type: m(h, o)})
                    } else {
                        if (g == "track") {
                            delete p.tracks;
                            n.push({file: m(h, j), "default": m(h, f), kind: m(h, "kind"), label: m(h, q)})
                        } else {
                            p[g] = b.utils.serialize(a.textContent(h));
                            if (g == "file" && p.sources) {
                                delete p.sources
                            }
                        }
                    }
                }
                if (!p[j]) {
                    p[j] = p.link
                }
            }
            if (e.length) {
                p.sources = [];
                for (k = 0; k < e.length; k++) {
                    if (e[k].file.length > 0) {
                        e[k][f] = (e[k][f] == "true") ? true : false;
                        if (!e[k].label.length) {
                            delete e[k].label
                        }
                        p.sources.push(e[k])
                    }
                }
            }
            if (n.length) {
                p.tracks = [];
                for (k = 0; k < n.length; k++) {
                    if (n[k].file.length > 0) {
                        n[k][f] = (n[k][f] == "true") ? true : false;
                        n[k].kind = (!n[k].kind.length) ? "captions" : n[k].kind;
                        if (!n[k].label.length) {
                            delete n[k].label
                        }
                        p.tracks.push(n[k])
                    }
                }
            }
            return p
        }
    })(jwplayer);
    (function (e) {
        var b = jwplayer.utils, h = b.xmlAttribute, c = e.localName, a = e.textContent, d = e.numChildren;
        var g = e.mediaparser = function () {
        };
        var f = "media";
        g.parseGroup = function (o, q) {
            var n, l, k = "tracks", j = [];

            function p(i) {
                var r = {
                    zh: "Chinese",
                    nl: "Dutch",
                    en: "English",
                    fr: "French",
                    de: "German",
                    it: "Italian",
                    ja: "Japanese",
                    pt: "Portuguese",
                    ru: "Russian",
                    es: "Spanish"
                };
                if (r[i]) {
                    return r[i]
                }
                return i
            }

            for (l = 0; l < d(o); l++) {
                n = o.childNodes[l];
                if (n.prefix == f) {
                    if (!c(n)) {
                        continue
                    }
                    switch (c(n).toLowerCase()) {
                        case"content":
                            if (h(n, "duration")) {
                                q.duration = b.seconds(h(n, "duration"))
                            }
                            if (d(n) > 0) {
                                q = g.parseGroup(n, q)
                            }
                            if (h(n, "url")) {
                                if (!q.sources) {
                                    q.sources = []
                                }
                                q.sources.push({
                                    file: h(n, "url"),
                                    type: h(n, "type"),
                                    width: h(n, "width"),
                                    label: h(n, "label")
                                })
                            }
                            break;
                        case"title":
                            q.title = a(n);
                            break;
                        case"description":
                            q.description = a(n);
                            break;
                        case"guid":
                            q.mediaid = a(n);
                            break;
                        case"thumbnail":
                            if (!q.image) {
                                q.image = h(n, "url")
                            }
                            break;
                        case"player":
                            break;
                        case"group":
                            g.parseGroup(n, q);
                            break;
                        case"subtitle":
                            var m = {};
                            m.file = h(n, "url");
                            m.kind = "captions";
                            if (h(n, "lang").length > 0) {
                                m.label = p(h(n, "lang"))
                            }
                            j.push(m)
                    }
                }
            }
            if (!q.hasOwnProperty(k)) {
                q[k] = []
            }
            for (l = 0; l < j.length; l++) {
                q[k].push(j[l])
            }
            return q
        }
    })(jwplayer.parsers);
    (function (g) {
        var b = jwplayer.utils, a = g.textContent, e = g.getChildNode, f = g.numChildren, d = g.localName;
        g.rssparser = {};
        g.rssparser.parse = function (o) {
            var h = [];
            for (var m = 0; m < f(o); m++) {
                var n = e(o, m), k = d(n).toLowerCase();
                if (k == "channel") {
                    for (var l = 0; l < f(n); l++) {
                        var p = e(n, l);
                        if (d(p).toLowerCase() == "item") {
                            h.push(c(p))
                        }
                    }
                }
            }
            return h
        };
        function c(l) {
            var m = {};
            for (var j = 0; j < l.childNodes.length; j++) {
                var k = l.childNodes[j];
                var h = d(k);
                if (!h) {
                    continue
                }
                switch (h.toLowerCase()) {
                    case"enclosure":
                        m.file = b.xmlAttribute(k, "url");
                        break;
                    case"title":
                        m.title = a(k);
                        break;
                    case"guid":
                        m.mediaid = a(k);
                        break;
                    case"pubdate":
                        m.date = a(k);
                        break;
                    case"description":
                        m.description = a(k);
                        break;
                    case"link":
                        m.link = a(k);
                        break;
                    case"category":
                        if (m.tags) {
                            m.tags += a(k)
                        } else {
                            m.tags = a(k)
                        }
                        break
                }
            }
            m = g.mediaparser.parseGroup(l, m);
            m = g.jwparser.parseEntry(l, m);
            return new jwplayer.playlist.item(m)
        }
    })(jwplayer.parsers);
    (function (d) {
        var b = d.utils;
        var c = d._;
        d.playlist = function (f) {
            var g = [];
            f = (c.isArray(f) ? f : [f]);
            c.each(f, function (h) {
                g.push(new d.playlist.item(h))
            });
            return g
        };
        d.playlist.filterPlaylist = function (h, g) {
            var f = [];
            c.each(h, function (k) {
                k = b.extend({}, k);
                k.sources = e(k.sources, false, g);
                if (!k.sources.length) {
                    return
                }
                for (var i = 0; i < k.sources.length; i++) {
                    k.sources[i].label = k.sources[i].label || i.toString()
                }
                f.push(k)
            });
            return f
        };
        function a(h) {
            if (!h || !h.file) {
                return
            }
            var f = b.trim("" + h.file);
            var g = h.type;
            if (!g) {
                var i = b.extension(f);
                g = b.extensionmap.extType(i)
            }
            return b.extend({}, h, {file: f, type: g})
        }

        var e = d.playlist.filterSources = function (g, i, j) {
            var h, k = [], f = (i ? d.embed.flashCanPlay : d.embed.html5CanPlay);
            if (!g) {
                return
            }
            c.each(g, function (l) {
                var m = a(l);
                if (!m) {
                    return
                }
                if (f(m.file, m.type, j)) {
                    h = h || m.type;
                    if (m.type === h) {
                        k.push(m)
                    }
                }
            });
            return k
        }
    })(jwplayer);
    (function (b) {
        var a = b.item = function (f) {
            var c = jwplayer.utils, e = c.extend({}, a.defaults, f), g, d, h;
            e.tracks = (f && c.exists(f.tracks)) ? f.tracks : [];
            if (e.sources.length === 0) {
                e.sources = [new b.source(e)]
            }
            for (g = 0; g < e.sources.length; g++) {
                h = e.sources[g]["default"];
                if (h) {
                    e.sources[g]["default"] = (h.toString() == "true")
                } else {
                    e.sources[g]["default"] = false
                }
                e.sources[g] = new b.source(e.sources[g])
            }
            if (e.captions && !c.exists(f.tracks)) {
                for (d = 0; d < e.captions.length; d++) {
                    e.tracks.push(e.captions[d])
                }
                delete e.captions
            }
            for (g = 0; g < e.tracks.length; g++) {
                e.tracks[g] = new b.track(e.tracks[g])
            }
            return e
        };
        a.defaults = {
            description: undefined,
            image: undefined,
            mediaid: undefined,
            title: undefined,
            sources: [],
            tracks: []
        }
    })(jwplayer.playlist);
    (function (b) {
        var a = b.utils, d = b.events, c = b.parsers;
        b.playlist.loader = function () {
            var g = new d.eventdispatcher();
            a.extend(this, g);
            this.load = function (i) {
                a.ajax(i, h, f)
            };
            function h(l) {
                try {
                    var n = l.responseXML.childNodes;
                    var o = "";
                    for (var j = 0; j < n.length; j++) {
                        o = n[j];
                        if (o.nodeType !== 8) {
                            break
                        }
                    }
                    if (c.localName(o) === "xml") {
                        o = o.nextSibling
                    }
                    if (c.localName(o) !== "rss") {
                        e("Not a valid RSS feed");
                        return
                    }
                    var k = new b.playlist(c.rssparser.parse(o));
                    g.sendEvent(d.JWPLAYER_PLAYLIST_LOADED, {playlist: k})
                } catch (m) {
                    e()
                }
            }

            function f(i) {
                e(i.match(/invalid/i) ? "Not a valid RSS feed" : "")
            }

            function e(i) {
                g.sendEvent(d.JWPLAYER_ERROR, {message: i ? i : "Error loading file"})
            }
        }
    })(jwplayer);
    (function (d) {
        var b, a = jwplayer.utils, c = {file: b, label: b, type: b, "default": b};
        d.source = function (f) {
            var e = a.extend({}, c);
            a.foreach(c, function (g) {
                if (a.exists(f[g])) {
                    e[g] = f[g];
                    delete f[g]
                }
            });
            if (e.type && e.type.indexOf("/") > 0) {
                e.type = a.extensionmap.mimeType(e.type)
            }
            if (e.type == "m3u8") {
                e.type = "hls"
            }
            if (e.type == "smil") {
                e.type = "rtmp"
            }
            return e
        }
    })(jwplayer.playlist);
    (function (d) {
        var b, a = jwplayer.utils, c = {file: b, label: b, kind: "captions", "default": false};
        d.track = function (e) {
            var f = a.extend({}, c);
            if (!e) {
                e = {}
            }
            a.foreach(c, function (g) {
                if (a.exists(e[g])) {
                    f[g] = e[g];
                    delete e[g]
                }
            });
            return f
        }
    })(jwplayer.playlist);
    (function (e) {
        var c = e.utils, f = e.events, d = e._;
        var h = e.embed = function (s) {
            var m = new h.config(s.config), k = m.width, B = m.height, j = "Error loading player: ", u = document.getElementById(s.id), C = e.plugins.loadPlugins(s.id, m.plugins), w, q = false, y = false, t = -1, A = null, v = this;
            if (m.fallbackDiv) {
                A = m.fallbackDiv;
                delete m.fallbackDiv
            }
            m.id = s.id;
            if (m.aspectratio) {
                s.config.aspectratio = m.aspectratio
            } else {
                delete s.config.aspectratio
            }
            g(s, m.events);
            var n = document.createElement("div");
            n.id = u.id;
            n.style.width = k.toString().indexOf("%") > 0 ? k : (k + "px");
            n.style.height = B.toString().indexOf("%") > 0 ? B : (B + "px");
            u.parentNode.replaceChild(n, u);
            v.embed = function () {
                if (y) {
                    return
                }
                C.addEventListener(f.COMPLETE, p);
                C.addEventListener(f.ERROR, o);
                C.load()
            };
            v.destroy = function () {
                if (C) {
                    C.destroy();
                    C = null
                }
                if (w) {
                    w.resetEventListeners();
                    w = null
                }
            };
            function p() {
                if (y) {
                    return
                }
                var J = m.playlist;
                if (d.isArray(J)) {
                    if (J.length === 0) {
                        r();
                        return
                    }
                    if (J.length === 1) {
                        if (!J[0].sources || J[0].sources.length === 0 || !J[0].sources[0].file) {
                            r();
                            return
                        }
                    }
                }
                if (q) {
                    return
                }
                if (d.isString(J)) {
                    w = new e.playlist.loader();
                    w.addEventListener(f.JWPLAYER_PLAYLIST_LOADED, function (K) {
                        m.playlist = K.playlist;
                        q = false;
                        p()
                    });
                    w.addEventListener(f.JWPLAYER_ERROR, function (K) {
                        q = false;
                        r(K)
                    });
                    q = true;
                    w.load(m.playlist);
                    return
                }
                if (C.getStatus() === c.loaderstatus.COMPLETE) {
                    for (var F = 0; F < m.modes.length; F++) {
                        var I = m.modes[F];
                        var G = I.type;
                        if (G && h[G]) {
                            var D = c.extend({}, m);
                            var E = new h[G](n, I, D, C, s);
                            if (E.supportsConfig()) {
                                E.addEventListener(f.ERROR, i);
                                E.embed();
                                a();
                                return s
                            }
                        }
                    }
                    var H;
                    if (m.fallback) {
                        H = "No suitable players found and fallback enabled";
                        l(H, true);
                        c.log(H);
                        new h.download(n, m, r)
                    } else {
                        H = "No suitable players found and fallback disabled";
                        l(H, false);
                        c.log(H);
                        x()
                    }
                }
            }

            function x() {
                n.parentNode.replaceChild(A, n)
            }

            function i(D) {
                z(j + D.message)
            }

            function o(D) {
                s.dispatchEvent(f.JWPLAYER_ERROR, {message: "Could not load plugin: " + D.message})
            }

            function r(D) {
                if (D && D.message) {
                    z("Error loading playlist: " + D.message)
                } else {
                    z(j + "No playable sources found")
                }
            }

            function l(D, E) {
                clearTimeout(t);
                t = setTimeout(function () {
                    s.dispatchEvent(f.JWPLAYER_SETUP_ERROR, {message: D, fallback: E})
                }, 0)
            }

            function z(D) {
                if (y) {
                    return
                }
                if (!m.fallback) {
                    l(D, false);
                    return
                }
                y = true;
                b(n, D, m);
                l(D, true)
            }

            v.errorScreen = z;
            return v
        };

        function g(j, i) {
            c.foreach(i, function (k, m) {
                var l = j[k];
                if (typeof l === "function") {
                    l.call(j, m)
                }
            })
        }

        function a() {
            c.css("object.jwswf, .jwplayer:focus", {outline: "none"});
            c.css(".jw-tab-focus:focus", {outline: "solid 2px #0B7EF4"})
        }

        function b(i, l, j) {
            var k = i.style;
            k.backgroundColor = "#000";
            k.color = "#FFF";
            k.width = c.styleDimension(j.width);
            k.height = c.styleDimension(j.height);
            k.display = "table";
            k.opacity = 1;
            var n = document.createElement("p"), m = n.style;
            m.verticalAlign = "middle";
            m.textAlign = "center";
            m.display = "table-cell";
            m.font = "15px/20px Arial, Helvetica, sans-serif";
            n.innerHTML = l.replace(":", ":<br>");
            i.innerHTML = "";
            i.appendChild(n)
        }

        e.embed.errorScreen = b
    })(jwplayer);
    (function (e) {
        var h = e.utils, g = e.embed, i = e.playlist.item;
        var a = g.config = function (k) {
            var m = {
                fallback: true,
                height: 270,
                primary: "html5",
                width: 480,
                base: k.base ? k.base : h.getScriptPath("jwplayer.js"),
                aspectratio: ""
            }, l = h.extend({}, m, e.defaults, k), j = {
                html5: {type: "html5", src: l.base + "jwplayer.html5.js"},
                flash: {type: "flash", src: l.base + "jwplayer.flash.swf"}
            };
            l.modes = (l.primary === "flash") ? [j.flash, j.html5] : [j.html5, j.flash];
            if (l.listbar) {
                l.playlistsize = l.listbar.size;
                l.playlistposition = l.listbar.position;
                l.playlistlayout = l.listbar.layout
            }
            if (l.flashplayer) {
                j.flash.src = l.flashplayer
            }
            if (l.html5player) {
                j.html5.src = l.html5player
            }
            d(l);
            f(l);
            return l
        };

        function f(k) {
            var j = k.aspectratio, l = b(j);
            if (k.width.toString().indexOf("%") === -1) {
                delete k.aspectratio
            } else {
                if (!l) {
                    delete k.aspectratio
                } else {
                    k.aspectratio = l
                }
            }
        }

        function b(k) {
            if (typeof k !== "string" || !h.exists(k)) {
                return 0
            }
            var l = k.indexOf(":");
            if (l === -1) {
                return 0
            }
            var j = parseFloat(k.substr(0, l)), m = parseFloat(k.substr(l + 1));
            if (j <= 0 || m <= 0) {
                return 0
            }
            return (m / j * 100) + "%"
        }

        a.addConfig = function (j, k) {
            d(k);
            return h.extend(j, k)
        };
        function d(k) {
            if (!k.playlist) {
                var m = {};
                h.foreach(i.defaults, function (n) {
                    c(k, m, n)
                });
                if (!m.sources) {
                    if (k.levels) {
                        m.sources = k.levels;
                        delete k.levels
                    } else {
                        var j = {};
                        c(k, j, "file");
                        c(k, j, "type");
                        m.sources = j.file ? [j] : []
                    }
                }
                k.playlist = [new i(m)]
            } else {
                for (var l = 0; l < k.playlist.length; l++) {
                    k.playlist[l] = new i(k.playlist[l])
                }
            }
        }

        function c(l, j, k) {
            if (h.exists(l[k])) {
                j[k] = l[k];
                delete l[k]
            }
        }
    })(jwplayer);
    (function (d) {
        var h = d.embed, i = d.utils, c = "none", a = "block", f = "100%", e = "relative", b = "absolute";

        function g(j, l) {
            var m = document.querySelectorAll(j);

            function n(p, o) {
                m[k].style[p] = o
            }

            for (var k = 0; k < m.length; k++) {
                i.foreach(l, n)
            }
        }

        h.download = function (m, w, k) {
            var p = i.extend({}, w), t, n = p.width ? p.width : 480, q = p.height ? p.height : 320, x, r, j = w.logo ? w.logo : {
                prefix: i.repo(),
                file: "logo.png",
                margin: 10
            };

            function v() {
                var C, D, B, E, I, z, y, H, A = p.playlist, F = ["mp4", "aac", "mp3"];
                if (!A || !A.length) {
                    return
                }
                I = A[0];
                z = I.sources;
                for (E = 0; E < z.length; E++) {
                    y = z[E];
                    if (!y.file) {
                        continue
                    }
                    H = y.type || i.extensionmap.extType(i.extension(y.file));
                    var G = i.indexOf(F, H);
                    if (G >= 0) {
                        C = y.file;
                        D = I.image
                    } else {
                        if (i.isYouTube(y.file, H)) {
                            B = y.file
                        }
                    }
                }
                if (C) {
                    x = C;
                    r = D;
                    s();
                    o()
                } else {
                    if (B) {
                        l(B)
                    } else {
                        k()
                    }
                }
            }

            function s() {
                if (m) {
                    t = u("a", "display", m);
                    u("div", "icon", t);
                    u("div", "logo", t);
                    if (x) {
                        t.setAttribute("href", i.getAbsolutePath(x))
                    }
                }
            }

            function o() {
                var y = "#" + m.id + " .jwdownload";
                m.style.width = "";
                m.style.height = "";
                g(y + "display", {
                    width: i.styleDimension(Math.max(320, n)),
                    height: i.styleDimension(Math.max(180, q)),
                    background: "black center no-repeat " + (r ? "url(" + r + ")" : ""),
                    backgroundSize: "contain",
                    position: e,
                    border: c,
                    display: a
                });
                g(y + "display div", {position: b, width: f, height: f});
                g(y + "logo", {
                    top: j.margin + "px",
                    right: j.margin + "px",
                    background: "top right no-repeat url(" + j.prefix + j.file + ")"
                });
                g(y + "icon", {background: "center no-repeat url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAgNJREFUeNrs28lqwkAYB/CZqNVDDj2r6FN41QeIy8Fe+gj6BL275Q08u9FbT8ZdwVfotSBYEPUkxFOoks4EKiJdaDuTjMn3wWBO0V/+sySR8SNSqVRKIR8qaXHkzlqS9jCfzzWcTCYp9hF5o+59sVjsiRzcegSckFzcjT+ruN80TeSlAjCAAXzdJSGPFXRpAAMYwACGZQkSdhG4WCzehMNhqV6vG6vVSrirKVEw66YoSqDb7cqlUilE8JjHd/y1MQefVzqdDmiaJpfLZWHgXMHn8F6vJ1cqlVAkEsGuAn83J4gAd2RZymQygX6/L1erVQt+9ZPWb+CDwcCC2zXGJaewl/DhcHhK3DVj+KfKZrMWvFarcYNLomAv4aPRSFZVlTlcSPA5fDweW/BoNIqFnKV53JvncjkLns/n/cLdS+92O7RYLLgsKfv9/t8XlDn4eDyiw+HA9Jyz2eyt0+kY2+3WFC5hluej0Ha7zQQq9PPwdDq1Et1sNsx/nFBgCqWJ8oAK1aUptNVqcYWewE4nahfU0YQnk4ntUEfGMIU2m01HoLaCKbTRaDgKtaVLk9tBYaBcE/6Artdr4RZ5TB6/dC+9iIe/WgAMYADDpAUJAxjAAAYwgGFZgoS/AtNNTF7Z2bL0BYPBV3Jw5xFwwWcYxgtBP5OkE8i9G7aWGOOCruvauwADALMLMEbKf4SdAAAAAElFTkSuQmCC)"})
            }

            function u(y, B, A) {
                var z = document.createElement(y);
                if (B) {
                    z.className = "jwdownload" + B
                }
                if (A) {
                    A.appendChild(z)
                }
                return z
            }

            function l(y) {
                var z = u("iframe", "", m);
                z.src = "http://www.youtube.com/embed/" + i.youTubeID(y);
                z.width = n;
                z.height = q;
                z.style.border = "none"
            }

            v()
        }
    })(jwplayer);
    (function (c) {
        var b = c.utils, d = c.events, a = {};
        var f = c.embed.flash = function (k, l, o, j, m) {
            var h = new c.events.eventdispatcher(), i = b.flashVersion();
            b.extend(this, h);
            function p(r, q, s) {
                var t = document.createElement("param");
                t.setAttribute("name", q);
                t.setAttribute("value", s);
                r.appendChild(t)
            }

            function n(r, s, q) {
                return function () {
                    try {
                        if (q) {
                            document.getElementById(m.id + "_wrapper").appendChild(s)
                        }
                        var u = document.getElementById(m.id).getPluginConfig("display");
                        if (typeof r.resize === "function") {
                            r.resize(u.width, u.height)
                        }
                        s.style.left = u.x;
                        s.style.top = u.h
                    } catch (t) {
                    }
                }
            }

            function g(q) {
                if (!q) {
                    return {}
                }
                var s = {}, r = [];
                b.foreach(q, function (t, v) {
                    var u = b.getPluginName(t);
                    r.push(t);
                    b.foreach(v, function (x, w) {
                        s[u + "." + x] = w
                    })
                });
                s.plugins = r.join(",");
                return s
            }

            this.embed = function () {
                o.id = m.id;
                if (i < 10) {
                    h.sendEvent(d.ERROR, {message: "Flash version must be 10.0 or greater"});
                    return false
                }
                var D, B, t = m.config.listbar;
                var w = b.extend({}, o);
                if (k.id + "_wrapper" === k.parentNode.id) {
                    D = document.getElementById(k.id + "_wrapper")
                } else {
                    D = document.createElement("div");
                    B = document.createElement("div");
                    B.style.display = "none";
                    B.id = k.id + "_aspect";
                    D.id = k.id + "_wrapper";
                    D.style.position = "relative";
                    D.style.display = "block";
                    D.style.width = b.styleDimension(w.width);
                    D.style.height = b.styleDimension(w.height);
                    if (m.config.aspectratio) {
                        var u = parseFloat(m.config.aspectratio);
                        B.style.display = "block";
                        B.style.marginTop = m.config.aspectratio;
                        D.style.height = "auto";
                        D.style.display = "inline-block";
                        if (t) {
                            if (t.position === "bottom") {
                                B.style.paddingBottom = t.size + "px"
                            } else {
                                if (t.position === "right") {
                                    B.style.marginBottom = (-1 * t.size * (u / 100)) + "px"
                                }
                            }
                        }
                    }
                    k.parentNode.replaceChild(D, k);
                    D.appendChild(k);
                    D.appendChild(B)
                }
                var r = j.setupPlugins(m, w, n);
                if (r.length > 0) {
                    b.extend(w, g(r.plugins))
                } else {
                    delete w.plugins
                }
                if (typeof w["dock.position"] !== "undefined") {
                    if (w["dock.position"].toString().toLowerCase() === "false") {
                        w.dock = w["dock.position"];
                        delete w["dock.position"]
                    }
                }
                var E = "#000000", z, s = w.wmode || (w.height && w.height <= 40 ? "transparent" : "opaque"), v = ["height", "width", "modes", "events", "primary", "base", "fallback", "volume"];
                for (var y = 0; y < v.length; y++) {
                    delete w[v[y]]
                }
                var C = b.getCookies();
                b.foreach(C, function (F, G) {
                    if (typeof(w[F]) === "undefined") {
                        w[F] = G
                    }
                });
                var q = window.location.href.split("/");
                q.splice(q.length - 1, 1);
                q = q.join("/");
                w.base = q + "/";
                a[k.id] = w;
                if (b.isMSIE()) {
                    var A = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" " width="100%" height="100%"id="' + k.id + '" name="' + k.id + '" tabindex=0"">';
                    A += '<param name="movie" value="' + l.src + '">';
                    A += '<param name="allowfullscreen" value="true">';
                    A += '<param name="allowscriptaccess" value="always">';
                    A += '<param name="seamlesstabbing" value="true">';
                    A += '<param name="wmode" value="' + s + '">';
                    A += '<param name="bgcolor" value="' + E + '">';
                    A += "</object>";
                    k.outerHTML = A;
                    z = document.getElementById(k.id)
                } else {
                    var x = document.createElement("object");
                    x.setAttribute("type", "application/x-shockwave-flash");
                    x.setAttribute("data", l.src);
                    x.setAttribute("width", "100%");
                    x.setAttribute("height", "100%");
                    x.setAttribute("bgcolor", E);
                    x.setAttribute("id", k.id);
                    x.setAttribute("name", k.id);
                    x.className = "jwswf";
                    p(x, "allowfullscreen", "true");
                    p(x, "allowscriptaccess", "always");
                    p(x, "seamlesstabbing", "true");
                    p(x, "wmode", s);
                    k.parentNode.replaceChild(x, k);
                    z = x
                }
                if (m.config.aspectratio) {
                    z.style.position = "absolute"
                }
                m.container = z;
                m.setPlayer(z, "flash")
            };
            this.supportsConfig = function () {
                if (i) {
                    if (o) {
                        if (b.typeOf(o.playlist) === "string") {
                            return true
                        }
                        try {
                            var s = o.playlist[0], q = s.sources;
                            if (typeof q === "undefined") {
                                return true
                            } else {
                                for (var r = 0; r < q.length; r++) {
                                    if (q[r].file && e(q[r].file, q[r].type)) {
                                        return true
                                    }
                                }
                            }
                        } catch (t) {
                            return false
                        }
                    } else {
                        return true
                    }
                }
                return false
            }
        };
        f.getVars = function (g) {
            return a[g]
        };
        var e = c.embed.flashCanPlay = function (g, h) {
            if (b.isYouTube(g, h)) {
                return true
            }
            if (b.isRtmp(g, h)) {
                return true
            }
            if (h === "hls") {
                return true
            }
            var i = b.extensionmap[h ? h : b.extension(g)];
            if (!i) {
                return false
            }
            return !!(i.flash)
        }
    })(jwplayer);
    (function (c) {
        var a = c.utils, b = a.extensionmap, d = c.events;
        c.embed.html5 = function (i, j, o, h, m) {
            var l = this, g = new d.eventdispatcher();
            a.extend(l, g);
            function n(q, r, p) {
                return function () {
                    try {
                        var s = document.querySelector("#" + i.id + " .jwmain");
                        if (p) {
                            s.appendChild(r)
                        }
                        if (typeof q.resize === "function") {
                            q.resize(s.clientWidth, s.clientHeight);
                            setTimeout(function () {
                                q.resize(s.clientWidth, s.clientHeight)
                            }, 400)
                        }
                        r.left = s.style.left;
                        r.top = s.style.top
                    } catch (t) {
                    }
                }
            }

            l.embed = function () {
                if (c.html5) {
                    h.setupPlugins(m, o, n);
                    i.innerHTML = "";
                    var p = c.utils.extend({}, o);
                    delete p.volume;
                    var q = new c.html5.player(p);
                    m.container = document.getElementById(m.id);
                    m.setPlayer(q, "html5")
                } else {
                    var r = new a.scriptloader(j.src);
                    r.addEventListener(d.ERROR, k);
                    r.addEventListener(d.COMPLETE, l.embed);
                    r.load()
                }
            };
            function k(p) {
                l.sendEvent(p.type, {message: "HTML5 player not found"})
            }

            l.supportsConfig = function () {
                if (!!c.vid.canPlayType) {
                    try {
                        if (a.typeOf(o.playlist) === "string") {
                            return true
                        } else {
                            var p = o.playlist[0].sources;
                            for (var r = 0; r < p.length; r++) {
                                var q = p[r].file, s = p[r].type;
                                if (c.embed.html5CanPlay(q, s, o.androidhls)) {
                                    return true
                                }
                            }
                        }
                    } catch (t) {
                    }
                }
                return false
            }
        };
        function f(g, h, j) {
            if (navigator.userAgent.match(/BlackBerry/i) !== null) {
                return false
            }
            if (a.isIE(9)) {
                return false
            }
            if (a.isYouTube(g, h)) {
                return true
            }
            var l = a.extension(g);
            h = h || b.extType(l);
            if (h === "hls") {
                if (j) {
                    var k = a.isAndroidNative;
                    if (k(2) || k(3) || k("4.0")) {
                        return false
                    } else {
                        if (a.isAndroid()) {
                            return true
                        }
                    }
                } else {
                    if (a.isAndroid()) {
                        return false
                    }
                }
            }
            if (a.isRtmp(g, h)) {
                return false
            }
            var i = b[h] || b[l];
            if (!i) {
                return false
            }
            if (i.flash && !i.html5) {
                return false
            }
            return e(i.html5)
        }

        function e(h) {
            if (!h) {
                return true
            }
            try {
                var g = c.vid.canPlayType(h);
                return !!g
            } catch (i) {
            }
            return false
        }

        c.embed.html5CanPlay = f
    })(jwplayer);
    (function (f, e) {
        var b = [], j = f.utils, k = f.events, l = k.state;

        function i(m) {
            j.addClass(m, "jw-tab-focus")
        }

        function d(m) {
            j.removeClass(m, "jw-tab-focus")
        }

        var c = ["getBuffer", "getCaptionsList", "getControls", "getCurrentCaptions", "getCurrentQuality", "getCurrentAudioTrack", "getDuration", "getFullscreen", "getHeight", "getLockState", "getMute", "getPlaylistIndex", "getSafeRegion", "getPosition", "getQualityLevels", "getState", "getVolume", "getWidth", "isBeforeComplete", "isBeforePlay", "releaseState"];
        var h = ["playlistNext", "stop", "forceState", "playlistPrev", "seek", "setCurrentCaptions", "setControls", "setCurrentQuality", "setVolume", "setCurrentAudioTrack"];
        var g = {
            onBufferChange: k.JWPLAYER_MEDIA_BUFFER,
            onBufferFull: k.JWPLAYER_MEDIA_BUFFER_FULL,
            onError: k.JWPLAYER_ERROR,
            onSetupError: k.JWPLAYER_SETUP_ERROR,
            onFullscreen: k.JWPLAYER_FULLSCREEN,
            onMeta: k.JWPLAYER_MEDIA_META,
            onMute: k.JWPLAYER_MEDIA_MUTE,
            onPlaylist: k.JWPLAYER_PLAYLIST_LOADED,
            onPlaylistItem: k.JWPLAYER_PLAYLIST_ITEM,
            onPlaylistComplete: k.JWPLAYER_PLAYLIST_COMPLETE,
            onReady: k.API_READY,
            onResize: k.JWPLAYER_RESIZE,
            onComplete: k.JWPLAYER_MEDIA_COMPLETE,
            onSeek: k.JWPLAYER_MEDIA_SEEK,
            onTime: k.JWPLAYER_MEDIA_TIME,
            onVolume: k.JWPLAYER_MEDIA_VOLUME,
            onBeforePlay: k.JWPLAYER_MEDIA_BEFOREPLAY,
            onBeforeComplete: k.JWPLAYER_MEDIA_BEFORECOMPLETE,
            onDisplayClick: k.JWPLAYER_DISPLAY_CLICK,
            onControls: k.JWPLAYER_CONTROLS,
            onQualityLevels: k.JWPLAYER_MEDIA_LEVELS,
            onQualityChange: k.JWPLAYER_MEDIA_LEVEL_CHANGED,
            onCaptionsList: k.JWPLAYER_CAPTIONS_LIST,
            onCaptionsChange: k.JWPLAYER_CAPTIONS_CHANGED,
            onAdError: k.JWPLAYER_AD_ERROR,
            onAdClick: k.JWPLAYER_AD_CLICK,
            onAdImpression: k.JWPLAYER_AD_IMPRESSION,
            onAdTime: k.JWPLAYER_AD_TIME,
            onAdComplete: k.JWPLAYER_AD_COMPLETE,
            onAdCompanions: k.JWPLAYER_AD_COMPANIONS,
            onAdSkipped: k.JWPLAYER_AD_SKIPPED,
            onAdPlay: k.JWPLAYER_AD_PLAY,
            onAdPause: k.JWPLAYER_AD_PAUSE,
            onAdMeta: k.JWPLAYER_AD_META,
            onCast: k.JWPLAYER_CAST_SESSION,
            onAudioTrackChange: k.JWPLAYER_AUDIO_TRACK_CHANGED,
            onAudioTracks: k.JWPLAYER_AUDIO_TRACKS
        };
        var a = {onBuffer: l.BUFFERING, onPause: l.PAUSED, onPlay: l.PLAYING, onIdle: l.IDLE};
        f.api = function (z) {
            var C = this, m = {}, s = {}, p, F = false, w = [], D, n, y = {}, u = {};
            C.container = z;
            C.id = z.id;
            C.setup = function (H) {
                if (f.embed) {
                    var I = document.getElementById(C.id);
                    if (I) {
                        H.fallbackDiv = I
                    }
                    t(C);
                    var J = f(C.id);
                    J.config = H;
                    n = new f.embed(J);
                    n.embed();
                    return J
                }
                return C
            };
            C.getContainer = function () {
                return C.container
            };
            C.addButton = function (J, H, I, M) {
                try {
                    u[M] = I;
                    var L = 'jwplayer("' + C.id + '").callback("' + M + '")';
                    B("jwDockAddButton", J, H, L, M)
                } catch (K) {
                    j.log("Could not add dock button" + K.message)
                }
            };
            C.removeButton = function (H) {
                B("jwDockRemoveButton", H)
            };
            C.callback = function (H) {
                if (u[H]) {
                    u[H]()
                }
            };
            C.getMeta = function () {
                return C.getItemMeta()
            };
            C.getPlaylist = function () {
                var H = B("jwGetPlaylist");
                if (C.renderingMode === "flash") {
                    j.deepReplaceKeyName(H, ["__dot__", "__spc__", "__dsh__", "__default__"], [".", " ", "-", "default"])
                }
                return H
            };
            C.getPlaylistItem = function (H) {
                if (!j.exists(H)) {
                    H = C.getPlaylistIndex()
                }
                return C.getPlaylist()[H]
            };
            C.getRenderingMode = function () {
                return C.renderingMode
            };
            C.setFullscreen = function (H) {
                if (!j.exists(H)) {
                    B("jwSetFullscreen", !B("jwGetFullscreen"))
                } else {
                    B("jwSetFullscreen", H)
                }
                return C
            };
            C.setMute = function (H) {
                if (!j.exists(H)) {
                    B("jwSetMute", !B("jwGetMute"))
                } else {
                    B("jwSetMute", H)
                }
                return C
            };
            C.lock = function () {
                return C
            };
            C.unlock = function () {
                return C
            };
            C.load = function (H) {
                B("jwInstreamDestroy");
                if (f(C.id).plugins.googima) {
                    B("jwDestroyGoogima")
                }
                B("jwLoad", H);
                return C
            };
            C.playlistItem = function (H) {
                B("jwPlaylistItem", parseInt(H, 10));
                return C
            };
            C.resize = function (J, H) {
                if (C.renderingMode !== "flash") {
                    B("jwResize", J, H)
                } else {
                    var K = document.getElementById(C.id + "_wrapper"), I = document.getElementById(C.id + "_aspect");
                    if (I) {
                        I.style.display = "none"
                    }
                    if (K) {
                        K.style.display = "block";
                        K.style.width = j.styleDimension(J);
                        K.style.height = j.styleDimension(H)
                    }
                }
                return C
            };
            C.play = function (H) {
                if (H !== e) {
                    B("jwPlay", H);
                    return C
                }
                H = C.getState();
                var I = D && D.getState();
                if (I) {
                    if (I === l.IDLE || I === l.PLAYING || I === l.BUFFERING) {
                        B("jwInstreamPause")
                    } else {
                        B("jwInstreamPlay")
                    }
                }
                if (H === l.PLAYING || H === l.BUFFERING) {
                    B("jwPause")
                } else {
                    B("jwPlay")
                }
                return C
            };
            C.pause = function (H) {
                if (H === e) {
                    H = C.getState();
                    if (H === l.PLAYING || H === l.BUFFERING) {
                        B("jwPause")
                    } else {
                        B("jwPlay")
                    }
                } else {
                    B("jwPause", H)
                }
                return C
            };
            C.createInstream = function () {
                return new f.api.instream(this, p)
            };
            C.setInstream = function (H) {
                D = H;
                return H
            };
            C.loadInstream = function (I, H) {
                D = C.setInstream(C.createInstream()).init(H);
                D.loadItem(I);
                return D
            };
            C.destroyPlayer = function () {
                B("jwPlayerDestroy")
            };
            C.playAd = function (I) {
                var H = f(C.id).plugins;
                if (H.vast) {
                    H.vast.jwPlayAd(I)
                } else {
                    B("jwPlayAd", I)
                }
            };
            C.pauseAd = function () {
                var H = f(C.id).plugins;
                if (H.vast) {
                    H.vast.jwPauseAd()
                } else {
                    B("jwPauseAd")
                }
            };
            function v(H, I) {
                j.foreach(H, function (J, K) {
                    C[J] = function (L) {
                        return I(K, L)
                    }
                })
            }

            v(a, x);
            v(g, E);
            function q(H, I) {
                var J = "jw" + I.charAt(0).toUpperCase() + I.slice(1);
                C[I] = function () {
                    var K = B.apply(this, [J].concat(Array.prototype.slice.call(arguments, 0)));
                    return (H ? C : K)
                }
            }

            var o = function (I, H) {
                q(false, H)
            };
            var A = function (I, H) {
                q(true, H)
            };
            j.foreach(c, o);
            j.foreach(h, A);
            C.remove = function () {
                if (!F) {
                    throw"Cannot call remove() before player is ready"
                }
                t(this)
            };
            function t(H) {
                w = [];
                if (n && n.destroy) {
                    n.destroy()
                }
                f.api.destroyPlayer(H.id)
            }

            C.registerPlugin = function (K, J, I, H) {
                f.plugins.registerPlugin(K, J, I, H)
            };
            C.setPlayer = function (H, I) {
                p = H;
                C.renderingMode = I
            };
            C.detachMedia = function () {
                if (C.renderingMode === "html5") {
                    return B("jwDetachMedia")
                }
            };
            C.attachMedia = function (H) {
                if (C.renderingMode === "html5") {
                    return B("jwAttachMedia", H)
                }
            };
            C.getAudioTracks = function () {
                return B("jwGetAudioTracks")
            };
            function x(H, I) {
                if (!s[H]) {
                    s[H] = [];
                    E(k.JWPLAYER_PLAYER_STATE, G(H))
                }
                s[H].push(I);
                return C
            }

            function G(H) {
                return function (J) {
                    var I = J.newstate, M = J.oldstate;
                    if (I === H) {
                        var L = s[I];
                        if (L) {
                            for (var N = 0; N < L.length; N++) {
                                var K = L[N];
                                if (typeof K === "function") {
                                    K.call(this, {oldstate: M, newstate: I})
                                }
                            }
                        }
                    }
                }
            }

            function r(I, J) {
                try {
                    I.jwAddEventListener(J, 'function(dat) { jwplayer("' + C.id + '").dispatchEvent("' + J + '", dat); }')
                } catch (K) {
                    if (C.renderingMode === "flash") {
                        var H = document.createElement("a");
                        H.href = p.data;
                        if (H.protocol !== location.protocol) {
                            j.log("Warning: Your site [" + location.protocol + "] and JWPlayer [" + H.protocol + "] are hosted using different protocols")
                        }
                    }
                    j.log("Could not add internal listener")
                }
            }

            function E(H, I) {
                if (!m[H]) {
                    m[H] = [];
                    if (p && F) {
                        r(p, H)
                    }
                }
                m[H].push(I);
                return C
            }

            C.removeEventListener = function (J, K) {
                var I = m[J];
                if (I) {
                    for (var H = I.length; H--;) {
                        if (I[H] === K) {
                            I.splice(H, 1)
                        }
                    }
                }
            };
            C.dispatchEvent = function (L) {
                var K = m[L];
                if (K) {
                    K = K.slice(0);
                    var I = j.translateEventResponse(L, arguments[1]);
                    for (var H = 0; H < K.length; H++) {
                        var J = K[H];
                        if (typeof J === "function") {
                            try {
                                if (L === k.JWPLAYER_PLAYLIST_LOADED) {
                                    j.deepReplaceKeyName(I.playlist, ["__dot__", "__spc__", "__dsh__", "__default__"], [".", " ", "-", "default"])
                                }
                                J.call(this, I)
                            } catch (M) {
                                j.log("There was an error calling back an event handler", M)
                            }
                        }
                    }
                }
            };
            C.dispatchInstreamEvent = function (H) {
                if (D) {
                    D.dispatchEvent(H, arguments)
                }
            };
            function B() {
                if (F) {
                    if (p) {
                        var H = Array.prototype.slice.call(arguments, 0), I = H.shift();
                        if (typeof p[I] === "function") {
                            switch (H.length) {
                                case 6:
                                    return p[I](H[0], H[1], H[2], H[3], H[4], H[5]);
                                case 5:
                                    return p[I](H[0], H[1], H[2], H[3], H[4]);
                                case 4:
                                    return p[I](H[0], H[1], H[2], H[3]);
                                case 3:
                                    return p[I](H[0], H[1], H[2]);
                                case 2:
                                    return p[I](H[0], H[1]);
                                case 1:
                                    return p[I](H[0])
                            }
                            return p[I]()
                        }
                    }
                    return null
                }
                w.push(arguments)
            }

            C.callInternal = B;
            C.playerReady = function (H) {
                F = true;
                if (!p) {
                    C.setPlayer(document.getElementById(H.id))
                }
                C.container = document.getElementById(C.id);
                j.foreach(m, function (I) {
                    r(p, I)
                });
                E(k.JWPLAYER_PLAYLIST_ITEM, function () {
                    y = {}
                });
                E(k.JWPLAYER_MEDIA_META, function (I) {
                    j.extend(y, I.metadata)
                });
                E(k.JWPLAYER_VIEW_TAB_FOCUS, function (J) {
                    var I = C.getContainer();
                    if (J.hasFocus === true) {
                        i(I)
                    } else {
                        d(I)
                    }
                });
                C.dispatchEvent(k.API_READY);
                while (w.length > 0) {
                    B.apply(this, w.shift())
                }
            };
            C.getItemMeta = function () {
                return y
            };
            return C
        };
        f.playerReady = function (n) {
            var m = f.api.playerById(n.id);
            if (!m) {
                m = f.api.selectPlayer(n.id)
            }
            m.playerReady(n)
        };
        f.api.selectPlayer = function (n) {
            var m;
            if (!j.exists(n)) {
                n = 0
            }
            if (n.nodeType) {
                m = n
            } else {
                if (typeof n === "string") {
                    m = document.getElementById(n)
                }
            }
            if (m) {
                var o = f.api.playerById(m.id);
                if (o) {
                    return o
                } else {
                    return f.api.addPlayer(new f.api(m))
                }
            } else {
                if (typeof n === "number") {
                    return b[n]
                }
            }
            return null
        };
        f.api.playerById = function (n) {
            for (var m = 0; m < b.length; m++) {
                if (b[m].id === n) {
                    return b[m]
                }
            }
            return null
        };
        f.api.addPlayer = function (m) {
            for (var n = 0; n < b.length; n++) {
                if (b[n] === m) {
                    return m
                }
            }
            b.push(m);
            return m
        };
        f.api.destroyPlayer = function (o) {
            var n, p, m;
            j.foreach(b, function (r, s) {
                if (s.id === o) {
                    n = r;
                    p = s
                }
            });
            if (n === e || p === e) {
                return null
            }
            j.clearCss("#" + p.id);
            m = document.getElementById(p.id + (p.renderingMode === "flash" ? "_wrapper" : ""));
            if (m) {
                if (p.renderingMode === "html5") {
                    p.destroyPlayer()
                }
                var q = document.createElement("div");
                q.id = p.id;
                m.parentNode.replaceChild(q, m)
            }
            b.splice(n, 1);
            return null
        }
    })(window.jwplayer);
    (function (c) {
        var d = c.events, a = c.utils, b = d.state;
        c.api.instream = function (j, e) {
            var i, k, h = {}, o = {}, f = this;

            function m(q, p) {
                e.jwInstreamAddEventListener(p, 'function(dat) { jwplayer("' + q + '").dispatchInstreamEvent("' + p + '", dat); }')
            }

            function g(p, q) {
                if (!h[p]) {
                    h[p] = [];
                    m(j.id, p)
                }
                h[p].push(q);
                return this
            }

            function n(p, q) {
                if (!o[p]) {
                    o[p] = [];
                    g(d.JWPLAYER_PLAYER_STATE, l(p))
                }
                o[p].push(q);
                return this
            }

            function l(p) {
                return function (r) {
                    var q = r.newstate, u = r.oldstate;
                    if (q === p) {
                        var t = o[q];
                        if (t) {
                            for (var v = 0; v < t.length; v++) {
                                var s = t[v];
                                if (typeof s === "function") {
                                    s.call(this, {oldstate: u, newstate: q, type: r.type})
                                }
                            }
                        }
                    }
                }
            }

            f.type = "instream";
            f.init = function () {
                j.callInternal("jwInitInstream");
                return f
            };
            f.loadItem = function (q, p) {
                i = q;
                k = p || {};
                if (a.typeOf(q) === "array") {
                    j.callInternal("jwLoadArrayInstream", i, k)
                } else {
                    j.callInternal("jwLoadItemInstream", i, k)
                }
            };
            f.removeEvents = function () {
                h = o = {}
            };
            f.removeEventListener = function (r, s) {
                var q = h[r];
                if (q) {
                    for (var p = q.length; p--;) {
                        if (q[p] === s) {
                            q.splice(p, 1)
                        }
                    }
                }
            };
            f.dispatchEvent = function (u, t) {
                var s = h[u];
                if (s) {
                    s = s.slice(0);
                    var q = a.translateEventResponse(u, t[1]);
                    for (var p = 0; p < s.length; p++) {
                        var r = s[p];
                        if (typeof r === "function") {
                            r.call(this, q)
                        }
                    }
                }
            };
            f.onError = function (p) {
                return g(d.JWPLAYER_ERROR, p)
            };
            f.onMediaError = function (p) {
                return g(d.JWPLAYER_MEDIA_ERROR, p)
            };
            f.onFullscreen = function (p) {
                return g(d.JWPLAYER_FULLSCREEN, p)
            };
            f.onMeta = function (p) {
                return g(d.JWPLAYER_MEDIA_META, p)
            };
            f.onMute = function (p) {
                return g(d.JWPLAYER_MEDIA_MUTE, p)
            };
            f.onComplete = function (p) {
                return g(d.JWPLAYER_MEDIA_COMPLETE, p)
            };
            f.onPlaylistComplete = function (p) {
                return g(d.JWPLAYER_PLAYLIST_COMPLETE, p)
            };
            f.onPlaylistItem = function (p) {
                return g(d.JWPLAYER_PLAYLIST_ITEM, p)
            };
            f.onTime = function (p) {
                return g(d.JWPLAYER_MEDIA_TIME, p)
            };
            f.onBuffer = function (p) {
                return n(b.BUFFERING, p)
            };
            f.onPause = function (p) {
                return n(b.PAUSED, p)
            };
            f.onPlay = function (p) {
                return n(b.PLAYING, p)
            };
            f.onIdle = function (p) {
                return n(b.IDLE, p)
            };
            f.onClick = function (p) {
                return g(d.JWPLAYER_INSTREAM_CLICK, p)
            };
            f.onInstreamDestroyed = function (p) {
                return g(d.JWPLAYER_INSTREAM_DESTROYED, p)
            };
            f.onAdSkipped = function (p) {
                return g(d.JWPLAYER_AD_SKIPPED, p)
            };
            f.play = function (p) {
                e.jwInstreamPlay(p)
            };
            f.pause = function (p) {
                e.jwInstreamPause(p)
            };
            f.hide = function () {
                j.callInternal("jwInstreamHide")
            };
            f.destroy = function () {
                f.removeEvents();
                j.callInternal("jwInstreamDestroy")
            };
            f.setText = function (p) {
                e.jwInstreamSetText(p ? p : "")
            };
            f.getState = function () {
                return e.jwInstreamState()
            };
            f.setClick = function (p) {
                if (e.jwInstreamClick) {
                    e.jwInstreamClick(p)
                }
            }
        }
    })(jwplayer)
}
;