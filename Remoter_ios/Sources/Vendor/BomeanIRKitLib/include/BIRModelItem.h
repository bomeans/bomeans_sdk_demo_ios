//
//  BIRModelItem.h
//  IRLib
//
//  Created by ldj on 2015/6/16.
//  Copyright (c) 2015年 lin. All rights reserved.
//
//  由 webGetRemoteModelList 回傳的資料
#import <Foundation/Foundation.h>

@interface BIRModelItem : NSObject

@property NSString *model;   // 遙控器ID
@property NSString *machineModel; //此遙控器可以控制的電器型號, 多筆資料石以逗號分開
@property NSString *country; // 區域（語言）代碼
@property NSString *releaseTime; // 遙控器登錄時間

-(instancetype) initWithModel : (NSString*)a_model
                 machineModel : (NSString*)a_machine_model
                      country : (NSString*)a_country
                  releaseTime : (NSString*)a_releaseTime;

@end
