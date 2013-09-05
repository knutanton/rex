<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/javascript/TitleSearch.js" %>
<!-- searchLimitsTile.jsp begin -->
<c:set var="primoView"  value="${sessionScope.primoView}"/>
<c:if test="${searchForm == null}">
<c:set var="searchForm" value="${displayForm}" scope="request"/>
</c:if>
<c:set value="${searchForm.queryTerms[1].inputs[0]}"	var="currentInput" />
<c:set var="displayAtAll" value="false" />
<c:if test="${fn:length(currentInput.options) gt 1}">
	<c:set var="displayAtAll" value="true" />
</c:if>
<c:forEach	var='currentInput' items='${searchForm.queryTerms[0].inputs}' begin='1' varStatus="status">
	<c:if test="${fn:length(currentInput.options) gt 1}">
		<c:set var="displayAtAll" value="true" />
	</c:if>
</c:forEach>

<c:if test="${fn:length(searchForm.queryTerms[0].inputs) gt 1 and displayAtAll}">
<div id="exlidHeaderSearchLimits" class="container">
      <fieldset>
      <legend class="EXLHiddenCue sr-only"> <prm:userText styleId="search-simple" type="openingText" inline="true"/></legend>
      <span class="EXLHeaderSearchLimitsFields">
		<span class="EXLHeaderSearchLimitsFieldsTitle">
		<prm:userText styleId="search-simple" type="openingText" inline="true"/>
		</span>

		<c:set value="${searchForm.queryTerms[1].inputs[0]}"	var="currentInput" />		
			<c:if test="${fn:length(currentInput.options) gt 1}">
				<span class="EXLHiddenCue sr-only"><prm:userText styleId="search-simple" type="lookForText" inline="true"/></span>
				<prm:select selectForm="${searchForm}" input="${currentInput}" styleClass="blue EXLSimpleSearchSelect" valueOptionsPrefix='search-simple' count="1"/>
			</c:if>		
		<%--Read the components to display the second and third --%>
		<c:forEach	var='currentInput' items='${searchForm.queryTerms[0].inputs}' begin='1' varStatus="status">
			<c:if test="${fn:length(currentInput.options) gt 1}">
	    	<span class="EXLHide sr-only">
				<span class="EXLHide sr-only"><fmt:message key="search-simple.search.limits.hidden.label"/></span>
				<c:if test="${fn:endsWith(currentInput.id,'1UI0')}">
					<prm:userText styleId="search-simple" type="lookInText" inline ="true"/>
				</c:if>
				<c:if test="${currentInput.id !='1UI0' && fn:endsWith(currentInput.id,'UI0')}">
					<prm:userText styleId="search-simple" type="operatorText" inline ="true"/>
				</c:if>
			</span>
				<prm:select selectForm="${searchForm}" input="${currentInput}" styleClass="blue EXLSimpleSearchSelect" valueOptionsPrefix='search-simple' count="1"/>
			</c:if>
		</c:forEach>
 	  <prm:userText styleId="search-simple" type="endingText" inline="true"/>hello
      <input name="Submit" type="submit" class="btn btn-default" value="Apply Search Limits"/>

      <input name="Reset" type="reset" class="btn btn-default" value="Clear Limits"/>
      </span>
      </fieldset>
</div>
</c:if>
<!-- searchLimitsTile.jsp end -->
