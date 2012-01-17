//
//  UserInformation.h
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject
{
    NSString* huid;
    NSString* pin;
}

@property (nonatomic, retain)     NSString* huid;
@property (nonatomic, retain)     NSString* pin;

- (id) initWithHUID: (NSString*) username andPIN: (NSString*) password;

@end
