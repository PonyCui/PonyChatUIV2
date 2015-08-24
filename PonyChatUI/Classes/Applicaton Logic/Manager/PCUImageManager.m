//
//  PCUImageManager.m
//  KaKaGroup
//
//  Created by 崔 明辉 on 15/7/30.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUImageManager.h"

@interface PCUImageManager ()

@property (nonatomic, copy) NSMutableDictionary *avatarCacheObject;

@end

@implementation PCUImageManager

+ (PCUImageManager *)sharedInstance {
    static PCUImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PCUImageManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _avatarCacheObject = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - ASImage Cache and Downloader

- (void)fetchCachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(void (^)(CGImageRef))completion {
    NSData *data = [self.avatarCacheObject valueForKey:URL.absoluteString];
    if (data != nil) {
        CGImageRef imageRef = [[UIImage imageWithData:data] CGImage];
        CFRetain(imageRef);
        if (imageRef != nil) {
            [self.avatarCacheObject setValue:data forKey:URL.absoluteString];
            dispatch_async(callbackQueue, ^{
                completion(imageRef);
            });
        }
        else {
            dispatch_async(callbackQueue, ^{
                completion(nil);
            });
        }
    }
    else {
        dispatch_async(callbackQueue, ^{
            completion(nil);
        });
    }
}

- (id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgressBlock:(void (^)(CGFloat))downloadProgressBlock completion:(void (^)(CGImageRef, NSError *))completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:15.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil && [data isKindOfClass:[NSData class]]) {
            CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
            CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
            if (imageRef == NULL) {
                imageRef = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
            }
            CFRelease(imgDataProvider);
            if (imageRef != nil) {
                if ([data length] < 1024 * 64) {
                    [self.avatarCacheObject setValue:data forKey:URL.absoluteString];
                }
                dispatch_async(callbackQueue, ^{
                    completion(imageRef, nil);
                    CFRelease(imageRef);
                });
            }
            else {
                dispatch_async(callbackQueue, ^{
                    completion(nil, [NSError errorWithDomain:@"CGImage" code:-1 userInfo:nil]);
                });
                
            }
        }
        else {
            dispatch_async(callbackQueue, ^{
                completion(nil, connectionError);
            });
        }
    }];
    return nil;
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    
}

@end
