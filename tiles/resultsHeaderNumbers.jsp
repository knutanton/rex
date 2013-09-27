<%@ include	 file="/views/taglibsIncludeAll.jspf" %>

<c:if test="${not(form.searchResult.numberOfResults == 0 and resultsFooterDisplay == true)}">
	<c:set value="0" var="switchSort" />
	<c:forEach items='${form.queryTerms}' var="query" varStatus="querystatus" >
		<c:forEach items='${form.queryTerms[querystatus.index].inputs}' var="input" varStatus="status" >
			<c:if test="${input.componentType=='precisionOperator' }">
				<c:set	value="${form.queryTerms[querystatus.index].inputs[status.index]}" var="precisionOp" />
			</c:if>
		</c:forEach>
		<c:if test="${fn:escapeXml(form.values[precisionOp.id])=='begins_with'}">
			<c:set value="1" var="switchSort" />
		</c:if>
	</c:forEach>

	<c:set value="false" var="findTitle" />
	<c:set value="false" var="searchFormSrt" />
	
	<c:if test="${switchSort=='1'}">
	    <c:forEach items='${searchForm.sortByList}' var="option" varStatus="listStatus">
	    		<c:if test="${option=='title'}" >
	    			<c:set	value="found" var="findTitle" />
	    		</c:if>
	    		<c:if test="${option==srtField}" >
	    			<c:set value="found" var="searchFormSrt" />
	    		</c:if>
	    </c:forEach>
	</c:if> 

	<c:set var="defaultTitle" value='<%= request.getParameter("sortTitle") %>'/>
	
	<c:choose>
		<c:when test="${not empty searchForm.frbrSrt}" >
			<c:set var="srtField" value='${searchForm.frbrSrt}'/>
		</c:when>
		<c:otherwise>
			<c:set var="srtField" value='${searchForm.srt}'/>
		</c:otherwise>
	</c:choose>
	
	<c:if test="${switchSort == '1' && findTitle == 'false'}" >
		<div class="EXLSystemFeedback"><fmt:message key='default.error.search.sortfield.title.missing' /></div>
	</c:if>

	<c:if test="${form.searchResult.numberOfResults>=0}">
		<h1 class="text-muted">
			<c:if test="${form.remote and form.searchResult.numberOfResults>0}">
		   		<em><fmt:message key='brief.results.first'/></em>
		   	</c:if>
		  	<c:if test="${form.searchResult.numberOfResults>=0}">
				<c:set var="noScope" value="false"/>
				<c:choose>
					<c:when test="${(searchForm.mode != null) &&(searchForm.mode eq 'BrowseSearch')}">
						<c:choose>
							<c:when test="${(form.refinementsCount == 0) && (searchForm.rfnGrp == null || searchForm.rfnGrp[0] != 'frbr') && param.docCount != null && param.docCount > form.searchResult.numberOfResults }">
							<c:if test="${form.searchResult.numberOfResults <= sessionScope.bulk}">
								<fmt:message key='browse.no.linkedpnx.frbr'>
									<fmt:param value="${form.searchResult.numberOfResults}" />
									<fmt:param value="${searchForm.browseDisplayedEntry}" />
									<fmt:param value="${param.docCount}" />
								</fmt:message>
							</c:if>
							<c:if test="${form.searchResult.numberOfResults > sessionScope.bulk}">
								<fmt:message key='browse.no.linkedpnx_paging.frbr'>
								    <fmt:param value="${form.searchResult.firstResultIndex}" />
								    <fmt:param value="${form.searchResult.lastResultIndex}" />
									<fmt:param value="${form.searchResult.numberOfResults}" />
									<fmt:param value="${searchForm.browseDisplayedEntry}" />
									<fmt:param value="${param.docCount}" />
								</fmt:message>
							</c:if>
							</c:when>
							<c:otherwise>
							   <c:if test="${form.searchResult.numberOfResults <= sessionScope.bulk}">
								<fmt:message key='browse.no.linkedpnx'>
									<fmt:param value="${form.searchResult.numberOfResults}" />
									<fmt:param value="${searchForm.browseDisplayedEntry}" />
								</fmt:message>
								</c:if>
								<c:if test="${form.searchResult.numberOfResults > sessionScope.bulk}">
								<fmt:message key='browse.no.linkedpnx_paging'>
								    <fmt:param value="${form.searchResult.firstResultIndex}" />
								    <fmt:param value="${form.searchResult.lastResultIndex}" />
									<fmt:param value="${form.searchResult.numberOfResults}" />
									<fmt:param value="${searchForm.browseDisplayedEntry}" />
								</fmt:message>
								</c:if>
							</c:otherwise>
						</c:choose>
						<c:set var="noScope" value="true"/>
					</c:when>
					<c:otherwise>
					<c:if test="${form.presentPaging}">
					    <c:if test="${form.searchResult.numberOfResults > sessionScope.bulk}"> 
					      <span class="EXLDisplayedCount EXLBriefResultsPaginationPageCount">
					      <fmt:message key='brief.results.results_of'>
					      <fmt:param value="${form.searchResult.firstResultIndex}" />
					      <fmt:param value="${form.searchResult.lastResultIndex}" />
					      </fmt:message>
		  	        </span>
		  	            </c:if>
		            </c:if>
						<em>
					  		<fmt:formatNumber value="${form.searchResult.numberOfResults}" />
					 		<c:if test="${form.searchResult.numberOfResults>0}">
							 	<c:if test="${form.searchResult.maxNumberOfResults>0 and fn:length(form.refinements)==0}">
							 		(<fmt:message key='brief.results.outof' />&nbsp;
							 		<fmt:formatNumber value="${form.searchResult.maxNumberOfResults}" />)
							 	</c:if>
				  			</c:if>
			  			</em>
			  			<c:if test="${!form.presentPaging or form.searchResult.numberOfResults <= sessionScope.bulk}">
						<fmt:message key='results.rescount' />
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${not empty searchForm.scp.selectedScopesId && noScope == 'false'}">
				&nbsp;<fmt:message key="results.scopes.for"/>
				<em>
				<c:if test="${searchForm.scp.selectedScopesId == 'Selected_Databases'}">
				<fmt:message key='scopes.option.current.selected'/>
			    </c:if>
                <c:if test="${searchForm.scp.selectedScopesId != 'Selected_Databases'}">
				<fmt:message key='scopes.option.${searchForm.scp.selectedScopesId}'/>
			    </c:if>
				</em>
			</c:if>

		</h1>
	</c:if>

    <%@ include file="resultsHeaderNavigation.jsp" %>

	<div class="EXLResultsSortBy">
		<!--<span class="EXLResultsSortByLabel"><fmt:message key='results.sortby' /></span>
		<span class="EXLResultsSortBySelected">
			<a href="#" title="<fmt:message key='results.tooltip.sortby'/>">
				<fmt:message key="results.sortby.option.${fn:escapeXml(srtField)}"/>					
			</a>
		</span>-->
		<input type="hidden" name="searchForm.frbrSrt" value=""/>
		<div class="EXLResultsSortByMenu btn-group">
            <ul class="nav nav-tabs">
                <li>
                    <button id="refine" class="btn btn-toolbar" name="refine" data-toggle="collapse" href=".index" >Refine Button</button>
                </li>
                <li>
                    <c:if test="${!form.displayGeneralPageActionsOnTop}">
                        <!--RSS, Save Search and Add page to e-Shelf Links-->
                        <%@ include file="generalPageActions.jspf" %>
                    </c:if>
                </li>
                <li>

            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                <span class="EXLResultsSortByLabel"><fmt:message key='results.sortby' /></span> <fmt:message key="results.sortby.option.${fn:escapeXml(srtField)}"/>&nbsp;<span class="caret"></span>
            </button>

	        <ul class="EXLResultsSortByMenuShow EXLResultsSortByMenuHide dropdown-menu" role="menu"><!--remove EXLResultsSortByMenuHide to show menu items-->
				<c:set var="SendToArrowImageUrl"><img src="<fmt:message key="ui.images.resultsheadernumbers.arrowsendto"/>" alt="<fmt:message key='results.tooltip.sortby'/>"/></c:set>
		 		<c:choose>
					<c:when test="${switchSort=='1'}">
						<c:choose>
							<c:when test="${findTitle=='found'}">
								<c:forEach items='${searchForm.sortByList}' var="option" varStatus="listStatus">
									<c:set var="showHide" value=""/>
									<c:choose>
										<c:when test="${defaultTitle=='noChange' && (srtField==option)}">
											<c:set var="showHide" value="EXLSortByLinkSelected sr-only"/>
										</c:when>
			  							<c:when test="${'title'==option}">
			  								<c:set var="showHide" value="EXLSortByLinkSelected sr-only"/>
			  							</c:when>
									</c:choose>

									<li class="EXLSortByLink ${showHide}">
										<c:choose>
											<c:when test="${searchForm.srt==option}">
									  			<fmt:message key='results.sortby.option.${option}' /> hello
											</c:when>
				  							<c:otherwise>
									  			<a href="search.do?srt=${option}&amp;srtChange=true&amp;${fn:escapeXml(searchForm.reqDecQry)}&amp;sortTitle=noChange" title="">
									  				<fmt:message key='results.sortby.option.${option}' />
									  			</a>
								  			</c:otherwise>
							  			</c:choose>
									</li>
					  			</c:forEach>
			  				</c:when>
			  				<c:otherwise>
			  					<c:set var="count" value="1"/>
			  					<c:forEach items='${searchForm.sortByList}' var="option" varStatus="listStatus">
			  						<c:choose>
										<c:when test="${searchFormSrt =='found'}">
											<li class="EXLSortByLink ${(srtField==option)?'EXLSortByLinkSelected sr-only':''}">
												<c:choose>
													<c:when test="${searchForm.srt==option}">
											  			<fmt:message key='results.sortby.option.${option}' />
													</c:when>
						  							<c:otherwise>
											  			<a href="search.do?srt=${option}&amp;srtChange=true&amp;${fn:escapeXml(searchForm.reqDecQry)}" title="">
											  				<fmt:message key='results.sortby.option.${option}' />
											  			</a>
										  			</c:otherwise>
									  			</c:choose>
											</li>
										</c:when>
			  							<c:otherwise>
			  								<c:set var="showHide" value=""/>
			  								<c:choose>
												<c:when test="${(srtField=='scdate') && ('date'==option)}">
													<c:set var="showHide" value="EXLSortByLinkSelected sr-only"/>
												</c:when>
												<c:when test="${(srtField=='') && ('rank'==option)}">
													<c:set var="showHide" value="EXLSortByLinkSelected sr-only"/>
												</c:when>
												<c:when test="${(srtField=='screator') && ('author'==option)}">
													<c:set var="showHide" value="EXLSortByLinkSelected sr-only"/>
												</c:when>
			  									<%--c:when test="${'1'==count}">
			  										<c:set var="showHide" value="EXLSortByLinkSelected"/>
			  									</c:when--%>
											</c:choose>

											<li class="EXLSortByLink ${showHide}">
												<c:choose>
													<c:when test="${searchForm.srt==option}">
											  			<fmt:message key='results.sortby.option.${option}' />
													</c:when>
						  							<c:otherwise>
											  			<a href="search.do?srt=${option}&amp;srtChange=true&amp;${fn:escapeXml(searchForm.reqDecQry)}" title="">
											  				<fmt:message key='results.sortby.option.${option}' />
											  			</a>
										  			</c:otherwise>
									  			</c:choose>
											</li>
			  							</c:otherwise>
									</c:choose>
									<c:set var="count" value="${count+1}"/>
					  			</c:forEach>
			 				</c:otherwise>
						</c:choose>
			  		</c:when>
			  		<c:otherwise>
						<c:forEach items='${searchForm.sortByList}' var="option" varStatus="listStatus">
					  		<li class="EXLSortByLink ${(srtField==option)?'EXLSortByLinkSelected sr-only':''}">
								<c:choose>
									<c:when test="${srtField==option}">
							  			<fmt:message key='results.sortby.option.${option}' />
									</c:when>
		  							<c:otherwise>
										<c:set var="resortUrlPrefix" value="search.do?" />
										<c:set var="resortUrlSuffix" value="srt=${option}&amp;srtChange=true&amp;${fn:escapeXml(searchForm.reqDecQry)}" />
				  						<c:if test="${searchForm.alma}">
											<c:set var="resortUrlPrefix" value="dlSearch.do?" />
										</c:if>										
										<a href="${resortUrlPrefix}${resortUrlSuffix}" title="">
							  				<fmt:message key='results.sortby.option.${option}' />
							  			</a>
						  			</c:otherwise>
					  			</c:choose>
					  		</li>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</ul>
            </li>
            </ul>
		</div>
	</div>
	<c:if
		test="${(searchForm.rfnGrp == null || searchForm.rfnGrp[0] != 'frbr') && (searchForm.mode != null) &&(searchForm.mode eq 'BrowseSearch')}">
		<c:url value="search.do" var="BackToBrowseSearch">
			<c:param name="fn" value="BrowseSearch" />
			<c:param name="isBack" value="true" />
			<c:param name="browseField" value="${form.searchField}" />
			<c:param name="basicSearchTxt(freeText0)" value="${form.searchTxt}" />
			<c:param name="searchTxt(freeText0)" value="${form.lastTerm}" />
			<c:param name="vid" value="${form.vid}" />
		</c:url>
		<div id="exlidBrowseFooterNavigation" class="EXLBackToResults">
			<a href="${BackToBrowseSearch}"
				title="<fmt:message key='browse.back.to.${form.searchField}s' />">
				<fmt:message key="browse.back.to.${form.searchField}s" />
			</a>
		</div>
	</c:if>
</c:if>

