//
//  PCUImageManager.m
//  KaKaGroup
//
//  Created by 崔 明辉 on 15/7/30.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUImageManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import <SDWebImage/SDWebImageManager.h>

@interface PCUImageManager ()

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

#pragma mark - ASImage Cache and Downloader

- (void)fetchCachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(void (^)(CGImageRef))completion {
    if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:URL]) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:URL options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            CGImageRef imageRef = image.CGImage;
            CFRetain(imageRef);
            if (imageRef != nil) {
                dispatch_async(callbackQueue, ^{
                    completion(imageRef);
                    CFRelease(imageRef);
                });
            }
            else {
                dispatch_async(callbackQueue, ^{
                    completion(nil);
                });
            }
        }];
    }
    else {
        dispatch_async(callbackQueue, ^{
            completion(nil);
        });
    }
}

- (id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgressBlock:(void (^)(CGFloat))downloadProgressBlock completion:(void (^)(CGImageRef, NSError *))completion {
    return [[SDWebImageManager sharedManager] downloadImageWithURL:URL options:kNilOptions progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        CGImageRef imageRef = image.CGImage;
        CFRetain(imageRef);
        if (imageRef != nil) {
            dispatch_async(callbackQueue, ^{
                completion(imageRef, nil);
                CFRelease(imageRef);
            });
        }
        else {
            dispatch_async(callbackQueue, ^{
                completion(nil, error);
            });
        }
    }];
}

- (void)cancelImageDownloadForIdentifier:(id<SDWebImageOperation>)downloadIdentifier {
    [downloadIdentifier cancel];
}

@end
