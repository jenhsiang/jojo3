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
	  <hr width="65%" color=#868A08>
	  <table>
		<tr>
		<div class="w3-content w3-section" style="max-width:1000px">
		  <img class="mySlides" height="400" src="show1.jpg" style="width:100%">
		  <img class="mySlides" height="400" src="show2.jpg" style="width:100%">
		  <img class="mySlides" height="400" src="show3.jpg" style="width:100%">
		  <img class="mySlides" height="400" src="show4.jpg" style="width:100%">
		  <img class="mySlides" height="400" src="show5.jpg" style="width:100%">
		  <img class="mySlides" height="400" src="show6.jpg" style="width:100%">
		</div>
		<hr width="65%" color=#868A08>

<script>
var myIndex = 0;
carousel();

function carousel() {
    var i;
    var x = document.getElementsByClassName("mySlides");
    for (i = 0; i < x.length; i++) {
       x[i].style.display = "none";
    }
    myIndex++;
    if (myIndex > x.length) {myIndex = 1}
    x[myIndex-1].style.display = "block";
    setTimeout(carousel, 2000); // Change image every 2 seconds
}
</script>
		
		<table  bgcolor=#E1F5A9 width="150" height="60" >
		<tr>
		<th><font color=#088A08 size=5>最新消息</font></th>
		</tr>
		</table>
		<table style="width:40%" height="350" BORDER="0">
  <tr>
    <td><a href="https://www.facebook.com/EverydayBoardgame/?pnref=story"  target="_blank" ><img src="news1.jpg" style="width:400px;height:400px;"></a></td>
    
    <td><a href="https://www.facebook.com/events/701478853337224/"  target="_blank" ><img src="news2.jpg" style="width:400px;height:400px;"></a></td>
  </tr>
</table>


		</table>
		
		<table  bgcolor=#E1F5A9 width="150" height="60" >
		<tr>
		<th><font color=#088A08 size=5>桌遊推薦</font></th>
		</tr>
		</table>
		
        <table width="96%" bgcolor="#CEF6EC" border="1" BORDERCOLOR=white style="border-collapse: collapse;" style="border: 1px solid black;">
			<tr>
			<td width="32%">
			<li>
				<div style="float: left;">
					<a href="index3-39.jsp"><img src="img/pic13.jpg" alt="阿瓦隆" id="itemImg" width="180" height="230"></a>
				</div>
				<div style="float: left;">
					<H2 style="color:BLUE;">阿瓦隆</H2>
					<p style="color:BLACK;">人數：5~10人</p>
					<p style="color:BLACK;">作者：Don Eskridge</p>
					<p style="color:BLACK;">類別：家庭遊戲</p>
					<p style="color:BLACK;">Price: 390 NTD</p>
					<p><a href="index3-39.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
				
			</li></td>
			<td width="32%"><li>
				<div style="float: left;">
					<a href="index3-6.jsp"><img src="pic15.jpg" alt="情書" id="itemImg" width="200" height="250"></a>
				</div>
								<div style="float: left;">
					<H2 style="color:BLUE;">情書(Love Letter)</H2>
					<p style="color:BLACK;">人數：2~4人</p>
					<p style="color:BLACK;">作者：Seiji Kanai</p>
					<p style="color:BLACK;">類別：家庭遊戲</p>
					<p style="color:BLACK;">Price: 358 NTD</p>
					<p><a href="index3-6.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
				
			</li></td>
<td width="32%"><li>
    <div style="float: left;">
        <a href="index3-5.jsp"><img src="pic14.jpg" alt="超級犀牛" id="itemImg" width="200" height="250"></a>
    </div>
    				<div style="float: left;">
					<H2 style="color:BLUE;">超級犀牛(super rhino)</H2>
					<p style="color:BLACK;">人數：2~5人</p>
					<p style="color:BLACK;">作者：Thies Schwarz</p>
					<p style="color:BLACK;">類別：家庭遊戲</p>
					<p style="color:BLACK;">Price: 600 NTD</p>
					<p><a href="index3-5.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
	
</li>
</td>
</tr>
</table>

</center>
<img src="//www.easycounter.com/counter.php?jojochen"
border="0" alt="Website Hit Counter" align="right"></a>


</body>
</html>
