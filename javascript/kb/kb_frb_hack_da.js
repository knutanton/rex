/**
* "FRBR Display Improvements",  from Ex Libris code share
* Author: Jeremy Prevost, Northwestern University Library, 2011
*
* implemented and adapted to on www.kb.dk/rex by jac@kb.dk, 2012
*
* DANISH version
*/


// Theese Strings match the names of the 
// labels that are used in the HTML (frontend)
// If the label changes, change theese accordingly
var relevanceString = 'Relevans';
var yearOldString = 'År%20-%20ældste';
var yearNewString = 'År%20-%20nyeste';
var authorString  = 'Forfatter';
var titleString = 'Titel';

$(document).ready(function () {
    
    $('link[href~="../css/mobile.css"]').remove();

    $('.EXLResult').each(function () {
        var frbr = $(this).find('.EXLResultFRBR').length;
        // if it's a FRBR record, hide stuff
        if (frbr != 0) {
            // hide links for FRBR groups
            $(this).find('.EXLTabsRibbon').hide();

            // remove link from title for FRBR groups
            $(this).find(".EXLResultTitle").find("a").removeAttr("href");

            // hide publisher for FRBR groups
            $(this).find(".EXLResultFourthLine").hide();

            // hide availability for FRBR groups
            $(this).find(".EXLResultAvailability").hide();

            // place display multiple link below title,
            // and change link of title and thumbnail
            var link = $(this).find(".EXLBriefResultsDisplayMultipleLink");
            $(this).find(".EXLSummaryFields").append(link);
            var titlelink = $(this).find(".EXLResultTitle").find("a");
            titlelink.attr("href", link.attr("href"));
            titlelink.attr("target", "_parent");
            var thumblink = $(this).find(".EXLThumbnail .EXLBriefResultsDisplayCoverImage A");
            thumblink.attr("href", link.attr("href"));

            // hide the my shelf star
            $(this).find(".EXLMyShelfStar A").hide();

            // hide original FRBR button
            $(this).find(".EXLResultFRBR").hide()
            // hide thumbnail image for FRBR groups (only appropriate if you don't create separate groups for each format)
            // Uncomment to enable.
            //$(this).find(".EXLThumbnail").find(".EXLThumbnailCaption").hide();
            //$(this).find(".EXLThumbnail").find(".EXLBriefResultsDisplayCoverImages").hide();
        }
    });

    // The rest of the code sorts FRBR displays by date and returns the user to the previous sort option when they remove the FRBR facet. If you don't like this feature, remove it!
    // grabs URL parameters
    // required for sort order functions to work
    // source: http://www.netlobo.com/url_query_string_javascript.html
    function gup(name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.href);
        if (results == null)
            return "";
        else
            return results[1];
    }

    // sort frbr groups by date
    // each "Der er XXX udgaver af dette materiale
    $(".EXLBriefResultsDisplayMultipleLink").each(function () {
        var TheURL = $(this).attr('href');
        var URLsplit = TheURL.split("?");
        var template = URLsplit[0];
        var querystring = URLsplit[1];
        var sort = '?srt=date&';

        var currentsort = $(".EXLResultsSortBySelected:first").text();

        var origsort = gup('origsort');

        var sortedURL = template + sort + querystring + '&origsort=' + currentsort;

        $(this).attr('href', sortedURL)
    });

    // on FRBR display pages, links back to result list try to remember what sort was in the previous list

    $(".EXLFirstRefinementElement").each(function () {

   // $(".EXLSearchRefinementRemovefacet_frbrgroupid").each(function () {

       // alert("adasda");
        var TheURL = $(this).attr('href');

        var URLsplit = TheURL.split("?");
        var template = URLsplit[0];
        var querystring = URLsplit[1];
        var sort = '?srt=date&';

        var currentsort = $(".EXLResultsSortBySelected:first").text();
        var origsort = gup('origsort');
        var URLsort = gup('srt');

        // remove any existing origsort from URL to protect from confusion later on
        var origsortcleaner = '&origsort=' + origsort;

        TheURL = TheURL.replace(origsortcleaner, '');

        $(this).attr('href', TheURL);

        if (currentsort != origsort) {

            // change srt URL parameter to origsort (after changing to match Primo syntax)
            var URLsortcleaner = 'srt=' + URLsort;
	    if (origsort == relevanceString){
                TheURL = TheURL.replace(URLsortcleaner, 'srt=rank');
                document.getElementById('str').value = origsort;
            }
            else if (origsort == yearOldString) {
                TheURL = TheURL.replace(URLsortcleaner, 'srt=lso01');
            }
            else if (origsort == yearNewString) {
                TheURL = TheURL.replace(URLsortcleaner, 'srt=date');
            }
            else if (origsort == authorString) {
                TheURL = TheURL.replace(URLsortcleaner, 'srt=author');
                document.getElementById('str').value = origsort;
            }
            else if (origsort == titleString) {
                TheURL = TheURL.replace(URLsortcleaner, 'srt=title');
                document.getElementById('str').value = origsort;
            }

            $(this).attr('href', TheURL);

        }
    });
});
