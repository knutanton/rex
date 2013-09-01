// features/support/world.js

var zombie = require('zombie');
var World = function World(callback) {
  this.browser = new zombie({debug: false, silent: true}); // this.browser will be available in step definitions


  this.visit = function (url, callback) {
    this.browser.visit(url, callback);
  };

  this.fill = function (name, value, callback) {
    this.browser.fill(name, value, callback);
  };

  this.pressButton = function (buttonName, callback) {
    this.browser.fill("#search_field", "linux").pressButton(buttonName, callback);
  };

  this.isOnPageWithTitle = function (title) {
    return this.browser.text("title") === title;
  };


  callback(); // tell Cucumber we're finished and to use 'this' as the world instance
};
exports.World = World;