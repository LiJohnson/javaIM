<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>java for lcs</title>
    <link rel="shortcut icon" id="favicon" type="image/x-icon" href="f.ico">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<style>
	div.stage {
		padding-top: 10%;
		text-align: center;
		font-size: 100px;
		cursor: pointer;
		-webkit-perspective: 450px;
	}
	
	
	div span {
		background-color: rgba(0, 255, 184, 0.0001961);
		bordert-radius: 13px;
	}
	.flash{
		display: block;
		position:relative;
		animation:flash 2s infinite;
		-moz-animation:flash 2s infinite; 
		-webkit-animation:flash 2s infinite;
		-o-animation:flash 2s infinite; 
	}
	
	@keyframes flash
	{
		0%  {transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
		50% {transform:  rotateY(-30deg);text-shadow: rgb(0, 0, 0) -0px 74px 41px;}
		100% {transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
		
	}
	@-webkit-keyframes flash /* Safari and Chrome */
	{
		0%  {-webkit-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
		50% {-webkit-transform:  rotateY(-30deg);text-shadow: rgb(0, 0, 0) -0px 74px 41px;}
		100%{-webkit-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
	}
	@-moz-keyframes flash /* Firefox */
	{
		0%  {-moz-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
		50% {-moz-transform:  rotateY(-30deg);text-shadow: rgb(0, 0, 0) -0px 74px 41px;}
		100% {-moz-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
	}
	
	@-o-keyframes flash /* Opera */
	{
		0%  {-o-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
		50% {-o-transform:  rotateY(-30deg);text-shadow: rgb(0, 0, 0) -0px 74px 41px;}
		100% {-o-transform:  rotateY(30deg);text-shadow: rgb(0, 0, 0) 40px 70px 41px;}
	}
	</style>
  </head>
  
  <body style="overflow: hidden; ">
	<div class="stage" >
		<span class=flash contenteditable>Hi lcs~ Nothing happens.</span>
	</div>
</body>
</html>
