<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%!
 private String  getTitle(String title){
 		String shortString = "";
       		if(title.length() > 20)
       			shortString = title.substring(0,20)+"...";
       		else
       			shortString = title;
       		return 	shortString;
        }
%>
<%
	DbBean db = new DbBean();
	List showNews = db.SelectRS("select * from newslist where deleteflag = 0 order by n_order ");
	String[] NewsAll;
	String[] NewsArray;
	String[] NewsIdx;
	if(showNews.size() > 6 ){
		NewsAll = new String[6];
		NewsArray = new String[6];
		NewsIdx = new String[6];
	}else{
		NewsAll = new String[showNews.size()];
		NewsArray = new String[showNews.size()];
		NewsIdx = new String[showNews.size()];
		}
	for(int i=0;i<NewsArray.length;i++){
		Map map = (Map) showNews.get(i);
			NewsAll[i] =(String) map.get( "n_title");
			NewsArray[i] =getTitle((String) map.get( "n_title"));
			NewsIdx[i] = String.valueOf((Integer)map.get( "n_id"));	
	}
%>
<!doctype html>
<html>
<head>
<style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
h1 {
    font-size: 700%;
	
}
ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #333;
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
    padding: 13px 15px;
    text-decoration: none;
}

li a:hover:not(.active) {
    background-color: #CEF6CE;
}

.active {
    background-color: white;
}
</style>
<title>天天學桌遊</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body>
    
      <%@ include file = "/_include/menu.jsp"%>
	  <center>
	  
		<h2 style="color:#00b36b" align="center" ><font face="Algerian">桌遊教學影片</font></h2>
        <table style="width:80%" border="1" BORDERCOLOR=#00994d>
			  <tr>
			    <th style="width:25%" >
					<iframe width="420" height="345" src="https://www.youtube.com/embed/N0XEjcUJJF0" frameborder="0" allowfullscreen></iframe>
					<p>
					終極密碼.
					<a href="https://www.youtube.com/watch?v=N0XEjcUJJF0" target="_blank">FACEBOOK</a>
					</p>
				</th>
			    <th style="width:25%" >
					<iframe width="420" height="345" src="https://www.youtube.com/embed/RQ8PojUDUQM" frameborder="0" allowfullscreen></iframe>
					<p>
					超級犀牛(super rhino).
					<a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/" target="_blank">FACEBOOK</a>
					</p>
				</th>
				<th style="width:25%" >
					<iframe width="420" height="345"  src="https://www.youtube.com/embed/AdHejKQFmzY" frameborder="0" allowfullscreen></iframe>
					<p>
					阿瓦隆.
					<a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/" target="_blank">FACEBOOK</a>
					</p>
				</th>
				<tr>
			    <th style="width:25%" >
					<iframe width="420" height="345" src="https://www.youtube.com/embed/D66v_HmNr6g" frameborder="0" allowfullscreen></iframe>
					<p>
					情書.
					<a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/" target="_blank">FACEBOOK</a>
					</p>
				</th>
			    <th style="width:25%" >
					<iframe width="420" height="345" src="https://www.youtube.com/embed/l-79LeLWagA" frameborder="0" allowfullscreen></iframe>
					<p>
					德國心臟病.
					<a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/" target="_blank">FACEBOOK</a>
					</p>
				</th>
				<th style="width:25%" >
					<iframe width="420" height="345" src="https://www.youtube.com/embed/u651PVUlXas" frameborder="0" allowfullscreen></iframe>
					<p>
					妙語說書人(DIXIT).
					<a href="https://www.facebook.com/%E5%A4%A9%E5%A4%A9%E5%AD%B8%E6%A1%8C%E9%81%8A-1118376901610135/" target="_blank">FACEBOOK</a>
					</p>
				</th>
			  </tr>
		</table>
				<div class="fb-comments" data-href="http://www.top-martin.net/video.jsp" data-colorscheme="light" data-numposts="100" data-width="700"></div>
		 
</center>
<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '1872644546296897',
      xfbml      : true,
      version    : 'v2.8'
    });
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
</script>
<div class="container">
  <h2>Pager</h2>
  <ul class="pager">
    <li><a href="video.jsp">1</a></li>
    <li><a href="video1.jsp">2</a></li>
	<li><a href="video2.jsp">3</a></li>
	<li><a href="video3.jsp">4</a></li>
	<li><a href="video4.jsp">5</a></li>
	<li><a href="video5.jsp">»</a></li>
  </ul>
</div>
</body>
</html>
