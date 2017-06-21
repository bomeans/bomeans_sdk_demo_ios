/*
 ============================================================================
 Name        : LocalizedStringTool.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The string localization tool
 ============================================================================
 */

#import "LocalizedStringTool.h"


NSString* L(NSString* key)
{
	return NSLocalizedString(key, nil);
}

NSString* LT(NSString* key, NSString* table)
{
	return NSLocalizedStringFromTable(key, table, nil);
}
