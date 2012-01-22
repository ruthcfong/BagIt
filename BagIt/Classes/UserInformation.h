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

@property (nonatomic, strong)     NSString* huid;
@property (nonatomic, strong)     NSString* pin;

- (id) initWithHUID: (NSString*) username andPIN: (NSString*) password;
- (id) initWithUser: (UserInformation*) otherUser;

@end
