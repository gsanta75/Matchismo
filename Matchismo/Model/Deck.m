//
//  Deck.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 18/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards; //of Cards

@end

@implementation Deck

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if(atTop){
        [self.cards insertObject:card atIndex:0];
    }else{
        [self.cards addObject:card];
    }
    
}

-(void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if([self.cards count]){
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

-(void)printAllCards
{
//  Print NSString contents of any card
//    for(Card *card in self.cards){
//        NSLog(@"%@", card.contents);
//    }
    
//    NSLog(@"%@", self.cards); //print card using descriptor of PlayingCard class
}

@end
