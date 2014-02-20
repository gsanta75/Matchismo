//
//  PlayingCard.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 18/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
+(NSArray *)validSuits;
+(NSUInteger)maxRank;

@end
