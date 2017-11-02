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
				rent = "借閱中"; ; 
				break; 
			case 4: 
				rent = "已超過借閱期限，請盡快還書"; ; 
				break;
			case 5: 
				rent = "書都借光光了，下次請早!"; ; 
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
	if ( session.getAttribute ("member_id") != null && session.getAttribute ("member_name") != null && session.getAttribute ("member_email") != null){
		int    member_id 		= Integer.parseInt((String)session.getAttribute ("member_id"));
		String member_name  = (String)session.getAttribute ("member_name");
		String member_email = (String)session.getAttribute ("member_email");
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-capable" content="yes" />
<title>看啥租啥租書店</title>
<link href="style.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="modaal.css" media="screen">
<script src="js/angular.js"></script>
<script src="js/book.js"></script>
</head>
<body  bgcolor="#FFFCA7"> 
<div id="container">
		<table>
		<tr>
		<img border="0" width="100%" height="350" src="library.jpg" alt="bvcb" />
			
		</tr>
		<tr>
		<%@ include file = "/_include/menu.jsp"%>
		</tr>
		</table>
	<div id="tfheader">
		<form id="tfnewsearch" action = "history.jsp"  method="post" ng-init="setFirst('<%=firstchoice%>','<%=secondchoice%>');">
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
<h3 align="center">Rent Book History</h3>
<table border="0" cellspacing="1" cellpadding="0" width="100%">
<%
			List chooseList = new ArrayList();
				 chooseList.add(member_id);
			String choice_datebase = "";
			if(firstchoice.equals("類別")){
				 choice_datebase = "category";
			}else if(firstchoice.equals("推薦")){
				 choice_datebase = "recommend";
			}
			String book_sql  = " select a.*,b." + choice_datebase + "_name from book as a left join " + choice_datebase + " as b on a." + choice_datebase + "_id = b." + choice_datebase + "_id where a.book_id in ";
				   book_sql += " ( select  book_id from borrow_record where member_id = ? GROUP BY book_id ) ";
			if(secondchoice == 0 && bookname.equals("")){
				book_sql += " order by a.book_id asc ";
			}else if(secondchoice == 0 && !bookname.equals("")){
				chooseList.add("%" + bookname + "%");
				book_sql += "  and a.book_name like ? order by a.book_id asc";
			}else if(secondchoice != 0 && bookname.equals("")){
				chooseList.add(secondchoice);
				book_sql += " and a." + choice_datebase + "_id = ?  order by a.book_id asc";
			}else if(secondchoice != 0 && !bookname.equals("")){
				chooseList.add(secondchoice);
				chooseList.add("%" + bookname + "%");
				book_sql += " and  a." + choice_datebase + "_id = ?  and  a.book_name like ? order by a.book_id asc";
			}
			List bookList = db.SelectRSwhere(book_sql,chooseList);
			if(bookList != null && bookList.size() > 0){
				for(int i=0;i<bookList.size();i++){
					Map map = (Map) bookList.get(i);
					int       book_id   	=(Integer) map.get( "book_id");
					int    	  choice_id   =(Integer) map.get( choice_datebase + "_id");
					String    book_name     =(String) map.get( "book_name");
					String    author        =(String) map.get( "author");
					String    publishing    =(String) map.get( "publishing");
					Date      release_date  =(Date) map.get( "release_date");
					int       book_price    =(Integer) map.get( "book_price");
					String    book_img      =(String) map.get( "book_img");
					int       book_total    =(Integer) map.get( "book_total");
					String    choice_name =(String) map.get( choice_datebase + "_name");
					int[] rent_array = checkrent(book_id,member_id,book_total);
					int rent_mark = rent_array[0];
					int rent_borrow_id = rent_array[1];
					String rentstate = rentState(rent_mark) ;			
%>
  <tr>
    <td width="17" valign="top"><p><%=book_id%>.</p></td>
    <td width="140" valign="top"><p><a href="confirm.html"><img border="0" width="140" height="190" src="<%=book_img%>" alt="bvcb" /></a></p></td>
    <td width="438" valign="top"><table border="0" cellspacing="0" cellpadding="0" width="100%">
      <tr>
        <td colspan="2"><h3><%=book_name%>
		<%  if(rent_mark > 0){ %>
		<font color="red">&nbsp;&nbsp&nbsp;&nbsp&nbsp;&nbsp<strong><%=rentstate%></strong></font>
		<% if(rent_mark == 1){%>
		<font color="red"><input id="cancel_reservebtn<%=i%>" type="button" value="取消預約" onclick="getreserve('<%=i%>','delete','<%=rent_borrow_id%>','<%=book_name%>','<%=book_id%>','<%=book_price%>','<%=member_id%>','<%=member_name%>','<%=member_email%>')"></font>	
		<%	}
		} else{ %>
		<font color="red">&nbsp;&nbsp&nbsp;&nbsp&nbsp;&nbsp<input id="reservebtn<%=i%>" type="button" value="預約" onclick="getreserve('<%=i%>','insert','0','<%=book_name%>','<%=book_id%>','<%=book_price%>','<%=member_id%>','<%=member_name%>','<%=member_email%>')"></font>
		<%}%>
		</h3>
              <p>出版社：<%=publishing%></p></td>
      </tr>
      <tr>
        <td colspan="2"><p>作者：<%=author%></p></td>
      </tr>
      <tr>
        <td colspan="2"><p>出版日期：<%=release_date%></p></td>
      </tr>
      <tr>
        <td colspan="2"><table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr>
            <td><p>類別：<%=choice_name%></p></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td colspan="2"><p>庫存：<%=book_total%></p></td>
      </tr>
      <tr>
        <td><p>租金: <span class="style3"><%=book_price%></span> NTD</p>
		</td>
		
      </tr>
    </table></td>
<%
	List whereList = new ArrayList();
					whereList.add(member_id);
					whereList.add(book_id);
	List borrowlist = db.SelectRSwhere("select * from borrow_record where member_id = ? and book_id = ? order by borrow_id desc limit 0,1 ",whereList);
	if ( borrowlist != null && borrowlist.size()>0 ) { 
			for ( int j = 0; j < borrowlist.size(); j++ ) {
				Map borrowmap = (Map) borrowlist.get(j); 	
			        	int borrow_id  		     =(Integer)borrowmap.get("borrow_id");
						Object reserve_date 	 = getReq((Date)borrowmap.get("reserve_date"));
						Object reserve_deadline  = getReq((Date)borrowmap.get("reserve_deadline"));
						Object borrow_date 	     = getReq((Date)borrowmap.get("borrow_date"));
						Object borrow_deadline   = getReq((Date)borrowmap.get("borrow_deadline"));
						Object return_date       = getReq((Date)borrowmap.get("return_date"));
						int fine 			   	 = (Integer)borrowmap.get("fine");
						int givefine 			 = (Integer)borrowmap.get("givefine");
						int realfine             =	getFine(givefine,fine,rent_mark,reserve_deadline,borrow_deadline);
%>	
	 <td width="514" valign="top"><table border="0" cellspacing="0" cellpadding="0" width="100%">
       <tr>
        <td><h3 style="color:blue;">最近租書紀錄</h3></td>
		<td><a href="detail.jsp?book_id=<%=book_id%>&book_name=<%=book_name%>" class="btn iframe"> <button class="ui-hidden">所有租書紀錄</button></a></td>
      </tr>
	  <tr>
        <td colspan="2"><p>預約日期：<%=reserve_date%></p></td>
      </tr>
      <tr>
        <td colspan="2"><p>預約到期日期：<%=reserve_deadline%></p></td>
      </tr>
      <tr>
        <td colspan="2"><p>借書日期：<%=borrow_date%></p></td>
      </tr>
      <tr>
        <td colspan="2"><table border="0" cellspacing="1" cellpadding="0" width="100%">
          <tr>
            <td><p>應歸還到期日：<%=borrow_deadline%></p></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td colspan="2"><p>歸還日期：<%=return_date%></p></td>
      </tr>
      <tr>
        <td><p>罰金: <span class="style3"><%=realfine%></span> NTD</p>
		
		</td>
		
      </tr>
    </table></td>
<%
			}
		}
%>			
  </tr>
  <tr>
    <td colspan="3"><p>&nbsp;</p></td>
  </tr>
  <tr>
    <td colspan="3"><p>&nbsp;</p></td>
  </tr>
 <%
				}
			}else{
%>
<h1 align="center">您尚無任何借書紀錄</h1>
<%}%>
</table>
</div>
</body>
</html>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="js/jquery.easing.1.3.js"></script>
<script src="js/jquery.backgroundPosition.js"></script>
<script src="js/cs.js"></script>
<script src="/js/modaal.js" type="text/javascript"></script>
<script>
$('.iframe').modaal({
		type: 'iframe',
		width: 1200,
		height: 500
});
function getreserve(i,sql_status,rent_borrow_id,book_name,book_id,book_price,member_id,member_name,member_email){
	var checkbook = null;
	if(sql_status == "insert"){
		checkbook =  confirm("確定租這本書:" + book_name + "?");
	}else if(sql_status == "delete"){
		checkbook =  confirm("確定取消這本書的預約:" + book_name + "?");
	}
	
	if( checkbook == true){
		if(sql_status == "insert"){
			$('#reservebtn' + i).attr('disabled', true);
		}else if(sql_status == "delete"){
			$('#cancel_reservebtn' + i).attr('disabled', true);
		}
		  $.ajax({
            url: "/controller/ReserveHandler.jsp",
            data: {
				sql_status: sql_status,
				rent_borrow_id: rent_borrow_id,
				book_id: book_id,
				book_name: book_name,
				book_price: book_price,
				member_id: member_id,
				member_name: member_name,
				member_email: member_email
			},
            type: "POST",
            dataType: "json",
            success: function(data,textStatus,jqXHR) {
            	console.log(data);
            	console.log(textStatus);
            	console.log(jqXHR);
            	if(data == 2){
					console.log('預約成功');
					if(sql_status == "insert"){
						alert('預約成功!請在預約到期日之前來店取書，謝謝。');
					}else if(sql_status == "delete"){
						alert('取消預約成功!歡迎您再次在本網站選書，謝謝。');
					}
				}else if(data == 5){
					alert('書都借光光了!下次請早，謝謝。');
				} else {
            		alert('系統錯誤，請通知網站管理員');
            	}
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
            	console.log('預約失敗');
            	console.log("XMLHttpRequest.status="+XMLHttpRequest.status+
			    		"\nXMLHttpRequest.readyState="+XMLHttpRequest.readyState+"\ntextStatus="+textStatus+"\errorThrown="+errorThrown);
            },
            complete: function(XMLHttpRequest) {
				if(sql_status == "insert"){
					$('#reservebtn' + i).attr('disabled', false);
				}else if(sql_status == "delete"){
					$('#cancel_reservebtn' + i).attr('disabled', false);
				}
				location.reload();
            	console.log('預約結果');
            	console.log(XMLHttpRequest);
            }
            
        	});
	}
}
</script>
<%} else{
	out.println ("<script language='javascript'> alert('會員請先登入，謝謝!'); location.href='login.jsp'; </script>");
}%>