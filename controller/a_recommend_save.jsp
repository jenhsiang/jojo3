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
	int seqnum = -1,recommend_id = 0,result = 0;
	String recommend_name = "",updateSql = "",msg = "",returnMessage = "0";
	List updateList = null,checklist = null;
	Date realtime = new Date();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("recommend_name"))){
			recommend_name = (String)request.getParameter("recommend_name");
			if(checkReq(request.getParameter("recommend_id"))){
				recommend_id = Integer.parseInt((String)request.getParameter("recommend_id"));
			}	
			if(checkReq(request.getParameter("seqnum"))){
				seqnum = Integer.parseInt((String)request.getParameter("seqnum"));
			}	
			List nameList = new ArrayList();
				if(recommend_id == 0){
					nameList.add(recommend_name);
					checklist = db.SelectRSwhere("select * from recommend where recommend_name = ?  ",nameList);
				} else {
					nameList.add(recommend_name);
					nameList.add(recommend_id);
					checklist = db.SelectRSwhere("select * from recommend where recommend_name = ? and recommend_id != ? ",nameList);
				}
			
			if ( checklist != null && checklist.size()>0 ) { 
					returnMessage = "2";
					msg = "推薦名稱:『" + recommend_name +"』已存在，請重新輸入!!!" ;
			}else{
				updateList = new ArrayList();
				if(recommend_id == 0){
					updateSql   = " insert into recommend  (recommend_name , a_userid , createtime , updatetime) values ( ? , ? , ? , ? ) ";
					updateList.add(recommend_name);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(realtime);					
				}else {
					updateSql   = " update recommend set recommend_name = ? ,a_userid = ? ,updatetime = ?  where  recommend_id = ? ";
					updateList.add(recommend_name);
					updateList.add(a_userid);
					updateList.add(realtime);
					updateList.add(recommend_id);
				}
			
			  result = db.InsertData(updateSql, updateList);	
			  switch(result) {  
			    case 1: 
					if(recommend_id == 0){
						msg = "推薦名稱:『" + recommend_name +"』新增成功" ;
					}else{
						msg = "推薦名稱:『" + recommend_name +"』修改成功" ;
					}
					returnMessage = Integer.toString(result);
			        break; 
			    default: 
					if(recommend_id == 0){
						msg = "推薦名稱:『" + recommend_name +"』新增失敗" ;
					}else{
						msg = "推薦名稱:『" + recommend_name +"』修改失敗" ;
					}		
				}
			}			
	}
	
	
		
	out.print("{\"success\":" + returnMessage);
	out.print(",\"msg\":\""+msg+"\"");
	out.print(",\"recommend_id\":\""+recommend_id+"\"");
	out.print(",\"seqnum\":"+seqnum);
	out.print("}");
}
%>