//
//  SetCardView.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 07/03/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

@property (nonatomic) BOOL chosen;

@end
