//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 19/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, strong) NSArray *lastChosenCards;
@end

@implementation CardMatchingGame


-(NSUInteger)cardsMatchMode
{
    Card *card = [self.cards firstObject];
    if (!_cardsMatchMode) _cardsMatchMode = card.numberOfMatchingCards;
    return _cardsMatchMode;
}

-(NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if(self){
        for(int i=0; i<count; i++){
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            }else{
                self = nil;
                break;
            }
        }
    }
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.lastScore = 0;
    
    if(!card.isMatched){
        if(card.isChosen){
            card.chosen = NO;
            self.lastChosenCards = [self choosenCards];
        }else{
      
            NSMutableArray *otherCards = [self choosenCards];
            self.lastChosenCards = [otherCards arrayByAddingObject:card];

            if ([otherCards count] + 1 == self.cardsMatchMode) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.lastScore += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                    }
                } else {
                    self.lastScore -= MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            self.score += self.lastScore - COST_TO_CHOOSE;
            card.chosen = YES;
        }

    }

    //NSLog(@"%@", self.cards);
    [self printCardGames];
}

-(NSMutableArray *)choosenCards
{
    NSMutableArray *otherCards = [NSMutableArray array];
    for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
            [otherCards addObject:otherCard];
        }
    }
    return otherCards;
}

-(void)printCardGames
{
    for(Card *card in self.cards){
        NSLog(@"%d %@ %d %d", [self.cards indexOfObject:card], card.contents, card.isChosen, card.isMatched);
    }
    NSLog(@"\n");
}


@end
