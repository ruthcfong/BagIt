//
//  ConnectionDelegate.h
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionDelegate : NSObject
{
    bool didWork;
    NSString* dWork;
}

@property (retain, nonatomic) NSMutableData* data;
@property (retain, nonatomic) NSString* dWork;
@property (assign, nonatomic) bool didWork;



@end
