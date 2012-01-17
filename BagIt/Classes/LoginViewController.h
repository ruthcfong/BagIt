//
//  LoginViewController.h
//  BagIt
//
//  Created by Ruth Fong on 1/15/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    UITextField* username;
    UITextField* password;
    NSString* orderInfo;
}

@property (retain, nonatomic) IBOutlet     UITextField* username;
@property (retain, nonatomic) IBOutlet     UITextField* password;
@property (retain, nonatomic) NSString* orderInfo;

-(IBAction)submit:(id)sender;
- (IBAction) textFieldReturn: (id) sender;
- (IBAction) backgroundTouched: (id) sender;

@end
