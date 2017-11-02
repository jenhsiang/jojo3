<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%!
 private String  getTitle(String title){
 		String shortString = "";
       		if( title.length()> 10)
       			shortString = title.substring(0,10)+"...";
       		else
       			shortString = title;
       		return 	shortString;
        }
private Object[]  getValue(List sqllist,String[] volumn){
 		Object[] rValue = new Object[volumn.length];
       		for(int i=0;i<sqllist.size();i++){
			Map map = (Map) sqllist.get(i);
				for(int j=0;j<rValue.length;j++){
					rValue[j] = map.get(volumn[j]);
				}
			}
       		return 	rValue;
        }
%>
<%
	request.setCharacterEncoding("UTF-8");
	int idx = Integer.parseInt((String)request.getParameter("id"));
	DbBean db = new DbBean();
	List newslist = null;
	List forwardlist = null;
	List backwardlist = null;
	Object[] nowValue = null;
	Object[] forwardValue = null;
 	Object[] backwardValue = null;
	String[] nowvolum = {"n_order","n_title","n_content","n_date"};
	String[] othervolum = {"n_order","n_title"};
	List AllNews = db.SelectRS("select * from newslist where deleteflag = 0 order by n_order ");
	int newscount = AllNews.size();
	List idList = new ArrayList();
	idList.add(idx);
	 newslist = db.SelectRSwhere("select * from newslist where n_order = ? and deleteflag = 0",idList);
	if(idx > 1){
		List fidList = new ArrayList();
		fidList.add(idx-1);
	 	forwardlist = db.SelectRSwhere("select * from newslist where n_order = ? and deleteflag = 0",fidList);
		forwardValue = getValue(forwardlist,othervolum);
	}
	if(idx < newscount){
		List bidList = new ArrayList();
		bidList.add(idx+1);
	 	backwardlist = db.SelectRSwhere("select * from newslist where n_order = ? and deleteflag = 0",bidList);
		backwardValue = getValue(backwardlist,othervolum);
	}	
    nowValue = getValue(newslist,nowvolum);
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
       <table>
		<tr>
		<img border="0" width="100%" height="350" src="library.jpg" alt="bvcb" />
			
		</tr>
		<tr>
		<%@ include file = "/_include/menu.jsp"%>
		</tr>
		</table>
        <article>
        <aside class="aside-left-1">
            <div class="content">
            <form>
            	<div class="content-t"><%=(String)nowValue[1]%></div>
                <div class="content-time"><%=(java.sql.Date)nowValue[3]%></div>
                <div class="content-c">
              <%=(String)nowValue[2]%>
                </div>
                <div class="button-pn">
                	<%if(idx > 1){%>
                    <div class="pre-news">上一則：<a href="news_content.jsp?id=<%=(Integer)forwardValue[0]%>" target="_self" title="<%=(String)forwardValue[1]%>"><%=getTitle((String)forwardValue[1])%></a></div>
                    <%}%>
                    <%if(idx < newscount){%>
                    <div class="next-news">下一則：<a href="news_content.jsp?id=<%=(Integer)backwardValue[0]%>" target="_self" title="<%=(String)backwardValue[1]%>"><%=getTitle((String)backwardValue[1])%></a></div>
                    <%}%>
                </div>
            </form>
            </div>
        </aside>
        </article>
        <footer></footer>
    </div>
<script src="js/jquery.min.js"></script>
<script src="js/jquery.easing.1.3.js"></script>
<script src="js/jquery.backgroundPosition.js"></script>
<script src="js/cs.js"></script>
<script>
(function(){
	
	$(window).resize(function() {
		$('article').css({height:$('.content').height()+100});
	}).trigger('resize');
	
	$('.pageButton').css({width:($('.pageNumber').width()+217),marginLeft:-$('.pageButton').width()/2});
		
})();
</script>
</body>
</html>
