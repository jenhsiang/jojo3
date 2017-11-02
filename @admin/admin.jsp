<%@ page contentType="text/html;charset=UTF-8" session="true" isErrorPage="true" %>
<style type="text/css">
body { background:#E0E0E0;}
td   { font-size:12px; color:#ffffff; }
a    { color:#ffffff; text-decoration:none; }
a:hover { text-decoration:underline; }
b	{color:#A0A0A0}
.arrow{
	position:absolute;
	width:33px;
	height:38px;
	z-index:111;
	left:500px;
	top:50px;
	cursor:pointer;
	-webkit-transition: -webkit-transform 0.4s ease !important;
	-moz-transition: -webkit-transform 0.4s ease !important;
	-ms-transition: -webkit-transform 0.4s ease !important;
	transition: transform 0.4s ease !important;	
}
.opacity{
	opacity:.5;
}
.rotate{	
	transform:rotate(180deg);	
}
.close{
	-webkit-transform:translateY(-60px);
	-moz-transform:translateY(-60px);
	-ms-transform:translateY(-60px);
	transform:translateY(-60px);	
}

</style>
<%@ include file = "/_include/lib_admin.jsp" %>
<%	
	String admin_ip  =request.getRemoteAddr();
	String sesAdminName = (String)session.getAttribute ("sesAdminName");
	String MainAdmin = (String)session.getAttribute ("sesMainAdmin");
	String adminID = (String)session.getAttribute ("sesAdminID");
	String adminName = (String)session.getAttribute ("sesAdminName"); 
	int sum = 0;
%>
<link rel="stylesheet" href="style.css" type="text/css" />
<script type="text/javascript" src="script.js"></script>
<script type="text/javascript" src="/js/jquery-1.11.1.min.js"></script>	
<body >
<nav>
	<div style="top:0px;left:0px;height:70px;background-color:#000000;">
		<div style="float:left"><img src="avatar.jpg" style="width:75px;height:70px;"></div>
			<div ><font size="5" color="yellow" >目前使用者:<%=sesAdminName%>  IP:<%=admin_ip%></font></div>
			
	<ul class="menu" id="menu">
	<li><a href="logout.jsp" class="menulink">登出管理者</a></li>
	<%if(MainAdmin.equals("1")){%>
	<li><a href="#" class="menulink">後台使用者資訊及管理</a>
		<ul>	
			<li>
				<a href="#" class="sub">使用者</a>
				<ul>
					<li class="topline"><a href='adminuser.jsp' target='incFrame'>管理使用者</a></li>
					<li><a href='adminfilter.jsp' target='incFrame' >限制IP登入後台</a></li>
				</ul>
			</li>
			<li><a href='contact_form.jsp' target='incFrame' >客戶訊息查詢</a></li>
		</ul>
	</li>
	<%}%>
	<li>
		<a href='newslist.jsp' target='incFrame'  class="menulink">最新消息管理</a>
	</li>
	<li><a href="#" class="menulink">桌遊項目管理</a>
		<ul>	
			<li>
				<a href="#" class="sub">類別及推薦管理</a>
				<ul>
					<li class="topline"><a href='a_category.jsp' target='incFrame'>類別管理</a></li>
					<li><a href='a_recommend.jsp' target='incFrame' >推薦管理</a></li>
				</ul>
			</li>
			<li><a href='a_book.jsp' target='incFrame' >桌遊管理</a></li>
		</ul>
	</li>
	<li>
		<a href='a_member.jsp' target='incFrame'  class="menulink">會員資料查詢</a>
	</li>
	<li>
		<a href='a_borrow_record.jsp' target='incFrame'  class="menulink">預約租借及付款處理</a>
	</li>
</ul>
<div class="arrow"><img src="/images/arrow.png" width="33" height="38" border="0"></div>
</div>
</nav>
<div id="container" >
	<iframe name="incFrame" id="incFrame" frameborder=0 width="100%" height="100%" src="banner.jpg"></iframe>
</div>
</body>
</html>
<script language='javascript'>
	var menu=new menu.dd("menu");
	menu.init("menu","menuhover");
	(function(){
		
		$('.arrow').click(function(){
			
			$('nav').toggleClass('close');	
			$('#container').toggleClass('close');
			setTimeout(function(){
				$('.arrow').toggleClass('rotate');
				$('nav').toggleClass('opacity');
			},500);
		});

	})();
</script>
<noscript>Your browser does not support Script!</noscript>