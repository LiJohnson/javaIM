(function(){
	var cmds = [{
		name:"rename",
		title:"设置用户名",
		excu:function( $this , name){
			if(!name){
				return 0;
			}
			this.socket.post("rename",name,function(name){
				$this.printTip("new name : " + name);
				$this.setting.set("name",name);
				$this.$scope.$apply();
			});
			
			return false;
		},
		init:function(){
			this.socket.post("rename",this.setting.get("name"),function(name){});
		}
	},
	{
		name:"desktop",
		title:"desktop notify",
		desc:"on/off",
		excu:function(option){
			this.setting.desktop(option);
			return "desktop : " + (this.setting.desktop() ? "on" : "off");
		},
		init:function( $this ){
			this.socket.onNewMessage(function(message){
				$this.setting.desktop() && $this.notify.desktop(message);
			});
		}
	},
	{
		name:"sound",
		title:"sound",
		desc:"spund",
		excu:function(option){
			this.setting.sound(option);
			return "sound : " + (this.setting.sound() ? "on" : "off");
		},
		init:function( $this ){
			this.socket.onNewMessage(function(message){
				$this.setting.sound() && $this.notify.sound();
			});
		}
	},
	{
		name:"opacity",
		title:"opacity",
		desc:"opacity 30-100",
		excu:function(opacity){
			opacity = Math.floor(opacity)||100;
			opacity = opacity < 30 ? 30 : (opacity > 100 ? 100 : opacity);

			this.setting.opacity(opacity);
			$("body").css("opacity",(this.setting.opacity())/100) ;
			return "opacity : " + this.setting.opacity();
		},
		init:function(){
			$("body").css("opacity",(this.setting.opacity()||100)/100) ;
		}
	},
	{
		name:"pic",
		title:"发送图片",
		desc:"拖拽或粘贴图片到输入窗口",
		excu:function(){
			return "<input type=file class=pic />";
		},
		init:function($this){
			//$(document).on("change","input[type=file].pic",function(){
			//	$(this).getImage(function(base64){
			//		$this.$scope.message.pic = base64;
			//		$this.$scope.$apply();
			//	});
			//});

			$("textarea").getImage(function(base64){
				$this.$scope.message.pic = base64;
				$this.$scope.message.text = $this.$scope.message.text || "图片";
				$this.$scope.$apply();
			});
		}
	},
	{
		name:"music",
		title:"音乐",
		init:function(){
			$(document).on("click","a.swf",function(){
				var $swf = $(this);
				if( $swf.data("embed") )return $swf.data("embed").toggle();

				var $embed = $("<embed type='application/x-shockwave-flash'   wmode='transparent'></embed>");
				
				var href = this.hash.split("|");
				$embed.prop($.extend({src:href[0].replace(/^#/,'')} , eval("("+href[1]+")")||{}));
				$swf.parent().after($embed);
				$swf.data("embed",$embed);
			});
		}
	},
	{
		name:"fm",
		title:"音乐",
		desc:"豆瓣音乐",
		excu:(function(){
			var fmData = {};
			$.getJSON("/static/js/fm.json",function(data){
				fmData = data;
			});

			return function(chanel){
				var html = [];
				$.each(fmData,function(i,fm){
					html.push("<a href='#' class='fm' title='"+fm.cid+"' ><img src='"+fm.cover+"' />"+fm.name+"</a>");
				});
				return html.join("");
			};

		})(),
		init:function($this){
			/*
{
		"album": "\/subject\/1761913\/",
		"picture": "http:\/\/img5.douban.com\/lpic\/s1633297.jpg",
		"ssid": "b99a",
		"artist": "袁凤瑛",
		"url": "http:\/\/mr4.douban.com\/201407012108\/206d8e13498350d0fe0fc6cdc1a9b576\/view\/song\/small\/p699624.mp4",
		"company": "滚石",
		"title": "天若有情",
		"rating_avg": 4.57821,
		"length": 231,
		"subtype": "",
		"public_time": "1991",
		"songlists_count": 81,
		"sid": "699624",
		"aid": "1761913",
		"sha256": "e8c102a17786f3e74effe1aef3b37c25be83adf7034a647d2e7dec0bef08b835",
		"kbps": "64",
		"albumtitle": "皇后大道东",
		"like": 0
	}
			*/
			var $fm = $("<audio class='fm' autoplay=true  controls=true />");
			var getSong = (function(){
				var buffers = {};
				var curCid = false;
				return function(cid , cb){
					curCid = cid = cid || curCid;
					if(!cid)return;

					var buffer = buffers[cid] || [];
					var song = buffer.shift();
					$.log(buffer,song);
					if( song )return cb(song);

					$this.socket.post("fm",cid,function(data){
						if(!data.song)return;

						buffers[cid] = data.song;
						return getSong(cid,cb);
					});
				};
			})();

			var play = function(song){
				$("audio.fm").each(function(){
					this.pause();
				});
				var html = "<div><audio controls src='"+song.url+"' />";
				html += "<a href='http://music.douban.com"+song.album+"' target=_blank >"
				html += "<img src='"+song.picture+"'>";
				html += "<br> " + song.artist + " : " + song.title;
				html += "</a>"
				html += "</div>";
				$fm.appendTo('body').prop("src",song.url);
				$this.printTip(html);

			};
			$fm.on("ended error",function(){
				getSong(false,play);
			});

			$(document).on("click","a.fm",function(){
				getSong( $(this).attr("title") , play );
			});
		}
	},{
		name:"clear",
		title:"清屏",
		excu:function($this){
			$this.$scope.list = [];
			$this.cache.clear();
			return "OK";
		}
	}];
//opacity
	cmds.push({
		name:"test",
		title:"test",
		excu:function(){
			this.printTip("abs");
		}
	});

	window.cmds = cmds;
})();
