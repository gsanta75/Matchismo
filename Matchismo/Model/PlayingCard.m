//
//  PlayingCard.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 18/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

+(NSArray *)validSuits
{
    return @[@"♥️", @"♦️", @"♠️", @"♣️"];
}

+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count]) {
        for (Card *card in otherCards) {
            if([card isKindOfClass:[PlayingCard class]]){
                PlayingCard *otherCard = (PlayingCard*)card;
                if ([otherCard.suit isEqualToString:self.suit]) {
                    score += 1;
                } else if (otherCard.rank == self.rank) {
                    score += 4;
                }
            }
        }
    }
    return score;
    /* if you want match the otherCards each other and not only with last card choosen
    int score = 0;
    int numOtherCards = [otherCards count];
    
    if (numOtherCards) {
        for (Card *card in otherCards) {
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *otherCard = (PlayingCard *)card;
                if ([self.suit isEqualToString:otherCard.suit]) {
                    score += 1;
                } else if (self.rank == otherCard.rank) {
                    score += 4;
                }
            }
        }
    }
    if (numOtherCards > 1) {
        score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, numOtherCards - 1)]];
    }
    return score;
     */
}



@end
