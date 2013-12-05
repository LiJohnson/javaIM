/**
 * File indexServlet.java
 * @authoer lcs
 */
package com.lcs.im;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * @author LCS
 *
 */
public class IndexServlet extends BaseServlet {

	/**
	 * @author LCS
	 */
	private static final long serialVersionUID = -3844916287533721547L;
	
	
	public void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {		
		
		resp.getWriter().write("lcs");
		//req.getRequestDispatcher("/home.jsp").forward(req, resp);
	}

}