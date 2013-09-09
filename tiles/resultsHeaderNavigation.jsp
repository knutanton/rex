<%@ include file="/views/taglibsIncludeAll.jspf" %>
<c:set var="bulkSize" value="${sessionScope.bulk}" />
<c:if test="${param.almaAzSearch == 'true' }">
<c:set var="bulkSize" value="30" />
</c:if>

<ul class="pagination">
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
        <li>
		<a href="${fn:escapeXml(paginationPrevURL)}" title="${previousTitle}" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious  EXLBriefResultsPagination">&laquo;</a>
        </li>
		
		
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
        <li>
		<a href="${fn:escapeXml(paginationPage)}" title="<fmt:message key='link.title.results.page'><fmt:param value="${loop.index}" /></fmt:message>" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious EXLBriefResultsPagination">${loop.index}</a>
        </li>
    </c:if>
    <c:if test="${loop.index != form.plsp.currentPageNumber && loop.index != 1}">
    <c:set var="indxForPage" value="${((loop.index-1) * bulkSize) - (bulkSize - 1)}" />
    <c:url value='${form.responseEncodeReqDecUrl}' var="paginationPage">
			<c:param name="ct" value="Next Page"/>
			<c:param name="pag" value="nxt"/>
			<c:param name="indx" value="${indxForPage}"/>
	   </c:url>
		<c:set var="pageNum"> ${loop.index} </c:set>
        <li>
		<a href="${fn:escapeXml(paginationPage)}" title="<fmt:message key='link.title.results.page'><fmt:param value="${loop.index}" /></fmt:message>" class="EXLPrevious EXLBriefResultsPaginationLinkPrevious EXLBriefResultsPagination">${loop.index}</a>
        </li>
    </c:if>
	<c:if test="${loop.index == form.plsp.currentPageNumber}">
    <span class="EXLHide sr-only"><fmt:message key='results.rescount' /></span>
    <li>
	<span class="EXLDisplayedCount EXLBriefResultsPaginationPageCount">${loop.index}</span>
    </li>
    </c:if>
    </c:forEach>
 </c:if>
 
  <c:if test="${!form.presentPaging}">
  <span class="EXLHide sr-only"><fmt:message key='results.rescount' /></span>
      <li>
	<span class="EXLDisplayedCount EXLBriefResultsPaginationPageCount">&nbsp;${form.searchResult.firstResultIndex}-${form.searchResult.lastResultIndex}</span>
      </li>
 </c:if>
    
  
    <c:if test="${(form.indx-1)+bulkSize<form.searchResult.numberOfResults}">
    
  	 		
  		<c:url value="${form.responseEncodeReqDecUrl}" var="paginationNextURL">
			<c:param name="ct" value="Next Page"/>
			<c:param name="pag" value="nxt"/>
		</c:url>
		<c:set var="nextTitle"><fmt:message key="link.title.results.next"/></c:set>
		<li><a href="${fn:escapeXml(paginationNextURL)}" title="${nextTitle}" class="EXLNext EXLBriefResultsPaginationLinkNext EXLBriefResultsPagination">&raquo;</a></li>
		
	
		
    </c:if>
  

     
</c:if>

</ul>