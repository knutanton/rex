<%@ include file="/views/taglibsIncludeAll.jspf" %>

<div style="width:100%;text-align:center;margin:30px;">
<img src="../images/logo.png" style="margin-bottom:100px;display:block;"/>
<c:set var="errorCode"  value="${param.messageCode}"/>


<c:choose>
<c:when test="${not empty errorCode}">
            <fmt:message key="${errorCode}">
                  <fmt:param>${sessionScope.institution}</fmt:param>
            </fmt:message>
</c:when>
<c:otherwise>
    <fmt:message key="unknown.view.Requested_Page_Was_Not_Found"/>
</c:otherwise>
</c:choose>

</div>