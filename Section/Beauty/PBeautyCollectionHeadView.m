//
//  PBeautyCollectionHeadView.m
//  PlayDrama
//
//  Created by hairong chen on 15/6/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyCollectionHeadView.h"

@implementation PBeautyCollectionHeadView

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self =[super initWithCoder:aDecoder]) {
       // self.boyBGView.backgroundColor = RGB(0x4cb17c, 1);
       // self.girlBGView.backgroundColor = RGB(0xe9ca5d, 1);
    }
    
    return self;
}

- (void)feframe
{
    CGRect bFrame           = self.boyBGView.frame;
    bFrame.origin.x         = 10;
    bFrame.size.width       = UIScreenWidth/2 -14;
    self.boyBGView.frame    = bFrame;
    
    CGRect gFrame           = self.girlBGView.frame;
    gFrame.origin.x         = self.boyBGView.frame.size.width +18;
    gFrame.size.width       = UIScreenWidth/2 -14;
    self.girlBGView.frame   = gFrame;
}

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Vertex3D;

/*
-(void)drawView:(GLView*)view
{
    static GLfloat rot = 0.0;
    static const Vertex3D vertices[]= {
        {0, -0.525731, 0.850651},
        // vertices[0]
        {0.850651, 0, 0.525731},
        // vertices[1]
        {0.850651, 0, -0.525731},
        // vertices[2]
        {-0.850651, 0, -0.525731},
        // vertices[3]
        {-0.850651, 0, 0.525731},
        // vertices[4]
        {-0.525731, 0.850651, 0},
        // vertices[5]
        {0.525731, 0.850651, 0},
        // vertices[6]
        {0.525731, -0.850651, 0},
        // vertices[7]
        {-0.525731, -0.850651, 0},
        // vertices[8]
        {0, -0.525731, -0.850651},
        // vertices[9]
        {0, 0.525731, -0.850651},
        // vertices[10]
        {0, 0.525731, 0.850651}
        // vertices[11]
    };
    static const Color3D colors[] = {
        {1.0, 0.0, 0.0, 1.0},        {1.0, 0.5, 0.0, 1.0},
        {1.0, 1.0, 0.0, 1.0},        {0.5, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.0, 1.0},        {0.0, 1.0, 0.5, 1.0},
        {0.0, 1.0, 1.0, 1.0},        {0.0, 0.5, 1.0, 1.0},
        {0.0, 0.0, 1.0, 1.0},        {0.5, 0.0, 1.0, 1.0},
        {1.0, 0.0, 1.0, 1.0},        {1.0, 0.0, 0.5, 1.0}
    };
    
    static const GLubyte icosahedronFaces[] = {
        1, 2, 6,        1, 7, 2,       3, 4, 5,       4, 3, 8,
        6, 5, 11,       5, 6, 10,      9, 10, 2,      10, 9, 3,
        7, 8, 9,        8, 7, 0,       11, 0, 1,      0, 11, 4,
        6, 2, 10,       1, 6, 11,      3, 5, 10,      5, 4, 11,
        2, 7, 9,        7, 1, 0,       3, 9, 8,       4, 8, 0,
    };
    
    glLoadIdentity();
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    for (int i = 1; i <= 30; i++)    {
        glLoadIdentity();
        glTranslatef(0.0f,-1.5,-3.0f * (GLfloat)i);
        glRotatef(rot, 1.0, 1.0, 1.0);
        glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
    }
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

typedef struct {
    Vertex3D v1;
    Vertex3D v2;
    Vertex3D v3;
    
} Triangle3D;
*/


@end