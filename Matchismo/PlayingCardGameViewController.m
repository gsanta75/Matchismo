//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 28/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

@synthesize gameResult = _gameResult;

-(GameResult *)gameResult
{
    if(!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"PlayingCard";
    return _gameResult;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.numberOfStartingCards = 15;
    self.maxCardSize = CGSizeMake(80.0, 120.0);
    [self updateUI];
}

- (UIView *)createViewForCard:(Card *)card
{
    PlayingCardView *view = [[PlayingCardView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    if (![card isKindOfClass:[PlayingCard class]]) return;
    if (![view isKindOfClass:[PlayingCardView class]]) return;
    
    PlayingCard *playingCard = (PlayingCard *)card;
    PlayingCardView *playingCardView = (PlayingCardView *)view;
    playingCardView.rank = playingCard.rank;
    playingCardView.suit = playingCard.suit;
    playingCardView.faceUp = playingCard.chosen;
    
}


@end
