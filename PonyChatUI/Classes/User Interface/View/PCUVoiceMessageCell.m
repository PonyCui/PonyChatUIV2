//
//  PCUVoiceMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUVoiceMessageCell.h"
#import "PCUVoiceMessageItemInteractor.h"
#import "PCUVoiceMessageEntity.h"
#import "PCUPopMenuViewController.h"

@interface PCUVoiceMessageCell ()<PCUVoiceStatus, PCUPopMenuViewControllerDelegate> {
    NSInteger currentPlayingFrame;
    BOOL isCurrentPlaying;
}

@property (nonatomic, strong) ASImageNode *voiceImageNode;

@property (nonatomic, strong) ASImageNode *backgroundImageNode;

@property (nonatomic, strong) ASDisplayNode *badgeNode;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) PCUPopMenuViewController *popMenuViewController;

@end

@implementation PCUVoiceMessageCell

- (void)dealloc
{
    [self stopPlayingAnimation];
}

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self.contentNode addSubnode:self.backgroundImageNode];
        [self.contentNode addSubnode:self.voiceImageNode];
        [self.contentNode addSubnode:self.badgeNode];
        [self configureScriptNode];
    }
    return self;
}

#pragma mark - Event 

- (void)handleVoiceTapped {
    if ([self.delegate respondsToSelector:@selector(PCUVoiceMessageItemTapped:voiceStatus:)]) {
        [self.delegate PCUVoiceMessageItemTapped:(id)self.messageInteractor.messageItem
                                     voiceStatus:self];
    }
}

- (void)handleDisplayLinkTrigger {
    if (currentPlayingFrame < 1 || currentPlayingFrame > 3) {
        currentPlayingFrame = 1;
    }
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.voiceImageNode.image = [UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld",
                                                         (long)currentPlayingFrame]];
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.voiceImageNode.image = [UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld",
                                                         (long)currentPlayingFrame]];
    }
    currentPlayingFrame++;
}

- (void)loopPlayingAnimation {
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopPlayingAnimation {
    if (isCurrentPlaying) {
        [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = nil;
        currentPlayingFrame = 0;
    }
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.voiceImageNode.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.voiceImageNode.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }
}

#pragma mark - Node

- (void)configureScriptNode {
    self.upscriptTextNode.attributedString = [[NSAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%.0f''", [[self voiceMessageInteractor] voiceDuration]]
                                              attributes:@{
                                                           NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                                           NSForegroundColorAttributeName: [UIColor grayColor]
                                                           }];
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    superSize.height += kCellGaps + topSpace;
    self.contentNode.frame = CGRectMake(0, 0, superSize.width, superSize.height);
    return superSize;
}

- (void)layout {
    [super layout];
    CGFloat topSpace = 0.0;
    if (self.showNickname) {
        topSpace = 18.0;
    }
    CGFloat backgroundWidth = MAX(88.0, MIN(1.0, [[self voiceMessageInteractor] voiceDuration] / 60.0) * 160.0);
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 14.0 - backgroundWidth, 2.0 + topSpace, backgroundWidth, 54.0);
        self.voiceImageNode.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
        self.voiceImageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 14.0 - 18.0 - self.voiceImageNode.image.size.width, 2.0 + topSpace, self.voiceImageNode.image.size.width, 44.0);
        self.badgeNode.hidden = YES;
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageNode.frame = CGRectMake(kAvatarSize + 14.0, 2.0 + topSpace, backgroundWidth, 54.0);
        self.voiceImageNode.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
        self.voiceImageNode.frame = CGRectMake(kAvatarSize + 14.0 + 18.0, 2.0 + topSpace, self.voiceImageNode.image.size.width, 44.0);
        self.badgeNode.frame = CGRectMake(self.backgroundImageNode.frame.origin.x + self.backgroundImageNode.frame.size.width + 22.0, self.backgroundImageNode.frame.origin.y + 8.0, 6.0, 6.0);
        self.badgeNode.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(PCUVoiceMessageItemHasPlayed:)]) {
            if (![self.delegate PCUVoiceMessageItemHasPlayed:(id)self.messageInteractor.messageItem]) {
                self.badgeNode.hidden = NO;
            }
        }
    }
    else {
        self.backgroundImageNode.hidden = YES;
    }
    [self updateLayoutWithContentFrame:self.backgroundImageNode.frame];
}

#pragma mark - PCUVoiceStatus

- (BOOL)isPlaying {
    return isCurrentPlaying;
}

- (void)setPlay {
    isCurrentPlaying = YES;
    [self loopPlayingAnimation];
    self.badgeNode.hidden = YES;
}

- (void)setPause {
    [self stopPlayingAnimation];
    isCurrentPlaying = NO;
}

#pragma mark - PCUPopMenuViewControllerDelegate

- (void)handleBackgroundImageNodeTapped:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.backgroundImageNode.alpha = 0.5;
        CGPoint thePoint = [sender.view.superview convertPoint:sender.view.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
        thePoint.x += CGRectGetWidth(sender.view.frame) / 2.0;
        [self.popMenuViewController presentMenuViewControllerWithReferencePoint:thePoint];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        self.backgroundImageNode.alpha = 1.0;
    }
}

- (void)menuItemDidPressed:(PCUPopMenuViewController *)menuViewController itemIndex:(NSUInteger)itemIndex {
    if (itemIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(PCURequireDeleteMessageItem:)]) {
            [self.delegate PCURequireDeleteMessageItem:self.messageInteractor.messageItem];
        }
    }
    else if (itemIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(PCURequireForwardMessageItem:)]) {
            [self.delegate PCURequireForwardMessageItem:self.messageInteractor.messageItem];
        }
    }
    else if (itemIndex == 2) {
        [self.cellDelegate mainViewShouldEnteringSeletionMode];
    }
}


#pragma mark - Getter

- (PCUVoiceMessageItemInteractor *)voiceMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASImageNode *)voiceImageNode {
    if (_voiceImageNode == nil) {
        _voiceImageNode = [[ASImageNode alloc] init];
        _voiceImageNode.backgroundColor = [UIColor clearColor];
        _voiceImageNode.contentMode = UIViewContentModeCenter;
    }
    return _voiceImageNode;
}

- (ASImageNode *)backgroundImageNode {
    if (_backgroundImageNode == nil) {
        _backgroundImageNode = [[ASImageNode alloc] init];
        _backgroundImageNode.backgroundColor = [UIColor clearColor];
        [_backgroundImageNode addTarget:self
                                 action:@selector(handleVoiceTapped)
                       forControlEvents:ASControlNodeEventTouchUpInside];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundImageNodeTapped:)];
        gesture.minimumPressDuration = 0.35;
        [_backgroundImageNode.view addGestureRecognizer:gesture];
    }
    return _backgroundImageNode;
}

- (CADisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLinkTrigger)];
        _displayLink.frameInterval = 30;
    }
    return _displayLink;
}

- (ASDisplayNode *)badgeNode {
    if (_badgeNode == nil) {
        _badgeNode = [[ASDisplayNode alloc] init];
        _badgeNode.backgroundColor = [UIColor redColor];
        _badgeNode.layer.cornerRadius = 3.0;
        _badgeNode.layer.masksToBounds = YES;
    }
    return _badgeNode;
}

- (PCUPopMenuViewController *)popMenuViewController {
    if (_popMenuViewController == nil) {
        _popMenuViewController = [[PCUPopMenuViewController alloc] init];
        _popMenuViewController.titles = @[@"删除", @"转发", @"更多..."];
        _popMenuViewController.delegate = self;
    }
    return _popMenuViewController;
}

@end
