<div id="KBTryThis" class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">Pr&oslash;v ogs&aring;</h3>
    </div>
    <div class="panel-body">
        <ul class="list-unstyled">
            <li><a href="http://www.kb.dk/da/kub/service/sporgbib/index.html">Kontakt biblioteket</a></li>
            <li>S&oslash;g p&aring; '<%= request.getParameter("query") %>' i <a href="http://bibliotek.dk/vis.php?origin=sogning&amp;field1=forfatter&amp;term1=&amp;field2=titel&amp;term2=&amp;field3=emne&amp;term3=&field4=fritekst&amp;term4=<%= java.net.URLEncoder.encode(request.getParameter("query"),"ISO-8859-1") %>&amp;mat_text=&amp;mat_ccl=&amp;term_mat%5B%5D=&amp;field_sprog=&amp;term_sprog%5B%5D=&amp;field_aar=year_eq&amp;term_aar=&amp;target%5B%5D=dfa" target="new">bibliotek.dk</a></li>
            <li>S&oslash;g p&aring; '<%= request.getParameter("query") %>' i <a href="http://scholar.google.dk/scholar?q=<%= java.net.URLEncoder.encode(request.getParameter("query"),"UTF-8") %>" target="new">Google scholar</a> eller <a href="http://books.google.dk/books?q=<%= java.net.URLEncoder.encode(request.getParameter("query"),"UTF-8") %>" target="new">Google books</a></li>
            <li>S&oslash;g p&aring; '<%= request.getParameter("query") %>' i <a href="http://www.worldcat.org/search?qt=worldcat_org_all&q=<%= java.net.URLEncoder.encode(request.getParameter("query"),"UTF-8") %>" target="new">Worldcat</a></li>
            <li>S&oslash;g p&aring; '<%= request.getParameter("query")%>' i <a href='http://search.theeuropeanlibrary.org/portal/en/search/("<%= java.net.URLEncoder.encode(request.getParameter("query"),"UTF-8") %>").query' target="new">European Library</a></li>
        </ul>
    </div>
</div>
