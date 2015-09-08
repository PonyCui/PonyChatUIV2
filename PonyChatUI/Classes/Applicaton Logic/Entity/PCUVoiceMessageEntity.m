//
//  PCUVoiceMessageEntity.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUVoiceMessageEntity.h"

@implementation PCUVoiceMessageEntity

- (instancetype)initWithForwardMessageItem:(PCUVoiceMessageEntity *)messageItem
{
    self = [super initWithForwardMessageItem:messageItem];
    if (self) {
        self.voiceURLString = [messageItem voiceURLString];
        self.voiceDuration = [messageItem voiceDuration];
    }
    return self;
}

@end
