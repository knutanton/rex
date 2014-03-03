<prefetchXml>
<%@ page contentType="text/xml;charset=UTF-8" language="java" %>
<%@ include file="/views/taglibsIncludeAll.jspf" %>

<c:set var="recordList" value="${renderForm.recIds}"/>
<!-- displayMode: ${renderForm.displayMode} -->
<c:forEach items="${recordList}" var="record" varStatus="recordStatus">
<!-- recId=${record} -->
		<c:set var="recordId" scope="request" value="${record}"/>
		<c:set var="recordBulkIndex" scope="request" value="${recordStatus.index}"/>
		<c:set var="recordResultIndex" scope="request" value="${renderForm.recIdxs[recordBulkIndex]}"/>
		<c:choose>
			<c:when test="${renderForm.displayMode=='full'}">
				<c:set var="recordElementId" scope="request">exlidResult0-TabContainer</c:set>
			</c:when>
			<c:otherwise>
		<c:set var="recordElementId" scope="request">exlidResult${recordResultIndex}-TabContainer</c:set>
			</c:otherwise>
		</c:choose>
		<c:set var="timestamp"><%=System.currentTimeMillis()%></c:set>

			<c:set var="displayURLRemoved" value="${requestScope.resultTileDisplayURL_reqEncUrlUTF8}" />
			<c:url var="popOutUrl" scope="request"  value="display.do?${displayURLRemoved}" >
				<c:param name="ct" value="display"/>
				<c:param name="fn" value="search"/>
				<c:param name="doc" value="${recordId}"/>
				<c:param name="indx" value="${param.indx}"/>
				<c:param name="recIds" value="${recordId}"/>
				<c:param name="recIdxs" value="${recordResultIndex}"/>
				<c:param name="elementId" value="${resultStatus.index}"/>
				<c:param name="renderMode" value="poppedOut"/>
				<c:param name="displayMode" value="full"/>
			</c:url>

		<c:url var="popOutUrlForLogin" scope="request" value="display.do?${requestScope.resultTileDisplayURL_reqEncUrl}" >
			<c:param name="ct" value="display"/>
			<c:param name="fn" value="search"/>
			<c:param name="doc" value="${recordId}"/>
			<c:param name="indx" value="${param.indx}"/>
			<c:param name="recIds" value="${recordId}"/>
			<c:param name="recIdxs" value="${recordResultIndex}"/>
			<c:param name="elementId" value="${resultStatus.index}"/>
			<c:param name="renderMode" value="poppedOut"/>
			<c:param name="displayMode" value="full"/>
		</c:url>

		<%-- this loop primarily eliminates the problem of accidentally prefetching session-form data. --%>
		<c:forEach items="${renderForm.tabs}" var="tab" varStatus="tabStatus">
			<c:choose>
				<c:when test="${tab eq 'detailsTab'}">
					<prm:renderTabContent form="${detailsForm}" tabKey="detailsTab" recordId="${recordId}" recordElementId="${recordElementId}-detailsTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'tagreviewsTab'}">
					<prm:renderTabContent form="${tagReviewsForm}" tabKey="tagreviewsTab" recordId="${recordId}" recordElementId="${recordElementId}-tagreviewsTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'locationsTab'}">
					<prm:renderTabContent form="${locationsTabForm}" tabKey="locationsTab" recordId="${recordId}" recordElementId="${recordElementId}-locationsTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'requestTab'}">
					<prm:renderTabContent form="${requestTabForm}" tabKey="requestTab" recordId="${recordId}" recordElementId="${recordElementId}-requestTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'recommendTab'}">
					<prm:renderTabContent form="${recommendationsForm}" tabKey="recommendTab" recordId="${recordId}" recordElementId="${recordElementId}-recommendTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'viewOnlineTab'}">
					<prm:renderTabContent form="${viewOnlineForm}" tabKey="viewOnlineTab" recordId="${recordId}" recordElementId="${recordElementId}-viewOnlineTab" popOutUrl="${popOutUrl}" />
				</c:when>
				<c:when test="${tab eq 'moreTab'}">
					<prm:renderTabContent form="${moreForm}" tabKey="moreTab" recordId="${recordId}" recordElementId="${recordElementId}-moreTab" popOutUrl="${popOutUrl}" />
				</c:when>
  				<c:when test="${tab eq 'conditionalTab'}">
					<prm:renderTabContent form="${conditionalTabForm}" tabKey="${conditionalTabForm.tabRealType}Tab" recordId="${recordId}" recordElementId="${recordElementId}-${conditionalTabForm.tabRealType}Tab" popOutUrl="${popOutUrl}" />
				</c:when>
  				<c:when test="${tab eq 'browseshelfTab'}">
					<prm:renderTabContent form="${browseshelfTabForm}" tabKey="browseshelfTab" recordId="${recordId}" recordElementId="${recordElementId}-browseshelfTab" popOutUrl="${popOutUrl}" />
				</c:when>
			</c:choose>
		</c:forEach>
</c:forEach>

	<logElement><![CDATA[
<exlibris-html:monitor inAjax='true' />
	]]></logElement>
</prefetchXml>