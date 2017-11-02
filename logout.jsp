<%@ page contentType="text/html;charset=UTF-8" session="true" isErrorPage="true" %>

<%
	session.removeAttribute ("member_id");
	session.removeAttribute ("member_name");
	session.removeAttribute ("member_email");
	session.removeAttribute ("member_account");
    session.invalidate ();
    response.sendRedirect("/"); 
%>
