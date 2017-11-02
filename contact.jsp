<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta charset="utf-8">
<title>Contact us</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div id="container">
	<center>
	<table>
		
		<tr>
		<%@ include file = "/_include/menu.jsp"%>
		</tr>
		</table></center>
        <article>
        <aside class="aside-left-1">
			<div class="label ll-6"></div>
            <form id="contact_form">
            <input type="hidden" id="contactidentity" name="identity" value="">
            	<p class="tp">滿意度：</p>
				<label class="radio"><input type="radio" name="RadioGroup1" value="很滿意">很滿意</label><br>
                <label class="radio"><input type="radio" name="RadioGroup1" value="還可以">還可以</label><br>
                <label class="radio"><input type="radio" name="RadioGroup1" value="不滿意">不滿意</label><br>
                <input type="text" id="contactname" name="name" placeholder="Name" class="text2 tp" maxlength="20"><br>
                <input type="text" id="contactemail" name="email" placeholder="E-mail" class="text2" maxlength="50"><br>
                <input type="text" id="contactphone" name="phone" placeholder="phone" class="text2" maxlength="20"><br>
                <textarea id="contactmessage" name="message" placeholder="Message" class="text4"></textarea>
                <div class="btns"><input type="reset" value="清除" class="login-button" id="contactclear" ><input type="button" value="送出" class="login-button" onclick="form_submit('contact');" id="contactsubmit" ></div>
            </form>
            
<script src="js/jquery.min.js"></script>
<script src="js/jquery.easing.1.3.js"></script>
<script src="js/jquery.backgroundPosition.js"></script>
<script src="js/cs.js"></script>
<script>
(function(){
	
	$('.m-6>a').css({color:'#17ade5'});
	
	$(window).resize(function() {
		$('article').css({height:$('.aside-left-1').height()+100});
	}).trigger('resize');
		
})();
function form_submit(element) {

    var msg = '';
    var identity = '';
	var RadioGroup1 = document.getElementsByName("RadioGroup1");
	for (var i=0;i<RadioGroup1.length;i++) {
        if (RadioGroup1[i].checked) {
        	identity = RadioGroup1[i].value;
        	$('#'+element+'identity').val(identity);
          break;
        }
      }
    
	if (identity == '')
	        msg += '沒有選擇 "身分"\n';
    if ($('#'+element+'name').val().length == 0)
        msg += '沒有填寫 "姓名"\n';
    else if ($('#'+element+'name').val().length < 2)
        msg += '"姓名"請填寫詳細\n';

    if ($('#'+element+'phone').val().length == 0)
        msg += '沒有填寫 "電話"\n';
    else if (/\d{10,}/.test($('#'+element+'phone').val()) === false)
        msg += '格式有錯 "電話"\n';

    if ($('#'+element+'email').val().length == 0)
        msg += '沒有填寫 "E-mail"\n';
    else if (/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test($('#'+element+'email').val()) === false)
        msg += '格式有誤 "E-mail"\n';
    
    if ($('#'+element+'message').val().length == 0)
        msg += '沒有填寫 "訊息"\n';
   
    if (msg.length == 0){
		$('#'+element+'submit').attr('disabled', true);
		$('#'+element+'clear').attr('disabled', true);
        $.ajax({
            url: "/controller/MailHandler.jsp",
            data:$("#"+element+"_form").serialize(),
            type: "POST",
            dataType: "json",
            success: function(data,textStatus,jqXHR) {
            	console.log(data);
            	console.log(textStatus);
            	console.log(jqXHR);
            	if(data == 2){
					console.log('寄信成功');
            		alert('感謝您的來信!將會有專人與您聯繫，謝謝。');
            	}else{
            		alert('系統錯誤，請通知網站管理員');
            	}
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
            	console.log('寄信失敗');
            	console.log("XMLHttpRequest.status="+XMLHttpRequest.status+
			    		"\nXMLHttpRequest.readyState="+XMLHttpRequest.readyState+"\ntextStatus="+textStatus+"\errorThrown="+errorThrown);
            },
            complete: function(XMLHttpRequest) {
				$('#'+element+'submit').attr('disabled', false);
                $('#'+element+'clear').attr('disabled', false);
            	console.log('寄信結果');
            	console.log(XMLHttpRequest);
            }
            
        	});
    }
    else{
        alert(msg);
    }

    return false;
}
</script>
</body>
</html>
