(function(){
	'use strict';
	Array.prototype.remove = function(index){
		index = Math.floor(index * 1);
		if( index >= 0 && index < this.length){
			for( var i = index ; i < this.length -1;i++ ){
				this[i] = this[i+1]; 
			}
			this.pop();
		}
		return this;
	};
	var KEY_CODE = {
			leftArrow:37,
			upArrow:38,
			rightArrow:39,
			downArrow:40,
			enter:13
	};

	var app = angular.module("app",['ngSanitize']);
	app.controller('imController',  function($scope,$sce,$timeout){

		var socket = new MY.SocketClient();
		var helper = new MY.Helper();
		var setting = new MY.Setting();
		var cache = new MY.Cache();
		var notify = new MY.Notify();
		var inputs = new MY.InputHistory();
		var $form = $("form");

		$scope.list = [];
		$scope.message = $scope.message || {};	
		cache.get().forEach(function(a){delete a.$$hashKey ; $scope.list.push(a)});
		var toScroll = function(){
			$timeout(function(){
				$(".chat-body").animate({scrollTop:99999});
			},3);
		};
		helper.printTip = function(text){
			$scope.list.push({tip:text});
			toScroll();
		};

		helper.setting = setting;
		helper.$scope = $scope;
		helper.socket = socket;


		helper.addCmd({
			name:"help",
			title:"帮助",
			desc:"帮助",
			excu:function(){
				var html = ["<ol class='helper' >"];
				$.each(this.getCmdData(),function(i,cmd){
					html.push("<li><a href='#'class='cmd' title='#"+cmd.name+" '>"+cmd.name+"</a>"+(cmd.desc||cmd.title)+"</li>")
				});
				html.push("</ol>");
				return html.join("");
			}
		}).addCmd({
			name: "emojis" ,
			title:"表情" ,
			desc: "直接输入中括号+相应的表情名;发送“<a>#emojis</a>”可以进行表情查阅",
			excu: function(category){
				var html = ["<div class=help>"];
				var data = false;
				$.each( $.getEmojis() , function(i,c){//'"++"'
					html.push("<a href=javascript:; class='btn btn-default btn-xs category' title='"+c.category+"' data-category='"+c.category+"' >"+c.category+"</a>");
					data = data || (c.category == category ? c.data : false);
				});
				html.push("<br>");
				data = data || $.getEmojis()[0].data;

				$.each(data,function(i,e){
					html.push("<a href=javascript:; class=emoji title='"+e.phrase+"'><img src='"+e.url+"'></a>");
				});

				html.push("</div>");
				return html.join("\n");
			}
		}).addCmd({
			name:"who",
			title:"在线用户",
			desc:"查看且有在线在用户",
			excu:function(){
				var $this = this;
				socket.post("who",function(data){
					$this.printTip(data.join("<br>"));
					$scope.$apply();
				});
				return false;
			}
		});
		
		$.each(window.cmds||[],function(){
			helper.addCmd(this);
		});

		$form.find("textarea").atwho({
			at:"@",
			tpl:"<li data-value='${'${atwho-at}${name}'}' >${'${name}'}</li>",
			callbacks: {
				remote_filter:function (query, cb) {
					socket.post("atwho",function(data){
						cb(data);
					});
				}
			},
			limit:8
		}).atwho({
			at:"#",
			tpl:"<li data-value='${atwho-at}${name}' title='{desc}' >${showName} <small>${showDesc}</small></li>",
			data:(function(){
				var data = [];
				$.each(helper.getCmdData(),function(i,c){
					if(!c.excu)return;
					var showName = c.name + " ";
					var desc = $("<a>" + (c.desc||c.title) + "</a>").text();
					var showDesc = desc;
					
					for( var i = showName.length ; i < 10 ;i++){
						showName +="-";
					}
					showName += " ";
					
					if( desc.length > 20  ){
						showDesc = desc.substr(0,20) + "...";
					}
					
					data.push({name:c.name,showName:showName,showDesc:showDesc,desc:desc});
				});

				return data;
			})(),
			limit:8
		}).atwho({
			at:"[",
			tpl:"<li data-value='${'${name}'}' title='${'${desc}'}' >${'${name}'}<img src='${'${url}'}' style='zoom:0.8;float:right'></li>",
			data:(function(){
				var data = [];
				$.each( $.getEmojis() , function(i,c){
					$.each(c.data,function(i,e){
						data.push($.extend({name:e.phrase},e));
					});
				});
				return data;
			})(),
			limit:10,
			start_with_space: false
		});

		socket.on("online",function(online){
			$scope.online = online;
			$scope.$apply();
		});

		socket.on("message",function(message){
			message.text = $.richText(message.text);
			$scope.list.push(message);
			cache.push(message);
			//$scope.$apply();
			toScroll();
		});

		$scope.selectCate = function(cate){
			helper.excu("#emojis " + cate);
		};
		$(document).on("click",'.btn.category',function(){
			helper.excu("#emojis " + $(this).attr('title'));
			$scope.$apply();
		}).on("click","a.emoji",function(){
			$scope.message.text = ($scope.message.text || "") + $(this).attr("title");
			$scope.$apply();
		}).on("click","a.cmd",function(){
			$scope.message.text = $(this).attr("title") + ($scope.message.text||"");
			$scope.$apply();
		});

		$scope.submit = function(){
			if( !$scope.message.text )return false;

			inputs.add($scope.message.text);
			!helper.excu($scope.message.text) && socket.send($scope.message);
			
			$scope.message = {};
		};

		$scope.keyup = function(e){
			if(!e.ctrlKey)return e;

			switch( e.keyCode ){
				case KEY_CODE.upArrow:
					$scope.message.text = inputs.get(1);
				break;
				case KEY_CODE.downArrow:
					$scope.message.text = inputs.get(-1);
				break;
				case KEY_CODE.enter:
					$scope.submit();
				break;
			}
		};

		$scope.remove = function(index){
			$scope.list.remove(index);
		};
		toScroll();
		$scope.abs="<b>a</b>";
		window.a=$scope;
	});
})();