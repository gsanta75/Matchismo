//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// protected
// for subclasses
-(Deck *)createDeck;
-(NSAttributedString *)titleForCard:(Card *)card;
-(UIImage *)backgroundImageForCard:(Card *)card;
-(void)updateUI;

@end
