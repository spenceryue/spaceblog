package spaceblog;



import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class PlanetKeeper extends HttpServlet {
	

	static {
	
	        ObjectifyService.register(Planet.class);
	
	    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

        // We have one entity group per PlanetKeeper with all Planets residing

        // in the same entity group as the PlanetKeeper to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Planets for a given PlanetKeeper.  However, the write rate to each

        // PlanetKeeper should be limited to ~1/second.

        String galaxy = req.getParameter("galaxy");

        Key GalaxyKey = KeyFactory.createKey("Galaxy", galaxy);
        
        String subject = req.getParameter("subject");
        
        Text content = new Text(req.getParameter("content"));

        Planet planet = new Planet(user, subject, content, GalaxyKey);
 
        ofy().save().entity(planet).now();
 
        if (galaxy.equals("alpha_centauri"))
        	resp.sendRedirect("/index.jsp");
        else
        	resp.sendRedirect("/index.jsp?galaxy=" + galaxy);
    }

}