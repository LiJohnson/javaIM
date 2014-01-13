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
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
	<script src1="//cxq.zhihuidao.com.cn/js/wp.js"></script>
	<script src="http://192.168.1.59:8080/js/wp.js"></script>
	
	<script src="client.js"></script>

	<script>
    var baseUrl = "<%=frontPath %>";
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
		}
		};
	})();
   var notify = window.nn = (function(){
          var notifications = window.notifications || window.webkitNotifications;
          var sound = ["tutor_urgency_02.ogg","tutor_urgency_05.ogg","tutor_urgency_04.ogg"];
          var i = 0;
          return function(message,title,pic){
              if( notifications.checkPermission() != 0 )return notifications.requestPermission(function(){});

              var notice = notifications.createNotification(pic||"data:image/png;base64,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",title||"通知",message);
              notice.show();
              $.WP.play(sound[i]);
              i = (i+1) % sound.length;
              setTimeout(function(){notice.cancel()},3000);
          };
      })();
	
	$(function(){
		var $form = $("form");
		var $list = $("[list]");
		var $image = $form.find(".image");
		
		var s = new SClient(baseUrl+"/sendV2" , baseUrl+"/listenV2");
		
		var print = function(list,id,cache){
			ChatCache.set("id",id);
			$.each(list||[],function(i,message){
				!cache && ChatCache.put(message);
                var self = id == message.id;
                message.name = message.name.split("#");
                message.head =message.name[1];
                message.name =message.name[0];
                
                if( $.isArray(message.text) && window.JSON ) message.text = JSON.stringify(message.text);
                var $t =  $("<div class='list-group-item' ><span class='badge label-info' html-name ></span><div html-text ></div></div>").setHtml(message).richText().addClass( self ? "self":"" );
                if( message.pic ){
                    $t.append($("<a>").prop({href:message.pic,target:"_blank"}).append($("<img>").prop("src",message.pic)));
                }
                $list.append($t);
                !self  && !cache && notify(message.text,message.name+":",message.head);
            });
			 $(".chat-body").animate({scrollTop:$list.height()});
		};
		
		$form.submit(function(){
			if(!$form.check())return false;
			var postData = $form.getData();
			s.send($form.getData(),function(){
				$form.find("textarea").val("");
				$image.empty();
			});
			return false;
		});
		$form.find("textarea").keydown(function(e){
			e.ctrlKey && e.keyCode == 13 && $form.submit();
		}).getImage(function(data,file){
			$image.append($("<a href=javascript:; class=close>&times;</a>"));
			$image.append($("<img>").prop("src" , data));
			$image.append($("<input type=hidden name='pic' >").val(data));
			!$form.find("textarea").val() && $form.find("textarea").val("分享图片");
		});
		$image.on("click",".close",function(){
			$image.empty();
		});
		
		s.listen(function(data){
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
        .self .badge{background-color: #5bc0de;float: left;}
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
           <textarea check-len="1" name="text" class="form-control" resize="false" ></textarea>
           <input type="hidden" value="<%=name %>#<%=head %>" name="name" />
           <input type="submit" value=" " class="btn btn-default btn-warning" />
        </form>
        </div>
    </div>
</div>
</body>
</html>
