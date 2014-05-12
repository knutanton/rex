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

<c:if test="${loggedIn == true}">
    <div id="KBMyAccountTile" class="bg-primary">
        <div class="container">

            <div class="btn-group btn-group-justified" role="toolbar">
                <a href="myAccountMenu.do?activity=loans&command=list" class="btn btn-primary">
                    <span class="glyphicon glyphicon-book"></span><br class="visible-xs">
                    <span>Hjemlån</span>
                </a>
                <a href="myAccountMenu.do?activity=requests" class="btn btn-primary">
                    <span class="glyphicon glyphicon-time "></span><br class="visible-xs">
                    <span>Bestillinger</span>
                </a>
                <a href="basket.do?fn=display&fromUserArea=true&vid=${sessionScope.vid}&fromPreferences=false" class="btn btn-primary">
                    <span class="glyphicon glyphicon-star"></span><br class="visible-xs">
                    <span>Favoritter</span>
                </a>
                <a href="query.do?fn=display&vid=${sessionScope.vid}" class="btn btn-primary">
                    <span class="glyphicon glyphicon-search"></span><br class="visible-xs">
                    <span>Søgninger</span>
                </a>
            </div>

        </div>
    </div>

</c:if>





