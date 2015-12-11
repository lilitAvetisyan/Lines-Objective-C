//
//
//  Lines
//
//  Created by Lilit Avetisyan on 10/2/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "GameFieldModel.h"

@interface GameFieldView : UIView

@property CLCell fromCell; // where is the selected ball
@property BOOL isSelected;
@property GameFieldModel *game;
- (void) setBallSelectedToI:(int) i andJ: (int) j flag:(BOOL) f;

@end
