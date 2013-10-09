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
         * We transform this:
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
        $('>ul', exlDetailsContentToFix).changeElementType('dl').addClass('dl-horizontal');
        $('>dl>li', exlDetailsContentToFix).changeElementType('dd');
        $.each($('>dl>dd>strong:first-child', exlDetailsContentToFix), function (idx, elem) {
            $(elem).insertBefore($(elem).closest('dd')).changeElementType('dt'); // NOTE: If we want to get rid of those ":" this would be the right place to do it
        });
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
        var actionButtons = $('.EXLLocationTableActionsMenu', exlLocationTableToFix),
            headingRow = $('.EXLLocationTitlesRow', exlLocationTableToFix);

        // transform the action buttons
        $.each(actionButtons, function () {
            $('>ul>li', this).remove().children().appendTo(this).addClass('btn btn-default btn-xs col-xs-12 col-sm-6 col-md-3');
            $('>ul', this).remove();
        });
        var actionRows = actionButtons.closest('td').changeElementType('div').addClass('EXLLocationTableActions row');
        $.each(actionRows, function (index, actionRow) {
            actionRow = $(actionRow);
            actionRow.empty().append(actionButtons[index]);
            actionRow.insertAfter(actionRow.parent());
        });
        // transform the headings
        headingRow.children().last().remove();
        headingRow.children().changeElementType('div').addClass('col-md-3');
        headingRow = headingRow.changeElementType('div').addClass('row');
        headingRow.insertBefore(headingRow.parent().parent());
        // transform the locations
        var locationAndInfoRows = $('tr', exlLocationTableToFix),
            tmpAdditionalFieldsId;
        $.each(locationAndInfoRows, function (index, row) {
            if ($('td.EXLAdditionalFieldsLink', row).length) {
                // This is a header for a location
                tmpAdditionalFieldsId = Unique.getUid();
                $(row).changeElementType('div')
                    .addClass('locationHeaderRow row')
                    .children().changeElementType('div')
                    .addClass('col-md-3');
                $('div.EXLAdditionalFieldsLink>a', exlLocationTableToFix)
                    .attr('data-target', 'additionalLocationFields' + tmpAdditionalFieldsId)
                    .attr('data-toggle', 'collapse');
            } else {
                // This is a collapsible additional info for a location
                $(row).changeElementType('div')
                    .addClass('panel-collapse collapse in')
                    .attr('id', 'additionalLocationFields' + tmpAdditionalFieldsId)
                    .children().changeElementType('div');
            }
        });
        exlLocationTableToFix.children().children().insertBefore(exlLocationTableToFix);
        exlLocationTableToFix.remove();
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
