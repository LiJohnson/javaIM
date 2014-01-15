window.SClient = (function(){
	var S = function( send , listen ){
		/**
		 * internal post 
		 */
		var post = function(url , data , callback){
			return $.post( url , data , callback , "json" );
		};
		
		var $this = this;
		
		this.urls = {};
		/**
		 * set send message url
		 * @param String url 
		 */
		this.setSendUrl = function(url){
			this.urls.send = url;
		};
		/**
		 * set listen message url
		 * @param String url 
		 */
		this.setListenUrl = function(url){
			this.urls.listen = url;
		};
		
		/**
		 * send message
		 * @param  String   name     
		 * @param  String   text     
		 * @param  Function callback 
		 */
		this.send = function(name , text , callback){
			var postData = {};
			if( typeof name == "object" ){ 
				postData = name ; 
				callback = text; 
			}else{
				postData.name = name;
				postData.text = text;
			}
			return text && post( this.urls.send , postData , callback );
		};
		
		/**
		 * listen message
		 * @param  Object   postData 
		 * @param  Function callback 
		 */
		this.listen = function(postData , callback){
			if( typeof postData == "function" ){
				callback = postData;
				postData = {};
			}
			
			return post(this.urls.listen , postData , function(data){
				$this.listen(postData,callback);
				callback && callback.call($this,data);
			}).fail(function(){
				setTimeout(function(){
					$this.listen(postData,callback);
				},3000);
				
			});
		};
		
		send && this.setSendUrl(send);
		listen && this.setListenUrl(listen);

	};
	return S;
})();