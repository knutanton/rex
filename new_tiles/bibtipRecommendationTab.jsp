<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@page import="java.util.*" %>

<script type="text/javascript">
function data(){
	document.getElementById('myAnchor').value=name;
}
</script>
<noscript>This feature requires javascript</noscript>
<c:if test="${recommendationsForm != null}">
	<html:form action="/action/recommend.do">
		<div id="exlidResult${resultStatus.index}-TabHeader" class="EXLTabHeader">
       		<div class="EXLTabHeaderContent"> </div>
     		<div id="exlidTabHeaderButtons${recordResultIndex}" class="EXLTabHeaderButtons">
	          	<prm:sendTo recordId="${recordId}"  pushToTypeList="${form.pushToTypeList}" fromEshelf="${form.fromEshelf}" fn="${form.fn}"  inBasket="${form.inBasket[0]}" tabForm="${recommendationsForm}" />
        		</div>
      	</div>

		<c:set var="bibtipresult" value='${recommendationsForm.recommendation}' scope="request"/>

		<%request.getSession().setAttribute("bibtipresult_"+request.getAttribute("recordId"),request.getAttribute("bibtipresult")); %>



		<c:if test="${ ! empty bibtipresult}">
			<c:set var="noHLtitle">${fn:replace(bibtipresult.title, '<span class="searchword">', '')}</c:set>
					<c:set var="noHLtitle">
												${fn:replace(noHLtitle, '</span>', '')}
					</c:set>

			<c:set var="noHLcreator">${fn:replace(bibtipresult.creator, '<span class="searchword">', '')}</c:set>
					<c:set var="noHLcreator">
												${fn:replace(noHLcreator, '</span>', '')}
					</c:set>
					<c:url value='../tiles/bibtip_content.jsp' var="bibTipUrl">
						<c:param name="recordId" value='${bibtipresult.recordId}'/>
						<c:param name="title" value='${noHLtitle}'/>
						<c:param name="isbn" value='${bibtipresult.isbnStr}'/>
						<c:param name="creationdate" value='${bibtipresult.creationdate}'/>
						<c:param name="creator" value='${noHLcreator}'/>
					  </c:url>

			<div id="exlidResult6BibTip-TabContent" class="EXLTabContent EXLRecommendationsTabContent">
				<iframe   src="${fn:escapeXml(bibTipUrl)}"
				name="bibTip" title="bibTip recommendation"  scrolling="auto" width="100%" height="100%" frameborder="1"></iframe>
	      	</div>
    	</c:if>
		<input type="submit" class="EXLHide"/>
	</html:form>
</c:if>
