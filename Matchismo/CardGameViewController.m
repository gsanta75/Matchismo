//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingModeSelector;

@end

@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        [self changeModeSelector:self.matchingModeSelector];
    }
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                    forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
    }
}
- (IBAction)newGame:(UIButton *)sender
{
    self.game = nil;
    [self updateUI];
}

- (IBAction)changeModeSelector:(UISegmentedControl *)sender
{
    self.game.cardsMatchMode = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
