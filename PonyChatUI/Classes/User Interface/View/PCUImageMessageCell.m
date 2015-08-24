//
//  PCUImageMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUImageMessageCell.h"
#import "PCUImageMessageItemInteractor.h"
#import "PCUCore.h"
#import "PCUImageManager.h"

@interface PCUImageMessageCell ()

@property (nonatomic, strong) ASNetworkImageNode *imageNode;

@property (nonatomic, strong) ASImageNode *maskNode;

@end

@implementation PCUImageMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.imageNode];
        [self addSubnode:self.maskNode];
    }
    return self;
}

#pragma mark - Event

- (void)handleImageNodeTapped {
    if ([self.delegate respondsToSelector:@selector(PCUImageMessageItemTapped:)]) {
        [self.delegate PCUImageMessageItemTapped:(id)self.messageInteractor.messageItem];
    }
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    CGSize imageSize = CGSizeMake([[self imageMessageInteractor] imageWidth], [[self imageMessageInteractor] imageHeight]);
    
    return CGSizeMake(constrainedSize.width, MAX(superSize.height, imageSize.height) + kCellGaps + topSpace);
}

- (void)layout {
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    [super layout];
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.imageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 14.0 - [self imageMessageInteractor].imageWidth, 0.0 + topSpace, [self imageMessageInteractor].imageWidth, [self imageMessageInteractor].imageHeight);
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.imageNode.frame = CGRectMake(kAvatarSize + 14.0, 0.0 + topSpace, [self imageMessageInteractor].imageWidth, [self imageMessageInteractor].imageHeight);
    }
    else {
        self.imageNode.hidden = YES;
    }
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.maskNode.image = [[UIImage imageNamed:@"SenderTextNodeBkgReversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 30, 15, 30) resizingMode:UIImageResizingModeStretch];
        self.maskNode.frame = self.imageNode.frame;
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.maskNode.image = [[UIImage imageNamed:@"ReceiverTextNodeBkgReversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 30, 15, 30) resizingMode:UIImageResizingModeStretch];
        self.maskNode.frame = self.imageNode.frame;
    }
    else {
        self.maskNode.hidden = YES;
    }
    [self updateLayoutWithContentFrame:self.maskNode.frame];
}

- (void)resume {
    [super resume];
    if ([[[self imageMessageInteractor] imageURLString] hasPrefix:@"/"]) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[self imageMessageInteractor] imageURLString]];
        _imageNode.image = image;
    }
}

#pragma mark - Getter

- (PCUImageMessageItemInteractor *)imageMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASNetworkImageNode *)imageNode {
    if (_imageNode == nil) {
        _imageNode = [[ASNetworkImageNode alloc] initWithCache:[PCUImageManager sharedInstance]
                                                    downloader:[PCUImageManager sharedInstance]];
        [_imageNode addTarget:self action:@selector(handleImageNodeTapped) forControlEvents:ASControlNodeEventTouchUpInside];
        _imageNode.contentMode = UIViewContentModeScaleAspectFit;
        if ([[[self imageMessageInteractor] imageURLString] hasPrefix:@"/"]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[[self imageMessageInteractor] imageURLString]];
            _imageNode.image = image;
        }
        else if ([[self imageMessageInteractor] thumbURLString] != nil) {
            _imageNode.URL = [NSURL URLWithString:[[self imageMessageInteractor] thumbURLString]];
        }
        else {
            _imageNode.URL = [NSURL URLWithString:[[self imageMessageInteractor] imageURLString]];
        }
        _imageNode.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return _imageNode;
}

- (ASImageNode *)maskNode {
    if (_maskNode == nil) {
        _maskNode = [[ASImageNode alloc] init];
    }
    return _maskNode;
}

@end
