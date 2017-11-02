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
		DbBean db = new DbBean();
	String returnMessage ="0";
	String  choose			= (String)request.getParameter("choose");
	int 	member_id 		= Integer.parseInt((String)request.getParameter("member_id"));
	String  member_account  = (String)request.getParameter("member_account");
	String  member_name     = (String)request.getParameter("member_name");
	String  password        = (String)request.getParameter("password");
	String  member_email    = (String)request.getParameter("member_email");
 	String  city            = (String)request.getParameter("city");
	String  town 			= (String)request.getParameter("town");
	String  address 		= (String)request.getParameter("address");
	String  telephone 		= (String)request.getParameter("telephone");
	Date 	realtime 		= new Date();
	List accountList = new ArrayList();
	if(choose.equals("update")){
		accountList.add(member_account);
		accountList.add(member_id);
	}else if(choose.equals("insert")){
		accountList.add(member_account);
	}
	List checklist = null;
	if(choose.equals("update")){
		checklist = db.SelectRSwhere("select * from member where member_account = ? and member_id != ? ",accountList);
	}else if(choose.equals("insert")){
		checklist = db.SelectRSwhere("select * from member where member_account=? ",accountList);
	}
		
	if ( checklist != null && checklist.size()>0 ) { 
		returnMessage = "4";
	}else{
		List insertList = new ArrayList();
		if(choose.equals("update")){
			insertList.add(member_account);
			insertList.add(member_name);
			insertList.add(password);
			insertList.add(member_email);
			insertList.add(city);
			insertList.add(town);
			insertList.add(address);
			insertList.add(telephone);
			insertList.add(realtime);
			insertList.add(member_id);
		}else if(choose.equals("insert")){
			insertList.add(member_account);
			insertList.add(member_name);
			insertList.add(password);
			insertList.add(member_email);
			insertList.add(city);
			insertList.add(town);
			insertList.add(address);
			insertList.add(telephone);
			insertList.add(realtime);
			insertList.add(realtime);
		}
		
		String insertSql  = "";
		if(choose.equals("update")){
			  insertSql += "update member set member_account = ?, member_name = ?, password = ?,member_email = ?,city = ?,town = ?,  ";
			  insertSql += "address = ?,telephone = ?,updatetime = ? where member_id = ?  ";
		}else if(choose.equals("insert")){
			 insertSql += "insert into member ( member_account,member_name, password, member_email,city,town,address,telephone,createtime,updatetime) ";
			 insertSql += " VALUES (?,?,?,?,?,?,?,?,?,?)";
		}
			  
		int result = db.InsertData(insertSql, insertList);
		if(result == 1){
			if(choose.equals("update")){
			 if ( session.getAttribute ("member_name") != null)  session.removeAttribute ("member_name");
			 if ( session.getAttribute ("member_email") != null)  session.removeAttribute ("member_email");
			 if ( session.getAttribute ("member_account") != null)  session.removeAttribute ("member_account");
		      session.setAttribute("member_name", member_name);
			  session.setAttribute("member_email", member_email);
			  session.setAttribute("member_account", member_account);
		}
			SendMailTLS mail = new SendMailTLS();
			
			List<String> mailcontect = new ArrayList<String>();
			mailcontect.add(member_name);
			mailcontect.add(member_account);
			mailcontect.add(password);
			mailcontect.add(member_email);
			mailcontect.add(city);
			mailcontect.add(town);
			mailcontect.add(address);
			mailcontect.add(telephone);
		boolean check = false;	
		if(choose.equals("update")){
			check =	mail.sendmail(member_email + ",ed01039639@gmail.com", "會員資料修改通知(" + member_name + ")", mailcontect,3);
		}else if(choose.equals("insert")){
			check =	mail.sendmail(member_email + ",ed01039639@gmail.com", "會員資料註冊通知(" + member_name + ")", mailcontect,4);
		}			
			if(check)
				returnMessage = "2";
			else
				returnMessage = "3";
			
		}else{
			returnMessage = "1";
		}
	}
	out.println(returnMessage);
%>
