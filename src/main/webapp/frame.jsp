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
	//桌面通知
	var notify = window.nn = (function(){
		var notifications = window.notifications || window.webkitNotifications;
		var sound = ["tutor_urgency_02.ogg","tutor_urgency_05.ogg","tutor_urgency_04.ogg"];
		var i = 0;
		return function(message,title,pic){
			if( !CMD.getTip() )return;
			if( notifications.checkPermission() != 0 )return notifications.requestPermission(function(){});

			var notice = notifications.createNotification(pic||"http://ww2.sinaimg.cn/large/5e22416bgw1ecitfrifssj201200v3y9.png",title||"通知",message);
			notice.show();
			$.WP.play(sound[i]);
			i = (i+1) % sound.length;
			setTimeout(function(){notice.cancel();},3000);
		};
	})();
	
	//命令
	var CMD = {
		help:function(){
			var html = ["<p>"];
			html.push("<a>表情</a>:直接输入中括号+相应的表情名;发送“<a>#emojis</a>”可以进行表情查阅");
			html.push("<a>音乐</a>:发送<a href='http://www.xiami.com/' target=_blank >虾米</a>上歌曲的地址<a href='http://ww3.sinaimg.cn/large/5e22416bgw1ecj3fnf57dj20rs0emacn.png' target=_blank >示图</a>");
			html.push("<a>视频</a>:发送<a href='http://youku.com/' target=_blank >优酷</a>上视频的地址<a href='http://ww2.sinaimg.cn/large/5e22416bgw1ecj3ebwh3rj20u10eztaf.png' target=_blank >示图</a>");
			html.push("<a>图片</a>:使用截图工具进行截图，然后在输入窗口粘贴；或直接将图片文件拖到输入窗口");
			html.push("<a>清屏</a>:发送“<a>#clear</a>”");
			html.push("<a>私聊</a>:发送信息前@一下相应的用户名(“@abs 你是女的吗？”)");
			html.push("<a>输入历史</a>:使用向上[↑](下[↓])箭头键可心调出输入历史");
			html.push("<a>当前用户</a>:发送“<a>#who</a>”查看在线用户（有时延是必须的）");
			html.push("<a>提示开关</a>:发送“<a>#on</a>”开启提示，发送“<a>#off</a>”关闭提示");

			return html.join("</p><p>")+"</p>";
		},
		emojis:(function(){
			$(document).on("click",".help a.emoji",function(){
				$(".chat-foot textarea").val( $(".chat-foot textarea").val() + $(this).attr("title") );
			});
			return function(){
				var html = ["<div class=help>"];
				$.each( $.WP.getEmojis() , function(i,e){
					html.push("<a href=javascript:; class=emoji title='["+e.text+"]'><img src='"+$.WP.resUrl+"/emoji/"+e.name+"'></a>");
				});
				html.push("</div>");
				return html.join("\n");
			};
		})(),
		clear:function(){
			$("[list]").empty();
			ChatCache.clear();
			return "<div>cleared</div>";
		},
		on:function(){
			localStorage.tip = "on";
			return "<div>已启动桌面通知</div>";
		},
		off:function(){
			localStorage.tip = "off";
			return "<div>已关闭桌面通知</div>";
		},
		who:(function(){
			$(document).on("click","[data-at]",function(){
                $(".chat-foot textarea").val("@"+$(this).data("at")+" ");
            });
			return function(s,printTip){
	            s.send("#who","#who",function(data){
	                data = data || [];
	                var html = [];
	                for( var i = 0 , user ; user = data[i] ; i++ ){
	                    html.push("<a href=javascript:; data-at='"+user.name+"'>"+user.name+"</a>");
	                }
	                printTip("<p>"+html.join("</p><p>")+"</p>");
	            });
	            return false;
	        };
		})(),
		getTip:function(){
			return localStorage.tip != "off";
		}
	};
	
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
				!self  && !cache && notify(message.text,message.name+":",message.head);
			});
			list.length && $(".chat-body").animate({scrollTop:$list.height()});
		};
		
		var help = function(text){
			text = text || "";
			if(!text.match(/^#/))return false;
			text = text.replace(/^#/,'');
			if( !CMD[text] )return false;
			var printTip = function(html){
				$list.append("<div class='list-group-item alert alert-success alert-dismissable' > <button type='button' class='close animate' data-dismiss='alert' aria-hidden='true' style='right:-15px;'>&times;</button>" + html + "</div>");
	            $(".chat-foot textarea").val("");
	            $(".chat-body").animate({scrollTop:$list.height()});
			};
			var html = CMD[text].call(this,s,printTip);
			html && printTip(html);
			return true;
		};

		
		$form.submit(function(){
			if(!$form.check())return false;
			var postData = $form.getData();
			inputHistory.add(postData.text);
			!help(postData.text) && s.send(postData,function(){
				var text = $inputor.val()||"";
				$inputor.val((text.match(/^@[^\s@[]+\s?/)||[""])[0]);
				$image.empty();
			});
			return false;
		});
		
		$inputor.keydown(function(e){
			e.ctrlKey && e.keyCode == KEY_CODE.enter && $form.submit();
		}).keyup(function(e){
			if( e.keyCode == KEY_CODE.upArrow )$inputor.val(inputHistory.get(1));
			if( e.keyCode == KEY_CODE.downArrow )$inputor.val(inputHistory.get(-1));
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
                		var names = [];
                		$.each(data,function(i,user){
                			user.name && names.push(user);
                		});
                		cb(names);
                	});
                }/*,
                matcher: function(flag, subtext) {
                    return matched;
                }*/
            },
            start_with_space:false
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
