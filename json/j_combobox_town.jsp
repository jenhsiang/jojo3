<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean" %>
<%@ page import="StringFormat.pattern" %>
<%
pattern pp = new pattern();
String city_name = "台北市";
if(request.getParameter("city_name") != null) city_name = (String)request.getParameter("city_name");

		DbBean db = new DbBean();
		String sql = "select a.*,b.city_name from town as a inner join city as b on a.city_id = b.city_id where b.city_name = ? order by a.town_id asc ";
		List whereList = new ArrayList(); 
		whereList.add(city_name);  
		List ll = db.SelectRSwhere(sql,whereList);
			out.println("{totalCount:" + ll.size() + ",result:[");
		for(int i=0;i<ll.size();i++){
				out.println("{");
			Map map = (Map) ll.get(i); 
				out.println("name:'"+pp.replaceBlank(map.get( "town_name"))+"',");
				out.println("value:'"+pp.replaceBlank(map.get( "town_name"))+"'");
				out.println("}");
				if(i<ll.size()-1)
					out.println(",");
			}
		out.println("]}");
 
%>