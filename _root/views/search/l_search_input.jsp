<%-- /views/search/l_input_search.jsp --%>
<!-- l_search_input.jsp begin -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ page import="com.exlibris.primo.utils.SessionUtils" %>

<%
         // jac: points to search tile in our dev environments
                 String view = "";

        // Try to read  view from from URI
        if(request.getParameter("vid") != null ){
            view = request.getParameter("vid");
        }


        // remove 'kb', so it fits our folder structure
        if(view.startsWith("kb")){
                    view = view.substring(2);
        }

        if(view.equals("")){ // no vid parameter in url
			view = request.getSession().getAttribute( "vid" )+""; // read from session
			if(view.equals("")){
				view = "KGL"; // last default to KGL
			}
        } else {
			request.getSession().setAttribute( "vid", view ); // set session parameter
        }

        String key = "l_search_input.jsp";
        String prefix = "/sites/kb/"+view+"/a/b/";
        String jsp_default = "/tiles/searchTile.jsp";
%>

<%@ include file="/general/jsp_mapping_retriver.jsp" %>

<c:set var="jsp_page"><%=jspPage%></c:set>
<!-- resolved jsp page for search tile: ${jsp_page} -->
<tiles:insert page="${jsp_page}" />
<!-- l_search_input.jsp end -->
