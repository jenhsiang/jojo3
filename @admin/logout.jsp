<%@ page contentType="text/html;charset=UTF-8" session="true" isErrorPage="true" %>

<%
	session.removeAttribute ("sesAdminID");
	session.removeAttribute ("sesAdminName");
	session.removeAttribute ("sesMainAdmin");
    session.invalidate ();
    response.sendRedirect("/@admin"); 
%>
