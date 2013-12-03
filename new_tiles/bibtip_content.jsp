<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@page import="java.util.*" %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="Content-Language" content="en"/>
	<title><fmt:message key="default.main.title" /></title>
	<link rel="stylesheet" type="text/css" href="../css/Primo_default.3.0.css" />
	<link rel="stylesheet" type="text/css" href="../css/bibTip.css" />
	 <base target="_blank">	 

	 <c:set var="recordid" value='<%= request.getParameter("recordId") %>'/>	 
	 <c:set var="title" value='<%= request.getParameter("title") %>'/>
	 <c:set var="creator" value='<%= request.getParameter("creator") %>'/>
	 <c:set var="creationdata" value='<%= request.getParameter("creationdate") %>'/>
	 <c:set var="isbn" value='<%= request.getParameter("isbn") %>'/>
	 <c:set var="bibResult" value='<%=request.getSession().getAttribute("bibtipresult_"+request.getParameter("recordId"))%>'/>
	
<script type="text/javascript" >
function querySt(name) {
	var getVars = new Array();
	var qString = unescape(window.location.href);
	var pairs = qString.split(/\&/);
	for (var i in pairs) {
		var nameVal = pairs[i].split(/\=/);
		if (nameVal[0] == name) {
           			return nameVal[1];
       		 }
       		 
	}		
}
	
</script>

<script type="text/javascript" src="../javascript/jquery/jquery-1.8.3.min.js">
$('a').live('click', function(){
	
     $(this).attr('target','_blank');

});
</script>

</head>
  
<body style="display: inline">
<!-- 	
<div id="exlidBibTipContainer" class="EXLBibTipContainer">
	<div> RECORDID -  ${recordid} </div>
	<div> TITLE -  ${title}  </div>	
	<div> ISBN  -  ${isbn} </div>
	<div> CREATOR - ${creator}  </div>
	<div> CREATION DATE -  ${creationdate} </div>	
-->		
	<div id="bibtip_isxn" style="display:none" >${isbn}</div><div id="bibtip_shorttitle" style="display:none" > ${title}/${creator};${creationdate}</div><div id="bibtip_id"  style="display:none" >${recordid}</div><script src="${bibResult.javascript}" type="text/javascript"></script><div style="display:none" id="bibtip_reclist"></div>

<!--/div -->
</body>
</html>
