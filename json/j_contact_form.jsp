<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%
pattern pp = new pattern();
//System.out.println(pp.replaceBlank(test));
int start = 0;
		try {
		    start = Integer.parseInt(request.getParameter("start"));
		} catch(Exception ex) {
		    System.err.println(ex);
		}
		int limit = 20;
		try {
		    limit = Integer.parseInt(request.getParameter("limit"));
		} catch(Exception ex) {
		    System.err.println(ex);
		}
String sort = "createtime";
String dir = "asc";
String select_status = "";
String select_data = "";
String date_s = "";
String date_e = "";
List total = null;
List ll = null;
List whereList = null;
int check_where = 0;
if(request.getParameter("sort") != null) sort = request.getParameter("sort");
if(request.getParameter("dir") != null) dir = request.getParameter("dir");
if(request.getParameter("select_status") != null) select_status = request.getParameter("select_status");
if(request.getParameter("select_data") != null) select_data = request.getParameter("select_data");
if(request.getParameter("date_s") != null) date_s = request.getParameter("date_s");
if(request.getParameter("date_e") != null) date_e = request.getParameter("date_e");
 //out.println(sort);
 //if(true) return;
		DbBean db = new DbBean();
		if(!select_status.equals("")){
			
		 if(select_status.equals("createtime") ){
           	 if (date_s.equals("") && date_e.equals("")) { 
           		 check_where = 0;
                } else if (date_s.equals("")) { 
                	check_where = 2;
               	 	whereList = new ArrayList();
                	whereList.add(date_e);   	
                } else if (date_e.equals("")) {
                	check_where = 3;
               	 	whereList = new ArrayList();
                	whereList.add(date_s); 	
                } else {
                	check_where = 4;
               	 	whereList = new ArrayList();
                	whereList.add(date_s);
                	whereList.add(date_e);  	
                }
			}else if(select_status.equals("usermessage")){
				check_where = 5; 
        		whereList = new ArrayList();
        		whereList.add("%"+select_data+"%");
			}else{
				if (!select_data.equals("")) {
                	check_where = 1; 
                	whereList = new ArrayList();
                	whereList.add(select_data);
                }
			}

		}	
		switch(check_where) { 
        case 0: 
        	total = db.SelectRS("select * from contact_form  order by createtime ");
		 	 ll = db.SelectRS("select * from contact_form  "+" order by  "+sort+" "+dir+"   limit "+start+","+limit);
            break; 
        case 1: 
        	total = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" = ? order by createtime ",whereList);
		 	 ll = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" = ? order by  "+sort+" "+dir+"   limit "+start+","+limit,whereList);
            break; 
        case 2: 
        	total = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" < ? order by createtime ",whereList);
		 	 ll = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" < ? order by  "+sort+" "+dir+"   limit "+start+","+limit,whereList);
            break; 
        case 3: 
        	total = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" > ? order by createtime ",whereList);
		 	 ll = db.SelectRSwhere("select * from contact_form  where  "+ select_status +" > ? order by  "+sort+" "+dir+"   limit "+start+","+limit,whereList);
            break;
        case 4: 
        	total = db.SelectRSwhere("select * from contact_form where   "+ select_status +" between ? and ? order by createtime ",whereList);
		 	ll = db.SelectRSwhere("select * from contact_form where   "+ select_status +"  between ? and ?  order by  "+sort+" "+dir+"   limit "+start+","+limit,whereList);
            break;
        case 5: 
       	 	total = db.SelectRSwhere("select * from contact_form where   "+ select_status +" like ? order by n_order ",whereList);
		 	 ll = db.SelectRSwhere("select * from contact_form where   "+ select_status +" like ? order by  "+sort+" "+dir+"   limit "+start+","+limit,whereList); 
	        break;	
   		 }
	
			out.println("{totalCount:"+total.size()+",result:[");
		for(int i=0;i<ll.size();i++){
				out.println("{");
			Map map = (Map) ll.get(i); 
				out.println("id:"+pp.replaceBlank(map.get( "id"))+",");
				out.println("identity:'"+pp.replaceBlank(map.get( "identity"))+"',");
				out.println("username:'"+pp.replaceBlank(map.get( "username"))+"',");
				out.println("useremail:'"+pp.replaceBlank(map.get( "useremail"))+"',");
				out.println("userphone:'"+pp.replaceBlank(map.get( "userphone"))+"',");
				out.println("usermessage:'"+pp.replaceBlank(map.get( "usermessage"))+"',");
				out.println("createtime:'"+pp.replaceBlank(map.get( "createtime"))+"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
%>