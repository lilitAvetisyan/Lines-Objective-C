//
//  ViewController.h
//  Lines
//
//  Created by Lilit Avetisyan on 10/2/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameFieldView.h"
#import "GameFieldModel.h"

@interface ViewController : UIViewController

@property GameFieldModel* model1;
@property (weak, nonatomic) IBOutlet GameFieldView *gameField;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;

@end

