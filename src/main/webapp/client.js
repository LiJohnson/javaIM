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


//jquery-plugin
(function($){

	$.fn.getFile = function(cb , base64){
		cb = $.isFunction(cb) ? cb : function(){};

		var $this = this;
		var readFile = function(file){
			if( base64 && window.FileReader){
				var reader = new FileReader();
				reader.onload =function(e){
					cb.call($this,reader.result,file);
				};
				reader.readAsDataURL(file);
			}
			else{
				 cb.call($this,file);
			}
		};
		
		//paste
		$this.on("paste",function(e){
			var clipboardData = e.originalEvent.clipboardData || {};			
			var item = (function( items ){ 
				if( !items || !items.length )return false;
				
				for( var i = 0 ; i < items.length ; i++ ){					
					if(items[i].type.indexOf("image") != -1){
						return items[i];
					} 
				}
				return false;
				})(clipboardData.items);
			
            if( item ){
            	readFile(item.getAsFile());
            }else{
            	return e;
            }
		});
		
		//drag file
		$this.on("dragenter",function(e){
			$this.addClass("drag");
		}).on("dragleave",function(e){
			$this.removeClass("drag");
		}).on("drop",function(e){
			$this.removeClass("drag");
			var file = e.originalEvent.dataTransfer && e.originalEvent.dataTransfer.files && e.originalEvent.dataTransfer.files[0];
			if( file ){
				readFile(file);
			};
			e.preventDefault();
		});
		return $this;
	};
})(window.jQuery);