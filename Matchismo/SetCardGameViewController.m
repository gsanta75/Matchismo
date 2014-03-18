//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 03/03/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "HistoryViewController.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

@synthesize gameResult = _gameResult;

-(GameResult *)gameResult
{
    if(!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"SetCard";
    return _gameResult;
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSString *symbol = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        if ([setCard.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([setCard.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([setCard.symbol isEqualToString:@"diamond"]) symbol = @"■";
        
        symbol = [symbol stringByPaddingToLength:setCard.number
                                      withString:symbol
                                 startingAtIndex:0];
        
        if ([setCard.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        
        if ([setCard.shading isEqualToString:@"solid"])
            [attributes setObject:@-5
                           forKey:NSStrokeWidthAttributeName];
        if ([setCard.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
                                                   }];
        if ([setCard.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    }
    
    return [[NSMutableAttributedString alloc] initWithString:symbol
                                                  attributes:attributes];
}

-(void)updateUI
{
    [super updateUI];

    NSString *lastFlippedCardDescription = self.lastFlippedCardsLabel.text;
    [self.lastFlippedCardsLabel setAttributedText:[self replaceCardDescriptionsInText:lastFlippedCardDescription]];
}

-(NSAttributedString *)replaceCardDescriptionsInText:(NSString *)description
{
    NSMutableAttributedString *attributedDescription = [[[NSAttributedString alloc] initWithString:description] mutableCopy];
    
    NSArray *setCards = [SetCard cardsFromText:attributedDescription.string];
    
      for(SetCard *setCard in setCards){
          NSRange range = [attributedDescription.string rangeOfString:setCard.contents];
          if(range.location != NSNotFound){
              [attributedDescription replaceCharactersInRange:range
                                         withAttributedString:[self titleForCard:setCard]];
          }
      }
    return attributedDescription;
}


- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"setCardSelected" : @"setCard"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showHistory"]){
        if([segue.destinationViewController isKindOfClass:[HistoryViewController class]]){
            NSMutableArray *attributedHistory = [[NSMutableArray alloc] init];
            for(NSString *flip in self.historyFlippedCards){
                [attributedHistory addObject:[self replaceCardDescriptionsInText:flip]];
            }
            [segue.destinationViewController setHistory:attributedHistory];
        }
    }
}

@end
