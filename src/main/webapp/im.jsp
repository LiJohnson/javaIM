<%
String frontPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="favicon.ico">
	<script src="http://1.gtbcode.sinaapp.com/load.php?c=1&type=js&load=jquery.js,jquery.plugin.js"></script>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">	
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href1="http://1.gtbcode.sinaapp.com/css/style.css">
	<link rel="stylesheet" href="http://lcs.com/sae/gtbcode/1/css/style.css">
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
	<script src="client.js"></script>

	<script>
	$(function(){
		var $form = $("form");
		var $list = $("[list]");
		var baseUrl = "<%=frontPath %>";
		var s = new SClient(baseUrl+"/sendV2" , baseUrl+"/listenV2");
		
		$form.submit(function(){
			if(!$form.check())return false;
			var postData = $form.getData();
			s.send(postData.name , postData.text,function(){
				$form.find("textarea").val("");
			});
			return false;
		});
		$form.find("textarea").keydown(function(e){
			e.ctrlKey && e.keyCode == 13 && $form.submit();
		});
		s.listen(function(data){
			$.each(data.list||[],function(i,message){
			//	$list.append( $("<div class='panel-body' ><span class='label label-info' html-name ></span><div html-text ></div></div>").setHtml(message) );	
				$list.append( $("<div class='list-group-item' ><span class='badge label-info' html-name ></span><div html-text ></div></div>").setHtml(message).addClass( data.id == message.id ? "self":"" ) );
				$(".chat-list").scrollTop(5000000000000);
			});
		});
		
		$form.find("input[name=name]").change(function(){
			window.localStorage.name = this.value;
		}).val(window.localStorage.name);
	});
	</script>
	<style>
	   .chat-list{height: 500px;overflow-y:scroll; }
	   .self{text-align: right;}
	   .self .badge{background-color: #5bc0de;float: left;}
	</style>
</head>
<body>
<div class="container">
<div class="row" >
	<div class="col-md-6 col-md-offset-3" >
	<div class="row chat-list" >
	   <div class="col-md-12">
			<div class="list-group" list>
            </div>
		</div>
	</div>
	<hr>
	<div class="row" >
	<form>
		<div class="col-md-3">
		    <label>
                <input type="text" name="name" placeholder="your big name" class="form-control" />
            </label>
		 </div>
		 <div class="col-md-12" >
		  <textarea check-len="1" name="text" class="form-control"  ></textarea>
		</div>
		<div class="col-md-12" >
		  <input type="submit" value="send" class="btn btn-default col-md-offset-6" style="float:right;" >
		</div>
	</form>
	</div>
	</div>
</div>
</div>
</body>
</html>
