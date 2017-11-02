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
	  
		<h2 style="color:#FA5858" align="center" ><font face="Algerian">殭屍商場(MallofHorror)</font></h2>
		
		
		<table border="0" width="80%" height="350">
			<th width="20%"><img src="img/pic21.jpg" style="width:300px;height:400px;" align="left">
			
			</th>
			<th width="80%">
			<p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:120%;">
			<font color="#5F4C0B">
			 @遊戲人數：2~6人<br>
			 @適合年齡：14歲以上 <br>
			 @遊戲時間：約60分
			 </font>
			 </p>
			 <p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:130%;">
			 <font color="#0B615E">
			 *遊戲開始<br>
			  當你開心地在逛街買東西的時候，突然聽到四周尖叫大喊的聲音，殭屍們包圍了整座商場，你只能不斷地來回逃竄，以躲避殭屍們的襲擊，祈禱救援隊能夠早日來臨。</br>
			  這是一款殭屍主題的投票遊戲，每回合開獎看多的殭屍從哪裡出現，玩家們操控的人物在小小的商場裡面逃竄，遇到真的抵擋不住的時候，就推人去死，可以說是去死去死團的經典遊戲之一，我還蠻喜歡這款遊戲，因為還蠻刺激滴，不過贏的人往往會被說是心機鬼。<br>
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
					<u><a href="video.jsp"><font color="blue">更多影片</font></a></u>
					</p>
					<font color="red">請給我們一個讚吧~</font>
					<div class="rw-ui-container"></div>
			</th>
		</tr>
		</table>
		<div class="fb-comments" data-href="http://www.top-martin.net/index3-15.jsp" data-colorscheme="light" data-numposts="100" data-width="700"></div>
		 
</center>
<script type="text/javascript">(function(d, t, e, m){
    
    // Async Rating-Widget initialization.
    window.RW_Async_Init = function(){
                
        RW.init({
            huid: "337476",
            uid: "7ac011a16604b6c9a35e705b84fc642a",
            source: "website",
            options: {
                "advanced": {
                    "font": {
                        "hover": {
                            "color": "#906461"
                        },
                        "color": "#906461"
                    }
                },
                "size": "large",
                "type": "nero",
                "label": {
                    "background": "#FFEDA4"
                },
                "style": "thumbs",
                "isDummy": false
            } 
        });
        RW.render();
    };
        // Append Rating-Widget JavaScript library.
    var rw, s = d.getElementsByTagName(e)[0], id = "rw-js",
        l = d.location, ck = "Y" + t.getFullYear() + 
        "M" + t.getMonth() + "D" + t.getDate(), p = l.protocol,
        f = ((l.search.indexOf("DBG=") > -1) ? "" : ".min"),
        a = ("https:" == p ? "secure." + m + "js/" : "js." + m);
    if (d.getElementById(id)) return;              
    rw = d.createElement(e);
    rw.id = id; rw.async = true; rw.type = "text/javascript";
    rw.src = p + "//" + a + "external" + f + ".js?ck=" + ck;
    s.parentNode.insertBefore(rw, s);
    }(document, new Date(), "script", "rating-widget.com/"));</script>
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
