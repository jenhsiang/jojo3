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
	int seqnum = -1,category_id = 0,result = 0;
	String category_name = "",updateSql = "",msg = "",returnMessage = "0";
	List updateList = null,checklist = null;
	Date realtime = new Date();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("category_name"))){
			category_name = (String)request.getParameter("category_name");
			if(checkReq(request.getParameter("category_id"))){
				category_id = Integer.parseInt((String)request.getParameter("category_id"));
			}	
			if(checkReq(request.getParameter("seqnum"))){
				seqnum = Integer.parseInt((String)request.getParameter("seqnum"));
			}	
			List nameList = new ArrayList();
				if(category_id == 0){
					nameList.add(category_name);
					checklist = db.SelectRSwhere("select * from category where category_name = ?  ",nameList);
				} else {
					nameList.add(category_name);
					nameList.add(category_id);
					checklist = db.SelectRSwhere("select * from category where category_name = ? and category_id != ? ",nameList);
				}
			
			if ( checklist != null && checklist.size()>0 ) { 
					returnMessage = "2";
					msg = "類別名稱:『" + category_name +"』已存在，請重新輸入!!!" ;
			}else{
				updateList = new ArrayList();
				if(category_id == 0){
					updateSql   = " insert into category  (category_name , a_userid , createtime , updatetime) values ( ? , ? , ? , ? ) ";
					updateList.add(category_name);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(realtime);					
				}else {
					updateSql   = " update category set category_name = ? ,a_userid = ? ,updatetime = ?  where  category_id = ? ";
					updateList.add(category_name);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(category_id);
				}
			
			  result = db.InsertData(updateSql, updateList);	
			  switch(result) {  
			    case 1: 
					if(category_id == 0){
						msg = "類別名稱:『" + category_name +"』新增成功" ;
					}else{
						msg = "類別名稱:『" + category_name +"』修改成功" ;
					}
					returnMessage = Integer.toString(result);
			        break; 
			    default: 
					if(category_id == 0){
						msg = "類別名稱:『" + category_name +"』新增失敗" ;
					}else{
						msg = "類別名稱:『" + category_name +"』修改失敗" ;
					}		
				}
			}			
	}
	
	
		
	out.print("{\"success\":" + returnMessage);
	out.print(",\"msg\":\""+msg+"\"");
	out.print(",\"category_id\":\""+category_id+"\"");
	out.print(",\"seqnum\":"+seqnum);
	out.print("}");
}
%>