// features/step_definitions/basic_search_feature.js

var myStepDefinitionsWrapper = function () {
  this.World = require("../support/world.js").World; // overwrite default World constructor


  this.Given(/^I am on the frontpage of REX$/, function (callback) {
    this.visit('http://www.kb.dk/rex', callback);
  });

  this.Given(/^type 'linux' in the search box$/, function (callback) {
    //this.fill("#search_field","linux",callback);

    callback();
  });

  this.When(/^I hit the 'search' button$/, function (callback) {
    this.pressButton("#goButton", callback);
  });

  this.Given(/^hit the 'search' button$/, function (callback) {
  // express the regexp above with the code you wish you had
    callback.pending();
  });

  var title = "REX - linux";
  this.Then(/^the title of the page should be REX - linux$/, function (callback) {
    if (!this.isOnPageWithTitle(title)) {
      // You can make steps fail by calling the `fail()` function on the callback:
        console.log("'" + this.browser.text("title") + "'");
        callback.fail(new Error("Expected to be on page with title '" + title  + "'"));
    } else {
        callback();
        }
    });

 this.When(/^I click the facet 'online material'$/, function (callback) {
  // express the regexp above with the code you wish you had
  callback.pending();
});

  this.Then(/^all items should have 'online' tabs$/, function (callback) {
  // express the regexp above with the code you wish you had
    callback.pending();
  });
};

module.exports = myStepDefinitionsWrapper;