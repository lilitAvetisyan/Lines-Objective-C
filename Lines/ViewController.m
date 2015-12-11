//
//  ViewController.m
//  Lines
//
//  Created by Lilit Avetisyan on 10/2/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    unsigned int playerScore;
    unsigned int highScore;
}
@end

@implementation ViewController
@synthesize model1;
- (void)viewDidLoad
{
    [super viewDidLoad];
    srandom((unsigned)time(NULL));
    model1 = [[GameFieldModel alloc] init];
    [self newGame];
    playerScore = [self.playerScoreLabel.text intValue];
    playerScore = 0;
    highScore = [self.highScoreLabel.text intValue];
    highScore = 0;
    self.playerScoreLabel.text=[NSString stringWithFormat:@"%d", playerScore];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) newGame
{
    playerScore = 0;
    [self.playerScoreLabel setText:[NSString stringWithFormat:@"%d", playerScore]];
    [model1 newGameWith:GameStartWith];
    [self.gameField setIsSelected:FALSE];
    [self.gameField setGame:model1];
    [self.gameField setNeedsDisplay];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int i, j;
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.gameField)
    {
        int cellSize = self.gameField.frame.size.height/FrameSize;
        CGPoint P1 = [touch locationInView:self.gameField];
        i = P1.y/cellSize ; // row
        j = P1.x/cellSize ; // column
        if([self.gameField isSelected])
        {
            switch ([model1 getTestCellFromI:i+1 andJ:j+1])
            {
                case 0:
                    [self.gameField setBallSelectedToI:i andJ:j flag:FALSE];
                    //Player changed his mind
                    break;
                case BUSY_CELL:
                    [model1 makeWaysFromI:i andJ:j];
                    [self.gameField setBallSelectedToI:i andJ:j flag:TRUE];
                    //Player chose another ball
                    break;
                case EMPTY_CELL:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You cannot go here"
                                             message:@"Try another cell"
                                             delegate:self
                                             cancelButtonTitle:@"Okay"
                                             otherButtonTitles:nil];
                    [alert show];
                }
                    break;
                default:
                    [model1 makeStepsi:i j:j];
                    
                    [self.gameField setBallSelectedToI:i andJ:j flag:FALSE];
                    int k = [model1 moveBall];
                    if (k)
                    {
                        playerScore += 5 * k;
                        [self.playerScoreLabel setText:[NSString stringWithFormat:@"%d", playerScore]];
                       [model1 removeLines:k];
                    }
                    else
                    {
                        if ([model1 dropNextBalls])
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game over"
                                                     message:[NSString stringWithFormat:@"Your score:%d", playerScore]
                                                     delegate:self
                                                     cancelButtonTitle:@"Okay"
                                                     otherButtonTitles:nil];
                            [alert show];
                            if (playerScore > highScore)
                            {
                                self.highScoreLabel.text = [NSString stringWithFormat:@"%i", playerScore];
                            }
                            [self newGame];
                        }
                    }
                    [self.gameField setGame:model1];
                    [self.gameField setNeedsDisplay];
                break;
            }
        }
        else
        {
            if ([model1 getCellFromI:i andJ:j]) // player chose a ball
            {
                [model1 makeWaysFromI:i andJ:j];
                [self.gameField setBallSelectedToI:i andJ:j flag:true];
            }
        }
    }
}

- (IBAction)restartButton:(UIButton *)sender
{
    [self newGame];
}
@end
