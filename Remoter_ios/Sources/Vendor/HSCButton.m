//
//  HSCButton.m
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSCButton.h"

@interface HSCButton() <UIGestureRecognizerDelegate>

@end

@implementation HSCButton

@synthesize dragEnable;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIPanGestureRecognizer* tapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
    }
    return self;
}

-(IBAction)tapGestureAction:(UIPanGestureRecognizer*)sender{
    CGPoint location = [sender translationInView:[self superview]];
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(self.center.x + location.x, self.center.y + location.y)];
        
        [sender setTranslation:CGPointZero inView:[self superview]];
        //gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + location.x, gestureRecognizer.view.center.y + location.y);
        [self.superview bringSubviewToFront:self];
    }
    else if ([sender state] == UIGestureRecognizerStateEnded)
    {
        
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // if (!dragEnable) {
   //     return;
   // }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
    [self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   // if (!dragEnable) {
   //     return;
   // }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
