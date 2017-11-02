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
	int a_idx = 0,admin = 0,check_data = 0,result = 0;
	String a_userid ="",a_username = "",a_passwd = "",a_userphone = "",a_email = "",updateSql = "",msg = "",status="";
	List updateList = null;
	Date updateNow = new Date();
	Calendar Cal= Calendar.getInstance();   
	Cal.setTime(updateNow);   
	Cal.add(Calendar.HOUR_OF_DAY,8);   
	Date realtime = Cal.getTime();
	DbBean db = new DbBean();
	if(checkReq(request.getParameter("a_userid")) && checkReq(request.getParameter("a_username"))  
		&& checkReq(request.getParameter("a_passwd")) && checkReq(request.getParameter("a_userphone"))
		&& checkReq(request.getParameter("a_email"))  && checkReq(request.getParameter("admin")) ){
			a_userid = (String)request.getParameter("a_userid");
			a_username = (String)request.getParameter("a_username");
			a_passwd = (String)request.getParameter("a_passwd");
			a_userphone = (String)request.getParameter("a_userphone");
			a_email = (String)request.getParameter("a_email");
			admin = Integer.parseInt((String)request.getParameter("admin"));
				if(checkReq(request.getParameter("a_idx")) ){
					a_idx = Integer.parseInt((String)request.getParameter("a_idx"));
					List checkList = new ArrayList();
					checkList.add(a_userid);
					checkList.add(a_idx);
		         	List repeatList = db.SelectRSwhere("select * from adminuser where deleteflag = 0 and a_userid = ? and a_idx != ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 2;
					}
				}else{
					List checkList = new ArrayList();
					checkList.add(a_userid);
		         	List repeatList = db.SelectRSwhere("select * from adminuser where deleteflag = 0 and a_userid = ?  ",checkList);
					if(repeatList.size() > 0){
						result = 2;
					}else{
						check_data = 1;
					 	List deleteList = db.SelectRS("select min(a_idx) as minidx from adminuser where deleteflag = 1  ");
				     	if(deleteList.size()>0){
				    		 for(int i=0;i<deleteList.size();i++){
								Map map = (Map) deleteList.get(i);
								if(map.get("minidx") != null){
									check_data = 3;
									a_idx = (Integer)map.get("minidx");
								}
							}
				     	}
					}
				}
					
	}
	switch(check_data) { 
    case 3: 
    	 updateList = new ArrayList();
		 updateList.add(a_userid);
		 updateList.add(a_username);
		 updateList.add(a_passwd);
		 updateList.add(a_userphone);
		 updateList.add(a_email);
		 updateList.add(admin);
		 updateList.add(realtime);
		 updateList.add(realtime);
		 updateList.add(a_idx);
		  updateSql   = "update adminuser set a_userid = ? ,a_username = ? , a_passwd = ? ,a_userphone = ? ";
		  updateSql  += "   ,a_email = ? , admin = ? ,createtime = ?,updatetime = ? ,deleteflag = 0 where  a_idx = ? ";
		  result = db.InsertData(updateSql, updateList); 
		  status = "新增";
        break; 
    case 2: 
    	 updateList = new ArrayList();
		 updateList.add(a_userid);
		 updateList.add(a_username);
		 updateList.add(a_passwd);
		 updateList.add(a_userphone);
		 updateList.add(a_email);
		 updateList.add(admin);
		 updateList.add(realtime);
		 updateList.add(a_idx);
		  updateSql   = "update adminuser set a_userid = ? ,a_username = ? , a_passwd = ? ,a_userphone = ? ";
		  updateSql  += "   ,a_email = ? , admin = ? ,updatetime = ? where  a_idx = ? ";
		  result = db.InsertData(updateSql, updateList);
		  status = "修改";
        break; 
    case 1: 
    	updateList = new ArrayList();
		 updateList.add(a_userid);
		 updateList.add(a_username);
		 updateList.add(a_passwd);
		 updateList.add(a_userphone);
		 updateList.add(a_email);
		 updateList.add(admin);
		 updateList.add(realtime);
		 updateList.add(realtime);
		  updateSql   = " insert into adminuser (a_userid,a_username,a_passwd,a_userphone,a_email,admin,createtime,updatetime,deleteflag) ";
		  updateSql  += " values(?,?,?,?,?,?,?,?,0) ";
		  result = db.InsertData(updateSql, updateList);
		  status = "新增";
        break;          
	}
	switch(result) { 
    case 2: 
    	msg = "帳號" + a_userid  +"已存在，請重新輸入" ;
        break; 
    case 1: 
    	msg = "帳號" + a_userid + status +"成功" ;
        break; 
    default: 
    	msg = "帳號" + a_userid + status +"失敗" ; 
	}
		
	out.print("{\"success\":"+result);
	out.print(",\"msg\":\""+msg+"\"");
	out.print("}");
%>