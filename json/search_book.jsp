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

		String  categorySql  = " select * from category   ";
		String  recommendSql = " select * from recommend  ";
		
		DbBean db = new DbBean();
		List categoryList  = db.SelectRS(categorySql);
		List recommendList = db.SelectRS(recommendSql);
		
		
		 out.print("[");
			if(categoryList.size() > 0){
					out.print("{\"search_id\":\"0\"");
					out.print(",\"search_name\":\"all\"");
					out.print(",\"search_type\":\"類別\"");
					out.print("},");
				for(int i=0;i<categoryList.size();i++){
					Map map = (Map) categoryList.get(i);
					int    search_id   = (Integer)map.get("category_id");
					String search_name = (String)map.get("category_name");

					out.print("{\"search_id\":\"" + search_id + "\"");
					out.print(",\"search_name\":\""+search_name + "\"");
					out.print(",\"search_type\":\"類別\"");
					out.print("},");
					}	
				}
				if(recommendList.size() > 0){
					out.print("{\"search_id\":\"0\"");
					out.print(",\"search_name\":\"不限\"");
					out.print(",\"search_type\":\"推薦\"");
					out.print("},");
					for(int i=0;i<recommendList.size();i++){
						Map map = (Map) recommendList.get(i);
						int    search_id     = (Integer)map.get("recommend_id");
						String search_name   = (String)map.get("recommend_name");

						out.print("{\"search_id\":\"" + search_id + "\"");
						out.print(",\"search_name\":\""+search_name + "\"");
						out.print(",\"search_type\":\"推薦\"");
						out.print("}");
							if(i < recommendList.size() - 1){
								out.print(",");
							}
						}	
				}
		 	out.print("]");	
			
	
%>