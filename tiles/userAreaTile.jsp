<%@ page contentType="text/xml;charset=UTF-8" language="java"%>
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/views/include/setSearchForm.jspf"%>
<%-- Prepare functional content first, html at end of file --%>
<c:set var="primoView"  value="${sessionScope.primoView}"/>

<%--Login status variable --%>
<c:set var="loggedIn" value="${false}"/>
<c:if test="${not empty sessionScope.loggedIn and sessionScope.loggedIn==true}">
	<c:set var="loggedIn" value="${true}"/>
</c:if>

<%-- Copied from mainMenuTile.jsp used for prefBackUrl in language selection HAFE --%>
<c:set var="lastUrl" value="${form.reqEncUrl}"/>
<c:set var="url" value="${fn:replace(lastUrl, '&', '%26')}"/>
<c:set var="url" value="${fn:replace(url, '/', '%2F')}"/>
<%-- /HAFE --%>

<%-- We don't use the response encoded url since this URL is used in the targetURL and there is no need to put session id on it  --%>
<c:url var="searchUrl" value="${form.reqPwd}search.do">
	<c:param name="vid" value="${primoView.id}"/>${form.fn}
</c:url>

<c:set var="userName" >
	<c:if test="${not empty sessionScope.userName}">
  			${fn:escapeXml(sessionScope.userName)}
	</c:if>
</c:set>

<c:if test="${!loggedIn}">
	<c:set var="userName">
		<fmt:message key="eshelf.user.anonymous"/>
	</c:set>
</c:if>

<c:url var="eshelfURL" value="basket.do">
 		<c:param name="${action_func}" value="display" />
 		<c:param name="fromUserArea" value="true"/>
 		<c:param name="vid" value="${primoView.id}"/>
 		<c:param name="fromPreferences" value="${form.fromPreferences}"/>
</c:url>

<c:choose>
  <c:when test="${loggedIn}">
	<c:url var="logoutUrl" value="logout.do">
  		<c:param name="loginFn" value="signout" />
  		<c:param name="vid" value="${primoView.id}"/>
  		<c:param name="targetURL" value="${fn:escapeXml(searchUrl)}"/>
	</c:url>
	<c:set var="loginTitle"><fmt:message key="eshelf.signout.title.link"/></c:set>
	<c:set var="eshelfTitle"><fmt:message key="link.title.signin.label"/></c:set>
  </c:when>
  <c:otherwise>
  	    <c:set var="errorString"><html:errors property="ESHELF_TILE_ERRORS"/></c:set>
  	<c:url var="loginUrl" value="login.do">
  		<c:param name="loginFn" value="signin" />
  		<c:param name="vid" value="${primoView.id}"/>
  		<c:param name="targetURL" value="${fn:escapeXml(form.reqEncUrl)}&initializeIndex=true"/>
	</c:url>
	<c:set var="loginTitle"><fmt:message key="eshelf.signin.label1"/> <fmt:message key="eshelf.signin.label2"/></c:set>
	<c:set var="eshelfTitle"><fmt:message key="link.title.signin.label"/></c:set>
</c:otherwise>
</c:choose>

<c:url var="preferencesUrl" value="preferences.do">
 		<c:param name="${action_func}" value="init" />
 		<c:param name="vid" value="${sessionScope.vid}"/>
</c:url>

<c:url var="myAccountUrl" value="myAccountMenu.do">
 		<c:param name="vid" value="${sessionScope.vid}"/>
</c:url>

<c:set var="loggedInClass" value="${(loggedIn)?'EXLEShelfTileLoggedIn':'EXLEShelfTileGuest'}"/>



<%-- displayed content --%>
<%-- dumping userName in window.EXLUserName if logged in - used to disable stuff in userMenu on document ready if not logged in - FIXME: this is not too pretty, but it will work for now HAFE --%>
<c:if test="${loggedIn}">
<script type="text/javascript">window.EXLUserName = '${userName}'</script>
</c:if>
<%-- userName dumping /HAFE --%>

<!-- this feedback unnecesary
<c:if test="${not empty errorString}">
		<div class="EXLHighlightError">${errorString}</div>
</c:if>
-->

<prm:boomerang id="SignInStatUserArea" boomForm="${searchForm}" pageId="sign-in"
				opId="click" resultDoc="${searchForm.searchResult.results[0]}" type=""
				delivery="${searchForm.delivery[0]}" noOther="true" index="${param.indx}"/>
<prm:boomerang id="SignOutStat" boomForm="${searchForm}" pageId="sign-out"
				opId="click" resultDoc="${searchForm.searchResult.results[0]}" type=""
				delivery="${searchForm.delivery[0]}" noOther="true" index="${param.indx}"/>

<c:if test="${requestScope.isNewSession != null && requestScope.isNewSession eq 'true'}">
    <c:set var="ssologinRequest" value="${requestScope.ssologinRequest}"/>
    <c:if test="${ssologinRequest != null}">
        <iframe id="exlIdssoLogin" src="" height="0px" width="0px"></iframe>
    </c:if>
</c:if>

<div id="exlidUserAreaRibbon" class="pull-right">

    <%-- Language --%>
    <div class="btn-group">
        <button href="#" class="btn btn-link navbar-btn" data-toggle="dropdown">
            <span class="glyphicon glyphicon-flag"></span>
            <span class="hidden-sm"><fmt:message key="mainmenu.label.language" /></span>
            <span class="caret"></span>
        </button>
        <ul id="exlidLanguages" class="EXLLanguageMenuShow EXLLanguageMenuHide dropdown-menu">
            <c:forEach items="${form.interfacaLangs}" var="option" varStatus="status">
                <c:url var="preferencesURL" value="preferences.do?prefBackUrl=${url}%26vid=${fn:escapeXml(sessionScope.vid)}" >
                    <c:param name="fn" value="change_lang"/>
                    <c:param name="vid" value="${fn:escapeXml(sessionScope.vid)}"/>
                    <c:param name="prefLang" value="${option}"/>
                </c:url>
                <c:choose>
                    <c:when test="${not empty sessionScope.chosenInterfaceLanguage and sessionScope.chosenInterfaceLanguage == option}">
                        <li id="exlidSelectedLanguage" class="EXLLanguageLink">
                            <a href="#">
                                <span class="glyphicon glyphicon-ok pull-right"></span>
                                <fmt:message key='mypref.language.option.${option}' />
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="EXLLanguageLink EXLLanguageLinkHide">
                            <a href="${fn:escapeXml(preferencesURL)}" class="EXLLanguageOptionLANG${option}" title="${lang_title} ${lang_name}">
                                <fmt:message key='mypref.language.option.${option}' />
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </ul>
    </div>
    <%-- Language end --%>

    <%-- New User --%>
    <%-- NOTE: Skal IKKE vises når man er logget ind --%>
    <div class="btn-group">
        <c:set var="newBorrowerUrl" value="https://user.kb.dk/user/create" />
        <c:choose>
            <c:when test="${sessionScope.chosenInterfaceLanguage == 'da_DK'}">
                <button onclick="window.location.href='<c:out value="${newBorrowerUrl}"/>?locale=da_DK'" class="btn btn-primary navbar-btn" target="_blank">
                    <span class="glyphicon glyphicon-user"></span>
                    <span class="hidden-sm">Ny låner</span>
                </button>
            </c:when>
            <c:otherwise>
                <button onclick="window.location.href='<c:out value="${newBorrowerUrl}"/>?locale=en_US'" class="btn btn-primary navbar-btn" target="_blank">
                    <span class="glyphicon glyphicon-user"></span>
                    <span class="hidden-sm">New user</span>
                </button>
            </c:otherwise>
        </c:choose>
    </div>
    <%-- New User end --%>

    <%-- Login User --%>
    <%-- NOTE: Skal KUN vises når man ER logget ind --%>
    <div class="btn-group">
        <button class="dropdown-toggle btn btn-primary navbar-btn" data-toggle="dropdown">
            <fmt:message key="eshelf.user.greeting">
                <span class="glyphicon glyphicon-user"></span>
                <span class="hidden-sm"><fmt:param value="${userName}"></fmt:param></span>
            </fmt:message>
            <span class="caret"></span>
        </button>

        <ul class="dropdown-menu">

            <%-- Din konto --%>
            <c:choose>
                <c:when test="${loggedIn}">
                    <li id="exlidMyAccount" class="EXLMyAccount">
                </c:when>
                <c:otherwise>
                    <li id="exlidMyAccount" class="EXLMyAccount disabled">
                </c:otherwise>
            </c:choose>
            <a href="${fn:escapeXml(myAccountUrl)}">
                <fmt:message key="menu.myaccount"/>
            </a>
            </li>
            <%-- Din konto End --%>

            <%-- Se og forny dine lån --%>
            <c:set var="renewUrl" value="http://pds.primo-17.kb.dk/pds?func=load-login&institute=KGL&calling_system=primo&url=http://rex.kb.dk:80/primo_library/libweb/action/login.do?afterPDS=true&vid=KGL&dscnt=1&targetURL=http://rex.kb.dk/primo_library/libweb/action/myAccountMenu.do?dscnt=0&vid=" />
            <c:choose>
                <c:when test="${loggedIn}">
                    <li>
                </c:when>
                <c:otherwise>
                    <li id="exlidMyAccount" class="disabled">
                </c:otherwise>
            </c:choose>
            <a href="<c:out value="${renewUrl}${vid}"/>">
            <c:choose>
                <c:when test="${sessionScope.chosenInterfaceLanguage == 'da_DK'}">
                    Se og forny dine lån
                </c:when>
                <c:otherwise>
                    Renew loans
                </c:otherwise>
            </c:choose>
            </a>
            </li>
            <%-- Se og forny dine lån End --%>

            <%-- Søgehistorie --%>
            <li id="exlidMyShelf" class="EXLMyShelf">
                <a href="${fn:escapeXml(eshelfURL)}">
                    <span class="EXLMyShelfStarSelected"></span><fmt:message key="eshelf.basket.title"/>
                </a>
            </li>
        </ul>
    </div>
    <%-- Login User End --%>

    <%-- Log ind / Log ud --%>
    <c:if test="${requestScope.isNewSession != null && requestScope.isNewSession eq 'true'}">
        <c:set var="ssologinRequest" value="${requestScope.ssologinRequest}"/>
        <c:if test="${ssologinRequest != null}">
            <input type="hidden" value="${ssologinRequest}" id="exlIdssologinRequest"/>
        </c:if>
    </c:if>
    <c:set var="hideSignOutClass" value=""/>
    <c:set var="hideSignInClass" value=""/>

    <c:choose>
        <c:when test="${loggedIn}">
            <c:set var="hideSignInClass" value="EXLHidden hidden"/>
        </c:when>
        <c:otherwise>
            <c:set var="hideSignOutClass" value="EXLHidden hidden"/>
        </c:otherwise>
    </c:choose>

    <div id="exlidSignOut" class="EXLSignOut EXLLastItem ${hideSignOutClass} btn-group">
        <button onclick="window.location.href='${fn:escapeXml(logoutUrl)}'" <%--TJAN onclick="boomCallToRum('SignOutStat',false);"--%> class="btn btn-danger navbar-btn">
            <span class="glyphicon glyphicon-off"></span>
            <span class="hidden-sm"><fmt:message key="eshelf.signout.title.link"/></span>
        </button>
    </div>

    <div id="exlidSignIn" class="EXLSignOut EXLLastItem ${hideSignInClass} btn-group">
        <button onclick="window.location.href='${fn:escapeXml(loginUrl)}'" <%--TJAN onclick="boomCallToRum('SignInStatUserArea',false);addResolutionParam(this);"--%> class="btn btn-success navbar-btn">
            <span class="glyphicon glyphicon-lock"></span>
            <span class="hidden-sm"><fmt:message key="eshelf.signin.title"/></span>
        </button>
        &nbsp; <fmt:message key="eshelf.additional.text"/>
    </div>

</div>

<script type="text/javascript">
    var userInst = "${sessionScope.userInfo.pdsInstitute}";
</script>


