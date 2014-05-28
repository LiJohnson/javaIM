package com.lcs.im.websocket;

import java.io.IOException;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Repository
public class HandleMessage {
	@Autowired
	private SessionManager sessionManager;

	public int sendMessage(TextMessage message) {
		return this.sendMessage(message, null);
	}

	public int sendMessage(JSONObject json){
		return this.sendMessage(new TextMessage(new StringBuffer(json.toString())));
	}
	
	public int sendMessage(JSONObject json , WebSocketSession session){
		try {
			session.sendMessage(new TextMessage(new StringBuffer(json.toString())));
		} catch (IOException e) {
			return 0;
		}
		return 1;
	}
	
	public int sendMessage(JSONObject json , String name){
		return this.sendMessage(new TextMessage(new StringBuffer(json.toString())),name);
	}

	public int sendMessage(TextMessage message, String name){
		int count = 0;
		if (name == null) {
			for (SocketData session : this.sessionManager.getAll()) {
				try{
					session.socketSession.sendMessage(message);
					count++;	
				}catch(Exception e){}
			}
		} else {
			for (SocketData session : this.sessionManager.getAll()) {
				if (!name.equals(session.name))
					continue;
				try{
					session.socketSession.sendMessage(message);
					count++;	
				}catch(Exception e){}
			}
		}

		return count;
	}

}