//
//  myHW.h
//  test_oc
//
//  Created by mingo on 2016/6/17.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIRIRBlaster.h"

@interface myHW : NSObject<BIRIRBlaster>

-(int) sendData : (NSData*) irBlasterData;
-(int) isConnection;


@end
