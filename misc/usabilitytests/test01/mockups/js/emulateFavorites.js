// Include this file to hook up stars with the number badge in the top bar (counting up and down on click).
$(document).ready(function () {
    var stars = $('.EXLMyShelfStar a'),
        favoritesBadge = $($('.topNavBar a .badge')[0]);

    var favInc = function () { favoritesBadge.text(parseInt(favoritesBadge.text(),10) + 1); }
    var favDec = function () { favoritesBadge.text(parseInt(favoritesBadge.text(),10) - 1); }

    stars.bind('click', function () {
        var icon = $(this).find('.glyphicon');
        if (icon.hasClass('glyphicon-star-empty')) {
            icon.removeClass('glyphicon-star-empty').addClass('glyphicon-star');
            favInc();
        } else {
            icon.removeClass('glyphicon-star').addClass('glyphicon-star-empty');
            favDec();
        }
        return false;
    });
});

