//
//  Order.h
//  BagIt
//
//  Created by Ruth Fong on 1/19/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
{
    int typeOfMeal;
    NSString* orderURL;
    NSMutableString* entree1Order;
    NSMutableString* entree2Order;
    NSMutableString* sidesOrder;
    NSMutableString* breakfastOrder;
    NSMutableArray* selectedPickupOptions;
    NSMutableArray* selectedBreakfastItems;    
    NSMutableArray* selectedSideIndices;
    NSMutableArray* selectedEntree1Indices;
    NSMutableArray* selectedEntree2Indices;

}

@property (nonatomic, assign) int typeOfMeal;
@property (strong, nonatomic) NSString* orderURL;
@property (strong, nonatomic) NSString* orderInformation;
@property (strong, nonatomic) NSMutableString* breakfastOrder;
@property (strong, nonatomic) NSMutableString* entree1Order;
@property (strong, nonatomic) NSMutableString* entree2Order;
@property (strong, nonatomic) NSMutableString* sideOrder;
@property (strong, nonatomic) NSMutableArray* selectedBreakfastItems;    
@property (strong, nonatomic) NSMutableArray* selectedSideIndices;
@property (strong, nonatomic) NSMutableArray* selectedEntree1Indices;
@property (strong, nonatomic) NSMutableArray* selectedEntree2Indices;
@property (strong, nonatomic) NSMutableArray* selectedPickupOptions;

- (id)initWithMeal: (int) selectedMeal;

@end
