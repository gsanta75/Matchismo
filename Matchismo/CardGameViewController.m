//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 17/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "CardGameViewController.h"
#import "Grid.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, strong) GameSettings *gSettings;

@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) Grid *grid;
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
            cardView = [self createViewForCard:card];
            cardView.tag = cardIndex;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(touchCard:)];
            [cardView addGestureRecognizer:tap];
            [self.cardViews addObject:cardView];
            viewIndex = [self.cardViews indexOfObject:cardView];
            [self.gridView addSubview:cardView];
        } else {
            cardView = self.cardViews[viewIndex];
            [self updateView:cardView forCard:card];
            cardView.alpha = card.matched ? 0.6 : 1.0;
        }
        
        cardView = self.cardViews[cardIndex];
        [self updateView:cardView forCard:card];
        cardView.alpha = card.matched ? 0.6 : 1.0;

        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        cardView.frame = frame;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%ld", (long)self.game.score];
    self.lastFlippedCardsLabel.text = [self descriptionOfLastFlippedCards:self.game.lastChosenCards];
    
    self.lastFlippedCardsLabel.alpha = 1.0;
    self.gameResult.score = self.game.score;
    //NSLog(@"%@",self.cardViews);
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
        if(![self.game cardAtIndex:gesture.view.tag].matched){
            [self.game chooseCardAtIndex:gesture.view.tag];
            [self updateUI];
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
    self.cardViews = nil;
    [[self.gridView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self updateUI];
}





@end
