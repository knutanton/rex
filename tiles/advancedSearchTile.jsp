<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/javascript/TitleSearch.js" %>
<c:set var="primoView"  value="${sessionScope.primoView}"/>
<c:if test="${empty resloc}">
	<c:set var="resloc">_self</c:set>
</c:if>
<c:if test="${searchForm == null}">
<c:set var="searchForm" value="${displayForm}" scope="request"/>
</c:if>
<html:form styleId="searchForm" method="post" styleClass="EXLSearchForm" action="/action/search.do?${action_func}=go&amp;ct=search"
		   enctype="application/x-www-form-urlencoded; charset=utf-8"
		   onsubmit="if(isRemoteSearch()){doPleaseWait();}if(window.manualFormSubmit){manualFormSubmit(this.id);return false;}" target="${resloc}">
<div id="exlidAdvancedSearchTile" class="EXLAdvancedSearch">
<div id="exlidAdvancedSearchRibbon">
	<%@ include file="/views/search/search_hidden.jspf" %>

    <fieldset>
    <legend class="EXLHiddenCue">Primo Advanced Search</legend>

<%-- begin tabs handling --%>
<c:if test="${primoView.numberOfTabs > 1}">
<c:set var="resloc"  value="${param.resloc}"/>
<c:set var="embed"  value="${param.embed}"/>
<html:hidden property="tb" styleId="tb" value="t"/>

<%--Build the prefix for the tab url --%>
<c:url value="search.do" var="tab_url">
	 	<c:param name="mode" value="${searchForm.mode}"/>
 		<c:param name="vid" value="${searchForm.vid}"/>
 		<c:choose>
			<c:when test="${not empty embed }">
				<c:if test="${not empty resloc }">
					<c:param name="embed" value="true"/>
					<c:param name="resloc" value="${resloc}"/>
				</c:if>
			</c:when>
		</c:choose>

 		<%--Copy the free text when swiching between tabs--%>
 		<c:if test="${searchForm.tabsRemote}">
			<c:set var="componentIds" value="${searchForm.componentType2ComponentIds[c_ctype_freetext]}"/>
			<c:set var="hasFreeText" value="${false}"/>
			<c:forEach items="${componentIds}" var="freeTextCompId" >
				<c:if test="${not empty searchForm.values[freeTextCompId] }">
	 				<c:param name="vl(${freeTextCompId})" value="${searchForm.values[freeTextCompId]}"/>
	 				<c:set var="hasFreeText" value="${true}"/>
				</c:if>
			</c:forEach>
			<%--Change the fn to search only if we have free text --%>

			<c:if test="${hasFreeText and searchForm.tabsRemote}">
				<c:param name="${action_func}" value="search"/>
			</c:if>

		</c:if>
</c:url>

<%-- render the tabs --%>
<div class="EXLSearchTabsContainer">
    <ul id="exlidSearchTabs" class="EXLTabs">
		<c:forEach items="${primoView.avilableTabs}" var="menu_item"  varStatus="status">
		<c:set var="isRemote"  value="${sessionScope.defaultScope4Tab[menu_item]}"/>
		<c:set var="menuItemLabel"><fmt:message key="tabbedmenu.${menu_item}.label" /></c:set>
			<li id="exlidTab${status.index}" class="EXLSearchTab ${(searchForm.tab == status.current )?'EXLSearchTabSelected':''}">
				<c:set var="defScopeId" value="${searchForm.defaultScp[menu_item]}"/>
				<span id="defaultScope${menu_item}" style='display:none'><fmt:message key='scopes.option.${defScopeId}' /></span> <%-- where is this used? (-hj) --%>
				<a href="${tab_url}&tab=${menu_item}" class="EXLSearchTabTitle EXLSearchTabLABEL${menuItemLabel}" onclick="getSearchField(this,'${searchForm.mode}'); delay4Remote('${isRemote}','${searchForm.tabsRemote} ','${menu_item}')"
				   title="<fmt:message key="tabbedmenu.${menu_item}.tooltip" />">
					<span>${menuItemLabel}</span>
				</a>
			</li>
		</c:forEach>
    </ul>
</div>
</c:if>
<%-- end tabs handling --%>
<%-- begin advanced search render --%>
	<div class="EXLSearchFieldRibbon EXLSearchFieldRibbonPreFilters">
		<div class="EXLSearchFieldRibbonFormFieldsGroup1">
		<div class="EXLAdvancedSearchFormRow">
			<prm:userText styleId="search-advanced" type="openingText" inline="true"/>
		</div>
		<c:set var="count" value="1"/>
				<c:forEach var="queryTerm" items="${searchForm.queryTerms}" varStatus="queryTermStatus">
			<div class="EXLAdvancedSearchFormRow">
            <fieldset id="exlidAdvancedSearchFieldset${queryTermStatus.index}">
				<legend class="EXLHiddenCue">Primo Advanced Search Query Term</legend>
					<c:forEach var="input" items="${queryTerm.inputs}" varStatus="status">
	            <span class="EXLAdvancedSearchFormRowInlineInput">
					<c:if test="${searchForm.location[queryTermStatus.index]=='L'}">
								<c:choose>
									<c:when test="${input.componentType == c_ctype_freetext}">
										<label class="EXLHide" for="input_${input.id}"><%-- accessibility instruction --%>
											Input search text:
										</label>
										<input type="text" id="input_${input.id}" name="vl(${input.id})" value="${fn:escapeXml(searchForm.values[input.id])}"/>
									</c:when>
									<c:otherwise>
										<label class="EXLHide" for="exlidInput_${input.componentType}_${count}">
										Show Results with:
										</label>
										<prm:select selectForm="${searchForm}" input="${input}" styleClass="fixed" valueOptionsPrefix='search-advanced' count="${count}" from="advance"/>
									</c:otherwise>
								</c:choose>

					</c:if>
				</span>
        			</c:forEach>
			</fieldset>
			</div>
			<c:set var="count" value="${count+1}"/>
				</c:forEach>

			<!--prefilters row-->

			<div class="EXLAdvancedSearchFormRow EXLAdvancedSearchFormRowPrefilters">
			<fieldset id="exlidAdvancedSearchFieldsetPreFilters">
			<legend class="EXLHiddenCue">Primo Advanced Search prefilters</legend>
			<span class="EXLAdvancedSearchFormRowInlineInput">
				<c:if test="${searchForm.showPeerReview}">
					<html:checkbox styleId="exlidIncludePeerReviewed" property="includePeerReviewed"/>
					<label for="exlidIncludePeerReviewed"><fmt:message key="search-advanced.prefilter.peer_review"/></label>
				</c:if>
				<c:if test="${searchForm.showFullText}">
					<html:checkbox styleId="exlidIncludeFullText" property="includeFullText"/>
					<label for="exlidIncludeFullText"><fmt:message key="search-advanced.prefilter.full_text_online"/></label>
				</c:if>
			</span>
			</fieldset>
			</div>

		</div>

		<!-- start right column -->
		<div class="EXLSearchFieldRibbonFormFieldsGroup2">
			<c:forEach var="queryTerm" items="${searchForm.queryTerms}" varStatus="queryTermStatus">
					<c:if test="${searchForm.location[queryTermStatus.index]=='R'}">
						<c:choose>
							<c:when test="${searchForm.termType[queryTermStatus.index]=='DateRange'}">
							<div class="EXLAdvancedSearchFormRow">
								<span class="EXLAdvancedSearchFormDateRangeRow">
									<label for="exlidInput_DateRange_Start"><fmt:message key="search-advanced.DateRange.label.DateRangeStart" /></label>
									<c:forEach var="input" items="${queryTerm.inputs}" varStatus="status">
										<c:if test="${status.index < 3}">
											<c:choose>
												<c:when test="${input.componentType == 'drStartYear'}">
													<c:choose>
														<c:when test="${fn:escapeXml(searchForm.values[input.id]) == ''}">
															<input type="text" id="input_${input.id}" name="vl(${input.id})" placeholder="<fmt:message key="search-advanced.DateRange.label.Year" />" />
														</c:when>
														<c:otherwise>
															<input type="text" id="input_${input.id}" name="vl(${input.id})" value="${fn:escapeXml(searchForm.values[input.id])}" />
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													<prm:select selectForm="${searchForm}" input="${input}" styleClass="fixed" valueOptionsPrefix='search-advanced'/>
												</c:otherwise>
											</c:choose>
										</c:if>
									</c:forEach>
								</span>
								</div>
								<div class="EXLAdvancedSearchFormRow">
								<span class="EXLAdvancedSearchFormDateRangeRow">
									<label for="exlidInput_DateRange_Start"><fmt:message key="search-advanced.DateRange.label.DateRangeEnd" /></label>
									<c:forEach var="input" items="${queryTerm.inputs}" varStatus="status">
										<c:if test="${status.index >= 3}">
											<c:choose>
												<c:when test="${input.componentType == 'drEndYear'}">
													<c:choose>
														<c:when test="${fn:escapeXml(searchForm.values[input.id]) == ''}">
															<input type="text" id="input_${input.id}" name="vl(${input.id})" placeholder="<fmt:message key="search-advanced.DateRange.label.Year" />" />
														</c:when>
														<c:otherwise>
															<input type="text" id="input_${input.id}" name="vl(${input.id})" value="${fn:escapeXml(searchForm.values[input.id])}" />
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
													<prm:select selectForm="${searchForm}" input="${input}" styleClass="fixed" valueOptionsPrefix='search-advanced'/>
												</c:otherwise>
											</c:choose>
										</c:if>
									</c:forEach>
								</span>
								</div>
							</c:when>
							<c:otherwise>
								<div class="EXLAdvancedSearchFormRow">
									<span class="EXLAdvancedSearchFormRowInlineInput">
										<c:forEach var="input" items="${queryTerm.inputs}" varStatus="status">
											<label for="exlidInput_${input.componentType}_"><fmt:message key="search-advanced.${input.componentType}.label.${status.index}" /></label>
											<prm:select selectForm="${searchForm}" input="${input}" styleClass="fixed" valueOptionsPrefix='search-advanced'/>
										</c:forEach>
									</span>
								</div>
							</c:otherwise>
						</c:choose>
					</c:if>
				</c:forEach>
				<c:if test="${empty searchForm.scp.scopesOptions}">
					<div class="EXLAdvancedSearchFormRow">
						<prm:userText styleId="search-advanced" type="endingText" inline="true"/>
					</div>
				</c:if>
        <!-- static closing parts of right column -->
<%-- render scope drop down and find databases --%>
                <div id="scopesListAdvancedSearch">
                <%@ include file="advancedSearchScopesList.jspf" %>
               </div>
</div>
<%-- end render scope drop down --%>



		</div><!-- end right column -->



<%-- submit button and simple search link --%>
        <div class="EXLSearchFieldRibbonFormSubmitSearch">
            <input id="goButton" name="Submit" type="submit" value='<fmt:message key="link.title.search.search"/>' class="submit"/>
        </div>
 			<c:url value="search.do?${requestScope.switchModeURL_reqDecQryUTF8}" var="simple_search_url">
						<c:param name="mode" value="${c_basic_search}"/>
						<c:param name="ct" value="BasicSearch"/>
			</c:url>
			<c:set var="basic_search_title"><fmt:message key="link.title.advanced.search.basic.search"/></c:set>

       <div class="EXLSearchFieldRibbonFormLinks">
           <span class="NEWSearchFieldRibbonNewSearchLink">
                    <a href="<fmt:message key='new_search_url_advanced'/>" title="<fmt:message key='link.title.search.new_search'/>">
                       <fmt:message key="label.new_search" />
                    </a>
            </span>
         <a href="${fn:escapeXml(simple_search_url)}" title="${basic_search_title}"><fmt:message key="label.simple_search" /></a>
       </div>
        </fieldset>
<%-- end submit button and simple search link --%>



<%-- end advanced search render --%>



</div>
</div>
</html:form>

