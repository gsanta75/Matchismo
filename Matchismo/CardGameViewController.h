//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "GameResult.h"
#import "CardMatchingGame.h"
#import "GameSettings.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses
-(Deck *)createDeck;

-(void)updateUI;
@property (weak, nonatomic) IBOutlet UILabel *lastFlippedCardsLabel;
@property (nonatomic, strong) GameResult *gameResult;

@property (nonatomic) NSUInteger numberOfStartingCards;
@property (nonatomic) CGSize maxCardSize;

- (UIView *)createViewForCard:(Card *)card;
- (void)updateView:(UIView *)view forCard:(Card *)card;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic) BOOL removingMatchingCards;
-(void)updateMatchedCards;
@end
