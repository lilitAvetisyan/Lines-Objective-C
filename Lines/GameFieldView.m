//
//
//  Lines
//
//  Created by Lilit Avetisyan on 10/2/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import "GameFieldView.h"

@implementation GameFieldView

{
    CGImageRef image[BallNum + 1];
}

@synthesize isSelected, fromCell;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initGameImages];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageRect;
    CLCell nextBall;
    CGContextRef context=UIGraphicsGetCurrentContext();
    int cellSize=self.frame.size.height/FrameSize;
    imageRect.size = CGSizeMake(cellSize, cellSize); // transforms the uiview into a 9 by 9 table
    for (int i = 0; i < FrameSize; i++)
    {
        for (int j = 0; j < FrameSize; j++)
        {
            imageRect.origin = CGPointMake(cellSize*j, cellSize*i);
            CGContextDrawImage(context, imageRect, image[0]);
            if ([self.game getCellFromI:i andJ:j])
            {
                CGContextDrawImage(context, imageRect, image[[self.game getCellFromI:i andJ:j]]);
            }
            
        }
    }
        
    if (isSelected) // if the current cell is selected, it is ezragcvel with red color
    {
        CGContextSetLineWidth(context, 3.0);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        imageRect.origin = CGPointMake(cellSize*fromCell.j, cellSize*fromCell.i);
        CGContextAddRect(context, imageRect);
        CGContextStrokePath(context);
    }
    
    imageRect.size = CGSizeMake(cellSize/2, cellSize/2);

    for (int i = 0; i < NewBallNum; i++)
    {
        nextBall = [self.game getNextFrom:i];
        if (nextBall.c)
        {
            imageRect.origin = CGPointMake(cellSize/(4)+cellSize*nextBall.j, cellSize/(4)+cellSize*nextBall.i); // takes the quarter of the cell and fills it with the image, thus we see a smaller image while we used the same as for the others
            CGContextDrawImage(context, imageRect, image[nextBall.c]);
        }
    }

}

- (void)getImageForGame:(int)i // fills the view with images from 0-8
{
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.png", i];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    image[i]=CGImageRetain(img.CGImage);
}

-(void) setBallSelectedToI:(int) i andJ: (int) j flag:(BOOL) f
{
    isSelected = f;
    fromCell.c = [self.game getCellFromI:i andJ:j];
    fromCell.i = i;
    fromCell.j = j;
    [self setNeedsDisplay];
}

- (void) initGameImages
{
    for (int i = 0; i < BallNum+1; i++)
    {
        [self getImageForGame:i];
    }
}

@end
