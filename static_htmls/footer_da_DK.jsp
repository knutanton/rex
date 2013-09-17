<footer class=container>
    <div class="col-md-8">
        <h2>Genveje</h2>
        <ul>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Biblioteker i REX samarbejdet</a></li>
            <li><a href="http://www.kb.dk/da/kub/service/sporgbib/forslag.html">Bogforslag</a></li>
            <li><a href="https://rex.kb.dk/F/?func=file&file_name=find-b&local_base=kgl01_rexclassic&con_lng=DAN">REX Classic</a></li>
            <li class="EXLFooterLastLink"><a href="http://www.kb.dk/da/kub/service/sporgbib/index.html">Spørg biblioteket</a></li>
        </ul>
    </div>
    <address class="col-md-4">
        <strong>Det Kongelige Bibliotek</strong><br>
        Søren Kierkegaards Plads 1<br>
        1219 København K<br>
        EAN: 5798 000795297<br>
        <abbr title="Telefon nr.">Tlf:</abbr>(+45) 33 47 47 47<br>
        <a href="mailto//:kb@kb.dk">kb@kb.dk</a>
    </address>
    <div>
        <ul class="list-inline">
            <li><a href="http://www.kb.dk/da/kb/webstedet/index.html">Om webstedet</a></li>
            <li><a href="http://www.kb.dk/da/kb/copyright/index.html" title="Oplysninger om ophavsret på Det Kongelige Bibliotek">Ophavsret</a></li>
            <li><a href="http://www.kb.dk/da/kb/handicap/index.html">Handikap-information</a></li>
        </ul>
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
  <div class="modal-dialog">
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
