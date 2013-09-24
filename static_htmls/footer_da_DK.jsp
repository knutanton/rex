<%@ page contentType="text/xml;charset=UTF-8" language="java"%>

<footer class="row">
    <div class="col-xs-12 col-sm-4">

        <strong class="lead">Rexs</strong>
        <ul class="list-unstyled">
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Hjælp</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Ny låner</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">REX Classic</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Bogforslag</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Biblioteker i REX samarbejdet</a></li>
        </ul>

    </div>
    <hr class="visible-xs" />
    <div class="col-xs-12 col-sm-4">

        <strong class="lead">Services</strong>
        <ul class="list-unstyled">
            <li> <a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Det Kongelige Bibliotek</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Danmarks National Biblioteket</a></li>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Københavns Universitets Bibliotek</a></li>
        </ul>

    </div>
    <hr class="visible-xs" />
    <div class="col-xs-12 col-sm-4">
        <div class="row">

            <div class="col-xs-2 col-sm-4">
                <img src="../sites/kb/dev02/images/kb/footerLogo.png" style="width:100%; height:auto;" alt="test"   />
            </div>
            <div class="col-xs-10 col-sm-8">
                <address>
                    <strong class="lead">Det Kongelige Bibliotek</strong><br/>
                    Søren Kierkegaards Plads 1<br>
                    1219 København K<br>
                    EAN: 5798 000795297<br>
                    <abbr title="Telefon nr.">Tlf:</abbr>(+45) 33 47 47 47<br>
                    E-mail <a href="mailto//:kb@kb.dk">kb@kb.dk</a>
                </address>
                <ul class="list-unstyled">
                    <li><a href="#">Åbningstider & Adresser</a></li>
                    <li><a href="#">Kontakt biblioteket</a></li>
                    <li><a href="#">Handikaphjælp</a></li>
                    <li><a href="#">Cookie- og Privatlivspolitik</a></li>
                    <li><a href="#"></a></li>
                </ul>
            </div>

        </div>



    </div>


</footer>
<!--begin footer-->
<!--footer_KGL_da_DK.html-->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-1269676-9']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
<!-- autocomplete imports -->
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<!-- END autocomplete -->


<div id="myModal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog wide">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">X</button>
        <h3>Mine e-ressourcer (BETA)</h3>
      </div>
      <div class="modal-body">
        <iframe name="eresFrame" id="eresFrame" src="http://mine-eres.kb.dk/favoritter/front.php" frameborder="no" scrolling="no" style=" width:100%; height:510px;"></iframe>
      </div>
    </div>
  </div>
</div>

<!-- dynamic inclusion of js files -->
<%
    String view = request.getParameter("vid");
    if(view.startsWith("kb")){
        view = view.substring(2);
    }

%>


<!-- BOOTSTRAP JS -->
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/alert.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/collapse.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/dropdown.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/modal.js"></script>

<!-- CUSTOM JS -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_global.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_da_DK.js"></script>

<!--end footer-->
