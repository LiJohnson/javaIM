package com.lcs.im.websocket;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Repository
public class HandleMessage  {
	@Autowired
	private SessionManager sessionManager;
	
	public void sendMessage(TextMessage message) throws IOException{
		for(WebSocketSession session : this.sessionManager.getAll() ){
			session.sendMessage(message);
		}
	}
}