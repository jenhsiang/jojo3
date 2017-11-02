<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="org.joda.time.DateTime"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="teachDB.DbBean"%>
<%!
		public boolean checkReq(Object obj){
			boolean check = false ;
			if(obj != null && !((String)obj).equals("")){
				check = true;
			}
			return check;
		}
%>
<%
	request.setCharacterEncoding("UTF-8");
if(session.getAttribute ("sesAdminID") != null && !session.getAttribute ("sesAdminID").equals ( "" )){
	String a_userid = (String)session.getAttribute ("sesAdminID");
	int seqnum = -1,book_id = 0,category_id = 0,recommend_id = 0,book_price = 0,book_total = 0,result = 0;
	String book_name = "",book_img = "",author = "",publishing = "",release_date = "",updateSql = "",msg = "",returnMessage = "0";
	List updateList = null,checklist = null;
	Date realtime = new Date(),pub_release_date = null;
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("book_name")) && checkReq(request.getParameter("book_img"))
	   && checkReq(request.getParameter("author")) && checkReq(request.getParameter("publishing"))
	   && checkReq(request.getParameter("release_date")) && checkReq(request.getParameter("category_name"))
	   && checkReq(request.getParameter("recommend_name")) && checkReq(request.getParameter("book_price"))
	   && checkReq(request.getParameter("book_total"))){
			book_name 		 = (String)request.getParameter("book_name");
			book_img 		 = (String)request.getParameter("book_img");
			author 			 = (String)request.getParameter("author");
			publishing 		 = (String)request.getParameter("publishing");
			release_date 	 = (String)request.getParameter("release_date").replace("/","-");
			category_id 	 = Integer.parseInt((String)request.getParameter("category_name"));
			recommend_id 	 = Integer.parseInt((String)request.getParameter("recommend_name"));
			book_price 		 = Integer.parseInt((String)request.getParameter("book_price"));
			book_total 		 = Integer.parseInt((String)request.getParameter("book_total"));
			pub_release_date = new DateTime(release_date).toDate();
			if(checkReq(request.getParameter("book_id"))){
				book_id = Integer.parseInt((String)request.getParameter("book_id"));
			}	
			if(checkReq(request.getParameter("seqnum"))){
				seqnum = Integer.parseInt((String)request.getParameter("seqnum"));
			}	
			List nameList = new ArrayList();
				if(book_id == 0){
					nameList.add(book_name);
					checklist = db.SelectRSwhere("select * from book where book_name = ?  ",nameList);
				} else {
					nameList.add(book_name);
					nameList.add(book_id);
					checklist = db.SelectRSwhere("select * from book where book_name = ? and book_id != ? ",nameList);
				}
			
			if ( checklist != null && checklist.size()>0 ) { 
					returnMessage = "2";
					msg = "桌遊名稱:『" + book_name +"』已存在，請重新輸入!!!" ;
			}else{
				updateList = new ArrayList();
				if(book_id == 0){
					updateSql   = " insert into book  (category_id , recommend_id , book_name , author, publishing, release_date, book_price, book_img, book_total,  ";
					updateSql  += "  a_userid , createtime , updatetime) values ( ? , ? , ? , ?, ?, ?, ?, ?, ?, ?, ?, ? ) ";
					updateList.add(category_id);
					updateList.add(recommend_id);
					updateList.add(book_name);
					updateList.add(author);
					updateList.add(publishing);
					updateList.add(pub_release_date);
					updateList.add(book_price);
					updateList.add(book_img);
					updateList.add(book_total);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(realtime);					
				}else {
					updateSql   = " update book set category_id = ? ,recommend_id = ? ,book_name = ? ,author = ?,publishing = ?,release_date = ? ";
					updateSql  += ",book_price = ?,book_img = ? ,book_total = ?, a_userid = ? ,updatetime = ?  where  book_id = ? ";
					updateList.add(category_id);
					updateList.add(recommend_id);
					updateList.add(book_name);
					updateList.add(author);
					updateList.add(publishing);
					updateList.add(pub_release_date);
					updateList.add(book_price);
					updateList.add(book_img);
					updateList.add(book_total);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(book_id);
				}
			
			  result = db.InsertData(updateSql, updateList);	
			  switch(result) {  
			    case 1: 
					if(book_id == 0){
						msg = "桌遊名稱:『" + book_name +"』新增成功" ;
					}else{
						msg = "桌遊名稱:『" + book_name +"』修改成功" ;
					}
					returnMessage = Integer.toString(result);
			        break; 
			    default: 
					if(book_id == 0){
						msg = "桌遊名稱:『" + book_name +"』新增失敗" ;
					}else{
						msg = "桌遊名稱:『" + book_name +"』修改失敗" ;
					}		
				}
			}			
	}
	
	
		
	out.print("{\"success\":" + returnMessage);
	out.print(",\"msg\":\""+msg+"\"");
	out.print(",\"book_id\":\""+book_id+"\"");
	out.print(",\"seqnum\":"+seqnum);
	out.print("}");
}
%>