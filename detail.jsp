<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	if ( session.getAttribute ("member_id") != null && session.getAttribute ("member_name") != null  
	    && request.getParameter("book_id") != null && request.getParameter("book_name") != null ){
		String  member_id 	 = (String)session.getAttribute ("member_id");
		String  member_name  = (String)session.getAttribute ("member_name");
		String  book_id 	 = (String)request.getParameter("book_id");
		String  book_name    = (String)request.getParameter("book_name");
%>	
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>看啥租啥租書店</title>
        <link rel="stylesheet" type="text/css" href="/ext-4.2.1.883/resources/css/ext-all.css" />
        <script type="text/javascript" src="/ext-4.2.1.883/ext-all.js"></script>
        <script type="text/javascript" src="/ext-4.2.1.883/locale/ext-lang-zh_TW.js"></script>
         <script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
         <script src="js/imagePreview.js" type="text/javascript"></script>
        <script type="text/javascript" src="/js/view/detail.js?member_id=<%=member_id%>&member_name=<%=member_name%>&book_id=<%=book_id%>&book_name=<%=book_name%>"></script>
		<link rel="stylesheet" type="text/css" href="/@admin/ext-patch.css" />
		<style type="text/css"> 
		.x-grid-cell.user-notyet 
		{ 
		color: blue; 
		} 
		.x-grid-cell.user-cancel 
		{ 
		 color: red; 
		} 
		/*交流管理系统 开始*/
tr.x-grid-record-red .x-grid-td { background: #FF0000; color:#FFFFFF }/*grid 行颜色*/

/*tr.x-grid-record-green .x-grid-td { background: #00ff90; font-color: }grid 行颜色*/
/*交流管理系统 结束*/
		</style>
    </head>
    <body>
        <div id="main">
            <div id="head" style="font-weight:bold;font-size:200%;"><%=member_name%>會員，(<%=book_name%>)所有租書紀錄</div>
            <div id="foot" style="text-align:right;">  </div>
        </div>
    </body>
</html>
<%} else{
	out.println ("<script language='javascript'> alert('會員請先登入，謝謝!'); parent.location.href='login.jsp'; </script>");
}%>