package spaceblog;

import java.util.Date;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity

public class Subscriber implements Comparable<Subscriber> {

    @Id Long id;
    
    @Parent Key parent;

    @Index User user;
    
    @Index String email;
    
    Date lastVisited;

    Date dateSubscribed;

    private Subscriber() {}

    public Subscriber(User user, String email, Key parent) {
    	
    	this.parent = parent;
    	
        this.user = user;
        
        this.email = email;

        dateSubscribed = lastVisited = new Date();

    }

    public User getUser() {
        return user;
    }
    
    public String getEmail() {
        return email;
    }
    
    public Date getLastVisited() {
        return lastVisited;
    }
    
    public Date getDateSubscribed() {
        return dateSubscribed;
    }
    
    public Key getParent() {
        return parent;
    }

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setParent(Key parent) {
		this.parent = parent;
	}

	public void setUser(User user) {
//		this.user = user;
	}
	
	public void setEmail(String email) {
//		this.email = email;
	}
	
	public void setLastVisited(Date lastVisited) {
		this.lastVisited = lastVisited;
	}
	
	public void setDateSubscribed(Date dateSubscribed) {
//		this.dateSubscribed = dateSubscribed;
	}

	@Override
    public int compareTo(Subscriber other) {
        if (dateSubscribed.after(other.dateSubscribed)) {
            return 1;
        } else if (dateSubscribed.before(other.dateSubscribed)) {
            return -1;
        }

        return 0;

    }

}