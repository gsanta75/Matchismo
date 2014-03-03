//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlippedCardsLabel;

@property (nonatomic, strong) NSMutableArray *historyFlippedCards;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

-(NSMutableArray *)historyFlippedCards
{
    if(!_historyFlippedCards) _historyFlippedCards = [[NSMutableArray alloc] init];
    return _historyFlippedCards;
}

-(CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        
    }
    return _game;
}

-(Deck *)createDeck
{
    return nil; //abstract
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastFlippedCardsLabel.text = @"";
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
        
        [cardButton setAttributedTitle:[self titleForCard:card]
                              forState:UIControlStateNormal ];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                    forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
    self.lastFlippedCardsLabel.text = [self descriptionOfLastFlippedCards:self.game.lastChosenCards];
    self.lastFlippedCardsLabel.alpha = 1.0;
    [self updateHistoryFlippedCards];
    [self setSliderRange];
    

}

- (IBAction)changeSlider:(UISlider *)sender
{
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    if ([self.historyFlippedCards count]) {
        self.lastFlippedCardsLabel.alpha = (sliderValue+1 < [self.historyFlippedCards count]) ? 0.6 : 1.0;
        self.lastFlippedCardsLabel.text = [self.historyFlippedCards objectAtIndex:sliderValue];
    }
}

-(void)updateHistoryFlippedCards
{
    NSString *flippedCard = self.lastFlippedCardsLabel.text;
    if (![flippedCard isEqualToString:@""] && ![[self.historyFlippedCards lastObject] isEqualToString:flippedCard]) {
        [self.historyFlippedCards addObject:flippedCard];
        NSLog(@"%@", self.historyFlippedCards);
    }
}

- (void)setSliderRange
{
    if([self.historyFlippedCards count]){
        int maxValue = [self.historyFlippedCards count]-1;
        self.historySlider.maximumValue = maxValue;
        [self.historySlider setValue:maxValue animated:YES];
    }
    
}

-(NSString *)descriptionOfLastFlippedCards:(NSArray *)lastChoosenCards
{
    if (self.game) {
        
        NSString *description = @"";
        
        if ([self.game.lastChosenCards count]) {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards) {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        
        if (self.game.lastScore > 0) {
            description = [NSString stringWithFormat:@"Matched %@ for %d points.", description, self.game.lastScore];
        } else if (self.game.lastScore < 0) {
            
            description = [NSString stringWithFormat:@"%@ don’t match! %d point penalty!", description, -self.game.lastScore];
        }
        
        return description;
    }else{
        return NULL;
    }
}

- (IBAction)newGame:(UIButton *)sender
{
    self.game = nil;
    self.historyFlippedCards = nil;
    self.historySlider.maximumValue = 0.0;
    [self updateUI];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.isChosen ? card.contents : @""];
    return title;
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
