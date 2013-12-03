<%@ include file="/views/taglibsIncludeAll.jspf" %>
<%@ include file="/javascript/TagsReviews.js" %>

<link rel="stylesheet" type="text/css" href="../css/temp.css" />

<%@page import="com.exlibris.primo.utils.SessionUtils"%>


<c:if test="${tagReviewsForm!=null}">
<c:choose>
	<c:when test="${not empty tagReviewsForm.displayMode}">
		<c:set var="displayMode" value="${tagReviewsForm.displayMode}" />
	</c:when>
	<c:otherwise>
		<c:set var="displayMode" value="${param.displayMode}" />
	</c:otherwise>
</c:choose>
<c:if test="${recordResultIndex eq '-1'}">
	<c:set var="recordResultIndex" value="0"/>
</c:if>
<form id="tagsReviews${recordResultIndex}" action="/primo_library/libweb/action/tagReviews.do?renderMode=prefetchXml&amp;tabs=tagreviewsTab&amp;recIds=${recordId}&amp;recIdxs=${recordResultIndex}&amp;recordId=${recordId}&amp;displayMode=${displayMode}">
<input type="hidden"  id="recordResultIndex" value="${recordResultIndex}"/>
<div id="exlidResult${resultStatus.index}-TabHeader" class="EXLTabHeader">
       <div class="EXLTabHeaderContent"> </div>
     <div id="exlidTabHeaderButtons${recordResultIndex}" class="EXLTabHeaderButtons">
	          	<prm:sendTo recordId="${recordId}"  pushToTypeList="${form.pushToTypeList}" fromEshelf="${form.fromEshelf}" fn="${form.fn}"  inBasket="${form.inBasket[0]}" tabForm="${tagReviewsForm}" />
        </div>
      </div>

      <c:set var="result" value="${tagReviewsForm.recordsMap[recordId]}"/>
      <c:set var="recordId" value="${recordId}" />
      <c:set var="rateReview" value="1"/>
      <c:set var="review_text" value="" />
		
		<c:url var="loginUrl" value="login.do">
		  		<c:param name="loginFn" value="signin" />
	  			<c:param name="targetURL" value="<%=(SessionUtils.getSearchFrom(request) != null) ? SessionUtils.getSearchFrom(request).getReqEncUrl() : request.getRequestURI()+'?'+request.getQueryString()%>"/>
		</c:url>

	  <div id="exlidResult${recordResultIndex}-TabContent" class="EXLTabContent EXLReviewsTagsTabContent">
        <div id="EXLReviewsContent${recordResultIndex}" class="EXLReviewsContent" >
	   <p id="writeRev${recordResultIndex}" class="EXLReviewsWriteReviewMarker"  >
          	<span class="EXLReviewIcon"  ></span>

        <c:choose>
          <c:when test="${sessionScope.loggedIn == 'true'}">
          	<a href="#" onclick="new_review(${recordResultIndex}); return false;" title="<fmt:message key='default.tags.postYourReview'/>"><fmt:message key="default.tags.postYourReview" />
          	</a>
          </c:when>
          <c:otherwise>
         	<c:set var="targetUrlValue" value="${requestScope.popOutUrlForLogin}"/>          		
			<c:if test="${form.tabEshelfLoginUrl != null }">
				<c:set var="targetUrlValue" value="${form.tabEshelfLoginUrl}"/>
			</c:if>
			<c:url var="loginUrl" value="login.do">
				<c:param name="loginFn" value="signin" />
			  	<c:param name="vid" value="${primoView.id}"/>
 			  	<c:param name="targetURL" value="${targetUrlValue}"/>
			  	<c:param name="tabs" value="tagreviewsTab"/>												  	
			</c:url>	
			<a href="${fn:escapeXml(loginUrl)}" onclick="boomCallToRum('SignInStatTagsReviews',false);addResolutionParam(this);" target="_parent" id="REVIEWS_SIGN_IN_${recordResultIndex}" title="<fmt:message key="default.reviews.signintopostreview" />">
				<fmt:message key="default.reviews.signintopostreview"/>
			</a>
          </c:otherwise>
        </c:choose>
          </p>

          <c:forEach items="${result.reviewList}" var="review">
	<c:if test="${ ! empty review}">
          	<p>
          		<cite>
          		           <c:if test="${review.param2}">
			<c:out value="${review.param3}"/>
		            </c:if>
			<input type="hidden" id="reviewUserId_${review.id}" name="reviewUserId_${review.id}"  value="${review.userId}" />
    		<c:if test="${sessionScope.loggedIn == 'true' && review.userId==sessionScope.userId}">
			(<a class="EXLReviewEditLink" href="#"
				onclick="prepare_edit(${recordResultIndex}, '${review.param1}','${review.param2}',${review.id}); return false;" title="<fmt:message key='link.title.reviews.edit'/>">
				<fmt:message key="default.reviews.edit"/>
			</a>/
			<a  class="EXLReviewDeleteLink" href="#"
				onclick="remove(${recordResultIndex}, ${review.id}); return false;"
				title="<fmt:message key='link.title.reviews.delete'/>">
				<fmt:message key="default.reviews.remove"/>

			</a>)
			</c:if>
		 </cite>
          	<span class="EXLReviewRating">
          		<c:choose>
          		<c:when test="${review.param1==1 }">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating05'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating05.alt'/>" />
	  			</c:when>
				<c:when test="${review.param1==2 }">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating1'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating1.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==3}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating15'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating15.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==4}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating2'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating2.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==5}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating25'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating25.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==6}">
	  				<img src="<fmt:message key='default.ui.images.tagsreviews.rating3'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating3.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==7}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating35'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating35.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==8}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating4'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating4.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==9}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating45'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating45.alt'/>" />
	  			</c:when>
	  			<c:when test="${review.param1==10}">
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating5'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating5.alt'/>" />
	  			</c:when>
				<c:otherwise>
					<img src="<fmt:message key='default.ui.images.tagsreviews.rating05'/>" alt="<fmt:message key='default.ui.images.tagsreviews.rating05.alt'/>" />
				</c:otherwise>
				</c:choose>
          	</span>
          	<c:set var="fullReview" value="${review.extensionClob}"/>
          	<q>

          	<c:choose>
			<c:when test="${fn:length(fullReview) > 200}">
			<c:set var="miniReview" value="${fn:substring(fullReview,0,200)}"/>
			<c:set var="fullReviewDisplay" value="inline"/>
			<c:set var="partialReviewDisplay" value="none"/>
			<c:if test="${param.displayMode!='full'}">
				<c:set var="fullReviewDisplay" value="none"/>
				<c:set var="partialReviewDisplay" value="inline"/>
			</c:if>
			
			
				<span id="ext_val_${review.id}" style="display:none;">${miniReview}</span>
				<span id="more_${review.id}" class="EXLTagsReviewsMoreReviewContentLink">(<a href="#" onclick="showMore('${review.id}',this);return false;" title="<fmt:message key='link.title.reviews.more'/>"><fmt:message key="default.reviews.more"/></a>)</span>
				<span id="ext_val_more_${review.id}" class="EXLTagsReviewsMoreReviewContent">${fullReview}</span>

				<script type="text/javascript">
					try{
						document.getElementById("ext_val_more_${review.id}").style.display = '${fullReviewDisplay}';
						document.getElementById("ext_val_${review.id}").style.display = '${partialReviewDisplay}';
						document.getElementById("more_${review.id}").style.display = '${partialReviewDisplay}';
						var isIE = navigator.userAgent.indexOf("MSIE") != -1;
						if (isIE){
							q = document.getElementById("ext_val_${review.id}");
							var text = q.innerText;
							q.innerHTML = '&quot;' + text + '&quot;'
						}
					}catch(e){}
				</script>
			</c:when>
			<c:otherwise>
				<span id="full_review_text_${review.id}">${fullReview}</span>
				<script type="text/javascript">
					try{
						var isIE = navigator.userAgent.indexOf("MSIE") != -1;
						if (isIE){
							q = document.getElementById("full_review_text_${review.id}");
							var text = q.innerText;
							q.innerHTML = '&quot;' + text + '&quot;'
						}
          			}catch(e){}
          		</script>
			</c:otherwise>
			</c:choose>
			</q>
          	</p>
          	</c:if>
          </c:forEach>
          
          	<c:set var="additionalReviewsURL" value="${fn:replace(requestScope.sendToPopOutUrl,'beginIndexReviews=','beginIndexReviewsDummy=')}&beginIndexReviews=${tagReviewsForm.reviewsFetched[recordId]}&bulkSizeReviews=${tagReviewsForm.bulkSizeFull}" />
          	<c:set var="additionalReviewsUrlText" value="viewMoreReviews" />
          	<c:set var="linkId" value="EXLLocationViewMoreLink" />
          	<c:set var="messageParameter" value="" />
          	
			<c:if test="${param.displayMode!='full'}">
				<c:set var="additionalReviewsURL" value="${requestScope.sendToPopOutUrl}&reviewsTotalParam=${tagReviewsForm.reviewsTotal[recordId]}" />
				<c:set var="additionalReviewsUrlText" value="seeAllReviews" />
				<c:set var="linkId" value="EXLLocationViewAllLink" />				
				<c:set var="messageParameter" value="${tagReviewsForm.reviewsTotal[recordId]}" />
			</c:if>			
			
			<c:if test="${tagReviewsForm.reviewsTotal[recordId] > tagReviewsForm.reviewsFetched[recordId]}">
				<!--  check if there are more results  -->				
				<div class="EXLREeviewsViewAllLink">
					<span>															
						<a id="${linkId}" href="${additionalReviewsURL}" target="_blank">
							<fmt:message key="default.reviews.${additionalReviewsUrlText}">
								<fmt:param>${messageParameter}</fmt:param>
							</fmt:message>
							<c:if test="${param.displayMode=='full'}">
								<img src="<fmt:message key='default.ui.images.resultsheadernumbers.arrowsendto'/>" alt="<fmt:message key='default.reviews.${additionalReviewsUrlText}'/>"/>
							</c:if>
						</a>								
					</span>
				</div>				
			</c:if>			         
			<script type="text/javascript">
				try{
						reviewsNavigation();
					}catch(reviewsNavigationErr){
						log('reviews navigation setup failed:'+reviewsNavigationErr);
					}	   
			</script>     
        </div>

		<div id="review_form${recordResultIndex}" class="EXLReviewTabReviewForm" style="display:none"><br/>
			<div class="EXLReviewTabFormRow" >
				<label for="rateReview${recordResultIndex}"><fmt:message key="default.reviews.rateReview"/></label>
				<html:select styleClass="EXLReviewEditRatingSelect" styleId="rateReview${recordResultIndex}" property="rateReview" value="${rateReview}">
					<c:forEach begin="1" end="10" step="1" varStatus="status">
						<html:option  value="${status.index}"/>
					</c:forEach>
				</html:select>
			</div>

			<div class="EXLReviewTabFormRow">
				<div class="EXLReviewTextArea">
					<label  for="review_text${recordResultIndex}"><fmt:message key='reviews.textarea.label'/></label>
					<html:textarea styleId="review_text${recordResultIndex}" cols="45" rows="5"  property="review_text" value="${review_text}"/>
				</div>
			</div>
			<div class="EXLReviewTabFormRow" >
			              <input name="displayReviewWriter" type="checkbox"  id="displayReviewWriter"  />
			              <label for="displayReviewWriter"><fmt:message key="default.reviews.agreeReviewWriter"/></label>
			</div>
			 <div class="EXLReviewTabFormRow">
			              <input name="agree04${recordResultIndex}" type="checkbox" value="" id="agree04${recordResultIndex}"/>
			              <label for="agree04${recordResultIndex}"><fmt:message key="default.reviews.agreeReview"/> <em class="EXLHide"> (required)</em></label>
			</div>

			<div class="EXLReviewFormRowLinkButtons">
		            		<input type="hidden" id="recordId" name="recordId"  value="${recordId}" />
				<%--
					commented out following two lines, because it causes recIds array contains a
					recId twice. same problem to recIdxs.
				<input type="hidden" id="recIds" name="recIds" value="${recordId}" />
				<input type="hidden" id="recIdxs" name="recIdxs" value="${recordResultIndex}" />
				--%>
				<input type="hidden" id="executeMode" name="executeMode"   />
				<input type="hidden" id="reviewId" name="reviewId" value="0" />
				<input type="hidden" id="index" name="index" value="${recordResultIndex}" />
		            		<div class="EXLReviewFormButton">
     					 <input name="Submit" type="submit" value="<fmt:message key='default.tags.submit'/>" id="exlidReviewFormSubmit" onclick="boomCallToRum('addreview${param.recIdxs}',false);return edit_save(${recordResultIndex});"/>
    				</div>
				 <div class="EXLReviewFormButton EXLReviewFormButtonCancel">
				              <input name="Submit" type="button" value="<fmt:message key='default.tags.cancel'/>" id="exlidReviewFormCancel" onclick="cancel(${recordResultIndex}); return false;"/>
				 </div>

			</div>

		</div>


        <!--All Tags-->
        <div class="EXLTagsContainer" >
        	<c:set var="limit_my_tags" value="7"/>
	<c:set var="limit_everybody_tags" value="7"/>
	<c:set var="fromEshelf" value="${form.fromEshelf}"/>
	<c:set var="scopsid">
		<%--find the first scope componet id --%>
		${sessionScope.lastSearchForm.componentType2ComponentIds.scope[0]}
	</c:set>
	<c:url value="search.do" var="tag_search_url">
		<c:param name="${action_func}" value="search" />
		<c:param name="vl(${scopsid})" value="usertag"/>
		<c:param name="vl(1UI0)" value="exact"/>
		<c:param name="mode" value="${sessionScope.lastSearchForm.mode}" />
		<c:param name="vid" value="${sessionScope.vid}" />
		<c:param name="fromEshelf" value="${fromEshelf}"/>
		<c:param name="tagsSearch" value="true" />
	</c:url>

        <p>
        	<c:url var="new_tag_url" value="addNewTagAction.do">
		<c:param name="${action_func}" value="openAssignTags"/>
		<c:param name="recordId" value="${recordId}"/>
		<c:param name="index" value="${recordResultIndex}"/>
		<c:param name="vid" value="${sessionScope.vid}"/>
		<c:param name="fromEshelf" value="${fromEshelf}"/>
		<c:param name="displayMode" value="${displayMode}" />
		<c:param name="backUrl" value="${requestScope.resultTileDisplayURL_reqDecQryUTF8}" />
	</c:url>
	<span class="EXLTagIcon"></span>

	<c:choose>
      <c:when test="${sessionScope.loggedIn == 'true'}">
	<a href="${fn:escapeXml(new_tag_url)}" target="popup" class="cancel"
		onclick="boomCallToRum('addtag${param.recIdxs}',false);openWindow(this.href, this.target, 'top=100,left=50,width=770,height=620,resizable=1,scrollbars=1'); return false;"
		title="<fmt:message key='default.tags.addNewTag'/>"><fmt:message key="default.tags.addNewTag" />
	</a>
	</c:when>
	<c:otherwise>
  		<c:set var="targetUrlValue" value="${requestScope.popOutUrlForLogin}"/>          		
 		<c:if test="${form.tabEshelfLoginUrl != null }">
			<c:set var="targetUrlValue" value="${form.tabEshelfLoginUrl}"/>
		</c:if>        	
		<c:url var="loginUrl" value="login.do">
			<c:param name="loginFn" value="signin" />
			<c:param name="vid" value="${primoView.id}"/>
			<c:param name="targetURL" value="${targetUrlValue}"/>
			<c:param name="tabs" value="tagreviewsTab"/>												  	
		</c:url>

													
		<a href="${fn:escapeXml(loginUrl)}" target="_parent" onclick="boomCallToRum('SignInStatTagsReviews',false);addResolutionParam(this);" id="TAGS_SIGN_IN_${recordResultIndex}" title="<fmt:message key="default.reviews.signintoaddnewtags"/>">
			<fmt:message key="default.reviews.signintoaddnewtags"/>
		</a>												
    </c:otherwise>
	</c:choose>

        </p>

        <div id="everyTags${recordResultIndex}" class="EXLTagsLinks EXLTagsLinksExpand" >
        <div >
	<span  class="EXLTagsLinksClosed">
		<a href="#" title="<fmt:message key="default.tags.collapseList"/>" >
		<img src="<fmt:message key='default.ui.images.tagsreviews.minus'/>"
			alt="<fmt:message key="default.tags.collapseList"/>"
			border="0" style="cursor:pointer; " />
		</a>
	</span>

	<span class="EXLTagsLinksHeader">
		<em><fmt:message key="tags.allTags"/></em>

		<a title="<fmt:message key="default.tags.cloudView"/>"  href="#" onclick="Tags_Cloud_list(false, 2, ${recordResultIndex}); return false;" ><fmt:message key="tags.Cloud"/>
		</a>
	</span>
</div>

          <ul >
            <c:set var="count" value="0"/>
            <c:forEach items="${result.everybodyRecordTags}" var="everybodyTag">

	<c:set var="count" value="${count+1}"/>
	<c:url value="${tag_search_url}" var="new_search_url">
		<c:param name="vl(${c_ctype_freetext}0)" value="${everybodyTag.extension.extensionValue}"/>
	</c:url>
	<li>
		<span class="EXLTagsLinksTitle">
		<c:if test="${count != 1}"><br></br> </c:if>
		<a href="${fn:escapeXml(new_search_url)}" target="_parent" title="<bean:write name="everybodyTag" property="extension.extensionValue"/>: ${tagReviewsForm.recordsMap[recordId].userForEveryTag[everybodyTag.extension.extensionValue]} users">
		<exlibris-html:truncate value="${everybodyTag.extension.extensionValue}" characters="35"/>
		</a>
		<span class="EXLTagCount">(${everybodyTag.extension.countValue})</span>
		</span>
	</li>
          </c:forEach>
          </ul>
        </div>

        <div id="everyCloudDiv${recordResultIndex}"  class="EXLTagsLinks EXLTagsLinksExpand" style="display:none">
		<div>
  			<span class="EXLTagsLinksClosed">
  				<a href="#" title="<fmt:message key='default.tags.collapseList'/>">
  				<img src="<fmt:message key='default.ui.images.tagsreviews.minus'/>" alt="<fmt:message key='default.tags.collapseList'/>"   border="0" style="cursor:pointer; "/>
  				</a>
  			</span>
  			<span class="EXLTagsLinksHeader">
  				<em><fmt:message key="tags.allTags"/></em>
  				<a href="#" title="<fmt:message key='default.tags.listView'/>" onclick="Tags_Cloud_list(true, 2, ${recordResultIndex}); return false;" >
  					<fmt:message key="tags.List"/>
  				</a>
  			</span>
  		</div>
	<ul >
		<c:forEach items="${result.everybodyRecordTagsWeighted}" var="weightedTag"  >
			<c:url value="${tag_search_url}" var="new_search_url">
				<c:param name="vl(${c_ctype_freetext}0)" value="${weightedTag.extension.extensionValue}"/>
			 </c:url>
				<li>
			<c:choose>
				<c:when test="${weightedTag.fontSize==1}">
					<a class="cloud0 EXLCloud0 EXLTagCloudWEIGHT${weightedTag.fontSize}"  target="_parent" href="${fn:escapeXml(new_search_url)}" title="<bean:write name="weightedTag" property="extension.extensionValue"/>: ${tagsReviewsTabForm.userForEveryTag[weightedTag.extension.extensionValue]} users">
						<exlibris-html:truncate value="${weightedTag.extension.extensionValue}" characters="35"/>
					</a>
				</c:when>
				<c:when test="${weightedTag.fontSize==2}">
					<a class="cloud25 EXLCloud25 EXLTagCloudWEIGHT${weightedTag.fontSize}"  target="_parent" href="${fn:escapeXml(new_search_url)}" title="<bean:write name="weightedTag" property="extension.extensionValue"/>: ${tagsReviewsTabForm.userForEveryTag[weightedTag.extension.extensionValue]} users">
						<exlibris-html:truncate value="${weightedTag.extension.extensionValue}" characters="35"/>
					</a>
				</c:when>
				<c:when test="${weightedTag.fontSize==3}">
					<a class="cloud50 EXLCloud50 EXLTagCloudWEIGHT${weightedTag.fontSize}"  target="_parent" href="${fn:escapeXml(new_search_url)}" title="<bean:write name="weightedTag" property="extension.extensionValue"/>: ${tagsReviewsTabForm.userForEveryTag[weightedTag.extension.extensionValue]} users">
						<exlibris-html:truncate value="${weightedTag.extension.extensionValue}" characters="35"/>
					</a>
				</c:when>
				<c:when test="${weightedTag.fontSize==4}">
					<a class="cloud75 EXLCloud75 EXLTagCloudWEIGHT${weightedTag.fontSize}"  target="_parent" href="${fn:escapeXml(new_search_url)}" title="<bean:write name="weightedTag" property="extension.extensionValue"/>: ${tagsReviewsTabForm.userForEveryTag[weightedTag.extension.extensionValue]} users">
						<exlibris-html:truncate value="${weightedTag.extension.extensionValue}" characters="35"/>
					</a>
				</c:when>
				<c:otherwise>
					<a class="cloud75 EXLCloud75 EXLTagCloudWEIGHT${weightedTag.fontSize}"  target="_parent" href="${fn:escapeXml(new_search_url)}" title="<bean:write name="weightedTag" property="extension.extensionValue"/>: ${tagsReviewsTabForm.userForEveryTag[weightedTag.extension.extensionValue]} users">
						<exlibris-html:truncate value="${weightedTag.extension.extensionValue}" characters="35"/>
					</a>
				</c:otherwise>
			</c:choose>
			</li>
		</c:forEach>
	</ul>
	<script type="text/javascript">

	//My Tags cloud-list toggling
	try{ Tags_Cloud_list(${is_tags_as_list}, 1, ${recordResultIndex}); }catch(e){}
	//Everybody's Tags cloud-list toggling
	Tags_Cloud_list(${is_tags_as_list}, 2, ${recordResultIndex});
	</script>
</div> <!-- everyCloudDiv -->



 <c:if test="${sessionScope.loggedIn == 'true'}">
        <!--My Tags-->
	<div id="myTags" class="EXLTagsLinks EXLTagsLinksExpand">

      		<div>
          			<span class="EXLTagsLinksClosed">
          				<a href="#" title="<fmt:message key='default.tags.collapseList'/>">
          					<img  src="<fmt:message key='default.ui.images.tagsreviews.minus'/>" alt="<fmt:message key='default.tags.collapseList'/>"    border="0" style="cursor:pointer; " />
          				</a>
          			</span>
          			<span class="EXLTagsLinksHeader">
          				<c:url var="tags_page_url" value="tagsAction.do">
					<c:param name="${action_func}" value="showTagsPage"/>
					<c:param name="vid" value="${sessionScope.vid}"/>
					</c:url>
					<em><fmt:message key="tags.myTags"/></em>
        				<a href="${fn:escapeXml(new_tag_url)}" target="popup" class="cancel"
							onclick="openWindow(this.href, this.target, 'top=100,left=50,width=770,height=620,resizable=1,scrollbars=1'); return false;"
							title="<fmt:message key='default.tags.editMyTags'/>"><fmt:message key='default.tags.edit'/>
        				</a>
          			</span>
          		</div>


          		<ul >
          			<c:set var="count" value="0"/>
          			<c:forEach items="${result.myTags}" var="entry"  >
				<c:if test="${entry.value.recordAssigned && count<limit_my_tags}">
					<c:set var="count" value="${count+1}"/>
					<c:url value="${tag_search_url}" var="new_search_url">
						<c:param name="vl(${c_ctype_freetext}0)" value="${entry.key}"/>
					</c:url>
					<li>
						<span class="EXLTagsLinksTitle">
						<c:if test="${count != 1}"><br></br> </c:if>
							<a href="${fn:escapeXml(new_search_url)}"  target="_parent" title="<bean:write name="entry" property="key"/>: ${tagReviewsForm.recordsMap[recordId].userForMyTag[entry.key]} users">
								<exlibris-html:truncate value="${entry.key}" characters="35"/>
							</a>
							<span class="EXLTagCount">(${entry.value.extension.countValue})</span>
						</span>
					</li>
				</c:if>
			</c:forEach>

          		</ul>


        	</div><!--My Tags-->
      </c:if>

        </div>



	  </div>

		<prm:boomerang id="addtag${param.recIdxs}"  boomForm="${sessionScope.lastSearchForm}" pageId="brief"
		opId="addTag" resultDoc="${sessionScope.lastSearchForm.searchResult.results[param.recIdxs]}"
		type="addtag" delivery="${sessionScope.lastSearchForm.delivery[param.recIdxs]}" noOther="false" index="${param.indx}"/>

		<prm:boomerang id="addreview${param.recIdxs}"  boomForm="${sessionScope.lastSearchForm}" pageId="brief"
		opId="addReview" resultDoc="${sessionScope.lastSearchForm.searchResult.results[param.recIdxs]}"
		type="addreview" delivery="${sessionScope.lastSearchForm.delivery[param.recIdxs]}" noOther="false" index="${param.indx}"/>
		
		<prm:boomerang id="SignInStatTagsReviews" boomForm="${searchForm}" pageId="sign-in"
		opId="click" resultDoc="${searchForm.searchResult.results[0]}" type=""
		delivery="${searchForm.delivery[0]}" noOther="true" index="${param.indx}"/>
	
</form>
</c:if>
