//
//  SubmissionSuperViewController.h
//  BagIt
//
//  Created by Ruth Fong on 1/17/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformation.h"
@interface SubmissionSuperViewController : UIViewController
{
    bool didWork;
    NSString* dWork;
    UserInformation* user;
}

@property (retain, nonatomic) NSMutableData* data;
@property (retain, nonatomic) NSString* dWork;
@property (assign, nonatomic) bool didWork;
@property (retain, readwrite, nonatomic) UserInformation* user;

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
