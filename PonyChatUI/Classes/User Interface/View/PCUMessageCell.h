//
//  PCUMessageCell.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "ASCellNode.h"

static const CGFloat kCellGaps = 8.0f;
static const CGFloat kAvatarSize = 40.0f;
static const CGFloat kFontSize = 16.0f;

typedef NS_ENUM(NSInteger, PCUMessageActionType) {
    PCUMessageActionTypeUnknown = 0,
    PCUMessageActionTypeSend,
    PCUMessageActionTypeReceive
};

@class PCUMessageItemInteractor, PCUMessageCell, PCUMessageEntity;

@protocol PCUDelegate;

@protocol PCUMessageCellDelegate <NSObject>

- (void)mainViewShouldEnteringSeletionMode;

- (void)messageCellShouldToggleSelection:(PCUMessageCell *)cell messageItem:(PCUMessageEntity *)messageItem;

@end

@interface PCUMessageCell : ASCellNode

@property (nonatomic, weak) id<PCUDelegate> delegate;

@property (nonatomic, weak) id<PCUMessageCellDelegate> cellDelegate;

@property (nonatomic, assign) PCUMessageActionType actionType;

+ (PCUMessageCell *)cellForMessageInteractor:(PCUMessageItemInteractor *)messageInteractor;

#pragma mark - Private

@property (nonatomic, assign) BOOL showNickname;

@property (nonatomic, strong) PCUMessageItemInteractor *messageInteractor;

@property (nonatomic, strong) ASDisplayNode *contentNode;

@property (nonatomic, strong) ASTextNode *upscriptTextNode;

@property (nonatomic, strong) ASTextNode *subscriptTextNode;

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor;

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize;

- (void)layout;

- (void)updateLayoutWithContentFrame:(CGRect)frame;

- (void)resume;

- (void)setSelecting:(BOOL)selecting animated:(BOOL)animated;

- (void)setSelected:(BOOL)selected;

@end
