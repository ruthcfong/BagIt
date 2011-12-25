//
//  NSString+URLEncoding.h
//  BagIt
//
//  Created by Ruth Fong on 12/7/11.
//  Copyright 2011 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncoding) 

+ (NSString *)urlEncodeValue:(NSString *)str;


@end
