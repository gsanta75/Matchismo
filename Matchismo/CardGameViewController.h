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

@interface CardGameViewController : UIViewController

// protected
// for subclasses
-(Deck *)createDeck;
-(NSAttributedString *)titleForCard:(Card *)card;
-(UIImage *)backgroundImageForCard:(Card *)card;
-(void)updateUI;
@property (weak, nonatomic) IBOutlet UILabel *lastFlippedCardsLabel;
@property (nonatomic, strong) NSMutableArray *historyFlippedCards;
@property (nonatomic, strong) GameResult *gameResult;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end
