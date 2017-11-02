<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	int a_idx = 0,result = 0;
	String a_userid = "" ,updateSql = "",msg = "";
	List updateList = null;
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("a_idx")) ){
			a_idx = Integer.parseInt((String)request.getParameter("a_idx"));
			List  whereList = new ArrayList();
	        whereList.add(a_idx);
	        List getList = db.SelectRSwhere("select * from adminuser where deleteflag = 0 and  a_idx = ?    ",whereList);
	        if(getList.size()>0){
		        for(int i=0;i<getList.size();i++){
		    		Map map = (Map) getList.get(i); 	
		    				a_userid = (String)map.get( "a_userid");
		    		}
	        }
			updateList = new ArrayList();
			updateList.add(realtime);
			updateList.add(a_idx);
			updateSql   = "update adminuser set deleteflag = 1 ,updatetime = ? where  a_idx = ? ";
			result = db.InsertData(updateSql, updateList); 
	}					
	switch(result) { 
    case 1: 
    	msg = "帳號" + a_userid +"刪除成功" ;
        break; 
    default: 
    	msg = "帳號" + a_userid +"刪除失敗" ;
	}
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>