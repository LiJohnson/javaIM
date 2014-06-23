var io = require("socket.io");
var http = require('http');
var app = require("express")();


var server = http.createServer(function(request,respon){
	console.log(33);
	respon.write("33");
	respon.end();
});

app.get("/*",function(req,res){
	console.log("---------------------------------------------------------------------------------------------------------");
	console.log(req.route);
	console.log(req);
	var file = __dirname +req._parsedUrl.pathname;
	console.log(file);
	res.sendfile(file);
});

app.listen(9090);

//server.listen(9090);

