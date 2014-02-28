package com.lcs.event;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public class MessageEvent {
	private static final Map<String, JSONObject> ON_LINE_CLIENT = new HashMap<String, JSONObject>();
	
	/**
	 * hold a request
	 * @param id
	 */
	public static void listen( String id , String name ){
		JSONObject client = getClient(id);
		client.put("name", name);
		synchronized (client) {
			try {
				client.wait(30*1000);
			} catch (InterruptedException e) {
				
			}
		}
	}
	
	/**
	 * notify a request
	 * @param id
	 * @param message
	 */
	public static void trigger( String id ,Object message  ) {
		if( id != null ){
			try{
				JSONObject client = getClient(id);
				getMessageList(id).add(message);
				synchronized (client) {
					client.notifyAll();
				}
			}catch(Exception e){}
			return ;
		}
		
		Iterator<String> iterator = ON_LINE_CLIENT.keySet().iterator();
		while (iterator.hasNext()) {
			id = iterator.next();
			if( id != null ){
				trigger( id , message );
			}
		}
	}
	
	/**
	 * get client by Id
	 * @param id
	 * @return
	 */
	public static JSONObject getClient( String id ){
		JSONObject client = ON_LINE_CLIENT.get(id);
		if( client == null ){
			client = new JSONObject();
			client.put("list", new JSONArray());
			ON_LINE_CLIENT.put(id, client);
		}
		return client;
	}
	
	/**
	 * list all client online
	 * @return
	 */
	public static JSONArray listClient( ){
		JSONArray list = new JSONArray();
		Iterator<String> iterator = ON_LINE_CLIENT.keySet().iterator();
		while (iterator.hasNext()) {
			JSONObject data = new JSONObject();
			String id = iterator.next();
			data.put("id", id);
			try{
				data.put("name", getClient(id).getString("name"));	
			}catch(Exception e){
				continue;
			}
			
			list.add(data);
		}
		return list;
	}
	
	/**
	 * get a client's message list
	 * @param id
	 * @return
	 */
	public static JSONArray getMessageList( String id ) {
		return getClient(id).getJSONArray("list");
	}
	
	/**
	 * remove a online client
	 * @param id
	 */
	public static void remove( String id ) {
		if( id == null )return;
		ON_LINE_CLIENT.remove(id);
		
	}	
}
