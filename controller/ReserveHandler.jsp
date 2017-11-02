<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%@ page import="teachMail.SendMailTLS"%>
<%@ page import="org.joda.time.DateTime"%>
<%@ page import="org.joda.time.Period"%>
<%@ page import="org.joda.time.PeriodType"%>
<%!

	/** SQL 值中的單引號(')需要轉化為 \'  */
	public String forSQL(String sql){
		return sql.replace("'", "\\'");
	}
%>
<%
	request.setCharacterEncoding("UTF-8");
	DbBean db = new DbBean();
	String returnMessage ="0";
	int       book_total = 0;
	String sql_status 		= (String)request.getParameter("sql_status");
	int rent_borrow_id 		= Integer.parseInt((String)request.getParameter("rent_borrow_id"));
	int book_id 			= Integer.parseInt((String)request.getParameter("book_id"));
	String book_name 		= (String)request.getParameter("book_name");
	String book_price 		= (String)request.getParameter("book_price");
	int member_id 			= Integer.parseInt((String)request.getParameter("member_id"));
	String member_name 		= (String)request.getParameter("member_name");
	String member_email 	= (String)request.getParameter("member_email");
	DateTime realtime 		= new DateTime();
	DateTime deadlinetime   = realtime.plusDays(7);
			List bookidList = new ArrayList();
			bookidList.add(book_id);
			List checkbookList = db.SelectRSwhere(" select * from book  where book_id = ?  ",bookidList);
			if(checkbookList != null && checkbookList.size() > 0){
					for(int i=0;i<checkbookList.size();i++){
						Map map = (Map) checkbookList.get(i);
						book_total   	=(Integer) map.get( "book_total");
				}
			}
			if(book_total == 0 && sql_status.equals("insert")){
				returnMessage = "5";
			}

			if(!returnMessage.equals("5")){
					List insertList   = new ArrayList();
					String insertSql  = "";
					if(sql_status.equals("insert")){
						insertList.add(member_id);
						insertList.add(book_id);
						insertList.add(realtime.toString("yyyy-MM-dd"));
						insertList.add(deadlinetime.toString("yyyy-MM-dd"));
						insertSql  = "insert into borrow_record ( member_id,book_id, reserve_date, reserve_deadline) ";
						insertSql += "VALUES (?,?,?,?)";
					}else if(sql_status.equals("delete")){
						insertList.add(rent_borrow_id);
						insertSql  = "delete from borrow_record where borrow_id = ? ";
					}
					int result = db.InsertData(insertSql, insertList);
					if(result == 1){
						List minusList = new ArrayList();
						if(sql_status.equals("insert")){
							minusList.add(book_total - 1);
						}else if(sql_status.equals("delete")){
							minusList.add(book_total + 1);
						}							
						minusList.add(realtime.toString("yyyy-MM-dd"));
						minusList.add(book_id);
						String booktotalSql  = "update book set book_total = ?,updatetime = ? where book_id = ? ";
						int totalresult = db.InsertData(booktotalSql, minusList);
						if(totalresult == 1){
								SendMailTLS mail = new SendMailTLS();
								
								List<String> mailcontect = new ArrayList<String>();
								if(sql_status.equals("insert")){
									mailcontect.add(member_name);
									mailcontect.add(book_name);
									mailcontect.add(book_price);
									mailcontect.add(realtime.toString("yyyy-MM-dd"));
									mailcontect.add(deadlinetime.toString("yyyy-MM-dd"));
								}else if(sql_status.equals("delete")){
									mailcontect.add(member_name);
									mailcontect.add(book_name);
									mailcontect.add(realtime.toString("yyyy-MM-dd"));
								}
							boolean check = false;	
							if(sql_status.equals("insert")){
								check =	mail.sendmail( member_email + ",ed01039639@gmail.com", "天天學桌遊--租桌遊通知(" + member_name +")", mailcontect,2);
							}else if(sql_status.equals("delete")){
								check =	mail.sendmail( member_email + ",ed01039639@gmail.com", "天天學桌遊--取消預約通知(" + member_name +")", mailcontect,5);
							}								
								if(check)
									returnMessage = "2";
								else
									returnMessage = "3";
						}else{
							returnMessage = "4";
						}
					}else{
						returnMessage = "1";
					}
			}
	out.println(returnMessage);
%>
