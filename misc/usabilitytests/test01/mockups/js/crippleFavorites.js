// Include this file to cripple all favorite links into poping over a prompt to log in.
$(document).ready(function () {
    $('<div class="kbModalOverlay"></div>').click(function () {
        $('.favoriteLink').popover('hide');
        $(this).css('display','none');
    }).appendTo(document.body);

    var loginLink = $('.btn-success').first().attr('href');
    $('.favoriteLink')
        .attr('href', '#') // TODO: Some of these could be written directly in the HTML, instead of making jQuery molest them?
        .removeAttr('title')
        .removeAttr('onclick')
        .attr('data-container', 'body')
        .attr('data-toggle', 'popover')
        .attr('data-html', 'true')
        .attr('data-content', '<a href="' + loginLink + '">Log ind</a> for at tilføje til favoritter')
        .popover({
            placement : 'bottom auto'
        })
        .click(function () {
            $('.kbModalOverlay').css('display','block');
            return false;
        });
});

