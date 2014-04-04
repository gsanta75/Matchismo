//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) GameSettings *gSettings;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, strong) Grid *grid;

@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UIButton *addNewCardsButton;

@end

@implementation CardGameViewController

-(Grid *)grid
{
    if(!_grid){
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = self.maxCardSize.width / self.maxCardSize.height;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    return _grid;
}
- (IBAction)addCardsButton:(UIButton *)sender
{
    for (int i = 0; i < sender.tag; i++) {
        [self.game drawNewCard];
    }
    if (self.game.deckIsEmpty) {
        sender.enabled = NO;
        sender.alpha = 0.5;
    }
    [self updateUI];
}


-(NSMutableArray *)cardViews
{
    if(!_cardViews) _cardViews = [NSMutableArray arrayWithCapacity:self.numberOfStartingCards];
    return _cardViews;
}

-(GameSettings *)gSettings
{
    if(!_gSettings) _gSettings = [[GameSettings alloc] init];
    return _gSettings;
}

-(GameResult *)gameResult
{
    return nil; //Abstract
}

-(CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards
                                                  usingDeck:[self createDeck]];
        
        _game.matchBonus = self.gSettings.matchBonus;
        _game.mismatchPenalty = self.gSettings.mismatchPenalty;
        _game.flipCost = self.gSettings.flipCost;
        
    }
    return _game;
}

-(Deck *)createDeck
{
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastFlippedCardsLabel.text = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.game.mismatchPenalty = self.gSettings.mismatchPenalty;
    self.game.matchBonus = self.gSettings.matchBonus;
    self.game.flipCost = self.gSettings.flipCost;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define CARDSPACINGINPERCENT 0.08
-(void)updateUI
{
    for (NSUInteger cardIndex = 0; cardIndex < self.game.numberOfDealtCards; cardIndex++) {
        
        Card *card = [self.game cardAtIndex:cardIndex];
        
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex){
                    //NSLog(@"cIdx:%ld - idx:%ld - cTag:%ld",(unsigned long)cardIndex, (unsigned long)idx, [(UIView *)obj tag]);
                    return YES;
                }
            }
            //NSLog(@"cIdx:%ld - idx:%ld", (unsigned long)cardIndex, (unsigned long)idx);
            return NO;
        }];
        
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            if(!card.matched){
                cardView = [self createViewForCard:card];
                cardView.tag = cardIndex;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(touchCard:)];
                [cardView addGestureRecognizer:tap];
                [self.cardViews addObject:cardView];
                //viewIndex = [self.cardViews indexOfObject:cardView];
                [self.gridView addSubview:cardView];
            }
        } else {
            cardView = self.cardViews[viewIndex];
            if(!card.matched){
                [self updateView:cardView forCard:card];
            }else{
                if(self.removingMatchingCards){
                    [self.cardViews removeObject:cardView];
                    [UIView animateWithDuration:1.0
                                     animations:^{
                                         cardView.frame = CGRectMake(0.0, self.gridView.bounds.size.height,
                                                                     self.grid.cellSize.width, self.grid.cellSize.height);
                                     } completion:^(BOOL finished) {
                                         [cardView removeFromSuperview];

                                     }];
                }else{
                    cardView.alpha = card.matched ? 0.6 : 1.0;
                }
            }
        }
        
    }
    
    self.grid.minimumNumberOfCells = [self.cardViews count];
    
    NSUInteger changedViews = 0;
    for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++) {
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        UIView *cardView = (UIView *)self.cardViews[viewIndex];
        if (![self frame:frame equalToFrame:cardView.frame]) {
            [UIView animateWithDuration:0.5
                                  delay:1.5 * changedViews++ / [self.cardViews count]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cardView.frame = frame;
                             } completion:NULL];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%ld", (long)self.game.score];
    self.lastFlippedCardsLabel.text = [self descriptionOfLastFlippedCards:self.game.lastChosenCards];
    
    self.lastFlippedCardsLabel.alpha = 1.0;
    self.gameResult.score = self.game.score;
    NSLog(@"%@",self.cardViews);
    
    [self updateMatchedCards];
}

#define FRAMEROUNDINGERROR 0.01

- (BOOL)frame:(CGRect)frame1 equalToFrame:(CGRect)frame2
{
    if (fabs(frame1.size.width - frame2.size.width) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.size.height - frame2.size.height) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.x - frame2.origin.x) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.y - frame2.origin.y) > FRAMEROUNDINGERROR) return NO;
    return YES;
}

-(void)updateMatchedCards
{
    //abstract
}

- (UIView *)createViewForCard:(Card *)card
{
    return nil; //abstract
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    //abstract
}

- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        if(!card.matched){
            
            [UIView transitionWithView:gesture.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                   card.chosen = !card.chosen;
                                   [self updateView:gesture.view forCard:card];
                               } completion:^(BOOL finished) {
                                   card.chosen = !card.chosen;
                                   [self.game chooseCardAtIndex:gesture.view.tag];
                                   [self updateUI];
                               }];
        }
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
            
            
            if (self.game.lastScore > 0) {
                description = [NSString stringWithFormat:@"Matched %@ for %ld points.", description, (long)self.game.lastScore];
            } else if (self.game.lastScore < 0) {
                
                description = [NSString stringWithFormat:@"%@ don’t match! %ld point penalty!", description, (long)-self.game.lastScore];
            }
        }
        return description;
    }else{
        return NULL;
    }
}


- (IBAction)newGame:(UIButton *)sender
{
    self.game = nil;
    self.gameResult = nil;
    
    //[[self.gridView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(UIView *subView in self.cardViews){
        [UIView animateWithDuration:0.2
                         animations:^{
                             subView.frame = CGRectMake(self.gridView.bounds.size.width, self.gridView.bounds.size.height,
                                                         self.grid.cellSize.width, self.grid.cellSize.height);
                         } completion:^(BOOL finished) {
                             [subView removeFromSuperview];
                             
                         }];
    }
    self.cardViews = nil;
    self.addNewCardsButton.enabled = YES;
    self.addNewCardsButton.alpha = 1.0;
    
    [self updateUI];
}





@end
