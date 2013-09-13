/*global jQuery, $ */
function kBFixTabs() {
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

    /*
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
    $('.EXLDetailsContent>ul', '.EXLContainer-detailsTab:visible').changeElementType('dl');
    $('.EXLDetailsContent>dl', '.EXLContainer-detailsTab:visible').addClass('dl-horizontal'); // would have loved to put this in the end of the line above, but it seems that jQuery misses out on the elementType change?
    $('.EXLDetailsContent>dl>li', '.EXLContainer-detailsTab:visible').changeElementType('dd');
    $.each($('.EXLDetailsContent>dl>dd>strong:first-child', '.EXLContainer-detailsTab:visible'), function (idx, elem) {
        $(elem).insertBefore($(elem).closest('dd')).changeElementType('dt');
    });
}

function hideLocationInfo() {
    //DGJ
    $("span.EXLLocationInfo>strong").hide();
    $("span.EXLLocationInfo>cite").hide();
}

function addLoginLink() {
    //DGJ
    var url = $('#exlidSignOut>a').attr('href');
    $(".EXLLocationTableActions:contains('Sign in to request')")
        .html('<a href="' + url + '">Sign in to request</a>');
}

function addLoginLinkFilter() {
    //DGJ --> udvidet til sub-library filtering KNAB
    var url = $('#exlidSignOut>a').attr('href');
    $(".EXLLocationTableActionsFirstItem:contains('Sign in to request')")
        .html('<a href="' + url + '">Sign in to request</a>');
}

function TextReplaceObject(originalText, newText) {
    this.originalText = originalText.toLowerCase().trim();
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
            matchText = html.find(".EXLLocationTableColumn2").text().trim().toLowerCase();
            $.each(textReplaceObjects, function (index, textReplaceObject) {
                if (matchText.indexOf(textReplaceObject.originalText) > -1) {
                    html.find(".EXLLocationTableActionsMenu ul li:contains(not)").html(textReplaceObject.newText);
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

$(document).ready(function () {
    /*changeRequestOptions();*/
    var dod = new TextReplaceObject("Use Digital Version", '<a href="http://www.kb.dk/en/nb/samling/dod/DODbestilling.html" target="_blank">By special request</a>'),
        kob = new TextReplaceObject("Mail to kob", '<a href="http://www.kb.dk/en/nb/samling/ks/kobbestilling.html" target="_blank">Mail to kob</a>'),
        mailToDfs = new TextReplaceObject("DFS In-house", '<a href="mailto:dfs-mail@kb.dk">Mail to dfs-mail@kb.dk</a>'),
        // mailToKob = new TextReplaceObject("Mail to kob", '<a href="mailto:kob@kb.dk">Mail to kob@kb.dk</a>'),
        textReplaceObjectArray = [dod, kob, mailToDfs];

        replaceTextInLocationsTab(textReplaceObjectArray);

//        fixImageTitleUri();
    var lang = $("#exlidSelectedLanguage").html().substring(0, 2),
        signoutText = $("#exlidSignOut").find("a").html();
    if (startsWith(signoutText, Array('Log ud', 'Sign out'))) {
        // things to do when the user is logged ind
        // change edit link
        $("div.EXLMyAccountEditLink").html('<span><a href="https://login.kb.dk/kbuser/useredit?pref_lang=en" target="_new">Edit</a></span>');
        $("#exlidMyAccountMainContainer1").filter(":contains('List of Fines')").append('<div id="KBPay"><iframe id=KBPayFrame" width="100%" src="https://rex.kb.dk/F/?func=file&con_lng=eng&file_name=bor-info-primo"></div>');
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

    // Tilret faneblade - indsaet skaf-links, hvis ingen bestillings-tab
    $(".EXLResultTabs:not(:has(.EXLLocationsTab))").each(function (index) {
/*jslint regexp: false */
        var html = $(this).find('li:first').html(),
            regex = /doc=([^&]*)/;
/*jslint regexp: true */
        if (regex.test(html)) {
            var doc = regex.exec(html)[1];
            $(this).append("<li class='requestForm EXLResultTab'><a title='Order items not otherwise available' href='http://rex.kb.dk/userServices/menu/Order?primoId=" + doc + "' target='_blank'>Order</a></li>");
        }
    });

    // Vis thumbnails for billeder i billedbasen
    $(".EXLDetailsLinksTitle>a[href*='images.kb.dk']").each(function (index) {
        var link = $(this).attr("href");
        $(this).prepend("<img alt='thumbnail' src='" + link.replace("present", "thumbnail") + "'><br/>");
    });

    // Tilret tabs - relevant ved fuld visning
    kBFixTabs();

    // HAFE start language specific faq and cookie policy
    // Change links in header for "faq" and "cookie policy" to the english version of those documents
    (function ($) {
        'use strict';
        var cookieLink = $('.EXLMainMenuITEMcookie-_and_privacypolicy', '#exlidMainMenuContainer'),
            faqLink = $('a[class^=EXLMainMenuITEMhelp]', '#exlidMainMenuContainer'); // FIXME: help or hjælp?
        cookieLink.attr('href', cookieLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
        faqLink.attr('href', faqLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
    }(jQuery));
    // HAFE stop language specific faq and cookie policy

    // copied from footer.html start /HAFE
    // my e-ressources
    var linkString = "My e-resources (BETA)",
        myResourceString = "<li><a href='#' class='my_e_resources' id='e_resources_click'>" + linkString + "</a></li>";
    $('#exlidUserAreaRibbon').append(myResourceString);
    $('#popupContact > h1').html(linkString);

    // copied from footer.html stop /HAFE
});

function bestil() {
    $("div.EXLRequestTabContent").each(function (index) {
        var submit = $(this).find("#exlidRequestTabFormSubmit").parents().html();
        $(this).find("tbody:not(:has(.KBExtraSubmit))").prepend('<tr class="KBExtraSubmit"><td>&nbsp;</td><th>&nbsp;</th><td>' + submit + '</td></tr>');
    });
}

function emne() {
    $("div.EXLDetailsContent>ul>li:contains('Emnekoder'):not(:has(.KBsubLink))").each(function (index) {
    var emnekoder = $(this).html();
        if (emnekoder !== null) {
            var x = emnekoder.split(/<\/strong>|<\/STRONG>/);
            emnekoder = x[1];
            if (emnekoder !== null) {
                var html = '<strong>Subjects:</strong>',
                    br = emnekoder.split(/<br>|<BR>/),
                    b;
                for(b in br) {
                    if (br.hasOwnProperty(b)) {
                        var ord = br[b].split(';'),
                            o;
                        for(o in ord) {
                            if (ord.hasOwnPropery(o)) {
                                var word = ord[o].replace(/^\s\s*/, '').replace(/\s\s*$/, '');
                                if (word !== '') {
                                    html = html + '<a class="KBsubLink" href="search.do?dscnt=0&vl%281UI0%29=contains&scp.scps=scope%3A%28KGL%29&frbg=&tab=default_tab&vl%2892005084UI0%29=sub&srt=rank&vl%2892005085UI1%29=all_items&ct=search&mode=Basic&dum=true&tb=t&indx=1&fn=search&vid=KGL&indx=1&vl%28freeText0%29=' + word + '">' + word + '</a>; ';
                                }
                            }
                        }
                        html = html + '<br>';
                    }
                }
                $(this).html(html);
            }
        }
    });
}

// Tilretninger af indholdet af faneblade - dynamisk
$(document).ajaxComplete(function () {
    kBFixTabs();
    hideLocationInfo();
    addLoginLink();
    bestil();
    emne();
});

$('.EXLLocationsIcon').live('click', function () {
    kBFixTabs();
    setTimeout('kBFixTabs();addLoginLinkFilter();', 2000);
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

