//
//  myHW.m
//  test_oc
//
//  Created by mingo on 2016/6/17.
//  Copyright © 2016年 bomeans. All rights reserved.
//

#import "myHW.h"
#import "BomeansConst.h"

@implementation myHW

// 使用你的方法送出bomeans irBlaster format data
//   return : 正常送出. 請return BIROK(0)
//  其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) sendData : (NSData*) irBlasterData
{
    return BIROK;
}


// 設備是否連接了
//  如有連接請回傳 BIROK(0) 其他為錯誤. 錯誤代碼可參考BomeansConst.h 中的BIRError
//   如為您的自訂代碼. 請大於 BIR_CustomerErrorBegin(0x40000000)
-(int) isConnection{
    return BIROK;
}

@end
