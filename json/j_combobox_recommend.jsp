<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%
pattern pp = new pattern();

		DbBean db = new DbBean();
		List ll = db.SelectRS("select * from recommend  order by recommend_id asc ");
			out.println("{totalCount:" + ll.size() + ",result:[");
			out.println("{");
				out.println("name:'不限',");
				out.println("value:'0'");
				out.println("},");
		for(int i=0;i<ll.size();i++){
				out.println("{");
			Map map = (Map) ll.get(i); 
				out.println("name:'"+pp.replaceBlank(map.get( "recommend_name"))+"',");
				out.println("value:'"+pp.replaceBlank(map.get( "recommend_id"))+"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
 
%>