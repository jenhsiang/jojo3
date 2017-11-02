<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%
	request.setCharacterEncoding("UTF-8");
	int pagesize = 0,currentpage = 0;
	String orderarr ="";
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	if(request.getParameter("pagesize") != null && request.getParameter("currentpage") != null 
		&& request.getParameter("orderarr") != null  ){
		 pagesize = Integer.parseInt((String)request.getParameter("pagesize"));
		 currentpage = Integer.parseInt((String)request.getParameter("currentpage"));
		 orderarr = (String)request.getParameter("orderarr");
		 orderarr = orderarr.substring(1,orderarr.length()-1);
	}
	DbBean db = new DbBean();
	int checkorder = 1;
	String[] order_Array =orderarr.split(",");
	if(!orderarr.equals("")){
		int start = 1 + ((currentpage-1)*pagesize); 
		int end = order_Array.length + ((currentpage-1)*pagesize); 
		for(int i = start;i<=end;i++){
			 List neworderList = new ArrayList();
			 neworderList.add(i);
			 neworderList.add(Integer.parseInt(order_Array[i-start]));
			 String neworderSql  = "update adminfilter  set i_order = ?   where  idx = ? ";
			 int result = db.InsertData(neworderSql, neworderList);
			 if(result !=1 ) checkorder = 0;	
		}
	}
	out.print("{\"success\":"+checkorder);
	out.print("}");
%>