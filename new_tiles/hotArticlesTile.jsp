<!-- begin hotArticlesTile.jsp -->
<%@ include file="/views/taglibsIncludeAll.jspf" %>


<c:set var="showString"><fmt:message key="default.results.bX.ha.show"/></c:set>
<c:set var="hideString"><fmt:message key="default.results.bX.ha.hide"/></c:set>

<input id="showString" type="hidden" value="${showString}"/>
<input id="hideString" type="hidden" value="${hideString}"/>

<c:if test="${not empty form.searchResult.results}">
	<div onclick="showhidebox();" id="showhidediv" style="font-family: Arial,verdana; font-size: 80%; font-weight: bold; color: #0075B0; cursor: pointer; padding-bottom: 20px; padding-left: 5px">
		<a href="#"  style="text-decoration: none;">
			<span id="showhide">${showString}</span>
			<img id="showhideimage" alt="${showString} image" style="padding-left: 5px; text-decoration:none" src="../images/../images/icon_open_subMenu.png"/>
		</a>
	</div>	
	
	<c:set var="issn"></c:set>
	 <c:forEach var="item" items="${fn:split(param.issn, ',')}" varStatus="pStatus">
	 	
	 	<c:if test="${pStatus.index<5}">
		 	<c:set var="issn">${issn}&amp;issn${pStatus.index+1}=${item}</c:set> 	
		         <!-- ITEM  ${item} -->
		</c:if>
	 </c:forEach>
	
	
	<input id="instCode" type="hidden" value="${institutionCode}"/>
	<input id="issnString" type="hidden" value="${issn}"/>
	<input id="token" type="hidden" value="${hatoken}"/>
	<input id="baseurl" type="hidden" value="${baseurl}"/>
	<input id="userLocale" type="hidden" value="${userLocale}"/>
</c:if>
<script type="text/javascript">
	var loaded = false;
	
	function createTile(){	
		
		loadHATile();
		var isGenericToken = ((document.getElementById("token").value=='primo-generic')?true:false);
		var haDiv = document.getElementById("hotArticlesFrame");
		
		var bxFrame = document.createElement("iframe");
		bxFrame.id = "bXFrame";
		bxFrame.align = "center";
		bxFrame.scrolling = "no";
		bxFrame.height = "210";
		bxFrame.frameborder = "0";
		bxFrame.width = "100%";
		bxFrame.title = "Hot Articles from bX";
		bxFrame.src = "http://bx.ha.service.exlibrisgroup.com/service/hotarticles?instCode=" + 
				document.getElementById("instCode").value +
				"&format=html&token=" + 
				document.getElementById("token").value +
				document.getElementById("issnString").value + 
				"&locale=" + document.getElementById("userLocale").value + 
				(isGenericToken?"&baseurl=" + document.getElementById("baseurl").value:"");
		
				
		if (navigator.userAgent.indexOf("MSIE") > -1 && !window.opera) {
			bxFrame.onreadystatechange = function(){
				if (bxFrame.readyState == "complete"){
					loaded = true;
					document.getElementById('exliLoadingHA').style.display='none';
					document.getElementById('exliWhiteContent').style.display='none';
				}
			}; 
		}else {
			bxFrame.onload = function(){
				loaded = true;
				document.getElementById('exliLoadingHA').style.display='none';
				document.getElementById('exliWhiteContent').style.display='none';
			}; 
		}
		
		$(haDiv).append(bxFrame);
	}

	function showhidebox() {
		
		boomCallToRum('hotArticles',false);
		
		var successHandler = function(url,errorAdditional,successFunction,e,data){			
		
		};
		
		generalAjaxCall('../ajaxClickThroughStatisticsServlet',false,successHandler,e);//click through statistics
		
		var frameNotExist = document.getElementById("bXFrame") == null;
		if (frameNotExist){
			createTile();
		}
		
		
		frameIsClosed = document.getElementById("hotArticlesFrame").style.display == "none";
	
		if (frameIsClosed != true) {
			document.getElementById("hotArticlesFrame").style.display = "none";
			
			if (document.getElementById('exliLoadingHA').style.display != 'none') {//removing the loading div, if exists
				document.getElementById('exliLoadingHA').style.display='none';
				document.getElementById('exliWhiteContent').style.display='none';
			}

			document.getElementById("showhide").innerHTML = document.getElementById("showString").value;
			document.getElementById("showhideimage").src = "../images/icon_open_subMenu.png";
			document.getElementById("showhidediv").style.paddingBottom = "20px";
		} else {
			if (document.getElementById("hotArticlesFrame") != null && document.getElementById("hotArticlesFrame").innerHTML.indexOf("html"))
				document.getElementById("hotArticlesFrame").style.display = "block";
			if (!loaded && !frameNotExist){//adding the loading div if it's in loading
					document.getElementById('exliLoadingHA').style.display = "block";
			}
			document.getElementById("showhide").innerHTML = document.getElementById("hideString").value;
			document.getElementById("showhideimage").src = "../images/icon_close_subMenu.png";
			document.getElementById("showhidediv").style.paddingBottom = "4px";
		}
	}
	
	
	function loadHATile(){
		

		var whiteContent = document.getElementById('exliWhiteContent');
		if($('#exliWhiteContent').size() == 0){
			var whiteContent = document.createElement("div");
			$(whiteContent).attr("id","exliWhiteContent");
			$(whiteContent).attr("style","display: none;");
		}
		
		var loadingHA = document.getElementById('exliLoadingHA');
		if($('#exliLoadingHA').size() == 0){
			var loadingHA = document.createElement("div");
			$(loadingHA).attr("id","exliLoadingHA");
			$(loadingHA).attr("style","display: block;");
			$(loadingHA).attr("class","exliLoadingHA");
		}
		$('body')[0].appendChild(whiteContent);
		$('body')[0].appendChild(loadingHA);
		document.getElementById('exliLoadingHA').style.display='block';
		
	}
	
	

</script>
<noscript>This feature requires javascript</noscript>

<div id="hotArticlesFrame" style="margin: 0px; padding: 0px;display: none"></div>

<prm:boomerang id="hotArticles" boomForm="${searchForm}" pageId="brief"
				opId="clickbXHA" resultDoc="${searchForm.searchResult.results[0]}" type=""
				delivery="${searchForm.delivery[0]}" noOther="true" index="${param.indx}"/>


<!-- end hotArticlesTile.jsp -->