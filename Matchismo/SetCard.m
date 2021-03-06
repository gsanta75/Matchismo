//
//  SetCard.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 26/02/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard


@synthesize color = _color, symbol = _symbol, shading = _shading;

-(instancetype)init
{
    self = [super init];
    if(self){
        self.numberOfMatchingCards = 3;
    }
    return self;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@:%@:%@:%lud", self.symbol, self.color, self.shading, (unsigned long)self.number];
}

-(NSString *)color
{
    return _color ? _color : @"?";
}

+(NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

-(void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) _color = color;
}

-(NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

+(NSArray *)validSymbols
{
    return @[@"oval", @"squiggle", @"diamond"];
}

-(void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) _symbol = symbol;
}

-(NSString *)shading
{
    return _shading ? _shading : @"?";
}

+(NSArray *)validShadings
{
    return @[@"solid", @"open", @"striped"];
}

-(void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) _shading = shading;
}

+(NSUInteger)maxNumber
{
    return 3;
}

-(void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) _number = number;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == self.numberOfMatchingCards - 1) {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *symbols = [[NSMutableArray alloc] init];
        NSMutableArray *shadings = [[NSMutableArray alloc] init];
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        [colors addObject:self.color];
        [symbols addObject:self.symbol];
        [shadings addObject:self.shading];
        [numbers addObject:@(self.number)];
        for (id otherCard in otherCards) {
            if ([otherCard isKindOfClass:[SetCard class]]) {
                SetCard *otherSetCard = (SetCard *)otherCard;
                if (![colors containsObject:otherSetCard.color])
                    [colors addObject:otherSetCard.color];
                if (![symbols containsObject:otherSetCard.symbol])
                    [symbols addObject:otherSetCard.symbol];
                if (![shadings containsObject:otherSetCard.shading])
                    [shadings addObject:otherSetCard.shading];
                if (![numbers containsObject:@(otherSetCard.number)])
                    [numbers addObject:@(otherSetCard.number)];
                if (([colors count] == 1 || [colors count] == self.numberOfMatchingCards)
                    && ([symbols count] == 1 || [symbols count] == self.numberOfMatchingCards)
                    && ([shadings count] == 1 || [shadings count] == self.numberOfMatchingCards)
                    && ([numbers count] == 1 || [numbers count] == self.numberOfMatchingCards)) {
                    score = 4;
                }
            }
        }
    }
    
    return score;
}

+ (NSArray *)cardsFromText:(NSString *)text
{
    NSString *pattern = [NSString stringWithFormat:@"(%@):(%@):(%@):(\\d+)",
                         [[SetCard validSymbols] componentsJoinedByString:@"|"],
                         [[SetCard validColors] componentsJoinedByString:@"|"],
                         [[SetCard validShadings] componentsJoinedByString:@"|"]];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) return nil;
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, [text length])];
    if (![matches count]) return nil;
    
    NSMutableArray *setCards = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in matches) {
        SetCard *setCard = [[SetCard alloc] init];
        setCard.symbol = [text substringWithRange:[match rangeAtIndex:1]];
        setCard.color = [text substringWithRange:[match rangeAtIndex:2]];
        setCard.shading = [text substringWithRange:[match rangeAtIndex:3]];
        setCard.number = [[text substringWithRange:[match rangeAtIndex:4]] intValue];
        [setCards addObject:setCard];
    }
    
    return setCards;
}

//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"%@ - %@ - %@ - %ld", self.color, self.symbol, self.shading, (unsigned long)self.number];
//}
@end
