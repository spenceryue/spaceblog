package spaceblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Properties;
import java.util.logging.Logger;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.ObjectifyService;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.*;
import javax.xml.ws.Response;

public class OrbitalUpdate extends HttpServlet {
	static Logger Log = Logger.getLogger("me.spenceryue.spaceblog.OrbitalUpdate");

	static {
		ObjectifyService.register(Subscriber.class);
		ObjectifyService.register(Planet.class);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		if (request.getParameter("unsubscribe") != null && request.getParameter("unsubscribe").equals("True")) {
			String email = URLDecoder.decode(request.getParameter("email"), "UTF-8");
			Subscriber subscriber = ofy().load().type(Subscriber.class).filter("email", email).first().now();
			ofy().delete().entity(subscriber).now();
			response.sendRedirect(response.encodeRedirectURL("/unsubscribed.html?email="+email));
			return;
		}
		
		List<Subscriber> subscribers = ObjectifyService.ofy().load().type(Subscriber.class).list();
		User user;
		String recipient, content;
		List<Planet> planets;
		
		for (Subscriber subscriber : subscribers) {
			user = subscriber.user;
			recipient = subscriber.email;
			
			if (user != null)
				content = String.format(
						"Greetings %s,<br>",
						user.getNickname());
			else
				content = String.format(
						"Greetings %s,<br>",
						"Spacefarer");
			
			content += "<br>";
			
			if (Math.abs(subscriber.lastVisited.getTime()-System.currentTimeMillis()) < 86400000)
				content += String.format(
						"Since you last visited Space Blog %s...<br>",
						Convenience.timeSince(subscriber.getLastVisited()));
			else
				content += String.format(
						"Since you last visited Space Blog on %s...<br>",
						Convenience.timeSince(subscriber.getLastVisited()));
			
			planets = ObjectifyService.ofy().load().type(Planet.class).filter("timestamp >", subscriber.getLastVisited().getTime()).order("-timestamp").list();
			if (planets == null || planets.isEmpty())
				content += String.format("Nothing much has happened.<br>");
			else
				for (Planet planet : planets) {
					content += String.format(
							"\t- %s created a new planet: %s. (%s)<br>",
							planet.getUser().getNickname(),
							planet.getSubject(),
							Convenience.timeSince(planet.getDate()));
				}
			content += "<br>";
			content += "That is all.<br>"
					+ "Happy spacefaring ~<br>";
			content += "<br>";
			content += String.format(
					"<a href=\"%1$s\" onclick=\"(function opener(url){window.open(url);return false;})(%1$s);\">Click here to leave orbit (unsubscribe)</a>",
					request.getRequestURL()
					+"?unsubscribe=True"
					+"&email="
					+URLEncoder.encode(subscriber.email, "UTF-8"));
//			content += "<script type=\"text/javascript\">function opener(url){window.open(url);return false;}</script>";
			
			Log.info("Sending email to " + recipient);
			Properties props = new Properties();
	        Session session = Session.getDefaultInstance(props, null);
	        try {
	            Message msg = new MimeMessage(session);
	            //Make sure you substitute your project-id in the email From field
	            msg.setFrom(new InternetAddress("noreply@spaceblog0110.appspotmail.com", "Space Blog"));
	            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient, "Recipient"));
	            msg.setSubject("Orbital Update");
	            msg.setContent(content, "text/html; charset=utf-8");
	            Transport.send(msg);
	        } catch (MessagingException | UnsupportedEncodingException e) {
	            Log.warning(e.getMessage());
	        }
        } 
	}
}
