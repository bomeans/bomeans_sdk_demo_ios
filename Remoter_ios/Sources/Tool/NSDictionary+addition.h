/*
 ============================================================================
 Name        : NSDictionary+addition.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : NSDictionary additions
 ============================================================================
 */

#import <Foundation/Foundation.h>


@interface NSDictionary (addition)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (unsigned long long)getUnsignedLongLongValueValueForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end