// features/support/world.js


var World = function World(callback) {
  this.phantom = require('phantom-proxy');
  this.stuff = 'world';

// Browser / navigation functions

  this.visit = function (url, callback) {
    //this.browser.visit(url, callback);
  };

  this.searchTerm = function (inputField, buttonName, term, callback) {
    this.browser.fill(inputField, term).pressButton(buttonName, callback);
  };


// Test functions
this.frbrCheckOk = function () {
  var results = this.browser.document.querySelectorAll(".EXLResult");


  for (var i = 0 ; i < results.length; i++){
      var elem = results[i];
      console.log(this.browser.text(".EXLResultTitle", elem));
      if(this.browser.query(".EXLBriefResultsDisplayMultipleLink",elem)) {
        this.browser.evaluate("$('.EXLTabsRibbon').is(':visible')");

        
      }
    }
    return results.length === 10;
  }
  callback(); // tell Cucumber we're finished and to use 'this' as the world instance
};
exports.World = World;