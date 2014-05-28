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
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/tooltip.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/popover.js"></script>

<!-- CUSTOM JS -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/cookieInformerBooklet_da_DK.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_global.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_da_DK.js"></script>

<!-- Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/respond-min.js"></script>
<![endif]-->

<!-- NB: When translating a static html page that includes images, the link of the image
must be replaced as follows:
The existing link: "../images/imageName.gif" must be changed into: "../locale/specifcLocaleCode/images/imageName.gif" where "specifcLocaleCode" represents the relevant locale of the language (e.g en_US for English USA, zh_CH for Chinese).
-->
<!-- header_KGL_da_DK  -->
<header class="hidden-print">

    <a class="navbar-brand hidden-xs hidden-sm" href="http://www.kb.dk/da/index.html" title="Det Kongelige Bibliotek">
        <img src="../sites/kb/<%= view %>/images/kb/da/logo.png" alt="Det Kongelige Bibliotek"/>
    </a>
    <a class="navbar-brand visible-xs visible-sm" href="http://www.kb.dk/da/index.html" title="Det Kongelige Bibliotek">
        <img src="../sites/kb/<%= view %>/images/kb/logo.png" alt="Det Kongelige Bibliotek"/>
    </a>
</header>
<!--print only-->
<img class="visible-print" src="../sites/kb/<%= view %>/images/kb/da/logo.png" alt="Det Kongelige Bibliotek"/>
