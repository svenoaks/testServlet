package com.smp.guestbook;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionHelper
{
	public static String getCurrentUserFromSession(HttpServletRequest request)
	{
		HttpSession session = request.getSession();
		return (String) session.getAttribute("user");
	}
	public static void newSessionForUser(String userName, HttpServletRequest request) {
		HttpSession currentSession = request.getSession();
		String currentUser = (String) currentSession.getAttribute("user");
		if (currentUser == null || !currentUser.equals(userName)) {
			currentSession.invalidate();
			currentSession = request.getSession();
		}
		currentSession.setAttribute("user", userName);
	}
}
