<%@ page contentType="text/xml;charset=UTF-8" language="java"%>
<%
      // jac: points to search tile in our dev environments
        String view = request.getSession().getAttribute( "vid" )+ "";

        // remove 'kb', so it fits our folder structure
        if(view.startsWith("kb")){
            view = view.substring(2);
        }
%>
<footer>

    <div class="row hidden-print">
        <div class="col-xs-12 col-sm-4">
            <strong class="lead">REX</strong>
            <ul class="list-unstyled">
                <li><a href="http://e-tidsskrifter.kb.dk/?umlaut.locale=en">E-journals</a>
                <li><a href="http://www.kb.dk/en/REX/sider">Help / FAQ</a></li>
                <li><a href="https://rex.kb.dk/F/?func=file&file_name=find-b&local_base=kgl01_rexclassic&con_lng=eng">REX Classic</a></li>
                <li><a href="http://www.kb.dk/da/REX/sider/biblioteker.html">Other libraries in REX</a></li>
                <li><a href="http://www.kb.dk/en/kub/service/sporgbib/forslag.html">Suggest a title</a></li>
                <li><a title="Special Request" href="https://rex.kb.dk/userServices/menu/Order" target="_blank">Can't find what you're looking for?</a></li>
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
            <img src="../sites/kb/<%= view %>/images/kb/footerLogo.png" class="img-responsive" alt="The Royal Library" />
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
                        <br/>
                        <span class="glyphicon glyphicon-thumbs-up"></span> <a href="https://www.facebook.com/DetKongeligeBibliotek" target="_blank">Follow us on facebook</a>
                    </small>
                </p>

            </address>
        </div>
    </div>
</footer>
<!--begin footer-->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-1269676-9']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  $('#facetList div ul:lt(2)').addClass('in');
</script>
