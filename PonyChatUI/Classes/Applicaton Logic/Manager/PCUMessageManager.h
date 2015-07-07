//
//  PCUMessageManager.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageEntity.h"
#import "PCUTextMessageEntity.h"

@class PCUMessageEntity;

@interface PCUMessageManager : NSObject

- (void)didReceiveMessageItem:(PCUMessageEntity *)messageItem;

- (void)didReceiveMessageItems:(NSArray *)messageItems;

@end
