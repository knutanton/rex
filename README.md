rex
===

Responsive design for ExLibris Primo



Current stageing setup:
javascript/kb/header.js:        $("div.EXLMyAccountEditLink").html('<span><a href="https://user.kb.dk/user/edit" target="_blank">Edit</a></span>');
javascript/kb/header_da_DK.js:        $("div.EXLMyAccountEditLink").html('<span><a href="https://user.kb.dk/user/edit" target="_blank">Rediger</a></span>');
tiles/userAreaTile.jsp:            <c:set var="newBorrowerUrl" value="https://user.kb.dk/user/create" /><%-- FIXME: What's the point in setting a variable an
