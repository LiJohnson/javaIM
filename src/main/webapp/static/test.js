(function(){
	var s = window.s = new WebSocket("ws://lcs.com:9090/chat");
	s.onopen = function(){
		$.log("open");
		s.send("send message");
	};
	s.onclose = function(){
		$.log("closed");
	};
	
})();