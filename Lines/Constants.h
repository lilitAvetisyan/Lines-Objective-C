//
//  Header.h
//  Lines
//
//  Created by Lilit Avetisyan on 10/2/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define GameStartWith 5 // on the board appear 5 balls and 3 future balls
#define FrameSize 9 // after 13 there are not initialized ballz
#define BallNum 7
#define NewBallNum 3
#define Combination 5
#define BUSY_CELL 81
#define EMPTY_CELL 82

struct CLPoint
{
    int i;
    int j;
};
typedef struct CLPoint CLPoint;

struct CLCell
{
    int c;
    int i;
    int j;
};
typedef struct CLCell CLCell;
#endif /* Header_h */
