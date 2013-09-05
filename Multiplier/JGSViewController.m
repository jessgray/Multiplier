//
//  JGSViewController.m
//  Multiplier
//
//  Created by Jessica Smith on 9/2/13.
//  Copyright (c) 2013 Jessica Smith. All rights reserved.
//

#import "JGSViewController.h"
#define kNumTurns 10                // total number of turns/questions the user answers
#define kNumAnswers 4               // total number of answers to choose from
#define kMaxMultiplier 15           // the range of numbers for the multiplcands (a number between 1 - 15)
#define kPlusMinusInterval 5        // the +- interval in which all fake answers must be from the real answer

@interface JGSViewController ()
@property (weak, nonatomic) IBOutlet UIView *progressBarBackground;         // background area of the progress bar 
@property (weak, nonatomic) IBOutlet UIView *multiplicationBackground;      // background area of the multiplication problem 
@property (weak, nonatomic) IBOutlet UIView *answerBackground;              // background area of the answer section 

@property (weak, nonatomic) IBOutlet UILabel *numCorrectQuestionsLabel;     // label that denotes the total number of correct questions the user has answered
@property (weak, nonatomic) IBOutlet UILabel *numTotalQuestionsLabel;       // label that denotes the total number of questions that the user has answered
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;                   // the / that separates the total number of of correct questions & number of questions answered
@property (weak, nonatomic) IBOutlet UILabel *correctQuestionsLabel;        // label that says "questions correctly answered"
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;           // progress bar element that shows the user's progress

@property (weak, nonatomic) IBOutlet UILabel *initialTitleLabel;            // label that contains the title for the application when it starts up
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;                // label that says the "You're Done!" when the user has answered 10 questions

@property (weak, nonatomic) IBOutlet UILabel *firstMultiplierLabel;         // label that denotes the first multiplicand
@property (weak, nonatomic) IBOutlet UILabel *secondMultiplierLabel;        // label that denotes the second multiplicand
@property (weak, nonatomic) IBOutlet UILabel *multiplicationSignLabel;      // the 'x' that denotes the problem is a multplication problem
@property (weak, nonatomic) IBOutlet UIView *multiplicationBar;             // the white bar that separates the multiplication problem from the result
@property (weak, nonatomic) IBOutlet UILabel *hiddenAnswerLabel;            // the ? that is shown before the user answers the problem
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;                  // label that denotes the result of the multiplication problem

@property (weak, nonatomic) IBOutlet UILabel *selectAnswerLabel;            // label that says 'Select an answer'
@property (weak, nonatomic) IBOutlet UILabel *answerCorrectnessLabel;       // label that says either "Correct!" or "Incorrect" when the user has chosen an answer
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSelectorBar; // the divided selection bar that contains 4 answers for the user to choose from
- (IBAction)answerSelected:(id)sender;                                      // action triggered when the user chooses something from the answer bar
@property (weak, nonatomic) IBOutlet UIButton *startButtonLabel;            // the button 'start', 'next', and 'reset' button
- (IBAction)startButtonClicked:(id)sender;                                  // action triggered when the user presses the start button

@property BOOL gameStarted;                                                 // flag for if game has started or not
@property NSInteger numTurns;                                               // number of turns that have been completed
@property NSInteger numCorrectAnswers;                                      // number of correctly answered questions

@end

@implementation JGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    // Unhide the real answer to the problem and the button that says 'next'
    _resultLabel.hidden = NO;
    self.startButtonLabel.hidden = NO;
    
    // Hide the answer bar and the '?'
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
    
    // Set progress bar accordingly
    [self.numTotalQuestionsLabel setText:[NSString stringWithFormat:@"%i", self.numTurns]];
    [_progressBar setProgress:(0.1*_numTurns) animated: YES];
    
}

-(void)GenerateNumbers {
    NSInteger num1, num2;               // the first and second multiplicand
    NSInteger result;                   // the result of multiplying num1 * num2
    NSNumber *correctChoice;            // correct answer for the multiplication problem (identical to result)
    NSNumber *fake1, *fake2, *fake3;    // fake answers to be stored in answerArray
    NSUInteger randIndex;               // random index of object in answerArray that is swapped when rearranging the array
    
    // Generate both multiplicands as random numbers between 1-15 and then calculate the result
    num1 = arc4random_uniform(kMaxMultiplier)+1;
    num2 = arc4random_uniform(kMaxMultiplier)+1;
    result = num1*num2;
    correctChoice = [NSNumber numberWithInteger:(num1*num2)];
    
    // Update both multipliers as well as the result label
    _firstMultiplierLabel.text = [NSString stringWithFormat:@"%i", num1];
    _secondMultiplierLabel.text = [NSString stringWithFormat:@"%i", num2];
    _resultLabel.text = [NSString stringWithFormat:@"%i", result];
    
    // Generate three fake answers without duplicates, all within the range -+5 + result. Ensure there are no negatives or zero values
    do {
        fake1 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        fake2 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        fake3 = [NSNumber numberWithInteger:(result + pow(-1, arc4random_uniform(2))*(arc4random_uniform(kPlusMinusInterval)+1))];
        
    } while ([fake1 intValue] == [fake2 intValue] || [fake1 intValue] == [fake3 intValue]|| [fake2 intValue] == [fake3 intValue] ||
             [fake1 intValue] <= 0 || [fake2 intValue] <= 0 || [fake3 intValue] <= 0);
    
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
    
    // Check if game has been started, is ending, or is in the middle of game play
    if(!self.gameStarted) {
        
        // Game has now started
        self.gameStarted = YES;
        
        // Hide items only viewed at the very beginning or end of game play
        self.initialTitleLabel.hidden = YES;
        self.gameOverLabel.hidden = YES;
        
        // Hide items that can only be seen once the user has answered a question
        self.answerCorrectnessLabel.hidden = YES;
        self.startButtonLabel.hidden = YES;
        
        // Unhide all other elements
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
        
        // Call function to generate the multiplcands, the result, and the answers
        [self GenerateNumbers];
        
        // Set progress bar initially
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
        
        // Reset game state in order for the game to be played over again
        self.gameStarted = NO;
        self.numTurns = 0;
        self.numCorrectAnswers = 0;
        
        // Show that the game is over
        self.gameOverLabel.hidden = NO;
        
        // Hide all other elements
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
        
        // Show answer bar and the ?
        self.answerSelectorBar.hidden = NO;
        self.selectAnswerLabel.hidden = NO;
        self.hiddenAnswerLabel.hidden = NO;
        
        // Hide the result, correct/incorrect field, and the start button since the user must select an answer first
        self.resultLabel.hidden = YES;
        self.answerCorrectnessLabel.hidden = YES;
        self.startButtonLabel.hidden = YES;
        
        // Show new multiplicands and results
        [self GenerateNumbers];
    }
}

@end