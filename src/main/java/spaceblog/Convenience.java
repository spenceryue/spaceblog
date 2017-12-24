package spaceblog;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class Convenience {
	public static String timeSince(Date date) {
		DateFormat[] dateFormat = {
				new SimpleDateFormat("s 'seconds ago'"),	// <60000
				new SimpleDateFormat("m 'minute ago'"),		// <12000
				new SimpleDateFormat("m 'minutes ago'"),	// <3600000
				new SimpleDateFormat("k 'hour ago'"),		// <7200000
				new SimpleDateFormat("k 'hours ago'"),		// <86400000
				new SimpleDateFormat("EEE h:mm a"),			// <604800000
				new SimpleDateFormat("M/d/YYYY h:mm a")
				};
		
		TimeZone original = TimeZone.getDefault();
		
		long elapsed = System.currentTimeMillis() - date.getTime();
		int index = -1;
		//String debugg = Long.toString(elapsed);
		
		if (elapsed >= 10000) // 10 seconds
			index = 0;
		if (elapsed >= 60000) // 1 minute
			index = 1;
		if (elapsed >= 120000) // 2 minutes
			index = 2;
		if (elapsed >= 3600000) // 1 hour
			index = 3;
		if (elapsed >= 7200000) // 2 hours
			index = 4;
		if (elapsed >= 86400000) // 24 hours
			index = 5;
		if (elapsed >= 604800000) // 1 week
			index = 6;
		
		//String debug2 = Integer.toString(index);
		if (index == -1)
			return "Just now";
		else if (index >= 5) {
			TimeZone.setDefault(original);
			return dateFormat[index].format(date.getTime()); //+" "+debugg+" "+debug2);
		} else {
			TimeZone.setDefault(TimeZone.getTimeZone("GMT"));
			return dateFormat[index].format(new Date(elapsed));
		}
	}
}
