//
//  PCUImageManager.h
//  KaKaGroup
//
//  Created by 崔 明辉 on 15/7/30.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface PCUImageManager : NSObject <ASImageCacheProtocol, ASImageDownloaderProtocol>

+ (PCUImageManager *)sharedInstance;

@end
