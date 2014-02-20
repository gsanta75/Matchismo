//
//  Card.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 18/02/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;

@property (nonatomic, getter = isMatched) BOOL matched;
@property (nonatomic, getter = isChosen) BOOL chosen;

-(int)match:(NSArray *)otherCards;

@end
