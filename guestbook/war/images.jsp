<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.smp.guestbook.SessionHelper"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobKey" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>

<html>
<body>

	<%
		String currentUser = SessionHelper.getCurrentUserFromSession(request);
		pageContext.setAttribute("currentUser", currentUser);
		if (currentUser != null) {
			System.out.println(currentUser);	
	%>
	<p>Hello, ${fn:escapeXml(currentUser)}! Here are your super secret
		images.</p>
	<%
		} else {
			response.sendRedirect("guestbook.jsp");
		}
		
		
	%>
	
	<form action="<%= blobstoreService.createUploadUrl("/submit") %>" method="post" enctype="multipart/form-data">
        <input type="file" name="<%= currentUser %>">
        <input type="submit" value="Submit this Image">
    </form>
</body>
</html>