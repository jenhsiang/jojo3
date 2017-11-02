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
	int n_id = 0,n_order = 0,check_data = 0,result = 0;
	String n_date ="",n_title = "",n_content = "",updateSql = "",msg = "",status="";
	List updateList = null;
	Date updateNow = new Date(),publishDate = null;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("n_date")) && checkReq(request.getParameter("n_title"))  
		&& checkReq(request.getParameter("n_content")) ){
			n_date = (String)request.getParameter("n_date");
			n_title = (String)request.getParameter("n_title");
			n_content = (String)request.getParameter("n_content");
			try {
				publishDate = sdf.parse(n_date);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				if(checkReq(request.getParameter("n_id")) ){
					n_id = Integer.parseInt((String)request.getParameter("n_id"));
					List checkList = new ArrayList();
					checkList.add(n_title);
					checkList.add(n_id);
		         	List repeatList = db.SelectRSwhere("select * from newslist where deleteflag = 0 and n_title = ? and n_id != ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 2;
					}
				}else{
					List checkList = new ArrayList();
					checkList.add(n_title);
		         	List repeatList = db.SelectRSwhere("select * from newslist where deleteflag = 0 and n_title = ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 1;
						List orderList = db.SelectRS("select max(n_order) as maxorder from newslist where deleteflag = 0  ");
				     	if(orderList.size()>0){
				    		 for(int i=0;i<orderList.size();i++){
								Map map = (Map) orderList.get(i);
								if(map.get("maxorder") != null){
									n_order = (Integer)map.get("maxorder");
								}
							}
				     	}
					 	List deleteList = db.SelectRS("select min(n_id) as minidx from newslist where deleteflag = 1  ");
				     	if(deleteList.size()>0){
				    		 for(int i=0;i<deleteList.size();i++){
								Map map = (Map) deleteList.get(i);
								if(map.get("minidx") != null){
									check_data = 3;
									n_id = (Integer)map.get("minidx");
								}
							}
				     	}
					}
				}
					
	}
	switch(check_data) { 
    case 3: 
    	 updateList = new ArrayList();
		 updateList.add(n_title);
		 updateList.add(n_content);
		 updateList.add(publishDate);
		 updateList.add(n_order + 1 );
		 updateList.add(realtime);
		 updateList.add(realtime);
		 updateList.add(n_id);
		  updateSql   = "update newslist set n_title = ? ,n_content = ? , n_date = ? ,n_order = ? ";
		  updateSql  += " ,createtime = ?,updatetime = ? ,deleteflag = 0 where  n_id = ? ";
		  result = db.InsertData(updateSql, updateList); 
		  status = "新增";
        break; 
    case 2: 
    	 updateList = new ArrayList();
		 updateList.add(n_title);
		 updateList.add(n_content);
		 updateList.add(publishDate);
		 updateList.add(realtime);
		 updateList.add(n_id);
		  updateSql   = "update newslist set n_title = ? ,n_content = ? , n_date = ?  ";
		  updateSql  += "  ,updatetime = ? where  n_id = ? ";
		  result = db.InsertData(updateSql, updateList);
		  status = "修改";
        break; 
    case 1: 
    	updateList = new ArrayList();
		 updateList.add(n_title);
		 updateList.add(n_content);
		 updateList.add(publishDate);
		 updateList.add(n_order + 1);
		 updateList.add(realtime);
		 updateList.add(realtime);
		  updateSql   = " insert into newslist (n_title,n_content,n_date,n_order,createtime,updatetime,deleteflag) ";
		  updateSql  += " values(?,?,?,?,?,?,0) ";
		  result = db.InsertData(updateSql, updateList);
		  status = "新增";
        break;          
	}
	switch(result) { 
    case 2: 
    	msg = "消息標題:『" + n_title  +"』已存在，請重新輸入" ;
        break; 
    case 1: 
    	msg = "消息標題:『" + n_title +"』" +status +"成功" ;
        break; 
    default: 
    	msg = "消息標題:『" + n_title +"』" +status +"失敗" ; 
	}
		
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>