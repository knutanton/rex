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

        return this.replaceWith(function (idx) {
            return $("<" + newType + "/>", attrs[idx]).data(data[idx]).append($(this).contents());
        });
    };
}(jQuery));

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
* remove the exlidPleaseWaitContainer div
* plus the javascript that is right after the div.
*  
* The code comes from the views folder
* so this is the way we decidede to fix it
*/
function removePleaseWait() {
    $('#exlidPleaseWaitContainer').remove();
    $('script[src*="pleaseWait.js"]').remove();
}

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