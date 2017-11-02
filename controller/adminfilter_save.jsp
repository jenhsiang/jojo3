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
	int idx = 0,i_order = 0,check_data = 0,result = 0;
	String ipaddress ="",updateSql = "",msg = "",status="";
	List updateList = null;
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("ipaddress"))){
			ipaddress = (String)request.getParameter("ipaddress").trim();
				if(checkReq(request.getParameter("idx")) ){
					idx = Integer.parseInt((String)request.getParameter("idx"));
					List checkList = new ArrayList();
					checkList.add(ipaddress);
					checkList.add(idx);
		         	List repeatList = db.SelectRSwhere("select * from adminfilter where deleteflag = 0 and ipaddress = ? and idx != ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 2;
					}
				}else{
					List checkList = new ArrayList();
					checkList.add(ipaddress);
		         	List repeatList = db.SelectRSwhere("select * from adminfilter where deleteflag = 0 and ipaddress = ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 1;
						List orderList = db.SelectRS("select max(i_order) as maxorder from adminfilter where deleteflag = 0  ");
				     	if(orderList.size()>0){
				    		 for(int i=0;i<orderList.size();i++){
								Map map = (Map) orderList.get(i);
								if(map.get("maxorder") != null){
									i_order = (Integer)map.get("maxorder");
								}
							}
				     	}
					 	List deleteList = db.SelectRS("select min(idx) as minidx from adminfilter where deleteflag = 1  ");
				     	if(deleteList.size()>0){
				    		 for(int i=0;i<deleteList.size();i++){
								Map map = (Map) deleteList.get(i);
								if(map.get("minidx") != null){
									check_data = 3;
									idx = (Integer)map.get("minidx");
								}
							}
				     	}
					}
				}
					
	}
	switch(check_data) { 
    case 3: 
    	 updateList = new ArrayList();
		 updateList.add(ipaddress);
		 updateList.add(i_order + 1 );
		 updateList.add(realtime);
		 updateList.add(realtime);
		 updateList.add(idx);
		  updateSql   = "update adminfilter set ipaddress = ?  ,i_order = ? ";
		  updateSql  += " ,createtime = ?,updatetime = ? ,deleteflag = 0 where  idx = ? ";
		  result = db.InsertData(updateSql, updateList); 
		  status = "新增";
        break; 
    case 2: 
    	 updateList = new ArrayList();
		 updateList.add(ipaddress);
		 updateList.add(realtime);
		 updateList.add(idx);
		  updateSql   = "update adminfilter set ipaddress = ?   ,updatetime = ? where  idx = ?  ";
		  result = db.InsertData(updateSql, updateList);
		  status = "修改";
        break; 
    case 1: 
    	updateList = new ArrayList();
		 updateList.add(ipaddress);
		 updateList.add(i_order + 1);
		 updateList.add(realtime);
		 updateList.add(realtime);
		  updateSql   = " insert into adminfilter (ipaddress,i_order,createtime,updatetime,deleteflag) ";
		  updateSql  += " values(?,?,?,?,0) ";
		  result = db.InsertData(updateSql, updateList);
		  status = "新增";
        break;          
	}
	switch(result) { 
    case 2: 
    	msg = "IP位址:『" + ipaddress  +"』已存在，請重新輸入" ;
        break; 
    case 1: 
    	msg = "IP位址:『" + ipaddress +"』" +status +"成功" ;
        break; 
    default: 
    	msg = "IP位址:『" + ipaddress +"』" +status +"失敗" ; 
	}
		
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>