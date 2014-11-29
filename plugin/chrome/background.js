chrome.webRequest.onBeforeSendHeaders.addListener( function(details){
	for( var i = 0 ; i < details.requestHeaders.length ; i++){
		if( details.requestHeaders[i].name.match(/referer/i) ){
			details.requestHeaders[i].value = details.url;
		}
	}
	return {requestHeaders:details.requestHeaders}
}, 
{urls: ["*://*.douban.com/*"]},
["blocking", "requestHeaders"]
); 
