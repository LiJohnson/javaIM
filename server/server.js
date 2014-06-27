
var app = require("express")();
var server = require("http").Server(app);
var io = require("socket.io")(server);

var sockets = {};

var OnPost = function(socket){
	var callbacks = {};
	this.on = function(type,callback){
		if( typeof callback != 'function' )return;

		callbacks[type] = callbacks[type] || [];
		callbacks[type].push(callback);
		return this;
	};

	this.trigger = function(type,data){
		if( !callbacks[type] )return;

		for( var i = 0 ; i < callbacks[type].length ; i++  ){
			data.data = callbacks[type][i].call(this,data.data);
			socket.emit("post",data);
		}
	};
};


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
	var post = new OnPost(socket);
	
	sockets[socket.id] = {
		socket:socket,
		name:'name'
	};

	post.on("who",function(){});
	post.on("name",function(){});

	socket.on("disconnect",function(){
		delete sockets[socket.id];
		console.log("someone's gone");
	}).on("message",function(data,s,e){
		console.log(data,s,e);
	}).on("atWho",function(){

	}).on("who",function(){

	}).on("name",function(name){

	}).on("post",function(data){
		post.trigger(data.type,data);
	});
})

server.listen(9090,function(){
	console.log("ha",server);
});








