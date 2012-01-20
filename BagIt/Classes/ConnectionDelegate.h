//
//  ConnectionDelegate.h
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ConnectionDelegate : NSObject
{
    NSString* didWork;
    UIAlertView* message;
    MBProgressHUD* loadingModal;
}

@property (retain, nonatomic) NSMutableData* data;
@property (retain, nonatomic) NSString* didWork;
@property (retain, nonatomic) UIViewController* viewController;
@property (retain, nonatomic) UIViewController* nextViewController;
@property (retain, nonatomic) UIAlertView *message;
@property (retain, nonatomic) MBProgressHUD* loadingModal;

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
