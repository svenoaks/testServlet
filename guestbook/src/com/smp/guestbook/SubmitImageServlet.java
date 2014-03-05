package com.smp.guestbook;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class SubmitImageServlet extends HttpServlet
{
	 /**
	 * 
	 */
	private static final long serialVersionUID = -650357472015322683L;

	@Override
	    public void doPost(HttpServletRequest request, HttpServletResponse response)
	                throws IOException {
	       
	        response.sendRedirect("/images.jsp");
	    }
}
