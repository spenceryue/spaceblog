<%@page import="spaceblog.Planet"%>
<%@page import="spaceblog.Subscriber"%>
<%@page import="spaceblog.Convenience"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ page import="java.util.List"%>

<%@page import="java.util.Collections"%>

<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.TimeZone"%>

<%@ page import="com.google.appengine.api.users.User"%>

<%@ page import="com.google.appengine.api.users.UserService"%>

<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>

<%@ page import="com.googlecode.objectify.Objectify" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="com.google.appengine.api.datastore.Key"%>

<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>

<%@ page import="com.google.appengine.api.datastore.Text"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
    String galaxy = request.getParameter("galaxy");

    if (galaxy == null) {
        galaxy = "alpha_centauri";
    }

    pageContext.setAttribute("galaxy", galaxy);
%>


<!DOCTYPE html>
<html>
<head>
	<title>Space Blog: Galaxy Map</title>

	<!-- Icon -->
	<link rel="icon" href="/favicon.ico">

	<!-- SVG Paths -->
	<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="defs">
		<defs>
			<path d="M50,102 a52,52 0 1 1 0,-104 a52,52 0 1 1 0,104" id="subject"></path>
			<path d="M50,-6 a56,56 0 1 0 0,112 a56,56 0 1 0 0,-112" id="date"></path>
			<path d="M0,-1 h 100" id="expandSubject"></path>
			<path d="M0,102 h 100" id="expandDate"></path>
		</defs>
	</svg>

	<!-- Fonts -->
	<link href="https://fonts.googleapis.com/css?family=Josefin+Sans|Libre+Baskerville|Muli:400,600i" rel="stylesheet">

	<!-- Styles -->
	<link type="text/css" rel="stylesheet" href="/stylesheets/styles.css" async>
	
	<!-- Paints background -->
	<script src="/stars.js" async></script>

	<!-- Paint gradient on planet -->
	<script src="/gradient.js" async></script>

	<!-- Time -->
<!-- 	<script src="/time.js" async></script> -->

	<!-- Scroll Navigation -->
	<script src="/scroll.js" async></script>

	<!-- Subscribe Form -->
	<script src="/form.js" async></script>
	
	<!-- Expand li elements -->
	<script src="/expand.js" async></script>
	
	<!-- Alerts -->
	<script type="text/javascript">
		if (document.URL.includes('alert=1')) {
			var timestamp = decodeURIComponent(document.URL.substring(document.URL.indexOf("timestamp=")+10,document.URL.indexOf("&date=")));
			var dateSubscribed = decodeURIComponent(document.URL.substring(document.URL.indexOf("date=")+5));
			if (Math.abs(timestamp-Date.now()) < 86400000)
				alert("Subscription failed because you were already subscribed " + dateSubscribed + ".");
			else
				alert("Subscription failed because you were already subscribed on " + dateSubscribed + ".");
		}
	</script>
</head>
<body>
	<!-- TODO: 1. js only transform here -->
	<header style="z-index:2">
		<img src="/optimised.svg" width="165" height="100"><h1>Space Blog</h1>
	</header>

	<canvas id="stars" width="300", height="300"></canvas>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {
        pageContext.setAttribute("user", user);
%>
<!-- TODO: 2a. js only transform here -->
<!-- Signed in -->
<!-- 	<aside> -->
<!-- 	<div id="time"> -->
<!-- 	</div> -->
<%-- 	<div id="greeting">Hello ${fn:escapeXml(user.nickname)}</div> --%>
<!-- 	<a href="create.html" class="text-gradient">Create a new planet</a> -->
<!-- 	</aside> -->
<%
    } else {
%>
<!-- TODO: 2b. js only transform here -->
<!-- Not Signed In -->
<!-- 	<aside class="text-gradient"> -->
<!-- 	<div id="greeting">Welcome Spacefarer</div> -->
<%-- 	<a id="signin" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in with your <span class="nobreak text-gradient"><img src="google-icon.svg">oogle</span> account to make a new planet.</a> --%>
<!-- 	</aside> -->
<%
    }
%>
<%
	Key GalaxyKey = KeyFactory.createKey("Galaxy", galaxy);
	ObjectifyService.register(Subscriber.class);
	ObjectifyService.register(Planet.class);
	
	// Update record of when a subscriber has last visited website.
	// (This info will be used in the newsletter potentially.)
	if (user != null) {
		Subscriber subscriber = ObjectifyService.ofy().load().type(Subscriber.class).ancestor(GalaxyKey).filter("user",user).first().now();
		if (subscriber != null) {
			subscriber.setParent(GalaxyKey);
			subscriber.setLastVisited(new Date());
			ObjectifyService.ofy().save().entity(subscriber).now();
		}
	}
	
	// Run an ancestor query to ensure we see the most up-to-date
	// view of the planets belonging to the selected Space Blog.
    
	List<Planet> planets = ObjectifyService.ofy().load().type(Planet.class).ancestor(GalaxyKey).order("-date").list();
%>
	<!-- TODO: 3. js only transform here -->
	<!-- TODO: 4. js only load messages here -->
	<ul style="display: flex; flex-direction: row; justify-content: flex-start; align-items: center; align-content: flex-start; flex-wrap: wrap; width: 95vw;">
<%
	int i=1;
    for (Planet planet : planets) {
    	pageContext.setAttribute("planet_user", planet.getUser());
		String firstLetter = ((String) (((User) planet.getUser()).getNickname())).substring(0,1);
		pageContext.setAttribute("planet_user_firstLetter", firstLetter);
		pageContext.setAttribute("planet_subject", planet.getSubject());
		pageContext.setAttribute("planet_content", planet.getContent().getValue());
		pageContext.setAttribute("planet_date", Convenience.timeSince(planet.getDate()));
%>
		<li id="planet<%=i%>">
			<svg viewBox="0 0 100 100" preserveAspectRatio="xMinYMin slice">
				<text text-anchor="middle">
					<textPath xlink:href="#subject" startOffset="50%">${fn:escapeXml(planet_subject)}</textPath>
				</text>
			</svg>
			<div class="author">${fn:escapeXml(planet_user_firstLetter)}${fn:escapeXml(planet_user.nickname)}</div>
			<hr>
			<p class="content">${fn:escapeXml(planet_content)}</p>
			<svg viewBox="0 0 100 100" preserveAspectRatio="xMinYMax slice">
				<text text-anchor="middle" class="date">
					<textPath xlink:href="#date" startOffset="50%">${fn:escapeXml(planet_date)}</textPath>
				</text>
			</svg>
		</li>
<%	
		i++;
	}
    
    if (planets == null || planets.isEmpty()) {
%>
		<li>
			<p>This galaxy has no planets yet. Why not create one?</p>
		</li>
<%
    }
%>
	</ul>

	<nav id="scroller">
	</nav>

	<nav id="options">
<%
		if (user != null) {
%>
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" id="signout"><div class="opt">sign out</div></a>
<%
		}
%>
		<!-- TODO: 5. js only transform here -->
		<a href="index.jsp" id="map"><div class="opt">return</div></a>
		<a href="#" id="prompt"><div class="opt">orbital updates</div></a>
	</nav>
<%
if (user != null)
	pageContext.setAttribute("user_email", user.getEmail());
else
	pageContext.setAttribute("user_email", "");
pageContext.setAttribute("return", request.getRequestURI());
%>
	<div id="shield">
		<form id="subscribe" class='subscribe' action="/subscribe" method="post">
			<input type="email" name="email" id="email" minlength="1" placeholder="alice@spacemail.com" value="${fn:escapeXml(user_email)}" required>
	        <input type="submit" value=">">
	        <input type="hidden" name="galaxy" value="${fn:escapeXml(galaxy)}">
	        <input type="hidden" name="return" value="${fn:escapeXml(return)}">
	    </form>
	    <div id="cancel"></div>
	</div>

</body>
</html>