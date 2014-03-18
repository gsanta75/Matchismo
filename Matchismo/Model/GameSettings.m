//
//  GameSettings.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 06/03/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

@synthesize mismatchPenalty = _mismatchPenalty, matchBonus = _matchBonus, flipCost = _flipCost;

#define ALL_SETTINGS_KEY @"GameSettings_All"
#define MISMATCH_KEY @"Mismatch"
#define MATCH_KEY @"MatchBonus"
#define FLIPCOST_KEY @"FlipCost"

#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define FLIP_COST 1

- (NSInteger)intValueForKey:(NSString *)key withDefault:(NSInteger)defaultValue
{
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_SETTINGS_KEY];
    if (!settings) return defaultValue;
    if (![[settings allKeys] containsObject:key]) return defaultValue;
    return [settings[key] integerValue];
}

- (NSInteger)matchBonus
{
    return [self intValueForKey:MATCH_KEY withDefault:MATCH_BONUS];
}

- (NSInteger)mismatchPenalty
{
    return [self intValueForKey:MISMATCH_KEY withDefault:MISMATCH_PENALTY];
}

- (NSInteger)flipCost
{
    return [self intValueForKey:FLIPCOST_KEY withDefault:FLIP_COST];
}

- (void)setIntValue:(NSInteger)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_SETTINGS_KEY] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[key] = @(value);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:ALL_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSURL *filePlist = [NSURL fileURLWithPath:@"/Users/Wasosky/Desktop/gameSettings.plist"];
//    [settings writeToURL:filePlist atomically:YES];

}

- (void)setMatchBonus:(NSInteger)matchBonus
{
    [self setIntValue:matchBonus forKey:MATCH_KEY];
}

- (void)setMismatchPenalty:(NSInteger)mismatchPenalty
{
    [self setIntValue:mismatchPenalty forKey:MISMATCH_KEY];
}

- (void)setFlipCost:(NSInteger)flipCost
{
    [self setIntValue:flipCost forKey:FLIPCOST_KEY];
}

@end
