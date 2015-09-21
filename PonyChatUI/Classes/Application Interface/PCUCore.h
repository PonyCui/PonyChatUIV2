//
//  PCUCore.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageManager.h"
#import "PCUWireframe.h"

@class PCUImageMessageEntity, PCUVoiceMessageEntity, ASImageNode;

@protocol PCUVoiceStatus <NSObject>

@required
- (BOOL)isPlaying;
- (void)setPlay;
- (void)setPause;

@end

@protocol PCUDelegate <NSObject>

@optional

#pragma mark - Event

- (void)PCUEndEditing;

- (void)PCURequireOpenURL:(NSURL *)URL;

- (void)PCURequireDeleteMessageItem:(PCUMessageEntity *)messageItem;

- (void)PCURequireForwardMessageItem:(PCUMessageEntity *)messageItem;

- (void)PCURequireBatchOperateWithMessageItems:(NSArray<PCUMessageEntity *> *)items
                               completionBlock:(void (^)(BOOL finished))completionBlock;

#pragma mark - Setting

- (BOOL)PCUCellShowNickname;

#pragma mark - History Messages

- (BOOL)PCUChatViewCanRequestPreviousMessages;

- (void)PCUChatViewRequestPreviousMessages:(void (^)(BOOL noMore))resultBlock;

- (void)PCURequireSlideToMessageID:(NSString *)messageID;

#pragma mark - Message Tapped

- (void)PCUAvatarTappedWithMessageItem:(PCUMessageEntity *)messageItem;

- (void)PCUAvatarLongPressedWithMessageItem:(PCUMessageEntity *)messageItem;

- (void)PCUImageMessageItemTapped:(PCUImageMessageEntity *)messageItem;

- (void)PCUImageMessageItemTapped:(PCUImageMessageEntity *)messageItem imageView:(ASImageNode *)imageView;

- (void)PCUVoiceMessageItemTapped:(PCUVoiceMessageEntity *)messageItem
                      voiceStatus:(id<PCUVoiceStatus>)voiceStatus;

- (BOOL)PCUVoiceMessageItemHasPlayed:(PCUVoiceMessageEntity *)messageItem;

- (void)PCUFailableMessageItemTapped:(PCUMessageEntity *)messageItem;

@end

@interface PCUCore : NSObject

@property (nonatomic, strong) PCUMessageManager *messageManager;

@property (nonatomic, strong) PCUWireframe *wireframe;

@end
