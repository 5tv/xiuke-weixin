$(function () {
    var did = 0;
    var time = 1;
    $("#startbtn").click(function () {
        lottery();
    });


    function lottery1(){ 


        $("#startbtn").unbind('click').css("cursor", "default");
        var a = 60; //角度
        var p = 4; //奖项
        $("#startbtn").rotate({
            duration: 3000, //转动时间
            angle: 0,
            animateTo: 1800 + a, //转动角度
            easing: $.easing.easeOutSine,
            callback: function () {
                time -= 1;
                if (time == 0) {
                    alert('谢谢您的参与'+p);
                    return false;
                }
                var con = confirm(p + '\n 还有' + time + '次机会,继续吗？');
                if (con) {
                    lottery1();
                } else {
                    return false;
                }
            }
        });
    }

    function lottery() {
        // $.ajax({
        //     type: 'POST',
        //     url: '${pageContext.request.contextPath}/queryAll.action',
         
        //     dataType: 'json',
        //     cache: false,
        //     error: function () {
        //         alert('出错了！');
        //         return false;
        //     },
        //     success: function (json) {
                $("#startbtn").unbind('click').css("cursor", "default");
     
                // var a =json[0].jiaodu; //角度
                var a = 120;
                // var p = json[0].jiangxiang; //奖项
                var p = 2; //奖项
                //  did = json.did;
                $("#startbtn").rotate({
                    duration: 3000, //转动时间
                    angle: 0,
                    animateTo: 3600 + a, //转动角度
                    easing: $.easing.easeOutSine,
                    callback: function () {
                        time = time - 1
                        if(time >= 0){
                            if(p==1){
                              alert("恭喜您获得了一等奖");
                            }else if(p==2){
                              alert("恭喜您获得了二等奖");
                            }else if(p==3){
                              alert("恭喜您获得了三等奖");
                            }else{
                               alert('未中奖额，再接再厉')
                            }
                            //var con = false;
                            
                            if (time!=0) {
                                var con = alert("你没有获奖" + '\n 还有' + time + '次机会,继续吗？');
                                lottery();
                            }
                        }
                    }
                });
            // }
        // });
    }
});

$half_height = $(window).height() / 2;
$half_height = $half_height - $("#onloading").height() / 2;
$("#onloading").css('top', $half_height + 'px');
$(document).ready(function () {
    $("#onloading").fadeOut(500, function () {
        $("#onloading").remove();
    });
});


// $(function () {
//     $.get("./ms_ajax.php?siteid=44&process_type=_behavior_view_&title=" + encodeURIComponent(document.title) + "&url=" + encodeURIComponent(document.URL));
//     FastClick.attach(document.body);
// });