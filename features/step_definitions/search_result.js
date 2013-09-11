// step_definitions/search_result.js

//var host = "http://rex.kb.dk/primo_library/libweb/action/search.do?mode=Basic&vid=kbdev02&tab=artikler&";
//var host = "http://rex.kb.dk/primo_library/libweb/action/search.do?dscnt=0&scp.scps=primo_central_multiple_fe&frbg=&tab=artikler&dstmp=1378418513576&srt=rank&ct=search&mode=Basic&dum=true&tb=t&indx=1&vl(1UIStartWith0)=contains&vl(747308826UI1)=all_items&vl(747308355UI0)=any&vl(freeText0)=linux&fn=search&vid=KGL";

var host = "http://www.kb.dk/da/index.html";

var myStepDefinitionsWrapper = function () {  
    
    this.World = require("../support/world.js").World; // overwrite default World constructor
    
    this.Given(/^I am on the frontpage of REX in the article tab$/, function(callback) {
	callback();
    });
    
    this.Given(/^search for the term 'linux'$/, function(callback) {
	//this.searchTerm('#search_field', '#goButton', 'linux', callback);
	callback();
    });
    
    this.Then(/^there should be no occurences of both "([^"]*)" and "([^"]*)" any records$/, function(arg1, arg2, callback) {
	callback();
    });
    
};

module.exports = myStepDefinitionsWrapper;