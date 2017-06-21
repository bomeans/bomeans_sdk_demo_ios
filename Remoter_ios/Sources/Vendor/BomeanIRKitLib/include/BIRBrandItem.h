//
//  BIRBrandItem.h
//  IRLib
//
//  Created by ldj on 2015/6/16.
//  Copyright (c) 2015年 lin. All rights reserved.
//
//  紀錄 廠牌 id 跟內容

#import <Foundation/Foundation.h>

@interface BIRBrandItem : NSObject

@property NSString* brandId;                // id for pass to WebApi
@property NSString* locationName;           // 地區名稱 example 新力 in tw
@property NSString* name;                   // 英文名稱 example SONY

-(instancetype) initWithId:(NSString*)theId locationName : (NSString*) lName andName :(NSString*) name;

@end


// this class for BIRVoiceSearchResultItem use
@interface BIRBrandItemEx : BIRBrandItem

@property NSString *typeId;

-(instancetype) initWithId:(NSString*)theId
             locationName : (NSString*) lName
                  andName :(NSString*) name
                   typeID :(NSString*) typeId;

@end