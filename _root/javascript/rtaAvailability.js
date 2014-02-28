in function handleResponse() (around line 124)
We only want to insert RTA elements where the ajax response contains actual content. Unfortunately it sometimes contains "&nbsp;" or "&nbsp; &nbsp; " or the likes.
When the content consist of any given variation of whitespace, and whitespace only, we want to remove the RTASpan_x and the RTADivTitle_x elements.

So the try catch block should be wrapped in the following if clause:


            if (statusObj.length > 0){ 
                for (var i = 0; i<statusObj.length; i++){
if (!/^(?:\s*\&nbsp;\s*)*$/.test(statusObj[i][0])) { // INSERTED BY HAFE
                try{
                    //for performance testing. substring(3) because when initiating the hidden field we prefix the current time with XXX
                    document.getElementById('rtaElapseTime_' + i).value =  new Date().getTime() - document.getElementById('rtaElapseTime_' + i).value.substring(3);
                    document.getElementById('RTASpan_' + i).innerHTML = statusObj[i][2];
                    document.getElementById('RTADivTitle_' + i).innerHTML = statusObj[i][0];
                    document.getElementById('RTADivTitle_' + i).className = statusObj[i][1];
                    //do only for brief
                    if(document.getElementById('availability_inlineDiv_' + i)){
                        document.getElementById('availability_inlineDiv_' + i).innerHTML = request.responseXML.getElementsByTagName("availhtml")[i].childNodes[0].nodeValue;
                    }
     
                    handleRtaRefresh(i);
                    }catch(e){

                    }
} else {                                            // INSERTED BY HAFE
    $('#RTASpan_' + i).remove();                    // INSERTED BY HAFE
    $('#RTADivTitle_' + i).remove();                // INSERTED BY HAFE
}                                                   // INSERTED BY HAFE
                }

            }

