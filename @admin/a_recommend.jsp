<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ include file = "/_include/lib_admin.jsp" %>	
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>推薦管理</title>
        <link rel="stylesheet" type="text/css" href="/ext-4.2.1.883/resources/css/ext-all.css" />
        <script type="text/javascript" src="/ext-4.2.1.883/ext-all.js"></script>
        <script type="text/javascript" src="/ext-4.2.1.883/locale/ext-lang-zh_TW.js"></script>
         <script src="/js/jquery-1.11.1.min.js" type="text/javascript"></script>
         <script src="/js/imagePreview.js" type="text/javascript"></script>
        <script type="text/javascript" src="/js/view/a_recommend.js"></script>
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
            <div id="head" style="font-weight:bold;font-size:200%;">推薦管理</div>
            <div id="foot" style="text-align:right;">  </div>
        </div>
    </body>
</html>