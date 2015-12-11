//
//  Model.m
//  Lines
//
//  Created by Lilit Avetisyan on 10/3/15.
//  Copyright © 2015 Lilit Avetisyan. All rights reserved.
//

#import "GameFieldModel.h"

@implementation GameFieldModel
{
    CLPoint emptyCells[FrameSize*FrameSize]; // 81
    int testCells[FrameSize+2][FrameSize+2]; // is used to check the neighbourhood of the current ball
    CLPoint fullLines[FrameSize*FrameSize];
    unsigned int cells[FrameSize][FrameSize]; // the array representing game field
    CLCell nextBalls[NewBallNum]; // array of the next balls, appearing on the next step
    CLPoint steps[FrameSize*FrameSize];
}

@synthesize length;

- (id) init
{
    self = [super init];
    if (self)
    {
        [self initTestCells];
    }
    return self;
}

- (void) initTestCells
{
    for (int i = 0; i < FrameSize+1; i++)
    {
        testCells[i][0] = BUSY_CELL;
        testCells[FrameSize+1][i] = BUSY_CELL;
        testCells[FrameSize+1-i][FrameSize+1] = BUSY_CELL;
        testCells[0][FrameSize+1-i] = BUSY_CELL;
    }
}

- (void) removeLines: (int) k // deletes the line segment wich is a combination
{
    int i;
    for (i = 0; i < k; i++)
    {
        cells[fullLines[i].i][fullLines[i].j] = 0;
    }
}

-(CLPoint) getStepFromI: (int) ii
{
    return steps[ii];
}

- (CLCell) getNextFrom: (int) i
{
    return nextBalls[i];
}

- (int) getCellFromI: (int) ii andJ: (int) jj
{
    return cells[ii][jj];
}

- (int) getTestCellFromI: (int) ii andJ: (int) jj
{
    return testCells[ii][jj];
}

- (void) newGameWith: (int) n
{
    for (int i = 0; i < FrameSize; i++)
    {
        for (int j = 0; j < FrameSize; j++)
        {
            cells[i][j] = 0;
        }
    }
    int k = [self setEmptyCells];
    int l = 0;
    for (int i = 0; (i < n) && (k > 0); i++)
    {
        int j = random()%k;
        int m = [self dropBallToI:emptyCells[j].i andJ:emptyCells[j].j withColor:random()%BallNum+1];
        if (m)
        {
            [self removeLines:m];
            l++;
            if (l < 100)
            {
                i-=m;
                k = [self setEmptyCells];
            }
        }
        else
        {
            emptyCells[j] = emptyCells[k-1];
            k--;
        }
    }
    [self setNextBalls];
}

- (int) setEmptyCells // returns the number of emty cells, if it is not 0 then it also creates an array containing the coordinates of the empty cells
{
    int k = 0;
    for (int i = 0; i < FrameSize; i++)
    {
        for (int j = 0; j < FrameSize; j++)
        {
            if (cells[i][j] == 0)
            {
                emptyCells[k].i = i;
                emptyCells[k].j = j;
                k++;
            }
        }
    }
    return k;
}

- (void) makeWaysFromI:(int) ii andJ:(int) jj // finds the shortest path, by fiiling empty cells with numbers strating from 1, then it finds the shortest path by finding the shortest number sequence
{
    // now each cell is either bussy cell or empty cell
    for (int i = 0; i < FrameSize; i++)
    {
        for (int j = 0; j < FrameSize; j++)
        {
            if (cells[i][j])
            {
                testCells[i+1][j+1] = BUSY_CELL;
            }
            else
            {
                testCells[i+1][j+1] = EMPTY_CELL;
            }
        }
    }
    testCells[ii+1][jj+1] = 0;
    BOOL flag;
    int k = 0;
    // fills the empty cells with numbers
    do
    {
        flag = FALSE;
        for (int i = 1; i < FrameSize+1; i++)
        {
            for (int j = 1; j < FrameSize+1; j++)
            {
                if (testCells[i][j] == k)
                {
                    flag = TRUE;
                    if (testCells[i][j+1] == EMPTY_CELL)
                    {
                        testCells[i][j+1] = k + 1;
                    }
                    if (testCells[i+1][j] == EMPTY_CELL)
                    {
                        testCells[i+1][j] = k + 1;
                    }
                    if (testCells[i][j-1] == EMPTY_CELL)
                    {
                        testCells[i][j-1] = k + 1;
                    }
                    if (testCells[i-1][j] == EMPTY_CELL)
                    {
                        testCells[i-1][j] = k + 1;
                    }
                }
            }
        }
        if (flag)
        {
            k = k + 1;
        }
    } while (flag);
}

- (void) makeStepsi:(int) ii j:(int) jj // takes the array steps and fills it with the cells which form the shortest path
{
    CLPoint dir[4] = {0, 1, 1, 0, 0, -1, -1, 0}; // moves only in these 4 directions, by just one step
    int ki = ii+1;
    int kj = jj+1;
    steps[testCells[ii + 1][jj + 1]].i = ii;
    steps[testCells[ii + 1][jj + 1]].j = jj;
    for (int i = testCells[ii + 1][jj + 1]; i > 0; i--)
    {
        for (int j = 0; j < 4; j++)
        {
            if (i == (testCells[ki+dir[j].i][kj+dir[j].j] + 1))
            {
                ki = ki+dir[j].i;
                kj = kj + dir[j].j;
                steps[testCells[ki][kj]].i = ki-1;
                steps[testCells[ki][kj]].j = kj-1;
                j = 4;
            }
        }
    }
    length = testCells[ii + 1][jj + 1];
}

- (BOOL) dropNextBalls
// adds the next 3 balls to the game field, considering the following cases
// case1: when newly added ball(s) create a combination
// case2: when the player drops his ball on the place of the upcomin ball
// case3: e.g. there are  places to add new balls, after adding them some more place is available,
//        then the remaining balls find their places on the game field
// in the end, the funstion returns BOOL, whether or not there is any empty cell remaining
{
    int j = 0, k;
    for (int i = 0; i < NewBallNum; i++)
    {
        if (nextBalls[i].c)
        {
            if (cells[nextBalls[i].i][nextBalls[i].j])
            {
                j = nextBalls[i].c;
            }
            else
            {
                k = [self dropBallToI:nextBalls[i].i andJ:nextBalls[i].j withColor:nextBalls[i].c];
                if (k)
                {
                    [self removeLines:k];
                }
            }
        }
        else
        {
            k = [self setEmptyCells];
            if (k)
            {
                k = random()%k;
                k = [self dropBallToI:emptyCells[k].i andJ:emptyCells[k].j withColor:random()%BallNum+1];
                if (k)
                {
                    [self removeLines:k];
                }
            }
        }
    }
    if (j)
    {
        k = [self setEmptyCells];
        if (k)
        {
            k = random()%k;
            k = [self dropBallToI:emptyCells[k].i andJ:emptyCells[k].j withColor:j];
            if (k)
            {
                [self removeLines:k];
            }
        }
    }
    [self setNextBalls];
    return (nextBalls[0].c == 0);
}

- (int) moveBall
{
    int k = 0;

    k = cells[steps[0].i][steps[0].j];
    cells[steps[0].i][steps[0].j] = 0;
    k = [self dropBallToI:steps[length].i andJ:steps[length].j withColor:k];
    return k;
}

// ii, jj, and cc are used for checking the identity of the ball
// this function checks the neighbourhood the current ball in all the possible directions
// as soon as it find a line segment consisting of 5 or more ball of the same color
// it returns the coordinates of those to the array fulllines
- (int) dropBallToI:(int) ii andJ:(int) jj withColor:(int) cc
{
    CLPoint dir[8] = {-1, -1, 0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0}; // used to go in any direction by just one step
    // (-1, -1) goes south-west diagonally
    // (0, -1) goes west
    // (1, -1) goes north-west diagonally
    // (1, 0) goes north
    // (1, 1) goes north-east diagonally
    // (0, 1) goes east
    // (-1, 1) goes east-south diagonally
    // (-1, 0) goes south
    int k = 0;
    int n[8]; // balls in the current direction
    
    cells[ii][jj] = cc;
    if (cc) // takes the current balls color and starts the count
    {
        for (int i = 0; i < 8; i++)
        {
            n[i] = 0;
        }
        // so basically in the neighborhood there is either a color of a "BUSY_CELL"
        for (int i = 0; i < FrameSize; i++)
        {
            for (int j = 0; j < FrameSize; j++)
            {
                if (cells[i][j] == cc)
                {
                    testCells[i+1][j+1] = cc;
                }
                else
                {
                    testCells[i+1][j+1] = BUSY_CELL;
                }
            }
        }
        // counting the number of the same-colored balls in the given/same direction
        for (int i = 0; i < 8; i++)
        {
            int j = 1;
            while (testCells[ii+1+j*dir[i].i][jj+1+j*dir[i].j] == cc)
            {
                n[i]++;
                j++;
            }
        }
        // if the line segment is less then 4 balls in a row then we inittialize the array with zeros
        for (int i = 0; i < Combination-1; i++)
        {
            if ((n[i] + n[i+Combination-1]) < Combination-1)
            {
                n[i] = 0;
                n[i+Combination-1] = 0;
            }
        }
        // if there is a line segment of same-colored
        for (int i = 0; i < FrameSize-1; i++)
        {
            for (int j = 0; j < n[i]; j++)
            {
                k++;
                fullLines[k].i = ii+(j+1) * dir[i].i;
                fullLines[k].j = jj+(j+1) * dir[i].j;
            }
        }
        // if there is a line consisting of at least 4 same colored balls then we add our current ball and now we have a real combination
        if (k)
        {
            k++;
            fullLines[0].i=ii;
            fullLines[0].j=jj;
        }
    }
    return k;
}

- (void) setNextBalls
{
    int level = BallNum;
    
    int k = [self setEmptyCells];
    for (int i = 0; i < NewBallNum; i++)
    {
        nextBalls[i].c = 0;
    }
    for (int i = 0; (i < NewBallNum) && (k > 0); i++) // as far as there are empty cells
    {
        nextBalls[i].c = random()%level + 1;
        int n = random()%k;
        nextBalls[i].i = emptyCells[n].i;
        nextBalls[i].j = emptyCells[n].j;
        emptyCells[n] = emptyCells[k - 1];
        k--;
    }
     // takes an empty cell fills it with a ball, now it is not an empty cell
     // now the array of empty cells is reduced by one, line 368,
     // and the number of empty cells, k, is also decreased line 369
}
@end
