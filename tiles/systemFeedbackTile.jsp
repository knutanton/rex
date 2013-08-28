<!-- systemFeedbackTile.jsp begin -->
<%@ include	 file="/views/taglibsIncludeAll.jspf" %>
<c:set var="primoView"  value="${sessionScope.primoView}"/>
<c:if test="${searchForm == null}">
<c:set var="searchForm" value="${displayForm}" scope="request"/>
</c:if>

<c:set var="errorString"><html:errors/></c:set>

<c:url var="loginPdsUrl" value="${fn:escapeXml(sessionScope.pdsUrlLogin)}?${targeturl}=${fn:escapeXml(form.reqEncUrl)}"/>

<%--Append did you mean string if exist --%>
<c:if test="${not empty searchForm.searchResult.didUMean}">
	<c:url value="search.do" var="dum_search_url">
			<c:param name="ct" value="didym"/>
			<c:param name="${action_func}" value="search"/>
		 	<c:param name="tab" value="${searchForm.tab}"/>
		 	<c:param name="mode" value="${searchForm.mode}"/>
	 		<c:param name="scp.scps" value="${searchForm.scp.scps}"/>
			<c:forEach items="${searchForm.searchResult.didUMeanItems}" var="search_token" varStatus="delStatus">
				<c:param name="vl(${c_ctype_freetext}${delStatus.index})" value="${search_token}"/>
			</c:forEach>
 			<c:param name="vl(${c_ctype_freetext}0)" value="${searchForm.searchResult.didUMean}"/>
 			<c:forEach items='${searchForm.queryTerms}' var="queryTerm">
	 			<c:forEach items='${queryTerm.inputs}' var="input">
	 				<c:if test="${not fn:contains(input.id, 'freeText')}">
	 					<c:param name="vl(${input.id})" value="${searchForm.values[input.id]}"/>
	 				</c:if>
	 			</c:forEach>
 			</c:forEach>
	</c:url>
	<c:set var="feedbackMessage">
	<fmt:message key="results.didumean" />&nbsp;<a href="${fn:escapeXml(dum_search_url)}" class="alert-link" onclick="if(isRemoteSearch()){suggestedPleaseWait('${searchForm.searchResult.didUMean}');}">${searchForm.searchResult.didUMean}</a>?
	</c:set>
</c:if>
<c:if test="${not loggedIn and not searchForm.allFullAccess and (selectedScopeAccessibility==0 or selectedScopeAccessibility==1)}">
    <c:set var="feedbackMessage"><a href="${loginPdsUrl}">Sign in</a> to get results from more resources.</c:set>
</c:if>
<c:if test="${not empty errorString}">
	<c:set var="feedbackMessage" value="${errorString}"/>
</c:if>
<c:if test="${searchForm.remote and searchForm.searchResult.numberOfResults>0 and searchForm.searchResult.maxNumberOfResults>searchForm.searchResult.numberOfResults}">
	<c:url value="${searchForm.reqDecUrl}" var="getMoreURL">
		<c:param name="${action_func}" value="${c_go_m}"/>
		<c:param name="ct" value="Remote More"/>
	</c:url>
	<c:set var="feedbackMessage"><c:if test="${not empty feedbackMessage}">${feedbackMessage}<br></c:if><a href="${fn:escapeXml(getMoreURL)}" onclick="doPleaseWait();"><fmt:message key='default.brief.display.more.results'/></a></c:set>
</c:if>
<c:if test="${searchForm.remote 
	and searchForm.searchResult.numberOfResults == 0
	and searchForm.searchResult.maxNumberOfResults>searchForm.searchResult.numberOfResults 
	and (searchForm.includeFullText
	or searchForm.includePeerReviewed)}">
	<c:url value="${searchForm.reqDecUrl}" var="getMoreURL">
		<c:param name="${action_func}" value="${c_go_m}"/>
		<c:param name="ct" value="Remote More"/>
	</c:url>
	<c:set var="prefilterVar"/>
	<c:if test="${searchForm.includeFullText and !searchForm.includePeerReviewed}">
		<c:set var="prefilterVar"><fmt:message key='remotesearch.filter.fulltext'/></c:set>
	</c:if>
	<c:if test="${searchForm.includePeerReviewed and !searchForm.includeFullText}">
		<c:set var="prefilterVar"><fmt:message key='remotesearch.filter.peerreview'/></c:set>
	</c:if>
	<c:if test="${searchForm.includePeerReviewed and searchForm.includeFullText}">
		<c:set var="prefilterVar"><fmt:message key='remotesearch.filter.fulltext'/><fmt:message key='remotesearch.filter.connector'/><fmt:message key='remotesearch.filter.peerreview'/></c:set>
	</c:if>
	<c:set var="feedbackMessage"><a href="${fn:escapeXml(getMoreURL)}" onclick="doPleaseWait();">
		<fmt:message key="remotesearch.filter.noresults">
			<fmt:param>${prefilterVar}</fmt:param>
		</fmt:message>

	</a></c:set>
</c:if>


<c:if test="${not empty feedbackMessage}">
    <div class="alert alert-info alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <strong>${feedbackMessage}!</strong>
    </div>
</c:if>
<!-- systemFeedbackTile.jsp end -->
