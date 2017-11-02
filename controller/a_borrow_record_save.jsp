<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="teachDB.DbBean"%>
<%@ page import="teachMail.SendMailTLS"%>
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
%>
<%
	request.setCharacterEncoding("UTF-8");
if(session.getAttribute ("sesAdminID") != null && !session.getAttribute ("sesAdminID").equals ( "" )){
	String a_userid = (String)session.getAttribute ("sesAdminID");
	int seqnum = -1,borrow_id = 0,book_id = 0,real_fine = 0,book_total = 0,result = 0;
	String new_action = "",book_name = "",member_account = "",member_name = "",member_email = "",updateSql = "",msg = "",msg_act = "",returnMessage = "0";
	List updateList = null;
	DateTime realtime       = new DateTime();
	DateTime deadlinetime   = realtime.plusDays(7);
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("borrow_id")) && checkReq(request.getParameter("new_action"))
		 && checkReq(request.getParameter("book_name")) && checkReq(request.getParameter("book_id")) 
		 && checkReq(request.getParameter("member_name")) && checkReq(request.getParameter("member_email"))
		  && checkReq(request.getParameter("member_account")) && checkReq(request.getParameter("real_fine"))){
			borrow_id 	   = Integer.parseInt((String)request.getParameter("borrow_id"));
			book_id 	   = Integer.parseInt((String)request.getParameter("book_id"));
			real_fine 	   = Integer.parseInt((String)request.getParameter("real_fine"));
			new_action 	   = (String)request.getParameter("new_action");
			book_name 	   = (String)request.getParameter("book_name");
			member_name    = (String)request.getParameter("member_name");
			member_email   = (String)request.getParameter("member_email");
			member_account = (String)request.getParameter("member_account");
			if(checkReq(request.getParameter("seqnum"))){
				seqnum = Integer.parseInt((String)request.getParameter("seqnum"));
			}	
			
			List bookidList = new ArrayList();
			bookidList.add(book_id);
			List checkbookList = db.SelectRSwhere(" select * from book  where book_id = ?  ",bookidList);
			if(checkbookList != null && checkbookList.size() > 0){
					for(int i=0;i<checkbookList.size();i++){
						Map map = (Map) checkbookList.get(i);
						book_total   	=(Integer) map.get( "book_total");
				}
			}
			
				updateList = new ArrayList();
				if(new_action.equals("getbook")){
					updateSql   = " update borrow_record set borrow_date = ? ,borrow_deadline = ? ,a_userid = ? where  borrow_id = ?  ";
				
					updateList.add(realtime.toString("yyyy-MM-dd"));
					updateList.add(deadlinetime.toString("yyyy-MM-dd"));
					updateList.add(a_userid);
					updateList.add(borrow_id);
					msg_act = "取桌遊";
				}else if(new_action.equals("returnbook")) {
					updateSql   = " update borrow_record set return_date = ?  ,a_userid = ? where  borrow_id = ?  ";
				
					updateList.add(realtime.toString("yyyy-MM-dd"));
					updateList.add(a_userid);
					updateList.add(borrow_id);
					msg_act = "還桌遊";
				}else if(new_action.equals("paybook") && real_fine > 0) {
					updateSql   = " update borrow_record set return_date = ?  ,fine = ?  ,givefine = ?  ,a_userid = ? where  borrow_id = ?  ";
				
					updateList.add(realtime.toString("yyyy-MM-dd"));
					updateList.add(real_fine);
					updateList.add(1);
					updateList.add(a_userid);
					updateList.add(borrow_id);
					msg_act = "付罰金";
				}
			result = db.InsertData(updateSql, updateList);
			if(result == 1 && (new_action.equals("returnbook") || new_action.equals("paybook"))){
				List minusList = new ArrayList();
						minusList.add(book_total + 1);							
						minusList.add(realtime.toString("yyyy-MM-dd"));
						minusList.add(book_id);
						String booktotalSql  = "update book set book_total = ?,updatetime = ? where book_id = ? ";
				result = db.InsertData(booktotalSql, minusList);
			}
			 
			  returnMessage = Integer.toString(result);
			  if(result == 1) {  
						SendMailTLS mail = new SendMailTLS();
								
								List<String> mailcontect = new ArrayList<String>();
								if(new_action.equals("getbook")){
									mailcontect.add(member_name);
									mailcontect.add(book_name);
									mailcontect.add(realtime.toString("yyyy-MM-dd"));
									mailcontect.add(deadlinetime.toString("yyyy-MM-dd"));
								}else if(new_action.equals("returnbook")){
									mailcontect.add(member_name);
									mailcontect.add(book_name);
									mailcontect.add(realtime.toString("yyyy-MM-dd"));
								}else if(new_action.equals("paybook")){
									mailcontect.add(member_name);
									mailcontect.add(book_name);
									mailcontect.add(Integer.toString(real_fine));
									mailcontect.add(realtime.toString("yyyy-MM-dd"));
								}
								
							boolean check = false;	
							if(new_action.equals("getbook")){
								check =	mail.sendmail( member_email + ",ed01039639@gmail.com", "天天學桌遊--取桌遊通知(" + member_name +")", mailcontect,6);
							}else if(new_action.equals("returnbook")){
								check =	mail.sendmail( member_email + ",ed01039639@gmail.com", "天天學桌遊--還桌遊通知(" + member_name +")", mailcontect,7);
							}else if(new_action.equals("paybook")){
								check =	mail.sendmail( member_email + ",ed01039639@gmail.com", "天天學桌遊--已付罰金通知(" + member_name +")", mailcontect,8);
							}
							
							if(check)
									returnMessage = "2";
								else
									returnMessage = "3";		
				}
				msg = "會員帳號:『" + member_account +"』,桌遊名稱:『" + book_name +"』";
				if(returnMessage.equals("2")){
					msg +=  msg_act +"成功" ;
				}else{
					msg +=  msg_act +"失敗" ;
				}
			
	}
	
	out.print("{\"success\":\"" + returnMessage +"\"");
	out.print(",\"msg\":\""+msg+"\"");
	out.print(",\"borrow_id\":\""+borrow_id+"\"");
	out.print(",\"seqnum\":"+seqnum);
	out.print("}");
}
%>