//
//  SetCard.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 26/02/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+(NSArray *)validColors;
+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSUInteger)maxNumber;
+ (NSArray *)cardsFromText:(NSString *)text;

@end
