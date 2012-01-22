//
//  NSString+URLEncoding.m
//  BagIt
//
//  Created by Ruth Fong on 12/7/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString (URLEncoding)

/* (NSString *)
 * urlEncodeValue: (NSString *) str
 *
 * Return a string that has been appropriately escaped for an HTTP GET post.
 * Code from: http://deusty.blogspot.com/2006/11/sending-http-get-and-post-from-cocoa.html
 */
+ (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (__bridge_transfer NSString *) 
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
											(__bridge CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return result;
}

@end
