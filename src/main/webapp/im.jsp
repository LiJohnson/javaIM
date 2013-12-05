<html>
<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
	<script src="http://1.gtbcode.sinaapp.com/load.php?c=1&type=js&load=jquery.js,bootstrap.js,jquery.plugin.js,jsonToString.js,Base64.js"></script>
	<link rel="stylesheet" href="http://1.gtbcode.sinaapp.com/css/bootstrap.min.css">
	<script>
	$(function(){
		var $form = $("form");
		var $list = $("[list]");
		
		$form.submit(function(){
			$form.postData("send",function(){
				$form.find("textarea").va;("");	
			},"text");
			return false;
		});
		
		var list = function(){
			$.myAjax({
				type:"POST",
				url:"listen",
				success:function(data){
					if( data && data.text ){
						data.time = $.formatDate(data.time);
						$list.append($("<p><span html-name></span>(<span html-time></span>)<br><span html-text></span></p>").setHtml(data) );
					}	
				},
				complete:function(e,state){
					if( state == "success" ){
						list();
					}else{
						setTimeout(function(){list();}, 5*1000);
					}
				},
				dataType:"json"
			});
		};
		list();
	});
	</script>
</head>
<body>

<div list >
</div>

<form>
<input type="text" name="name" placeholder="your big name" />
<textarea check-len="1" name="text" ></textarea>
<input type="submit" >
</form>

</body>
</html>
