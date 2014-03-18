//
//  SettingsGameViewController.m
//  Matchismo
//
//  Created by Giuseppe Santaniello on 06/03/14.
//  Copyright (c) 2014 Giuseppe Santaniello. All rights reserved.
//

#import "SettingsGameViewController.h"
#import "GameSettings.h"

@interface SettingsGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipcostLabel;
@property (weak, nonatomic) IBOutlet UISlider *matchSlider;
@property (weak, nonatomic) IBOutlet UISlider *mismatchSlider;
@property (weak, nonatomic) IBOutlet UISlider *flipcostSlider;
@property (nonatomic, strong) GameSettings *gSettings;

@end

@implementation SettingsGameViewController

-(GameSettings *)gSettings
{
    if(!_gSettings) _gSettings = [[GameSettings alloc] init];
    return _gSettings;
}

#pragma mark - (Unused) Initialization before viewDidLoad

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

#pragma mark - ViewController lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI
{
    self.matchLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gSettings.matchBonus];
    self.mismatchLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gSettings.mismatchPenalty];
    self.flipcostLabel.text = [NSString stringWithFormat:@"%ld", (long)self.gSettings.flipCost];
    
    [self.mismatchSlider setValue:(float)self.gSettings.mismatchPenalty animated:YES];
    [self.matchSlider setValue:(float)self.gSettings.matchBonus animated:YES];
    [self.flipcostSlider setValue:(float)self.gSettings.flipCost animated:YES];
}

- (IBAction)changeSettings:(UISlider *)sender
{
    int sliderValue;
    sliderValue = sender.value;
    [sender setValue:sliderValue animated:NO];
    
    if(sender == self.matchSlider){
        self.matchLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
        self.gSettings.matchBonus = sliderValue;
    }
    if(sender == self.mismatchSlider){
        self.mismatchLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
        self.gSettings.mismatchPenalty = sliderValue;
    }
    if(sender == self.flipcostSlider){
        self.flipcostLabel.text = [NSString stringWithFormat:@"%d", sliderValue];
        self.gSettings.flipCost = sliderValue;
    }
}



@end
