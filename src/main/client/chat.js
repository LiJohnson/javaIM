(function(){
	var Chat = function( url , name ){
		if( !window.jQuery )throw("need jQuery supported");

		this.style = "<style type='text/css'>    #webim {position: fixed;right: 0;bottom: 0;width:0px;height: 0px;z-index:99999;}    #webim a{text-decoration:none;}    #webim form{display: initial;}    #webim .box{position: absolute;right: 0;bottom: 0;width: 300px;height: 500px;}    #webim .box{border: 1px solid #bebebe;background: #fff;-moz-box-shadow: -1px 1px 1px rgba(0,0,0,.2);-webkit-box-shadow: 0 2px 4px rgba(0,0,0,.2);box-shadow: 0 2px 4px rgba(0,0,0,.2);}    #webim .box .form,.title,.messageList{width: 100%;}    #webim .box .title{height: 5%;}    #webim .box .title .mini{ font-size: 30px;float: right;line-height: 10px; color: gray;}    #webim .box .messageList{height: 65%;}    #webim .box .form{height: 30%;}    #webim .miniBox{position: absolute;right: 0;bottom: 0;width: 30px;height: 20px;background-color: blue;}    #webim .miniBox{border-radius: 30px/20px;border: 1px solid #8B8B8B;background: #fff;-moz-box-shadow: -1px 1px 1px rgba(0,0,0,.2);-webkit-box-shadow: 0 2px 4px rgba(0,0,0,.2);box-shadow: 0 2px 4px rgba(0,0,0,.2);cursor: pointer;}    #webim .miniBox .line{width: 50%;border: 1px solid gray;margin: 3px auto;}    #webim li {list-style: none;margin: 0;}    #webim li img {cursor: pointer;max-width: 30px;max-height: 30px;}    #webim p {margin: 0;}    #webim ul {height: 100%;margin: 0;  padding-left: 5px;overflow-y: overlay;}    #webim textarea {height: 80%;width: 100%;}    #webim input[type='submit'] {float: right;}    #webim [html-name]{color: gray;}    #webim .box .title .mini,#webim .miniBox,#webim .reload{opacity: 0.5;} #webim .box .title .mini:hover,#webim .miniBox:hover,#webim .reload:hover{opacity: 0.9;}     #webim .reload {margin: 2px;  border-radius: 10px;  display: inline-block;  width: 10px;  height: 10px;  border: 3px solid gray;border-bottom-color: rgba(128, 128, 128, 0.38);border-top-color: rgba(128, 128, 128, 0.38);}     #webim .reload:hover {-webkit-transform: rotate(180deg);transform: rotate(180deg);}   </style>";
		this.html = "<div id='webim'>    <div class='box'>     <div class='title'>      <a href='javascript:;' class='reload animate' title='repload'></a>      <a href='javascript:;' class='mini'>-</a>     </div>     <div class='messageList'>      <ul list=''>       </ul>     </div>     <div class='form'>      <form>       <textarea name='text' check-len='1'></textarea>       <input type='submit' value='send'>      </form>     </div>    </div>    <div class='miniBox'>     <div class='line' style='margin-top: 5px;'></div>     <div class='line'></div>     <div class='line'></div>    </div>   </div>";
		this.url = url;
		this.name = name;

		var post = function(type,data,cb){
			return $.getJSON( url + type + "?callback=?",data,cb );
		};
		
		var listenAjax = window.aa = {};
		
		var listen = function(){
			listenAjax = $.ajax({
				type: 'GET',
				url: url + "listen" + "?callback=?",
				success: function(list){
					$.each(list || [] ,function(i,data){
						data.time = $.formatDate && $.formatDate(data.time,"h:M:s") || data.time;
						if( typeof data.text == 'object' )data.text = JSON ?JSON.stringify(data.text) : data.text.toString();
						data.text = (data.text || "").replace(/<\/?script[^>]*>/gi, "").replace(/<\/?iframe[^>]*>/gi, "").replace(/<\/?link[^>]*>/gi, "");
						var $li = $("<li><p><span html-name></span> <span html-time></span></p><p html-text></p></li>").setHtml(data);
						$li.richText && $li.find("[html-text]").richText();
						$list.append($li);
					});
					$list.animate({scrollTop:$list.prop("scrollHeight")});
				},
				dataType:'json',
				complete:function(){listen();}
			});
		};
		var setting = function(k,v){
			if( v == undefined )return (window.localStorage||{})[k];
			(window.localStorage||{})[k] = v;
			
		};
		var $html = (function(style,html){ html = $(html);$("body").append(style).append(html); return html;})(this.style,this.html);		
		var $form = $html.find("form");
		var $postForm = $("<form ><input name=name /><textarea name=text></textarea></form>").hide().prop({method:"post",action:url+"send?"+$.param({name:name}),target:"iframWebim"}).add($("<iframe />").hide().prop({name:"iframWebim"})).appendTo($html);
		var $list = $html.find("[list]");
		var $box = $html.find(".box");
		var $miniBox = $html.find(".miniBox");
		var show = function(){
			$box.show().css("opacity",0.5);
			$miniBox.hide();
			$box.animate({zoom:1,opacity:1});
			setting("webim","show");
		};
		var hide = function(){
			$box.animate({zoom:0.01,opacity:0.2},function(){
				$box.hide();
				$miniBox.show();
			});
			setting("webim","hide");
		};
		$form.submit(function(){
			$form.check() && post('send',$.extend({name:name},$form.getData()),function(data){
				$form.find("textarea").val("");
			});
			return false;
		});
		$box.find(".reload").click(function(){
			listenAjax && listenAjax.abort();
			listen();
		});
		$form.find("textarea").keydown(function(e){
			e.ctrlKey && e.keyCode == 13 && $form.submit();
		});
		$form.getImage(function(data){
			$postForm.setData({text:"<img src='"+data+"' />"}).submit();
		});
		$html.find(".mini").click(hide);
		$miniBox.click(show);
		
		$box.on("click","img",function(){
			window.open(this.src,"_blank");
		});
		
		setting("webim") == "show" ? show() : $box.hide() && hide();
		setTimeout(listen,1000);
	};
	window.Chat = Chat;
})();