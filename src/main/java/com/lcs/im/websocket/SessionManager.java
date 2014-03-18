package com.lcs.im.websocket;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.web.socket.WebSocketSession;

public class SessionManager  {
	private Map<String, WebSocketSession> sessions;
	
	public SessionManager() {
		this.sessions = new HashMap<String, WebSocketSession>();
	}
	
	public void add( WebSocketSession session ){
		this.sessions.put(session.getId(), session);
	}
	
	public void remove( WebSocketSession session ){
		this.sessions.remove(session);
	}
	
	public List<WebSocketSession> getAll(){
		List<WebSocketSession> list = new ArrayList<WebSocketSession>();
		Iterator< Entry<String, WebSocketSession> > it = this.sessions.entrySet().iterator();
		while( it.hasNext() ){
			Entry<String, WebSocketSession> entry = it.next();
			WebSocketSession session = entry.getValue();
			if( session.isOpen() ){
				list.add(session);
			}
		}
		return list;
	}
	
}