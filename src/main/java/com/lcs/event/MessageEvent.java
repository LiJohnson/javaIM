package com.lcs.event;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public class MessageEvent {
	private static final Map<String, JSONArray> ON_LINE_SESSION = new HashMap<String, JSONArray>();
	
	public static void listen( String id ){
		JSONArray lock = getMessageList(id);
		synchronized (lock) {
			try {
				lock.wait(30*1000);
			} catch (InterruptedException e) {
				
			}
		}
		
		
	}
	
	public static void trigger( String id ,JSONObject message  ) {
		if( id != null ){
			try{
				JSONArray lock = getMessageList(id);
				lock.add(message);
				synchronized (lock) {
					lock.notifyAll();
				}
			}catch(Exception e){}
			return ;
		}
		
		Iterator<String> iterator = ON_LINE_SESSION.keySet().iterator();
		while (iterator.hasNext()) {
			id = iterator.next();
			if( id != null ){
				trigger( id , message );
			}
			
		}
	}
	
	public static JSONArray getMessageList( String id ) {
		JSONArray lock = ON_LINE_SESSION.get(id);
		if( lock == null ){
			lock = new JSONArray();
			ON_LINE_SESSION.put(id, lock); 
		}
		return lock;
	}
	
	public static Map<String , JSONArray> getSessionMap( boolean clean ) {
		if( clean ){
			//ON_LINE_SESSION.clear();
		}
		return ON_LINE_SESSION;
	}
	
	public static void remove( String id ) {
		if( id == null )return;
		
		ON_LINE_SESSION.remove(id);
		
	}	
}
