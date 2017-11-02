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
	int idx = 0,i_order = 0,result = 0;
	String ipaddress = "" ,updateSql = "",msg = "";
	List updateList = null;
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("idx")) ){
			idx = Integer.parseInt((String)request.getParameter("idx"));
			List  whereList = new ArrayList();
	        whereList.add(idx);
	        List getList = db.SelectRSwhere("select * from adminfilter where deleteflag = 0 and  idx = ?    ",whereList);
	    	if(getList.size()>0){
		        for(int i=0;i<getList.size();i++){
		    		Map map = (Map) getList.get(i); 	
		    			ipaddress = (String)map.get( "ipaddress");
		    			i_order = (Integer)map.get( "i_order");
		    		}
	    		}
			updateList = new ArrayList();
			updateList.add(realtime);
			updateList.add(idx);
			updateSql   = "update adminfilter set deleteflag = 1 ,i_order = 0 ,updatetime = ? where  idx = ? ";
			result = db.InsertData(updateSql, updateList); 
		if(result == 1){
			List  orderList = new ArrayList();
			orderList.add(i_order);
	        List changeList = db.SelectRSwhere("select * from adminfilter where deleteflag = 0 and  i_order > ? order by i_order   ",orderList);
	        if(changeList.size()>0){
		        for(int i=0;i<changeList.size();i++){
		    		Map map = (Map) changeList.get(i); 	
		    			int change_id = (Integer)map.get("idx");
		    			updateList = new ArrayList();
		    			updateList.add(i_order + i);
		    			updateList.add(change_id);
		    			updateSql   = "update adminfilter set i_order = ?  where  idx = ? ";
		    			result = db.InsertData(updateSql, updateList); 
		    		}
	        }
		}
	}					
	switch(result) { 
    case 1: 
    	msg = "消息標題:『" + ipaddress +"』刪除成功" ;
        break; 
    default: 
    	msg = "消息標題:『" + ipaddress +"』刪除失敗" ;
	}
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>