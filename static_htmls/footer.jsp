<%@ page contentType="text/xml;charset=UTF-8" language="java"%>

<footer>

    <div class="row">
        <div class="col-xs-12 col-sm-4">
            <strong class="lead">REX</strong>
            <ul class="list-unstyled">
                <li><a href="http://www.kb.dk/en/REX/sider">Help</a></li>
                <li><a href="https://rex.kb.dk/F/?func=file&file_name=find-b&local_base=kgl01_rexclassic&con_lng=eng">REX Classic</a></li>
                <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Other libraries in REX</a></li>
                <li><a href="http://www.kb.dk/en/kub/service/sporgbib/forslag.html">Suggest a title</a></li>
            </ul>
        </div>

        <hr class="visible-xs" />

        <div class="col-xs-12 col-sm-4">
            <strong class="lead">THE ROYAL LIBRARY</strong>
            <ul class="list-unstyled">
                <li><a href="http://www.kb.dk/en/kb/aabningstider/">Opening Hours</a></li>
                <li><a href="http://www.kb.dk/en/kub/service/kontakt/index.html">Contact the library</a></li>
                <li><a href="http://www.kb.dk/en/kb/handicap/index.html">Information for disabled</a></li>
                <li><a href="http://www.kb.dk/en/kb/webstedet/cookiepolitik.html">Cookie- and privacy policy</a></li>
                <li><a href="http://www.kb.dk/en/kb/webstedet/index.html">About the website</a></li>
            </ul>
        </div>

    </div>

    <hr />

    <div class="row">

        <a href="http://www.kb.dk/en/" class="col-xs-2 col-sm-1">
            <img src="../sites/kb/dev02/images/kb/footerLogo.png" class="img-responsive" alt="The Royal Library" />
        </a>
        <div class="col-xs-10 col-sm-11">
            <address>
                <p>
                    <strong>
                        The Royal Library<br/>
                        National Library of Denmark and Copenhagen University Library
                    </strong>
                    <small>
                        <br/>
                        Søren Kierkegaards Plads 1 - DK-1016 1219 Copenhagen K - EAN: 5798 000795297 - <abbr title="Phone nr.">Phone: </abbr>+45 33 47 47 47 - E-mail <a href="mailto//:kb@kb.dk">kb@kb.dk</a>
                    </small>
                </p>

            </address>
        </div>
    </div>
</footer>
<!--begin footer-->

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
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/bootstrap/carousel.js"></script>

<!--end footer-->

<!-- CUSTOM JS -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/cookieInformerBooklet.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header_global.js"></script>
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/header.js"></script>

<!-- respond.js  -->
<script type="text/javascript" src="../sites/kb/<%= view %>/javascript/kb/respond-min.js"></script>
