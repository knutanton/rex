<%@ page contentType="text/xml;charset=UTF-8" language="java" %>
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<!-- searchTileBasic.jsp begin -->
<c:set var="primoView" value="${sessionScope.primoView}"/>
<%-- for embedded search tile --%>
    <c:if test="${empty divClass}">
    <c:set var="divClass" value="EXLSearch"/>
</c:if>

    <div id="exlidSearchTile" class="${divClass} row">
    <div id="exlidSearchRibbon" class="col-md-8 col-md-offset-2">

        <c:if test="${searchForm == null}">
            <c:set var="searchForm" value="${displayForm}" scope="request"/>
        </c:if>

        <c:if test="${empty resloc}">
            <c:set var="resloc">_self</c:set>
        </c:if>
        <c:url value="search.do?${requestScope.switchModeURL_reqDecQryUTF8}" var="advanced_search_url">
            <c:param name="mode" value="Advanced"/>
            <c:param name="ct" value="AdvancedSearch"/>
        </c:url>
        <c:if test="${searchForm.displayDefinition=='false'}">
                <%-- determine whether scope will be visible or not, grow text search box accordingly, all of these are classes --%>
            <c:set var="oneScopeOnlyClass">EXLDynamicSelectOnlyOneScope</c:set>
            <c:set var="fullSearchBoxClass">EXLSearchFieldMaximized</c:set>
            <c:set var="enlargeSearchFieldHideScope">EXLSearchFieldRibbonFormSearchForMaximized</c:set>
        </c:if>

        <%@ include file="/views/search/search_hidden.jspf" %>


        <!--<legend class="EXLHiddenCue collapse">Primo Search</legend>-->
            <%-- begin tabs handling --%>
        <div class="EXLSearchTabsContainer">

            <c:if test="${primoView.numberOfTabs > 1}">

                <c:set var="embed" value="${param.embed}"/>
                <html:hidden property="tb" styleId="tb" value="t"/>

                    <%--Build the prefix for the tab url --%>
                <c:url value="search.do" var="tab_url">
                    <c:param name="mode" value="${searchForm.mode}"/>
                    <c:param name="vid" value="${searchForm.vid}"/>
                    <c:choose>
                        <c:when test="${not empty embed }">
                            <c:param name="embed" value="true"/>
                        </c:when>
                    </c:choose>

                        <%--Copy the free text when swiching between tabs--%>
                    <c:if test="${searchForm.tabsRemote}">
                        <c:set var="componentIds" value="${searchForm.componentType2ComponentIds[c_ctype_freetext]}"/>
                        <c:set var="hasFreeText" value="${false}"/>
                        <c:forEach items="${componentIds}" var="freeTextCompId">
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

                <ul id="exlidSearchTabs" class="EXLTabs nav nav-tabs">
                    <c:forEach items="${primoView.avilableTabs}" var="menu_item" varStatus="status">
                        <c:set var="isRemote" value="${sessionScope.defaultScope4Tab[menu_item]}"/>
                        <c:set var="menuItemLabel">
                            <fmt:message key="tabbedmenu.${menu_item}.label"/>
                        </c:set>

                        <li id="exlidTab${status.index}"
                            class="EXLSearchTab ${(searchForm.tab == status.current )?'EXLSearchTabSelected, active':''}">
                            <c:set var="defScopeId" value="${searchForm.defaultScp[menu_item]}"/>
                                <%--Add the embedded parameters to the tab url to maintain functionality through tabs--%>
                            <c:set var="additionalParams" value=""/>
                            <c:if test="${not empty embed}">
                                <c:forEach items="${param}" var="keyValue">
                                    <c:set var="additionalParams"
                                           value="${additionalParams}${keyValue.key}=${keyValue.value}&"/>
                                </c:forEach>
                            </c:if>
                            <span id="defaultScope${menu_item}" style='display:none'>
                                <fmt:message key='scopes.option.${defScopeId}'/>
                            </span>
                                <%-- where is this used? (-hj) --%>
                            <c:if test="${searchForm.tabsRemote}">
                                <c:set var="autoSearchScript">getSearchField(this,'${searchForm.mode}');</c:set>
                            </c:if>
                            <c:set var="tabUrl" value="${tab_url}&tab=${menu_item}&${additionalParams}"/>
                            <a href="${fn:escapeXml(tabUrl)}"
                               class="EXLSearchTabTitle EXLSearchTabLABEL${menuItemLabel}" target="${resloc}"
                               onclick="${autoSearchScript} delay4Remote('${isRemote}','${searchForm.tabsRemote} ','${menu_item}')"
                               title="<fmt:message key=" tabbedmenu.${menu_item}.tooltip" />">
                            <span>${menuItemLabel}</span>
                        </a>
                    </li>
                </c:forEach>
            </ul>

        </c:if>
    </div>

        <%-- end tabs handling --%>


    <div class="EXLSearchFieldRibbon ${enlargeSearchFieldHideScope}">
        <div class="EXLSearchFieldRibbonFormFields form-group">
            <div class="EXLSearchFieldRibbonFormSearchFor input-group input-group-lg">
                <label for="search_field" class="EXLHide sr-only">Search For:</label>
                <input name="vl(${searchForm.queryTerms[0].inputs[0].id})" class="${fullSearchBoxClass} form-control"
                       value='${fn:escapeXml(searchForm.values[searchForm.queryTerms[0].inputs[0].id])}'
                       id="search_field" type="text" accesskey="s"/>

                <div class="EXLSearchFieldRibbonFormSubmitSearch input-group-btn">
                    <c:if test="${empty sbutton }">
                        <c:set var="sbutton" value="submit"/>
                    </c:if>
                    <button id="goButton" type="submit" value="<fmt:message key='link.title.search.search'/>"
                            class="${sbutton} btn btn-primary" accesskey="g">
                        <span class="glyphicon glyphicon-search "></span>
                        <span class="collapse">
                            <fmt:message key='link.title.search.search'/>
                        </span>
                    </button>
                </div>
            </div>
                <%-- begin scopes dropdown --%>
                <%--@ include file="basicSearchScopesList.jspf" --%>
                <%-- end scopes dropdown --%>
        </div>
        <!-- end  search field ribbon -->
    </div>

    <jsp:include page="systemFeedbackTile.jsp"/>
    <jsp:include page="searchLimitsTile.jsp"/>

    <c:set var="browseAlign" value=""/>
    <c:if test="${searchForm.showBrowseLink }">
        <c:set var="browseAlign" value="EXLSearchFieldRibbonAdvancedTwoLinks"/>
    </c:if>

    <div class="EXLSearchFieldRibbonAdvancedSearchLink">
        <a class="${browseAlign}" title="<fmt:message key='link.title.advanced_search'/>"
           href="${fn:escapeXml(advanced_search_url)}" id="advancedSearchBtn">
            <fmt:message key='label.advanced_search'/>
        </a>
    </div>

    <c:if test="${searchForm.showBrowseLink }">
        <c:url value="search.do?${requestScope.switchModeURL_reqDecQryUTF8}" var="browse_search_url">
            <c:param name="fn" value="showBrowse"/>
            <c:param name="mode" value="BrowseSearch"/>
        </c:url>
        <div class="EXLSearchFieldRibbonBrowseSearchLink">
            <a class="${browseAlign}" title="<fmt:message key='browse.browsesearch'/>"
               href="${fn:escapeXml(browse_search_url)}">
                <fmt:message key='browse.browsesearch'/>
            </a>
        </div>
    </c:if>
</div>
</div>
<%-- 	back to results link

--%>
<!--<div id="exlidSearchBanner">-->
<%--c:choose--%>
<%--
<c:when test="${not empty displayForm}">
	<c:if test="${form.fn != 'display'}">
	<c:url value="search.do?pag=bak&ct=&${displayForm.reqDecQry}" var="backURL"/>
	<a href="${fn:escapeXml(backURL)}" target="_parent" class="backTo EXLFullResultsHeaderBackToBriefResultsLink" title='<fmt:message key="link.title.deatiles.back"/>'><fmt:message key="fulldisplay.deatiles.back"/></a>
	</c:if>
</c:when>
--%>
<%--c:when test="${!searchForm.remote}"--%>
<%--<c:set var="bannerUrl"><fmt:message key='banner.link'/></c:set>
          <c:url var="bannerLink" value="${bannerUrl}"/>
            <a
               href="${fn:escapeXml(bannerLink)}"
               target="_popup">
              <img src="<fmt:message key='ui.images.searchtitlebasic.banner'/>" alt="<fmt:message key='ui.images.searchtitlebasic.banner.alt'/>" />
            </a> --%>
<%--/c:when>
<c:otherwise>
	<a href="#" title=""><img src="<fmt:message key='ui.images.searchtitlebasic.banner'/>" alt="Subscribe to Library News Feeds" /></a>
</c:otherwise>
</c:choose
</div>--%>
<!--end exlidSearchBanner
</div>-->
<!-- searchTileBasic.jsp end -->