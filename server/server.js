
var app = require("express")();
var server = require("http").Server(app);
var io = require("socket.io")(server);

var sockets = {};

app.get("/",function(req,res){	
	var file = __dirname +req._parsedUrl.pathname;
	res.sendfile(file);
	
	console.log("---------------------------------------------------------------------------------------------------------");
	console.log(file);
});

app.get("/static/*",function(req,res){	
	var file = __dirname +req._parsedUrl.pathname;
	res.sendfile(file);
});

io.on("connection",function(socket){
	console.log("someone comes");
	
	sockets[socket.id] = {
		socket:socket,
		name:'name'
	};

	var res = function(name,cb){
		socket.on(name,function(data){
			data = cb.call(this,data,function(data){
				data && socket.emit(name,data);
			});
			data && socket.emit(name,data);
		});
	};

	socket.on("disconnect",function(){
		delete sockets[socket.id];
		console.log("someone's gone");
	}).on("message",function(data,s,e){
		console.log(data,s,e);
	}).on("atWho",function(){

	}).on("who",function(){

	}).on("name",function(name){

	});

	res("ha",function(data,cb){
		console.log(data);
		cb.call(this,"shit")
		return "haha";
	})
})

server.listen(9090,function(){
	console.log("ha",server);
});








