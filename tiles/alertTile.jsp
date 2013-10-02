<%@ include file="/views/taglibsIncludeAll.jspf" %>

<div class="alert alert-warning">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <c:if test="${locale == 'da_DK'}">
		<strong>Advarsel !</strong> Rex er ude af drift den. 7/10/2013 pga. opdatering af system.
	</c:if>
	<c:if test="${locale != 'da_DK'}">
		<strong>Warning !</strong> Rex is down due to maintanece. 7/10/2013.
	</c:if>
</div>