package com.lcs.im.websocket;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class Chat extends TextWebSocketHandler {
	@Autowired
	private SessionManager sessionManager;
	@Autowired
	private HandleMessage handleMessage;

	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		JSONObject json = new JSONObject(message.getPayload());
		String type = json.getString("type");
		
		if ("connected".equals(type)) {
			this.sessionManager.add(session,json.getString("name"));
			json = new JSONObject();
			json.put("count", this.sessionManager.getAll().size());
			json.put("type", "count");
			this.handleMessage.sendMessage(json);
			
		} else if( "who".equals(type) ){
			json = new JSONObject();
			json.put("data", this.sessionManager.getAllName());
			json.put("type", "who");
			this.handleMessage.sendMessage(json,session);
			
		} else if( "atwho".equals(type) ){
			json = new JSONObject();
			json.put("data", this.sessionManager.getAllName());
			json.put("type", "atwho");
			this.handleMessage.sendMessage(json,session);
		}
		else if( "message".equals(type) ){
			String text = json.getString("text");
			int atIndex = text.indexOf("@");
			int spaceIndex = text.indexOf(" ");
			if( atIndex == 0 && spaceIndex > 1 ){
				json.put("private",true);
				String name = text.substring(1,spaceIndex);
				this.handleMessage.sendMessage(json, session);
				json.put("text", text.substring(spaceIndex));
				if( this.handleMessage.sendMessage(json, name) == 0){
					json.put("text", "<a>没有@"+name+"</a>");
					this.handleMessage.sendMessage(json, session);
				}
			}else{
				this.handleMessage.sendMessage(json);	
			}
			
		}

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
		this.sessionManager.remove(session);
		
		JSONObject json = new JSONObject();
		json.put("count", this.sessionManager.getAll().size());
		json.put("type", "count");
		this.handleMessage.sendMessage(json);
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		JSONObject data = new JSONObject();
		data.put("uid", session.getId());
		data.put("type", "connected");
		session.sendMessage(new TextMessage(new StringBuffer(data.toString())));
	}
}