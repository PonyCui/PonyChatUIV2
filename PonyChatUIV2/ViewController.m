//
//  ViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "ViewController.h"
@import PonyChatUI;

@interface ViewController ()

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
    [self receiveVoiceMessage];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(receiveTextMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:11.0 target:self selector:@selector(receivePreviousTextMessage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(receiveImageMessage) userInfo:nil repeats:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chatView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Debug

- (void)receiveSystemMessage {
    PCUSystemMessageEntity *systemMessageItem = [[PCUSystemMessageEntity alloc] init];
    systemMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    systemMessageItem.messageText = @"Hello, World!";
    [self.core.messageManager didReceiveMessageItem:systemMessageItem];
}

- (void)receiveTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这只是一堆用来测试的文字，谢谢！Post:%@",
                                   [[NSDate date] description]];
    textMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    textMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    [self.core.messageManager didReceiveMessageItem:textMessageItem];
}

- (void)receivePreviousTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageOrder = -[[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这段文字来自很多年前，谢谢！Post:%@",
                                   [[NSDate date] description]];
    textMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    textMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    [self.core.messageManager didReceiveMessageItem:textMessageItem];
}

- (void)receiveImageMessage {
    PCUImageMessageEntity *imageMessageItem = [[PCUImageMessageEntity alloc] init];
    imageMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    imageMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    imageMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    imageMessageItem.imageURLString = @"http://ww1.sinaimg.cn/mw1024/4923db2bjw1etpf22s9mbj20xr1o0e82.jpg";
    imageMessageItem.imageSize = CGSizeMake(1024, 1820);
    [self.core.messageManager didReceiveMessageItem:imageMessageItem];
}

- (void)receiveVoiceMessage {
    
}

@end
