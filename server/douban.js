var http = require("http");

var URL = "http://douban.fm/j/mine/playlist?type=n&sid=&pt=0.0&from=mainsite&r=e27e73af0c&channel=";
var DouBan = function() {
	this.getSong = function(chanelID, cb) {
		
		var res = http.get(URL+chanelID , function(respon){
			console.log(respon);
			respon = JSON.parse(respon);
			console.log(respon);
		});
		console.log(res);
	};
}
exports.douban = function(){
	return new DouBan();
}