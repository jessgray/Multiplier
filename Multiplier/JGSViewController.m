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
    _gameStarted = NO;
    _numTurns = 0;
    _numCorrectAnswers = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)answerSelected:(id)sender {
    
    // Unhide the real answer to the problem and the button that says 'next'
    _resultLabel.hidden = NO;
    _startButtonLabel.hidden = NO;
    
    // Hide the answer bar and the '?'
    _hiddenAnswerLabel.hidden = YES;
    _answerSelectorBar.hidden = YES;
    _selectAnswerLabel.hidden = YES;
    
    // Show either correct or incorrect based on user's selection
    if([[self.answerSelectorBar titleForSegmentAtIndex:self.answerSelectorBar.selectedSegmentIndex] isEqualToString:self.resultLabel.text]) {
        _answerCorrectnessLabel.text = @"Correct!";
        _answerCorrectnessLabel.hidden = NO;
        _numCorrectAnswers++;
        
        [_numCorrectQuestionsLabel setText:[NSString stringWithFormat:@"%i", _numCorrectAnswers]];
    } else {
        _answerCorrectnessLabel.text = @"Incorrect";
        _answerCorrectnessLabel.hidden = NO;
    }
    
    // Increment total number of questions answered
    _numTurns++;
    
    // Set progress bar accordingly
    [_numTotalQuestionsLabel setText:[NSString stringWithFormat:@"%i", _numTurns]];
    [_progressBar setProgress:(0.1*_numTurns) animated: YES];
    
}

/*
 * - Generates two random numbers between 1 and 15 and displays them as multiplicands on the screen
 * - Multiplies those numbers together to obtain a result, which is the correct answer
 * - Generates three fake answers all within a range of +- 5 of the result
 * - Displays all four answers on the screen
 */
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
    [_answerSelectorBar setSelectedSegmentIndex: -1];
    
    // Check if game has been started, is ending, or is in the middle of game play
    if(!self.gameStarted) {
        
        // Game has now started
        _gameStarted = YES;
        
        // Hide items only viewed at the very beginning or end of game play
        _initialTitleLabel.hidden = YES;
        _gameOverLabel.hidden = YES;
        
        // Hide items that can only be seen once the user has answered a question
        _answerCorrectnessLabel.hidden = YES;
        _startButtonLabel.hidden = YES;
        
        // Unhide all other elements
        _progressBarBackground.hidden = NO;
        _multiplicationBackground.hidden = NO;
        _answerBackground.hidden = NO;
        _numCorrectQuestionsLabel.hidden = NO;
        _numTotalQuestionsLabel.hidden = NO;
        _slashLabel.hidden = NO;
        _correctQuestionsLabel.hidden = NO;
        _progressBar.hidden = NO;
        _firstMultiplierLabel.hidden = NO;
        _secondMultiplierLabel.hidden = NO;
        _multiplicationSignLabel.hidden = NO;
        _multiplicationBar.hidden = NO;
        _selectAnswerLabel.hidden = NO;
        _answerSelectorBar.hidden = NO;
        _hiddenAnswerLabel.hidden = NO;
        
        // Call function to generate the multiplcands, the result, and the answers
        [self GenerateNumbers];
        
        // Set progress bar initially
        [_progressBar setProgress:(0.1*_numTurns) animated: YES];
        [_numCorrectQuestionsLabel setText:[NSString stringWithFormat:@"%i", _numCorrectAnswers]];
        [_numTotalQuestionsLabel setText:[NSString stringWithFormat:@"%i", _numTurns]];
        
        // Change text on start button to be "Next"
        [_startButtonLabel setTitle:@"Next" forState:UIControlStateNormal];
        
    } else if(self.numTurns == kNumTurns) {
        
        // Set progress bar accordingly
        [_progressBar setProgress:(0.1*_numTurns) animated: YES];
        
        // Change text on start button to be "Reset"
        [_startButtonLabel setTitle:@"Reset" forState:UIControlStateNormal];
        
        // Reset game state in order for the game to be played over again
        _gameStarted = NO;
        _numTurns = 0;
        _numCorrectAnswers = 0;
        
        // Show that the game is over
        _gameOverLabel.hidden = NO;
        
        // Hide all other elements
        _progressBarBackground.hidden = YES;
        _multiplicationBackground.hidden = YES;
        _answerBackground.hidden = YES;
        _numCorrectQuestionsLabel.hidden = YES;
        _numTotalQuestionsLabel.hidden = YES;
        _slashLabel.hidden = YES;
        _correctQuestionsLabel.hidden = YES;
        _progressBar.hidden = YES;
        _firstMultiplierLabel.hidden = YES;
        _secondMultiplierLabel.hidden = YES;
        _multiplicationSignLabel.hidden = YES;
        _multiplicationBar.hidden = YES;
        _resultLabel.hidden = YES;
        _hiddenAnswerLabel.hidden = YES;
        _answerCorrectnessLabel.hidden = YES;
        _answerSelectorBar.hidden = YES;
        
    } else {
        
        // Show answer bar and the ?
        _answerSelectorBar.hidden = NO;
        _selectAnswerLabel.hidden = NO;
        _hiddenAnswerLabel.hidden = NO;
        
        // Hide the result, correct/incorrect field, and the start button since the user must select an answer first
        _resultLabel.hidden = YES;
        _answerCorrectnessLabel.hidden = YES;
        _startButtonLabel.hidden = YES;
        
        // Show new multiplicands and results
        [self GenerateNumbers];
    }
}

@end