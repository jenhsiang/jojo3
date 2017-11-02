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
	int n_id = 0,n_order = 0,result = 0;
	String n_title = "" ,updateSql = "",msg = "";
	List updateList = null;
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("n_id")) ){
			n_id = Integer.parseInt((String)request.getParameter("n_id"));
			List  whereList = new ArrayList();
	        whereList.add(n_id);
	        List getList = db.SelectRSwhere("select * from newslist where deleteflag = 0 and  n_id = ?    ",whereList);
	    	if(getList.size()>0){
		        for(int i=0;i<getList.size();i++){
		    		Map map = (Map) getList.get(i); 	
		    			n_title = (String)map.get( "n_title");
		    			n_order = (Integer)map.get( "n_order");
		    		}
	    		}
			updateList = new ArrayList();
			updateList.add(realtime);
			updateList.add(n_id);
			updateSql   = "update newslist set deleteflag = 1 ,n_order = 0 ,updatetime = ? where  n_id = ? ";
			result = db.InsertData(updateSql, updateList); 
		if(result == 1){
			List  orderList = new ArrayList();
			orderList.add(n_order);
	        List changeList = db.SelectRSwhere("select * from newslist where deleteflag = 0 and  n_order > ? order by n_order   ",orderList);
	        if(changeList.size()>0){
		        for(int i=0;i<changeList.size();i++){
		    		Map map = (Map) changeList.get(i); 	
		    			int change_id = (Integer)map.get("n_id");
		    			updateList = new ArrayList();
		    			updateList.add(n_order + i);
		    			updateList.add(change_id);
		    			updateSql   = "update newslist set n_order = ?  where  n_id = ? ";
		    			result = db.InsertData(updateSql, updateList); 
		    		}
	        }
		}
	}					
	switch(result) { 
    case 1: 
    	msg = "消息標題:『" + n_title +"』刪除成功" ;
        break; 
    default: 
    	msg = "消息標題:『" + n_title +"』刪除失敗" ;
	}
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>