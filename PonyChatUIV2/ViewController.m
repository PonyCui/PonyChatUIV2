//
//  ViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "ViewController.h"
@import PonyChatUI;

//#define PressureTest

// PonyChatUI 仅仅是一个聊天时间轴界面，不包含底部的输入框，这将带给开发者更多的控制权。
@interface ViewController ()<PCUDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) PCUCore *core;

@property (nonatomic, strong) UIView *chatView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _core = [[PCUCore alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatView = [self.core.wireframe addMainViewToViewController:self
                                                  withMessageManager:self.core.messageManager];
    [self receiveSystemMessage];
    [self performSelector:@selector(receiveLinkMessage) withObject:nil afterDelay:18.0];
    [self receiveAnimatingMessage];
    
#ifdef PressureTest
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(receiveAnimatingMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(receiveVoiceMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(receiveTextMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(receiveImageMessage) userInfo:nil repeats:YES];
#else
    [NSTimer scheduledTimerWithTimeInterval:12.0 target:self selector:@selector(receiveAnimatingMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(receiveVoiceMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(receiveTextMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(receiveImageMessage) userInfo:nil repeats:YES];
#endif
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chatView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Debug

- (void)receiveSystemMessage {
    PCUSystemMessageEntity *systemMessageItem = [[PCUSystemMessageEntity alloc] init];
    systemMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    systemMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    systemMessageItem.messageText = @"Hello, World!";
    [self.core.messageManager didReceiveMessageItem:systemMessageItem];
}

- (void)receiveLinkMessage {
    PCULinkMessageEntity *linkMessageItem = [[PCULinkMessageEntity alloc] init];
    linkMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    linkMessageItem.messageDate = [NSDate date];
    linkMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    linkMessageItem.messageText = @"美国乡村奇怪事件 《奇异人生》最新截图视频";
    linkMessageItem.descriptionText = @"SE于今天公开了PS4、XboxOne、PC三平台上的最新冒险游戏《奇异人生》的最新截图和一段日文解说的宣传视频。";
    linkMessageItem.thumbURLString = @"http://img3.dwstatic.com/ps4/1509/306164780504/1442210084834.jpg";
    linkMessageItem.linkURLString = @"http://ps4.duowan.com/1509/306164780504.html";
    [self.core.messageManager didReceiveMessageItem:linkMessageItem];
}

- (void)receiveTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    textMessageItem.messageDate = [NSDate date];
    textMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这只是一堆用来测试的文字，谢谢！Post:%@",
                                   [[NSDate date] description]];
    textMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    textMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    [self.core.messageManager didReceiveMessageItem:textMessageItem];
}

- (void)receivePreviousTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    textMessageItem.messageDate = [NSDate date];
    textMessageItem.messageOrder = -[[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这段文字来自很多年前，谢谢！Post:%@",
                                   [[NSDate date] description]];
    textMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    textMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    [self.core.messageManager didReceiveMessageItem:textMessageItem];
}

- (void)receiveAnimatingMessage {
    PCUImageMessageEntity *imageMessageItem = [[PCUImageMessageEntity alloc] init];
    imageMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    imageMessageItem.messageDate = [NSDate date];
    imageMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    imageMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    imageMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    imageMessageItem.imageURLString = [NSString stringWithFormat:@"http://pics.sc.chinaz.com/Files/pic/faces/3708/%u.gif", arc4random() % 15 + 1];
    imageMessageItem.imageSize = CGSizeMake(75, 75);
    imageMessageItem.isGIF = YES;
    [self.core.messageManager didReceiveMessageItem:imageMessageItem];
}

- (void)receiveImageMessage {
    PCUImageMessageEntity *imageMessageItem = [[PCUImageMessageEntity alloc] init];
    imageMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    imageMessageItem.messageDate = [NSDate date];
    imageMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    imageMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    imageMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    imageMessageItem.imageURLString = @"http://ww1.sinaimg.cn/mw1024/4923db2bjw1etpf22s9mbj20xr1o0e82.jpg";
    imageMessageItem.imageSize = CGSizeMake(1024, 1820);
    [self.core.messageManager didReceiveMessageItem:imageMessageItem];
}

- (void)receiveVoiceMessage {
    PCUVoiceMessageEntity *voiceMessageItem = [[PCUVoiceMessageEntity alloc] init];
    voiceMessageItem.messageID = [NSString stringWithFormat:@"%u", arc4random()];
    voiceMessageItem.messageDate = [NSDate date];
    voiceMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    voiceMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    voiceMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    voiceMessageItem.voiceURLString = @"";
    voiceMessageItem.voiceDuration = arc4random() % 60;
    [self.core.messageManager didReceiveMessageItem:voiceMessageItem];
}

#pragma mark - PCUDelegate

- (void)PCUImageMessageItemTapped:(PCUImageMessageEntity *)messageItem {
    NSLog(@"Image Tapped, Do Something.");
    /* PonyChatUI希望做到的是，把更多的控制权交回给开发者手上，因此，PonyChatUI并不会将Gallery类集成到里面，你可以自行响应这个方法。
     * 你可以子类化PCUImageMessageEntity，PCU将原封不动的将你的子类返回给你。
     */
}

- (void)PCUVoiceMessageItemTapped:(PCUVoiceMessageEntity *)messageItem
                      voiceStatus:(id<PCUVoiceStatus>)voiceStatus {
    NSLog(@"Voice Tapped, Do Something.");
    /* 你可以自行获取对应音频文件或本地已经缓存好的文件，并播放，使用voiceStatus控制cell的UI状态。*/
    if (![voiceStatus isPlaying]) {
        [voiceStatus setPlay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [voiceStatus setPause];
        });
    }
    else {
        [voiceStatus setPause];
    }
}

- (void)PCURequireOpenURL:(NSURL *)URL {
    [[UIApplication sharedApplication] openURL:URL];
}

@end
