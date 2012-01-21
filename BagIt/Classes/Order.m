//
//  Order.m
//  BagIt
//
//  Created by Ruth Fong on 1/19/12.
//  Copyright 2012 Harvard College. All rights reserved.
//

#import "Order.h"
#import "Constants.h"

@implementation Order

@synthesize typeOfMeal, orderURL, orderInformation,selectedBreakfastItems, selectedSideIndices,selectedEntree1Indices, selectedEntree2Indices, selectedPickupOptions, entree1Order, entree2Order, sideOrder, breakfastOrder;


- (id)init
{
    self = [super init];
    if (self) 
    {
        /*selectedBreakfastItems = [[NSArray alloc] init];
        selectedSideIndices = [[NSArray alloc] init];
        selectedEntreesIndices = 
         */
    }
    
    return self;
}

- (id)initWithMeal: (int) selectedMeal
{
    self = [super init];
    if (self) 
    {
        self.typeOfMeal = selectedMeal;
        entree1Order = [[NSMutableString alloc] init];
        entree2Order = [[NSMutableString alloc] init];
        breakfastOrder = [[NSMutableString alloc] init];
        selectedPickupOptions = [[NSMutableArray alloc]initWithCapacity:NUM_OF_PICKUP_OPTIONS];
        selectedEntree1Indices = [[NSMutableArray alloc]initWithCapacity:NUM_OF_ENTREE_OPTIONS];
        selectedEntree2Indices = [[NSMutableArray alloc]initWithCapacity:NUM_OF_ENTREE_OPTIONS];
        selectedSideIndices = [[NSMutableArray alloc]initWithCapacity:NUM_OF_SIDES];
    }
    
    return self;
}

@end
