<%@ include file="/views/taglibsIncludeAll.jspf" %>
<!-- fullViewPage.jsp begin -->
<html>
<head>
<link href="../css/Primo_default.3.0.css" type="text/css" rel="stylesheet"/>
</head>
<body>
<html:form action="/action/expand.do">
</html:form>
<c:set var="recordList" value="${renderForm.recIds}"/>
<c:forEach items="${recordList}" var="record" varStatus="recordStatus">
<!-- recId=${record} -->
	<%--c:forEach items="${renderForm.tabs[record]}" var="tab"--%>
		<c:set var="recordId" scope="request" value="${record}"/>
		<c:set var="recordBulkIndex" scope="request" value="${recordStatus.index}"/>
		<c:set var="recordResultIndex" scope="request" value="${renderForm.recIdxs[recordBulkIndex]}"/>
		<c:set var="recordElementId" scope="request">exlidResult${recordResultIndex}-TabContainer</c:set>
		<c:set var="timestamp"><%=System.currentTimeMillis()%></c:set>

	<c:if test="${detailsForm.renderer[recordId]!=null}">
	<jsp:include page="${detailsForm.renderer[recordId]}"/>
	</c:if>

	<c:if test="${tagReviewsForm.renderer[recordId]!=null}">
	<jsp:include page="${tagReviewsForm.renderer[recordId]}"/>
	</c:if>

	<c:if test="${requestTabForm.renderer[recordId]!=null}">
	<jsp:include page="${requestTabForm.renderer[recordId]}"/>
	</c:if>

	<c:if test="${locationsTabForm.renderer[recordId]!=null}">
	<jsp:include page="${locationsTabForm.renderer[recordId]}"/>
	</c:if>

	<c:if test="${frameForm.renderer[recordId]!=null}">
	<jsp:include page="${frameForm.renderer[recordId]}"/>
	</c:if>

</c:forEach>
</body>
</html>
<!-- fullViewPage.jsp end -->