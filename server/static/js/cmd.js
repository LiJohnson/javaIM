(function(){
	var cmds = [{
		name:"rename",
		title:"设置用户名",
		excu:function(name){
			var $this = this;
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
		init:function(){
			var $this = this;
			this.socket.onNewMessage(function(message){
				$.log($this.setting.desktop());
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
		init:function(){
			var $this = this;
			this.socket.onNewMessage(function(message){
				$.log($this.setting.sound());
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
