<%@ include file="/views/taglibsIncludeAll.jspf" %>
<c:set var="bulkSize" value="${sessionScope.bulk}" />
<c:if test="${param.almaAzSearch == 'true' }">
<c:set var="bulkSize" value="30" />
</c:if>
<c:if test="${form.searchResult.numberOfResults>bulkSize || form.indx>1}">
	<c:url value="${form.reqDecUrl}" var="pagnationURL">
			<c:param name="refinementId" value="${refine.refinementid}"/>
	</c:url>
	<c:if test="${form.indx!='1'}">
	
	 
	   <c:url value='${form.responseEncodeReqDecUrl}' var="paginationPrevURL">
			<c:param name="ct" value="Previous Page"/>
			<c:param name="pag" value="prv"/>
	   </c:url>
		<c:set var="previousTitle"><fmt:message key="link.title.results.prev"/></c:set>
		<a href="${fn:escapeXml(paginationPrevURL)}" title="${previousTitle}" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious  EXLBriefResultsPagination"><img src="<fmt:message key='ui.images.resultsheadernavigation.arrowprev'/>" alt="previous page" /> </a>
	
		
		
    </c:if>
    <c:if test="${form.presentPaging}">
    <c:forEach begin="${form.plsp.firstPagePresented}" end="${form.plsp.lastPagePresented}" varStatus="loop">
    <c:if test="${loop.index == 1 && form.indx!='1'}">  
    <c:url value='${form.responseEncodeReqDecUrl}' var="paginationPage">
			<c:param name="ct" value=""/>
			<c:param name="pag" value=""/>
			<c:param name="indx" value="1"/>
	   </c:url>
		<c:set var="pageNum"> ${loop.index} </c:set>
		<a href="${fn:escapeXml(paginationPage)}" title="<fmt:message key='link.title.results.page'><fmt:param value="${loop.index}" /></fmt:message>" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious EXLBriefResultsPagination">${loop.index}</a>
	</c:if>
    <c:if test="${loop.index != form.plsp.currentPageNumber && loop.index != 1}">
    <c:set var="indxForPage" value="${((loop.index-1) * bulkSize) - (bulkSize - 1)}" />
    <c:url value='${form.responseEncodeReqDecUrl}' var="paginationPage">
			<c:param name="ct" value="Next Page"/>
			<c:param name="pag" value="nxt"/>
			<c:param name="indx" value="${indxForPage}"/>
	   </c:url>
		<c:set var="pageNum"> ${loop.index} </c:set>
		<a href="${fn:escapeXml(paginationPage)}" title="<fmt:message key='link.title.results.page'><fmt:param value="${loop.index}" /></fmt:message>" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious EXLBriefResultsPagination">${loop.index}</a>
	</c:if>
	<c:if test="${loop.index == form.plsp.currentPageNumber}">
    <span class="EXLHide"><fmt:message key='results.rescount' /></span>
	<span class="EXLDisplayedCount EXLBriefResultsPaginationPageCount">${loop.index}</span>
    </c:if>
    </c:forEach>
 </c:if>
 
  <c:if test="${!form.presentPaging}">
  <span class="EXLHide"><fmt:message key='results.rescount' /></span>
	<span class="EXLDisplayedCount EXLBriefResultsPaginationPageCount">&nbsp;${form.searchResult.firstResultIndex}-${form.searchResult.lastResultIndex}</span>
 </c:if>
    
  
    <c:if test="${(form.indx-1)+bulkSize<form.searchResult.numberOfResults}">
    
  	 		
  		<c:url value="${form.responseEncodeReqDecUrl}" var="paginationNextURL">
			<c:param name="ct" value="Next Page"/>
			<c:param name="pag" value="nxt"/>
		</c:url>
		<c:set var="nextTitle"><fmt:message key="link.title.results.next"/></c:set>
		<a href="${fn:escapeXml(paginationNextURL)}" title="${nextTitle}" class="EXLNext EXLBriefResultsPaginationLinkNext EXLBriefResultsPagination"> <img src="<fmt:message key='ui.images.resultsheadernavigation.arrownext'/>" alt="next page" /></a>
		
	
		
    </c:if>
  

     
</c:if>
