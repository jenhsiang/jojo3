<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%
if ( session.getAttribute ("sesAdminID") == null || session.getAttribute ("sesAdminID").equals ( "" ) ) {
	out.println ("<script language='javascript'>alert('您需重新登入.'); if (parent.window) { parent.window.location.href='/@admin'; } else { location.href='/@admin'; } </script>");
	return;
}
%>