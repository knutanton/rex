module.exports = {
	'Testing the rex frontpage': function (test) {
	  test
	    .open('http://primo-97.kb.dk/primo_library/libweb/action/search.do?dscnt=1&fromLogin=true&dstmp=1381382974048&vid=kbdev01&fromLogin=true')
	    	.assert.text('#exlidUserAreaRibbon li', 'Ny låner', 'New user menu item in place')
	    	.assert.numberOfElements('#exlidUserAreaRibbon li a', 10 , 'There exisits 10 menu items')
	    	.assert.doesntExist('#exlidPleaseWaitContainer', 'Please Wait container kindly removed from the UI')
	    .done();
	}
};
