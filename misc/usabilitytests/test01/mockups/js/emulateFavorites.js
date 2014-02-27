// Include this file to hook up stars with the number badge in the top bar (counting up and down on click).
// TopNavBar needs a class .topNavBar and favorites badge needs a class .favorites for this to function.
$(document).ready(function () {
    var stars = $('.EXLMyShelfStar a'),
        favoritesBadge = $($('.topNavBar a .badge.favorites')[0]),
        allStar = $('.EXLFacetSaveToEShelfAction a');

    var favInc = function () { favoritesBadge.text(parseInt(favoritesBadge.text(),10) + 1); }
    var favDec = function () { favoritesBadge.text(parseInt(favoritesBadge.text(),10) - 1); }
    var starToggle = function (star) {
        var icon = $(star).find('.glyphicon');
        if (icon.hasClass('glyphicon-star-empty')) {
            icon.removeClass('glyphicon-star-empty').addClass('glyphicon-star yellow');
            favInc();
        } else {
            icon.removeClass('glyphicon-star yellow').addClass('glyphicon-star-empty');
            favDec();
        }
    }

    allStar.attr('onclick',null);
    stars.attr('onclick', null);

    stars.bind('click', function () {
        starToggle(this);
        return false;
    });

    allStar.bind('click', function () {
        var icon = $(this).find('.glyphicon');
        if (icon.hasClass('glyphicon-star-empty')) {
            icon.removeClass('glyphicon-star-empty').addClass('glyphicon-star yellow');
            $.each(stars, function (index, star) {
                if ($(star).find('.glyphicon').hasClass('glyphicon-star-empty')) {
                    starToggle(star);
                }
            });
        } else {
            icon.removeClass('glyphicon-star yellow').addClass('glyphicon-star-empty');
            $.each(stars, function (index, star) {
                if ($(star).find('.glyphicon').hasClass('glyphicon-star')) {
                    starToggle(star);
                }
            });
        }
        return false;
    });
});

