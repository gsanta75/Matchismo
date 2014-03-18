//
//  GameResult.h
//  Matchismo
//
//  Created by Giuseppe Santaniello on 24/02/13.
//  Copyright (c) 2013 Giuseppe Santaniello. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSString *gameType;

@property (nonatomic) NSInteger score;

// added after lecture

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult;

@end
