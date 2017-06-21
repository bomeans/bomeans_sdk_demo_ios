//
//  BIRGUIFeature.h
//  IRLib
//
//  Created by ldj on 2015/6/9.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRGUIFeature : NSObject

@property (readonly) int displayType; //=Display.NO;
@property (readonly) BOOL RTC; // = false;
@property (readonly) int timerMode; // = 0;
@property (readonly) BOOL timerCountDown; // = false;
@property (readonly) BOOL timerClock; // = false;



-(id) init;

-(id) initX:(int) type
        RTC:(BOOL) rtc
       Mode:(int) m
  CountDown:(BOOL) down
     Clock :(BOOL) clock;


@end
