//
//  BIRRemoteUID.h
//  IRLib
//
//  Created by ldj on 2016/1/26.
//  Copyright (c) 2016年 lin. All rights reserved.
//
//  智慧選碼的結果.
//  使用此BIRRemoteUID 中的三個id 可建立一個remote 
//
#import <Foundation/Foundation.h>

@interface BIRRemoteUID : NSObject

@property NSString *typeID;     // type id
@property NSString *brandID;    // brand id
@property NSString *modelID;    // model id   這三個id 用來建立一個remote


-(instancetype) initWithType : (NSString*)type
                       brand : (NSString*)brand
                       model : (NSString*)model;

@end

