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

@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSString* didWork;
@property (strong, nonatomic) UIViewController* viewController;
@property (strong, nonatomic) UIViewController* nextViewController;
@property (strong, nonatomic) UIAlertView *message;
@property (strong, nonatomic) MBProgressHUD* loadingModal;

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
