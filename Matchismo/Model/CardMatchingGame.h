//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 19/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
-(void)printCardGames;
@property (nonatomic) NSUInteger cardsMatchMode;
@property (nonatomic, readonly) NSInteger lastScore;
@property (nonatomic, readonly) NSMutableArray *lastChosenCards;
@end
