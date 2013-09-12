// Adding function changeElementType to $. Changes element type. NOTE: The changing elements eventHandlers are lost in the process (childNodes handl    ers are preserved)
// Usage: $(selector).changeElementType(newType) where selector is any valid jQuery selector and newType is a HTMLElemnent typeName
// code heavily inspired of http://stackoverflow.com/questions/8584098/how-to-change-an-element-type-using-jquery
(function($) {
    $.fn.changeElementType = function(newType) {
        var attrs = [],
            data = [];

        $.each(this, function (idx) {
            var attrList = {};
            data[idx] = $(this).data();
            $.each(this.attributes, function(idx, attr) {
                attrList[attr.nodeName] = attr.nodeValue;
            });
            attrs[idx] = attrList;
        });

        return returnValue = this.replaceWith(function(idx) {
            return $("<" + newType + "/>", attrs[idx]).data(data[idx]).append($(this).contents());
        });
    };
})(jQuery);

function KBFixTabs() {
  // Tilret Bestil-fanebladet
  $(".EXLLocationTableActionsMenu>ul:not(:has(.requestForm))").each(function (index) {
    // Faa fat i en identifier paa dokumentet ved at sakse den fra et link
    var html=$(this).find('li:first').html();
    // forsoeg at matche paa doc
    //regex=/doc=([^&]*)/;
    // forsoeg at matche paa systemnummeret i ilsApiId
    regex=/ilsApiId\([^=]*=.....([^&]*)/;
    // Indsaet skaf-links, hvis ej hjemme
    if (regex.test(html)) {
      var doc=regex.exec(html)[1];
      if (!($(this).parent().parent().parent().parent().is(':contains("On Shelf"),:contains("Expected on"),:contains("Not published"),:contains("Reshelving")'))) {
        $(this).append("<li class='requestForm'><a title='If there is more than a 2 week waiting period for the item you want, try ordering it from library.dk and select The Royal Library/Copenhagen University Library Services as your pick-up location. Perhaps we can get it sooner from another library' href='http://bibliotek.dk/linkme.php?lingo=eng&ccl=lid%3D" + doc + "' target='_blank'>Try bibliotek.dk</a></li>");
      }
    }
    // Fjern links uden mening
    $(this).find("a:contains('Request not available')").replaceWith('Request not available');
  });
  // Vis thumbnails for billeder i billedbasen i online-delen
  $(".EXLViewOnlineLinksTitle>a[href*='images.kb.dk']:not(:has(img))").each(function (index) {
    var link=$(this).attr("href");
    $(this).prepend("<img alt='thumbnail' src='" + link.replace("present","thumbnail") + "'><br/>");
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
  $('.EXLDetailsContent>dl', '.EXLContainer-detailsTab:visible').addClass('dl-horizontal'); // would have loved to put this in the end of the line a    bove, but it seems that jQuery misses out on the elementType change?
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
                .html('<a href="'+url+'">Sign in to request</a>');
}

function addLoginLinkFilter() {
        //DGJ --> udvidet til sub-library filtering KNAB
        var url = $('#exlidSignOut>a').attr('href');
        $(".EXLLocationTableActionsFirstItem:contains('Sign in to request')")
                .html('<a href="'+url+'">Sign in to request</a>');
}

//NKH Start (EOD functions)

var t = 0;

function EXLTA_recordId(element){
        return $(element).parents('.EXLResult').find('.EXLResultRecordId').attr('id');
}


function EXLTA_getPNX(recordId){
        var r = $('#'+recordId).get(0);
        if (!r.pnx){
          //r.pnx = $.ajax({url: 'display.do',data:{doc: recordId, "vl(freeText0)":"abcd", showPnx: true},async: false,error:function(){alert('error: '+recordId)}}).responseXML;
          r.pnx = $.ajax({url: 'display.do',data:{doc: recordId, "vl(freeText0)":"abcd", showPnx: true},async: false,error:function(){}}).responseXML;
        }
        return r.pnx;
}

function EXLTA_sourceId(recordId){
        var pnx = EXLTA_getPNX(recordId);
        var s = $(pnx).find('sourcerecordid').eq(0).text();
        var sid = s.split("$$OKGL01"); 
        if (sid) {
           return sid[1];
        }
        else {
          return $(pnx).find('sourcerecordid').eq(0).text();
        }
}

function EXLTA_originalsourceId(recordId){
        var pnx = EXLTA_getPNX(recordId);
        var s = $(pnx).find('originalsourceid').eq(0).text();
        var sid = s.split("$$O");
        if (sid) {
           return sid[1];
        }
        else {
          return $(pnx).find('originalsourceid').eq(0).text();
        }
}

function EXLTA_creationdate(recordId){
        var pnx = EXLTA_getPNX(recordId);
        var s = $(pnx).find('creationdate').eq(0).text();
        var d = s.split("-");
        if (d) {
           return d[0];
        }
        return $(pnx).find('creationdate').eq(0).text();
}

function EXLTA_general(recordId){
        var pnx = EXLTA_getPNX(recordId);
        var re = /(.*)(wbkkbd|wbkkba|wbkub1|wbkdnl|wbhdoe|wbheod)(.*)/i;
        var delbib = re.exec($(pnx).find('general').text());
        if (delbib) {
            return 1;
        }
        else {
          return 0;
        }
}

function EXLTA_addTab(tabName,tabType,url,tabHandler,firstTab,evaluator){
                $('.EXLResultTabs').each(function(){
                        var customTab = $('<li class="EXLResultTab '+tabType+'"><a href="'+url+'">'+tabName+'</a></li>');
                        var customTabContainer = $('<div class="EXLResultTabContainer '+tabType+'-Container"></div>');
                        if(!evaluator || (evaluator && evaluator(this))){
                if (firstTab){
                                                $(this).find('li').removeClass('EXLResultFirstTab');
                                                $(customTab).addClass('EXLResultFirstTab');
                                                $(this).prepend(customTab);
                                }else{
                                                $(this).find('li').removeClass('EXLResultLastTab');
                                                $(customTab).addClass('EXLResultLastTab');
                                                $(this).append(customTab);
                }
                if ($("div[class=EXLSummary EXLResult]")){
                  $(this).parents('.EXLSummary').append(customTabContainer);
                } 
                else {
                  $(this).parents('.EXLResult').find('.EXLSummary').append(customTabContainer);
                }
                $('.'+ tabType + ' a').click(function(e){
                                tabHandler(e, this, tabType, url, $(this).parents('.EXLResultTab').hasClass('EXLResultSelectedTab'));
                });
                        }
                });
        $('.EXLSummary .'+tabType+'-Container').hide();
}



/*
function EXLTA_iframeTabHandler(e,element,tabType,url,isSelected){
                e.preventDefault();
                if (isSelected){
                        EXLTA_closeTab(element);
                }else{
                        EXLTA_openTab(element,tabType, EXLTA_wrapResultsInNativeTab(element,'<iframe src="'+url+'"></iframe>',url,''),true);
                }
}
*/


function EXLTA_createWidgetTabHandler(content,reentrant){
        return function(e,element,tabType,url,isSelected){
                e.preventDefault();
                
                if (isSelected && t){
                        EXLTA_closeTab(element);
                }else{
                        EXLTA_openTab(element,tabType, EXLTA_wrapResultsInNativeTab(element,content,url,''),reentrant);
                }
        };
        t = 1;
}

function EXLTA_addLoadEvent(func){
        addLoadEvent(func);
}

function EXLTA_isFullDisplay(){  
	return $('.EXLFullView').size() > 0;
}

function EXLTA_wrapResultsInNativeTab(element, content,url, headerContent){ 
        var popOut = '<div class="EXLTabHeaderContent">'+headerContent+'</div><div class="EXLTabHeaderButtons"><ul><li class="EXLTabHeaderButtonPopout"><span></span><a href="'+url+'" target="_blank"><img src="../images/icon_popout_tab.png" /></a></li><li></li><li class="EXLTabHeaderButtonCloseTabs"><a href="#" title="hide tabs"><img src="../images/icon_close_tabs.png" alt="hide tabs"></a></li></ul></div>';
        var header = '<div class="EXLTabHeader">'+ popOut +'</div>';
        var htmlcontent = '';
        if (typeof(content)=='function'){
                log('trying function');
                htmlcontent = content(element);
        }else{
                htmlcontent = content;
        }
        var body = '<div class="EXLTabContent">'+htmlcontent+'</div>';
        return header + body;
}

function EXLTA_closeTab(element){
        if(!isFullDisplay()){
                $(element).parents('.EXLResultTab').removeClass('EXLResultSelectedTab');
                $(element).parents('.EXLTabsRibbon').addClass('EXLTabsRibbonClosed');
                $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide();
        }
}

function EXLTA_openTab(element,tabType, content, reentrant){
        t = 0;
        $(element).parents('.EXLTabsRibbon').removeClass('EXLTabsRibbonClosed');
        $(element).parents('.EXLResultTab').siblings().removeClass('EXLResultSelectedTab').end().addClass('EXLResultSelectedTab');
        var container = $(element).parents('.EXLResult').find('.EXLResultTabContainer').hide().end().find('.'+tabType+'-Container').show();
        if (content && !(reentrant && $(container).attr('loaded'))){
                $(container).html(content);
                if(reentrant){
                        $(container).attr('loaded','true');
                }
        }
        return container;
}
//NKH Slut (EOD functions)


function TextReplaceObject(originalText, newText) {
    this.originalText = originalText.toLowerCase().trim();
    this.newText = newText;
}

function replaceTextInLocationsTab(textReplaceObjects) {
    $(".EXLLocationsTab").ajaxComplete(function(event, xhr, settings) {
        var htmlResult,
                html,
                link;

        if($(event.currentTarget).hasClass("EXLResultSelectedTab")) {
            htmlResult = $(event.currentTarget).parents().eq(3),
                    html = htmlResult.find(".EXLSublocation"),
                    matchText = html.find(".EXLLocationTableColumn2").text().trim().toLowerCase();

            $.each(textReplaceObjects, function(index, textReplaceObject) {
                if(matchText.indexOf(textReplaceObject.originalText) > -1) {
                    html.find(".EXLLocationTableActionsMenu ul li:contains(not)").html(textReplaceObject.newText);
                    return;
                }
            });
        }
    });
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

$(document).ready(function() {

	/*changeRequestOptions();*/

 var dod = new TextReplaceObject("Use Digital Version", '<a href="http://www.kb.dk/en/nb/samling/dod/DODbestilling.html" target="_blank">By special request</a>'),
     kob = new TextReplaceObject("Mail to kob", '<a href="http://www.kb.dk/en/nb/samling/ks/kobbestilling.html" target="_blank">Mail to kob</a>'),
        mailToDfs = new TextReplaceObject("DFS In-house", '<a href="mailto:dfs-mail@kb.dk">Mail to dfs-mail@kb.dk</a>') ,
        // mailToKob = new TextReplaceObject("Mail to kob", '<a href="mailto:kob@kb.dk">Mail to kob@kb.dk</a>'),
        textReplaceObjectArray = [dod, kob, mailToDfs];

        replaceTextInLocationsTab(textReplaceObjectArray);


//                fixImageTitleUri();
                var lang = $("#exlidSelectedLanguage").html().substring(0,2);

                var signoutText = $("#exlidSignOut").find("a").html();
                if (startsWith(signoutText,Array('Log ud','Sign out'))) {
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
                        $("#exlidMyAccount>a").attr("href","login.do?loginFn=signin&targetURL=myAccountMenu.do%3fvid%3dKGL");

                }
 $(".EXLMyAccountTable>tbody>tr>td:eq(6)").hide();
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Fad to be Sent')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Reorder from Netpunkt/Subito')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Exceeded date of interest')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Not yet published')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Not for loan')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Not willing to pay')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Acquisition (PRO)')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Double order')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Not for loan from Institute')").html("Cancelled");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('All copies are lent out')").html("Cancelled");


// csv: Adding pickup numbers
$(".EXLMyAccountTable>tbody>tr>td:contains('On hold until')").each( function() {
var link=$(this).parent().find('a').attr('href');
var hold=link.replace(/^.*?KGL50([0-9]+).*$/,"$1");
// create a wrapper div for the pickup number
$(this).parent().find('td:nth-child(6)').append('<span id="hold' + hold + '"></span>');
// and fill it out, asynchronously - must be from the same host as primo is accessed on, so on primo-97 this is just a mockup currently
$('#hold' + hold).load('/cgi-bin/get_pickup_number_text?z37_rec_key=' + hold);
});


		//NKH Start (ADD EOD tabs)

		//var eodTabHandler = EXLTA_createWidgetTabHandler(function(element){return '<iframe src="http://books2ebooks.eu/odm/orderformular.do?formular_id=21&sys_id='+EXLTA_sourceId(EXLTA_recordId(element))+'&local_base='+EXLTA_originalsourceId(EXLTA_recordId(element))+' target=\" _blank\" title=\"DoD\"><img src=\"https://rex.kb.dk/exlibris/aleph/a16_1/alephe/www_f_dan/icon/eodlogo.gif\" width=\"201\" height=\"50\" border=\"0\" title=\"DoD\" alt=\"DoD\""></iframe>';},true);

		var eodTabHandler = EXLTA_createWidgetTabHandler(function(element){return '<iframe src="http://books2ebooks.eu/odm/orderformular.do?formular_id=101&sys_id='+EXLTA_sourceId(EXLTA_recordId(element))+'&local_base=KGL01 target=_blank title=DoD"></iframe>';},true);

		// create an evaluator checks if the record has an EOD
		var eodEvaluator = function(element){  
                	var general = EXLTA_general(EXLTA_recordId(element));
                	var date = EXLTA_creationdate(EXLTA_recordId(element));
                	if ((date <= 1900) && (general)){
                        	return true;
                	}
                	return false;
		};

//		EXLTA_addLoadEvent(function(){
//      			EXLTA_addTab('EOD/eBooks','EODTab','eBooks',eodTabHandler,false,eodEvaluator);
//		});
		//NKH Slut (ADD EOD Tabs)


  		// Tilret faneblade - indsaet skaf-links, hvis ingen bestillings-tab
  $(".EXLResultTabs:not(:has(.EXLLocationsTab))").each(function (index) {
    var html=$(this).find('li:first').html();
    var regex=/doc=([^&]*)/;
    if (regex.test(html)) {
      var doc=regex.exec(html)[1];
      $(this).append("<li class='requestForm EXLResultTab'><a title='Order items not otherwise available' href='http://rex.kb.dk/userServices/menu/Order?primoId=" + doc + "' target='_blank'>Order</a></li>");
    }
  });

  // Vis thumbnails for billeder i billedbasen
  $(".EXLDetailsLinksTitle>a[href*='images.kb.dk']").each(function (index) {
    var link=$(this).attr("href");
    $(this).prepend("<img alt='thumbnail' src='" + link.replace("present","thumbnail") + "'><br/>");
  });

  // Tilret tabs - relevant ved fuld visning
  KBFixTabs();

  // HAFE start language specific faq and cookie policy
  // Change links in header for "faq" and "cookie policy" to the english version of those documents
    (function ($) {
        'use strict';
        var cookieLink = $('.EXLMainMenuITEMcookie-_and_privacypolicy', '#exlidMainMenuContainer'),
            faqLink = $('a[class^=EXLMainMenuITEMhelp]', '#exlidMainMenuContainer'); // ought to be $('.EXLMainMenuITEMhjælp/faq', '#exlidMainMenuContainer'); but dat char in a class name! :(
        cookieLink.attr('href', cookieLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
        faqLink.attr('href', faqLink.attr('href').replace(/www\.kb\.dk\/da\//, 'www.kb.dk/en/'));
    })(jQuery)
  // HAFE stop language specific faq and cookie policy

})

function startsWith(s,a) {
        for (x in a) {
                if (s.indexOf(a[x]) === 0) {
                        return true;
                }
        }
        return false;
}

function bestil() {
        $("div.EXLRequestTabContent").each(function(index){
                var submit = $(this).find("#exlidRequestTabFormSubmit").parents().html();
                $(this).find("tbody:not(:has(.KBExtraSubmit))").prepend('<tr class="KBExtraSubmit"><td>&nbsp;</td><th>&nbsp;</th><td>'+submit+'</td></tr>');

        });


}

function emne() {
        $("div.EXLDetailsContent>ul>li:contains('Emnekoder'):not(:has(.KBsubLink))").each(function(index) {
                var emnekoder = $(this).html();
                if (emnekoder != null) {
                        var x = emnekoder.split(/<\/strong>|<\/STRONG>/);
                        emnekoder = x[1];
                        if (emnekoder != null) {
                                var html = '<strong>Subjects:</strong>';
                                var br = emnekoder.split(/<br>|<BR>/);
                                for(var b in br) {
                                        var ord = br[b].split(';');
                                        for(var o in ord) {
                                                var word = ord[o].replace(/^\s\s*/, '').replace(/\s\s*$/, '');
                                                if (word != '') {
                                                        html = html + '<a class="KBsubLink" href="search.do?dscnt=0&vl%281UI0%29=contains&scp.scps=scope%3A%28KGL%29&frbg=&tab=default_tab&vl%2892005084UI0%29=sub&srt=rank&vl%2892005085UI1%29=all_items&ct=search&mode=Basic&dum=true&tb=t&indx=1&fn=search&vid=KGL&indx=1&vl%28freeText0%29='+word+'">'+word+'</a>; ';
                                                }
                                        }
                                        html = html + '<br>';
                                }
                                $(this).html(html);
                        }
                }
        });

}


// Tilretninger af indholdet af faneblade - dynamisk
$(document).ajaxComplete( function() {
  KBFixTabs();
  hideLocationInfo();
  addLoginLink();
  bestil();
  emne();
});

$('.EXLLocationsIcon').live('click', function() {
   KBFixTabs();
   setTimeout('KBFixTabs();addLoginLinkFilter();',2000);
});

/*
SD sag 1012745. Når URL'ens link starter med
images.kb.dk, skal titlen ikke være klikbar.
Det er fordi det ofte er kuvertposter der indeholder
flere billeder.
Titelurlen , fører kun til den ene af billederne.
*/
function fixImageTitleUri(){
    $("h2 > a[href*='images.kb.dk']").each(function(){

        var tmp = $(this).html();
        $(this).parent().html(tmp);

    });
}


// 20112411, jac: autosubmit af forms når man opdatere 'selects'  
   $('#holdingsForm > select').live("change",function() {  
      $(this).closest('form').submit();   
   }); 


