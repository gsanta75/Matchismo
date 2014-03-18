//
//  GameSettings.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 06/03/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) NSInteger matchBonus;
@property (nonatomic) NSInteger mismatchPenalty;
@property (nonatomic) NSInteger flipCost;

@end
