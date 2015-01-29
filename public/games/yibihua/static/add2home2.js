/*!
 * Add to Homescreen v2.0.7 ~ Copyright (c) 2013 Matteo Spinelli, http://cubiq.org
 * Released under MIT license, http://cubiq.org/license
 */
var addToHome=(function(n){var i=n.navigator,j="platform" in i&&(/iphone|ipod|ipad/gi).test(i.platform),y,o,A,D,e,z=0,v=0,x=0,f,b,E,a,l,k,m,d={autostart:true,returningVisitor:false,animationIn:"drop",animationOut:"fade",startDelay:2000,lifespan:15000,bottomOffset:14,expire:0,message:"",touchIcon:false,arrow:true,hookOnLoad:true,closeButton:true,iterations:100},q={zh_cn:"您可以将此网站发送到您的 %device 上。请按 %icon 然后选择<strong>添加至主屏幕</strong>。",zh_tw:"您可以將此應用程式安裝到您的 %device 上。請按 %icon 然後點選<strong>加入主畫面螢幕</strong>。"};function u(){if(!j){return}var w=Date.now(),F;if(n.addToHomeConfig){for(F in n.addToHomeConfig){d[F]=n.addToHomeConfig[F]}}if(!d.autostart){d.hookOnLoad=false}y=(/ipad/gi).test(i.platform);o=n.devicePixelRatio&&n.devicePixelRatio>1;A=(/Safari/i).test(i.appVersion)&&!(/CriOS/i).test(i.appVersion);D=i.standalone;e=i.appVersion.match(/OS (\d+_\d+)/i);e=e&&e[1]?+e[1].replace("_","."):0;x=+n.localStorage.getItem("addToHome");b=n.sessionStorage.getItem("addToHomeSession");E=d.returningVisitor?x&&x+28*24*60*60*1000>w:true;if(!x){x=w}f=E&&x<=w;if(d.hookOnLoad){n.addEventListener("load",t,false)}else{if(!d.hookOnLoad&&d.autostart){t()}}}function t(){n.removeEventListener("load",t,false);if(!E){n.localStorage.setItem("addToHome",Date.now())}else{if(d.expire&&f){n.localStorage.setItem("addToHome",Date.now()+d.expire*60000)}}if(!l&&(!A||!f||b||D||!E)){return}var F="",w=i.platform.split(" ")[0],G=i.language.replace("-","_");a=document.createElement("div");a.id="addToHomeScreen";a.style.cssText+="left:-9999px;-webkit-transition-property:-webkit-transform,opacity;-webkit-transition-duration:0;-webkit-transform:translate3d(0,0,0);position:"+(e<5?"absolute":"fixed");if(d.message in q){G=d.message;d.message=""}if(d.message===""){d.message=G in q?q[G]:q.en_us}if(d.touchIcon){F=o?document.querySelector('head link[rel^=apple-touch-icon][sizes="114x114"],head link[rel^=apple-touch-icon][sizes="144x144"],head link[rel^=apple-touch-icon]'):document.querySelector('head link[rel^=apple-touch-icon][sizes="57x57"],head link[rel^=apple-touch-icon]');if(F){F='<span style="background-image:url('+F.href+')" class="addToHomeTouchIcon"></span>'}}a.className=(y?"addToHomeIpad":"addToHomeIphone")+(F?" addToHomeWide":"");a.innerHTML=F+d.message.replace("%device",w).replace("%icon",e>=4.2?'<span class="addToHomeShare"></span>':'<span class="addToHomePlus">+</span>')+(d.arrow?'<span class="addToHomeArrow"></span>':"")+(d.closeButton?'<span class="addToHomeClose">\u00D7</span>':"");document.body.appendChild(a);if(d.closeButton){a.addEventListener("click",g,false)}if(!y&&e>=6){window.addEventListener("orientationchange",r,false)}setTimeout(C,d.startDelay)}function C(){var F,w=208;if(y){if(e<5){v=n.scrollY;z=n.scrollX}else{if(e<6){w=160}}a.style.top=v+d.bottomOffset+"px";a.style.left=z+w-Math.round(a.offsetWidth/2)+"px";switch(d.animationIn){case"drop":F="0.6s";a.style.webkitTransform="translate3d(0,"+-(n.scrollY+d.bottomOffset+a.offsetHeight)+"px,0)";break;case"bubble":F="0.6s";a.style.opacity="0";a.style.webkitTransform="translate3d(0,"+(v+50)+"px,0)";break;default:F="1s";a.style.opacity="0"}}else{v=n.innerHeight+n.scrollY;if(e<5){z=Math.round((n.innerWidth-a.offsetWidth)/2)+n.scrollX;a.style.left=z+"px";a.style.top=v-a.offsetHeight-d.bottomOffset+"px"}else{a.style.left="50%";a.style.marginLeft=-Math.round(a.offsetWidth/2)-(n.orientation%180&&e>=6?40:0)+"px";a.style.bottom=d.bottomOffset+"px"}switch(d.animationIn){case"drop":F="1s";a.style.webkitTransform="translate3d(0,"+-(v+d.bottomOffset)+"px,0)";break;case"bubble":F="0.6s";a.style.webkitTransform="translate3d(0,"+(a.offsetHeight+d.bottomOffset+50)+"px,0)";break;default:F="1s";a.style.opacity="0"}}a.offsetHeight;a.style.webkitTransitionDuration=F;a.style.opacity="1";a.style.webkitTransform="translate3d(0,0,0)";a.addEventListener("webkitTransitionEnd",h,false);m=setTimeout(p,d.lifespan)}function s(w){if(!j||a){return}l=w;t()}function p(){clearInterval(k);clearTimeout(m);m=null;if(!a){return}var G=0,H=0,w="1",F="0";if(d.closeButton){a.removeEventListener("click",g,false)}if(!y&&e>=6){window.removeEventListener("orientationchange",r,false)}if(e<5){G=y?n.scrollY-v:n.scrollY+n.innerHeight-v;H=y?n.scrollX-z:n.scrollX+Math.round((n.innerWidth-a.offsetWidth)/2)-z}a.style.webkitTransitionProperty="-webkit-transform,opacity";switch(d.animationOut){case"drop":if(y){F="0.4s";w="0";G+=50}else{F="0.6s";G+=a.offsetHeight+d.bottomOffset+50}break;case"bubble":if(y){F="0.8s";G-=a.offsetHeight+d.bottomOffset+50}else{F="0.4s";w="0";G-=50}break;default:F="0.8s";w="0"}a.addEventListener("webkitTransitionEnd",h,false);a.style.opacity=w;a.style.webkitTransitionDuration=F;a.style.webkitTransform="translate3d("+H+"px,"+G+"px,0)"}function g(){n.sessionStorage.setItem("addToHomeSession","1");b=true;p()}function h(){a.removeEventListener("webkitTransitionEnd",h,false);a.style.webkitTransitionProperty="-webkit-transform";a.style.webkitTransitionDuration="0.2s";if(!m){a.parentNode.removeChild(a);a=null;return}if(e<5&&m){k=setInterval(c,d.iterations)}}function c(){var w=new WebKitCSSMatrix(n.getComputedStyle(a,null).webkitTransform),F=y?n.scrollY-v:n.scrollY+n.innerHeight-v,G=y?n.scrollX-z:n.scrollX+Math.round((n.innerWidth-a.offsetWidth)/2)-z;if(F==w.m42&&G==w.m41){return}a.style.webkitTransform="translate3d("+G+"px,"+F+"px,0)"}function B(){n.localStorage.removeItem("addToHome");n.sessionStorage.removeItem("addToHomeSession")}function r(){a.style.marginLeft=-Math.round(a.offsetWidth/2)-(n.orientation%180&&e>=6?40:0)+"px"}u();return{show:s,close:p,reset:B}})(window);
