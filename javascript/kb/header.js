/*global jQuery, $, document, setTimeout, window, kbBootstrapifyTabs */
function kbFixTabs() {
    // Tilret Bestil-fanebladet
    $(".EXLLocationTableActionsMenu>ul:not(:has(.requestForm))").each(function (index) {
        // Faa fat i en identifier paa dokumentet ved at sakse den fra et link
        var html = $(this).find('li:first').html();
        // forsoeg at matche paa doc
        //regex=/doc=([^&]*)/;
        // forsoeg at matche paa systemnummeret i ilsApiId
/*jslint regexp: false */
        regex = /ilsApiId\([^=]*=.....([^&]*)/;
/*jslint regexp: true */
        // Indsaet skaf-links, hvis ej hjemme
        if (regex.test(html)) {
            var doc = regex.exec(html)[1];
            if (!($(this).parent().parent().parent().parent().is(':contains("On Shelf"),:contains("Expected on"),:contains("Not published"),:contains("Reshelving")'))) {
                $(this).append("<li class='requestForm'><a title='If there is more than a 2 week waiting period for the item you want, try ordering it from library.dk and select The Royal Library/Copenhagen University Library Services as your pick-up location. Perhaps we can get it sooner from another library' href='http://bibliotek.dk/linkme.php?lingo=eng&ccl=lid%3D" + doc + "' target='_blank'>Try bibliotek.dk</a></li>");
            }
        }
        // Fjern links uden mening
        $(this).find("a:contains('Request not available')").replaceWith('Request not available');
    });

    // Vis thumbnails for billeder i billedbasen i online-delen
    $(".EXLViewOnlineLinksTitle>a[href*='images.kb.dk']:not(:has(img))").each(function (index) {
        var link = $(this).attr("href");
        $(this).prepend("<img alt='thumbnail' src='" + link.replace("present", "thumbnail") + "'><br/>");
    });
}


/**
* //JAC
* rewrites loginlinks to use the "global" loginlink.
* Instead of a rewrite the href, we add a clickhandler to the surrounding button.
* This makes the <a href.. a nice fallback
*/
function addLoginLink() {
    var loginUrl = $('#exlidSignOut>a').attr('href');
    $(document).on("click", ".locationButtons:contains('Sign in to request')", function () {
        window.location = loginUrl;
        return false;
    });
}

/**
* //HAFE
* Sets up a datepicker for a $ set of elements
* Needs 3rdpartyBundles/bootstrap-datepicker.da.min.js to be loaded first // TODO: The load step could be made transparent!
*/
function setUpDatepicker(elems) {
    $('.date-pick', elems).datepicker({
        format: 'dd/mm/yyyy',
        weekStart: 1,
        language: 'en',
        autoclose: true,
        todayHighlight: true
    });
}

/**
* //JAC
* Add "Show Source" (PNX) option to
* "send to: " dropdown menu
*/
function addShowSource(){
    var unfixedSendTo = getUnfixedElems('.EXLTabHeaderButtonSendTo > a');
    // Grab the url from the "open this item in new window"
    // Andappend &showPnx=true
    var showPnxUrl;
    if ($('body').hasClass('EXLFullView')) {
        showPnxUrl = location.href + '&showPnx=true';
    } else {
        showPnxUrl = unfixedSendTo.parent().prev().find('a').attr('href') + '&showPnx=true';
    }
    unfixedSendTo.next().append("<li><a target='_blank' href='"+showPnxUrl+"'>Show Source</a><li>");
    flagFixed(unfixedSendTo);
}

// Report problem tab  -knab hentet fra aub

// The evaluator for the problem tab. Only show this tab if there is an View Online tab for the record
var problemEvaluator = function(element){
    var text = $(element).parents('.EXLResult').find('.EXLViewOnlineTab').length;
    if (text == '0') {
       return false;
    } else {
       return true;
    }
};

var problemTabHandler = EXLTA_createWidgetTabHandler(function(element){return '<iframe src="http://e-tidsskrifter.kb.dk/feedback?id='+EXLTA_recordId(element)+'&system=primo&umlaut.locale=en"></iframe>';},true);

EXLTA_addLoadEvent(function(){
    EXLTA_addTab('Need help?','ProblemTab','http://e-tidsskrifter.kb.dk/feedback?&system=primo&umlaut.locale=en',problemTabHandler,false,problemEvaluator);
});

//end Report problem tab - knab

function TextReplaceObject(originalText, newText) {
    this.originalText = originalText.trim();
    this.newText = newText;
}

function replaceTextInLocationsTab(textReplaceObjects) {
    $(".EXLLocationsTab").ajaxComplete(function (event, xhr, settings) {
        var htmlResult,
            html,
            matchText;

        if ($(event.currentTarget).hasClass("EXLResultSelectedTab")) {
            htmlResult = $(event.currentTarget).parents().eq(3);
            html = htmlResult.find(".EXLSublocation");
            matchText = html.find(".EXLLocationTableColumn2").text().trim();
            $.each(textReplaceObjects, function (index, textReplaceObject) {
                if (matchText.indexOf(textReplaceObject.originalText) > -1) {
                    html.find('.EXLLocationTableColumn2:contains(' + textReplaceObject.originalText + ')')
                        .closest('.locationDiv')
                        .find('.locationButtons')
                        .html(textReplaceObject.newText);
                    return;
                }
            });
        }
    });
}

function startsWith(s, a) {
    var x;
    for (x in a) {
        if (s.indexOf(a[x]) === 0) {
            return true;
        }
    }
    return false;
}

/* function changeRequestOptions() {
$(".EXLLocationsTab").ajaxComplete(function(event, xhr, settings) {
    var htmlResult,
        html,
        link,
        linkMatch = "USE DIGITAL VERSION",
        newLink = '<a href="http://www.kb.dk/en/nb/samling/js/DODbestilling.html" target="_blank">By special request</a>';
   if($(event.target).hasClass("EXLResultSelectedTab")) {
        htmlResult = $(event.target).parents().eq(3),
        html = htmlResult.find(".EXLSublocation"),
        link = html.find(".EXLShowInfo");
         
        if(link.is(":contains("+ linkMatch +")")) {
            html.find(".EXLLocationTableActionsMenu").html(newLink);            
        } 
    }
});
}*/



 /*  JAC
 *  grabs URL parameters
 *  source: http://www.netlobo.com/url_query_string_javascript.html
 */
function gup(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results === null) {
        return "";
    }
    return results[1];
}

function gup(name, url) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(url);
    if (results === null) {
        return "";
    }
    return results[1];
}

$(document).ready(function () {

    addLoginLink();

    // Remove unwanted content (Function defined in header_global.js)
    removeUnWantedContent();

    // Closing all closed result tab containers (they expand upon tab header clicks)
    //$('.EXLResultTabContainerClosed').addClass('collapse');

    /*changeRequestOptions();*/
    var dod = new TextReplaceObject("USE DIGITAL VERSION", '<a href="http://www.kb.dk/en/nb/samling/dod/DODbestilling.html" target="_blank">By special request</a>'),
        kob = new TextReplaceObject("Mail to kob", '<a href="http://www.kb.dk/en/nb/samling/ks/kobbestilling.html" target="_blank">Mail to kob</a>'),
        mailToDfs = new TextReplaceObject("DFS In-house", '<a href="mailto:dfs-mail@kb.dk">Mail to dfs-mail@kb.dk</a>'),
        textReplaceObjectArray = [dod, kob, mailToDfs];

        replaceTextInLocationsTab(textReplaceObjectArray);

//        fixImageTitleUri();
    var lang = $("#exlidSelectedLanguage").html().substring(0, 2),
        signoutText = $("#exlidSignOut").find("a").html();
    if (startsWith(signoutText, Array('Log ud', 'Sign out'))) {
        // things to do when the user is logged ind
        // change edit link
        $("div.EXLMyAccountEditLink").html('<span><a href="https://user.kb.dk/user/edit" target="_blank">Edit</a></span>');
        $("#exlidMyAccountMainContainer1").filter(":contains('Fine Date')").append('<div id="KBPay"><iframe id=KBPayFrame" width="100%" src="https://aleph-00.kb.dk/F/?func=file&file_name=bor-info-primo"></div>');
    } else {
        // things to do when the user is NOT logged in
        // remove edit link
        $("div.EXLMyAccountEditLink").hide();
        $("li.EXLMyAccountTab").filter(":contains('My Account')").hide();

        //$("#exlidMyAccount").hide();
        $("#exlidMyAccount>a").attr("href", "login.do?loginFn=signin&targetURL=myAccountMenu.do%3fvid%3dKGL");
    }
    $(".EXLMyAccountTable>tbody>tr>td:eq(6)").hide();
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Fad to be Sent')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Reorder from Netpunkt/Subito')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Exceeded date of interest')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Not yet published')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Not for loan')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Not willing to pay')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Acquisition (PRO)')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Double order')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('Not for loan from Institute')").html("Cancelled");
//    $(".EXLMyAccountTable>tbody>tr>td:contains('All copies are lent out')").html("Cancelled");

// csv: Adding pickup numbers
    $(".EXLMyAccountTable>tbody>tr>td:contains('On hold until')").each(function () {
/*jslint regexp: false */
        var link = $(this).parent().find('a').attr('href'),
            hold = link.replace(/^.*?KGL50([0-9]+).*$/, "$1");
/*jslint regexp: true */
        // create a wrapper div for the pickup number
        $(this).parent().find('td:nth-child(6)').append('<span id="hold' + hold + '"></span>');
        // and fill it out, asynchronously - must be from the same host as primo is accessed on, so on primo-97 this is just a mockup currently
        $('#hold' + hold).load('/cgi-bin/get_pickup_number_text?z37_rec_key=' + hold);
    });

    //NKH Start (ADD EOD tabs)

    //var eodTabHandler = EXLTA_createWidgetTabHandler(function(element){return '<iframe src="http://books2ebooks.eu/odm/orderformular.do?formular_id=21&sys_id='+EXLTA_sourceId(EXLTA_recordId(element))+'&local_base='+EXLTA_originalsourceId(EXLTA_recordId(element))+' target=\" _blank\" title=\"DoD\"><img src=\"https://rex.kb.dk/exlibris/aleph/a16_1/alephe/www_f_dan/icon/eodlogo.gif\" width=\"201\" height=\"50\" border=\"0\" title=\"DoD\" alt=\"DoD\""></iframe>';},true);

    var eodTabHandler = EXLTA_createWidgetTabHandler(function (element) {
            return '<iframe src="http://books2ebooks.eu/odm/orderformular.do?formular_id=101&sys_id=' + EXLTA_sourceId(EXLTA_recordId(element)) + '&local_base=KGL01 target=_blank title=DoD"></iframe>';
        }, true),
        // create an evaluator checks if the record has an EOD
        eodEvaluator = function (element) {  
            var general = EXLTA_general(EXLTA_recordId(element)),
                date = EXLTA_creationdate(EXLTA_recordId(element));
            if ((date <= 1900) && (general)) {
                return true;
            }
            return false;
        };

//		EXLTA_addLoadEvent(function(){
//          EXLTA_addTab('EOD/eBooks','EODTab','eBooks',eodTabHandler,false,eodEvaluator);
//	    });
    //NKH Slut (ADD EOD Tabs)

    // JAC: Tilføj SKAF hvis der ikke er locationstab, og der ikke står "Adgang: Alle har adgang"
    $(".EXLResultTabs:not(:has(.EXLLocationsTab))").each(function (index) {
            var doc = gup('doc', $(this).find(".EXLDetailsTab > a").attr('href') ); //Henter docid
            var resultHtmlElement = $(this).parents().eq(3); //
            if (!($(resultHtmlElement).find('.EXLResultFourthLine').is(':contains("Adgang: Alle har adgang")'))) {
                   $(this).append("<li class='requestForm EXLResultTab'><a title='Order items not otherwise available' href='http://rex.kb.dk/userServices/menu/Order?primoId=" + doc + "' target='_blank'>Order</a></li>");
            }

    });

    // Vis thumbnails for billeder i billedbasen
    $(".EXLDetailsLinksTitle>a[href*='images.kb.dk']").each(function (index) {
        var link = $(this).attr("href");
        $(this).prepend("<img alt='thumbnail' src='" + link.replace("present", "thumbnail") + "'><br/>");
    });

    // Tilret tabs - relevant ved fuld visning
    kbFixTabs();
    kbBootstrapifyTabs();

    // HAFE start language specific faq and cookie policy
    // Change links in header for "faq" and "cookie policy" to the english version of those documents
    (function ($) {
        'use strict';
        var cookieLink = $('.EXLMainMenuITEMcookie-_and_privacypolicy', '#exlidMainMenuContainer'),
            faqLink = $('a[class^=EXLMainMenuITEMhelp]', '#exlidMainMenuContainer'); // FIXME: help or hjælp?

            //JAC: TODO: removed this, since it breaks placement os my eressource link
        //cookieLink.attr('href', cookieLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
        //faqLink.attr('href', faqLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
    }(jQuery));
    // HAFE stop language specific faq and cookie policy

    });

function bestil() {
    $("div.EXLRequestTabContent").each(function (index) {
        var submit = $(this).find("#exlidRequestTabFormSubmit").parents().html();
        $(this).find("tbody:not(:has(.KBExtraSubmit))").prepend('<tr class="KBExtraSubmit"><td>&nbsp;</td><th>&nbsp;</th><td>' + submit + '</td></tr>');
    });
}

// Tilretninger af indholdet af faneblade - dynamisk
$(document).ajaxComplete(function () {
    kbFixTabs();
    kbBootstrapifyTabs();
    bestil();
    addShowSource();
});

$('.EXLLocationsIcon').live('click', function () {
    kbFixTabs();
    setTimeout(function () {
        kbFixTabs();
    }, 2000);
});

/*
SD sag 1012745. Når URL'ens link starter med
images.kb.dk, skal titlen ikke være klikbar.
Det er fordi det ofte er kuvertposter der indeholder
flere billeder.
Titelurlen , fører kun til den ene af billederne.
*/
function fixImageTitleUri() {
    $("h2 > a[href*='images.kb.dk']").each(function () {
        var tmp = $(this).html();
        $(this).parent().html(tmp);
    });
}


// 20112411, jac: autosubmit af forms når man opdatere 'selects'  
$('#holdingsForm > select').live("change", function () {  
    $(this).closest('form').submit();   
});



