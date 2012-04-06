//
//  CalculatorViewController.m
//  Calculator 2
//
//  Created by Me on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL UserInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL UserEnteringSecondNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) int dotCounter;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize secondDisplay;
@synthesize UserInTheMiddleOfEnteringANumber;
@synthesize UserEnteringSecondNumber;
@synthesize brain = _brain;
@synthesize dotCounter;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    //NSString *digit = [sender currentTitle];
    //NSString *currentDisplayText = self.display.text;
    //NSString *newDisplayText = [currentDisplayText stringByAppendingFormat:digit];
    //self.display.text = newDisplayText;
    
    NSRange range = [[sender currentTitle] rangeOfString:@"."];
    NSString *digit = [sender currentTitle];
    
    for (int i = 0; i == 0; i++) {
    
        //check for two o more dots in a floating number;
        if (range.location == NSNotFound) {
            //no dot is entered
        } else 
        {
            dotCounter++;
            if (dotCounter > 1)
            {
                dotCounter--;
                break;
            }
        }
    
        if (self.UserInTheMiddleOfEnteringANumber) 
        {
            self.display.text = [self.display.text stringByAppendingFormat:digit];
            self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat:digit];
    
        } else { // user in the start;
            
            if ( dotCounter > 0) {
                self.display.text = @"0.";
                self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat:@" 0.", digit];
                
                
                self.UserInTheMiddleOfEnteringANumber = YES;
                
            } else {
                
                // Prevents "00000001" numbers
                if ([digit isEqualToString:@"0"]) {
                    break;
                } else {
                    self.display.text = digit;
                }
                
                if (UserEnteringSecondNumber) {
                    
                    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: @" "];
                    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: digit];
                }
                else {
                    
                    // Prevents "00000001" numbers
                    if ([digit isEqualToString:@"0"]) {
                        break;
                    } else {
                        self.secondDisplay.text = digit;
                    }
                    
                }
                
                self.UserInTheMiddleOfEnteringANumber = YES;
            }
        }
    }
}

- (IBAction)enterPressed
{    
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.UserInTheMiddleOfEnteringANumber = NO;
    self.UserEnteringSecondNumber = YES;
    dotCounter = 0;
    
    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat:@" Enter "];
}

- (IBAction)operationPressed:(UIButton *)sender
{   
    if (self.UserInTheMiddleOfEnteringANumber) [self enterPressed];
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
     self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: @" "];
    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: operation];
    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: @" "];
    
    
    
}

- (void)viewDidUnload 
{
    [self setSecondDisplay:nil];
    [super viewDidUnload];
}


- (IBAction)clear:(UIButton *)sender 
{
    self.display.text = @"0";
    self.secondDisplay.text = [self.secondDisplay.text stringByAppendingFormat: @" C "];
    dotCounter = 0;
    UserInTheMiddleOfEnteringANumber = NO;
        self.UserEnteringSecondNumber = YES;
    [self.brain pushOperand:0];
}

@end