<script>
	(function removeBootsrapCss() {
   if (!(document.URL.indexOf('search.do') > -1 || document.URL.indexOf('display.do') > -1)){
    var currCssLink = $("link[href*='bootstrap.css']").attr("href");
    var newCssLink = currCssLink.replace("bootstrap.css","KGL.css");
    $("link[href*='bootstrap.css']").attr("href",newCssLink);

   }
}());
</script>
<!--NB: When translating a static html page that includes images, the link of the image must be replaced as follows:
The existing link: "../images/imageName.gif" must be changed into: "../locale/specifcLocaleCode/images/imageName.gif" where "specifcLocaleCode" represents the relevant locale of the language (e.g en_US for English USA, zh_CH for Chinese).
-->

<!-- header_KGL_en_EN -->
<header class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand hidden-xs hidden-sm" href="http://www.kb.dk/en/index.html" title="The Royal Library">
        <img src="../sites/kb/dev02/images/kb/en/logo.png" alt="The Royal Library"/>
    </a>
    <a class="navbar-brand visible-xs visible-sm" href="http://www.kb.dk/en/index.html" title="The Royal Library">
        <img src="../sites/kb/dev02/images/kb/logo.png" alt="The Royal Library"/>
    </a>
</header>
