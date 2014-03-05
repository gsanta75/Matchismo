//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 04/03/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

-(void)setHistory:(NSArray *)history
{
    _history = history;
    if(self.view.window) [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    
}

-(void)updateUI
{
    if ([[self.history firstObject] isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] init];
        int i = 1;
        for (NSAttributedString *line in self.history) {
            [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%2d: ", i++]]];
            [historyText appendAttributedString:line];
            [historyText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" ]];
        }
        self.historyTextView.attributedText = historyText;
    } else {
        NSMutableString *historyText = [[NSMutableString alloc] init];
        int i = 1;
        for (NSString *line in self.history) {
            [historyText appendFormat:@"%2d: %@\n\n", i++, line];
        }
        self.historyTextView.text = historyText;
    }
    
}
@end
