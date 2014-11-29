var nodegrass = require("nodegrass");

var URL = "http://douban.fm/j/mine/playlist?type=n&sid=&pt=0.0&from=mainsite&r=e27e73af0c&channel=";
var DouBan = function() {
	this.getSong = function(chanelID, cb) {
		
		return nodegrass.get(URL+chanelID , function(data){
			try{
				cb( JSON.parse(data) );
			}catch(e){
				cb({error:true});
			}
		});
	};
}
exports.douban = function(){
	return new DouBan();
}
/*
test
var a=(function(){
	var d = new DouBan();
	d.getSong(4,function(data){
		console.log(JSON.parse(data));
	});
});
a();
*/
