<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<html ng-app="app" ng-controller= "mainCrtl">
<head>
<meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../bootstrap-3.3.1-dist/dist/fonts/">
	<link href="style.css" rel="stylesheet" type="text/css">
	<script src="js/angular.js"></script>
	<script src="js/address.js"></script>
</head>
 <body  bgcolor="#E6E6FA"> 
<center>
 <table>
		<tr>
		<%@ include file = "/_include/menu.jsp"%>
		</tr>
		</table></center>
<div class="row">
<div class="col-md-4"></div>
<div class="col-md-4">
<form id="member_form" class="form-horizontal" role="form" data-ng-init="setcity('台北市','中正區');">
<input type="hidden" name="member_id" id="member_id" value="0">
<input type="hidden" name="city" id="city" value="{{add_city}}">
<input type="hidden" name="town" id="town" value="{{add_town.town}}">
<input type="hidden" name="choose" id="choose" value="insert">
<table class="table table-hover">
<caption>會員註冊</caption>
<tr>
<td>姓名</td>
<td><input type="text" class="form-control"  name="member_name" id="member_name" > </td>
</tr>
<tr>
<td>帳號</td>
<td> <input type="text" class="form-control" name="member_account" id="member_account" ></td>
</tr>
<tr>
<td>密碼</td>
<td><input type="password" class="form-control" name="password" id="password" > </td>
</tr>
<tr>
<td>確認密碼</td>
<td><input type="password" class="form-control" name ="confirm_password" id="confirm_password" > </td>
</tr>
<tr>
<td>email</td>
<td><input type="text" class="form-control" name="member_email" id="member_email"> </td>
</tr>
<tr>
<td>城市</td>
<td><select class="city" ng-model="add_city" ng-options="name.city as name.city for name in cityName"  ng-change="getcitytown()">
</select> </td>
</tr>
<tr>
<td>地區</td>
<td><select class="town" ng-model="add_town" ng-options="name as name.town for name in setTownName">
</select></td>
</tr>
<tr>
<td>地址</td>
<td><input type="text" class="form-control" name="address" id="address"> </td>
</tr>
<tr>
<td>電話</td>
<td><input type="text" class="form-control" name ="telephone" id="telephone"> </td>
</tr>
<tr>
<td><input id="register_submit" type = "button" class="btn btn-info" value = "REGISTER" onclick="form_submit();" ></td>
</tr>
</tr>	
</table>	
</form>
</div>
</div>
</body>
<script language='javascript'>
function form_submit() {

    var msg = '';
   
    if ($('#member_name').val().length == 0)
        msg += '沒有填寫 "name"\n';
    else if ($('#member_name').val().length < 2)
        msg += '"name"請填寫詳細\n';
	
	 if ($('#member_account').val().length == 0)
        msg += '沒有填寫 "account"\n';
    else if ($('#member_account').val().length < 4)
        msg += '"account"至少4個字母\n';
	
	 if ($('#password').val().length == 0)
        msg += '沒有填寫 "password"\n';
    else if ($('#password').val().length < 4)
        msg += '"password"至少4個字母\n';
	
	if ($('#confirm_password').val().length == 0)
        msg += '沒有填寫 "confirm password"\n';
    else if ($('#password').val() != $('#confirm_password').val() ){
        msg += '"password"和"confirm password"不相同\n';
		 var f3 = document.getElementById("member_form");
		$('#password').val("");
		$('#confirm_password').val("");
		f3.password.focus ();
	}
	 if ($('#member_email').val().length == 0)
        msg += '沒有填寫 "E-mail"\n';
    else if (/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test($('#member_email').val()) === false)
        msg += '格式有誤 "E-mail"\n';

	 if ($('#address').val().length == 0)
        msg += '沒有填寫 "address"\n';
    else if ($('#address').val().length < 5)
        msg += '"address"至少5個字\n';
	
    if ($('#telephone').val().length == 0)
        msg += '沒有填寫 "telephone"\n';
    else if (/\d{10,}/.test($('#telephone').val()) === false)
        msg += '格式有錯 "telephone"\n';  
   
   
    if (msg.length == 0){
		$('#register_submit').attr('disabled', true);
        $.ajax({
            url: "/controller/MemberHandler.jsp",
            data:$("#member_form").serialize(),
            type: "POST",
            dataType: "json",
            success: function(data,textStatus,jqXHR) {
            	console.log(data);
            	console.log(textStatus);
            	console.log(jqXHR);
            	if(data == 2){
					console.log('會員資料註冊成功');
            		alert($('#member_name').val() + '的會員資料已註冊成功。');
					location.reload();
				}else if(data == 4){
					 var f3 = document.getElementById("member_form");
					 alert("此帳號" + $('#member_account').val() + "已有人使用，請換帳號，謝謝。");
					 $('#member_account').val("");
					   f3.member_account.focus ();
            	}else{
            		alert('系統錯誤，請通知網站管理員');
            	}
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
            	console.log('會員資料註冊失敗');
            	console.log("XMLHttpRequest.status="+XMLHttpRequest.status+
			    		"\nXMLHttpRequest.readyState="+XMLHttpRequest.readyState+"\ntextStatus="+textStatus+"\errorThrown="+errorThrown);
            },
            complete: function(XMLHttpRequest) {
				$('#register_submit').attr('disabled', false);
            	console.log('會員資料註冊結果');
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
</html>