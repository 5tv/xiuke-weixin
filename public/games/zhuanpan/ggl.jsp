<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" name="viewport"/>
    <title>HTML5 Canvas å®å®æ¨ Demo</title>
    <style type="text/css">
        #main {border: 1px solid #666;cursor: pointer;}
        img.output { border: 1px solid #666; }
    </style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js "></script>
<script type="text/javascript">
$('document').ready(function(){
       
//éæºå½æ°,äº§çéæºçç§ç
     function   selectFrom(isFirstValue, iLastValue){
       var iChoices=iLastValue-isFirstValue+1;
	   return  Math.floor(Math.random()*iChoices+isFirstValue);

	 }
	  
  var imges=document.getElementById("pic").value;
  
	 
      //var imgs=["img/1.jpg","img/2.jpg","img/3.jpg","img/slide1.jpg","img/xx.jpg"];
       //var image=imgs[selectFrom(0,imgs.length-1)];
    var backimage = { 'url':imges, 'img': null };
    var canvas = {'temp': null, 'draw': null}; 
    var mouseDown = false;    
    // canvas åæ    
    function recompositeCanvases() {
        var main = document.getElementById('main');
        var tempctx = canvas.temp.getContext('2d');
        var mainctx = main.getContext('2d');
        // clear the temp
        canvas.temp.width = canvas.temp.width;
        // æ canvas.draw è¦èå° drawImage ä¸
        tempctx.drawImage(canvas.draw, 0, 0);
        // ä»¥ source-atop çæ¹å¼æ backimage ç«å° tempctx ä¸
        tempctx.globalCompositeOperation = 'source-atop';
        tempctx.drawImage(backimage.img, 0, 0);
        // mainctx => ç°è²åæ¯ (éæ²æå®æçå°æ¹)
        mainctx.fillStyle = "#888";
        mainctx.fillRect(0, 0, backimage.img.width, backimage.img.height);
        // æå¾æ canvas.temp è¦èå° mainctx ä¸
        mainctx.drawImage(canvas.temp, 0, 0);
    }
   



    // ç«ç·
    function scratch(canv, x, y, fresh) {
        var ctx = canv.getContext('2d');        
        // ç«ç­å¤§å°, å½¢ç...
        ctx.lineWidth = 20;
        ctx.lineCap = ctx.lineJoin = 'round';
        if (fresh) {
            ctx.beginPath();
            // çºäºæ¨¡æ¬æ»åï¼æä»¥å¨ x å ä¸ 0.01ï¼ä¸ç¶é»ä¸ä¸ä¸æç¢çåæ
            ctx.moveTo(x+0.01, y);
        }
        ctx.lineTo(x, y);
        ctx.stroke();
    }
    function setupCanvases() {
        var c = document.getElementById('main');
        // åå¾åçé·å¯¬
        c.width = backimage.img.width;
        c.height = backimage.img.height;
        canvas.temp = document.createElement('canvas');
        canvas.draw = document.createElement('canvas');
        canvas.temp.width = canvas.draw.width = c.width;
        canvas.temp.height = canvas.draw.height = c.height;
        recompositeCanvases();
        function mousedown_handler(e) {
            var local = getLocalCoords(c, e);
            mouseDown = true;
            scratch(canvas.draw, local.x, local.y, true);
            recompositeCanvases();
            if (e.cancelable) { e.preventDefault(); } 
           
            return false;
        };
        function mousemove_handler(e) {
            if (!mouseDown) { return true; }
            var local = getLocalCoords(c, e);
            scratch(canvas.draw, local.x, local.y, false);
            recompositeCanvases();
            if (e.cancelable) { e.preventDefault(); } 
			/**
			 if(local.x>105&&local.x<390&&local.y>110&&local.y<197){
             alert(local.x+"\tdsfdsf"+local.y);
            }
			*/
            return false;
        };
        function mouseup_handler(e) {
            if (mouseDown) {
                mouseDown = false;
                if (e.cancelable) { e.preventDefault(); } 
                return false;
            }
            return true;
        };
        // mouse handlers
        c.addEventListener('mousedown', mousedown_handler, false);
        c.addEventListener('touchstart', mousedown_handler, false);
        window.addEventListener('mousemove', mousemove_handler, false);
        window.addEventListener('touchmove', mousemove_handler, false);
        window.addEventListener('mouseup', mouseup_handler, false);
        window.addEventListener('touchend', mouseup_handler, false);
    }
    // åå¾åº§æ¨
    function getLocalCoords(elem, ev) {
        var ox = 0, oy = 0;
        var first;
        var pageX, pageY;
        while (elem != null) {
            ox += elem.offsetLeft;
            oy += elem.offsetTop;
            elem = elem.offsetParent;
        }
        if (ev.hasOwnProperty('changedTouches')) {
            first = ev.changedTouches[0];
            pageX = first.pageX;
            pageY = first.pageY;
        } else {
            pageX = ev.pageX;
            pageY = ev.pageY;
        }
        return { 'x': pageX - ox, 'y': pageY - oy };
    }
    // åæçä¸å img åºä¾
    backimage.img = document.createElement('img'); 
    backimage.img.addEventListener('load', setupCanvases, false);
    backimage.img.src = backimage.url;
    // reset
    $('#resetbutton').bind('click', function() {
        canvas.draw.width = canvas.draw.width;
        recompositeCanvases();
        return false;
    });    
});
</script>
</head>
<body>
    <canvas id="main"></canvas> <br />
    <input id="resetbutton" type="button" value="Reset" />
     <input id="pic" type="hidden" value="<%= request.getParameter("picutre") %>"/>
  <%= request.getParameter("picutre") %>   
     奖
</body>
</html>