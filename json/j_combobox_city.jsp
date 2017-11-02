<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%
pattern pp = new pattern();

		DbBean db = new DbBean();
		List ll = db.SelectRS("select * from city  order by city_id asc ");
			out.println("{totalCount:" + ll.size() + ",result:[");
		for(int i=0;i<ll.size();i++){
				out.println("{");
			Map map = (Map) ll.get(i); 
				out.println("name:'"+pp.replaceBlank(map.get( "city_name"))+"',");
				out.println("value:'"+pp.replaceBlank(map.get( "city_name"))+"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
 
%>