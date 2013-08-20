var http   = require('http');
var colors = require('colors');
var router = require('./router.js');
var file = require('./file.js');
var instance;

var Server = {

	init: function(authreq){
	
		instance = http.createServer(function(request, response){
			console.log(JSON.stringify(request.url, null, 4));
			console.log(JSON.stringify(request.headers, null, 4));
			
			var auth = request.headers['authorization'];
			var token = request.headers['token'];
			var shouldAuthenticate = request.headers['shouldauthenticate'];
			
			console.log(shouldAuthenticate);
			if (shouldAuthenticate == 'false') {
				
				var content = router.queryObject(request.url);
				console.log(content);
				Server.render(response, content);
				
			} else if (!auth && authreq) {
				console.log('Authentication failed'.red);
			
				Server.authenticationFailed(response);
			} else if (auth && authreq) {
		 		var tmp = auth.split(' ');
		 		var buf = new Buffer(tmp[1], 'base64');
		        var plain_auth = buf.toString();
		 		var creds = plain_auth.split(':');
		        var username = creds[0];
		        var password = creds[1];
			
				if((username == 'epam') && (password == 'epam')) {
						var content = router.queryObject(request.url);
						Server.render(response, content);
         		} else {
					Server.authenticationFailed(response);
					
					console.log('Authentication failed'.red);
 				}
 			} else {
 				// invoke when authentication not required
 			}
		});
	},
	
	start: function(){
		instance.listen(1337);
	}, 
	
	render: function(response, content){
		setTimeout((function(){
			response.statusCode = 200;
    		response.end(content);
		}), 0);
	},
	
	
	authenticationFailed: function(response) {
 		response.statusCode = 401;
        response.setHeader('WWW-Authenticate', 'Basic realm="Secure Area"');
 		response.end('try with epam:epam credentials');
 		
 		return response;
	}
};

exports.init = Server.init;
exports.start = Server.start;
