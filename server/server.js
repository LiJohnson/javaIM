
var app = require("express")();
var server = require("http").Server(app);
var io = require("socket.io")(server);
var douban = require("./douban").douban();

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

var broadCast = function(type,data , socket){
	for( var i in sockets ){
		if( socket ){
			data.self =  socket.id == sockets[i].socket.id ? 'self' : 'other';
		}
		sockets[i].socket.emit(type,data);
	};
};
var getWho = function(text){
	var names = text.match(/^@[\w\d_]+\s+(@[\w\d_]+\s+)*/);
	if(!names)return false;
	
	names = names[0].replace(/@/g,'').split(/\s+/);

	var list = [];
	for( var i in sockets ){
		var s = sockets[i];
		if( names.indexOf(s.name) != -1 ){
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
	var user = sockets[socket.id] = {
		id:socket.id,
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
		return sockets[socket.id].name = name || sockets[socket.id].name || "name";
	}).on("atwho",function(){
		var data = [];
		for( var i in sockets ){
			data.push({name:sockets[i].name});
		}
		return data;
	}).on("fm",function(chaelId){
		douban.getSong(2,function(){
			
		});
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
			broadCast("message",data,socket)	
		}else if( privateSocket.length == 0 ){
			socket.emit("message",data);
			data.text = '人不在';
			socket.emit("message",data);
		}else{
			data.private = "private";
			
			socket.emit("message",data);
			
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



