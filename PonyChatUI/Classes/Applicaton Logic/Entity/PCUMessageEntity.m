//
//  PCUMessageEntity.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageEntity.h"

@implementation PCUMessageEntity

- (instancetype)initWithForwardMessageItem:(PCUMessageEntity *)messageItem
{
    self = [super init];
    if (self) {
        self.messageOrder = (double)[[NSDate date] timeIntervalSince1970];
        self.messageDate = [NSDate date];
        self.ownSender = YES;
    }
    return self;
}

@end
