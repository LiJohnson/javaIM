package com.lcs.im;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BaseServlet extends HttpServlet {
	/**
	 * @author LCS
	 * public void doAction( HttpServletRequest req , HttpServletResponse resp )throws ServletException, IOException{}
	 */
	private static final long serialVersionUID = 7105717486320137800L; 
	
	public void init(ServletConfig config) throws ServletException{super.init(config);System.out.println(new Date().getTime());}
	public void destroy(){super.destroy();}
	
	public void doPost( HttpServletRequest req , HttpServletResponse resp )throws ServletException, IOException{dispatchRequest(req, resp);}
	public void doGet(HttpServletRequest req,  HttpServletResponse resp) throws ServletException, IOException{dispatchRequest(req, resp);}
	public void doAction( HttpServletRequest req , HttpServletResponse resp )throws ServletException, IOException{resp.getWriter().println("Hey guy! please override method doAction");}
	
	private void dispatchRequest( HttpServletRequest req , HttpServletResponse resp )throws ServletException, IOException{
		Method[] methods = this.getClass().getDeclaredMethods();
		String methodName = this.getInitParameter("method") ;
		for( Method method : methods ){
			if( method.getName().equals(methodName) ){
				try {
					method.invoke(this, req , resp);
					return ;
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.err.println("lcs 处理post方法失败！\t IllegalArgumentException" );return ;
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.err.println("lcs 处理post方法失败！\t IllegalAccessException" );return ;
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.err.println("lcs 处理post方法失败！\t InvocationTargetException" );return ;
				}finally{
					
				}
			}
		}
		doAction(req, resp);
	}
	
	
	private static String toBeanPropertyName( String name ){
		int start = 0 ;
		if( name.startsWith("set") || name.startsWith("get") ){start = 3 ;}
		name = name.substring(start,start+1).toLowerCase() + name.substring(start+1);
		return name ;
	}
	protected static void setBeanProperty( HttpServletRequest request , Object object ){
		Method[] methods = object.getClass().getDeclaredMethods();
		for( Method method : methods ){
			if( method.getName().startsWith("set")){
				String p = request.getParameter( toBeanPropertyName(method.getName()));
				if( p != null ){
					try {
						method.invoke(object, p );
					} catch (IllegalArgumentException e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
						System.err.println("lcs : " + p.toString() + "\t IllegalArgumentException" );
					} catch (IllegalAccessException e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
						System.err.println("lcs : " + p.toString() + "\t IllegalAccessException");
					} catch (InvocationTargetException e) {
						// TODO Auto-generated catch block
						//e.printStackTrace();
						System.err.println("lcs : " + p.toString() + "\t InvocationTargetException");
					}
				}
			}
		}/**/
		
		/*Field[] fields = object.getClass().getDeclaredFields();
		Enumeration pros = request.getParameterNames();
		while( pros.hasMoreElements() ){
			String p = (String) pros.nextElement();
			for( Field field : fields ){
				if(field.getName().equals(p)){
					try {
						field.setAccessible(true);
						field.set(object, request.getParameter(p));
					} catch (IllegalArgumentException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			System.out.println(pros.nextElement());
		}
		/**/
	}
}
