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
    $(selector, divWithUl).changeElementType('dl')
        .addClass('dl-horizontal')
        .children().changeElementType('dd');
    $.each($('>dl>dd>strong:first-child', divWithUl), function (idx, elem) {
        $(elem).insertBefore($(elem).closest('dd')).changeElementType('dt'); // NOTE: If we want to get rid of those ":" this would be the right place to do it
    });
    return divWithUl;
}

// helper function that transforms a table of locations into a bootstrapish list of nested divs
// for more info look inside the kbBootstrapifyTabs method, where this snippet originally came from. // FIXME: move documentation up here!
function transformLocationTrToBootstrap(rows, headerText) {
    var locationArray = [],
        row,
        headerFieldCount = headerText.length,
        colsPerColumn = Math.floor(12 / headerFieldCount), // Magic number 12 = bootstrap cols
        tmpLocation,
        tmpButtons,
        tmpAdditionalFieldsId,
        i, j,
        pushTmpLocation = function () {
            if (tmpLocation) {
                if (tmpButtons) {
                    tmpLocation.append(tmpButtons);
                    tmpButtons = null;
                }
                locationArray.push(tmpLocation);
                tmpLocation = null;
            }
        },
        clickHandler = function () {
            var targetDiv = $('#' + $(this).attr('data-target'));
            if (targetDiv.hasClass('in')) {
                $('.glyphicon', this).addClass('glyphicon-chevron-right').removeClass('glyphicon-chevron-down');
                targetDiv.slideUp(400, function () {
                    $(this).removeClass('in');
                });
            } else {
                $('.glyphicon', this).addClass('glyphicon-chevron-down').removeClass('glyphicon-chevron-right');
                targetDiv.slideDown(400, function () {
                    $(this).addClass('in');
                });
            }
        };

    // loop thru all rows and generate locationDivs on the way
    for (i = 0; i < rows.length; i += 1) { // NOTE: Starting with row 1 because row 0 is the headlines
        row = $(rows[i]);
        if (row.hasClass('EXLLocationTitlesRow')) {
            continue; // NOTE: titles are supposed to come as second parameter - title rows will just be ignored in here.
        }
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
                pushTmpLocation();
                // start new location
                tmpAdditionalFieldsId = Unique.getUid();
                tmpLocation = $('<div class="locationDiv"/>');
                var headerFields = row.children(),
                    tmpHeader = $('<div class="locationHeader row" />');
                for (j = 0; j < headerFieldCount; j += 1) {
                    tmpHeader.append(($(headerFields[j])
                        .changeElementType('div')
                        .removeClass('EXLLocationLink-1_1') // NOTE: This class gets all click handlers reset by ExLibris on more rows recieved! :(
                        .addClass('locationHeaderField col-md-' + colsPerColumn)
                        .prepend('<div class="locationColumnTitle visible-xs visible-sm">' + headerText[j]  + '</div>')));
                }
                // setup event listener to additionalFieldsLink
                $('.EXLAdditionalFieldsLink a', tmpHeader)
                    .attr('data-target', 'additionalLocationFields' + tmpAdditionalFieldsId)
                    .attr('data-toggle', 'collapse')
                    .removeAttr('href')
                    // TODO: since the above bootstrap attempts does not work properly, we also sets eventlisteners up manually - we might wanna examine why it does not work
                    .on('click', clickHandler)
                    .prepend('<span class="glyphicon glyphicon-chevron-right"></span>');
                tmpLocation.append(tmpHeader);
                // Fix the action buttons - 1) move action buttons, 2) remove the ul structure they used to reside in, 3) move everything else.
                tmpButtons = $('<div class="locationButtons" />');
                var aTags = $('.EXLLocationTableActionsMenu a', headerFields[headerFields.length - 1]);
                var aTagsParentUl = aTags.closest('ul');
                aTags
                    .addClass('btn btn-default btn-xs')
                    .appendTo(tmpButtons);
                aTagsParentUl.remove(); // Remove the empty ul that used to contain the a tags
                $('.EXLLocationTableActionsMenu', headerFields[headerFields.length - 1]).children(':not(a)')
                    .appendTo(tmpButtons); // add everything that is not an a-tag too (eg. "Bestilling ikke mulig")
            } else {
                // This is anything else - just wrap it in divs and append it? (the very last "show all locations" link is in here!)
                pushTmpLocation();
                // append what ever there is of content cells in this row
                locationArray.push(row.children().changeElementType('div'));
            }
        }
    }
    pushTmpLocation(); // if there is a tmpLocation left, append it to locationArray

    return locationArray;
}

function kbBootstrapifyTabs() {
    var exlResultTabHeaderButtonsToFix = getUnfixedElems('.EXLResultTabContainer .EXLTabHeaderButtons');
    var locations;

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

    var exlLocationListToFix = getUnfixedElems('.EXLResultTabContainer .EXLLocationsTabContent .EXLLocationListContainer');
    if (exlLocationListToFix.length) { // transform Location groups into bootstrap accordion-panels
        /* HAFE
         * Transform locationList to bootstrap accordion panels
         * NOTE: We do not use the bootstrap accordion events, since we have to hook up with EXLIBRIS ajax system. The very first time an accordion is clicked,
         *       we use EXLIBRIS ajax call. On success (OBS OBS: in the end of the transformation of the recieved locationTable!!) we remove the href from the link,
         *       and we setup our own event handlers to handle the accordion collapse/expand.
         * Responsive Rex: .EXLLocationListContainer .EXLLocationList .EXLLocationsTitle .EXLLocationInfo
         * We transform this:
         * <div class="EXLLocationListContainer">
         *   <div class="EXLLocationList">
         *     <span class="EXLLocationsTitle">
         *       <a href="AJAXLINK" class="EXLLocationsIcon">
         *         <img>
         *       </a>
         *       [...]
         *     </span>
         *     <span class="EXLLocationInfo">
         *         [...]
         *     </span>
         *     <br>
         *     <div class="EXLSubLocation">
         *       [...]
         *     </div>
         *   </div>
         * </div>
         * into this:
         * <div class="EXLLocationListContainer">
         *   <div class="EXLLocationList panel panel-default">
         *     <div class="panel-heading">
         *       <h4 class="panel-title">
         *         <a href="AJAXLINK" class="EXLLocationsIcon accordion-toggle" data-target="#locationAccordionUID" data-toggle="collapse">
         *           <img>      (<--- display=none)
         *           <span class="EXLLocationsTitle">
         *             [...]
         *           </span>
         *           <span class="EXLLocationInfo">
         *             [...]
         *           </span>
         *         </a>
         *       </h4>
         *     </div>
         *     <div id="locationAccordionUID" class="panel-collapse collapse in">
         *       <div class="EXLSubLocation panel-body">
         *         [...]
         *       </div>
         *     </div>
         *   </div>
         * </div>
         */
        var locationLists = $('.EXLLocationList', exlLocationListToFix).addClass('panel panel-default');
        $.each(locationLists, function (index, locationList) {
            locationList = $(locationList);
            var tmpUid = Unique.getUid(),
                accordionHeaderElement = $('<div class="panel-heading"><h4 class="panel-title"><a class="accordion-toggle" data-toggle="collapse" href="#locationAccordion' + tmpUid + '"></a></h4></div>'),
                oldLink = $('.EXLLocationsTitle a', locationList),
                accordionIcon = $('<span class="glyphicon glyphicon-chevron-' + (oldLink.length ? 'right' : 'down') + '"/>'),
                accordionHeaderLink = $('a', accordionHeaderElement),
                accordionBodyContainer = $('<div id="locationAccordion' + tmpUid + '" class="panel-collapse collapse' + (oldLink.length ? '' : ' in') + '"></div>');
            if (oldLink.length) {
                oldLink.children().hide();
                accordionHeaderLink.replaceWith(oldLink.addClass('accordion-toggle').attr({
                    'data-toggle' : 'collapse',
                    'data-target' : 'locationAccordion' + tmpUid
                }));
                accordionHeaderLink = oldLink;
            }
            accordionIcon.prependTo(accordionHeaderLink);
            $('.EXLLocationsTitle', locationList).appendTo(accordionHeaderLink);
            $('.EXLLocationInfo', locationList).appendTo(accordionHeaderLink);
            $('br', locationList).remove();
            accordionBodyContainer.appendTo(locationList);
            accordionHeaderElement.prependTo(locationList);
            $('.EXLSublocation', locationList).addClass('panel-body').appendTo(accordionBodyContainer);
            // eventhandler for toggling the accordion icon
            accordionHeaderLink.on('click', function () {
                if (accordionBodyContainer.hasClass('in')) {
                    accordionIcon.removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-right');
                } else {
                    accordionIcon.removeClass('glyphicon-chevron-right').addClass('glyphicon-chevron-down');
                }
            }); // FIXME: Is this invoked on keyboard input? :(
        });
        flagFixed(exlLocationListToFix);
    }

    var exlLocationTableToFix = getUnfixedElems('.EXLResultTabContainer .EXLLocationsTabContent .EXLLocationTable');
    if (exlLocationTableToFix.length) { // transform table to divs for responsive design
        /* HAFE
         * Replace table structure in locationTab with div/cols Bootstrap DOM
         * Responsice Rex: .EXLContainer-locationsTab .EXLSubLocation .EXLLocationTable
         * NOTE: In the end of this function, we expands the parent accordion (that we made earlier), and kills the EXLIBRIS ajax link, and sets up our own accordion events
         *       We unfortunately had to do this to make EXLIBRIS ajax system work with our bootstrappish accordions.
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
            headerRow = $(rows[0]),
            headerText = $.makeArray(headerRow.children().map(function (index, elem) { return $(elem).text().trim(); })),
            colsPerColumn;
        locations = $('<div class="locations" />');
        headerText.pop(); // The very last column is the action buttons, and they are appended in their own row
        exlLocationTableToFix.data('headerText', headerText); // Saving the header texts for when recieving more results
        headerRow.children().last().remove();
        colsPerColumn = Math.floor(12 / headerText.length); // Magic number 12 = bootstrap cols
        headerRow = headerRow.changeElementType('div').addClass('row visible-md visible-lg');
        headerRow.children().changeElementType('div').addClass('col-md-' + colsPerColumn);
        locations.append(headerRow);

        $.each(transformLocationTrToBootstrap(rows, headerText), function (index, location) { // TODO: Duplicate code - look beneath here
            if (!location.find('.EXLLocationsButton').length) {
                locations.append(location);
            } else {
                location.find('.EXLLocationsButton').on('click', function () {
                    $(this).removeAttr('id'); // When new rows arrive, they are bundled with a new button with this id! :-/
                });
                locations.append(location);
            }
        });

        $('tbody', exlLocationTableToFix).empty();
        locations.insertBefore(exlLocationTableToFix);
        flagFixed(exlLocationTableToFix);

        // =====================================================================================================================================================
        // ================ the rest of the code here is about the parent accordion, and really belongs to the code that fixes the LocationsLists! =============
        // =====================================================================================================================================================
        // Unfortunately, due to our accordion-hack above, we do need to expand the accordion this table reside on, and swap the a href to bootstraps data-target after it has been fetched the first time. :( FIXME: This is freaking ugly, and I pitty you who have to debug this after 3 month (HAFE) :-(
        locations.closest('.panel-collapse').slideDown(400, function () {
            $(this).addClass('in');
            // FIXME: it OUGHT to be enough to change the href of the a tag to change the link, but for some strange reason my chrome browser linger on to the old link
            //$('a', this.previousElementSibling).attr('href', '#' + $(this).attr('id'));
            var accordionAnchor = $('a', this.previousElementSibling);
            if (accordionAnchor.attr('href').charAt(0) !== '#') {
                // This is an ExLibris ajax call - remove the href and install our own accordion handlers, since bootstraps does not work here.
                accordionAnchor
                    .removeAttr('href')
                    .on('click', function () {
                        var accordionBody = $('#' + $(this).attr('data-target'));
                        accordionBody.slideToggle().toggleClass('in'); // FIXME: - shitty code, but the bootstrap accordion/link change did not work out! :(
                        if (accordionBody.hasClass('in')) {
                            accordionAnchor.find('.glyphicon').removeClass('glyphicon-chevron-right').addClass('glyphicon-chevron-down');
                        } else {
                            accordionAnchor.find('.glyphicon').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-right');
                        }
                    });
            }
        });
    }

    // When a locationList is dynamically extended by user pressing "more" - create new location elements from the new rows in the dummy table, and append them to the list
    // FIXME: shall the more button also be changed, or is that already done by ExLibris?
    var additionalLocationRowsToSpliceIn = $('body.EXLFullView .EXLLocationTable.jsFlagDomFixed tr');
    if (additionalLocationRowsToSpliceIn.length) {
        var dummyTable = additionalLocationRowsToSpliceIn.closest('table'),
            newLocations = transformLocationTrToBootstrap(additionalLocationRowsToSpliceIn, dummyTable.data('headerText'));
        locations = dummyTable.prev();
        locations.children().last().remove();
        $.each(newLocations, function (index, location) { // TODO: Duplicate code - look above
            if (!location.find('.EXLLocationsButton').length) { // unless it is a location button (because we already have the button), insert it into the location list
                locations.append(location);
            } else {
                // this is a more button. Ensure that it looses it's id when pressed, so it won't steal the handler of the next button that comes with the ajax :(
                location.find('.EXLLocationsButton').on('click', function () {
                    $(this).removeAttr('id'); // when the new rows arrives, they are bundled with a new button that has the same id (doh!)
                });
                locations.append(location);
            }
        });
        $('tbody', dummyTable).empty();
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

// tilfjet nyere version af EXL Tab API - knab

function EXLTA_isFullDisplay() {
    return $('.EXLFullView').size() > 0;
}

function EXLTA_addHeadlessTab(tabType, content, evaluator) {
    $('.EXLResultTabs').each(function() {
        if(!evaluator || (evaluator && evaluator(this))) {
            var htmlcontent = '';
            if (typeof(content) === 'function') {
                log('trying function');
                htmlcontent = content(this);
            } else {
                htmlcontent = content;
            }
            var customTabContainer = $('<div class="' + tabType + '-Container">' + htmlcontent + '</div>'),
                result = $(this).parents('.EXLResult');
            if (!EXLTA_isFullDisplay()) { //Solves 'full display' bug where container isn't added to page.
                result = result.find('.EXLSummary');
            }
            result.append(customTabContainer);
        }
    });
}

function EXLTA_addTabBySelector(selector, tabName, tabType, url, tabHandler, firstTab, evaluator) {
    $(selector).each(function() {
        var customTab = $('<li class="EXLResultTab ' + tabType + '"><a href="' + url + '">' + tabName + '</a></li>'),
            customTabContainer = $('<div class="EXLResultTabContainer ' + tabType + '-Container"></div>');
        if (!evaluator || (evaluator && evaluator(this))) {
            if (firstTab) {
                $(this).find('li').removeClass('EXLResultFirstTab');
                $(customTab).addClass('EXLResultFirstTab');
                $(this).prepend(customTab);
            } else if (firstTab == undefined || firstTab == false) { // FIXME: This sounds like if (!firstTab) - and that's already given? /HAFE
                $(this).find('li').removeClass('EXLResultLastTab');
                $(customTab).addClass('EXLResultLastTab');
                $(this).append(customTab);
            } else { // FIXME: This will never happen, since firstTab will always be either truthy or falsy /HAFE
                $(this).find(firstTab).replaceWith(customTab);
            }
            if (EXLTA_isFullDisplay()) {
                $(this).parents('.EXLResult').append(customTabContainer);
            } else {
                $(this).parents('.EXLResult').find('.EXLSummaryContainer').append(customTabContainer);
            }
            $('#' + $(this).attr('id') + ' .' + tabType + ' a').click(function(e) {
                tabHandler(e, this, tabType, url, $(this).parents('.EXLResultTab').hasClass('EXLResultSelectedTab'));
            });
        }
        $(this).parents('.EXLSummary').find('.' + tabType + '-Container').hide();
    });
}

function EXLTA_addTab(tabName, tabType, url, tabHandler, firstTab, evaluator) {
    EXLTA_addTabBySelector('.EXLResultTabs', tabName, tabType, url, tabHandler, firstTab, evaluator);
}

function EXLTA_addOpenTab(tabName, tabType, url, tabHandler, firstTab, evaluator) {
    EXLTA_addTab(tabName, tabType, url, tabHandler, firstTab);
    $('.' + tabType).click();
}

function EXLTA_wrapResultsInNativeTab(element, content,url, headerContent) {
    var popOut = '<div class="EXLTabHeaderContent">' + headerContent + '</div><div class="EXLTabHeaderButtons"><ul><li class="EXLTabHeaderButtonPopout"><span></span><a href="' + url + '" target="_blank"><img src="../images/icon_popout_tab.png" /></a></li><li></li><li class="EXLTabHeaderButtonCloseTabs"><a href="#" title="hide tabs"><img src="../images/icon_close_tabs.png" alt="hide tabs"></a></li></ul></div>',
        header = '<div class="EXLTabHeader">' + popOut + '</div>',
        htmlcontent = '';
    if (typeof content === 'function') {
        log('trying function'); // FIXME: Where does this log function come from, and shouldn't it be erased in the final code? /HAFE
        htmlcontent = content(element);
    } else {
        htmlcontent = content;
    }
    var body = '<div class="EXLTabContent">' + htmlcontent + '</div>';
    return header + body;
}

function EXLTA_closeTab(element){
    if(!EXLTA_isFullDisplay()){
        $(element).parents('.EXLResultTab').removeClass('EXLResultSelectedTab');
        $(element).parents('.EXLTabsRibbon').addClass('EXLTabsRibbonClosed');
        $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide();
    }
}

function EXLTA_openTab(element,tabType, content, reentrant) {
    $(element).parents('.EXLTabsRibbon').removeClass('EXLTabsRibbonClosed');
    $(element).parents('.EXLResultTab').siblings().removeClass('EXLResultSelectedTab').end().addClass('EXLResultSelectedTab');
    var container = $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide().end().find('.' + tabType + '-Container').show();
    if (content && !(reentrant && $(container).attr('loaded'))) {
        $(container).html(content);
        if(reentrant){
            $(container).attr('loaded','true');
        }
    }
    return container;
}

function EXLTA_createWidgetTabHandler(content, reentrant) {
    return function(e, element, tabType, url, isSelected) {
        e.preventDefault();
        if (isSelected && t){
            EXLTA_closeTab(element);
        }else{
            EXLTA_openTab(element, tabType, EXLTA_wrapResultsInNativeTab(element, content, url, ''), reentrant);
        }
    };
}

function EXLTA_addLoadEvent(func) {
    addLoadEvent(func);
}

// slut ny EXL TAB API - knab
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


/**
 * When on "Min konto" we dont have
 * a bootstrap structure, so we switch back to
 * the good alo css
 */
(function removeBootsrapCss() {
    if (!(document.URL.indexOf('search.do') > -1 ||
        document.URL.indexOf('display.do') > -1 ||
        document.URL.indexOf('dlDisplay.do') > -1 ||
        document.URL.indexOf('dlSearch.do') > -1)) {


        var currCssLink = $("link[href*='primo_library_css.css']").attr("href");
        //alert(currCssLink);
        var newCssLink = currCssLink.replace("../wro/primo_library_css.css?", "/primo_library/libweb/sites/kb/dev01/css/KGL.css");
        $("link[href*='primo_library_css.css']").attr("href", newCssLink);

    }
}());
