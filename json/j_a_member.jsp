<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%@ page import="org.joda.time.DateTime"%>
<%@ page import="org.joda.time.Period"%>
<%@ page import="org.joda.time.PeriodType"%>
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

String sort = " member_id ";
String dir = "asc";
String select_status = "";
String select_data = "";
String date_s = "";
String date_e = "";
String check_city = "";
String check_town = "";
if(request.getParameter("sort") != null) sort = (String)request.getParameter("sort");
if(request.getParameter("dir") != null) dir = (String)request.getParameter("dir");
if(request.getParameter("select_status") != null) select_status = (String)request.getParameter("select_status");
if(request.getParameter("select_data") != null) select_data = (String)request.getParameter("select_data");
if(request.getParameter("date_s") != null) date_s = (String)request.getParameter("date_s");
if(request.getParameter("date_e") != null) date_e = (String)request.getParameter("date_e");
if(request.getParameter("check_city") != null) check_city = (String)request.getParameter("check_city");
if(request.getParameter("check_town") != null) check_town = (String)request.getParameter("check_town");


		DbBean db = new DbBean();
		List whereList = new ArrayList(); 
		int check_where = 0;
		String total_sql   = "  select * from member   ";
		String detail_sql  = "  select * from member   ";
		if(!select_status.equals("")){	
		 if(select_status.equals("createtime") || select_status.equals("updatetime") ){
           	 if (date_s.equals("") && date_e.equals("")) { 
           		 check_where  = 0;
                } else if (date_s.equals("")) { 
                	check_where = 2;
                	whereList.add(date_e);   	
                } else if (date_e.equals("")) {
                	check_where = 3;
                	whereList.add(date_s); 	
                } else {
                	check_where = 4;
                	whereList.add(date_s);
                	whereList.add(date_e);  	
                }
			} else if(select_status.equals("city")){
				if (!check_city.equals("")) {
					check_where = 1;
                	whereList.add(check_city);
				}
			} else if(select_status.equals("town")){
				if (!check_town.equals("")) {
					check_where = 1;
					whereList.add(check_town);
				}else if(!check_city.equals("")){
					select_status = "city";
					check_where = 1;
                	whereList.add(check_city);
				}
			} else{
				if (!select_data.equals("")) { 
                	if(select_status.equals("member_name") || select_status.equals("address") ){
						check_where = 5;
                		whereList.add("%" + select_data + "%");
                	}else {
						check_where = 1;
						whereList.add(select_data);
					}
                }
			}

		}	
		switch(check_where) { 
        case 0: 
			total_sql   += " order by member_id "; 
			detail_sql  += " order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 1: 
			total_sql   += " where  "+ select_status +" = ? order by member_id "; 
			detail_sql  += " where  "+ select_status +" = ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 2: 
			total_sql   += " where  "+ select_status +" < ? order by member_id "; 
			detail_sql  += " where  "+ select_status +" < ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 3: 
			total_sql   += " where  "+ select_status +" > ? order by member_id "; 
			detail_sql  += " where  "+ select_status +" > ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break;
        case 4: 
			total_sql   += " where  "+ select_status +"  between ? and ?  order by member_id "; 
			detail_sql  += " where  "+ select_status +"  between ? and ?  order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
	    case 5: 
			total_sql   += " where  "+ select_status +" like ? order by member_id "; 
			detail_sql  += " where  "+ select_status +" like ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break;  
   		 }
		  //out.println(total_sql);
		 // out.println(detail_sql);
		//if(true) return;
		 List total = null;
		 List ll    = null;
		 if(check_where == 0){
			 total = db.SelectRS(total_sql);
			 ll    = db.SelectRS(detail_sql);
		 }else {
			 total = db.SelectRSwhere(total_sql,whereList);
			 ll    = db.SelectRSwhere(detail_sql,whereList);
		 }
			
			out.println("{totalCount:"+total.size()+",result:[");
		for(int i=0;i<ll.size();i++){
			Map map = (Map) ll.get(i); 
				out.println("{");
				out.println("seqnum:"+ i +",");
				out.println("member_id:"+pp.replaceBlank(map.get( "member_id"))+",");
				out.println("member_account:'"+pp.replaceBlank(map.get( "member_account"))+"',");
				out.println("member_name:'"+pp.replaceBlank(map.get( "member_name"))+"',");
				out.println("password:'"+pp.replaceBlank(map.get( "password"))+"',");
				out.println("member_email:'"+pp.replaceBlank(map.get( "member_email"))+"',");
				out.println("city:'"+pp.replaceBlank(map.get( "city"))+"',");
				out.println("town:'"+pp.replaceBlank(map.get( "town"))+"',");
				out.println("address:'"+pp.replaceBlank(map.get( "address"))+"',");
				out.println("telephone:'"+pp.replaceBlank(map.get( "telephone"))+"',");
				out.println("createtime:'"+pp.replaceBlank(map.get( "createtime"))+"',");
				out.println("updatetime:'"+ pp.replaceBlank(map.get( "updatetime")) +"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
%>