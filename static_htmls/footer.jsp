<%@ page contentType="text/xml;charset=UTF-8" language="java"%>
<!--begin footer-->
<!--footer_KGL.html-->
<footer class=row>
    <div class="col-md-8">
        <h2>Shortcuts</h2>
        <ul>
            <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Other libraries in REX</a></li>
            <li><a href="http://www.kb.dk/en/kub/service/sporgbib/forslag.html">Suggest a title</a></li>
            <li><a href="https://rex.kb.dk/F/?func=file&file_name=find-b&local_base=kgl01_rexclassic&con_lng=eng">REX Classic</a></li>
            <li class="EXLFooterLastLink"><a href="http://www.kb.dk/en/kub/service/sporgbib/index.html">Ask the library</a></li>
        </ul>
    </div>
    <address class="col-md-4">
        <strong>The Royal Library</strong><br>
        Søren Kierkegaards Plads 1<br>
        1219 Copenhagen K<br>
        EAN: 5798 000795297<br>
        <abbr title="Telefon nr.">Tlf:</abbr>(+45) 33 47 47 47<br>
        <a href="mailto//:kb@kb.dk">kb@kb.dk</a>
    </address>
    <div>
        <ul class="list-inline">
            <li><a href="http://www.kb.dk/en/kb/webstedet/index.html">About the website</a></li>
            <li><a href="http://www.kb.dk/da/kb/copyright/index.html" title="Oplysninger om ophavsret på Det Kongelige Bibliotek">Ophavsret</a></li>
            <li><a href="http://www.kb.dk/en/kb/handicap/index.html">Information for disabled</a></li>
        </ul>
    </div>
</footer>

 <!-- script type="text/javascript" src="../javascript/kb_frb_hack_en.js"></script -->



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


<div id="myModal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog wide">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">X</button>
        <h3>My e-ressources (BETA)</h3>
      </div>
      <div class="modal-body">
        <iframe name="eresFrame" id="eresFrame" src="http://mine-eres.kb.dk/favoritter/front.php?lang=en" frameborder="no" scrolling="no" style=" width:100%; height:510px;"></iframe>
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
<!--end footer-->

<!-- CUSTOM JS -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_global.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header.js"></script>
