<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/javascript/resultsHeader.js" %>

 <div>
	<%-- Show only facet --%>
	<c:if test="${form.displayTopLevelFacet}">
		<c:set value="${form.facetResult.facets[c_facet_tlevel]}" var="facet" />
		<c:if test="${not empty facet && not empty facet.facetValues and fn:length(facet.facetValues)>0}">
			<div id="exlidTopLevelFacetsTile" class="EXLTopLevelFacetsTile">
		  	    <div id="exlidToplevelFacetsContainer" class="EXLToplevelFacetsContainer">
					<!--<h3><fmt:message key="results.showonly"/></h3>-->
			    	<ul id="exlidToplevelFacetsRibbon" class="EXLToplevelFacetsRibbon nav nav-pills nav-justified">
						<c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status" end="4" >
							<c:url value="${form.reqDecUrl}" var="facet_url">
								<c:param name="ct" value="facet"/>
							 	<c:param name="fctN" value="facet_tlevel"/>
							 	<c:param name="fctV" value="${facetValue.KEY}"/>
							 	<c:param name="rfnGrp" value="show_only"/>
							</c:url>
							<c:choose>
								<c:when test="${status.index==0}"><%-- first toplvl facet --%>
									<c:set var="topLevelFacetSpecialClass">EXLTopLevelFacetFirstItem</c:set>
								</c:when>
								<c:when test="${status.index==(fn:length(facet.facetValues)-1)}"><%-- last toplvl facet --%>
									<c:set var="topLevelFacetSpecialClass">EXLTopLevelFacetLastItem</c:set>
								</c:when>
								<c:otherwise>
									<c:set var="topLevelFacetSpecialClass"></c:set>
								</c:otherwise>
							</c:choose>
							<li class="EXLTopLevelFacetItem ${topLevelFacetSpecialClass}">
									<a href="${fn:escapeXml(facet_url)}"><fmt:message key="facets.facet.tlevel.${facetValue.KEY}"/>
									<span class="EXLParenthesis badge pull-right"><fmt:formatNumber value="${facetValue.VALUE}"/>${form.facetResult.accurate?'':' +'}</span>
                                    </a>
                            </li>
						</c:forEach>
			    	</ul>
				</div>
			</div>
		</c:if>
	</c:if>
	<%-- End only facet --%>

<%--Choose the correct results full vs brief --%>
<c:choose>
	<c:when test="${action=='/action/search' || action=='/action/dlSearch'}">
		<c:set var="result0" value="${form.searchResult.results[0]}"/>
	</c:when>
	<c:otherwise>
		<c:set var="result0" value="${form.searchResultFullDoc[0]}"/>
	</c:otherwise>
</c:choose>
<c:if test="${fn:length(form.refinements)>0}">
	<c:set var="removeFacetTitle"><fmt:message key="refinement.remove" /></c:set>
	<div class="EXLRefinementRibbonWithExclude alert alert-success">
		<div class="EXLRefinementsList">
			<span class="EXLRefinementsListTitle"><fmt:message key="search.header.facets.refined_by"/></span>

			<%--List of refinemets added by the user --%>
			<c:forEach items="${form.refinements}" var="refine" varStatus="refineStatus">
			 	<c:url value="search.do" var="refinemantURL">
					<c:param name="rfnId" value="${refine.refinementid}"/>
			 	</c:url>

				 <c:if test="${refine.facetField eq c_facet_frbrgroupid}" >
					 <%--Need to remove frbg so we will set it to empty --%>
				 	<c:url var="refinemantURL" value="${refinemantURL}">
				 		<c:param name="frbg" value=""/>
				 	</c:url>
				 </c:if>

				<!-- c:set var="displayValue" value='${refine.fvalue}' / -->
				<c:set var="displayValue" value="${fmt:clearLangSuffix(fn:escapeXml(refine.facetField), fn:escapeXml(refine.fvalue))}" />
				<c:if test="${refine.facetField eq c_facet_domain}">
					<c:set var="fvalue">
						${fn:escapeXml(refine.fvalue)}
					</c:set>
					<c:set var="displayValue">
						<fmt:message key="facets.facet.facet_domain.${fvalue}" prefix="facets.facet.facet_domain"/>
					</c:set>
					<c:if test="${displayValue == fvalue}">
						<c:set var="displayValue">
							<fmt:message key="${fmt:replaceLibCode(fvalue, view)}" prefix="dummy"/>
						</c:set>
					</c:if>
				</c:if>

				<c:if test="${facetField == facet_library}">
					<c:set var="displayValue">
							<c:set var="fvalue">
								${fn:escapeXml(refine.fvalue)}
							</c:set>				
						<fmt:message key="${fvalue}" prefix="dummy"/>
					</c:set>
				</c:if>
		
				<c:set var="refType" value="${refine.refinementType}"/>
				<c:set var="refClass" value=""/>
				<c:if test="${refType=='EXCLUDE'}">
					<c:set var="refClass" value="EXLExcludedElement"/>
				</c:if>
				<c:if test="${grpId == null || refine.refinementGroupId != grpId}">
					<c:set var="refClass" value="${refClass} EXLFirstRefinementElement"/>
					<c:if test="${refineStatus.index > 0}">
						</span> <%-- this will close the span that we open in the next line in loop iterations other than the first one --%>
					</c:if>
				</c:if>

				<c:if test="${grpId == null || refineStatus.index==0 || refine.refinementGroupId != grpId}">
					<c:set var="grpId" value="${refine.refinementGroupId}" />
					<span id="exlidRefinement${refineStatus.index}" class="EXLRemoveRefinement">
						<c:choose>
							<c:when test="${fn:startsWith(form.doc, 'TN') || fn:startsWith(form.doc, 'RS')}">
								<fmt:message key="default.facets.search-box.pcgroup"/>
							</c:when>
							<c:otherwise>
								<fmt:message key="facets.search-box.${fn:escapeXml(refine.facetField)}"/>:
							</c:otherwise>
						</c:choose>
				</c:if>
						
						<c:url var="tmp1" value="${fn:escapeXml(refinemantURL)}&amp;${fn:escapeXml(form.reqDecQry)}"/>
						<c:url var="tmp2" value="${fn:replace(tmp1, 'indx','')}"/>
						<c:url var="tmp3" value="${fn:replace(tmp2, 'doc','')}"/>
						<c:url var="tmp4" value="${fn:replace(tmp3, 'lastPagIndx', 'indx')}"/>
						<c:url var="removeRefinementUrl" value="${fn:replace(tmp4, 'lastPag', 'pag')}"/>
					
						<a href="${removeRefinementUrl}" title="${removeFacetTitle}" class="${refClass} btn btn-success">
							<c:if test="${fn:contains(refine.facetField,c_facet_localX)}">
								<c:set var="displayValue">
									<fmt:message key="facets.facet.${fn:escapeXml(refine.facetField)}.${fn:escapeXml(refine.fvalue)}" prefix="facets.facet.${fn:escapeXml(refine.facetField)}"/>
								</c:set>
							</c:if>
							<c:if test="${not (refine.facetField eq c_facet_frbrgroupid)}">
								<strong class="EXLSearchRefinement${fn:escapeXml(refine.facetField)}">${displayValue}</strong>
							</c:if>
                            <span>&times;</span>
							<!--<img id="removeFacet" src="<fmt:message key='ui.images.resultsheaderrefinements.remove'/>" alt="<fmt:message key='refinement.remove'/>" />-->
						</a>
				<c:if test="${refineStatus.index==fn:length(form.refinements)-1}">
					</span>
				</c:if>
			</c:forEach>
		</div>
	</div>
</c:if>
 </div>

<script type="text/javascript">
	addLoadEvent(runThumbnailQueries);
</script>
<noscript>This feature requires javascript</noscript>
