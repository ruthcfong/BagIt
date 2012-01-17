//
//  ConnectionDelegate.m
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "ConnectionDelegate.h"
#import "CJSONDeserializer.h"
#import "NSObject+Addons.h"
@implementation ConnectionDelegate

@synthesize data=_data;

@synthesize didWork, dWork;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.data = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSString* str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    NSError* error = nil;
    NSDictionary* responseData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data 
                                                                                   error:&error];
    if (!error) 
    {
        NSLog(@"%@", [responseData valueForKey:@"didWork"]);
        // iterate over all returned data
        //NSMutableArray* courses = [[NSMutableArray alloc] init];
        //didWork = 
        dWork = [responseData valueForKey:@"didWork"];
        
        if ([dWork isEqualToString:@"yes"]) 
        {
            NSLog(@"Yay!");
        }
        else
        {
            // display error message
            [self showAlertWithString: @"Incorrect HUID/PIN"];
            //NSLog(@"Wrong HUID/PIN didn't work.");
        }
        
        //NSLog(@"%@", [responseData valueForKey:@"didWork"]);
        
        //NSLog(@"%@", [responseData valueForKey:@"didWork"]);
        /*for (NSString* entry in [responseData valueForKey:@"didWork"]) 
        {
            NSLog(@"Got here 2");
            NSLog(@"%@", entry);
        }*/
    }
    else
    {
        NSLog(@"%@", error);
    }
    
    
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
    /*NSString* str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);*/
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
    NSLog(@"Yay! Connection was made.");// Response data is %@", self.data);
    /*NSString *responseBody = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseBody);
    NSString* str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);*/
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Boo hoo. Something went terribly wrong.");
    NSLog(@"The error is as follows:%@", error);
}

@end
