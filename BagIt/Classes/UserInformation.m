//
//  UserInformation.m
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "UserInformation.h"
#import "NSString+URLEncoding.h"
@implementation UserInformation

@synthesize huid, pin;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithHUID: (NSString*) username andPIN: (NSString*) password
{
    //[self init];
    
    self.huid = [NSString urlEncodeValue:username];//[NSString stringWithString:username];
    self.pin = [NSString urlEncodeValue:password];//[NSString stringWithString:password];
    return self;
}

- (id) initWithUser: (UserInformation*) otherUser
{
    //[self init];
    
    self.huid = [NSString stringWithString:otherUser.huid];//[NSString stringWithString:username];
    self.pin = [NSString stringWithString:otherUser.pin];//[NSString stringWithString:password];
    return self;
}


@end
