<%@ page contentType="text/xml;charset=UTF-8" language="java"%>
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
<div id="exlidHeaderSearchLimits" class="row">
      <fieldset>
      <legend class="EXLHiddenCue sr-only"><prm:userText styleId="search-simple" type="openingText" inline="true"/></legend>
      <div class="EXLHeaderSearchLimitsFields">
		<span class="EXLHeaderSearchLimitsFieldsTitle">
		<prm:userText styleId="search-simple" type="openingText" inline="true"/>
		</span>

		<c:set value="${searchForm.queryTerms[1].inputs[0]}"	var="currentInput" />		
			<c:if test="${fn:length(currentInput.options) gt 1}">
				<span class="EXLHiddenCue sr-only"><prm:userText styleId="search-simple" type="lookForText" inline="true"/></span>
                <div class="col-xs-6 col-md-3">
                    <div class="form-group">
                <prm:select selectForm="${searchForm}" input="${currentInput}" styleClass="blue EXLSimpleSearchSelect form-control input-sm" valueOptionsPrefix='search-simple' count="1"/>
                    </div>
                </div>
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
                <div class="col-xs-6 col-md-3">
                    <div class="form-group">
                        <prm:select selectForm="${searchForm}" input="${currentInput}" styleClass="EXLSimpleSearchSelect form-control input-sm" valueOptionsPrefix='search-simple' count="1"/>
                    </div>
                </div>
			</c:if>
		</c:forEach>
          <div class="col-xs-6 col-md-3">
              <div class="form-group">
                  <select id="exlidSearchIn" class="EXLSearchInputScopesSelect form-control input-sm"
                          name="scp.scps" ${(searchForm.displayDefinition=='false')?'disabled="disabled"':''}>
                      <c:forEach items='${searchForm.scp.scopesOptions}' var="option" varStatus="status">
                          <c:set var="classes"
                                 value="${option.locationrefs==searchForm.scp.scps?'EXLSelectedOption':'EXLSelectOption'}"/>
                          <c:set var="selected" value="${option.locationrefs==searchForm.scp.scps?'selected=\"selected\"':''}"/>
                          <c:choose>
                              <c:when test="${option.id == 'Selected_Databases'}">
                                  <c:if test="${searchForm.displaySelectedScope != 'hide'}">
                                      <option id="${option.id}" value="${fn:escapeXml(option.locationrefs)}"
                                              class="${classes} EXLSearchInputScopesOption${option.id}" ${selected}>
                                          <fmt:message
                                                  key='scopes.option.current.selected'/>
                                          <c:if test="${searchForm.accessibilityList[status.index]!='-1' and not searchForm.allFullAccess}">
                                              &nbsp;
                                              <fmt:message
                                                      key='option.accessibility.${searchForm.accessibilityList[status.index]}'/>
                                          </c:if>
                                      </option>
                                  </c:if>
                              </c:when>
                              <c:otherwise>
                                  <c:if test="${option.personalSetScope == false or (searchForm.displaySelectedScope != 'hide' and option.personalSetScope == true)}">
                                      <option id="${option.id}" value="${fn:escapeXml(option.locationrefs)}"
                                              class="${classes} EXLSearchInputScopesOption${option.id}" ${selected}>
                                          <fmt:message
                                                  key='scopes.option.${option.id}'/>
                                          <c:if test="${searchForm.accessibilityList[status.index]!='-1' and not searchForm.allFullAccess}">
                                              &nbsp;
                                              <fmt:message
                                                      key='option.accessibility.${searchForm.accessibilityList[status.index]}'/>
                                          </c:if>
                                      </option>
                                  </c:if>
                              </c:otherwise>
                          </c:choose>
                      </c:forEach>
                  </select>
              </div>
          </div>

      </div>
      </fieldset>
      <!--<input name="Submit" type="submit" value="Apply Search Limits"/>-->
      <!--<input name="Reset" type="reset" value="Clear Limits"/>-->
    <div class="col-md-12">
        <prm:userText styleId="search-simple" type="endingText" inline="true"/>
        <a href="/primo_library/libweb/action/search.do?menuitem=0" class="btn btn-primary btn-sm" title="ny søgning" target="_self"><fmt:message key='mainmenu.label.ny_søgning' /></a>
    </div>





</div>
</c:if>
<!-- searchLimitsTile.jsp end -->
