//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 26/02/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "SetCardDeck.h"


@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    if(self){
        for (NSString *color in [SetCard validColors]){
            for (NSString *symbol in [SetCard validSymbols]){
                for (NSString *shading in [SetCard validShadings]){
                    for (NSUInteger number=1; number <= [SetCard maxNumber]; number++){
                        SetCard *card = [[SetCard alloc]init];
                        card.color = color;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
