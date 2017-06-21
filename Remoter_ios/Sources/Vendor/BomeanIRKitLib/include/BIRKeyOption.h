//
//  KeyOption.h
//  IRLib
//
//  Created by ldj on 2015/6/4.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRKeyOption : NSObject

// 目前的 option index
@property int currentOption;
// 所有的 option
@property (retain) NSMutableArray *options;
// key 是否enable(目前無作用. 總是YES)
@property  BOOL enable;

-(id) init;

-(id) initP:(int) optionIndex Options : (NSMutableArray*) option;

@end
