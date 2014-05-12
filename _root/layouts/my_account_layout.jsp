<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/views/taglibsIncludeAll.jspf" %>

<!-- dynamic inclusion of js files -->
<%
      //JAC: points to search tile in our dev environments
      String view = request.getSession().getAttribute( "vid" )+ "";

      // remove 'kb', so it fits our folder structure
      if(view.startsWith("kb")){
          view = view.substring(2);
      }

%>



<!-- my_account_layout.jsp begin -->
<fmt:requestEncoding value="UTF-8"/>
<jsp:include page="/general/resolveLocale.jsp"/>
<html xml:lang="${currentLocaleAccessible}" lang="${currentLocaleAccessible}">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<prm:rssHeader/>
<%
//JAC: If this is a KB view, use the KB version of this Layout
     if( view.startsWith("dev") || view.equals("KGL") || view.equals("stable") || view.equals("preview") ) { 
 } else {
%>
<link rel="stylesheet" type="text/css" href="../wro/my_shelf_wro.css" />
<%
}
%>

<jsp:include page="/general/cssAdder.jsp" />
 
  
<c:set var="wroDevMode" value=""/>
<c:if test="${param.wroDevMode != null && param.wroDevMode eq 'true'}">
        <c:set var="wroDevMode" value="?minimize=false&amp;resetWroGroup=true"/>
</c:if>
   
<script type="text/javascript" src="../wro/primo_library_web.js${wroDevMode}"></script>
<script type="text/javascript" src="../wro/jsencrypt.js"></script>
<title><fmt:message key='main.title'/></title>
<jsp:include page="/tiles/javascriptTextIncludes.jsp"/>

</head>
<%
//JAC: If this is a KB view, use the KB version of this Layout
     if( view.startsWith("dev") || view.equals("KGL") || view.equals("stable") || view.equals("preview") ) {

%>

<body class="MyAccount EXLCurrentLang_${currentLocale}">


<!-- MY ACCOUNT -->
<div id="myAccount">

 <div id="exlidSkipToContent" class="EXLSkipToContent">
  <jsp:include page='<%="/sites/kb/"+view+"/tiles/skipToContentTile.jsp"%>' />
 </div>

<!-- HEADER -->
 <div id="header" class="navbar navbar-default">
   <div id="headerWrapper" class="container">
     <div id="exlidHeaderTile" class="EXLLogo">
       <jsp:include page='<%="/sites/kb/"+view+"/tiles/headerTile.jsp"%>' />
     </div>

     <div id="exlidUserAreaTile" class="EXLUserMenu">
                <jsp:include page='<%="/sites/kb/"+view+"/tiles/userAreaTile.jsp"%>' />
     </div>
  </div>
</div>
<!-- END HEADER -->

         <jsp:include page='<%="/sites/kb/"+view+"/tiles/myAccountTile.jsp"%>' />

<!-- SEARCH -->

<div id="search" class="searchComp">
  <div id="exlidSearchTileWrapper" class="EXLCustomLayoutTile EXLSearchWrapper container">
   <jsp:include page="/views/search/dev_l_search_input.jsp"/>
  </div>
</div>


<!-- CONTENT -->
<div id="content">
  <div id="contentWrapper" class="container">

<!-- EX LIBRIS STUFF HERE -->

<!-- add your tiles here -->
<!--begin My Account Tabs-->
<c:url var="eshelfURL" value="basket.do">
 		<c:param name="${action_func}" value="display" />
 		<c:param name="fromUserArea" value="true"/>
 		<c:param name="vid" value="${fn:escapeXml(primoView.id)}"/>
 		<c:param name="fromPreferences" value="${fn:escapeXml(form.fromPreferences)}"/>
</c:url>
<c:url var="myAccountUrl" value="myAccountMenu.do">
 		<c:param name="vid" value="${sessionScope.vid}"/>
</c:url>
<c:choose>
	<c:when test="${sessionScope.loggedIn}">
		<c:url var="queryURL" value="query.do">
			<c:param name="${action_func}" value="display" />
			<c:param name="vid" value="${sessionScope.vid}"/>
		</c:url>
	</c:when>
	<c:otherwise>
		<c:url var="queryURL" value="sessionQuery.do">
			<c:param name="${action_func}" value="display" />
			<c:param name="vid" value="${sessionScope.vid}"/>
		</c:url>
	</c:otherwise>
</c:choose>

<c:if test="${not sessionScope.loggedIn}">
	<c:url var="loginUrl" value="login.do">
		<c:param name="loginFn" value="signin" />
		<c:param name="targetURL" value="${fn:escapeXml(form.reqEncUrl)}"/>
	</c:url>
	<div class="EXLCustomLayoutTile EXLSystemFeedback" id="exlidHeaderSystemFeedback">
		<div class="EXLSystemFeedback" id="exlidHeaderSystemFeedback">				
			<strong><fmt:message key="default.eshelf.signin.message"/>
 				<a href="${fn:escapeXml(loginUrl)}" onclick="boomCallToRum('SignInStat',false);addResolutionParam(this);" title="<fmt:message key="default.eshelf.signin.folders"/>"><fmt:message key="default.eshelf.signin.folders" /></a>					
			</strong>
		</div>
	</div>
</c:if>

<input id="dbSetNumForTabShow" type="hidden" value="${requestScope.myDbSetCount}"/>

<div class="EXLMyAccountTabsRibbon">
  <div>
    <ul class="EXLMyAccountTabs">
	  <c:set var="myShelfSelectedStyle" value ="" />
	  <c:set var="myQueriesSelectedStyle" value ="" />
	  <c:set var="myAccountSelectedStyle" value ="" />
	  <c:choose>
		  <c:when test="${requestScope.myAccountTab == 'eshelf'}">
			<c:set var="myShelfSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:when>
		  <c:when test="${requestScope.myAccountTab == 'queries'}">
			<c:set var="myQueriesSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:when>
		  <c:otherwise>
			<c:set var="myAccountSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:otherwise>
	  </c:choose>
      <li id="exlidEshelfTab" class="EXLMyAccountTab ${myShelfSelectedStyle} EXLMyAccountFirstTab  EXLMyAccountFirstSelectedTab"><a href="${fn:escapeXml(eshelfURL)}" title="<fmt:message key="menu.eshelf" />"><fmt:message key="menu.eshelf" /></a></li>
      <li id="exlidQuereisTab" class="EXLMyAccountTab ${myQueriesSelectedStyle}"><a href="${fn:escapeXml(queryURL)}" title="<fmt:message key="menu.queries" />"><fmt:message key="menu.queries" /></a></li>
      <li id="exlidMyAccountTab" class="EXLMyAccountTab ${myAccountSelectedStyle} EXLMyAccountLastTab"><a href="${fn:escapeXml(myAccountUrl)}" title="<fmt:message key="menu.myaccount" />"><fmt:message key="menu.myaccount" /></a></li>
      <c:if test="${sessionScope.displayMyDatabasesInMyAccount}">
      <li id="exlidMyDatabasesTab" class="EXLMyAccountTab"><a href="#" onclick="javascript:boomCallToRum('FindDbStat',false);openPrimoLightBox('searchDB','loadSearchDbPage','searchDbXml','IamDeepLinkToMyDatabases');" title="<fmt:message key="menu.mydatabases" />"><fmt:message key="menu.mydatabases" /></a></li>
      </c:if>
    </ul>
  </div>
</div>
 <!--begin my account menu-->
<c:set var="activity_pane_val">
	 <tiles:getAsString name="activity_pane"/>
</c:set>
<!--  we are here activity pane - ${activity_pane_val} -->
<tiles:insert attribute="my_account_pane">
	<tiles:put name="activity_pane" value="${activity_pane_val}"/>
</tiles:insert>

<!-- END EX LIBRIS STUFF -->

  </div>
</div>
<!-- END CONTENT -->


<!-- FOOTER -->

<div id="footer">
  <div id="footerWrapper" class="container">
    <tiles:insert attribute="footer"  /> 
 </div>
</div>

</div> 
<!-- END MY ACCOUNT -->

</body>

</html>
<!-- my_account_layout.jsp -->

<% } else {  //JAC: All other views, use the Exlibris Layout   %>

<body class="MyAccount EXLCurrentLang_${currentLocale}">
<%--
<body onload="updateEshelfRTA(${form.updateEshelfRTA});" class="MyAccount">
--%>
<%--
<div id="contentEXL" class="EXLContent EXLBriefDisplay">
--%>
 <div id="exlidSkipToContent" class="EXLSkipToContent">
  <jsp:include page="../tiles/skipToContentTile.jsp"/>
 </div>
 <div id="exlidHeaderContainer" class="EXLHeader EXLClearFix">
  <div id="exlidHeaderTile" class="EXLLogo">
   <jsp:include page="../tiles/headerTile.jsp"/>
  </div>
  <div id="exlidUserAreaTile" class="EXLUserMenu">
   <jsp:include page="../tiles/userAreaTile.jsp"/>
  </div>
  <div id="exlidMainMenuTile" class="EXLMainMenu">
   <jsp:include page="../tiles/mainMenuTile.jsp"/>
  </div>
  <div id="exlidSearchTileWrapper" class="EXLCustomLayoutTile EXLSearchWrapper">
   <jsp:include page="../views/search/l_search_input.jsp"/>
  </div>

 </div>
 <!-- add your tiles here -->
<!--begin My Account Tabs-->
<c:url var="eshelfURL" value="basket.do">
 		<c:param name="${action_func}" value="display" />
 		<c:param name="fromUserArea" value="true"/>
 		<c:param name="vid" value="${fn:escapeXml(primoView.id)}"/>
 		<c:param name="fromPreferences" value="${fn:escapeXml(form.fromPreferences)}"/>
</c:url>
<c:url var="myAccountUrl" value="myAccountMenu.do">
 		<c:param name="vid" value="${sessionScope.vid}"/>
</c:url>
<c:choose>
	<c:when test="${sessionScope.loggedIn}">
		<c:url var="queryURL" value="query.do">
			<c:param name="${action_func}" value="display" />
			<c:param name="vid" value="${sessionScope.vid}"/>
		</c:url>
	</c:when>
	<c:otherwise>
		<c:url var="queryURL" value="sessionQuery.do">
			<c:param name="${action_func}" value="display" />
			<c:param name="vid" value="${sessionScope.vid}"/>
		</c:url>
	</c:otherwise>
</c:choose>

<c:if test="${not sessionScope.loggedIn}">
	<c:url var="loginUrl" value="login.do">
		<c:param name="loginFn" value="signin" />
		<c:param name="targetURL" value="${fn:escapeXml(form.reqEncUrl)}"/>
	</c:url>
	<div class="EXLCustomLayoutTile EXLSystemFeedback" id="exlidHeaderSystemFeedback">
		<div class="EXLSystemFeedback" id="exlidHeaderSystemFeedback">				
			<strong><fmt:message key="default.eshelf.signin.message"/>
 				<a href="${fn:escapeXml(loginUrl)}" onclick="boomCallToRum('SignInStat',false);addResolutionParam(this);" title="<fmt:message key="default.eshelf.signin.folders"/>"><fmt:message key="default.eshelf.signin.folders" /></a>					
			</strong>
		</div>
	</div>
</c:if>

<input id="dbSetNumForTabShow" type="hidden" value="${requestScope.myDbSetCount}"/>

<div class="EXLMyAccountTabsRibbon">
  <div>
    <ul class="EXLMyAccountTabs">
	  <c:set var="myShelfSelectedStyle" value ="" />
	  <c:set var="myQueriesSelectedStyle" value ="" />
	  <c:set var="myAccountSelectedStyle" value ="" />
	  <c:choose>
		  <c:when test="${requestScope.myAccountTab == 'eshelf'}">
			<c:set var="myShelfSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:when>
		  <c:when test="${requestScope.myAccountTab == 'queries'}">
			<c:set var="myQueriesSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:when>
		  <c:otherwise>
			<c:set var="myAccountSelectedStyle" value ="EXLMyAccountSelectedTab" />
		  </c:otherwise>
	  </c:choose>
      <li id="exlidEshelfTab" class="EXLMyAccountTab ${myShelfSelectedStyle} EXLMyAccountFirstTab  EXLMyAccountFirstSelectedTab"><a href="${fn:escapeXml(eshelfURL)}" title="<fmt:message key="menu.eshelf" />"><fmt:message key="menu.eshelf" /></a></li>
      <li id="exlidQuereisTab" class="EXLMyAccountTab ${myQueriesSelectedStyle}"><a href="${fn:escapeXml(queryURL)}" title="<fmt:message key="menu.queries" />"><fmt:message key="menu.queries" /></a></li>
      <li id="exlidMyAccountTab" class="EXLMyAccountTab ${myAccountSelectedStyle} EXLMyAccountLastTab"><a href="${fn:escapeXml(myAccountUrl)}" title="<fmt:message key="menu.myaccount" />"><fmt:message key="menu.myaccount" /></a></li>
      <c:if test="${sessionScope.displayMyDatabasesInMyAccount}">
      <li id="exlidMyDatabasesTab" class="EXLMyAccountTab"><a href="#" onclick="javascript:boomCallToRum('FindDbStat',false);openPrimoLightBox('searchDB','loadSearchDbPage','searchDbXml','IamDeepLinkToMyDatabases');" title="<fmt:message key="menu.mydatabases" />"><fmt:message key="menu.mydatabases" /></a></li>
      </c:if>
    </ul>
  </div>
</div>
 <!--begin my account menu-->
<c:set var="activity_pane_val">
	 <tiles:getAsString name="activity_pane"/>
</c:set>
<!--  we are here activity pane - ${activity_pane_val} -->
<tiles:insert attribute="my_account_pane">
	<tiles:put name="activity_pane" value="${activity_pane_val}"/>
</tiles:insert>
<div class="EXLFooterTile">
	<tiles:insert attribute="footer"  />
</div>

</body>

</html>
<!-- my_account_layout.jsp -->
<% } //JAC: End Layout selection %>
