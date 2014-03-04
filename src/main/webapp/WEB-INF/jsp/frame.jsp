<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="f.ico">
	<script src="http://1.gtbcode.sinaapp.com/load.php?c=1&type=js&load=jquery.js,jquery.plugin.js,jquery.atwho.js"></script>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">	
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="http://1.gtbcode.sinaapp.com/css/style.css">
	<link rel="stylesheet" href="http://1.gtbcode.sinaapp.com/css/jquery.atwho.css">
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
	<script src="//cxq.zhihuidao.com.cn/js/jquery.atwho.js"></script>
	
	<script src="/static/client.js"></script>

	<script>
	var baseUrl = "${contextPath}";

    var KEY_CODE = {
    		leftArrow:37,
    	    upArrow:38,
    	    rightArrow:39,
    	    downArrow:40,
    	    enter:13
    };
    
	$(function(){
		var $form = $("form");
		var $list = $("[list]");
		var $file = $form.find(".file");
		var $inputor = $form.find("textarea");
		
		var s = new MY.Client(baseUrl+"/send" , baseUrl+"/listen");
		var inputHistory = new MY.InputHistory("inputHistory");
		var chatCache = new MY.Cache("chatCache");
		var setting = new MY.Setting("chatSetting");
		var notify = new MY.Notify( setting );

		var helper = new MY.Helper( function(html){
			if( html == "clear" ){
				$list.empty();
			}else{
			    $list.append("<div class='alert alert-success alert-dismissable' style='font-size: 12px;' > <button type='button' class='close animate' data-dismiss='alert' aria-hidden='true' style='right:-15px;'>&times;</button>" + html + "</div>");	
			}
			/^#.+/.test($inputor.val()) && $inputor.val("");
			$(".chat-body").animate({scrollTop:$list.height()});
			return $list;
		});

		var getFileHtml = function(base64Data,name){
			var $html = $("<a></a>").prop({href:base64Data , target:'_blank'});

			if( /^data:image.+/.test(base64Data) ){
				$html.append($("<img>").prop("src",base64Data));
			}else{
				$html.append(name||"文件");
			}
			return $html;
		};

		var print = function(list,id,cache){
			chatCache.stor.set("id",id);
			list = list||[];
			$.each(list||[],function(i,message){
				!cache && chatCache.push(message);
				var self = id == message.id;
				
				if( $.isArray(message.text) && window.JSON ) message.text = JSON.stringify(message.text);

				var $t =  $("<div class='list-group-item' ><span class='badge label-info' html-name data-at='"+message.name+"' ></span><div html-text ></div></div>").setHtml(message).addClass( self ? "self":"" );

				$t.find("[html-text]").richText();
				if( message.file ){
					$t.append(getFileHtml(message.file , (message.text.match(/\$\S+/)||[""])[0].replace(/^\$/,'')));
				}
				if( message.toId ){
					$t.addClass("alert-warning");
				}

				$list.append($t);

				if( !self  && !cache ){
					hasNewMessage(message);
				}
			});
			list.length && $(".chat-body").animate({scrollTop:$list.height()});
		};

		var hasNewMessage = function (message){
			setting.desktop()  && notify.desktop(message);
			setting.sound()  && notify.sound(message);
			 setting.frame() && window.parent.postMessage( JSON.stringify(message),"*");
		};

		/**********************************************************************************/

		helper.addCmd({
			name:"help" , 
			title: "帮助" ,
			desc: "show this text" ,
			excu: function(){
				var html = [];
				for( var name in this.cmds ){
					var cmd = this.cmds[name];
					cmd.title && html.push("<a href=javascript:; data-cmd='"+cmd.name+"'>"+cmd.title+"</a> : " + cmd.desc);
				}
				return "<p>" + html.join("</p><p>") + "</p>";
			}
		});
		
		helper.addCmd({ 
			name: "emojis" ,
			title:"表情" ,
			desc: "直接输入中括号+相应的表情名;发送“<a>#emojis</a>”可以进行表情查阅",
			excu: function(category){
				var html = ["<div class=help>"];
				var data = false;
				$.each( $.getEmojis() , function(i,c){
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
		});
		
		helper.addCmd({
			name:"music",
			title:"音乐",
			desc:"发送<a href='http://www.xiami.com/' target=_blank >虾米</a>上歌曲的地址<a href='http://ww3.sinaimg.cn/large/5e22416bgw1ecj3fnf57dj20rs0emacn.png' target=_blank >示图</a>"
		});
		
		helper.addCmd({
			name:"video",
			title:"视频",
			desc:"发送<a href='http://youku.com/' target=_blank >优酷</a>上视频的地址<a href='http://ww2.sinaimg.cn/large/5e22416bgw1ecj3ebwh3rj20u10eztaf.png' target=_blank >示图</a>"
		});
		
		helper.addCmd({
			name:"pic",
			title:"图片",
			desc:"使用截图工具进行截图，然后在输入窗口粘贴；或直接将图片文件拖到输入窗口"
		});

		helper.addCmd({
			name:"file",
			title:"文件" , 
			desc:"将文件直接拖到输入窗口即可",
			excu:function(){
				return "<input type=file />";
			}
		});
		
		helper.addCmd({
			name:"clear",
			title:"清屏",
			desc:"发送“<a>#clear</a>”",
			excu:function(){
				chatCache.clear();
				return "clear";
			}
		});
		
		helper.addCmd({
			name:"priv",
			title:"私聊",
			desc:"发送信息前@一下相应的用户名(“@abs 你是女的吗？”,则只有用户abs才收到 信息)"
		});

		helper.addCmd({
			name:"inputHistory",
			title:"输入历史",
			desc:"先按下ctrl键，再使用向上[↑](下[↓])箭头键可以调出输入历史"
		});
		
		
		helper.addCmd({
			name:"opacity",
			title:"透明",
			desc:"设置窗口透明度,发送“<a>#opacity num</a>”;num可为30到100",
			excu:function(num){
				setting.opacity(num);
				$("html").css("opacity",setting.opacity()/100);
				return "已设透明度为:"+ setting.opacity();
			},
			init:function(){
				$("html").css("opacity",setting.opacity()/100);
			}
		});

		helper.addCmd({
			name:"desktop",
			excu:function(param){
				if( !param )return;
				setting.desktop(param);
				return "桌面提醒已" + ( setting.desktop() ? "启动" : "关闭" );
			},
			title:"桌面提醒",
			desc:"设置桌面通知提醒,发送<a>#desktop on</a>启动提醒，<a>#desktop off</a>关闭提醒"
		});

		helper.addCmd({
			name:"sound",
			excu:function(param){
				if(!param)return;
				setting.sound(param);
				return "声音提醒已" + ( setting.sound() ? "启动" : "关闭" );
			},
			title:"声音提醒",
			desc:"设置声音通知提醒,发送<a>#sound on</a>启动提醒，<a>#sound off</a>关闭提醒"
		});

		helper.addCmd({
			name:"frame",
			title:"frame提醒",
			desc:"设置frame信息提醒（新信息时的窗口闪烁）,发送<a>#frame on</a>启动提醒，<a>#frame off</a>关闭提醒",
			excu:function(param){
				if(!param)return;
				setting.frame(param);
				return "frame提醒已" + ( setting.frame() ? "启动" : "关闭" );
			}
		});

		helper.addCmd({
			name:"who",
			title:"在线用户",
			desc:"发送“<a>#who</a>”查看在线用户（有时延是必须的）",
			excu:function(){
				s.send("#who","#who",function(data){
					data = data && data.data || [];
					var html = [];
					for( var i = 0 , user ; user = data[i] ; i++ ){
					html.push("<a href=javascript:; data-at='"+user.name+"'>"+user.name+"</a>");
					}
					helper.printTip("<ol><li>" + html.join("</li><li>") + "</li></ol>");
				});
				return false;
			}
		});
		
		helper.addCmd({
            name:"about",
            title:"关于",
            desc:"V2.0 <br>基于 long polling & ajax 开发<br>github <a href='http://t.cn/8F1RjZQ' target=_blank  >http://t.cn/8F1RjZQ</a>",
            excu:function(){
            	return "V2.0 <br>基于 long polling & ajax 开发<br>github <a href='http://t.cn/8F1RjZQ' target=_blank  >http://t.cn/8F1RjZQ</a>";
            }
        });

		var addFile = function( file){
			var reader = new FileReader();
			reader.onload =function(e){
				$file.empty();
				$file.append($("<a href=javascript:; class='close animate'>&times;</a>"));
				$file.append(getFileHtml(e.target.result,file.name));
				$file.append($("<input type=hidden name='file' >").val(e.target.result));
				!$inputor.val() && $inputor.val("分享文件");
				$inputor.val($inputor.val() + " $" + (file.name || "未命名文件") + " ");
			};
			reader.readAsDataURL(file);
		};

		$form.submit(function(){
			if(!$form.check())return false;
			var postData = $form.getData();
			inputHistory.add(postData.text);
			!helper.excu(postData.text) && s.send(postData,function(){
				var text = $inputor.val()||"";
				$inputor.val((text.match(/^@[^\s@[]+\s?/)||[""])[0]);
				$file.empty();
			});
			return false;
		});
		
		$inputor.focus(function(){
			notify.desktop("request");
		}).keydown(function(e){
			e.ctrlKey && e.keyCode == KEY_CODE.enter && $form.submit();
		}).keyup(function(e){
			if( !e.ctrlKey )return;

			if( e.keyCode == KEY_CODE.upArrow ){ $inputor.val(inputHistory.get(1)); }
			if( e.keyCode == KEY_CODE.downArrow ){ $inputor.val(inputHistory.get(-1)); }

		}).getFile(function(data,file){
			addFile(file);
		},true);
		
		$inputor.atwho({
			at:"@",
			tpl:"<li data-value='${'${atwho-at}${name}'}' >${'${name}'}</li>",
			callbacks: {
				remote_filter:function (query, cb) {
					s.send("#who","#who",function(data){
						cb(data && data.data ||[]);
					});
				}
			},
			limit:8
		}).atwho({
		   	at:"#",
			tpl:"<li data-value='${'${atwho-at}${name}'}' title='${'${desc}'}' >${'${showName}'} <small>${'${showDesc}'}</small></li>",
			data:(function(){
				var data = [];
				$.each(helper.getCmdData(),function(i,c){
					if(!c.excu)return;
					var showName = c.name + " ";
					var desc = $("<a>" + c.desc + "</a>").text();
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
		
		$list.on("click",".help a.emoji",function(){
			$inputor.val( $inputor.val() + $(this).attr("title") );
		});

		$list.on("click","a.category",function(){
			$(this).parents(".alert").remove();
			helper.excu("#emojis " + $(this).data("category"));
		});

		$list.on("click","[data-at]",function(){
			$inputor.val( "@" + $(this).data("at") + " " );
		});

		$list.on("click","[data-cmd]",function(){
			$inputor.val( "#" + $(this).data("cmd") + " " );
		});

		$list.on("change","input[type=file]",function(){
			addFile(this.files[0]);
		});
		
		$file.on("click",".close",function(){
			$file.empty();
		});
		
		s.listen({name:"${name}"},function(data){
			print(data.list,data.id);
			$("[data-online]").html(data.online);
		});
		
		print(chatCache.get(),chatCache.stor.get("id"),true);
	});
	</script>
	<style>
		.chat{position: relative;}
		.chat img{max-width: 50px;max-height: 50px;}
		.chat-body , .chat-head , .chat-foot{position: fixed;left: 0;right: 0;border: 0px solid red;}
		.chat-head{top:0;height:20px;}
		.chat-body{top:20px;bottom: 50px;overflow-y: scroll;overflow-x: hidden;}
		.chat-foot{height: 50px;bottom: 0;}
		.chat-body{overflow-y:overflow-y: scroll;}
		.chat-foot textarea,.chat-foot input{height:50px;margin: 0;padding:0;display: inline-block;}
		.chat-foot textarea{width: 93%;}
		.chat-foot input{width: 5%;}
		.chat-foot .file{position: absolute;left: 0;bottom: 50px;}
		.self{text-align: right;}
		.at{background-color:#f2dede;}
		.self .badge{background-color: #5bc0de;float: left;}
		[list] .badge{cursor: pointer;}
		.chat-body img.emojis{zoom:0.8;}
	</style>
</head>
<body>
<div class="chat" >
	<div class="chat-head">
		<div class="row">
			<div class="col-md-12" >
				<span class="label label-default" style="float:left;" >${name }</span>
				<span class="label label-danger col-md-offset-1" style="float:left;"  ><span data-online >0</span></span>
			</div>
		</div>
	</div>
	<div class="chat-body">
		<div class="row chat-list" >
		   <div class="col-md-12">
				<div class="list-group" list>
				</div>
			</div>
		</div>
	</div>
	<div class="chat-foot">
		<form>
		   <div class="file"></div>
		   <textarea check-len="1" name="text" class="form-control" resize="false" placeholder="发送 “#help”查看帮助" ></textarea>
		   <input type="hidden" value="${name }" name="name" />
		   <input type="hidden" value="${head }" name="head" />
		   <input type="submit" value=" " class="btn btn-default btn-warning" />
		</form>
		</div>
	</div>
</div>
</body>
</html>
