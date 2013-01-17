//
//  WiImageLoader.m
//  WiYunSample
//
//  Created by Wang Qing on 10-5-10.
//  Copyright 2010 WiYun Inc. All rights reserved.
//

#import "LQImageLoader.h"

static LQImageLoader* _wiImageLoader = nil;

@interface WiGameImageRequest : NSObject
{
    NSString* _imageUrl;
    id _context;
}

@property (nonatomic) NSString* imageUrl;
@property (nonatomic) id context;

+ (WiGameImageRequest*)requestWithUrl:(NSString*)url context:(id)context;

@end

@implementation WiGameImageRequest
@synthesize context = _context;
@synthesize imageUrl = _imageUrl;


+ (WiGameImageRequest*)requestWithUrl:(NSString*)url context:(id)context{
    WiGameImageRequest* request = [[WiGameImageRequest alloc] init];
    request.context = context;
    request.imageUrl = url;
    return request;
}

@end



@implementation LQImageLoader

+(LQImageLoader*)sharedInstance{
    if (_wiImageLoader == nil){
        _wiImageLoader = [[LQImageLoader alloc] init];
    }
    
    return _wiImageLoader;
}

- (id)init{
    self = [super init];
    if (self!=nil){
        _cachedSystemImages = [[NSMutableDictionary alloc] initWithCapacity:10];
        _cachedImages = [[NSMutableDictionary alloc] initWithCapacity:10];
        _requestsQueue = [[NSMutableArray alloc] initWithCapacity:10];
        _imageThreadRunning = NO;
    }
    return self;
}


- (void)clearCacheImages{
    @synchronized(_cachedImages){
        [_cachedImages removeAllObjects];
    }
    @synchronized(_requestsQueue){
        [_requestsQueue removeAllObjects];
    }
}

- (NSString*)cachedFilePath:(NSString*)imageUrl{
    NSString* fileName = [imageUrl lastPathComponent];
//    [[[imageUrl dataUsingEncoding:NSUTF8StringEncoding] nsutf] hexString:NO];
    NSString* filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:fileName] stringByExpandingTildeInPath];
    return filePath;
}

- (void)addRequest:(NSString*)imageUrl context:(id)context{
    @synchronized(_requestsQueue){
        [_requestsQueue insertObject:[WiGameImageRequest requestWithUrl:imageUrl context:context] atIndex:0];
    }
    @synchronized(self){
        if (!_imageThreadRunning){
            _imageThreadRunning = YES;
            [NSThread detachNewThreadSelector:@selector(loadImageThread) toTarget:self withObject:nil];
        }
    }
}

- (UIImage*)loadImage:(NSString*)imageUrl context:(id)context{
    UIImage* image = nil;
    @synchronized(_cachedImages){
        image = [_cachedImages objectForKey:imageUrl];
    }
    
    if (image == nil){
        [self addRequest:imageUrl context:context];
    }
    
    return image;
}

- (void)sendImageLoadedNotification:(id)context{
    if (context!=nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:kWiImageLoadedNotification object:self userInfo:[NSDictionary dictionaryWithObject:context forKey:@"context"]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kWiImageLoadedNotification object:self userInfo:nil];        
    }
}

- (void)imageDidLoaded:(NSDictionary*)values{
    NSObject<LQImageReceiver>* context = [values objectForKey:@"context"];
    if ([context conformsToProtocol:@protocol(LQImageReceiver)]){
        [context updateImage:[values objectForKey:@"image"] forUrl:[values objectForKey:@"url"]];
    }
}

- (void)loadImageThread{
    @autoreleasepool {

        WiGameImageRequest* request = nil;
        do
        {
            @synchronized(_requestsQueue){
                request = [_requestsQueue lastObject];
            }

            if (request == nil){
                break;
            }
            
            UIImage* image = nil;
            @synchronized(_cachedImages){
                image = [_cachedImages objectForKey:request.imageUrl];
            }
            
            if (image == nil){
                NSURLRequestCachePolicy policy = NSURLRequestReturnCacheDataElseLoad;
                
                NSError *error = nil;
                NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:request.imageUrl]
                                                         cachePolicy:policy
                                                     timeoutInterval:30.0];
                NSURLResponse* response = nil;
                NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                if (data != nil){
				image = [UIImage imageWithData:data];
				if (image != nil){
					if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
						float scale = [[UIScreen mainScreen] scale];
						if (scale > 1.0f){
							if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]){
								image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
							}
						}
					}
				}
                }

                if (image != nil){
                    @synchronized(_cachedImages){
                        [_cachedImages setObject:image forKey:request.imageUrl];
                    }
                }
            }
             
            if (image!=nil){
                if (request.context != nil){
                    NSDictionary* values = [NSDictionary dictionaryWithObjectsAndKeys:
                                            image, @"image",
                                            request.imageUrl, @"url",
                                            request.context, @"context",
                                            nil];
                    [self performSelectorOnMainThread:@selector(imageDidLoaded:) withObject:values waitUntilDone:NO];
                }else{
                    [self performSelectorOnMainThread:@selector(sendImageLoadedNotification:) withObject:nil waitUntilDone:NO];
                }
            }
            
            @synchronized(_requestsQueue){
                if (_requestsQueue.count > 0){
                    [_requestsQueue removeLastObject];
                }
            }
        }while(YES);
        
        @synchronized(self){
            _imageThreadRunning = NO;
        }
    
    }
}

- (UIImage*)loadImageByName:(NSString*)imageName{
    
    UIImage* cachedImage = [_cachedSystemImages objectForKey:imageName];
    if (cachedImage == nil){
        
        float screenScale = 1.0f;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
            screenScale = [[UIScreen mainScreen] scale];
        }
        
        NSString* pathExt = [imageName pathExtension];
        imageName = [[[imageName stringByDeletingPathExtension] stringByAppendingString:@"_hd"] stringByAppendingPathExtension:pathExt];
        
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:pathExt];
        
        cachedImage = [UIImage imageWithContentsOfFile:imagePath];
        
        if (cachedImage != nil){
            CGImageRef imgRef = cachedImage.CGImage;
            CGFloat width = cachedImage.size.width;
            CGFloat height = cachedImage.size.height;
            if (screenScale == 1.0f){
                CGFloat scale = 0.5f;
                UIGraphicsBeginImageContext(CGSizeMake( width * scale, height * scale));
                CGContextRef context = UIGraphicsGetCurrentContext();
                if ((cachedImage.imageOrientation == UIImageOrientationDown) ||
                    (cachedImage.imageOrientation == UIImageOrientationRight) || 
                    (cachedImage.imageOrientation == UIImageOrientationUp)){
                    // flip the coordinate space upside down
                    CGContextScaleCTM(context, 1, -1);
                    CGContextTranslateCTM(context, 0, - height * scale);
                }
                
                CGContextDrawImage(context, CGRectMake(0, 0, width * scale, height * scale), imgRef);
                cachedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }else{
                cachedImage = [UIImage imageWithCGImage:cachedImage.CGImage scale:screenScale orientation:cachedImage.imageOrientation];
            }
            
        }else{
            NSLog(@"imageName %@ does not exist", imageName);
        }
        
        if (cachedImage != nil){
            [_cachedSystemImages setObject:cachedImage forKey:imageName];
        }
    }
    return cachedImage;
//    UIImage* cachedImage = [_cachedSystemImages objectForKey:imageName];
//    if (cachedImage == nil){
//        NSString* imagePath = [[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] ofType:[imageName pathExtension]];
//        cachedImage = [UIImage imageWithContentsOfFile:imagePath];
//        if (cachedImage != nil){
//            [_cachedSystemImages setObject:cachedImage forKey:imageName];
//        }
//    }
//    return cachedImage;
//    UIImage* cachedImage = [_cachedSystemImages objectForKey:imageName];
    
//    if (cachedImage == nil){
//        NSString* imagePath = [WiResourceBundle getImagePath:imageName];
//        cachedImage = [UIImage imageWithContentsOfFile:imagePath];
//    }
//    
//    
//    if (cachedImage != nil){
//        [_cachedSystemImages setObject:cachedImage forKey:imageName];
//    }
//    else{
//        float screenScale = 1.0f;
//        
//        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
//            screenScale = [[UIScreen mainScreen] scale];
//        }
//        
//        NSString* pathExt = [imageName pathExtension];
//        imageName = [[[imageName stringByDeletingPathExtension] stringByAppendingString:@"_hd"] stringByAppendingPathExtension:pathExt];
//        
//        NSString* imagePath = [WiResourceBundle getImagePath:[imageName stringByDeletingPathExtension] withExt:pathExt];        
//        
//        cachedImage = [UIImage imageWithContentsOfFile:imagePath];
//        
//        if (cachedImage != nil){
//            CGImageRef imgRef = cachedImage.CGImage;
//            CGFloat width = cachedImage.size.width;
//            CGFloat height = cachedImage.size.height;
//            if ([WiGame deviceIsIPhone]) {
//                if (screenScale == 1.0f){
//                    CGFloat scale = 0.5f;
//                    UIGraphicsBeginImageContext(CGSizeMake( width * scale, height * scale));
//                    CGContextRef context = UIGraphicsGetCurrentContext();
//                    if ((cachedImage.imageOrientation == UIImageOrientationDown) ||
//                        (cachedImage.imageOrientation == UIImageOrientationRight) || 
//                        (cachedImage.imageOrientation == UIImageOrientationUp)){
//                        // flip the coordinate space upside down
//                        CGContextScaleCTM(context, 1, -1);
//                        CGContextTranslateCTM(context, 0, - height * scale);
//                    }
//                    
//                    CGContextDrawImage(context, CGRectMake(0, 0, width * scale, height * scale), imgRef);
//                    cachedImage = UIGraphicsGetImageFromCurrentImageContext();
//                    UIGraphicsEndImageContext();
//                }else{
//                    cachedImage = [UIImage imageWithCGImage:cachedImage.CGImage scale:screenScale orientation:cachedImage.imageOrientation];
//                }
//            }else{
//                if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]){
//                    cachedImage = [UIImage imageWithCGImage:cachedImage.CGImage scale:2.0 orientation:cachedImage.imageOrientation];
//                }else{
//                    CGFloat scale = 0.5f;
//                    UIGraphicsBeginImageContext(CGSizeMake( width * scale, height * scale));
//                    CGContextRef context = UIGraphicsGetCurrentContext();
//                    if ((cachedImage.imageOrientation == UIImageOrientationDown) ||
//                        (cachedImage.imageOrientation == UIImageOrientationRight) || 
//                        (cachedImage.imageOrientation == UIImageOrientationUp)){
//                        // flip the coordinate space upside down
//                        CGContextScaleCTM(context, 1, -1);
//                        CGContextTranslateCTM(context, 0, - height * scale);
//                    }
//                    
//                    CGContextDrawImage(context, CGRectMake(0, 0, width * scale, height * scale), imgRef);
//                    cachedImage = UIGraphicsGetImageFromCurrentImageContext();
//                    UIGraphicsEndImageContext();
//                }
//                //                if (screenScale == 1.0f){
//                //                    CGFloat scale = 0.5f;
//                //                    UIGraphicsBeginImageContext(CGSizeMake( width * scale, height * scale));
//                //                    CGContextRef context = UIGraphicsGetCurrentContext();
//                //                    if ((cachedImage.imageOrientation == UIImageOrientationDown) ||
//                //                        (cachedImage.imageOrientation == UIImageOrientationRight) || 
//                //                        (cachedImage.imageOrientation == UIImageOrientationUp)){
//                //                        // flip the coordinate space upside down
//                //                        CGContextScaleCTM(context, 1, -1);
//                //                        CGContextTranslateCTM(context, 0, - height * scale);
//                //                    }
//                //                    
//                //                    CGContextDrawImage(context, CGRectMake(0, 0, width * scale, height * scale), imgRef);
//                //                    cachedImage = UIGraphicsGetImageFromCurrentImageContext();
//                //                    UIGraphicsEndImageContext();
//                //                }else{
//                //                    cachedImage = [UIImage imageWithCGImage:cachedImage.CGImage scale:screenScale orientation:cachedImage.imageOrientation];
//                //                }
//            }
//        }else{
//            NSLog(@"imageName %@ does not exist", imageName);
//        }
//        
//        if (cachedImage != nil){
//            [_cachedSystemImages setObject:cachedImage forKey:imageName];
//        }
//    }
//    return cachedImage;
}

- (void)clearSystemImages{
    [_cachedSystemImages removeAllObjects];
}

+ (UIImage*)loadImageByName:(NSString*)imageName{
    return [[LQImageLoader sharedInstance] loadImageByName:imageName];
}

+ (UIImage*)loadImage:(NSString*)imageUrl context:(id)context{
    return [[LQImageLoader sharedInstance] loadImage:imageUrl context:context];
}

+ (void)clearSystemImages{
    [[LQImageLoader sharedInstance] clearSystemImages];
}

+ (void)clearCacheImages{
    [[LQImageLoader sharedInstance] clearCacheImages];
}

@end
