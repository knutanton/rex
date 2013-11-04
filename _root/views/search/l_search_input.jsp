<%-- /views/search/l_input_search.jsp --%>
<!-- l_search_input.jsp begin -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ page import="com.exlibris.primo.utils.SessionUtils" %>

<%
        // jac: points to search tile in our dev environments
        String view = request.getSession().getAttribute( "vid" )+ "";

        // remove 'kb', so it fits our folder structure
        if(view.startsWith("kb")){
            view = view.substring(2);
        }

        String key = "l_search_input.jsp";
        String prefix = "/sites/kb/"+view+"/a/b/";
        String jsp_default = "/tiles/searchTile.jsp";
%>

<%@ include file="/general/jsp_mapping_retriver.jsp" %>


<%
// when arriving from a deeplink, the extra prefix
// should not be applied
// ex: http://primo-97.kb.dk/primo_library/libweb/action/dlDisplay.do?vid=kbdev01&afterPDS=true&institution=KGLN&docId=TN_gale_ofg263218779
if ( jspPage.indexOf("../../") <= 0 ){
    jspPage = jspPage.replaceAll("a/b/","");
}

%>

<c:set var="jsp_page"><%=jspPage%></c:set>
<!-- resolved jsp page for search tile: ${jsp_page} -->
<tiles:insert page="${jsp_page}" />

<%-- /views/search/l_input_search.jsp --%>
<!-- l_search_input.jsp end -->
