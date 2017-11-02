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
	  
		<h2 style="color:#FA5858" align="center" ><font face="Algerian">JACK小盒版</font></h2>
		<table border="0" width="80%" height="350">
			<th width="20%"><img src="img/pic33.jpg" style="width:300px;height:400px;" align="left">
			
			</th>
			<th width="80%">
			<p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:120%;">
			<font color="#5F4C0B">
			 @遊戲人數：2人<br>
			 @適合年齡：8歲以上 <br>
			 @遊戲時間：約30分
			 </font>
			 </p>
			 <p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:130%;">
			 <font color="#0B615E">
			 *遊戲開始<br>
			 1888年–倫敦–白教堂區 陰暗的小街道終年被灰茫茫的霧幕所籠罩著，隱藏在這層霧幕底下的是倫敦百年來的奇案，
			 全英國人民無不希望這名對白教堂區治安投下震撼彈的惡魔–開膛手傑克早日被繩之以法。 
			 為此福爾摩斯與華生誓言將開膛手傑克的神祕面紗給揭開。蘇格蘭警場則派出幹練的Lestrade警探帶著大批警網試圖終結這份惡行威廉．
			 古爾醫生亦奉英女王之命前來提供科學上的幫助倫敦街頭的民眾們–燈伕約翰．
			 史密斯、明星日報的記者傑洛米．伯特、巡佐古德烈中士以及神祕的女性史黛西，也為了重新尋回白教堂區的安定和平，紛紛投入這場追捕--- <br>
			</font>
			</p>
			</th>
		
		</table>
		
		<h2 style="color:blue" align="center" style="font-family:Microsoft JhengHei;">教學影片</h2>
		<table>
		<tr>
			<th style="width:25%" >
					<iframe width="70%" height="600" src="https://www.youtube.com/embed/u651PVUlXas" frameborder="0" allowfullscreen></iframe>
					<p>
					<a href="video.jsp"><font color="blue">MORE</font></a>
					</p>
			</th>
		</tr>
		</table>
		 <div class="fb-comments" data-href="http://www.super-martin.net/index3-27.jsp" data-colorscheme="light" data-numposts="100" data-width="700"></div>
		 
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
</body>
</html>
