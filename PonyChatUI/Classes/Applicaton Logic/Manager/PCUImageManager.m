//
//  PCUImageManager.m
//  KaKaGroup
//
//  Created by 崔 明辉 on 15/7/30.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUImageManager.h"
#import <CommonCrypto/CommonCrypto.h>

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
    if (data == nil) {
        data = [NSData dataWithContentsOfFile:[self cachePathWithURL:URL]];
    }
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
                                         timeoutInterval:60.0];
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
                else {
                    [data writeToFile:[self cachePathWithURL:URL] atomically:NO];
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

- (NSString *)cachePathWithURL:(NSURL *)URL {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [[URL absoluteString] UTF8String], (CC_LONG) [[URL absoluteString] length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), s];
    
}

@end
