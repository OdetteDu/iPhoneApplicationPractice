//
//  DescriptionView.h
//  GraphicalSet
//
//  Created by Caidie on 9/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface DescriptionView : SetCardView

@property (strong, nonatomic) NSArray *activeCards;
@property (nonatomic) BOOL match;

@end
