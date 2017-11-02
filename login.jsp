<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%
String adminID = "";
String adminPW = "";

String act = request.getParameter("act");
String admin_ip  =request.getRemoteAddr();
String rand = (String)session.getAttribute("rand");
	String input = request.getParameter("rand");

if ( act != null ) {
	if ( act.equals("process") ) {
		try {
			adminID = request.getParameter("adminID").trim();
			adminPW = request.getParameter("adminPW").trim();
			boolean checkip = false;
			DbBean db = new DbBean();
				List iplist = db.SelectRS("select ipaddress from adminfilter where deleteflag = 0 ");				
				if( iplist != null && iplist.size() > 0 ) {
					for ( int i = 0; i < iplist.size(); i++ ) {
						Map ipmap = (Map)iplist.get(i); 
						if( ipmap.get("ipaddress").toString().equals(admin_ip) ) {
							checkip = true;
						}else{
							out.println("<script>alert('未授權');top.location.href='/';</script>");
						}			
					} 
				}else{
					checkip = true;
				}
				if(checkip){
					List loginList = new ArrayList();
					loginList.add(adminID);
					loginList.add(adminPW);
					List userlist = db.SelectRSwhere("select * from member where member_account=? and password = ?",loginList);
					
					if ( userlist != null && userlist.size()>0 && rand.equals(input)) { 
						for ( int i = 0; i < userlist.size(); i++ ) {
							Map usermap = (Map)userlist.get(i); 
								session.setAttribute ("member_id",usermap.get("member_id").toString());
								session.setAttribute ("member_name",usermap.get("member_name").toString());
								session.setAttribute ("member_email",usermap.get("member_email").toString());
						}
						session.setAttribute ("member_account",adminID);
						response.sendRedirect ("/");
						return;
					} else {
						if(!rand.equals(input)){
							out.println ("<script language='javascript'>alert('驗證碼輸入錯誤.');location.href='/login.jsp';</script><noscript>Your browser does not support Script!</noscript>");
						}else{
							out.println ("<script language='javascript'>alert('帳號或密碼錯誤.');location.href='/login.jsp';</script><noscript>Your browser does not support Script!</noscript>");
						}
						return;
					}
				}
			
		} catch ( Exception e ) {
			out.println ("<script language='javascript'>alert('非法存取.');location.href='/';</script><noscript>Your browser does not support Script!</noscript>");
			return;
		}
	}
}
%>
<html  ng-app="app" ng-controller= "mainCrtl">
<head>
<meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>login</title>
	   <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="js/jquery.easing.1.3.js"></script>
	<script src="js/jquery.backgroundPosition.js"></script>
	<script src="js/cs.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../bootstrap-3.3.1-dist/dist/fonts/">
	<link href="style.css" rel="stylesheet" type="text/css">
	<script src="js/angular.js"></script>
	<script src="js/address.js"></script>
</head>

 <body  bgcolor="#FFFCA7"  >

 <center>
 <table>
		
		<tr>
		<%@ include file = "/_include/menu.jsp"%>
		</tr>
		</table></center>
<div class="row">
<div class="col-md-4"></div>
<div class="col-md-4">
<% if ( session.getAttribute ("member_id") != null) {
	DbBean db = new DbBean();
	int m_id = Integer.parseInt((String)session.getAttribute ("member_id"));
	List idList = new ArrayList();
					idList.add(m_id);
	List memberlist = db.SelectRSwhere("select * from member where member_id=? ",idList);
	if ( memberlist != null && memberlist.size()>0 ) { 
			for ( int i = 0; i < memberlist.size(); i++ ) {
				Map membermap = (Map) memberlist.get(i); 	
			        	String member_account =(String)membermap.get("member_account");
						String member_name    =(String)membermap.get("member_name");
						String member_email   =(String)membermap.get("member_email");
						String password       =(String)membermap.get("password");
						String city           =(String)membermap.get("city");
						String town           =(String)membermap.get("town");
						String address        =(String)membermap.get("address");
						String telephone      =(String)membermap.get("telephone");	
							
	%>
<form id="member_form" class="form-horizontal" role="form" data-ng-init="setcity('<%=city%>','<%=town%>');">
<input type="hidden" name="member_id" id="member_id" value="<%=m_id%>">
<input type="hidden" name="city" id="city" value="{{add_city}}">
<input type="hidden" name="town" id="town" value="{{add_town.town}}">
<input type="hidden" name="choose" id="choose" value="update">
<table class="table table-hover">
<caption>會員修改</caption>

<tr>
<td>姓名</td>
<td><input type="text" class="form-control" name="member_name" id="member_name" value="<%=member_name%>"> </td>
</tr>
<tr>
<td>帳號</td>
<td> <input type="text" class="form-control" name="member_account" id="member_account" value="<%=member_account%>"></td>
</tr>
<tr>
<td>密碼</td>
<td><input type="text" class="form-control" name="password" id="password" value="<%=password%>"> </td>
</tr>
<tr>
<td>email</td>
<td><input type="text" class="form-control" name="member_email" id="member_email" value="<%=member_email%>"> </td>
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
<td><input type="text" class="form-control" name="address" id="address" value="<%=address%>"> </td>
</tr>
<tr>
<td>電話</td>
<td><input type="text" class="form-control" name="telephone" id="telephone" value="<%=telephone%>"> </td>
</tr>
<tr>
<td>
<input type = "button" id = "modify_submit" class="btn btn-info" value = "MODIFY" onclick="form_submit();" >
</td>
</tr>
</tr>	
</table>	
</form>
<% 		}
	}
} else {
%>

<table class="table table-hover" width="500">

<caption><STRONG>會員</STRONG></caption>
 <form id="frmAdminLogin1" onsubmit='return isAdminLogin(1)'>
<tr>
<td>帳號</td>
<td> <input type="text" class="form-control" name ="login_account" id = "login_account" value=""></td>
</tr>
</form>
<form id="frmAdminLogin2" action="" onsubmit='return isAdminLogin(2)' method="post">
                        <input type="hidden" name="act" value="process">
                        <input type="hidden" name="adminID">
<tr>
<td>密碼</td>
<td><input type="password" class="form-control" name ="adminPW"> </td>
</tr>
<tr>
<td><img border=0 src="/@admin/image.jsp"  width="94" heigh="34" border="0"></td>
<td><input type="password" class="form-control" name ="rand" maxlength="4" placeholder="請輸入驗證碼" onKeyDown="toQuery()"> </td>
</tr>
		<tr>
		<td><p>Not a member? <a href="register.jsp">註冊</a></p></td>
		<td><input type = "button" class="btn btn-info" value = "LOGIN"  onclick='submitAdminLogin()'></td>
		
		</tr>
</form>		
</tr>	
</table>	
<% } %>
</div>
</div>
</body>
<script language='javascript'>
    function isAdminLogin (n) {
        var f1 = document.getElementById("frmAdminLogin1");
        var f2 = document.getElementById("frmAdminLogin2");
        f2.adminID.value = document.getElementById("login_account").value;

        if (n == 1) {
            if (document.getElementById("login_account").value == "") {
                alert ("請輸入帳號.");
                return false;
            } else {
                f2.adminPW.focus ();
                return false;
            }

        } else if (n == 2) {
            if (f2.adminID.value == "") {
                alert ("請輸入帳號.");
                document.getElementById("login_account").focus ();
                return false;
            } else {
                if (f2.adminPW.value == "") {
                    alert ("請輸入密碼.");
                    f2.adminPW.focus ();
                    return false;
                } else {
                    return true;
                }
            }
        }
    }

    function submitAdminLogin () {
        if (!isAdminLogin(2)) return;
        else {
            frmAdminLogin2.submit ();
        }
    }
	function toQuery(){
		if( event.keyCode == 13 ){
			submitAdminLogin();
		}
	}
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
		$('#modify_submit').attr('disabled', true);
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
					console.log('會員資料修改成功');
            		alert($('#member_name').val() + '的會員資料已修改成功。');
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
            	console.log('會員資料修改失敗');
            	console.log("XMLHttpRequest.status="+XMLHttpRequest.status+
			    		"\nXMLHttpRequest.readyState="+XMLHttpRequest.readyState+"\ntextStatus="+textStatus+"\errorThrown="+errorThrown);
            },
            complete: function(XMLHttpRequest) {
				$('#modify_submit').attr('disabled', false);
            	console.log('會員資料修改結果');
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