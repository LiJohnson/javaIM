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
public class Chat extends BaseServlet{

	private static final long serialVersionUID = -2697955197777469188L;

	public void send(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		JSONObject message = new JSONObject();
		String name = req.getParameter("name");
		if (name == null || "".equals(name)) {
			name = "god";
		}
		
		message.put("name", name);
		message.put("tocken", req.getParameter("tocken"));		
		message.put("text", req.getParameter("text"));
		message.put("time", new Date().getTime());

		MessageEvent.trigger(null, message);

		outPut(req, resp, message.toString());
	}

	public void listen(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		String id = req.getParameter("tocken");
		boolean once = "once".equals(req.getParameter("once"));
		JSONArray messageList = MessageEvent.getMessageList(id);
		int i = 10;
		while ( !once && messageList.size() == 0 && i > 0) {
			i--;
			MessageEvent.listen(id);
		}

		outPut(req, resp, messageList.toString());
		messageList.clear();
	}

	public void listSession(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		JSONObject session = new JSONObject();
		session.putAll(MessageEvent.getSessionMap( "clean".equals(req.getParameter("clean")) ));
		session.put("id", req.getSession().getId());
		outPut(req, resp, session.toString());
	}

	public void getTocken(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		JSONObject tocken = new JSONObject();
		tocken.put("tocken", req.getSession().getId());
		outPut(req, resp, tocken.toString());
	}

	
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