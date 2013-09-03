//
//  JGSViewController.m
//  Multiplier
//
//  Created by Jessica Smith on 9/2/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"

@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *firstMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplicationSignLabel;
@property (weak, nonatomic) IBOutlet UIView *multiplicationBar;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialTitleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSelectorBar;
- (IBAction)answerSelector:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startButtonLabel;
- (IBAction)startButton:(id)sender;

@end

@implementation JGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)answerSelector:(id)sender {
}
- (IBAction)startButton:(id)sender {
}
@end
