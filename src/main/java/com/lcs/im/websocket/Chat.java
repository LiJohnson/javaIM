package com.lcs.im.websocket;

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

		this.handleMessage.sendMessage(message);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
		this.sessionManager.remove(session);
	}
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session)  throws Exception{
		this.sessionManager.add(session);
		session.sendMessage( new TextMessage(new StringBuffer("{id:'"+session.getId()+"'}") ) );
	}
}