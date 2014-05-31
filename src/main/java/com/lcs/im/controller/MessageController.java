package com.lcs.im.controller;



import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MessageController extends BaseController {

	@RequestMapping( value="frame")
	public String frame( String name , String head , ModelMap map) {
		map.put("name", name == null ? this.session.getId() : name);
		map.put("head", head == null ? "" : head);
		map.put("baseUrl", request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath());
		return "frame";
	}
}