<%@ include file="/views/taglibsIncludeAll.jspf" %>

<c:if test="${recommendationsForm != null}">
	<html:form action="/action/recommend.do">
		<div id="exlidResult${recordResultIndex}-TabHeader" class="EXLTabHeader">
			<div class="EXLTabHeaderContent"></div>
			<div id="exlidTabHeaderButtons${recordResultIndex}" class="EXLTabHeaderButtons">
	          	<prm:sendTo recordId="${recordId}"  pushToTypeList="${form.pushToTypeList}" fromEshelf="${form.fromEshelf}" fn="${form.fn}"  inBasket="${form.inBasket[0]}" tabForm="${recommendationsForm}"/>
			</div>
		</div>

		<c:set var="sourceUrl" value="${recommendationsForm.urlMap[recordId]}"/>
		<div id="exlidResult${recordResultIndex}-TabContent" class="EXLTabContent EXLDetailsTabContent">
			<c:choose>
				<c:when test="${not empty sourceUrl}">
				   	<iframe	src="${sourceUrl}" frameborder="1" scrolling="auto" width="100%" height="360" title="Recommendation from bX">
					</iframe>
	    		</c:when>
	    		<c:otherwise>
	    	 		<div class="EXLRequestSystemFeedback">
	    	 			<span>The record has no recommendation</span>
	    	 		</div>
	    		</c:otherwise>
	    	</c:choose>
    	</div>
		<input type="submit" class="EXLHide"/>
	</html:form>
</c:if>
