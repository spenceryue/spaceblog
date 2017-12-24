package spaceblog;

import java.util.Date;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

 

@Entity

public class Planet implements Comparable<Planet> {

    @Id Long id;
    
    @Parent Key parent;

    User user;
    
    String subject;

    Text content;

    @Index Date date;
    
    @Index long timestamp;

    private Planet() {}

    public Planet(User user, String subject, Text content, Key parent) {
    	
    	this.parent = parent;

    	this.subject = subject;
    	
        this.user = user;

        this.content = content;

        date = new Date();
        
        timestamp = date.getTime();
    }

    public User getUser() {

        return user;

    }
    
    public String getSubject() {

        return subject;

    }
    
    public Text getContent() {

        return content;

    }
    
    public Date getDate() {

        return date;

    }
    
    public long getTimestamp() {

        return timestamp;

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
		this.user = user;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	public void setContent(Text content) {
		this.content = content;
	}

	public void setDate(Date date) {
		this.date = date;
		timestamp = date.getTime();
	}

	@Override

    public int compareTo(Planet other) {

        if (date.after(other.date)) {

            return 1;

        } else if (date.before(other.date)) {

            return -1;

        }

        return 0;

    }

}