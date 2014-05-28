package com.lcs.im.websocket;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.web.socket.WebSocketSession;

public class SessionManager {
	private Map<String, SocketData> sessions;

	public SessionManager() {
		this.sessions = new HashMap<String, SocketData>();
	}

	public void add(WebSocketSession session, String name) {
		this.sessions.put(session.getId(), new SocketData(session, name));
	}

	public void remove(WebSocketSession session) {
		this.sessions.remove(session.getId());
	}

	public List<SocketData> getAll() {
		List<SocketData> list = new ArrayList<SocketData>();
		Iterator<Entry<String, SocketData>> it = this.sessions.entrySet()
				.iterator();
		while (it.hasNext()) {
			Entry<String, SocketData> entry = it.next();
			SocketData session = entry.getValue();
			if (session.socketSession.isOpen()) {
				list.add(session);
			}
		}
		return list;
	}
	
	public List<String> getAllName() {
		List<String> list = new ArrayList<String>();
		Iterator<Entry<String, SocketData>> it = this.sessions.entrySet()
				.iterator();
		while (it.hasNext()) {
			Entry<String, SocketData> entry = it.next();
			SocketData session = entry.getValue();
			if (session.socketSession.isOpen()) {
				list.add(session.name);
			}
		}
		return list;
	}
}

class SocketData {
	public WebSocketSession socketSession;
	public String name;

	public SocketData(WebSocketSession socketSession, String name) {
		this.socketSession = socketSession;
		this.name = name;
	}
}