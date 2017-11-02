<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%@ page import="org.joda.time.DateTime"%>
<%@ page import="org.joda.time.Period"%>
<%@ page import="org.joda.time.PeriodType"%>
<%!
	public boolean checkReq(Object obj){
		boolean check = false ;
		if(obj != null && !((String)obj).equals("")){
			check = true;
		}
		return check;
	}
	public Object getReq(Object obj){
		Object getS = "";
		if(obj != null){
			getS = (Date) obj;
		}
		return getS;
	}
	public int[] checkrent(int book_id,int member_id,int book_total){
		int[] result = new int[2];
				DbBean db = new DbBean();
				DateTime nowdate = new DateTime();
				DateTime endtime = nowdate.minusDays(1);
				List whereList = new ArrayList();
				whereList.add(book_id);
				whereList.add(member_id);
				whereList.add(nowdate.toString("yyyy-MM-dd HH:mm:ss"));
				whereList.add(endtime.toString("yyyy-MM-dd HH:mm:ss"));	
				List whereList2 = new ArrayList();
				whereList2.add(book_id);
				whereList2.add(member_id);
				whereList2.add(nowdate.toString("yyyy-MM-dd HH:mm:ss"));		
				List duringReserve = db.SelectRSwhere("select * from borrow_record where book_id = ? and member_id = ? and reserve_date <= ? and reserve_deadline >= ? and borrow_date is null and return_date is null and givefine = 0  ",whereList);
				List overReserve   = db.SelectRSwhere("select * from borrow_record where book_id = ? and member_id = ? and reserve_deadline <= ? and borrow_date is null and return_date is null and givefine = 0  ",whereList2);
				List duringRent    = db.SelectRSwhere("select * from borrow_record where book_id = ? and member_id = ? and borrow_date <= ? and borrow_deadline >= ? and  return_date is null and givefine = 0  ",whereList);
				List overRent	   = db.SelectRSwhere("select * from borrow_record where book_id = ? and member_id = ? and borrow_deadline <= ?  and return_date is null and givefine = 0 ",whereList2);
				List checkList = new ArrayList();
				if(duringReserve != null && duringReserve.size() > 0){
					result[0] = 1;
					checkList.addAll(duringReserve);
				}else if(overReserve != null && overReserve.size() > 0){
					result[0] = 2;
					checkList.addAll(overReserve);
				}else if(duringRent != null && duringRent.size() > 0){
					result[0] = 3;
					checkList.addAll(duringRent);
				}else if(overRent != null && overRent.size() > 0){
					result[0] = 4;
					checkList.addAll(overRent);
				}else if(book_total == 0){
					result[0] = 5;
					result[1] = 0;
				}
				if(checkList != null && checkList.size() > 0){
					for ( int j = 0; j < checkList.size(); j++ ) {
						Map map = (Map) checkList.get(j); 	
			        	int borrow_id  = (Integer)map.get("borrow_id");
						result[1] = borrow_id;	
					}
				}
		return result;
	}
	public String rentState(int rent_id){
		String rent = "";
		switch(rent_id) { 
			case 1: 
				rent = "預約中"; 
				break; 
			case 2: 
				rent = "已超過預約期限"; ; 
				break; 
			case 3: 
				rent = "租借中"; ; 
				break; 
			case 4: 
				rent = "已超過借閱期限，請盡快還桌遊"; ; 
				break;
			case 5: 
				rent = "桌遊都借光光了，下次請早!"; ; 
				break; 
		} 
		return rent;
	}
	public int getFine(int givefine,int fine,int rent_mark,Object reserve_deadline,Object borrow_deadline){
		int money = 0;
		if(givefine == 1){
			money = fine;
		}else if(rent_mark == 2 || rent_mark == 4){
			DateTime get_deadline = null;
			if(rent_mark == 2 && reserve_deadline != null ){
				get_deadline = new DateTime((Date)reserve_deadline).plusDays(1);
			}else if(rent_mark == 4 && borrow_deadline != null ){
				get_deadline = new DateTime((Date)borrow_deadline).plusDays(1);
			}
			if(get_deadline != null){
				DateTime nowdate = new DateTime();
				Period p = new Period(get_deadline, nowdate, PeriodType.days());
				money = 2 * p.getDays();
			}	
		}
		return money;
	}
%>
<%
	request.setCharacterEncoding("UTF-8");
	DbBean  db = new DbBean();
	String firstchoice  = "類別";
	int    secondchoice = 0 ;
	String bookname   = "" ;
	if(checkReq(request.getParameter("firstchoice"))){
		firstchoice = (String)request.getParameter("firstchoice");
	}
	if(checkReq(request.getParameter("secondchoice"))){
		secondchoice = Integer.parseInt((String)request.getParameter("secondchoice"));
	}
	if(checkReq(request.getParameter("bookname"))){
		bookname = (String)request.getParameter("bookname").replaceAll("\\s+", "");
	}
%>
<html  ng-app="app" ng-controller= "mainCrtl">
<head>
<style>
.button {
    background-color: #4CAF50;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
}
</style>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-capable" content="yes" />
<title>天天學桌遊</title>
<link href="style.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="modaal.css" media="screen">
<script src="js/angular.js"></script>
<script src="js/book.js"></script>
</head>
<body > 
		<%@ include file = "/_include/menu.jsp"%>
		
	<div id="tfheader">
		<form id="tfnewsearch" action = "book.jsp"  method="post" ng-init="setFirst('<%=firstchoice%>','<%=secondchoice%>');">
		<input type="hidden" name="firstchoice" id="firstchoice" value="{{add_first}}">
		<input type="hidden" name="secondchoice" id="secondchoice" value="{{add_second.search_id}}">
		<select class="city" ng-model="add_first" ng-options="name.search_type as name.search_type for name in firstName"  ng-change="getFirst();">
		</select>
		<select class="town" ng-model="add_second" ng-options="name as name.search_name for name in setSecondName" >
		</select>
		        <input type="text" class="tftextinput"  id = "bookname" name = "bookname"  size="21" maxlength="120" value="<%=bookname%>">

				<input type="submit" value="search" class="tfbutton">
		</form>
	<div class="tfclear"></div>
	  </div>
	  <center>
	  
		
		<table  bgcolor=#E1F5A9 width="150" height="60" >
		<tr>
		<th><font color=#088A08 size=5>商品</font></th>
		</tr>
		</table>
        <table width="96%" bgcolor="#CEF6EC" border="1" BORDERCOLOR=white style="border-collapse: collapse;" style="border: 1px solid black;">
			<tr>
			<td width="32%">
			<li>
				<div style="float: left;">
					<a href="index3.jsp"><img src="pic6.jpg" alt="妙語說書人" id="itemImg" width="180" height="230"></a>
				</div>
				<div style="float: left;">
					<H2 style="color:BLUE;">妙語說書人(DIXIT)</H2>
					<p style="color:BLACK;">人數：3~6人</p>
					<p style="color:BLACK;">作者：Jean-Louis Roubira</p>
					<p style="color:BLACK;">類別：派對遊戲</p>
					<p style="color:BLACK;">Price: 1048 NTD</p>
					<p><a href="index3.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
				
			</li></td>
			<td width="32%"><li>
				<div style="float: left;">
					<a href="index3-1.jsp"><img src="pic9.jpg" alt="矮人礦坑" id="itemImg" width="180" height="230"></a>
				</div>
				<div style="float: left;">
					<H2 style="color:BLUE;">矮人礦坑(Saboteur)</H2>
					<p style="color:BLACK;">人數：3~10人</p>
					<p style="color:BLACK;">作者：Frederic Moyersoen</p>
					<p style="color:BLACK;">類別：派對遊戲</p>
					<p style="color:BLACK;">Price: 508 NTD</p>
					<p><a href="index3-1.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>				
</li></td>
<td width="32%"><li>
    <div style="float: left;">
        <a href="index3-2.jsp"><img src="pic10.jpg" alt="驢橋" id="itemImg" width="180" height="230"></a>
    </div>
    <div style="float: left;">
        <H2 style="color:BLUE;">驢橋(Eselsbrücke)</H2>
        <p style="color:BLACK;">人數：3~12人</p>
        <p style="color:BLACK;">作者：Stefan Dorra</p>
		<p style="color:BLACK;">類別：記憶</p>
					<p style="color:BLACK;">Price: 1120 NTD</p>
        <p><a href="index3-2.jsp" style="color:blue;">MORE</a></p>
    </div>
    <div style="float: none; clear: both;"></div>
	
</li>
</td>
</tr>
</table>
<table width="96%" bgcolor="WHITE" border="1" BORDERCOLOR=#00b36b style="border-collapse: collapse;" style="border: 1px solid black;">
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
					<a href="index3-4.jsp"><img src="pic12.jpg" alt="出包魔法師" id="itemImg" width="180" height="230"></a>
				</div>
								<div style="float: left;">
					<H2 style="color:BLUE;">出包魔法師(ABRACA)</H2>
					<p style="color:BLACK;">人數：2~5人</p>
					<p style="color:BLACK;">作者：</p>
					<p style="color:BLACK;">類別：派對遊戲</p>
					<p style="color:BLACK;">Price: 990 NTD</p>
					<p><a href="index3-4.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
				
</li></td>
<td width="32%"><li>
    <div style="float: left;">
        <a href="index3-5.jsp"><img src="pic14.jpg" alt="超級犀牛" id="itemImg" width="180" height="230"></a>
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
<table width="96%" bgcolor="#CEF6EC" border="1" BORDERCOLOR=white style="border-collapse: collapse;" style="border: 1px solid black;">
			<tr>
			<td width="32%">
			<li>
				<div style="float: left;">
					<a href="index3-6.jsp"><img src="pic15.jpg" alt="情書" id="itemImg" width="180" height="230"></a>
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
					<a href="index3-7.jsp"><img src="pic11.jpg" alt="拉密(Rummikub)" id="itemImg" width="180" height="230"></a>
				</div>
								<div style="float: left;">
					<H2 style="color:BLUE;">拉密(Rummikub)</H2>
					<p style="color:BLACK;">人數：3~4人</p>
					<p style="color:BLACK;">作者：Ephraim Hertzano</p>
					<p style="color:BLACK;">類別：派對遊戲</p>
					<p style="color:BLACK;">Price: 510 NTD</p>
					<p><a href="index3-7.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
				
</li></td>
<td width="32%"><li>
    <div style="float: left;">
        <a href="index3-8.jsp"><img src="pic7.jpg" alt="驢橋" id="itemImg" width="180" height="230"></a>
    </div>
    				<div style="float: left;">
					<H2 style="color:BLUE;">從前從前</H2>
					<p style="color:BLACK;">人數：2~5人</p>
					<p style="color:BLACK;">作者：Reinhard Staupe</p>
					<p style="color:BLACK;">類別：派對遊戲</p>
					<p style="color:BLACK;">Price:  808 NTD</p>
					<p><a href="index3-8.jsp" style="color:blue;">MORE</a></p>
				</div>
				<div style="float: none; clear: both;"></div>
	
</li>
</td>
</tr>
</table>

</center>
<div class="container">
  <h2>Pager</h2>
  <ul class="pager">
    <li><a href="index4.jsp">1</a></li>
    <li><a href="index4-1.jsp">2</a></li>
	<li><a href="index4-2.jsp">3</a></li>
	<li><a href="index4-3.jsp">4</a></li>
	<li><a href="index4-4.jsp">5</a></li>
	
	<li><a href="index4-6.jsp">»</a></li>
  </ul>
</div>
<script type="text/javascript">(function(d, t, e, m){
    
    // Async Rating-Widget initialization.
    window.RW_Async_Init = function(){
                
        RW.init({
            huid: "337476",
            uid: "7ac011a16604b6c9a35e705b84fc642a",
            source: "website",
            options: {
                "size": "large",
                "type": "nero",
                "style": "thumbs_bp",
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
</body>
</html>
