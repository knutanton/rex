<%-- /views/search/l_input_search.jsp --%>
<!-- l_search_input.jsp begin -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ page import="com.exlibris.primo.utils.SessionUtils" %>

<%
        // jac: points to search tile in our dev environments
        String view = request.getParameter("vid");
        if(view.startsWith("kb")){
            view = view.substring(2);
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
