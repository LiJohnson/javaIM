package com.lcs.im.controller;


import net.sf.json.JSONArray;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lcs.event.MessageEvent;
import com.lcs.im.pojo.Message;

@Controller
@RequestMapping("/")
public class MessageController extends BaseController {
	
	@RequestMapping( value="send")
	public String send( Message message , ModelMap map) {
		
		if( "#who".equals(message.getText()) ){
			map.put("data", MessageEvent.listClient());
			return "";
		}
		message.setId(this.session.getId());
		
		String toId = this.getToId(message.getText());
		if( toId != null ){
			message.setToId(toId);
			MessageEvent.trigger( message.getId() , message);
			if( toId.length() > 0 ){
				MessageEvent.trigger( toId , message);	
			}
		}else{
			MessageEvent.trigger( null , message);
		}

		map.put("data", message);
		return "output";
	}

	@RequestMapping( value="listen")
	public String listen(Message message ,ModelMap map) {
		String tocken = this.session.getId();	
		
		MessageEvent.listen(tocken,message.getName());
		
		JSONArray messageList = MessageEvent.getMessageList(tocken);
		JSONArray out = new JSONArray();
		for( int i = 0 ; i < messageList.size() ; i++ ){
			out.add( messageList.get(i) );
		}
		messageList.clear();
		
		map.put("online", MessageEvent.listClient().size());
		map.put("id", tocken);
		map.put("list", out);

		return "output";
	}

	@RequestMapping( value="frame")
	public String frame( String name , String head , ModelMap map) {
		map.put("name", name == null ? this.session.getId() : name);
		map.put("head", head == null ? "" : head);
		return "frame";
	}
	
	@RequestMapping( value="socket")
	public String socket( String name , String head , ModelMap map) {
		map.put("name", name == null ? this.session.getId() : name);
		map.put("head", head == null ? "" : head);
		return "frame";
	}
	
	private String getToId(String text){
		int index =text.indexOf(" ");
		if( !text.startsWith("@") || index < 1 )return null;
		
		String name = text.substring(1, text.indexOf(" "));
		
		JSONArray clients =  MessageEvent.listClient();
		for( int i = 0 , len = clients.size()  ; i < len ; i++ ){
			if( name.equals(clients.getJSONObject(i).getString("name")) ){
				return clients.getJSONObject(i).getString("id");
			}
		}
		return "";
	}
}