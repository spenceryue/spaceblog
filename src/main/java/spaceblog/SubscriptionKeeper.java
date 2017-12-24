package spaceblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import jdk.nashorn.internal.ir.RuntimeNode.Request;

public class SubscriptionKeeper extends HttpServlet {
	

	static {
	        ObjectifyService.register(Subscriber.class);
	    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

        // We have one entity group per SubscriptionKeeper with all Subscribers residing

        // in the same entity group as the SubscriptionKeeper to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Subscribers for a given SubscriptionKeeper.  However, the write rate to each

        // SubscriptionKeeper should be limited to ~1/second.

        String galaxy = req.getParameter("galaxy");

        Key GalaxyKey = KeyFactory.createKey("Galaxy", galaxy);
        
        String email = req.getParameter("email").toLowerCase();
        
        Subscriber subscriber = ObjectifyService.ofy().load().type(Subscriber.class).filter("email",email).first().now();
        if (subscriber != null) {
        	if (galaxy.equals("alpha_centauri"))
        		resp.sendRedirect(req.getParameter("return") + "?alert=1" + "&timestamp=" + subscriber.getDateSubscribed().getTime() + "&date=" + Convenience.timeSince(subscriber.getDateSubscribed()));
            else
            	resp.sendRedirect(req.getParameter("return") + "?galaxy=" + galaxy + "&alert=1" + "&timestamp=" + subscriber.getDateSubscribed().getTime() + "&date=" + Convenience.timeSince(subscriber.getDateSubscribed()));
        	return;
        }

        subscriber = new Subscriber(user, email, GalaxyKey);
 
        ofy().save().entity(subscriber).now();
 
        if (galaxy.equals("alpha_centauri"))
        	resp.sendRedirect(req.getParameter("return"));
        else
        	resp.sendRedirect(req.getParameter("return") + "?galaxy=" + galaxy);
    }

}