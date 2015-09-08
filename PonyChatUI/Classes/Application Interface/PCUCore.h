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

@class PCUImageMessageEntity, PCUVoiceMessageEntity;

@protocol PCUVoiceStatus <NSObject>

@required
- (BOOL)isPlaying;
- (void)setPlay;
- (void)setPause;

@end

@protocol PCUDelegate <NSObject>

@optional
- (BOOL)PCUCellShowNickname;
- (void)PCUEndEditing;
- (BOOL)PCUChatViewRequestPreviouMessages;
- (void)PCUAvatarTappedWithMessageItem:(PCUMessageEntity *)messageItem;
- (void)PCUAvatarLongPressedWithMessageItem:(PCUMessageEntity *)messageItem;
- (void)PCUImageMessageItemTapped:(PCUImageMessageEntity *)messageItem;
- (void)PCUVoiceMessageItemTapped:(PCUVoiceMessageEntity *)messageItem
                      voiceStatus:(id<PCUVoiceStatus>)voiceStatus;
- (BOOL)PCUVoiceMessageItemHasPlayed:(PCUVoiceMessageEntity *)messageItem;
- (void)PCUFailableMessageItemTapped:(PCUMessageEntity *)messageItem;
- (void)PCURequireDeleteMessageItem:(PCUMessageEntity *)messageItem;
- (void)PCURequireForwardMessageItem:(PCUMessageEntity *)messageItem;
- (void)PCURequireOpenURL:(NSURL *)URL;
- (void)PCURequireSlideToMessageID:(NSString *)messageID;

@end

@interface PCUCore : NSObject

@property (nonatomic, strong) PCUMessageManager *messageManager;

@property (nonatomic, strong) PCUWireframe *wireframe;

@end
