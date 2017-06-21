//
//  BIRKeyItem.h
//  IRLib
//
//  Created by ldj on 2015/10/23.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIRKeyItem : NSObject

@property NSString *keyId;             // key id for 發碼使用
@property NSString *locationName;      // 地區名稱
@property NSString *name;              // 英文名稱

-(instancetype) initWithId:(NSString*)keyId locationName : (NSString*) lName andName :(NSString*) name;


@end

