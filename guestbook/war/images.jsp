<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.smp.guestbook.SessionHelper"%>
<%@ page import="com.smp.guestbook.BlobHelper"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.images.ServingUrlOptions"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>

<%!private ImagesService imagesService = ImagesServiceFactory
			.getImagesService();
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();
	private DatastoreService datastore = DatastoreServiceFactory
			.getDatastoreService();%>
<html>
<body>
	<%
		String guestbookName = request.getParameter("guestbookName");
		String currentUser = SessionHelper
				.getCurrentUserFromSession(request);
		pageContext.setAttribute("currentUser", currentUser);
		if (currentUser != null) {
	%>
	<p>Hello, ${fn:escapeXml(currentUser)}! Here are your super secret
		images.</p>
	<%
		} else {
			response.sendRedirect("guestbook.jsp");
		}

		Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
		Key userKey = guestbookKey.getChild("User", currentUser);

		Query query = new Query("ImageBlobKey", userKey).addSort("date",
				Query.SortDirection.DESCENDING);
		List<Entity> imageBlobKeys = datastore.prepare(query).asList(
				FetchOptions.Builder.withLimit(10));
		if (imageBlobKeys.isEmpty()) {
	%>
	<p>You have no images.</p>
	<%
		} else {
	
		for (Entity imageBlobKey : imageBlobKeys)
		{
			BlobKey theKey = (BlobKey) imageBlobKey.getProperty("BlobKey");
		
			ServingUrlOptions urlOptions = ServingUrlOptions.Builder
				.withBlobKey(theKey);
	%><div>
		<img src="<%=imagesService.getServingUrl(urlOptions)%>" height="100"
			width="100" />
	</div>
	<%
			}
		}
	%>

	<form action="<%=blobstoreService.createUploadUrl("/submit")%>"
		method="post" enctype="multipart/form-data">
		<input type="file" name="<%=currentUser%>"> <input
			type="submit" value="Submit this Image"> <input type="hidden"
			name="guestbookName" value="${fn:escapeXml(guestbookName)}" />
	</form>
</body>
</html>