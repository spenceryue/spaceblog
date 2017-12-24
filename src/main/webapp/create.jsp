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
	<title>Space Blog: Creating a new planet...</title>

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
	<script src="/time.js" async></script>

	<!-- Scroll Navigation -->
<!-- 	<script src="/scroll.js" async></script> -->

	<!-- Subscribe Form -->
<!-- 	<script src="/form.js" async></script> -->

	<!-- Expand li elements -->
	<script src="/expand.js" async></script>
	
	<!-- Alerts -->
	<script type="text/javascript">
		if (document.URL.includes('alert=1'))
			alert("Subscription failed because you're already subscribed! :P");
	</script>
</head>
<body>
	<header>
		<img src="/optimised.svg" width="165" height="100"><h1>Space Blog</h1>
	</header>

	<canvas id="stars" width="300", height="300"></canvas>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {
        pageContext.setAttribute("user", user);
%>
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
%>
	<style type="text/css">
		ul {
			padding-bottom: 0;
		}
		li {
			display: block;
			pointer-events: initial;
			margin-bottom: 0;
		}
		li svg {
			pointer-events: none;
		}
		form {
			/*top: 50%;*/
			/*bottom: -50%;*/
			transform: translate(0,33vh);
			height: 36vh;
			width: 100%;
			background: none;
			outline: none;
			border: none;
			-webkit-text-fill-color: white;
  			color: deepskyblue;
			/*border: 2px solid white;*/
		}
		#planetName {
			/*position: absolute;*/
			/*top: 45%;*/
			background: none;
			outline: none;
			border: none;
			border-bottom: 2px solid deepskyblue;
			width: 100%;
			font-size: 3vh;
			padding-left: 3vh;
			padding-right: 3vh;
			overflow-x: scroll;
			/*left:50%;*/
			/*transform: translate(-50%,0);*/

			-webkit-text-fill-color: white;
  			color: deepskyblue;
			/*border: 2px solid white;*/
		}
		textarea {
			/*position: absolute;*/
			background: none;
			outline: none;
			border: none;
			bottom: 0;
			width: 100%;
			height: 27vh;
			-webkit-text-fill-color: white;
  			color: deepskyblue;
			/*border-bottom-left-radius: 33vh;*/
			/*border-bottom-right-radius: 33vh;*/
			padding-left: 3vh;
			padding-right: 3vh;
			padding-bottom: 3vh;
			overflow: scroll;
			overflow-wrap: break-word;
			/*border: 2px solid white;*/
		}
		textarea::-webkit-scrollbar {
			display: none;
		}
		li .author {
			position: absolute;
			top: 16vh;
			left: 50%;
			transform: translate(-50%,0);
			font-size: 5vh;
			/*border: 2px solid white;*/
		}

	</style>
	<ul>
<%
   	pageContext.setAttribute("author", user.getNickname());
	String firstLetter = user.getNickname().substring(0,1);
	pageContext.setAttribute("author_firstLetter", firstLetter);
%>
		<li id="planet1">
			<svg viewBox="0 0 100 100" preserveAspectRatio="xMinYMin slice">
				<text text-anchor="middle">
					<textPath xlink:href="#subject" startOffset="50%">Creating a new planet...</textPath>
				</text>
			</svg>
			<div class="author">${fn:escapeXml(author_firstLetter)}${fn:escapeXml(author)}</div>
			<form id="creation" action="/create" method="post">
				<input id="planetName" type="text" name="subject" minlength="1" placeholder="Name your planet" required>
				<textarea id="content" class="content" name="content" placeholder="I like rocky planets because I can live on them, most likely. They should also have water... (that's a plus.)" minlength="1" required></textarea>
				<input type="hidden" name="galaxy" value="${fn:escapeXml(galaxy)}">
			</form>
			<svg viewBox="0 0 100 100" preserveAspectRatio="xMinYMax slice">
				<text text-anchor="middle" class="date">
					<textPath xlink:href="#date" startOffset="50%" id="time"></textPath>
				</text>
			</svg>
		</li>
	</ul>
	
	<script type="text/javascript">
	var planetName = document.getElementById('planetName');
	var content = document.getElementById('content');
	// alert(planetName.tagName);
	planetName.onfocus = function(){planetName.placeholder='';};
	var sp = planetName.placeholder;
	planetName.onblur = function() {planetName.placeholder=sp;}
	content.onfocus = function(){content.placeholder='';};
	var cp = content.placeholder;
	content.onblur = function() {content.placeholder=cp;}
	</script>

<!-- 	<nav id="scroller"> -->
<!-- 	</nav> -->

	<nav id="options">
		<a href="#" id="prompt" onclick="document.getElementById('creation').submit()"><div class="opt">confirm creation</div></a>
		<a href="index.jsp"><div class="options opt">return</div></a>
	</nav>
<%-- <% --%>
<!-- // if (user != null) -->
<!-- // 	pageContext.setAttribute("user_email", user.getEmail()); -->
<!-- // else -->
<!-- // 	pageContext.setAttribute("user_email", ""); -->
<%-- %> --%>
<!-- 	<div id="shield"> -->
<!-- 		<form id="subscribe" class='subscribe' action="/subscribe" method="post"> -->
<%-- 			<input type="email" name="email" id="email" minlength="1" placeholder="alice@spacemail.com" value="${fn:escapeXml(user_email)}" required> --%>
<!-- 	        <input type="submit" value=">"> -->
<%-- 	        <input type="hidden" name="galaxy" value="${fn:escapeXml(galaxy)}"> --%>
<!-- 	    </form> -->
<!-- 	    <div id="cancel"></div> -->
<!-- 	</div> -->

</body>
</html>