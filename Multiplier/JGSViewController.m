//
//  JGSViewController.m
//  Multiplier
//
//  Created by Jessica Smith on 9/2/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#define kNumTurns 10

@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *firstMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplicationSignLabel;
@property (weak, nonatomic) IBOutlet UIView *multiplicationBar;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCorrectnessLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSelectorBar;
- (IBAction)answerSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startButtonLabel;
- (IBAction)startButtonClicked:(id)sender;

@property BOOL gameStarted;                 // flag for if game has started or not
@property NSInteger numTurns;               // number of turns that have been completed
@property NSInteger numCorrectAnswers;      // number of correctly answered questions


@end

@implementation JGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Hide all elements initially except the start button and initial title for application
    self.titleLabel.hidden = YES;
    self.progressBar.hidden = YES;
    self.firstMultiplierLabel.hidden = YES;
    self.secondMultiplierLabel.hidden = YES;
    self.multiplicationSignLabel.hidden = YES;
    self.multiplicationBar.hidden = YES;
    self.resultLabel.hidden = YES;
    self.answerCorrectnessLabel.hidden = YES;
    self.answerSelectorBar.hidden = YES;
    
    // Set initial variables for game
    self.gameStarted = NO;
    self.numTurns = 0;
    self.numCorrectAnswers = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)answerSelected:(id)sender {
}

-(void)GenerateNumbers {

    
}

- (IBAction)startButtonClicked:(id)sender {
    
    // Check if game has been started in order to properly display items on the page
    if(!self.gameStarted) {
        self.gameStarted = YES;
        
        // hide title that is in the middle of the screen
        self.initialTitleLabel.hidden = YES;
        
        // unhide all elements except correctness label
        self.titleLabel.hidden = NO;
        self.progressBar.hidden = NO;
        self.firstMultiplierLabel.hidden = NO;
        self.secondMultiplierLabel.hidden = NO;
        self.multiplicationSignLabel.hidden = NO;
        self.multiplicationBar.hidden = NO;
        self.resultLabel.hidden = NO;
        self.answerSelectorBar.hidden = NO;
    
        // Change text on start button to be "Next"
        [self.startButtonLabel setTitle:@"Next" forState:UIControlStateNormal];
        
    } else if(self.numTurns == kNumTurns-1) {
        
        // Change text on start button to be "Reset"
        [self.startButtonLabel setTitle:@"Reset" forState:UIControlStateNormal];
        
        // Reset game state
        self.gameStarted = NO;
        self.numTurns = 0;
        self.numCorrectAnswers = 0;
        
    } else {
        // Increment the number of turns that has been completed
        self.numTurns++;
    }
}

@end