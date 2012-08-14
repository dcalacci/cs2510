import cs2510h.ITwitter;
import cs2510h.TwitterFactory;
// A TwitterFactory is a
//   new TwitterFactory()
//
// and implements:
//
// makeTwitter : -> Twitter
// Produces an object that lets you talk to Twitter
// Effect: sets up a Twitter connection


// A Driver implements
//
// static main : String[] -> Void
// Kicks off the program
public class Driver {
	public static void main(String[] args) {
		TwitterFactory tfact = new TwitterFactory();
		System.out.println("Hello");
	} 
}



// ITwitter implements
//
// getHomeTimeline : -> List<Status>
// Gets the top 20 of your follower tweets
// Effect: fetches tweets from Twitter
//
// getUserTimeline : -> List<Status>
// Gets the top 20 public tweets
// Effect: connects to Twitter
//
// getUserTimeline : String -> List<Status>
// Gets the top 20 public tweets for the given user
// Effect: connects to Twitter
//
// getPublicTimeline : -> List<Status>
// Gets the top 20 public tweets
// Effect: connects to Twitter
//
// getScreenName : -> String
// Produces your screen name
//
// getStatus : -> Status
// Fetches your status
// Effect: fetches status from server
//
// retweet : Status -> Status
// Retweets the given status
// Effect: sends the retweet
//
// search : String -> List<Status>
// Searches Twitter for the given term
// Effect: searches Twitter
//
// setStatus : String -> Status
// Sets your status to the given string
// Effect: sets your status on the server
//
// users : -> Twitter_Users
// Produces an object useful for interacting with users
