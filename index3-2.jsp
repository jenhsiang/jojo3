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
	  
		<h2 style="color:#FA5858" align="center" ><font face="Algerian">驢橋(Eselsbrücke)</font></h2>
		
		<table border="0" width="80%" height="350">
			<th width="20%"><img src="pic10.jpg" style="width:300px;height:400px;" align="left">
			
			</th>
			<th width="80%">
			<p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:120%;">
			<font color="#5F4C0B">
			 @遊戲人數：3~12人<br>
			 @適合年齡：8歲以上 <br>
			 @遊戲時間：10~30分鐘
			 </font>
			 </p>
			 <p align="left" size="32px" style="font-family:Microsoft JhengHei;font-size:130%;">
			 <font color="#0B615E">
			 *遊戲開始<br>
			 -“驢橋”? 聽到這個桌遊名字時會不會很狐疑呢？這個遊戲到底在玩什麼的？一隻驢過一座橋？還是猜不出來啊？原來原文的Eselsbrücke是故事記憶法的意思，也就是用容易記憶的一小段話或故事將不相關的詞語連在一起以便容易記住。原文Eselsbrücke是由”驢子Esel”和”橋Brücke”所組成的。<br>
			 -一次在和孩子們玩有關企鵝遊戲並介紹企鵝的家除南極外還有＂加拉巴哥＂群島，為了讓孩子容易記住這個地方，我也編了一個故事「有一次去餐廳吃飯點餐，愛吃辣的我特別請服務生幫我點的菜＂加辣八個＂」。這樣就很容易記住這個地方哦！<br>
			 -沒錯，驢橋就是一款編故事記憶的遊戲，只要故事編得精采讓人印象深刻，你會發現你的記憶力超乎你想像呢！<br>
			
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
		<div class="fb-comments" data-href="http://www.top-martin.net/index3-2.jsp" data-colorscheme="light" data-numposts="100" data-width="700"></div>
		 
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
