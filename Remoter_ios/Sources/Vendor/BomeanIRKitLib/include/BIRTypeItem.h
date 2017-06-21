//
//  BIRTypeItem.h
//  IRLib
//
//  Created by ldj on 2015/6/16.
//  Copyright (c) 2015年 lin. All rights reserved.
//
//  用來記錄 http://www.bomeans.com/api_v2/getTypeList.php 取回的資料

#import <Foundation/Foundation.h>

@interface BIRTypeItem : NSObject

@property NSString *typeId;
@property NSString *locationName;
@property NSString *name;

-(instancetype) initWithId:(NSString*)theId locationName : (NSString*) lName andName :(NSString*) name;



@end
