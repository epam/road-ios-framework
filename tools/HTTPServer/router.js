var file = require('./file.js');

var url = require('url') ;

var Router = {
	queryObject: function(queryURL) {
		var requestDescription = url.parse(queryURL, true);
		console.log(requestDescription);
		var parameters = requestDescription.query;
		console.log(parameters);
		if (parameters["time"] != undefined)
		{
			var now = new Date().getTime();
			while(new Date().getTime() < now + parameters["time"] * 1000) {
 	  			// do nothing
			}
		}
		return Router.getContentForParameter(requestDescription);
	
		
	},
	
	getContentForParameter : function(requestDescription)
	{
		return file.read('datasource.json');
	}
	
};

exports.queryObject = Router.queryObject;
