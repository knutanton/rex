<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@page import="com.exlibris.primo.srvinterface.FacetResultDTO" %>
<%@ taglib uri="/WEB-INF/tlds/exlibris-ajax.tld" prefix="eas" %>
<button id="refine" class="btn btn-lg btn-primary btn-block " name="refine" data-toggle="collapse" href=".index"><span
        class="glyphicon glyphicon-filter"></span></button>


<c:if test="${form.displayGeneralPageActionsOnTop && not empty form.searchResult.results}">
    <!--RSS, Save Search and Add page to e-Shelf Links-->
    <%@ include file="generalPageActions.jspf" %>
</c:if>

<h2 class="EXLFacetsTitle hide">Refine Search Results</h2>
<c:set value="${form.vid}" var="view"/>
<%-- Vertical facet --%>
<c:set value="true" var="chagedPCAvailMode"/>
<c:if test="${form.pcAvailabiltyMode == 'true'}">
    <c:set value="false" var="chagedPCAvailMode"/>
</c:if>

<%-- This loop is required for Date Facet Slider--%>
<c:forEach items="${form.facetResult.facetOrder}" var="facetField"
        varStatus="facetIndex">
        <c:set value='${form.filteredFacetResult.facets[facetField]}'
                var="facet" />
        <c:set var="fctN">${facetField eq c_facet_instsort? c_facet_library : facetField}</c:set>
        <c:if test="${fctN=='facet_creationdate'}">
                <c:set value='${facet.facetValues[0]}' var="facetValue" />
                <c:if test="${facetValue != null}">
                        <c:set value='true' var="isCreationFacetExist" />
                        <c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status" >
                                <%@ include file="/tiles/facetsTextStartLabel.jspf"%>
                                <c:if test="${not empty displayValue}">
                                        <c:set value='${displayValue}' var="startDateDisplay" />
                                </c:if>
                        </c:forEach>
                        <input type="hidden" id="startDateDisplay" value="${startDateDisplay}" />
                        <c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status" >
                                <%@ include file="/tiles/facetsTextEndLabel.jspf"%>
                                <c:if test="${not empty displayValue}">
                                        <c:set value='${displayValue}' var="endDateDisplay" />
                                </c:if>
                        </c:forEach>
                        <input type="hidden" id="endDateDisplay" value="${endDateDisplay}" />
                </c:if>
        </c:if>
</c:forEach>


<c:if test="${form.displayTopLevelSideFacet}">
    <c:set value="${form.facetResult.facets[c_facet_tlevel]}" var="facet"/>
    <c:if test="${not empty facet && not empty facet.facetValues and fn:length(facet.facetValues)>0}">
        <div id="facetListTopLevel" class="EXLFacetList EXLTopLevelFacetList">
            <div class="EXLFacetContainer">
                <h3><fmt:message key="results.showonly"/></h3>
                <ol id="exlidFacetSublistX" class="EXLFacetsList EXLFacetsListPreview">
                    <c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status" end="4">
                        <c:url value="${form.reqDecUrl}" var="facet_url">
                            <c:param name="ct" value="facet"/>
                            <c:param name="fctN" value="facet_tlevel"/>
                            <c:param name="fctV" value="${facetValue.KEY}"/>
                            <c:param name="rfnGrp" value="show_only"/>
                        </c:url>
                        <li class="EXLFacet">
                            <a href="${fn:escapeXml(facet_url)}"><fmt:message
                                    key="facets.facet.tlevel.${facetValue.KEY}"/>
                            </a>&nbsp;<span class="EXLParenthesis">(<fmt:formatNumber
                                value="${facetValue.VALUE}"/>${form.facetResult.accurate?'':' +'})</span>
                        </li>
                    </c:forEach>
                </ol>
            </div>
        </div>
    </c:if>
</c:if>

<c:forEach items="${form.searchResult.salResults}" var="sal_result" varStatus="sal_resultStatus">
    <c:if test="${sal_resultStatus.index==0}">
        <div class="EXLFacetList EXLTopLevelFacetList">
            <div class="EXLFacetContainer">
                <h3><fmt:message key="results.Additional_Results"/></h3>
                <ol class="EXLFacetsList EXLSearchAndLinkList">
    </c:if>
    <c:set var="titleStrArr" value="${fn:split(sal_result.values[c_value_title][0],'$$V')}"/>
    <c:set var="resource" value="${fn:escapeXml(titleStrArr[0])}"/>
    <c:choose>
        <c:when test="${titleStrArr[1] == '0'}">
        </c:when>
        <c:otherwise>
            <c:set var="quantity">
                <c:choose>
                    <c:when test="${fn:contains(titleStrArr[1], '88888888')}">0</c:when>
                    <c:otherwise>${titleStrArr[1]}</c:otherwise>
                </c:choose>
            </c:set>
            <c:set var="method" value="${sal_result.values[c_value_publisher][0]}"/>
            <li class="EXLFacet EXLSearchAndLinkResource">
                <c:choose>
                    <c:when test="${method=='POST'}">
                        <a id="salLink${sal_resultStatus.index}" title="${titleStrArr[0]}" href="#" target="popup"
                           onclick="submitForm(document.getElementById('sal_${sal_resultStatus.index}')); return false;"><fmt:message
                                key="sal.resources.${resource}" prefix="sal.resources"/>
                        </a>

                        <form method="post" id="sal_${sal_resultStatus.index}"
                              action="${fn:substringBefore(sal_result.values[c_value_source][0], '?')}"
                              target="searchAndLinkPopup" class="EXLSearchAndLinkForm EXLHide">
                            <c:set var="MLQuery"
                                   value="${fn:substringAfter(sal_result.values[c_value_source][0], '?')}"/>
                            <c:forTokens items="${MLQuery}" delims="&" var="url_param">
                                <input type="hidden" name="${fn:substringBefore(url_param, '=')}"
                                       value="${fn:substringAfter(url_param, '=')}"/>
                            </c:forTokens>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <a id="salLink${sal_resultStatus.index}" title="${titleStrArr[0]}"
                           href="${fn:escapeXml(sal_result.values[c_value_source][0])}" target="popup">
                            <fmt:message key="sal.resources.${resource}" prefix="sal.resources"/>
                        </a>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${quantity==0}"></c:when>
                    <c:otherwise>
                        <c:catch var="catchException">
                            <span class="EXLParenthesis">(<fmt:formatNumber value="${quantity}"/>)</span>
                        </c:catch>
                        <c:if test="${catchException!=null}">
                            <span class="EXLParenthesis"></span>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </li>
        </c:otherwise>
    </c:choose>
    <c:if test="${sal_resultStatus.index==(fn:length(form.searchResult.salResults)-1)}">
        </ol>
        </div>
        </div>
    </c:if>
</c:forEach>

<a id="refine" name="refine"></a>
<%--Display the content of this page only if we have results --%>
<c:if test="${form.searchResult.numberOfResults>0 and form.facetResult.displayFacets}">
    <div id="facetList" class="EXLFacetList facet-collapse slide index panel-group">
        <c:if test="${form.scp.showPCAvailabilityCheckbox}">
            <c:if test="${form.mode == 'Basic' or (form.mode == 'Advanced' and !form.showFullText)}">
                <c:url value="${form.reqDecUrl}" var="pc_avail_url">
                    <c:param name="ct" value="facet"/>
                    <c:param name="pcAvailabiltyMode" value="${chagedPCAvailMode}"/>
                </c:url>

                <div class="EXLFacetList EXLTopLevelFacetList checkbox">
                    <div class="EXLFacetContainer">


                        <html:checkbox name="searchForm" property="pcAvailabiltyMode" styleClass="uncheckable"
                                       styleId="pcAvailabiltyMode"
                                       onclick="location.replace('${fn:escapeXml(pc_avail_url)}');"/>
                        &nbsp;&nbsp;<label for="pcAvailabiltyMode"><fmt:message key="expandresults"/></label>

                    </div>
                </div>
            </c:if>
        </c:if>
        <c:set var="facetTitleDisplayed" value="false"/>
        <c:forEach items="${form.facetResult.facetOrder}" var="facetField" varStatus="facetIndex">
            <c:set value='${form.filteredFacetResult.facets[facetField]}' var="facet"/>

            <%-- if we less then two facets do not display them--%>
            <c:if test="${not empty facet && not empty facet.facetValues and (facet.count>1 or (facet.count>0 and facetField == c_facet_domain and form.remote)) and (fn:length(facet.facetValues)>1 or (fn:length(facet.facetValues)>0 and facetField == c_facet_domain and form.remote))}">
                <c:set var="facetName" value="${facet.name}"/>

                <div id="exlidFacet${facetIndex.index}" class="EXLFacetContainer panel panel-default">
                    <%--<c:if test="${facetTitleDisplayed=='false'}">
                             <h1><fmt:message key="facets.title"/></h1>
                             <c:set var="facetTitleDisplayed" value="true"/>
                         </c:if>--%>

                    <%--Facet Title e.g: Subject --%>
                    <c:choose>
                        <c:when test="${facetField eq c_facet_instsort}">
                            <h4><fmt:message key="facets.facet.facet_library_otherinstitution"/>&nbsp;</h4>
                        </c:when>
                        <c:when test="${(facetField eq c_facet_library) and form.libInstSort}">
                            <h4><fmt:message key="facets.facet.facet_library_myinstitution">
                                <fmt:param>
                                    ${sessionScope.institutionFromCT}
                                </fmt:param>
                            </fmt:message></h4>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${form.remote && facetField eq 'facet_domain'}">
                                <a class="EXLRemoteDatabasesMoreInfo" href="search.do?${action_func}=dbs"
                                   target="databases"
                                   onclick="openWindow(this.href, this.target, 'top=100,left=50,width=600,height=350,resizable=1,scrollbars=1'); return false;">(<fmt:message
                                        key="remote.db.list.more.info"/>)</a>
                            </c:if>

                            <div class="panel-heading">
                                <h4 class="EXLFacetTitleLabelPHolder${facetField} panel-title">
                                    <a title="<fmt:message key='facets.moreoptions.tooltip'/>"
                                       id="exlidFacet${facetIndex.index}-more" class="btn-block" data-toggle="collapse"
                                       data-parent="#facetList${facetIndex.index}"
                                       href="#exlidFacetSublist${facetIndex.index}">
                                        <fmt:message key="facets.facet.${facetField}"/>&nbsp;
                                    </a>
                                </h4>
                            </div>
                        </c:otherwise>
                    </c:choose>


                    <ul id="exlidFacetSublist${facetIndex.index}"
                        class="EXLFacetsList EXLFacetsListPreview nav nav-pills nav-stacked panel-collapse collapse">
                         <%-- Adding Date Facet Slider --%>
                        <c:if test="${facetField eq c_facet_creationdate}">
                            <c:if test="${isCreationFacetExist == true}">
                                <div class="EXLDateRangeText">
                                    <div class="EXLDateRangeLine">
                                        <c:url var="slider_url" value="${form.responseEncodeReqDecUrl}" >
                                            <c:param name="ct" value="facet"/>
                                            <c:param name="fctN" value="xxx"/>
                                            <c:param name="fctV" value="xxx"/>
                                            <c:param name="rfnGrp" value="${form.rfnGrpCounter + 1}"/>
                                            <c:param name="rfnGrpCounter" value="${form.rfnGrpCounter + 1}"/>
                                        </c:url>
                                        <span class="EXLSliderFromText"><fmt:message key="facets.date.slider.from"/></span>
                                        <input type="hidden" id="sliderURL" value="${slider_url}" />
                                        <label class="EXLHide" for="startdate">
                                            <fmt:message key="facets.date.slider.The start date used in the slider bar of creation date facet"/>
                                        </label>
                                        <input type="text" onchange="onTBChange('start');" onkeyup="afterClick(this);" maxlength="4" size="3" id="startdate"
                                                class="datebox" value="${startDateDisplay}" />
                                        <span class="EXLSliderToText"><fmt:message key="facets.date.slider.to"/></span>
                                        <label class="EXLHide" for="enddate">
                                            <fmt:message key="facets.date.slider.The end date used in the slider bar of creation date facet"/>
                                        </label>
                                        <input type="text" onchange="onTBChange('end');" onkeyup="afterClick(this);" maxlength="4" size="3" id="enddate"
                                                class="datebox" value="${endDateDisplay}" />
                                        <div class="EXLSliderRefine">
                                            <a id="dateSubmit"><fmt:message key="facets.date.slider.refine" /></a>
                                        </div>
                                    </div>
                                    <div id="slider-range" class="EXLSliderContainer"></div>
                                </div>
                            </c:if>
                        </c:if>


                        <c:set var="maxDisplayCount" value="${facet.maxDisplayCount}"/>
                        <c:set var="rfnGrp">${form.rfnGrpCounter + 1}</c:set>
                        <c:forEach items="${facet.facetValues}" var="facetValue" varStatus="status">
                            <%@ include file="facetsTextLabel.jspf" %>
                            <%-- build url for the facet--%>
                            <c:set var="fctN">${facetField eq c_facet_instsort? c_facet_library : facetField}</c:set>
                            <c:set var="fctV">${facetValue.KEY}</c:set>
                            <c:url var="facet_url" value="${form.responseEncodeReqDecUrl}">
                                <c:param name="ct" value="facet"/>
                                <c:param name="fctN" value="${fctN}"/>
                                <c:param name="fctV" value="${fctV}"/>
                                <c:param name="rfnGrp" value="${rfnGrp}"/>
                                <c:param name="rfnGrpCounter" value="${rfnGrp}"/>
                            </c:url>

                            <%-- class to initially hide extra facets --%>
                            <c:choose>
                                <c:when test="${status.index>=maxDisplayCount}">
                                    <c:set var="hiddenFacet">EXLAdditionalFacet</c:set>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="hiddenFacet"></c:set>
                                </c:otherwise>
                            </c:choose>

                            <%--
                                   <li class="EXLFacet EXLFacetChecked">
                                       <input id="exlidFacet4-2" type="checkbox" value="0"/><label for="exlidFacet4-1" class="EXLHide">label placeholder</label>
                                       <span class="label"><a href="#" title="title placeholder">All</a></span> <span>(110))</span>
                                   </li>
                                   --%>
                            <li class="EXLFacet ${hiddenFacet}">
                                <a href="${facet_url}"
                                   id="exlidFacet${facetIndex.index}-${status.index}">${displayValue}
                                    <c:if test="${!fn:contains(form.scp.scps, 'EbscoLocal') and !fn:contains(form.scp.scps, 'WorldCatLocal')}">
									<span class="EXLFacetCount badge pull-right">
										<fmt:formatNumber
                                            value="${facetValue.VALUE}"/>${form.facetResult.accurate?'':' +'}
									</span>
                                    </c:if>
                                </a>
                            </li>
                        </c:forEach>
                        <li class="EXLFacetsDisplayMore"><a href="#"
                                                            title="<fmt:message key='facets.moreoptions.tooltip'/>"
                                                            id="exlidFacet${facetIndex.index}-more">
                            <fmt:message key='facets.moreoptions'/>&nbsp;<img
                                src="<fmt:message key='default.ui.images.facetstitle.opensubmenu'/>"
                                alt="open sub menu"/></a>
                        </li>

                    </ul>
                </div>
            </c:if>

        </c:forEach>
    </div>
</c:if>

<%--<jsp:include page="suggestedSearchTile.jsp"/>

<c:if test="${!form.displayGeneralPageActionsOnTop && not empty form.searchResult.results}">
	<!--RSS, Save Search and Add page to e-Shelf Links-->
	<%@ include file="generalPageActions.jspf" %>
</c:if>
--%>
<!--end EXLFacetList-->
