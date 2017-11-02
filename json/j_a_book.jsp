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

String sort = " book_id ";
String dir = "asc";
String select_status = "";
String select_data = "";
String date_s = "";
String date_e = "";
String check_userid = "";
String check_category = "";
String check_recommend = "";
String check_int = "";
if(request.getParameter("sort") != null) sort = (String)request.getParameter("sort");
if(request.getParameter("dir") != null) dir = (String)request.getParameter("dir");
if(request.getParameter("select_status") != null) select_status = (String)request.getParameter("select_status");
if(request.getParameter("select_data") != null) select_data = (String)request.getParameter("select_data");
if(request.getParameter("date_s") != null) date_s = (String)request.getParameter("date_s");
if(request.getParameter("date_e") != null) date_e = (String)request.getParameter("date_e");
if(request.getParameter("check_userid") != null) check_userid = (String)request.getParameter("check_userid");
if(request.getParameter("check_category") != null) check_category = (String)request.getParameter("check_category");
if(request.getParameter("check_recommend") != null) check_recommend = (String)request.getParameter("check_recommend");
if(request.getParameter("check_int") != null) check_int = (String)request.getParameter("check_int");

		DbBean db = new DbBean();
		List whereList = new ArrayList(); 
		int check_where = 0;
		String total_sql   = "  select a.*,b.category_name,c.recommend_name from book as a inner join category as b  ";
			   total_sql  += "  on a.category_id = b.category_id left join recommend as c on a.recommend_id = c.recommend_id   ";
		String detail_sql  = "  select a.*,b.category_name,c.recommend_name from book as a inner join category as b ";
			   detail_sql += "  on a.category_id = b.category_id left join recommend as c on a.recommend_id = c.recommend_id  ";
		if(!select_status.equals("")){	
		 if(select_status.equals("release_date") || select_status.equals("createtime") || select_status.equals("updatetime") ){
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
			} else if(select_status.equals("category_id")){
				if (!check_category.equals("")) {
					check_where = 1;
                	whereList.add(check_category);
				}
			} else if(select_status.equals("recommend_id")){
				if (!check_recommend.equals("")) {
					check_where = 1;
                	whereList.add(check_recommend);
				}
			} else if(select_status.equals("book_total") || select_status.equals("book_price") ){
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
                	if(select_status.equals("book_name") || select_status.equals("author") || select_status.equals("publishing")){
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
			total_sql   += " order by book_id "; 
			detail_sql  += " order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 1: 
			total_sql   += " where  a."+ select_status +" = ? order by book_id "; 
			detail_sql  += " where  a."+ select_status +" = ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 2: 
			total_sql   += " where  a."+ select_status +" < ? order by book_id "; 
			detail_sql  += " where  a."+ select_status +" < ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
        case 3: 
			total_sql   += " where  a."+ select_status +" > ? order by book_id "; 
			detail_sql  += " where  a."+ select_status +" > ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break;
        case 4: 
			total_sql   += " where  a."+ select_status +"  between ? and ?  order by book_id "; 
			detail_sql  += " where  a."+ select_status +"  between ? and ?  order by  "+sort+" "+dir+"   limit "+start+","+limit;
            break; 
	    case 5: 
			total_sql   += " where  a."+ select_status +" like ? order by book_id "; 
			detail_sql  += " where  a."+ select_status +" like ? order by  "+sort+" "+dir+"   limit "+start+","+limit;
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
				out.println("book_id:"+pp.replaceBlank(map.get( "book_id"))+",");
				out.println("book_name:'"+pp.replaceBlank(map.get( "book_name"))+"',");
				out.println("book_img:'"+pp.replaceBlank(map.get( "book_img"))+"',");
				out.println("category_id:'"+pp.replaceBlank(map.get( "category_id"))+"',");
				out.println("category_name:'"+pp.replaceBlank(map.get( "category_name"))+"',");
				out.println("recommend_id:'"+pp.replaceBlank(map.get( "recommend_id"))+"',");
				out.println("recommend_name:'"+pp.replaceBlank(map.get( "recommend_name"))+"',");
				out.println("author:'"+pp.replaceBlank(map.get( "author"))+"',");
				out.println("publishing:'"+pp.replaceBlank(map.get( "publishing"))+"',");
				out.println("release_date:'"+pp.replaceBlank(map.get( "release_date"))+"',");
				out.println("book_price:'"+pp.replaceBlank(map.get( "book_price"))+"',");
				out.println("book_total:'"+pp.replaceBlank(map.get( "book_total"))+"',");
				out.println("a_userid:'"+pp.replaceBlank(map.get( "a_userid"))+"',");
				out.println("createtime:'"+pp.replaceBlank(map.get( "createtime"))+"',");
				out.println("updatetime:'"+ pp.replaceBlank(map.get( "updatetime")) +"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
%>