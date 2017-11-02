<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%@ page import="teachMail.SendMailTLS"%>
<%!

	/** SQL 值中的單引號(')需要轉化為 \'  */
	public String forSQL(String sql){
		return sql.replace("'", "\\'");
	}
%>
<%
	request.setCharacterEncoding("UTF-8");
	String returnMessage ="0";
	String identity = request.getParameter("identity");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String phone = request.getParameter("phone");
	String message = request.getParameter("message");
		Date realtime = new Date();
		List insertList = new ArrayList();
		insertList.add(identity);
		insertList.add(name);
		insertList.add(email);
		insertList.add(phone);
		insertList.add(message);
		insertList.add(realtime);
	
		String insertSql  = "insert into contact_form ( identity,username, useremail, userphone,usermessage,createtime) ";
			   insertSql += "VALUES (?,?,?,?,?,?)";
		DbBean db = new DbBean();
		int result = db.InsertData(insertSql, insertList);
		if(result == 1){
			SendMailTLS mail = new SendMailTLS();
			
			List<String> mailcontect = new ArrayList<String>();
			mailcontect.add(identity);
			mailcontect.add(name);
			mailcontect.add(email);
			mailcontect.add(phone);
			mailcontect.add(message);
			
		boolean check =	mail.sendmail("ed01039639@gmail.com", "天天學桌遊--聯絡我們", mailcontect,1);
			if(check)
				returnMessage = "2";
			else
				returnMessage = "3";
			
		}else{
			returnMessage = "1";
		}
	out.println(returnMessage);
%>
