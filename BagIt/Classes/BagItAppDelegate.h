//
//  BagItAppDelegate.h
//  BagIt
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagItAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end

