//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 28/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
