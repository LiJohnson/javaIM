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
	}];

	cmds.push({
		name:"test",
		title:"test",
		excu:function(){
			this.printTip("abs");
		}
	});

	window.cmds = cmds;
})();
