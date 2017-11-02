<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%
if ( session.getAttribute ("sesAdminID") != null) {
		response.sendRedirect ("admin.jsp");
		return;
}

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
					List userlist = db.SelectRSwhere("select * from adminuser where a_userid=? and a_passwd = ? and deleteflag = 0",loginList);
					
					if ( userlist != null && userlist.size()>0 && rand.equals(input)) { 
						for ( int i = 0; i < userlist.size(); i++ ) {
							Map usermap = (Map)userlist.get(i); 
								session.setAttribute ("sesMainAdmin",usermap.get("admin").toString());
								session.setAttribute ("sesAdminName",usermap.get("a_username").toString());
						}
						session.setAttribute ("sesAdminID",adminID);
						response.sendRedirect ("admin.jsp");
						return;
					} else {
						if(!rand.equals(input)){
							out.println ("<script language='javascript'>alert('驗證碼輸入錯誤.');location.href='/@admin';</script><noscript>Your browser does not support Script!</noscript>");
						}else{
							out.println ("<script language='javascript'>alert('帳號或密碼錯誤.');location.href='/@admin';</script><noscript>Your browser does not support Script!</noscript>");
						}
						return;
					}
				}
			
		} catch ( Exception e ) {
			out.println ("<script language='javascript'>alert('非法存取.');location.href='/@admin';</script><noscript>Your browser does not support Script!</noscript>");
			return;
		}
	}
}
%>
<html>
<head>
<meta charset="utf-8">
<title>測試後台</title>
<link href="/style.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div id="login-container">
        	<div class="login-logo"><img src="avatar.jpg" width="70" height="58" alt="天天學桌遊" border="0"><div class="company-2" style="color:#0000FF">天天學桌遊後台</div></div>
        <div class="login-content">
         <form name="frmAdminLogin1" onsubmit='return isAdminLogin(1)'>
        	<div class="id"><input type="text" name="adminID" class="text" placeholder="帳號"></div>
         </form>
        	<form name="frmAdminLogin2" action="" onsubmit='return isAdminLogin(2)' method="post">
                        <input type="hidden" name="act" value="process">
                        <input type="hidden" name="adminID">
        	<div class="pd"><input type="password" name="adminPW" class="text" placeholder="密碼"></div>
            <div class="ck"><input type="text" name="rand" maxlength="4" class="text3" placeholder="請輸入驗證碼" onKeyDown="toQuery()"><div class="ckimg"><img border=0 src="image.jsp"  width="94" heigh="34" border="0"></div></div>
        	<div class="bt"><input type="button" value="送出" class="login-button" onclick='submitAdminLogin()'>
        	<input type="reset" value="取消" class="login-button"></div>
        	 </form>
         </div>
    </div>
</body>
</html>

<script language='javascript'>
    function isAdminLogin (n) {
        var f1 = frmAdminLogin1;
        var f2 = frmAdminLogin2;

        f2.adminID.value = f1.adminID.value;

        if (n == 1) {
            if (f1.adminID.value == "") {
                alert ("請輸入帳號.");
                return false;
            } else {
                f2.adminPW.focus ();
                return false;
            }

        } else if (n == 2) {
            if (f2.adminID.value == "") {
                alert ("請輸入帳號.");
                f1.adminID.focus ();
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
</script>