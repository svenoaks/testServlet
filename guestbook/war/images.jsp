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
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>

<%!private ImagesService imagesService = ImagesServiceFactory
			.getImagesService();
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();%>
<html>
<body>
	<%
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
	%>
	<%
		ServingUrlOptions urlOptions = ServingUrlOptions.Builder
				.withBlobKey((new BlobKey(currentUser)));
	%>
	<%
		
		if (BlobHelper.doesBlobExist(currentUser, blobstoreService)) {
	%><div>
	<img src="<%=imagesService.getServingUrl(urlOptions)%>" height="100" width="100" />
	</div>
	<%
		}
	%>

	<form action="<%=blobstoreService.createUploadUrl("/submit")%>"
		method="post" enctype="multipart/form-data">
		<input type="file" name="<%= currentUser %>"> <input
			type="submit" value="Submit this Image">
	</form>
</body>
</html>