//
//  BIRVoiceSearchResultItem.h
//  IRLib
//
//  Created by ldj on 2015/10/23.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BIRTypeItem;
@class BIRKeyItem;
@class BIRBrandItemEx;

@interface BIRVoiceSearchResultItem : NSObject

@property BIRTypeItem *typeItem;
@property BIRBrandItemEx *brandItem;
@property BIRKeyItem *keyItem;

-(instancetype) initXXX : (BIRTypeItem*)t Brand : (BIRBrandItemEx*) b Key: (BIRKeyItem*) k;

@end
