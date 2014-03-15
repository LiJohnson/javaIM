package com.lcs.im.websocket;

import java.io.IOException;
import java.util.Date;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class Chat extends TextWebSocketHandler {

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) {
       System.out.println(session);
       System.out.println(message);
       try {
		session.sendMessage( new TextMessage(message.toString() + new Date().toString()));
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    }

}