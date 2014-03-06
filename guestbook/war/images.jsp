<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.smp.guestbook.SessionHelper"%>
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
		System.out.println(guestbookName);
		String currentUser = SessionHelper
				.getCurrentUserFromSession(request);
		pageContext.setAttribute("currentUser", currentUser);
		if (currentUser != null && guestbookName != null) {
	%>
	<p>Hello, ${fn:escapeXml(currentUser)}! Here are your super secret
		images.</p>
	<%
		} else {
			response.sendRedirect("guestbook.jsp");
			return;
		}

		Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
		Key userKey = guestbookKey.getChild("User", currentUser);

		Query query = new Query("ImageBlobKey", userKey).addSort("date",
				Query.SortDirection.ASCENDING);
		List<Entity> imageBlobKeys = datastore.prepare(query).asList(
				FetchOptions.Builder.withDefaults());
		if (imageBlobKeys.isEmpty()) {
	%>
	<p>You have no images.</p>
	<%
		} else { %>
			<table style="width:300px; margin:20px;">
			<tr>
		<%
			int rowLength = 0;
			for (Entity imageBlobKey : imageBlobKeys) {
				BlobKey theKey = (BlobKey) imageBlobKey
						.getProperty("BlobKey");

				ServingUrlOptions urlOptions = ServingUrlOptions.Builder
						.withBlobKey(theKey);

				try {
					String servingUrl = imagesService.getServingUrl(urlOptions);
					if (rowLength % 5 == 0)
					{
						%>
						</tr>
						<td>
					<%}
					 ++rowLength;%>
				
		<td> <a href="<%=servingUrl%>"> <img style="max-width:150px; max-height:150px" src="<%=servingUrl%>" /> </a> </td>	
	
	<%
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				}
			}%>
			</tr>
			</table>
		<%} %>
	 <form action="<%= blobstoreService.createUploadUrl("/submit") %>" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile">
        <input type="submit" value="Submit this Image">
    </form>
</body>
</html>