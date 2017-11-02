<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%!
 private String  getTitle(String title){
 		String shortString = "";
       		if(title.length() > 40)
       			shortString = title.substring(0,40)+"...";
       		else
       			shortString = title;
       		return 	shortString;
        }
private int  getPagecount(int size){
 		int count = size/15;
       		if( size % 15 != 0 )
       			count ++;
       		return 	count;
        }
%>
<%
	request.setCharacterEncoding("UTF-8");
	int nowpage = Integer.parseInt((String)request.getParameter("page"));
	String start = String.valueOf((nowpage-1)*15);
	DbBean db = new DbBean();
	List AllNews = db.SelectRS("select * from newslist where deleteflag = 0 order by n_order ");
	int pagecount = getPagecount(AllNews.size());
	List showNews = db.SelectRS("select * from newslist where deleteflag = 0 order by n_order limit "+start+",15");
	String[] NewsAll;
	String[] NewsArray;
	String[] NewsIdx;
	if(showNews.size() < 15 ){
		NewsAll = new String[showNews.size()];
		NewsArray = new String[showNews.size()];
		NewsIdx = new String[showNews.size()];
	}else{
		NewsAll = new String[15];
		NewsArray = new String[15];
		NewsIdx = new String[15];
		}
	for(int i=0;i<NewsArray.length;i++){
		Map map = (Map) showNews.get(i);
			NewsAll[i] =(String) map.get( "n_title");
			NewsArray[i] =getTitle((String) map.get( "n_title"));
			NewsIdx[i] = String.valueOf((Integer)map.get( "n_order"));	
	}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>測試</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>

<body>
    <div id="container">
        <header>
        	<div class="logo"><img src="images/logo.png" width="70" height="48" alt="測試" border="0"></div>
            <div class="company">測試</div>
        </header>
        <nav>
        	<ul>
            	<li class="m-1"><a href="about.html" target="_self">關於我們</a></li>
                <li class="m-2"><a href="service.html" target="_self">服務項目</a></li>
                <li class="m-3"><a href="price.html" target="_self">收費標準</a></li>
                <li class="m-4"><a href="qa.html" target="_self">常用問題</a></li>
                <li class="m-5"><a href="link.html" target="_self">常用連結</a></li>
                <li class="m-6"><a href="contact.html" target="_self">聯絡我們</a></li>
            </ul>
        </nav>
        <div id="slider">
        	<img src="img/img_03.png" width="100%" border="0" id="img1">
            <img src="img/img_04.png" width="100%" border="0" id="img2">
        </div>
        <article>
        <aside class="aside-left-1">
            <div class="label ll-0"></div>
            <div class="news-content-list">
            <form>
                <ul class="news-list list-in">
                <%for(int i=0;i<NewsArray.length;i++){
					if(i%2==0){ %>
				<li class="list-a">
				<%}else{%>
				<li class="list-b">
				<%}%>
                <span class="list-style-1"></span><a href="news_content.jsp?id=<%=NewsIdx[i]%>" target="_self" title="<%=NewsAll[i]%>" ><%=NewsArray[i]%></a></li>
                  <%}%>   
                </ul>
                <ul class="pageButton">
                	<li><a class="button" onclick="gotopage(<%=nowpage%>,<%=pagecount%>,'forword')">上一頁</a></li>
                    <li class="pageNumber"><%=nowpage%>/<%=pagecount%></li>
                    <li><a class="button" onclick="gotopage(<%=nowpage%>,<%=pagecount%>,'backword')">下一頁</a></li>
                </ul>
            </form>
            </div>
        </aside>
        <aside class="aside-right-1">
        	<ul id="right-icon">
            	<li><div class="ricon icon-1"></div>設立流程</li>
                <li><div class="ricon icon-2"></div>服務時程</li>
                <li><div class="ricon icon-3"></div>公司與行號<br>的差別</li>
                <li><div class="ricon icon-4"></div>文件下載</li>
            </ul>
        </aside>
        </article>
        <footer></footer>
    </div>
<script src="js/jquery.min.js"></script>
<script src="js/jquery.easing.1.3.js"></script>
<script src="js/jquery.backgroundPosition.js"></script>
<script src="js/cs.js"></script>
<script>
	function gotopage(pagenow,pagecount,description){
		if(description =='forword'){
			if(pagenow == 1)
				alert('已是第一頁');
			else{
				window.location = "news_list.jsp?page="+(pagenow-1);
			}		
		}else if(description =='backword'){
			if(pagenow == pagecount)
				alert('已是最後一頁');
			else{
				window.location = "news_list.jsp?page="+(pagenow+1);
			}	
		}
	}
(function(){
	
	$(window).resize(function() {
		$('article').css({height:$('.news-list').height()+135});
	}).trigger('resize');
	
	$('.pageButton').css({width:($('.pageNumber').width()+217),marginLeft:-$('.pageButton').width()/2});
		
})();
</script>
</body>
</html>
