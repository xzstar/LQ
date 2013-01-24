//
//  KRShareRequest.h
//  KRShare_ios_sdk
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRShareRequest;
@class KRShare;

/**
 * @description 第三方应用访问微博API时实现此此协议，当sdk完成api的访问后通过传入的此类对象完成接口访问结果的回调，应用在协议实现的相应方法中接收访问结果并做对应处理。
 */
@protocol KRShareRequestDelegate <NSObject>
@optional

- (void)request:(KRShareRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(KRShareRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(KRShareRequest *)request didFailWithError:(NSError *)error;
- (void)request:(KRShareRequest *)request didFinishLoadingWithResult:(id)result;
@end

@interface KRShareRequest : NSObject
{
    KRShare                       *krShare;//weak reference
    
    NSString                        *url;
    NSString                        *httpMethod;
    NSDictionary                    *params;
    
    NSURLConnection                 *connection;
    NSMutableData                   *responseData;
    
    id<KRShareRequestDelegate>    delegate;
}

@property (nonatomic, assign) KRShare *krShare;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, assign) id<KRShareRequestDelegate> delegate;

+ (KRShareRequest *)requestWithURL:(NSString *)url 
                          httpMethod:(NSString *)httpMethod 
                              params:(NSDictionary *)params
                            delegate:(id<KRShareRequestDelegate>)delegate;

+ (KRShareRequest *)requestWithAccessToken:(NSString *)accessToken
                                         url:(NSString *)url
                                  httpMethod:(NSString *)httpMethod 
                                      params:(NSDictionary *)params
                                    delegate:(id<KRShareRequestDelegate>)delegate;

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

- (void)connect;
- (void)disconnect;

@end
