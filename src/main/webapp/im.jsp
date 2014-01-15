<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

String frontPath = request.getContextPath();
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
	<link rel="stylesheet" href="http://1.gtbcode.sinaapp.com/css/style.css">
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
    
    <script>
    $(function(){
    	var stor = window.localStorage || {};
    	$(".chat").drag({handle:".chat .chat-head"});
    	$("form input:not([type=submit])").change(function(){
    		stor[this.name] = this.value;
        }).each(function(){
        	$(this).val(stor[this.name]);
        });
    	$("form [type=submit]").click();
    });
    </script>

	<style>
	.chat{
	   width: 320px;
       height: 500px;
       position: fixed;
       bottom:  -480;
       right: 2px;
       top: inherit;
       left: inherit;
       z-index: 5555;
	}
	.chat .chat-head{
		width: 100%;
	    height: 25px;
	    position: absolute;
	    top: 0;
	    left: 0;
	    z-index: 5555;
	    background: rgba(128, 128, 128, 0.06);
	    cursor: move;
	}
	.chat iframe{
		width: 100%;
		height: 100%;
		border-radius: 3px;
	    border: 1px solid rgb(182, 182, 182);
	}
	</style>
</head>
<body>
<div class="container">
	<div class="row" >
		<div class="col-md-6 col-md-offset-3" >
		<div class="row" >
			<div class="alert alert-warning alert-dismissable">
			  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			  <p style="text-align: center"><strong>TIP! </strong> 如果不觉得无聊的可以开两个浏览器玩一下</p>
			</div>
		</div>
		
		<div class="row" >
		<form action="frame.jsp" target="chat-frame">
			<div class="col-md-12">
	                <input type="text" name="name" placeholder="your big name" required="required" class="form-control" />
			 </div>
			 
			 <div class="col-md-12">
                    <input type="url" name="head" placeholder="image url" class="form-control" />
                </label>
             </div>
			<div class="col-md-12" >
			  <input type="submit" value="chat" class="btn btn-default" >
			</div>
		</form>
		</div>
		</div>
	</div>
</div>
<div class="chat">
    <div class="chat-head"></div>
    <iframe name="chat-frame" id="chat-frame" ></iframe>
</div>
</body>
</html>
