/*
 ============================================================================
 Name        : FileTool.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The file tool file
 ============================================================================
 */

#import <Foundation/Foundation.h>


@interface FileTool : NSObject
{

}

+ (BOOL)initDirectoryForFile:(NSString*)filename;
+ (BOOL)createDirectory:(NSString*)dir;
+ (BOOL)createFile:(NSString*)path withData:(NSData*)data;
+ (BOOL)isFileExist:(NSString*)filepath;
+ (BOOL)deleteFile:(NSString*)path;

+ (NSString*)getDocumentPath;
+ (NSString*)getSubDocumentPath:(NSString*)dir;

+ (NSString*)generateGuid;

@end
