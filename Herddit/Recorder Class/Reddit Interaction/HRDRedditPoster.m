//
//  HRDRedditPoster.m
//  Herddit
//
//  Created by Daniel Finlay on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HRDRedditPoster.h"

@implementation HRDRedditPoster

-(void)post:(NSString *) streamUrl toSub:(NSString *)subId{
	NSLog(@"Post streamurl to subreddit");
	
	NSString *session_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionCookie"];
	
	NSString *post = [[NSString alloc] initWithFormat:@"uh=%@&kind=link&sr=%@&title=HerdditPost&r=%@", modhash, subId, subId];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://www.reddit.com/api/submit"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(connection){
		receivedData = [NSMutableData data];
	}else{
		//Inform the user connection failed.  For now, just popping.
		NSLog(@"Error with HRDRedditPoster");
	}
	
}
-(void)reply:(NSString *) streamUrl toPost:(NSString *)replyTo{
	NSString *post = [[NSString alloc] initWithFormat:@"thing_id=%@&text=%@&uh=%@",	replyTo, streamUrl, modhash];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://www.nowhere.com/sendFormHere.php"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(connection){
		receivedData = [NSMutableData data];
	}else{
		//Inform the user connection failed.  For now, just popping.
		NSLog(@"Error with HRDRedditPoster");
	}
	
}
-(void)setModhash:(NSString*)mod{
	modhash = mod;
}
-(void)newPostTo:(NSString *)subReddit{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
	NSError *error = [[NSError alloc] init];
	outData = [deserializer deserialize:receivedData error:&error];
	NSLog(@"Received Data class: %@", [receivedData class]);
	NSLog(@"Error: %@", error);
	NSLog(@"Data class: %@", [outData class]);
	NSLog(@"Main Subreddit Data: %@", outData);
}
@end
