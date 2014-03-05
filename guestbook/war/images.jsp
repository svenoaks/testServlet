<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%!private String getCurrentUserFromSession(HttpServletRequest request) {
		HttpSession session = request.getSession();
		return (String) session.getAttribute("user");
	}%>
<html>

<body>

	<%
		String currentUser = getCurrentUserFromSession(request);
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
</body>
</html>