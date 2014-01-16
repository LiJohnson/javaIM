<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
//request.setCharacterEncoding("utf-8");
String name = request.getParameter("name");
String head = request.getParameter("head");
String frontPath = request.getContextPath();

name = name == null ? request.getSession().getId() : name ;//new String( name.getBytes("gbk") , "utf-8" );
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="f.ico">
	<script src="http://1.gtbcode.sinaapp.com/load.php?c=1&type=js&load=jquery.js,jquery.plugin.js"></script>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">	
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="//cxq.zhihuidao.com.cn/style/style.css">
	<link rel="stylesheet" href="//cxq.zhihuidao.com.cn/html/style/jquery.atwho.css">
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
	<script src="//cxq.zhihuidao.com.cn/js/wp.js"></script>
	<script src="//cxq.zhihuidao.com.cn/js/jquery.atwho.js"></script>
	<script src1="http://192.168.1.59:8080/js/wp.js"></script>
	
	<script src="client.js"></script>

	<script>
	var baseUrl = "<%=frontPath %>";
	
	//缓存
	var ChatCache = (function(){
		var s = window.sessionStorage || {};
		var list = eval("("+s.list+")")||[];
		return {
			put:function(message){
				list.push(message);
				s.list = JSON.stringify(list);
		},get:function(k){
			return k && s[k] ? s[k]:list;
		},set:function(k,v){
			s[k]=v;
		},
		clear:function(){
			list = [];
			s.list = JSON.stringify(list);
		}
		};
	})();
	
	//chat 设置
	var ChatSetting = function(){
		var l = window.localStorage || {};
        var setting = eval("("+l.ChatSetting+")")||{};
        
        this.get = function(k){return setting[k];};
        this.set = function(k,v){ setting[k] = v;l.ChatSetting = JSON.stringify(setting); };
        
        this.tip = function(value){
        	if( !arguments.length ){
        		return this.get("tip") != "off";
        	}
        	this.set("tip",value);
        };
        this.opacity = function(value){
        	if( !arguments.length ){
                return this.get("opacity");
            }
        	this.set("opacity",value*1 || 100)
        };
	};
	
	//桌面通知
	var notify = (function(){
		var notifications = window.notifications || window.webkitNotifications;
		var sound = ["tutor_urgency_02.ogg","tutor_urgency_05.ogg","tutor_urgency_04.ogg"];
		var i = 0;
		var replaceId = 0;
		return function(message,title,pic){
			if(message == "request")return notifications.requestPermission(function(){});
			if( notifications.checkPermission() != 0 )return ;

			var notice = notifications.createNotification(pic||"http://ww2.sinaimg.cn/large/5e22416bgw1ecitfrifssj201200v3y9.png",title||"通知",message);
			notice.replaceId = "replaceId_" +  replaceId;
			notice.show();
			$.WP.play(sound[i]);
			i = (i+1) % sound.length;
			replaceId = (replaceId+1)%3;
			setTimeout(function(){notice.cancel();},5000);
		};
	})();
	
	//帮助
	var Helper = function( client , printTip ){
		var cmds = {};
		var _this = this;
		this.setting = new ChatSetting();
		this.cache = ChatCache;
		this.help = function(){};
		this.addCmd = function( cmd , excu, title , description ){
			if( !cmd || !excu)return;
			$.log(cmd);
			if( cmds[cmd] )throw("cmd: "+cmd+" existed!");
			
			cmds[cmd] = {title:title,desc:description,excu:excu};
		};
		
		this.excu = function(text){
			text = text || "";
            if(!text.match(/^#/))return false;
            var param = text.replace(/^#/,'').split(" ");
            var cmd = cmds[param.shift()];
            if( !cmd )return false;
            
            var res = cmd.excu.apply( this , param );

            res != false && printTip(res||cmd.desc);
            return true;
		};
		
		this.getCmdData = function(){
			var data = [];
			for( var name in cmds ){
                var cmd = cmds[name];
                cmd.name = name;
                data.push(cmd);
            }
			return data;
		};
		
		this.addCmd( "help" ,  function(){
			var html = [];
			for( var name in cmds ){
				var cmd = cmds[name];
				cmd.title && html.push("<a>"+cmd.title+"</a> : " + cmd.desc);
			}
			return "<p>" + html.join("</p><p>") + "</p>";
		}, "帮助" , "show this text" );
		
		this.addCmd( "emojis" , function(){
		    var html = ["<div class=help>"];
		    $.each( $.WP.getEmojis() , function(i,e){
		    	  html.push("<a href=javascript:; class=emoji title='["+e.text+"]'><img src='"+$.WP.resUrl+"/emoji/"+e.name+"'></a>");
		    });
		    html.push("</div>");
		    return html.join("\n");
	    },"表情" , "直接输入中括号+相应的表情名;发送“<a>#emojis</a>”可以进行表情查阅" );
		
		this.addCmd("music",function(){},"音乐","发送<a href='http://www.xiami.com/' target=_blank >虾米</a>上歌曲的地址<a href='http://ww3.sinaimg.cn/large/5e22416bgw1ecj3fnf57dj20rs0emacn.png' target=_blank >示图</a>");
		
		this.addCmd("video",function(){},"视频","发送<a href='http://youku.com/' target=_blank >优酷</a>上视频的地址<a href='http://ww2.sinaimg.cn/large/5e22416bgw1ecj3ebwh3rj20u10eztaf.png' target=_blank >示图</a>");
		
		this.addCmd("pic",function(){},"图片" , "使用截图工具进行截图，然后在输入窗口粘贴；或直接将图片文件拖到输入窗口");
		
		this.addCmd("clear",function(){
			printTip("clear");
			this.cache.clear();
			return false;
		},"清屏","发送“<a>#clear</a>”");
		
		this.addCmd("priv",function(){},"私聊","发送信息前@一下相应的用户名(“@abs 你是女的吗？”,则只有用户abs才收到 信息)");
		
		this.addCmd("opacity",function( num ){
			this.setting.opacity(num);
			$("body").css("opacity",this.setting.opacity()/100);
		},"透明","设置窗口透明度,发送“<a>#opacity num</a>”;num可为0到100");
		
		this.addCmd("history",function(){},"输入历史","使用向上[↑](下[↓])箭头键可心调出输入历史");
		
		this.addCmd("who",function(args){
            client.send("#who","#who",function(data){
                data = data || [];
                var html = [];
                for( var i = 0 , user ; user = data[i] ; i++ ){
                    html.push("<a href=javascript:; data-at='"+user.name+"'>"+user.name+"</a>");
                }
                printTip("<ol><li>" + html.join("</li><li>") + "</li></ol>");
            });
            return false;
		},"当前用户","发送“<a>#who</a>”查看在线用户（有时延是必须的）");
		
		this.addCmd("on",function(){
			this.setting.tip("on");
			return "已启动桌面通知";
		},"","");
		
		this.addCmd("off",function(){
			this.setting.tip("off");
			return "已关闭桌面通知";
		},"","");
		
		this.addCmd("tip",function(){},"提示开关","发送“<a>#on</a>”开启提示，发送“<a>#off</a>”关闭提示");
		
        $("body").css("opacity",(this.setting.opacity()||100)/100);
	};
	
	//输入历史
	var InputHistory = function(){
        var inputs = eval("("+ChatCache.set("input")+")")||[];;
        var index = -1;
        this.add = function( text ){
        	if( text == inputs[0] )return;
        	inputs.unshift(text);
            index = -1;
            if( inputs.length > 20 )inputs.pop();
            ChatCache.set("input",JSON.stringify(inputs));
        };
        this.get = function(i){
        	index = index +( i*1 || 1);
        	index = index >= inputs.length ? inputs.length -1 : index ;
        	index = index < 0 ? 0 : index ;
        	return inputs[index];
        };
    };
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
		var $image = $form.find(".image");
		var $inputor = $form.find("textarea");
		
		var s = new SClient(baseUrl+"/sendV2" , baseUrl+"/listenV2");
		var inputHistory = new InputHistory();
		
		var helper = new Helper( s ,function(html){
			if( html == "clear" ){
				$list.empty();
			}else{
			    $list.append("<div class='alert alert-success alert-dismissable' style='font-size: 12px;' > <button type='button' class='close animate' data-dismiss='alert' aria-hidden='true' style='right:-15px;'>&times;</button>" + html + "</div>");	
			}
            $(".chat-foot textarea").val("");
            $(".chat-body").animate({scrollTop:$list.height()});
            return $list;
        });
		
		var print = function(list,id,cache){
			ChatCache.set("id",id);
			list = list||[];
			$.each(list||[],function(i,message){
				!cache && ChatCache.put(message);
				var self = id == message.id;
				message.name = message.name.split("#");
				message.head =message.name[1];
				message.name =message.name[0];
				
				if( $.isArray(message.text) && window.JSON ) message.text = JSON.stringify(message.text);
				var $t =  $("<div class='list-group-item' ><span class='badge label-info' html-name data-at='"+message.name+"' ></span><div html-text ></div></div>").setHtml(message).addClass( self ? "self":"" );
				$t.find("[html-text]").richText();
				if( message.pic ){
					$t.append($("<a>").prop({href:message.pic,target:"_blank"}).append($("<img>").prop("src",message.pic)));
				}
				if( message.toId ){
					$t.addClass("at");
				}
				$list.append($t);
				!self  && !cache && helper.setting.tip()&& notify(message.text,message.name+":",message.head);
			});
			list.length && $(".chat-body").animate({scrollTop:$list.height()});
		};
		
		$form.submit(function(){
			if(!$form.check())return false;
			var postData = $form.getData();
			inputHistory.add(postData.text);
			!helper.excu(postData.text) && s.send(postData,function(){
				var text = $inputor.val()||"";
				$inputor.val((text.match(/^@[^\s@[]+\s?/)||[""])[0]);
				$image.empty();
			});
			return false;
		});
		
		$inputor.focus(function(){
			notify("request");
		}).keydown(function(e){
			e.ctrlKey && e.keyCode == KEY_CODE.enter && $form.submit();
		}).keyup(function(e){
			if( e.keyCode == KEY_CODE.upArrow )$inputor.val(inputHistory.get(1));
			if( e.keyCode == KEY_CODE.downArrow )$inputor.val(inputHistory.get(-1));
			notify("request");
		}).getImage(function(data,file){
			$image.empty();
			$image.append($("<a href=javascript:; class='close animate'>&times;</a>"));
			$image.append($("<img>").prop("src" , data));
			$image.append($("<input type=hidden name='pic' >").val(data));
			!$form.find("textarea").val() && $form.find("textarea").val("分享图片");
		});
		
		$inputor.atwho({
            at:"@",
            tpl:"<li data-value='${atwho-at}${name}' >${name}</li>",
            callbacks: {
                remote_filter:function (query, cb) {
                	s.send("#who","#who",function(data){
                		cb(data||[]);
                	});
                }/*,
                matcher: function(flag, subtext) {
                    return matched;
                }*/
            }
        }).atwho({
        	at:"#",
        	tpl:"<li data-value='${atwho-at}${name}' title='${desc}' >${showName} <small>${showDesc}</small></li>",
        	data:(function(){
        		var data = [];
        		$.each(helper.getCmdData(),function(i,c){
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
        		$.log(data);
        		return data;
        	})(),
        	limit:8
        });
		
		$list.on("click",".help a.emoji",function(){
			$inputor.val( $inputor.val() + $(this).attr("title") );
        });
		$list.on("click","[data-at]",function(){
            $inputor.val( "@" + $(this).data("at") + " " );
        });
		
		$image.on("click",".close",function(){
			$image.empty();
		});
		
		s.listen({name:"<%=name %>"},function(data){
			print(data.list,data.id);
			$("[data-online]").html(data.online);
		});
		
		print(ChatCache.get(),ChatCache.get("id"),true);
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
		.chat-foot .image{position: absolute;left: 0;bottom: 50px;}
		.self{text-align: right;}
		.at{background-color:#f2dede;}
		.self .badge{background-color: #5bc0de;float: left;}
		[list] .badge{cursor: pointer;}
	</style>
</head>
<body>
<div class="chat" >
	<div class="chat-head">
		<div class="row">
		<div class="col-md-12" >
		  <span class="label label-default" style="float:left;" ><%=name %></span>
		  <span class="label label-danger col-md-offset-1" style="float:left;"  ><span data-online ></span>&nbsp;<span class="glyphicon glyphicon-comment" style="font-size: 9px;"></span></span>
		  <span style="float:right;" ></span>
		  </div>
		</div>
	</div>
	<div class="chat-body">
		<div class="row chat-list " >
		   <div class="col-md-12">
				<div class="list-group" list>
				</div>
			</div>
		</div>
	</div>
	<div class="chat-foot">
		<form>
		   <div class="image"></div>
		   <textarea check-len="1" name="text" class="form-control" resize="false" placeholder="发送 “#help”查看帮助(有新功能更新 14.1.15)" ></textarea>
		   <input type="hidden" value="<%=name %>#<%=head %>" name="name" />
		   <input type="submit" value=" " class="btn btn-default btn-warning" />
		</form>
		</div>
	</div>
</div>
</body>
</html>
