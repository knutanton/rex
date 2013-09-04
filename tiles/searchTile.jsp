<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/javascript/mainMenu.js" %>

<!-- searchTile.jsp begin -->
<%-- do our best to make sure searchForm exists for usage by tiles in the page --%>
<c:if test="${empty searchForm}">
	<c:set var="searchForm" value="${requestScope.displayForm}" scope="request"/>
</c:if>
<c:if test="${empty searchForm}">
	<c:set var="searchForm" value="${sessionScope.lastSearchForm}" scope="request"/>
</c:if>

<%-- for embedded search --%>

<c:if test="${empty formAction}">
	<c:set var="formAction" value="/action/search.do?${action_func}=go&amp;ct=search"/>
</c:if>

<c:if test="${empty resloc}">
	<c:set var="resloc">_self</c:set>
</c:if>

<html:form styleId="searchForm" method="post" styleClass="EXLSearchForm" action="${formAction}"
		   enctype="application/x-www-form-urlencoded; charset=utf-8"
		   onsubmit="if(isRemoteSearch()){doPleaseWait();};if(window.manualFormSubmit){manualFormSubmit(this.id);return false;}" target="${resloc}">

<c:if test="${sessionScope.showPyrPopup=='true'}">
<script type="text/javascript">
loadPyrPreferencesPage('pyrFromInitial');
</script>
</c:if>


<jsp:include page="searchTileBasic.jsp" />

<jsp:include page="searchLimitsTile.jsp" />


</html:form>
<!-- searchTile.jsp end -->

