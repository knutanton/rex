/**
 * Unique - object with method getUid() that returns unique numbers
 * Used to generate unique ids to postfix element ids, when creating collapsible elements and bootstrap controlers on the fly
 */
window.Unique = (function ($, window) {
    var id = 1;
    return {
        getUid : function () {
            id += 1;
            return id;
        }
    };
}(jQuery, window));

// Adding function changeElementType to $. Changes element type. NOTE: The changing elements eventHandlers are lost in the process (childNodes handl    ers are preserved)
// Usage: $(selector).changeElementType(newType) where selector is any valid jQuery selector and newType is a HTMLElemnent typeName
// code heavily inspired of http://stackoverflow.com/questions/8584098/how-to-change-an-element-type-using-jquery
(function ($) {
    $.fn.changeElementType = function (newType) {
        var attrs = [],
            data = [];

        $.each(this, function (idx) {
            var attrList = {};
            data[idx] = $(this).data();
            $.each(this.attributes, function (idx, attr) {
                attrList[attr.nodeName] = attr.nodeValue;
            });
            attrs[idx] = attrList;
        });

        var allReplacedElements = $();
        this.replaceWith(function (idx) {
            var newElement = $("<" + newType + "/>", attrs[idx]).data(data[idx]).append($(this).contents());
            allReplacedElements = allReplacedElements.add(newElement); // Add to the list of new elements
            return newElement;
        });
        return allReplacedElements;
    };
}(jQuery));

/**
 * Flag one or more elements as fixed (have gotten whatever DOM manipulations are needed to them done)
 * @param elem {jQuery|HTMLElement|string} jQuery object, HTMLElement or Qualified jQuery selector string.
 */
function flagFixed(elem) {
    ((elem.nodeType === 3) || (typeof elem === 'string') || (elem instanceof String) ? $(elem) : elem).addClass('jsFlagDomFixed');
}

/**
 * Get all elements that are not yet flagged as fixed (see flagFixed)
 * @param selector {string} Qualified jQuery selector string. The elements that should be fixed.
 * @param cantHave {string} Optional Qualified jQuery selector string. What the selected elements can not contain (eg. don't fix if there is a loading spinner).
 * @return {jQuery} One or more matching elements that are not flagged as fixed yet.
 */
function getUnfixedElems(selector, cantHave) { // TODO: I don't think the cantHave is necessary anymore, now we are tagging the directly involved elements?
    return $(selector + ':not(.jsFlagDomFixed)' + (cantHave ? ':not(:has(\'' + cantHave + '\'))' : ''));
}

/* HAFE
 * Transforms an ul list to a dl list. Used in details tab and location tab.
 * @param divWithUl {jQuery Object} The element that contains an ul that has to be transformed.
 * @param selector {String/selector} Optional Selector for the ul to to transform. Defaults to '>ul'.
 * @return {jQuery Object} The element that is now containing a dl.
 * Transform this:
 * <ul>
 *   <li>
 *     <strong>Forfatter:</strong><a href="[...]/a>
 *   </li>
 * [...]
 * </ul>
 * into this:
 * <dl>
 *   <dt>Forfatter:<dt><dd><a href="[...]/a></dd>
 *   [...]
 * </dl>
 */
function transformUlToDl(divWithUl, selector) {
    selector = selector || '>ul';
    $(selector, divWithUl).changeElementType('dl').addClass('dl-horizontal'); // FIXME: chain with .children().
    $('>dl>li', divWithUl).changeElementType('dd');
    $.each($('>dl>dd>strong:first-child', divWithUl), function (idx, elem) {
        $(elem).insertBefore($(elem).closest('dd')).changeElementType('dt'); // NOTE: If we want to get rid of those ":" this would be the right place to do it
    });
    return divWithUl;
}

function kbBootstrapifyTabs() {
    var exlResultTabHeaderButtonsToFix = getUnfixedElems('.EXLResultTabContainer .EXLTabHeaderButtons');
    var exlResultTabContainerToFix = $(exlResultTabHeaderButtonsToFix).closest('.EXLResultTabContainer:not(\'jsFlagDomFixed\')');

    if (exlResultTabContainerToFix.length) { // Make the tab a well
        exlResultTabContainerToFix.addClass('well well-sm');
        flagFixed(exlResultTabContainerToFix);
    }

    if (exlResultTabHeaderButtonsToFix.length) { // fix header buttons - reverse order, horizontal, align right
        /* HAFE
         * Reverse order of buttons in Tab Header, and mark them up to match bootstrap classes
         * Responsive Rex:
         *  Masking on: .EXLTabHeaderButtons
         *  Adding bootstrap classes:
         *      'nav nav-pills' to .EXLTabHeaderButtons ul,
         *      'pull-right' to .EXLTabHeaderButtons .EXLTabHeaderButtonCloseTabs
         *      'pull-right' to .EXLTabHeaderButtons .EXLTabHeaderButtonPopout
         *      'dropdown pull-right' to .EXLTabHeaderButtons .EXLTabHeaderButtonSendTo
         *      'dropdown-menu' to .EXLTabHeaderButtons .EXTTabHeaderButtonSendTo ol
         * and reverting the order of the .EXLTabHeaderButtons ul li
         */
        var buttons = $('>ul', exlResultTabHeaderButtonsToFix).addClass('nav nav-pills');
        $.each(buttons, function (index, buttonset) {
            $(buttonset).append($('>li', buttonset).get().reverse());
        });
        $('.EXLTabHeaderButtonCloseTabs, .EXLTabHeaderButtonPopout, .EXLTabHeaderButtonSendTo', exlResultTabHeaderButtonsToFix).addClass('pull-right');
        $('.EXLTabHeaderButtonSendTo', exlResultTabHeaderButtonsToFix).addClass('dropdown');
        $('.EXLTabHeaderButtonSendTo ol', exlResultTabHeaderButtonsToFix).addClass('dropdown-menu');
        flagFixed(exlResultTabHeaderButtonsToFix);
    }

    var exlDetailsContentToFix = getUnfixedElems('.EXLResultTabContainer .EXLDetailsContent');
    if (exlDetailsContentToFix.length) { // transform ul to dl
        /* HAFE
         * Replace ul stuctures in detailsTab with dl
         * Responsive Rex: .EXLContainer-detailsTab .EXLDetailsContent
         */
        transformUlToDl(exlDetailsContentToFix);
        flagFixed(exlDetailsContentToFix);
    }

    var exlLocationTableToFix = getUnfixedElems('.EXLResultTabContainer .EXLLocationsTabContent .EXLLocationTable');
    if (exlLocationTableToFix.length) { // transform table to divs for responsive design
        /* HAFE
         * Replace table structure in locationTab with div/cols Bootstrap DOM
         * Responsice Rex: .EXLContainer-locationsTab .EXLSubLocation .EXLLocationTable
         * We transform this:
         * <table class="EXLLocationTable">
         *   <tbody>
         *     <tr class="EXLLocationTitlesRow">
         *       <th>Placering</th>
         *       <th>Opstilling</th>
         *       <th>Status</th>
         *       <th>Beskrivelse</th>
         *       <th>Bestillingsmuligheder</th>
         *     </tr>
         *     <tr>
         *       <td>
         *         <a href="URL">MAGASIN_LINK</a>
         *       </td>
         *       <td>OPSTILLINGSNR</td>
         *       <td>STATUS</td>
         *       <td>BESKRIVELSE</td>
         *       <td>
         *         <div class="EXLLocationTableActions">
         *           <span class="EXLLocationTableActionsLabel">Select Request Option:</span>
         *           <div class="EXLLocationTableActionsMenu">
         *             <ul>
         *               <li><a href="URL1">Bestilling</a></li>
         *               <li><a href="URL2">Fotokopibestilling</a></li>
         *               <li><a href="URL3">Prøv bibliotek.dk</a></li>
         *             </ul>
         *           </div>
         *         </div>
         *       </td>
         *     </tr>
         *     <tr class="EXLAdditionalFieldsRow EXLLocationDetails1" style="display: none;">
         *       <td class="EXLLocationTableMargin EXLHideInfo" colspan="5">
         *         <ul>
         *           <li>
         *             <strong>Afdeling: </strong> AFDELING
         *           </li>
         *           <li>
         *             <strong>Beskrivelse: </strong> BESKRIVELSE
         *           </li>
         *           [...]
         *         </ul>
         *       </td>
         *     </tr>
         *     [...]
         *     </tr>
         *   </tbody>
         * </table>
         * into this:
         * <div class="EXLLocationTable">
         *   <div class="row">
         *     <div class="cols-md-3">Placering</div>
         *     <div class="cols-md-3">Opstilling</div>
         *     <div class="cols-md-3">Status</div>
         *     <div class="cols-md-3">Beskrivelse</div>
         *   </div>
         *   <div class="row">
         *     <div class="cols-md-3"><a href="" data-toggle="collapse" data-target="EXLLocationDescription[#uid]">MAGASIN_LINK</a></div>
         *     <div class="cols-md-3">OPSTILLINGSNR</div>
         *     <div class="cols-md-3">STATUS</div>
         *     <div class="cols-md-3">BESKRIVELSE</div>
         *   </div>
         *   <div id="EXLLocationDescription[#uid]" class="panel-collapse collapse in">
         *     <div class="panel-body">
         *       <dl>
         *         <dt>Afdeling:</dt><dd>AFDELING</dd>
         *         <dt>Beskrivelse:<dt><dd>BESKRIVELSE</dd>
         *         [...]
         *       </dl>
         *     </div>
         *   </div>
         *   <div class="row">
         *     <a href="URL1" class="btn btn-default cols-xs-12 cols-sm-6 cols-md-3">Bestilling</a>
         *     <a href="URL2" class="btn btn-default cols-xs-12 cols-sm-6 cols-md-3">Fotokopibestilling</a>
         *     <a href="URL3" class="btn btn-default cols-xs-12 cols-sm-6 cols-md-3">Prøv bibliotek.dk</a>
         *   </div>
         * </div>
         */

        exlLocationTableToFix.hide();
        var rows = $('tr', exlLocationTableToFix), // FIXME: This will break badly if there is more than one exlLocationTableToFix at a time!
            row,
            headerRow = $(rows[0]),
            headerText = headerRow.children().map(function (index, elem) { return $(elem).text().trim(); }),
            headerFieldCount = headerRow.children().length - 1, // NOTE: The very last field is the action buttons, and they are appended in their own row
            colsPerColumn = Math.floor(12 / headerFieldCount), // Magic number 12 = bootstrap cols
            locations = $('<div class="locations" />'),
            tmpLocation,
            tmpButtons,
            tmpAdditionalFieldsId,
            i, j,
            clickHandler = function () {
                var targetDiv = $('#' + $(this).attr('data-target'));
                if (targetDiv.hasClass('in')) {
                    targetDiv.slideUp(400, function () {
                        $(this).removeClass('in');
                    });
                } else {
                    targetDiv.slideDown(400, function () {
                        $(this).addClass('in');
                    });
                }
            };
        headerRow.children().last().remove();
        headerRow = headerRow.changeElementType('div').addClass('row visible-md visible-lg');
        headerRow.children().changeElementType('div').addClass('col-md-' + colsPerColumn);
        locations.append(headerRow);
        // loop thru all rows and generate locationDivs on the way
        for (i = 1; i < rows.length; i += 1) { // NOTE: Starting with row 1 because row 0 is the headlines
            row = $(rows[i]);
            if (row.hasClass('EXLAdditionalFieldsRow')) {
                // this is a (hidden) additional fields line
                transformUlToDl(row.children().changeElementType('div'))
                    .attr('id', 'additionalLocationFields' + tmpAdditionalFieldsId)
                    .attr('class', row.attr('class'))
                    .addClass('collapse')
                    .appendTo(tmpLocation);
            } else {
                if ($('td.EXLAdditionalFieldsLink', row).length) {
                    // this is a location headline
                    if (tmpLocation) {
                        // push the previous location
                        if (tmpButtons) {
                            tmpLocation.append(tmpButtons);
                            tmpButtons = null;
                        }
                        locations.append(tmpLocation);
                    }
                    // start new location
                    tmpAdditionalFieldsId = Unique.getUid();
                    tmpLocation = $('<div class="locationDiv"/>');
                    var headerFields = row.children(),
                        tmpHeader = $('<div class="locationHeader row" />');
                    for (j = 0; j < headerFieldCount; j += 1) {
                        tmpHeader.append(($(headerFields[j])
                            .changeElementType('div')
                            .addClass('locationHeaderField col-md-' + colsPerColumn)
                            .prepend('<div class="locationColumnTitle visible-xs visible-sm">' + headerText[j]  + '</div>')));
                    }
                    // setup event listener to additionalFieldsLink
                    $('.EXLAdditionalFieldsLink a', tmpHeader)
                        .attr('data-target', 'additionalLocationFields' + tmpAdditionalFieldsId)
                        .attr('data-toggle', 'collapse')
                        .removeAttr('href')
                    // TODO: since the above bootstrap attempts does not work properly, we also sets eventlisteners up manually - we might wanna examine why it does not work
                        .on('click', clickHandler);
                    tmpLocation.append(tmpHeader);
                    tmpButtons = $('<div class="locationButtons" />');
                    $('.EXLLocationTableActionsMenu a', headerFields[headerFields.length - 1])
                        .addClass('btn btn-default btn-xs')
                        .appendTo(tmpButtons);
                } else {
                    // This is anything else - just wrap it in divs and append it? (the very last "show all locations" link is in here!)
                    if (tmpLocation) {
                        // push the previous location
                        if (tmpButtons) {
                            tmpLocation.append(tmpButtons);
                            tmpButtons = null;
                        }
                        locations.append(tmpLocation);
                    }
                    // append what ever there is of content cells in this row
                    locations.append(row.children().changeElementType('div'));
                }
            }
        }
        exlLocationTableToFix.replaceWith(locations);
        // NOTE: We do not need to flag the table fixed, since we have removed it!
    }
}

//NKH Start (EOD functions)
var t = 0;

function EXLTA_recordId(element) {
    return $(element).parents('.EXLResult').find('.EXLResultRecordId').attr('id');
}


function EXLTA_getPNX(recordId) {
    var r = $('#' + recordId).get(0);
    if (!r.pnx) {
        //r.pnx = $.ajax({url: 'display.do',data:{doc: recordId, "vl(freeText0)":"abcd", showPnx: true},async: false,error:function(){alert('error: '+recordId)}}).responseXML;
        r.pnx = $.ajax({
            url : 'display.do',
            data : {
                doc : recordId,
                "vl(freeText0)" : "abcd",
                showPnx : true
            },
            async : false,
            error : function () {}
        }).responseXML;
    }
    return r.pnx;
}

function EXLTA_sourceId(recordId) {
    var pnx = EXLTA_getPNX(recordId),
        s = $(pnx).find('sourcerecordid').eq(0).text(),
        sid = s.split("$$OKGL01");
    if (sid) {
        return sid[1];
    } else {
        return $(pnx).find('sourcerecordid').eq(0).text();
    }
}

function EXLTA_originalsourceId(recordId) {
    var pnx = EXLTA_getPNX(recordId),
        s = $(pnx).find('originalsourceid').eq(0).text(),
        sid = s.split("$$OKGL01");
    if (sid) {
        return sid[1];
    } else {
        return $(pnx).find('originalsourceid').eq(0).text();
    }
}

function EXLTA_creationdate(recordId) {
    var pnx = EXLTA_getPNX(recordId),
        s = $(pnx).find('creationdate').eq(0).text(),
        d = s.split("-");
    if (d) {
        return d[0];
    }
    return $(pnx).find('creationdate').eq(0).text();
}

function EXLTA_general(recordId) {
    var pnx = EXLTA_getPNX(recordId),
/*jslint regexp: false */
        re = /(.*)(wbkkbd|wbkkba|wbkub1|wbkdnl|wbhdoe|wbheod)(.*)/i,
/*jslint regexp: true */
        delbib = re.exec($(pnx).find('general').text());
    if (delbib) {
        return 1;
    } else {
        return 0;
    }
}

function EXLTA_addTab(tabName, tabType, url, tabHandler, firstTab, evaluator) {
    $('.EXLResultTabs').each(function () {
        var customTab = $('<li class="EXLResultTab ' + tabType + '"><a href="' + url + '">' + tabName + '</a></li>'),
            customTabContainer = $('<div class="EXLResultTabContainer ' + tabType + '-Container"></div>');
        if (!evaluator || (evaluator && evaluator(this))) {
            if (firstTab) {
                $(this).find('li').removeClass('EXLResultFirstTab');
                $(customTab).addClass('EXLResultFirstTab');
                $(this).prepend(customTab);
            } else {
                $(this).find('li').removeClass('EXLResultLastTab');
                $(customTab).addClass('EXLResultLastTab');
                $(this).append(customTab);
            }
            if ($("div[class=EXLSummary EXLResult]")) {
                $(this).parents('.EXLSummary').append(customTabContainer);
            } else {
                $(this).parents('.EXLResult').find('.EXLSummary').append(customTabContainer);
            }
            $('.' + tabType + ' a').click(function (e) {
                tabHandler(e, this, tabType, url, $(this).parents('.EXLResultTab').hasClass('EXLResultSelectedTab'));
            });
        }
    });
    $('.EXLSummary .' + tabType + '-Container').hide();
}

function EXLTA_wrapResultsInNativeTab(element, content, url, headerContent) {
    var popOut = '<div class="EXLTabHeaderContent">' + headerContent +
            '</div><div class="EXLTabHeaderButtons"><ul><li class="EXLTabHeaderButtonPopout"><span></span><a href="' + url +
            '" target="_blank"><img src="../images/icon_popout_tab.png" /></a></li><li></li><li class="EXLTabHeaderButtonCloseTabs">' +
            '<a href="#" title="hide tabs"><img src="../images/icon_close_tabs.png" alt="hide tabs"></a></li></ul></div>',
        header = '<div class="EXLTabHeader">' + popOut + '</div>',
        htmlcontent = '';
    if (typeof content  === 'function') {
        log('trying function');
        htmlcontent = content(element);
    } else {
        htmlcontent = content;
    }
    var body = '<div class="EXLTabContent">' + htmlcontent + '</div>';
    return header + body;
}

function EXLTA_closeTab(element) {
    if (!isFullDisplay()) {
        $(element).parents('.EXLResultTab').removeClass('EXLResultSelectedTab');
        $(element).parents('.EXLTabsRibbon').addClass('EXLTabsRibbonClosed');
        $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide();
    }
}

function EXLTA_openTab(element, tabType, content, reentrant) {
    t = 0;
    $(element).parents('.EXLTabsRibbon').removeClass('EXLTabsRibbonClosed');
    $(element).parents('.EXLResultTab').siblings().removeClass('EXLResultSelectedTab').end().addClass('EXLResultSelectedTab');
    var container = $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide().end().find('.' + tabType + '-Container').show();
    if (content && !(reentrant && $(container).attr('loaded'))) {
        $(container).html(content);
        if (reentrant) {
            $(container).attr('loaded', 'true');
        }
    }
    return container;
}

function EXLTA_createWidgetTabHandler(content, reentrant) {
    return function (e, element, tabType, url, isSelected) {
        e.preventDefault();
        if (isSelected && t) {
            EXLTA_closeTab(element);
        } else {
            EXLTA_openTab(element, tabType, EXLTA_wrapResultsInNativeTab(element, content, url, ''), reentrant);
        }
    };
}

function EXLTA_addLoadEvent(func) {
    addLoadEvent(func);
}

function EXLTA_isFullDisplay() {
    return $('.EXLFullView').size() > 0;
}
//NKH Slut (EOD functions)



/*
*JAC
* Remove unwanted content from the page:
*   - removes the exlidPleaseWaitContainer div
*   - removes the javascript that is right after the div.
*   - removes "opdater automatisk" container
*
* The code comes from the views folder
* so this is the way we decidede to fix it
*/
function removeUnWantedContent() {
    $('#exlidPleaseWaitContainer').remove();
    $('script[src*="pleaseWait.js"]').remove();
    $('.EXLFooterUpdateContainer').remove();
}

/*
// Hey Hasse lidt til dig ;)
$(document).ready(function () {
    removePleaseWait();
    $("div.EXLFooterUpdateContainer").addClass("collapse");
        // Facebook follow button see footer.jsp
        (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) { return; }
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/da_DK/all.js#xfbml=1";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

});
*/
