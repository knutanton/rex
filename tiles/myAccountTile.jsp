<%@ page contentType="text/xml;charset=UTF-8" language="java"%>
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/views/include/setSearchForm.jspf"%>
<%--
 Custom tile that contains the personal menubar 
--%>


<%--Login status variable --%>
<c:set var="loggedIn" value="${false}"/>
<c:if test="${not empty sessionScope.loggedIn and sessionScope.loggedIn==true}">
	<c:set var="loggedIn" value="${true}"/>
</c:if>

<%--
This is a hack we dont want use
<c:if test="${sessionScope.myAccountMenuForm == null && loggedIn == true}">
	<iframe src="http://primo-97.kb.dk/primo_library/libweb/action/myAccountMenu.do" style="height:10px;"></iframe>
	<iframe src="http://primo-97.kb.dk/primo_library/libweb/action/basket.do?fn=display&fromUserArea=true&vid=kbdev01&fromPreferences=false" style="height:10px;"></iframe>
</c:if>
--%>


<%-- Søgehistorik 
<c:set var="sessionQueriesListLen">${fn:length(sessionScope.savedSessionQuery)}</c:set>
--%>

<%-- Favoritter 
<c:set var="node" value="${sessionScope.basketForm.root}"/>
<c:set var="itemsCount">
        <c:if test="${node.itemsCount > 0}">
                ${node.itemsCount}
        </c:if>
        <c:if test="${(node.itemsCount==0||node.itemsCount==null) && sessionScope.form.itemsCount>0}">
                ${sessionScope.form.itemsCount}
        </c:if>
</c:set>
--%>
<%-- Hjemlån 
${sessionScope.myAccountMenuForm.loansCounter}
--%>

<%-- Bestillinger
${sessionScope.myAccountMenuForm.requestCounter}
 --%>


<c:if test="${loggedIn == false}">
<pre>
                <a href="myAccountMenu.do?activity=personalSettings">Indstillinger</a>   |   <a href="basket.do?fn=display&fromUserArea=true&vid=${sessionScope.vid}&fromPreferences=false">Favoritter</a>   |   <a href="sessionQuery.do?fn=display&vid=${sessionScope.vid}">Søgninger</a>
</pre>
</c:if>
<c:if test="${loggedIn == true}">
<pre>
                ${sessionScope.userName} | <a href="myAccountMenu.do?activity=loans&command=list">Hjemlån</a> | <a href="myAccountMenu.do?activity=requests">Bestillinger</a> | <a href="basket.do?fn=display&fromUserArea=true&vid=${sessionScope.vid}&fromPreferences=false">Favoritter</a> | <a href="query.do?fn=display&vid=${sessionScope.vid}">Søgninger</a> | <a href="myAccountMenu.do?activity=fees">Gebyrer</a>
                <a href="myAccountMenu.do?activity=personalSettings">Indstillinger</a>
                <a href="http://kbkort.kb.dk/safecom/webuser.dll/login">Print konto</a>
</pre>
</c:if>





