//
//  JGSViewController.m
//  Multiplier
//
//  Created by Jessica Smith on 9/2/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#define kNumTurns 10
#define kNumAnswers 4
#define kMaxMultiplier 15
#define kPlusMinusInterval 5

@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UIView *progressBarBackground;
@property (weak, nonatomic) IBOutlet UIView *multiplicationBackground;
@property (weak, nonatomic) IBOutlet UIView *answerBackground;
@property (weak, nonatomic) IBOutlet UILabel *hiddenAnswerLabel;

@property (weak, nonatomic) IBOutlet UILabel *numCorrectQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTotalQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *firstMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondMultiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplicationSignLabel;
@property (weak, nonatomic) IBOutlet UIView *multiplicationBar;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCorrectnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectAnswerLabel;
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
    self.progressBarBackground.hidden = YES;
    self.multiplicationBackground.hidden = YES;
    self.answerBackground.hidden = YES;
    self.numCorrectQuestionsLabel.hidden = YES;
    self.numTotalQuestionsLabel.hidden = YES;
    self.slashLabel.hidden = YES;
    self.gameOverLabel.hidden = YES;
    self.correctQuestionsLabel.hidden = YES;
    self.progressBar.hidden = YES;
    self.firstMultiplierLabel.hidden = YES;
    self.secondMultiplierLabel.hidden = YES;
    self.multiplicationSignLabel.hidden = YES;
    self.multiplicationBar.hidden = YES;
    self.resultLabel.hidden = YES;
    self.answerCorrectnessLabel.hidden = YES;
    self.selectAnswerLabel.hidden = YES;
    self.answerSelectorBar.hidden = YES;
    
    self.hiddenAnswerLabel.hidden = YES;
    
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
    self.startButtonLabel.hidden = NO;
    
    // Hide answer bar
    self.hiddenAnswerLabel.hidden = YES;
    self.answerSelectorBar.hidden = YES;
    self.selectAnswerLabel.hidden = YES;
    
    // Show either correct or incorrect based on user's selection
    if([[self.answerSelectorBar titleForSegmentAtIndex:self.answerSelectorBar.selectedSegmentIndex] isEqualToString:_resultLabel.text]) {
        _answerCorrectnessLabel.text = @"Correct!";
        _answerCorrectnessLabel.hidden = NO;
        _numCorrectAnswers++;
        [self.numCorrectQuestionsLabel setText:[NSString stringWithFormat:@"%i", self.numCorrectAnswers]];
    } else {
        _answerCorrectnessLabel.text = @"Incorrect";
        _answerCorrectnessLabel.hidden = NO;
    }
    
    // Increment total number of questions answered
    self.numTurns++;
    [self.numTotalQuestionsLabel setText:[NSString stringWithFormat:@"%i", self.numTurns]];
    
    // Set progress bar accordingly
    [_progressBar setProgress:(0.1*_numTurns) animated: YES];
    
}

-(void)GenerateNumbers {
    NSInteger num1;             // the first multiplicand
    NSInteger num2;             // the second multiplicand
    NSInteger result;           // the result of multiplying num1 * num2
    NSNumber *correctChoice;    // correct answer for the multiplication problem
    NSNumber *fake1;            // first fake answer to be stored in answerArray
    NSNumber *fake2;            // second fake answer to be stored in answerArray
    NSNumber *fake3;            // third fake answer to be stored in answerArray
    NSUInteger randIndex;       // random index of object in answerArray that is swapped when rearranging the array
    
    // Generate both multiplicands and the result
    num1 = arc4random_uniform(kMaxMultiplier)+1;
    num2 = arc4random_uniform(kMaxMultiplier)+1;
    result = num1*num2;
    correctChoice = [NSNumber numberWithInteger:(num1*num2)];
    
    // Update both multipliers as well as the result label
    _firstMultiplierLabel.text = [NSString stringWithFormat:@"%i", num1];
    _secondMultiplierLabel.text = [NSString stringWithFormat:@"%i", num2];
    _resultLabel.text = [NSString stringWithFormat:@"%i", result];
    
    // Generate three fake answers without duplicates
    do {
        fake1 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        fake2 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        fake3 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        
    } while ([fake1 intValue] == [fake2 intValue] || [fake1 intValue] == [fake3 intValue]|| [fake2 intValue] == [fake3 intValue] || [fake1 intValue] < 0 || [fake2 intValue] < 0 || [fake3 intValue] < 0);
    
    // Create array for answers to be stored in
    NSMutableArray *answerArray = [NSMutableArray arrayWithObjects:fake1, fake2, fake3, correctChoice, nil];

    // Rearrange the array randomly
    for(NSUInteger i=0; i < kNumAnswers; i++) {
        randIndex = arc4random_uniform(kNumAnswers);
        [answerArray exchangeObjectAtIndex:i withObjectAtIndex:randIndex];
    }
    
    // Display answers on the answer bar
    for(int i=0; i < kNumAnswers; i++) {
        [_answerSelectorBar setTitle:[NSString stringWithFormat:@"%@", answerArray[i]] forSegmentAtIndex:i];
    }
}

- (IBAction)startButtonClicked:(id)sender {
    
    // Make sure that no answers are selected
    [self.answerSelectorBar setSelectedSegmentIndex: -1];
    
    // Check if game has been started in order to properly display items on the page
    if(!self.gameStarted) {
        self.gameStarted = YES;
        
        // hide title that is in the middle of the screen
        self.initialTitleLabel.hidden = YES;
        self.answerCorrectnessLabel.hidden = YES;
        self.gameOverLabel.hidden = YES;
        self.startButtonLabel.hidden = YES;
        
        // unhide all elements except correctness label and result label
        self.progressBarBackground.hidden = NO;
        self.multiplicationBackground.hidden = NO;
        self.answerBackground.hidden = NO;
        self.numCorrectQuestionsLabel.hidden = NO;
        self.numTotalQuestionsLabel.hidden = NO;
        self.slashLabel.hidden = NO;
        self.correctQuestionsLabel.hidden = NO;
        self.progressBar.hidden = NO;
        self.firstMultiplierLabel.hidden = NO;
        self.secondMultiplierLabel.hidden = NO;
        self.multiplicationSignLabel.hidden = NO;
        self.multiplicationBar.hidden = NO;
        self.selectAnswerLabel.hidden = NO;
        self.answerSelectorBar.hidden = NO;
        self.hiddenAnswerLabel.hidden = NO;
        
        [self GenerateNumbers];
        
        [_progressBar setProgress:(0.1*_numTurns) animated: YES];
        [self.numCorrectQuestionsLabel setText:[NSString stringWithFormat:@"%i", self.numCorrectAnswers]];
        [self.numTotalQuestionsLabel setText:[NSString stringWithFormat:@"%i", self.numTurns]];
        
        // Change text on start button to be "Next"
        [self.startButtonLabel setTitle:@"Next" forState:UIControlStateNormal];
        
    } else if(self.numTurns == kNumTurns) {
        
        // Set progress bar accordingly
        [_progressBar setProgress:(0.1*_numTurns) animated: YES];
        
        // Change text on start button to be "Reset"
        [self.startButtonLabel setTitle:@"Reset" forState:UIControlStateNormal];
        
        // Reset game state for the next click
        self.gameStarted = NO;
        self.numTurns = 0;
        self.numCorrectAnswers = 0;
        
        // Unhide label that says the game is over
        self.gameOverLabel.hidden = NO;
        
        // Hide all elements except the reset button
        self.progressBarBackground.hidden = YES;
        self.multiplicationBackground.hidden = YES;
        self.answerBackground.hidden = YES;
        self.numCorrectQuestionsLabel.hidden = YES;
        self.numTotalQuestionsLabel.hidden = YES;
        self.slashLabel.hidden = YES;
        self.correctQuestionsLabel.hidden = YES;
        self.progressBar.hidden = YES;
        self.firstMultiplierLabel.hidden = YES;
        self.secondMultiplierLabel.hidden = YES;
        self.multiplicationSignLabel.hidden = YES;
        self.multiplicationBar.hidden = YES;
        self.resultLabel.hidden = YES;
        self.hiddenAnswerLabel.hidden = YES;
        self.answerCorrectnessLabel.hidden = YES;
        self.answerSelectorBar.hidden = YES;
    } else {
        
        // Show answer bar
        self.answerSelectorBar.hidden = NO;
        self.selectAnswerLabel.hidden = NO;
        self.hiddenAnswerLabel.hidden = NO;
        
        // Hide the result field and correct/incorrect field
        self.resultLabel.hidden = YES;
        self.answerCorrectnessLabel.hidden = YES;
        self.startButtonLabel.hidden = YES;
        
        // Show new multiplicands and results
        [self GenerateNumbers];
    }
}

@end