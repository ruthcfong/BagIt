//
//  NSDate.h
//  BreakfastPrototype1
//
//  Created by Ruth Fong on 11/24/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (formatted)

// prototypes
- (NSString *) toHUDSDate;
- (NSString *) toHUDSTime;
- (NSString *) toTime;
- (NSString *) toDate;

@end
