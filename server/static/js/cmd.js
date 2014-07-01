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
	},{
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
					html.push("<a><img src='"+fm.cover+"' />"+fm.name+"</a>");
				});
				return html.join("");
			};

		})(),
		init:function($this){
			
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
