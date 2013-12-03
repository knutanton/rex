<!-- begin javascriptTextIncludes.jsp -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>
<script type="text/javascript">
<c:set var="msg"><fmt:message key="search.results.tabs.messages.exlTabReloadMessage.Try_reloading"/></c:set>
var exlTabReloadMessage = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="search.results.tabs.messages.exlTabReloadLinkText.Click_here"/></c:set>
var exlTabReloadLinkText = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="search.results.tabs.messages.exlTabLoadErrorMessage.Error_loading_tab"/></c:set>
var exlTabLoadErrorMessage = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="search.results.tabs.messages.exlDelayTabProcessingYourRequest.Processing_your_request"/></c:set>
var exlDelayTabProcessingYourRequest = '${fn:replace(msg,"'","\\'")}'; //Processing your request...

<c:set var="msg"><fmt:message key="finddb.sb.Try_reloading"/></c:set>
var exlFdbReloadMessage = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="finddb.sb.Click_here"/></c:set>
var exlFdbReloadLinkText = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="dbinfo.noInfo"/></c:set>
var exlFdbNoInfoMessage = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="finddb.sb.index.subcat"/></c:set>
var exlFdbSubCategoryLabel = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="reviews.signintopostreview"/></c:set>
var exlTabSignInMessage = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="facets.title"/></c:set>
var facetsTitleLabel = '${fn:replace(msg,"'","\\'")}';

<c:set var="msg"><fmt:message key="rta.updating" /></c:set>
var updatingMessage = '${fn:replace(msg,"'","\\'")}';

</script>
<!-- end javascriptTextIncludes.jsp -->
