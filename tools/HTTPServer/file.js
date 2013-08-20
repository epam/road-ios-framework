var fs = require('fs');

var File = {
	read: function(fileName){
		return  fs.readFileSync(fileName, 'utf8');
	}
};

exports.read = File.read;
