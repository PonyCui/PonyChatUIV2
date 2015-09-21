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
#import "PCUSystemMessageEntity.h"
#import "PCUImageMessageEntity.h"
#import "PCUVoiceMessageEntity.h"
#import "PCULinkMessageEntity.h"
#import "PCUSlideUpEntity.h"

@class PCUMessageEntity, PCUSlideUpEntity;

@protocol PCUMessageManagerDelegate <NSObject>

@required
- (void)messageManagerItemsDidChanged;
- (void)messageManagerItemDidDeletedWithIndex:(NSUInteger)index;
- (void)messageManagerSlideUpItemsDidChanged;

@end

@interface PCUMessageManager : NSObject

@property (nonatomic, weak) id<PCUMessageManagerDelegate> delegate;

@property (nonatomic, copy) NSArray<PCUMessageEntity *> *messageItems;

@property (nonatomic, copy) NSArray<PCUSlideUpEntity *> *slideUpItems;

- (void)addInitalizeMessageItems:(NSArray<PCUMessageEntity *> *)messageItems;

- (void)didInsertMessageItem:(PCUMessageEntity *)messageItem nextItem:(PCUMessageEntity *)nextItem;

- (void)didReceiveMessageItem:(PCUMessageEntity *)messageItem;

- (void)didReceiveMessageItems:(NSArray<PCUMessageEntity *> *)messageItems;

- (void)didDeletedMessageItem:(PCUMessageEntity *)messageItem;

- (void)addSlideUpItem:(PCUSlideUpEntity *)slideUpItem;

@end
