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
	<c:set var="formAction" value="/action/search.do?${action_func}=search&amp;ct=search"/>
</c:if>

<c:if test="${empty resloc}">
	<c:set var="resloc">_self</c:set>
</c:if>

<html:form styleId="searchForm" method="get" styleClass="EXLSearchForm" action="${formAction}"
		   enctype="application/x-www-form-urlencoded; charset=utf-8"
		   onsubmit="if(isRemoteSearch()){doPleaseWait();};if(window.manualFormSubmit){manualFormSubmit(this.id);return false;}" target="${resloc}">
		   

<input id="fn" type="hidden" value="search" name="fn" />
<input id="ct" type="hidden" value="search" name="ct" />
<input id="initialSearch" type="hidden" value="true" name="initialSearch" />

<input id="autoCompleteEnabled"   type="hidden" value='${sessionScope.acOn}' />
<input id="autoCompleteUrl"       type="hidden" value='${sessionScope.acUrl}' />
<input id="autoCompleteScope"     type="hidden" value='${sessionScope.acScope}' />
<input id="autoCompleteScopesMap" type="hidden" value='${sessionScope.acScopesMap}' />

<c:if test="${sessionScope.showPyrPopup=='true'}">
<script type="text/javascript">
	loadPyrPreferencesPage('pyrFromInitial');
</script>
</c:if>


<jsp:include page="searchTileBasic.jsp" />

<%--<jsp:include page="searchLimitsTile.jsp" /> Bliver includeret i searchTileBasic.jsp--%>


</html:form>
<!-- searchTile.jsp end -->

