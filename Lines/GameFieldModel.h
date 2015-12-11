//
//  Model.h
//  Lines
//
//  Created by Lilit Avetisyan on 10/3/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameFieldModel : NSObject

@property int length;
-(CLPoint) getStepFromI: (int) ii;
- (int) getCellFromI: (int) ii andJ: (int) jj;
- (int) getTestCellFromI: (int) ii andJ: (int) jj;
- (void) makeWaysFromI:(int) ii andJ:(int) jj;
- (void) makeStepsi:(int) ii j:(int) jj;
- (int) moveBall;
- (void) removeLines: (int) k;
- (BOOL) dropNextBalls;
- (CLCell) getNextFrom: (int) i;
- (void) newGameWith: (int) n;

@end
