<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/views/taglibsIncludeAll.jspf" %>

<!-- If we have result in the request the page was called for printable display -->
<c:if test="${empty requestScope.result}">
        <c:set var="result" value="${displayForm.searchResultFullDoc[0]}"/>
</c:if>
<c:set var="recordid" value="${result.id}"/>
<c:set var="record" value='${requestScope["recommendationData"]}' />
<c:set var="fromEshelf" value="${displayForm.fromEshelf}"/>
<script type="text/javascript" src="../javascript/primo_boomerang.js"></script>
<noscript>This feature requires javascript</noscript>

<!-- If index is defined this jsp was called from printable_body_layout.jsp and the index
         is passed in the request, otherwise we need to set it to zero explicitly -->
<c:if test="${empty index}">
        <c:set var="index" value="0" scope="request"/>
</c:if>
<c:if test="${fromEshelf}">
        <input type="hidden" id="vid" value="${fn:escapeXml(sessionScope.vid)}"/>
</c:if>
<div class="EXLSummary EXLResult">
<div class="EXLSummaryContainer"><a name="${result.id}" id="${result.id}" class="EXLResultRecordId"></a>
    <div class="EXLSummaryFields">
        <c:set var="recordTitle"><prm:fields fields="${displayForm.resultView[0]}" result="${result}" fieldDelims="${displayForm.displayFieldsDelimiters[0]}"/></c:set>
        <c:set var="recordAuthor"><prm:fields fields="${displayForm.resultView[1]}" result="${result}" fieldDelims="${displayForm.displayFieldsDelimiters[1]}"/></c:set>
        <h1 class="EXLResultTitle">${fmt:escapeLooseAmpersands(recordTitle)}</h1>
        <c:if test="${not empty recordAuthor }">
            <h2 class="EXLResultAuthor">${fmt:escapeLooseAmpersands(recordAuthor)}</h2>
        </c:if>
        <!-- 8300 defect for UNSW -->
        <c:set var="resultDetailsThirdLine"><prm:fields fields="${c_value_is_part_of}" result="${result}" fieldDelims=" "/></c:set>
        <span class="EXLResultDetails">${fmt:escapeLooseAmpersands(resultDetailsThirdLine)}</span>
        <c:if test="${not empty result.values[c_value_is_part_of]}">
            <c:set var="displayLds50">${result.values[c_value_lds_50][0]}</c:set>
            <c:if test="${not empty displayLds50 and displayLds50 eq 'peer_reviewed'}" >
                <fmt:message key='default.fulldisplay.constants.peer_reviewed'/>
            </c:if>
        </c:if>

        <%-- check to make sure the content exists before rendering the fourth line unnecesarily --%>
        <c:set var="fourthLineContent"><prm:fields fields="${displayForm.resultView[2]}" result="${result}" fieldDelims="${displayForm.displayFieldsDelimiters[2]}"/></c:set>
        <c:if test="${not empty fourthLineContent}">
            <h3 class="EXLResultFourthLine">${fmt:escapeLooseAmpersands(fourthLineContent)}</h3>
        </c:if>
        <!-- end of 8300 -->
        <!--   span class="EXLResultDetails"><prm:fields fields="${c_value_is_part_of}" result="${result}" fieldDelims=" "/></span>-->
        <prm:available availForm="${displayForm}" dlvIndex="0" displayLayout="full" />
    </div>

    <%-- defect 7208 begin --%>
    <%--
    <c:url var="frbrUrl" value="${displayForm.responseEncodeReqDecUrl}">
            <c:param name="cs" value="frb"/>
            <c:param name="frbg" value="${result.values[c_value_frbrgroupid][0]}"/>
            <c:param name="fctN" value="${c_facet_frbrgroupid}"/>
            <c:param name="fctV" value="${result.values[c_value_frbrgroupid][0]}"/>
`               </c:url>
    <c:if test="${not empty result.values[c_value_frbrgroupid] and  result.values[c_value_frbrtype][0] eq 7}">
            <cite class="EXLResultFRBR">
                    <span class="EXLResultBgFRBR"></span>
                            <a class="EXLBriefResultsDisplayMultipleLink" target="_parent" href="${fn:escapeXml(frbrUrl)}">${result.values[c_value_versions][0]}</a>
                    <span class="EXLResultBgRtlFRBR"></span>
            </cite>
    </c:if>
    --%>

    <c:url var="frbrUrl" value="search.do?${fn:replace(displayForm.reqDecQry,'ct=display','ct=search')}">
        <c:param name="frbg" value="${result.values[c_value_frbrgroupid][0]}"/>
        <c:param name="fctN" value="${c_facet_frbrgroupid}"/>
        <c:param name="fctV" value="${result.values[c_value_frbrgroupid][0]}"/>
        <c:param name="doc" value="${result.id}"/>
    </c:url>
    <c:if test="${not empty result.values[c_value_frbrgroupid] and  result.values[c_value_frbrtype][0] eq 5 and (sessionScope[recordid]>1 or displayForm.frbrVersion > 1) and (empty displayForm.fctN)}" >
        <c:set var="frbrnum" value="${sessionScope[recordid]}" />
        <c:if test="${empty frbrnum}" >
            <c:set var="frbrnum" value="${displayForm.frbrVersion}" />
        </c:if>
        <cite class="EXLResultFRBR">
            <span class="EXLResultBgFRBR"></span>
            <a class="EXLBriefResultsDisplayMultipleLink" target="_parent" href="${fn:escapeXml(frbrUrl)}">
                <c:choose>
                    <c:when test="${fn:startsWith(result.id, 'TN') || fn:startsWith(result.id, 'RS')}">
                        <fmt:message key="default.pcgroup.display"/>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="frbrversion.editions.prefix"/>&nbsp;${frbrnum}&nbsp;<fmt:message key="frbrversion.editions"/>
                    </c:otherwise>
                </c:choose>
            </a>
            <span class="EXLResultBgRtlFRBR"></span>
        </cite>
    </c:if>
    <%-- defect 7208 end --%>

</div>

<c:set var="displayURLRemoved" value="${requestScope.resultTileDisplayURL_reqQryUTF8}" />
<c:url var="displayURL" value="display.do?${displayURLRemoved}" >
    <c:param name="ct" value="display"/>
    <c:param name="fn" value="${displayForm.fn}"/>
    <c:param name="doc" value="${result.id}"/>
    <c:param name="indx" value="${displayForm.indx}"/>
    <c:param name="recIds" value="${result.id}"/>
    <c:choose>
        <c:when test="${not empty renderForm.recIdxs}">
            <c:param name="recIdxs" value="${renderForm.recIdxs[0]}"/>
        </c:when>
        <c:otherwise>
            <c:param name="recIdxs" value="0"/>
            <%-- it may be better to not add anything here. 0 is known to cause null pointer exceptions in DeliveryManager :) see TabAction.getPreprocessedDeliveryResponse()
                   it's possible this code never worked and its rare to find a situation where it comes up. -hj
            --%>
        </c:otherwise>
    </c:choose>
    <c:param name="elementId" value="0"/>
    <c:param name="renderMode" value="poppedOut"/>
    <c:param name="displayMode" value="full"/>
</c:url>


<div class="EXLTabsRibbon ">
<div><!-- result.id: ${result.id} tabState: ${searchForm.recordTabs[result.id]} tabOrder: ${searchForm.recordTabs[result.id].tabsOrder} -->
<ul id="exlidResult0-TabsList" class="EXLResultTabs nav nav-tabs">
    <c:set var="tabState" value="${displayForm.recordTabs[result.id]}"/>

    <c:set var="noFirstTab" value="true"/>
    <c:forEach items="${tabState.tabsOrder}" var="tab" varStatus="tabStatus">
        <!-- index: ${tabStatus.index} length: ${fn:length(tabState.tabsOrder)} -->
        <c:choose>
            <c:when test="${tab == renderForm.tabs[0]}">
                <c:set var="selectedTabClass" value="EXLResultSelectedTab, active"/>
            </c:when>
            <c:otherwise>
                <c:set var="selectedTabClass" value=""/>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${noFirstTab==true}">
                <c:set var="specialTabClass" value="EXLResultFirstTab ${selectedTabClass}"/>
            </c:when>
            <c:when test="${tab==tabState.tabsOrder[fn:length(tabState.tabsOrder)-1]}">
                <c:set var="specialTabClass" value="EXLResultLastTab ${selectedTabClass}"/>
            </c:when>
            <c:otherwise>
                <c:set var="specialTabClass" value="${selectedTabClass}"/>
            </c:otherwise>
        </c:choose>
        <%-- viewonline,getit_link1,locations,details,reviewsandtags,recommendations,getit_link2 --%>
        <c:if test="${tab=='viewonline' && not empty tabState.viewOnlineTab}">
            <li id="exlidResult0-ViewOnlineTab" class="EXLViewOnlineTab EXLResultTab ${specialTabClass} ${ (renderForm.tabs[0] eq 'viewOnlineTab') ? 'EXLResultSelectedTab, active':''} ${tabState.viewOnlineTab.iconCode}">
                <c:choose>
                    <c:when test="${tabState.viewOnlineTab.popOut == 'on'}">
                        <c:set var="taburl" value="${tabState.viewOnlineTab.link}"/>
                        <c:set var="popoutTarget"> target='_blank' </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="taburl" value="${displayURL}&tabs=viewOnlineTab&gathStatTab=true"/>
                        <c:set var="popoutTarget"></c:set>
                    </c:otherwise>
                </c:choose>
                <a href="${fn:escapeXml(taburl)}" title="" ${popoutTarget}>
                    <fmt:message key="${tabState.viewOnlineTab.label}"/></a>

                <!-- rum statistics -->

                <prm:boomerang id="getit1_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="getit1" resultDoc="${displayForm.searchResultFullDoc[0]}" type="delivery"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->

            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='getit_link1' && not empty tabState.requestTab}">
            <li id="exlidResult0-RequestTab" class="EXLRequestTab EXLResultTab ${specialTabClass} ${ (renderForm.tabs[0] eq 'requestTab') ? 'EXLResultSelectedTab, active':''} ${tabState.requestTab.iconCode}">
                <c:choose>
                    <c:when test="${tabState.requestTab.popOut == 'on' && !fn:contains(tabState.requestTab.link,'requestTab.do')}">
                        <c:set var="taburl" value="${tabState.requestTab.link}"/>
                        <c:set var="popoutTarget"> target='_blank' </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="taburl" value="${displayURL}&tabs=requestTab&gathStatTab=true"/>
                        <c:set var="popoutTarget"></c:set>
                    </c:otherwise>
                </c:choose>
                <%-- The parameter ilsApiId is unnecessary here and causes problems, but since there is no easy way to remove it,
    I changed its name so we don't try to call its setter --%>
                <c:set var="taburl" value="${fn:replace(taburl, 'ilsApiId=', 'tmp=')}"/> <%-- IMPORTANT! Don't remove. See comment above --%>
                <a href="${fn:escapeXml(taburl)}" title="" ${popoutTarget}><fmt:message key="${tabState.requestTab.label}"/></a>

                <!-- rum statistics -->

                <prm:boomerang id="getit1_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="getit1" resultDoc="${displayForm.searchResultFullDoc[0]}" type="delivery"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='locations' && not empty tabState.locationsTab}">
            <li id="exlidResult0-LocationsTab" class="EXLLocationsTab EXLResultTab ${ (renderForm.tabs[0] eq 'locationsTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=locationsTab&amp;gathStatTab=true" title=""><fmt:message key="${tabState.locationsTab.label}"/></a>
                <!-- rum statistics -->

                <prm:boomerang id="locations_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="locationTab" resultDoc="${displayForm.searchResultFullDoc[0]}" type="locations"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='details' && not empty tabState.detailsTab}">
            <li id="exlidResult0-DetailsTab" class="EXLDetailsTab EXLResultTab ${ (empty renderForm.tabs or renderForm.tabs[0] eq 'detailsTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=detailsTab&amp;gathStatTab=true" title=""><fmt:message key="${tabState.detailsTab.label}"/></a>
                <!-- rum statistics -->

                <prm:boomerang id="details_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="detailsTab" resultDoc="${displayForm.searchResultFullDoc[0]}" type="details"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='reviewsandtags' && not empty tabState.tagsReviewsTab}">
            <li id="exlidResult0-ReviewsTab" class="EXLReviewsTab EXLResultTab ${ (renderForm.tabs[0] eq 'tagreviewsTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=tagreviewsTab&amp;gathStatTab=true" title=""><fmt:message key="${tabState.tagsReviewsTab.label}"/></a>
                <!-- rum statistics -->

                <prm:boomerang id="tagsreview_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="tagReviewTab" resultDoc="${displayForm.searchResultFullDoc[0]}" type="tagsreview"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='recommendations' && not empty tabState.recommendationsTab}">
            <c:set var="linkTitle">
                <fmt:message key="default.recommendationtab.recommendations_loading"/>
            </c:set>
            <li id="exlidResult0-RecommendTab" class="EXLRecommendTab EXLResultTab ${ (renderForm.tabs[0] eq 'recommendTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=recommendTab&amp;gathStatTab=true" title="${linkTitle}" id="exlidHref0"><fmt:message key="${tabState.recommendationsTab.label}"/></a>
                <!-- rum statistics -->

                <prm:boomerang id="recommendation_${0}" boomForm="${displayForm}" pageId="brief"
                               opId="recommendationTab" resultDoc="${displayForm.searchResultFullDoc[0]}" type="recommendation"
                               delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='getit_link2' && not empty tabState.moreTab}">
            <li id="exlidResult0-MoreTab" class="EXLMoreTab EXLResultTab ${ (renderForm.tabs[0] eq 'moreTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass} ${tabState.moreTab.iconCode}">
                <c:choose>
                    <c:when test="${tabState.moreTab.popOut == 'on'}">
                        <c:set var="taburl" value="${tabState.moreTab.link}"/>
                        <c:set var="popoutTarget"> target='_blank' </c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="taburl" value="${displayURL}&tabs=moreTab&gathStatTab=true"/>
                        <c:set var="popoutTarget"></c:set>
                    </c:otherwise>
                </c:choose>
                <a href="${fn:escapeXml(taburl)}" title="" ${popoutTarget}>
                    <fmt:message key="${tabState.moreTab.label}"/></a>
                <!-- rum statistics -->

                <prm:boomerang id="getit2_${0}" boomForm="${displayForm}" pageId="brief" opId="getit2"
                               resultDoc="${displayForm.searchResultFullDoc[0]}"
                               type="getit2" delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>

                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='citations' && not empty tabState.citationsTab}">
            <li id="exlidResult0-CitationsTab" style="display:none;" class="EXLCitationsTab EXLServiceConditionalTab EXLResultTab ${ (empty renderForm.tabs or renderForm.tabs[0] eq 'citationsTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}">

                <input class="EXLServiceConditionalTabService" type="hidden" value="${tabState.citationsTab.serviceName}"/>
                <input class="EXLServiceConditionalTabRecord" type="hidden" value="${result.id}"/>
                <a href="${fn:escapeXml(displayURL)}&amp;tabs=conditionalTab&amp;gathStatTab=true&amp;tabRealType=citations" title="">
                    <fmt:message key="${tabState.citationsTab.label}"/>
                </a>

                <!-- rum statistics -->
                <prm:boomerang id="citations_${0}" boomForm="${displayForm}" pageId="brief" opId="citations"
                               resultDoc="${displayForm.searchResultFullDoc[0]}"
                               type="citations" delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>
                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>
        <c:if test="${tab=='onlinereviews' && not empty tabState.onlinereviewsTab}">
            <li id="exlidResult0-OnlinereviewsTab" style="display:none;" class="EXLOnlinereviewsTab EXLServiceConditionalTab EXLResultTab ${ (empty renderForm.tabs or renderForm.tabs[0] eq 'onlinereviewsTab') ? 'EXLResultSelectedTab, active ':''} ${specialTabClass}">
                <input class="EXLServiceConditionalTabService" type="hidden" value="${tabState.citationsTab.serviceName}"/>
                <input class="EXLServiceConditionalTabRecord" type="hidden" value="${result.id}"/>
                <a href="${fn:escapeXml(displayURL)}&amp;tabs=conditionalTab&amp;gathStatTab=true&amp;tabRealType=onlinereviews" title="">
                    <fmt:message key="${tabState.onlinereviewsTab.label}"/>
                </a>

                <!-- rum statistics -->
                <prm:boomerang id="onlinereviews_${0}" boomForm="${displayForm}" pageId="brief" opId="onlinereviews"
                               resultDoc="${displayForm.searchResultFullDoc[0]}"
                               type="onlinereviews" delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>
                <!-- end rum statistics -->
            </li>
            <c:set var="noFirstTab" value="false"/>
        </c:if>

    </c:forEach>
</ul>
<%--
        <ul id="exlidResult0-TabsList" class="EXLResultTabs">
          <li id="exlidResult0-RequestTab" class="EXLRequestTab EXLResultTab EXLResultFirstTab ${(renderForm.tabs[0]=='requestTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=requestTab" title="" onclick="runOnce();" >Request</a></li>
          <li id="exlidResult0-LocationsTab" class="EXLLocationsTab EXLResultTab ${(renderForm.tabs[0]=='locationsTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=locationsTab" title="" onclick="runOnce();">Locations</a></li>
          <li id="exlidResult0-DetailsTab" class="EXLDetailsTab EXLResultTab ${(renderForm.tabs[0]=='detailsTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=detailsTab" title="" onclick="runOnce();">Details</a></li>
          <li id="exlidResult0-ReviewsTab" class="EXLReviewsTab EXLResultTab ${(renderForm.tabs[0]=='tagsreviewsTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=tagreviewsTab" title=""  onclick="runOnce();">Reviews &amp; Tags</a></li>
          <li id="exlidResult0-RecommendTab" class="EXLRecommendTab EXLResultTab ${(renderForm.tabs[0]=='recommendationsTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=recommendTab" title="" onclick="runOnce();">Recommendations</a></li>
                  <li id="exlidResult0-OnlineTab" class="EXLRequestTab EXLResultTab EXLResultFirstTab ${(renderForm.tabs[0]=='viewOnlineTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=viewOnlineTab" title="" onclick="runOnce();">Online</a></li>
          <li id="exlidResult0-MoreTab" class="EXLMoreTab EXLResultTab EXLResultLastTab ${(renderForm.tabs[0]=='moreTab')?'EXLResultSelectedTab':''}"><a href="${fn:escapeXml(displayURL)}&amp;tabs=moreTab" title="" onclick="runOnce();">More</a></li>
        </ul>
--%>
</div>
</div>
<c:set var="recordId" scope="request" value="${result.id}"/>
<c:set var="recordBulkIndex" scope="request" value="${recordStatus.index}"/>
<c:set var="recordResultIndex" scope="request" value="${result.resultNumber}"/>
<c:set var="recordElementId" scope="request">exlidResult0-TabContainer</c:set>

<!-- tabs[0]: ${renderForm.tabs[0]} -->
<c:set var="popOutUrl" scope="request" value="${displayURL}"/>

<c:set var="resultStatusIndex" value="0"/>
<div id="exlidResult${resultStatusIndex}-TabContainer-viewOnlineTab" class="EXLResultTabContainer EXLContainer-viewOnlineTab ${ (renderForm.tabs[0] eq 'viewOnlineTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'viewOnlineTab'}">
        <prm:renderTabContent live="true" form="${viewOnlineForm}" tabKey="viewOnlineTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-requestTab" class="EXLResultTabContainer EXLContainer-requestTab ${ (renderForm.tabs[0] eq 'requestTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'requestTab'}">
        <prm:renderTabContent live="true" form="${requestTabForm}" tabKey="requestTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-locationsTab" class="EXLResultTabContainer EXLContainer-locationsTab ${ (renderForm.tabs[0] eq 'locationsTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'locationsTab'}">
        <prm:renderTabContent live="true" form="${locationsTabForm}" tabKey="locationsTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-detailsTab" class="EXLResultTabContainer EXLContainer-detailsTab ${ (empty renderForm.tabs or renderForm.tabs[0] eq 'detailsTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${empty renderForm.tabs or renderForm.tabs[0] eq 'detailsTab'}">
        <c:catch var="defaultDetailsTabLoadAttempt">
            <prm:renderTabContent live="true" form="${detailsForm}" tabKey="detailsTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
        </c:catch>
        <c:if test="${not empty defaultDetailsTabLoadAttempt}">
            Please select a tab to view
        </c:if>
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-tagreviewsTab" class="EXLResultTabContainer EXLContainer-tagreviewsTab ${ (renderForm.tabs[0] eq 'tagreviewsTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'tagreviewsTab'}">
        <prm:renderTabContent live="true" form="${tagReviewsForm}" tabKey="tagreviewsTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-recommendTab" class="EXLResultTabContainer EXLContainer-recommendTab ${ (renderForm.tabs[0] eq 'recommendTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'recommendTab'}">
        <prm:renderTabContent live="true" form="${recommendationsForm}" tabKey="recommendTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-moreTab" class="EXLResultTabContainer EXLContainer-moreTab ${ (renderForm.tabs[0] eq 'moreTab') ? '' :'EXLResultTabContainerClosed' }">
    <c:if test="${renderForm.tabs[0] eq 'moreTab'}">
        <prm:renderTabContent live="true" form="${moreForm}" tabKey="moreTab" recordId="${result.id}" recordElementId="${resultStatus.index}" popOutUrl="${popOutUrl}" />
    </c:if>
</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-citationsTab" class="EXLResultTabContainer EXLContainer-citationsTab " style="display:none;">

</div>
<div id="exlidResult${resultStatusIndex}-TabContainer-onlinereviewsTab" class="EXLResultTabContainer EXLContainer-onlinereviewsTab " style="display:none;">

</div>

<%--
      <div id="exlidResult${resultStatus.index}-TabHeader" class="EXLTabHeader">
       <div class="EXLTabHeaderContent"> </div>
     <div id="exlidTabHeaderButtons${resultStatus.index}" class="EXLTabHeaderButtons">
          <prm:sendTo recordId="${result.id}" />
        </div>
      </div>
      <div id="exlidResult${resultStatus.index}-TabContent" class="EXLTabContent">

          </div>
 --%>
<%-- set so that renderers will render correctly --%>

</div>

<%-- we embed this in the page so the prefetch mechanism knows what its configuration is.--%>
<script type="text/javascript">
    var exlPrefetchConfiguration = {
        enabled : '${searchForm.prefetchEnabled}',
        bulkSize : '${searchForm.prefetchBulkSize}',
        repeat : '${searchForm.prefetchRepeat}',
        loadedTab : '${renderForm.tabs[0]}',
        timeout: '${sessionScope.ajaxTimeout}'
    }
    applySubmitHandlingToTabForms($('.EXLSummary'));//initialize any form that might load as part of the default page, so that it will submit via ajax

    //if (exlPrefetchConfiguration.loadedTab !=  'recommendTab') {
    addLoadEvent( function(){checkRecommendation('${result.id}', '${renderForm.tabs[0]}', '${fromEshelf}');});
    //}

    if (exlPrefetchConfiguration.loadedTab == 'recommendTab') {
        document.getElementById('exlidHref0').title = "<fmt:message key="recommendationtab.recommendations_found"/>";
    }
</script>
<noscript>This feature requires javascript</noscript>
<div class="EXLResultsHeader EXLResultsFooter">
    <c:if test="${not empty displayForm}">
        <c:set value="${fn:substringBefore((searchForm.indx - 1) div sessionScope.bulk , '.') + 1 }" var="indexPage" />
        <c:set value="${indexPage*sessionScope.bulk  - (sessionScope.bulk -1)}" var="backIndex" />
        <c:url value="search.do?pag=bak&indx=${backIndex}&ct=&viewAllItemsClicked=false&selectedLocation=&${displayForm.reqDecQry}&doc=${result.id}" var="backURL"/>
        <c:if test="${form.fn != 'display'}">
            <div class="EXLBackToResults">
                <c:choose>
                    <c:when test="${(displayForm.mode != null) &&(displayForm.mode eq 'BrowseSearch') && fn:contains(displayForm.searchField, 'callnumber')}">
                        <c:url value="search.do" var="BackToBrowseSearch">
                            <c:param name="fn" value="BrowseSearch"/>
                            <c:param name="isBack" value="true"/>
                            <c:param name="browseField" value="${displayForm.searchField}"/>
                            <c:param name="basicSearchTxt(freeText0)" value="${displayForm.lastTerm}"/>
                            <c:param name="searchTxt(freeText0)" value="${displayForm.lastTerm}"/>
                            <c:param name="search_field" value="${displayForm.lastTerm}"/>
                            <c:param name="innerPnxIndex" value="${displayForm.currentPagePnxIndex}"/>
                        </c:url>
                        <%--                                            <c:set var="browseMessageSuffix" value="browse.back.to.${displayForm.searchField}s"/>
                     <c:if test="${fn:contains(displayForm.searchField, 'callnumber')}"> --%>
                        <c:set var="browseMessageSuffix" value="browse.back.to.callnumbers"/>
                        <%--                                            </c:if>
                        --%>                                           <a id="backToResultsBtn" class="btn btn-default" href="${fn:escapeXml(BackToBrowseSearch)}" title="<fmt:message key='${browseMessageSuffix}' />">
                        <span class="glyphicon glyphicon-chevron-left"></span> <fmt:message key="${browseMessageSuffix}" />
                    </a>
                    </c:when>

                    <c:otherwise>
                        <a id="backToResultsBtn" class="btn btn-default" href="${fn:escapeXml(backURL)}" target="_parent" title='<fmt:message key="link.title.deatiles.back"/>'><span class="glyphicon glyphicon-chevron-left"></span> <fmt:message key="fulldisplay.deatiles.back"/></a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

    </c:if>

        <c:if test="${displayForm.fn=='search' and (not empty sessionScope.lastSearchForm) and not displayForm.fromEshelf}" >
                <c:url var="paginationURL" value="display.do?${displayURLRemoved}" >
                        <c:param name="ct" value="display"/>
                        <c:param name="fn" value="search"/>
                        <c:param name="elementId" value="0"/>
                        <c:param name="renderMode" value="poppedOut"/>
                        <c:param name="displayMode" value="full"/>
                </c:url>

                <div class="EXLResultsNavigation">
            <ul class="pager">
                        <c:if test="${displayForm.indx!='1'}">
                                        <c:url value="${paginationURL}" var="paginationPrevURL">
                                                <c:param name="pag" value="prv"/>
                                                <c:param name="indx" value="${displayForm.indx}"/>
                                        </c:url>
                                            <li class="EXLPrevious previous">
                                            <a class="EXLPrev"  target="_parent" title='<fmt:message key="link.title.results.prev"/>' href="${fn:escapeXml(paginationPrevURL)}">&larr; <fmt:message key='results.prev'/></a>
                                    </li>

                </c:if>

                <li class="EXLDisplayedCountTitle text-muted"><strong><fmt:message key='fulldisplay.deatiles.result'/>&nbsp;</strong></li>
                <li class="EXLDisplayedCount text-muted"><strong>${displayForm.indx} </strong></li>
                        <c:if test="${displayForm.indx!=displayForm.searchResult.numberOfResults}">
                                <c:url value="${paginationURL}" var="paginationNextURL">
                                        <c:param name="pag" value="nxt"/>
                                        <c:param name="indx" value="${displayForm.indx}"/>
                                </c:url>
                    <li class="next">
                    <a class="EXLNext" target="_parent" title='<fmt:message key="link.title.results.next"/>' href="${fn:escapeXml(paginationNextURL)}"><fmt:message key='results.next'/> &rarr;</a>
                    </li>
                        </c:if>
            </ul>
                </div>
        </c:if>
</div>




<c:set var="opId">title</c:set>
<c:if test="${param.gathStatIcon eq 'true'}">
        <c:set var="opId">icon</c:set>
</c:if>
<script type="text/javascript">
<!-- PRM-17057 Call to PC and get data for the conditional tab  -->
addLoadEvent(checkConditional);
</script>
<noscript>This feature requires javascript</noscript>
<prm:boomerang id="title"  boomForm="${displayForm}" pageId="brief"
opId="${opId}" resultDoc="${displayForm.searchResultFullDoc[0]}" type="title,${renderForm.tabs[0]}" delivery="${displayForm.delivery[0]}" noOther="false" index="${param.indx}"/>
<c:if test="${param.pag ne 'nxt' and param.pag ne 'prv' }">
<script type="text/javascript">
        boomCallToRum("title",true);
</script>
<noscript>This feature requires javascript</noscript>
</c:if>
