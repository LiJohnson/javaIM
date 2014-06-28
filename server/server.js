
var app = require("express")();
var server = require("http").Server(app);
var io = require("socket.io")(server);

var sockets = {};
var online = 0;
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
//ad 
var broadCast = function(type,data){
	for( var i in sockets ){
		sockets[i].socket.emit(type,data);
	};
};
var getWho = function(text){
	var name = (text.match(/^@\S+/)||[false])[0];
	if(!name)return false;

	var list = [];
	for( var i in sockets ){
		var s = sockets[i];
		if( s.name == name){
			list.push(s.socket);
		}
	}
	return list;
};

app.get("/",function(req,res){	
	var file = __dirname +req._parsedUrl.pathname;
	res.sendfile(file);
	
	console.log("-----------------------");
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
	online++;

	broadCast("online",online);
	
	post.on("who",function(){
		var data = [];
		for( var i in sockets ){
			data.push(sockets[i].name);
		}
		return data;

	}).on("rename",function(name){
		return sockets[socket.id].name = name || "name";
	}).on("atwho",function(){
		var data = [];
		for( var i in sockets ){
			data.push({name:sockets[i].name});
		}
		return data;
	});

	socket.on("disconnect",function(){
		delete sockets[socket.id];
		online--;
		broadCast("online",online);
		console.log("someone's gone");
	}).on("message",function(data,s,e){
		data.name = sockets[socket.id].name;
		var privateSocket = getWho(data.text);
		if( !privateSocket ){
			broadCast("message",data)	
		}else if( privateSocket.length == 0 ){
			socket.emit("message",data);
			data.text = '人不在';
			socket.emit("message",data);
		}else{
			for( var i = 0 , s ; s = privateSocket[i] ; i++){
				s.emit("message",data);
			}
		}
	}).on("post",function(data){
		post.trigger(data.type,data);
	});
})

server.listen(9090,function(){
	console.log("ha",9090);
});