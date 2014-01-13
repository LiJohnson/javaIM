package com.lcs.im;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.lcs.event.MessageEvent;

/**
 * @author LCS
 * 
 */
public class ChatV2 extends BaseServlet {

	private static final long serialVersionUID = -2697955197777469185L;

	/**
	 * send message
	 * @param req
	 * @param resp
	 * @throws IOException
	 */
	public void send(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		JSONObject message = new JSONObject();
		String name = req.getParameter("name");
		String id = req.getSession().getId();
		if (name == null || "".equals(name)) {
			name = id;
		}
		
		message.put("name", name);
		message.put("id", id);
		message.put("text", req.getParameter("text").replaceAll("<", "&lt;").replaceAll(">", "&gt;"));
		message.put("pic", req.getParameter("pic"));
		message.put("time", new Date().getTime());

		MessageEvent.trigger(null, message);

		outPut(req, resp, message.toString());
	}

	/**
	 * listen message
	 * @param req
	 * @param resp
	 * @throws IOException
	 */
	public void listen(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String tocken = req.getSession().getId();		
		
		MessageEvent.listen(tocken);
		JSONObject data = new JSONObject();
		JSONArray messageList = MessageEvent.getMessageList(tocken);
		
		data.put("online", MessageEvent.getSessionMap(false).size());
		data.put("id", tocken);
		data.put("list", messageList);
		
		outPut(req, resp, data.toString());
		messageList.clear();
	}
	
	/**
	 * frame
	 * @param req
	 * @param resp
	 * @throws IOException
	 */
	public void frame(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.getWriter().write(req.getParameter("callback")+"()");
	}
	
	/**
	 * response
	 * @param req
	 * @param resp
	 * @param data
	 * @throws IOException
	 */
	private void outPut(HttpServletRequest req, HttpServletResponse resp,
			String data) throws IOException {
		resp.setContentType("text/html;charset=UTF-8");
		String callback = req.getParameter("callback");
		if (callback != null) {
			resp.getWriter().write(callback + "(" + data + ")");
		} else {
			resp.getWriter().write(data);
		}
	}
}