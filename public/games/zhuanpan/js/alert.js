/**
 * Created by 閾佹墜 on 13-11-15.
 */


function alert(str, title ,callback) {
    $("#alert_box").remove();
    $("body").css('position', 'relative');

    //鏍峰紡
    $alert_css = '<style>#alert_warp{height:100%; width:100%; position:fixed; _position:absolute; top:0; z-index:1000;background-color: rgba(0, 0, 0, 0.4);}#alert_box{display:none;padding: 10px;width: 240px;left:50%;margin-left:-130px;background-color: rgba(0,0,0,0.8);border-radius: 6px;color: #fff;position: fixed;z-index:1001;}#alert_close{display: block;width: 100%;-webkit-tap-highlight-color:rgba(0,0,0,0);height: 30px;margin:0;text-align: right;}#alert_title{float: left;line-height: 30px;color: #999;}#alert_close img{width: 26px;}#alert_msg{text-align: center;margin-top: 4px;}#confirm{-webkit-tap-highlight-color:rgba(0,0,0,0);font-size:1.2em;display: inherit;text-decoration: none;color:#fff;text-align: center;margin: 0;padding: 8px;}</style>';

    //缁撴瀯
    $html = '<div id="alert_warp"><div id="alert_box"><p id="alert_close">';

    // 鎻愮ず妗嗘爣棰�
    if (title) {
        $html += '<span id="alert_title">' + title + '</span>';
    }

    $html += '<img src="./images/5sxn9hec.jpg?1119" /></p><p id="alert_msg">' + str + '</p><p id="confirm">Good Luck With YOU!!!</p></div></div>';

    //琛ㄧ幇
    $("body").append($alert_css + $html);
    $("#alert_box").fadeIn('fast');

    $half_height = $(window).height() / 2;
    $msgboxheight = $("#alert_box").height() / 2;
    $("#alert_box").css('bottom', $half_height + 'px');
    $("#alert_box").css('margin-bottom', '-' + $msgboxheight + 'px');


    $("#confirm").click(function () {
        $("#alert_box").fadeOut('slow', function () {
            $("#alert_warp").remove();
            if(callback){
                callback();
            }
        });
    });
    $("#alert_close").click(function () {
        $("#alert_warp").fadeOut('slow', function () {
            $("#alert_warp").remove();
        });
    });

    /*callback*/
}



