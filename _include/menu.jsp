<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<html>
<head>
<style >
h1 {
    font-size: 700%;
	
}
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #0B615E;
}

li {

    float: left;
    border-right:1px solid #bbb;
}

li:last-child {
    border-right: none;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

li a:hover:not(.active) {
    background-color: #111;
}

.active {
    background-color: #4CAF50;
}
</style>
</head>
<body>
<center>
		<table align="center">
	<tr>
		<th>
			<image src=LOGOD.png width="100px" height="90">
		</th>
		<th>
			<p style="color:#0B615E" align="center" ><font face="Algerian" size="700">天天學桌遊</font><a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/"  target="_blank" ><img src="fb1.png" style="width:50px;height:40px;" align="right"></a>
		</th>
	</tr>
</table>
<table style="border: 0px solid #0B614B;" style="width:100%">
	<tr>
	
		<th>
		

			<ul>
				  
				  <li><a class="active" href="index.jsp" target="_self">首頁</a></li>
				  <li><a href="index4.jsp" target="_self">商品</a></li>
				  <li><a href="book.jsp" target="_self">租借</a></li>
				  
				  <li><a href="contact.jsp" target="_self">聯絡我們</a></li>
				  <li><a href="video.jsp" target="_self">影片</a></li>
				  <li class="m-5"><a href="rent.jsp" target="_self">狀態</a></li>
				  <li style="float:right"><a href="register.jsp" target="_self">註冊</a></li>
				  <li class="m-7"><a href="login.jsp" target="_self">
				<%	if ( session.getAttribute ("member_name") != null) {%>
				會員修改
				<%} else {%>
				登入
				<%}%>
				</a></li>
				<%	if ( session.getAttribute ("member_name") != null) {%>
				<li class="m-8"><a href="logout.jsp" target="_self">登出</a></li>
				<%}%>
			</ul>
				
        

</th>
</table>
</center>
</body>
</html>