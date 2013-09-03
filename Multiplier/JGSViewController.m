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

@property BOOL gameStarted;                // flag for if game has started or not
@property NSInteger numTurns;              // number of turns that have been completed
@property NSInteger numCorrectAnswers;     // number of correctly answered questions


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
    
    //Unhide result label
    _resultLabel.hidden = NO;
    
    // Show either correct or incorrect based on user's selection
    if([[self.answerSelectorBar titleForSegmentAtIndex:self.answerSelectorBar.selectedSegmentIndex] isEqualToString:_resultLabel.text]) {
        _answerCorrectnessLabel.text = @"Correct!";
        _answerCorrectnessLabel.hidden = NO;
    } else {
        _answerCorrectnessLabel.text = @"Incorrect";
        _answerCorrectnessLabel.hidden = NO;
    }
        
}

-(NSArray *)GenerateNumbers {
    NSInteger num1;             // the first multiplicand
    NSInteger num2;             // the second multiplicand
    NSInteger result;           // the result of multiplying num1 * num2
    NSNumber *correctChoice;    // correct answer for the multiplication problem
    NSNumber *fake1;            // one fake answer to be stored in resArray
    NSNumber *fake2;            // second fake answer to be stored in resArray
    NSNumber *fake3;            // third fake answer to be stored in resArray
        
    // Generate both multiplicands and the result
    num1 = arc4random_uniform(15)+1;
    num2 = arc4random_uniform(15)+1;
    result = num1*num2;
    
    _resultLabel.text = [NSString stringWithFormat:@"%i", result];
    
    correctChoice = [NSNumber numberWithInteger:(num1*num2)];
    
    _firstMultiplierLabel.text = [NSString stringWithFormat:@"%i", num1];
    _secondMultiplierLabel.text = [NSString stringWithFormat:@"%i", num2];
    
    
    // Generate fake answers without duplicates
    do {
        fake1 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(5)+1))];
        fake2 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(5)+1))];
        fake3 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(5)+1))];

    } while (fake1 == fake2 || fake1 == fake3 || fake2 == fake3);
    
    // Store all answers into an array
    NSArray *resArray = [NSArray arrayWithObjects:fake1, fake2, fake3, correctChoice, nil];
    
    return resArray;
}

-(void)DisplayAnswers {
    
    NSInteger index0;
    NSInteger index1;
    NSInteger index2;
    NSInteger index3;
    
    do {
        index0 = arc4random_uniform(4);
        index1 = arc4random_uniform(4);
        index2 = arc4random_uniform(4);
        index3 = arc4random_uniform(4);
    } while (index0 == index1 || index0 == index2 || index0 == index3 || index1 == index2 || index1 == index3 || index2 == index3);
    
    NSArray *answers;
    answers = [self GenerateNumbers];
    
    [_answerSelectorBar setTitle:[NSString stringWithFormat:@"%@", answers[index0]] forSegmentAtIndex:0];
    [_answerSelectorBar setTitle:[NSString stringWithFormat:@"%@", answers[index1]] forSegmentAtIndex:1];
    [_answerSelectorBar setTitle:[NSString stringWithFormat:@"%@", answers[index2]] forSegmentAtIndex:2];
    [_answerSelectorBar setTitle:[NSString stringWithFormat:@"%@", answers[index3]] forSegmentAtIndex:3];
    
}

- (IBAction)startButtonClicked:(id)sender {
    
    // Check if game has been started in order to properly display items on the page
    if(!self.gameStarted) {
        self.gameStarted = YES;
        
        // hide title that is in the middle of the screen
        self.initialTitleLabel.hidden = YES;
        
        // unhide all elements except correctness label and result label
        self.titleLabel.hidden = NO;
        self.progressBar.hidden = NO;
        self.firstMultiplierLabel.hidden = NO;
        self.secondMultiplierLabel.hidden = NO;
        self.multiplicationSignLabel.hidden = NO;
        self.multiplicationBar.hidden = NO;
        self.answerSelectorBar.hidden = NO;
        
        [self DisplayAnswers];
        
        [self.answerSelectorBar setSelectedSegmentIndex: -1];
    
        // Change text on start button to be "Next"
        [self.startButtonLabel setTitle:@"Next" forState:UIControlStateNormal];
        
    } else if(self.numTurns == kNumTurns-1) {
        
        // Change text on start button to be "Reset"
        [self.startButtonLabel setTitle:@"Reset" forState:UIControlStateNormal];
        
        // Reset game state
        self.gameStarted = NO;
        self.numTurns = 0;
        self.numCorrectAnswers = 0;
        
        [self.answerSelectorBar setSelectedSegmentIndex: -1];
        
    } else {
        // Increment the number of turns that has been completed
        self.numTurns++;
        
        // Hide the result field and correct/incorrect field
        self.resultLabel.hidden = YES;
        self.answerCorrectnessLabel.hidden = YES;
        
        // Show new multiplicands and results
        [self DisplayAnswers];
        
        [self.answerSelectorBar setSelectedSegmentIndex: -1];
    }
}

@end