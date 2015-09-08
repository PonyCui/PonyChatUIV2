//
//  PCUMessageEntity.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef double PCUMessageOrder;

typedef NS_ENUM(NSInteger, PCUMessageItemSendingStatus) {
    PCUMessageItemSendingStatusFailure = -1,
    PCUMessageItemSendingStatusUnknown = 0,
    PCUMessageItemSendingStatusProcessing = 1,
    PCUMessageItemSendingStatusSucceed = 2
};

@interface PCUMessageEntity : NSObject

@property (nonatomic, copy) NSString *messageID;

@property (nonatomic, strong) NSDate *messageDate;

@property (nonatomic, assign) PCUMessageOrder messageOrder;

@property (nonatomic, assign) BOOL ownSender;

@property (nonatomic, copy) NSString *senderID;//发送者的识别标识

@property (nonatomic, copy) NSString *senderNicknameString;

@property (nonatomic, copy) NSString *senderAvatarURLString;

@property (nonatomic, assign) PCUMessageItemSendingStatus sendingStatus;

@property (nonatomic, copy) NSDictionary *attributes;

- (instancetype)initWithForwardMessageItem:(PCUMessageEntity *)messageItem;

@end
