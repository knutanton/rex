<!-- dynamic inclusion of js files -->
<%
      // jac: points to search tile in our dev environments
        String view = request.getSession().getAttribute( "vid" )+ "";

        // remove 'kb', so it fits our folder structure
        if(view.startsWith("kb")){
            view = view.substring(2);
        }
%>

<script type="text/javascript">var kbViewPath = '<%= view %>';</script>

<!-- BOOTSTRAP JS -->
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/alert.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/collapse.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/dropdown.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/modal.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/carousel.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/transition.js"></script>

<!--end footer-->

<!-- CUSTOM JS -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/cookieInformerBooklet.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_global.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header.js"></script>

<!-- Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/respond-min.js"></script>
<![endif]-->


<!--NB: When translating a static html page that includes images, the link of the image must be replaced as follows:
The existing link: "../images/imageName.gif" must be changed into: "../locale/specifcLocaleCode/images/imageName.gif" where "specifcLocaleCode" represents the relevant locale of the language (e.g en_US for English USA, zh_CH for Chinese).
-->

<!-- header_KGL_en_EN -->
<header class="navbar-header hidden-print">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand hidden-xs hidden-sm" href="http://www.kb.dk/en/index.html" title="The Royal Library">
        <img src="../sites/kb/<%= view %>/images/kb/en/logo.png" alt="The Royal Library"/>
    </a>
    <a class="navbar-brand visible-xs visible-sm" href="http://www.kb.dk/en/index.html" title="The Royal Library">
        <img src="../sites/kb/<%= view %>/images/kb/logo.png" alt="The Royal Library"/>
    </a>
</header>
<img class="visible-print"  src="../sites/kb/<%= view %>/images/kb/en/logo.png" alt="The Royal Library"/>
