<%@ include file="/views/taglibsIncludeAll.jspf" %>

<c:if test="${detailsForm!=null}">
<html:form action="/action/details.do">
	<div id="exlidResult${recordResultIndex}-TabHeader" class="EXLTabHeader">
		<div class="EXLTabHeaderContent"></div>
		<div id="exlidTabHeaderButtons${recordResultIndex}" class="EXLTabHeaderButtons">
	          	<prm:sendTo recordId="${recordId}"  pushToTypeList="${form.pushToTypeList}" fromEshelf="${form.fromEshelf}" fn="${form.fn}"  inBasket="${form.inBasket[0]}" tabForm="${detailsForm}" />
		</div>
	</div>

	<c:set var="result" value="${detailsForm.recordsMap[recordId]}"/>

	<div id="exlidResult${recordResultIndex}-TabContent" class="EXLTabContent EXLDetailsTabContent">
       <div class="EXLDetailsContent">
          <ul>
          	<c:set var="hasTitle" value="false"/>
          	<c:forEach items="${result.values.title}" var="titles" varStatus="status" >
				<c:if test="${not empty titles}">
					<c:set var="hasTitle" value="true"/>
				</c:if>
			</c:forEach>

			<c:if test="${hasTitle=='true'}">
	           	<li>
	          		<strong><fmt:message key='fulldisplay.title'/>:</strong>
	          		<c:forEach items="${result.values.title}" var="titles" varStatus="status" >
						<c:if test="${status.index>0}">
							<br/>
						</c:if>
						${titles}
					</c:forEach>
	          	</li>
          	</c:if>

          	<c:forEach items="${detailsForm.fulResultView}" var="line" varStatus="lineStatus">
				<c:set var="headingDisplayd" value="false"/>
				<c:set var="hasValue" value="false"/>

				<c:forEach items="${line}" var="field" varStatus="fieldStatus">
					<c:if test="${not empty result.values[field] and result.values[field] != null}">
						<c:set var="hasValue" value="true"/>
					</c:if>
				</c:forEach>

				<c:if test="${lineStatus.index >1 and hasValue=='true'}">
					<c:forEach items="${line}" var="field" varStatus="fieldStatus">
						<c:if test="${not empty result.values[field] and (field!='title' and field!='vertitle')}" >
							<li>
								<%-- none-linked field header --%>
								<c:if test="${(field != 'creator' and field !='subject' and field !='contributor')}">
									<c:if test="${!headingDisplayd}">
										<c:set var="heading">
											<fmt:message key='fulldisplay.${field}'/>
										</c:set>
										<c:if test="${not empty fn:trim(heading) and fn:trim(heading) != 'value_na'}">
											<%-- only displays when the field is not empty --%>
											<c:set var="hasData" value="false"/>
											<c:forEach items="${result.values[field]}" var="theValue">
												<c:if test="${not empty theValue and theValue != null}">
													<c:set var="hasData" value="true"/>
												</c:if>
											</c:forEach>
											<c:if test="${hasData=='true'}">
												<strong>
													${heading}:
												</strong>
												<c:set var="headingDisplayd" value="true"/>
											</c:if>
										</c:if>
									</c:if>
								</c:if>

								<%-- fields whose data vlaue needs links underneath --%>
						<%--
								<c:if test="${field == 'creator' or field =='subject' or field =='contributor'}">
									<c:if test="${headingDisplayd}">
										<prm:linkedFields field="${field}" result="${result}" fieldDelims="${detailsForm.fieldDelim}" displayHeading="${false}"/>
									</c:if>
									<c:if test="${!headingDisplayd}">
										<prm:linkedFields field="${field}" result="${result}" fieldDelims="${detailsForm.fieldDelim}" displayHeading="${true}"/>
										<c:set var="headingDisplayd" value="true"/>
									</c:if>
								</c:if>
						--%>

								<%-- none-linked fields --%>
								<c:forEach items="${result.values[field]}" var="pnxItem" varStatus="status">
									<c:if test="${field != 'creator' and field !='subject' and field !='contributor'}">
										<c:choose>
											<c:when test="${field =='language'}">
												<c:forTokens items="${pnxItem}" var="subitem" delims="${detailsForm.fieldDelim}" varStatus="subStatus">
													<c:if test="${subStatus.index >0}">${detailsForm.fieldDelim}</c:if>
													<c:set var="displayLang">
														<fmt:message key="lang.${fn:trim(subitem)}" />
													</c:set>
													${displayLang}
												</c:forTokens>
											</c:when>
											<c:otherwise>
												<c:set var="displayValue">${pnxItem}</c:set>
												<c:set var="facetField">"facet_"${field}</c:set>

												<c:set var="displayValue" value='${fmt:clearLangSuffix(facetField, facetValue.KEY)}' />
												<c:if test="${field == 'type'}">
													<c:set var="displayValue">
														<fmt:message key="mediatype.${pnxItem}"/>
													</c:set>
												</c:if>
												<c:if test="${field =='source' and not remote}">
													<c:set var="displayValue">
															<fmt:message key="fulldisplay.datasource.${pnxItem}" prefix="fulldisplay.datasource"/>
													</c:set>
												</c:if>
												${displayValue}
												<c:if test="${subStatus.index >0}">
													${detailsForm.fieldDelim}
												</c:if>
											</c:otherwise>
										</c:choose>
									<br/>
									</c:if>
								</c:forEach>
							</li>
						</c:if>
					</c:forEach>
				</c:if>
			</c:forEach>
          </ul>
        </div>

        <%-- only display Links section when record has links --%>
        <c:set var="hasLink" value="false"/>
        <c:forEach items="${detailsForm.displayLinks}"  var="link">
				<c:if test="${not empty link}">
					<c:set var="linkvalue" value="${detailsForm.deliveryResponses[recordBulkIndex].linksMap[link]}" />
					<c:if test="${not empty linkvalue }">
						<c:set var="hasLink" value="true"/>
					</c:if>
				</c:if>
		</c:forEach>

		<c:if test="${hasLink == 'true'}">
	        <div class="EXLDetailsLinks">
	        <em><fmt:message key='fulldisplay.links'/></em>
	          <ul>
	           	<c:set var="linksMap"  value="${detailsForm.deliveryResponses[recordBulkIndex].linksMap}"/>
	           	<c:if test="${not empty linksMap }">
					<c:forEach items="${detailsForm.displayLinks}"  var="linkType">
						<c:if test="${not empty linkType and (linkType eq c_links_gbsabout or linkType eq c_links_gbsfull or linkType eq c_links_gbsaboutnofull)}">
							<c:if test="${not empty linkType and (linkType eq c_links_gbsabout)}">
								<div style="display:none;" id="div_about">${linkType}</div>
								<li class="EXLFullDetailsOtherItem EXLFullDetailsGoogleBookItem">
										<a class="outsider EXLFullDetailsOutboundLink" style="display:none;" target="_blank" href="#" id="gbook_about">
											<fmt:message key="fulldisplay.${c_links_gbsabout}"/>
										</a>
								</li>
							</c:if>

							<c:if test="${not empty linkType and (linkType eq c_links_gbsfull)}">
								<div style="display:none;" id="div_full">${linkType}</div>
								<li class="EXLFullDetailsOtherItem EXLFullDetailsGoogleBookItem">
									<a class="outsider EXLFullDetailsOutboundLink" style="display:none;" target="_blank" href="#" id="gbook_full">
										<fmt:message key="fulldisplay.${c_links_gbsfull}"/>
									</a>
								</li>
							</c:if>

							<c:if test="${not empty linkType and (linkType eq c_links_gbsaboutnofull)}">
								<div style="display:none;" id="div_aboutfull">${linkType}</div>
								<li class="EXLFullDetailsOtherItem EXLFullDetailsGoogleBookItem">
									<a class="outsider EXLFullDetailsOutboundLink" style="display:none;" target="_blank" href="#" id="gbook_fullabout">
										<fmt:message key="fulldisplay.${c_links_gbsaboutnofull}"/>
									</a>
								</li>
							</c:if>
						</c:if>

						<c:set var="links" value="${linksMap[linkType]}" />
						<c:if test="${not empty links }">
							<c:forEach items="${links}" var="link" >
								<li>
									<span class="EXLDetailsLinksBullet"></span>
									<span class="EXLDetailsLinksTitle">
										<c:choose>
								   			<c:when test="${fn:startsWith(link.displayText, '$$E')}">
									   			<%--The PNX had missing display text use defaults based on keys --%>
									   			<c:set var="displayText">
									   				<fmt:message key="fulldisplay.${fn:substringAfter(link.displayText, '$$E')}"/>
									   			</c:set>
									   			<c:set var="bulletSplitLen" value="${fn:length(displayText)/40}"/>
									   		</c:when>
									   		<c:when test="${linkType == link.displayText}">
									   			<%--The PNX had missing display text use defaults based on keys --%>
									   			<c:set var="displayText">
									   				<fmt:message key="fulldisplay.${linkType}"/>
									   			</c:set>
									   			<c:set var="bulletSplitLen" value="${fn:length(displayText)/40}"/>
									   		</c:when>
									   		<c:otherwise>
										   		<c:set var="displayText">
									   				${link.displayText}
									   			</c:set>
									   			<c:set var="bulletSplitLen" value="${fn:length(displayText)/40}"/>
									   		</c:otherwise>
								   		</c:choose>
								   		<a href="${fn:escapeXml(link.linkUrl)}" target="popup" class="outsider EXLFullDetailsOutboundLink" onclick="openWindow(this.href, this.target, 'top=100,left=50,width=950,height=650,resizable=1,scrollbars=1');return false;">
								   			${displayText}
										</a>
										<c:if test="${bulletSplitLen>1}">
											<c:forEach begin="1" end="${bulletSplitLen}" step="1">
												<li class="EXLFullDetailsOtherSpacer">&nbsp;</li>
											</c:forEach>
											<c:set var="bulletSplitLen" value="1" />
										</c:if>
									</span>
								</li>
							</c:forEach>
						</c:if>
					</c:forEach>
				  </c:if>
		         </ul>
	        </div>
        </c:if>
	 </div>
</html:form>
</c:if>
