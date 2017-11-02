<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="teachDB.DbBean"%>
<%!

	/** SQL 值中的單引號(')需要轉化為 \'  */
	public String forSQL(String sql){
		return sql.replace("'", "\\'");
	}

	public boolean checkReq(Object obj){
		boolean check = false ;
		if(obj != null && !((String)obj).equals("")){
			check = true;
		}
		return check;
	}
	public  String trim(String str) {
		  if (str == null || str.equals("")) {
		   return str;
		  } else {
		   //return leftTrim(rightTrim(str));
		                        return str.replaceAll("^[　 ]+|[　 ]+$","");
		  }
		 }
	public String toEmpty(String str) {
		if (str == null ){
			 return "";
		}else{
			return str;
		}
	}
%>
<%
	request.setCharacterEncoding("UTF-8");
		String  citySql = " select * from city order by city_id  ";
		
		DbBean db = new DbBean();
		
		List cityList = db.SelectRS(citySql);
		
		 out.print("[");
				if(cityList.size() > 0){
					for(int i=0;i<cityList.size();i++){
						Map map = (Map) cityList.get(i);
						String city_name   = (String)map.get("city_name");

						out.print("{\"city\":\"" + city_name + "\"");
						out.print("}");
							if(i < cityList.size() - 1){
								out.print(",");
							}
						}	
				}
		 	out.print("]");	
			
	
%>