//
//  BIRKeyName.h
//  IRLib
//
//  Created by ldj on 2016/5/15.
//  Copyright (c) 2016年 lin. All rights reserved.
//
//  主要給 webGetKeyName 使用
//

#import <Foundation/Foundation.h>

@interface BIRKeyName : NSObject

@property NSString *type;          // 是哪一類的remote 使用的
@property NSString *keyId;         // the key id     ex : IR_KEY_PLAY
@property NSString *name;          // key name       ex : 播放


-(instancetype) initWithType : (NSString*) typeID
                    andKeyID : (NSString*) key
                     andName : (NSString*) n;

@end
