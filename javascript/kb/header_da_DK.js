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

        return this.replaceWith(function(idx) {
            return $("<" + newType + "/>", attrs[idx]).data(data[idx]).append($(this).contents());
        });
    };
}(jQuery));

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
      if (!($(this).parent().parent().parent().parent().is(':contains("hylden"),:contains("Forventes"),:contains("Ikke udkommet"),:contains("Netop afleveret"),:contains("cmb@kb.dk"),:contains("PDF")'))) {
        $(this).append("<li class='requestForm'><a title='Er der mere end to ugers ventetid p&aring; materialet? Pr&#248v at bestille det i Bibliotek.dk og anf&#248r, at du vil hente det p&aring; Det Kongelige Bibliotek/K&#248benhavns Universitets Biblioteksservice. S&aring; kan vi m&aring;ske skaffe det hurtigere fra et andet bibliotek i Danmark' href='http://bibliotek.dk/linkme.php?ccl=lid%3D" + doc + "' target='_blank'>Prøv bibliotek.dk</a></li>");
      }
    }
    // Fjern links uden mening
    $(this).find("a:contains('Bestilling ikke mulig')").replaceWith('Bestilling ikke mulig');

  });
  // omdoeb requests til reservationer
  $(".EXLLocationTable>tbody>tr>td:contains('request(s) of')").each(function () {
      $(this).text(
        $(this).text().replace(/request\(s\) *of *([0-9]+) *items/ ,'af $1 eks')
      );
  });

  // Vis thumbnails for billeder i billedbasen i online-delen
  $(".EXLViewOnlineLinksTitle>a[href*='images.kb.dk']:not(:has(img))").each(function (index) {
    var link=$(this).attr("href");
    $(this).prepend("<img alt='thumbnail' src='" + link.replace("present","thumbnail") + "'><br/>");
  });
  $('iframe#bX').load(function() {
    $(this).contents().find('head>link').attr('href','../../../css/KGL_bX.css');
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

$('.EXLRecommendTab').live('click',function () {
  $('iframe#bX').each(function() {
    $(this).contents().find('head>link').attr('href','../../../css/KGL_bX.css');
  });
});


function hideLocationInfo() {
	//DGJ
	$("span.EXLLocationInfo>strong").hide();
//	$("span.EXLLocationInfo>cite").hide();
}

function addLoginLink() {
	//DGJ
	var url = $('#exlidSignOut>a').attr('href');
	$(".EXLLocationTableActions:contains('Log ind for at reservere')")
		.html('<a href="'+url+'">Log ind for at reservere </a>');
}

function addLoginLinkAlleMaterialer() {

	// DGJ : til 'alle materialer'
	var url = $('#exlidSignOut>a').attr('href');
	$(".EXLLocationTableActionsFirstItem:contains('Log ind for at reservere')").html('<a href="'+url+'">Log ind for at reservere</a>');

}

function addLoginLinkFilter() {
        //DGJ --> udvidet til sub-library filtering KNAB
        var url = $('#exlidSignOut>a').attr('href');
        $(".EXLLocationTableActionsFirstItem:contains('Log ind for at reservere')")
                .html('<a href="'+url+'">Log ind for at reservere</a>');
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
        var sid = s.split("$$OKGL01"); 
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

function EXLTA_wrapResultsInNativeTab(element, content,url, headerContent){ 
        var popOut = '<div class="EXLTabHeaderContent">'+headerContent+'</div><div class="EXLTabHeaderButtons"><ul><li class="EXLTabHeaderButtonPopout"><span></span><a href="'+url+'" target="_blank"><img src="../images/icon_popout_tab.png" /></a></li><li></li><li class="EXLTabHeaderButtonCloseTabs"><a href="#" title="hide tabs"><img src="../images/icon_close_tabs.png" alt="hide tabs"></a></li></ul></div>';
        var header = '<div class="EXLTabHeader">'+ popOut +'</div>';
        var htmlcontent = '';
        if (typeof(content) === 'function') {
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

function EXLTA_createWidgetTabHandler(content,reentrant){
        return function(e,element,tabType,url,isSelected){
                e.preventDefault();
                
                if (isSelected && t){
                        EXLTA_closeTab(element);
                }else{
                        EXLTA_openTab(element,tabType, EXLTA_wrapResultsInNativeTab(element,content,url,''),reentrant);
                }
        };
}

function EXLTA_addLoadEvent(func){
        addLoadEvent(func);
}

function EXLTA_isFullDisplay(){  
	return $('.EXLFullView').size() > 0;
}
//NKH Slut (EOD functions)


function TextReplaceObject(originalText, newText) {
    this.originalText = originalText.toLowerCase().trim();
    this.newText = newText;
}

function replaceTextInLocationsTab(textReplaceObjects) {
    $(".EXLLocationsTab").ajaxComplete(function(event, xhr, settings) {
        if($(event.currentTarget).hasClass("EXLResultSelectedTab")) {
            var htmlResult = $(event.currentTarget).parents().eq(3),
                html = htmlResult.find(".EXLSublocation"),
                matchText = html.find(".EXLLocationTableColumn2, .EXLLocationTableColumn3").text().trim().toLowerCase();

            $.each(textReplaceObjects, function(index, textReplaceObject) {
                if(matchText.indexOf(textReplaceObject.originalText) > -1) {
                    html.find(".EXLLocationTableActionsMenu ul li:contains(ikke)").html(textReplaceObject.newText);
		    return;
                }
            });
        }
    });
}

function trafiklys() {
    var resultItems = $("tr[id^='exlidResult']");
    //iterate over items and create trafiklys query for each one
    $.each(resultItems, function() {
        var openUrl = parseOpenUrl($(this));
        if (openUrl !== null) {
            var baseUrl = "http://sfx-test-01.kb.dk:3000/trafiklys/lookUp/";
            var fullUrl = baseUrl + encodeURIComponent(openUrl) + "/" + window.ip + "/" + userInst + "?callback=?";
            var id = $(this).attr('id');
            //make jsonp get request and append result to our post
            $.getJSON(fullUrl, { format: "json" }, function(data) {
                //console.log(fullUrl);
                //parse response and insert message into result
                var access = parseResponse(data),
                    trafiklysMessage;
                if (access.toLowerCase() === "no") {
                    trafiklysMessage = '<em class=".EXLResultsList EXLResultStatusNotAvailable">Trafiklys: ' + access + '</em>';
                    $('#' + id).find('.EXLResultAvailability').append(trafiklysMessage);
                } else if (access.toLowerCase() === "yes") {
                    trafiklysMessage = '<h3 style="color: green;">Trafiklys: ' + access + '</h3>';
                    $('#' + id).find('.EXLResultAvailability').append(trafiklysMessage);
                    $('#' + id).find('.requestForm').hide();
                }
            });
        }

    });

    function parseOpenUrl(resultItem) {
        var longUrl = resultItem.find("input[id^=getit]").attr('value');
        //make sure we got a longUrl
        if (typeof longUrl !== 'undefined') {
            //openUrl occupies this position and starts with ctx_ver
            var openUrl = longUrl.split('?')[1];
            if (typeof openUrl !== 'undefined'
             && openUrl.slice(0,7) === 'ctx_ver'){
                    return openUrl;
            }
            return null;
        }
    }

    function parseResponse(data) {
        return data['trafiklys']['response']['access'];
    }
}

function startsWith(s,a) { // FIXME: These helper methods shouldn't be dumped in window!
        var x;
        for (x in a) {
                if (s.indexOf(a[x]) === 0) {
                        return true;
                }
        }
        return false;
}

$(document).ready(function() {
 
    //we need the user's IP to call Trafiklys
    var ipUrl = "http://sfx-test-01.kb.dk:3000/trafiklys/get_ip?callback=?";
	$.getJSON(ipUrl, function(data) {
        window.ip = data['ip'];
    }).done(trafiklys);

	var dod = new TextReplaceObject("Brug Digital Version", '<a href="http://www.kb.dk/da/nb/samling/dod/DODbestilling.html" target="_blank">Efter særlig ansøgning</a>'),
        kob = new TextReplaceObject("Mail til kob", '<a href="http://www.kb.dk/da/nb/samling/ks/kobbestilling.html" target="_blank">Mail til kob</a>'),
        mailToDfs = new TextReplaceObject("DFS Brug", '<a href="mailto:dfs-mail@kb.dk">Mail til dfs-mail@kb.dk</a>') ,
        // mailToKob = new TextReplaceObject("Mail til kob", '<a href="mailto:kob@kb.dk">Mail til kob@kb.dk</a>'),
	textReplaceObjectArray = [dod, kob, mailToDfs];

    replaceTextInLocationsTab(textReplaceObjectArray);

//		fixImageTitleUri();
                var lang = $("#exlidSelectedLanguage").html().substring(0,2);

                var signoutText = $("#exlidSignOut").find("a").html();
                if (startsWith(signoutText,Array('Log ud','Sign out'))) {
                        // things to do when the user is logged ind

                        // change edit link
                        $("div.EXLMyAccountEditLink").html('<span><a href="https://login.kb.dk/kbuser/useredit" target="_new">Rediger</a></span>');
//                                .find("a")
//                                .attr("href","https://login.kb.dk/kbuser/useredit")
//                                .attr("onClick","return true;")
//                                .attr("target","_new");
                        $("#exlidMyAccountMainContainer1").filter(":contains('gebyrer')").append('<div id="KBPay"><iframe id="KBPayFrame" width="100%" src="https://rex.kb.dk/F/?func=file&file_name=bor-info-primo"></div>');
                } else {
                        // things to do when the user is NOT logged in

                        // remove edit link
                        $("div.EXLMyAccountEditLink").hide();
                        $("li.EXLMyAccountTab").filter(":contains('Din konto')").hide();

                        //$("#exlidMyAccount").hide();
                        $("#exlidMyAccount>a").attr("href","login.do?loginFn=signin&targetURL=myAccountMenu.do%3fvid%3dKGL");
			
			addLoginLinkAlleMaterialer();
			

                }
		$(".EXLMyAccountTable>tbody>tr>td:eq(6)").hide();
	        // set text til "annuleret" for bestemte REQ-STATUS (midlertidigt fix) -- DGJ
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Genbestilles fra Netpunkt/Subito')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Overskredet interessedato')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Materialet findes ikke')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Materialet udlånes ikke')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Ej betale fra udlandet')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Købes via PRO')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Dobbelt bestilling')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('nes ikke fra institut')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Alle eksemplarer udl')").html("Annulleret");
//                $(".EXLMyAccountTable>tbody>tr>td:contains('Kan ikke sendes')").html("Annulleret");

		
// csv: Adding pickup numbers
$(".EXLMyAccountTable>tbody>tr>td:contains('Ligger til afhentning')").each( function() {
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

// EXLTA_addLoadEvent(function(){
//      EXLTA_addTab('EOD/eBooks','EODTab','eBooks',eodTabHandler,false,eodEvaluator);
// });   

//NKH Slut (ADD EOD Tabs)


  $(".EXLResultTabs:has(.EXLMoreTab):not(:has(.EXLLocationsTab))").each(function (index) {
  // Tilret faneblade - indsaet skaf-links, hvis AndreTilbud-tab, men ingen bestillings-tab
    var html=$(this).find('li:first').html();
    var regex=/doc=([^&]*)/;
    if (regex.test(html)) {
      var doc=regex.exec(html)[1];
 var resultHtmlElement = $(this).parents().eq(3);
            if (!($(resultHtmlElement).find('.EXLResultFourthLine').is(':contains("Adgang:")'))) {
      $(this).append("<li class='requestForm EXLResultTab'><a title='Skaf materiale, som er udl&aring;nt eller ikke er bestilbart' href='http://rex.kb.dk/userServices/menu/Order?primoId=" + doc + "' target='_blank'>Skaf</a></li>");
    }
    }
  });


  // Vis thumbnails for billeder i billedbasen
  $(".EXLDetailsLinksTitle>a[href*='images.kb.dk']").each(function (index) {
    var link=$(this).attr("href");
    $(this).prepend("<img alt='thumbnail' src='" + link.replace("present","thumbnail") + "'><br/>");
  });
  // Tilret tabs - relevant ved fuld visning
  KBFixTabs();
  // Ret engelsk til dansk ved fotokopibestillinger
  $(".EXLMyAccountTable>tbody>tr>td:contains('Waiting in queue'),.EXLMyAccountTableDetails>tbody>tr>td:contains('Waiting in queue')").each(function () {
      $(this).html("Venter i k&oslash"); 
  });
  $(".EXLMyAccountTable>tbody>tr>td:contains('In process'),.EXLMyAccountTableDetails>tbody>tr>td:contains('In process')").each(function () {
      $(this).html("Under behandling"); 
  });
});

function bestil() {
        $("div.EXLRequestTabContent").each(function(index){
                var submit = $(this).find("#exlidRequestTabFormSubmit").parents().html();
                $(this).find("tbody:not(:has(.KBExtraSubmit))").prepend('<tr class="KBExtraSubmit"><td>&nbsp;</td><th>&nbsp;</th><td>'+submit+'</td></tr>');

        });


}

function emne() {
    $("div.EXLDetailsContent>ul>li:contains('Klassifikation/emnekoder'):not(:has(.KBsubLink))").each(function(index) {
        var emnekoder = $(this).html();
        if (emnekoder !== null) {
            var x = emnekoder.split(/<\/strong>|<\/STRONG>/);
            emnekoder = x[1];
            if (emnekoder !== null) {
                var html = '<strong>Klassifikation/emnekoder:</strong>',
                    br = emnekoder.split(/<br>|<BR>/),
                    b;
                for(b in br) {
                    var ord = br[b].split(';'),
                        o;
                    for(o in ord) {
                        var ord2 = ord[o].split(','),
                            o2;
                        for (o2 in ord2) {
                            var word = ord2[o2],
                                word2 = ord2[o2].replace(/^\s*/, '').replace(/\s*$/, '');
                            if (word !== '' && word.indexOf('</span>') === -1) {
                                html = html + '<a class="KBsubLink" href="search.do?dscnt=0&vl%281UI0%29=contains&vl(468199667UI0)=lsr05&scp.scps=scope%3A%28KGL%29&frbg=&tab=default_tab&vl%2892005084UI0%29=sub&srt=rank&vl%2892005085UI1%29=all_items&ct=search&mode=Basic&dum=true&tb=t&indx=1&fn=search&vid=KGL&indx=1&vl%28freeText0%29='+word2+'">'+word+'</a>; ';
                            }
                        }
                    }
                    html = html + '<br>';
                }
                $(this).html(html);
            }
            $(this).html(html);
        }
    });
}

// Tilretninger af indholdet af faneblade - dynamisk
$(document).ajaxComplete( function() {
  KBFixTabs();
  hideLocationInfo();
  addLoginLink();
  addLoginLinkFilter();
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


