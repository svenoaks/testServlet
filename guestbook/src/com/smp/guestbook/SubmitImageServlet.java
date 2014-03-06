package com.smp.guestbook;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class SubmitImageServlet extends HttpServlet
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -650357472015322683L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();
	private DatastoreService datastore = DatastoreServiceFactory
			.getDatastoreService();

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException
	{
		String guestbookName = request.getParameter("guestbookName");
		System.out.println(guestbookName);
		String currentUser = SessionHelper
				.getCurrentUserFromSession(request);
		if (guestbookName == null || currentUser == null)
		{
			response.sendRedirect("/guestbook.jsp");
			return;
		}
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
		BlobKey blobKey = blobs.get("myFile");

		Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
		Key userKey = guestbookKey.getChild("User", currentUser);

		Date date = new Date();
		Entity imageBlobKey = new Entity("ImageBlobKey", userKey);
		imageBlobKey.setProperty("BlobKey", blobKey);
		imageBlobKey.setProperty("date", date);
		
		datastore.put(imageBlobKey);
		response.sendRedirect("/images.jsp?guestbookName=" + guestbookName);
	}
}
