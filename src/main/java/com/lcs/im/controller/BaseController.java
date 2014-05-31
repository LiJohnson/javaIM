package com.lcs.im.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

public class BaseController {
	@Autowired(required=false)
    protected HttpServletRequest request;
    @Autowired(required=false)
    protected HttpSession session;
}