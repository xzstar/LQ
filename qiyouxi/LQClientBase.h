//
//  MGClient.h
//  TicketGo
//
//  Created by maruojie on 09-9-14.
//  Copyright 2009 MobGo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MG_CLIENT_VERSION @"1.0"

#define P_INTERNAL_PREFIX @"internal_"
#define P_INTERNAL_URL @"internal_u"
#define P_INTERNAL_URL_TAG @"internal_t"
#define P_INTERNAL_COMMAND @"internal_c"
#define P_INTERNAL_TIMEOUT @"internal_o"
#define P_INTERNAL_METHOD @"internal_m"
#define P_INTERNAL_MULTIPART @"internal_p"

#define P_BRAND @"b"
#define P_MODEL @"m"
#define P_OS @"o"
#define P_CLIENT_VERSION @"cv"
#define P_USER_ID @"u"
#define P_FORMAT @"fm"

#define F_JSON 0
#define F_XML 1
#define F_RAWDATA 2

#define TAG_ERROR @"e"

//command constant
#define C_CHECK_UPDATE 1
#define C_USER_COMMAND 100

#define HTTP_GET @"GET"
#define HTTP_DELETE @"DELETE"
#define HTTP_PUT @"PUT"
#define HTTP_POST @"POST"

@class LQClientBase;
@class LQClientError;

/*
 * delegate of b2c client
 */

@protocol LQClientDelegate

@optional
// when checkupdate is returned
- (void)client:(LQClientBase*)client didNeedUpdate:(NSString*)description link:(NSString*)link;

// when command is completed
- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tag:(int)tag;

- (void)client:(LQClientBase*)client didGetCommandResult:(id)result forCommand:(int)command format:(int)format tagObject:(id)tagObject;

// when command fails
- (void)client:(LQClientBase*)client didFailExecution:(LQClientError*)error;
@end

/*
 * mobgo b2c client declaration
 */

@interface LQClientBase : NSObject{
//    id __weak delegate;
}
@property (nonatomic, unsafe_unretained) id delegate;

- (id)initWithDelegate:(id)delegate;

#pragma mark -
#pragma mark 数据结果处理
//请求失败
- (void)notifyDelegateForFailure:(LQClientError*)error;
//请求成功
- (void)notifyDelegateForCommandResult:(NSDictionary*)result;
//版本有更新
- (void)notifyDelegateForCheckUpdate:(NSDictionary*)jsonObj;

#pragma mark -
#pragma mark 加密url相关接口
// 生成加密密钥
- (NSData*)generateKeyForName:(NSString*)name;
// 加密密钥生成种子
- (NSString*)generateRandomName;
// 添加加密参数
- (void)addParamsAsEncoded:(NSMutableDictionary*)queryParams params:(NSDictionary*)params;

#pragma mark -
#pragma mark 默认参数
// 构建默认参数，这些参数不会被编码
- (NSMutableDictionary*)composeParametersForCommand:(int)command withUrl:(NSString*)url ofFormat:(int)format;

#pragma mark -
#pragma mark 数据发送接口
// 检查版本
- (void)processCheckUpdate:(NSString*)url;

- (void)processCommand:(NSString*)url command:(UInt32)command;
- (void)processCommand:(NSString*)url command:(UInt32)command format:(int)format;
- (void)processCommand:(NSString*)url command:(UInt32)command format:(int)format parameters:(NSDictionary*)parameters encoding:(BOOL)encoding ;

- (void)processCommand:(NSString*)url command:(UInt32)command withTag:(int)tag;
- (void)processCommand:(NSString*)url command:(UInt32)command withTag:(int)tag parameters:(NSDictionary*)parameters encoding:(BOOL)encoding;

- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command;
- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command withTag:(int)tag;
- (void)processThirdPartyUrl:(NSString*)url command:(UInt32)command withParameters:(NSDictionary*)parameters;

#pragma mark -
#pragma mark 可以重载的方法
//客户端版本
- (NSString*)version;
//构建QueryString
- (NSString*)composeParameterString:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method;
//构建MultiPart包体, 只有P_INTERNAL_MULTIPART为YES的时候调用，默认不实现.
- (NSData*)composeMultipartData:(NSDictionary*)parameters url:(NSString*)url method:(NSString*)method;
//请求数据
- (NSData*)getRequestData:(NSMutableURLRequest*)request returningResponse:(NSURLResponse**)response error:(NSError**)error;

@end


@interface LQClientError : NSObject 
@property (nonatomic, assign) int command;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, strong) id tagObject;
@property (nonatomic, strong) NSString* message;

- (int)tag;

@end