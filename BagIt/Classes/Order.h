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
@property (retain, nonatomic) NSString* orderURL;
@property (retain, nonatomic) NSString* orderInformation;
@property (retain, nonatomic) NSMutableString* breakfastOrder;
@property (retain, nonatomic) NSMutableString* entree1Order;
@property (retain, nonatomic) NSMutableString* entree2Order;
@property (retain, nonatomic) NSMutableString* sideOrder;
@property (retain, nonatomic) NSMutableArray* selectedBreakfastItems;    
@property (retain, nonatomic) NSMutableArray* selectedSideIndices;
@property (retain, nonatomic) NSMutableArray* selectedEntree1Indices;
@property (retain, nonatomic) NSMutableArray* selectedEntree2Indices;
@property (retain, nonatomic) NSMutableArray* selectedPickupOptions;

- (id)initWithMeal: (int) selectedMeal;

@end
