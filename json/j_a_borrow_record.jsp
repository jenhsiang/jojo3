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

String sort = " borrow_id ";
String dir = "asc";
String select_status = "";
String select_data = "";
String date_s = "";
String date_e = "";
String check_userid = "";
String check_status = "";
String check_givefine = "";
String check_int = "";
if(request.getParameter("sort") != null) sort = (String)request.getParameter("sort");
if(request.getParameter("dir") != null) dir = (String)request.getParameter("dir");
if(request.getParameter("select_status") != null) select_status = (String)request.getParameter("select_status");
if(request.getParameter("select_data") != null) select_data = (String)request.getParameter("select_data");
if(request.getParameter("date_s") != null) date_s = (String)request.getParameter("date_s");
if(request.getParameter("date_e") != null) date_e = (String)request.getParameter("date_e");
if(request.getParameter("check_userid") != null) check_userid = (String)request.getParameter("check_userid");
if(request.getParameter("check_status") != null) check_status = (String)request.getParameter("check_status");
if(request.getParameter("check_givefine") != null) check_givefine = (String)request.getParameter("check_givefine");
if(request.getParameter("check_int") != null) check_int = (String)request.getParameter("check_int");

		DbBean db = new DbBean();
		List whereList = new ArrayList(); 
		int check_where = 0;
		String total_sql   = "  select * from ( select a.*,F_check_rent_status(a.borrow_id) as borrow_status,F_get_now_fine(a.borrow_id) as real_fine,  ";
			   total_sql  += "  b.book_name,c.member_account,c.member_name,c.member_email from borrow_record as a inner join book as b on a.book_id = b.book_id    ";
			   total_sql  += "  inner join member as c on a.member_id = c.member_id ) as d   ";
		String detail_sql  = "  select * from ( select a.*,F_check_rent_status(a.borrow_id) as borrow_status,F_get_now_fine(a.borrow_id) as real_fine, ";
			   detail_sql += "  b.book_name,c.member_account,c.member_name,c.member_email from borrow_record as a inner join book as b on a.book_id = b.book_id    ";
			   detail_sql += "  inner join member as c on a.member_id = c.member_id ) as d   ";
		if(!select_status.equals("")){	
		 if(select_status.equals("reserve_date") || select_status.equals("reserve_deadline") || select_status.equals("borrow_date") 
			 || select_status.equals("borrow_deadline") || select_status.equals("return_date")  ){
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
			} else if(select_status.equals("borrow_status")){
				if (!check_status.equals("")) {
					check_where = 1;
                	whereList.add(check_status);
				}
			} else if(select_status.equals("givefine")){
				if (!check_givefine.equals("")) {
					check_where = 1;
                	whereList.add(check_givefine);
				}
			} else if(select_status.equals("real_fine")){
				if (!check_int.equals("")) {
					check_where = 1;
                	whereList.add(check_int);
				}
			} else if(select_status.equals("a_userid")){
				if (!check_userid.equals("")) {
					check_where = 1;
                	whereList.add(check_userid);
				}
			}else{
				if (!select_data.equals("")) { 
                	if(select_status.equals("book_name")){
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
			total_sql   += " order by borrow_id "; 
			detail_sql  += " order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 1: 
			total_sql   += " where  "+ select_status +" = ? order by borrow_id "; 
			detail_sql  += " where  "+ select_status +" = ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 2: 
			total_sql   += " where  "+ select_status +" < ? order by borrow_id "; 
			detail_sql  += " where  "+ select_status +" < ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 3: 
			total_sql   += " where  "+ select_status +" > ? order by borrow_id "; 
			detail_sql  += " where  "+ select_status +" > ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break;
        case 4: 
			total_sql   += " where  "+ select_status +"  between ? and ?  order by borrow_id "; 
			detail_sql  += " where  "+ select_status +"  between ? and ?  order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
	    case 5: 
			total_sql   += " where  "+ select_status +" like ? order by borrow_id "; 
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
				out.println("borrow_id:"+pp.replaceBlank(map.get( "borrow_id"))+",");
				out.println("member_id:'"+pp.replaceBlank(map.get( "member_id"))+"',");
				out.println("member_account:'"+pp.replaceBlank(map.get( "member_account"))+"',");
				out.println("member_name:'"+pp.replaceBlank(map.get( "member_name"))+"',");
				out.println("member_email:'"+pp.replaceBlank(map.get( "member_email"))+"',");
				out.println("book_id:'"+pp.replaceBlank(map.get( "book_id"))+"',");
				out.println("book_name:'"+pp.replaceBlank(map.get( "book_name"))+"',");
				out.println("borrow_status:'"+pp.replaceBlank(map.get( "borrow_status"))+"',");
				out.println("reserve_date:'"+pp.replaceBlank(map.get( "reserve_date"))+"',");
				out.println("reserve_deadline:'"+pp.replaceBlank(map.get( "reserve_deadline"))+"',");
				out.println("borrow_date:'"+pp.replaceBlank(map.get( "borrow_date"))+"',");
				out.println("borrow_deadline:'"+pp.replaceBlank(map.get( "borrow_deadline"))+"',");
				out.println("return_date:'"+pp.replaceBlank(map.get( "return_date"))+"',");
				out.println("fine:'"+pp.replaceBlank(map.get( "fine"))+"',");
				out.println("real_fine:'"+pp.replaceBlank(map.get( "real_fine"))+"',");
				out.println("givefine:'"+pp.replaceBlank(map.get( "givefine"))+"',");
				out.println("a_userid:'"+pp.replaceBlank(map.get( "a_userid"))+"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
%>