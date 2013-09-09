<!-- suggestedSearchTile.jsp begin -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<c:if test="${form.searchResult.numberOfResults>0 and form.facetResult.displayRelatedFacets}" >
<div id="exlidSuggestedList" class="EXLFacetList">
	<a name="suggested"></a>

	<%--defect #1934 --%>
	<c:set var="mediatypeComponetId" value="${form.componentType2ComponentIds[c_ctype_mediatype][0]}"/>
	<c:set var="percisionOperatorComponetId" value="${form.componentType2ComponentIds[c_ctype_precision][0]}"/>
	<%--defect #1934 --%>

	<c:forTokens items="${form.facetResult.relatedFacetIds}" delims="," var="facetField" varStatus="facetIndex">

			<c:set value='${form.facetResult.relatedFacets[facetField]}' var="facet" />
			<c:if test="${not empty facet && not empty facet.facetValues}">
				<div class="EXLFacetContainer EXLRelatedSearchTopic EXLRelatedSearchTopicFIELD${facetField}">
<c:if test="${facetIndex.index==0}">
	<h3 class="EXLSuggestedSearchesTitle"><fmt:message key='related.label.title'/> </h3>
	<span class="EXLSuggestedSearchesDescription"><fmt:message key='related.label.description'/></span>


           <div class="EXLFacetContainer">
               <ol class="EXLFacetsList">
				<li class="EXLFacet">
					<html:checkbox name="searchForm"  property="pcAvailabiltyMode" styleClass="uncheckable" styleId="pcAvailabiltyMode" onclick="location.replace('${fn:escapeXml(pc_avail_url)}');" />
								&nbsp;&nbsp;<label for="pcAvailabilityMode"><fmt:message key="expandresults"/></label>
				</li>
		    </ol>
           </div>
       
</c:if>
				<%--Facet Title e.g: On this subject --%>
					<h4><fmt:message key="related.label.${facetField}"/>:</h4>
					<ol class="EXLFacetsList EXLFacetsListPreview"><!-- id="first_${facetField}" -->
						<%--We are limiting the number of facets to 5 --%>
						<c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status" end="4" >
								<%--Removing language suffix,QC 4603 --%>
								<c:set var="valueWithoutLangSuffix" value="${fmt:clearLangSuffix(facetField, facetValue.KEY)}"/>
								<%--Format date in the case we need to display them --%>
								<c:set var="displayValue" value="${valueWithoutLangSuffix}" />
								<c:if test="${facetField == 'facet_creationdate'}">
									<c:set var="displayValue">
										<%=com.exlibris.primo.srvinterface.FacetResultDTO.formatRangeDates(((com.exlibris.jaguar.xsd.search.FACETVALUESDocument.FACETVALUES)pageContext.getAttribute("facetValue")).getKEY(), request)%>
									</c:set>
								</c:if>

					<%--defect #1934 --%>
					<c:set var="scopeComponetId" value="${form.componentType2ComponentIds[c_ctype_scope][0]}"/>
					<%--defect #1934 --%>

								<c:url value="search.do" var="new_search_url">
									<c:param name="${action_func}" value="search"/>
								 	<c:param name="vl(${c_ctype_freetext}0)" value="${valueWithoutLangSuffix}" />
								 	<c:param name="tab" value="${form.tab}"/>
								 	<c:param name="mode" value="${form.mode}"/>
							 		<c:param name="scp.scps" value="${form.scp.scps}"/>
							 		<c:param name="vid" value="${form.vid}"/>
							 		<%--defect #1934 --%>
							 		<c:if test="${not empty mediatypeComponetId }" >
										<%--We have a valid uicomponet to for mediaType --%>
										<c:param name="vl(${mediatypeComponetId})" value="${form.values[mediatypeComponetId]}"/>
									</c:if>
									<c:if test="${not empty percisionOperatorComponetId }" >
										<%--We have a valid uicomponet to for percisionOperator --%>
										<c:param name="vl(${percisionOperatorComponetId})" value="exact"/>
									</c:if>

							 		<c:if test="${not empty scopeComponetId }" >
										<%--We have a valid uicomponet to for scope --%>
										<c:if test="${facetField eq c_facet_topic}" >
											<c:param name="vl(${scopeComponetId})" value="${c_value_sub}"/>
										</c:if>
										<c:if test="${facetField eq c_facet_creator}" >
											<c:param name="vl(${scopeComponetId})" value="${c_value_author}"/>
										</c:if>

									</c:if>
									<%--defect #1934 --%>
								 </c:url>

							<li class="EXLRelatedSearch EXLRelatedSearchKEY${facetValue.KEY}">
								<a href="${fn:escapeXml(new_search_url)}" onclick="if(isRemoteSearch()){suggestedPleaseWait('${fmt:safeHTMLEntitiesEncode(displayValue)}');}">${fmt:safeHTMLEntitiesEncode(displayValue)}</a>
							</li>
						</c:forEach>
					</ol>
				</div>
			</c:if>
	</c:forTokens>
</div>
</c:if>

<!-- suggestedSearchTile.jsp end -->
