//
//  TuringRobotMoreViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/8.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "TuringRobotMoreViewController.h"
#import "PCUCore.h"

@interface TuringRobotMoreViewController ()<PCUDelegate>

@property (nonatomic, assign)   NSInteger fakeOrder;

@property (nonatomic, strong)   NSDate    *fakeDate;

@property (nonatomic, assign)   NSInteger fakeDateTimeInterval;

@end

@implementation TuringRobotMoreViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.fakeOrder = 10000;
        self.fakeDate = [NSDate date];
        self.fakeDateTimeInterval = 100;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSlideUp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchHistoryDataWithCompletionBlock:(void (^)())completionBlock {
    NSMutableArray *items = [NSMutableArray array];
    for (; self.fakeOrder > 9970; self.fakeOrder--) {
        PCUTextMessageEntity *messageItem = [[PCUTextMessageEntity alloc] init];
        messageItem.messageID = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
        messageItem.messageOrder = self.fakeOrder;
        messageItem.messageDate = [self.fakeDate dateByAddingTimeInterval:-self.fakeDateTimeInterval];
        messageItem.senderID = @"2";
        messageItem.senderNicknameString = @"Turing";
        messageItem.senderAvatarURLString = @"http://tp2.sinaimg.cn/1756627157/180/40029973996/1";
        messageItem.messageText = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
        [items addObject:messageItem];
        self.fakeDateTimeInterval += arc4random() % 300;
    }
    [self.core.messageManager addInitalizeMessageItems:items];
    [self.core.wireframe addMainViewToViewController:self messageManager:self.core.messageManager waitUntilRendFinished:^(UIView *mainView) {
        self.chatView = mainView;
        [self configureChatView];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)configureChatView {
    [self.chatView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleChatViewTapped)]];
    for (id viewController in [self childViewControllers]) {
        if ([viewController isKindOfClass:[PCUMainViewController class]]) {
            self.chatViewController = viewController;
            break;
        }
    }
    [self.view sendSubviewToBack:self.chatView];
}

- (void)configureSlideUp {
    PCUSlideUpEntity *item = [[PCUSlideUpEntity alloc] init];
    item.titleText = @"100条新消息";
    item.messageID = @"9900";
    [self.core.messageManager addSlideUpItem:item];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PCUSlideUpEntity *item = [[PCUSlideUpEntity alloc] init];
        item.titleText = @"有人@我";
        item.messageID = @"9800";
        [self.core.messageManager addSlideUpItem:item];
    });
}

#pragma mark - PCUDelegate

- (BOOL)PCUChatViewCanRequestPreviousMessages {
    if (self.fakeOrder < 9000) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)PCUChatViewRequestPreviousMessages:(void (^)(BOOL))resultBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger intMessageID = self.fakeOrder - 30;
        PCUTextMessageEntity *lastItem = nil;
        for (; self.fakeOrder > intMessageID; self.fakeOrder--) {
            PCUTextMessageEntity *messageItem = [[PCUTextMessageEntity alloc] init];
            messageItem.messageID = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
            messageItem.messageOrder = self.fakeOrder;
            messageItem.messageDate = [self.fakeDate dateByAddingTimeInterval:-self.fakeDateTimeInterval];
            messageItem.senderID = @"2";
            messageItem.senderNicknameString = @"Turing";
            messageItem.senderAvatarURLString = @"http://tp2.sinaimg.cn/1756627157/180/40029973996/1";
            messageItem.messageText = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
            self.fakeDateTimeInterval += arc4random() % 300;
            if (lastItem != nil) {
                [self.core.messageManager didInsertMessageItem:lastItem nextItem:messageItem];
            }
            lastItem = messageItem;
        }
        if (lastItem != nil) {
            [self.core.messageManager didInsertMessageItem:lastItem nextItem:nil];
        }
        resultBlock(self.fakeOrder < 9000);
    });
}

- (void)PCURequireSlideToMessageID:(NSString *)messageID {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger intMessageID = [messageID integerValue];
        PCUTextMessageEntity *lastItem = nil;
        for (; self.fakeOrder >= intMessageID; self.fakeOrder--) {
            PCUTextMessageEntity *messageItem = [[PCUTextMessageEntity alloc] init];
            messageItem.messageID = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
            messageItem.messageOrder = self.fakeOrder;
            messageItem.messageDate = [self.fakeDate dateByAddingTimeInterval:-self.fakeDateTimeInterval];
            messageItem.senderID = @"2";
            messageItem.senderNicknameString = @"Turing";
            messageItem.senderAvatarURLString = @"http://tp2.sinaimg.cn/1756627157/180/40029973996/1";
            messageItem.messageText = [NSString stringWithFormat:@"%ld", (long)self.fakeOrder];
            self.fakeDateTimeInterval += arc4random() % 300;
            if (lastItem != nil) {
                [self.core.messageManager didInsertMessageItem:lastItem nextItem:messageItem];
            }
            lastItem = messageItem;
        }
        if (lastItem != nil) {
            [self.core.messageManager didInsertMessageItem:lastItem nextItem:nil];
        }
    });
}

@end
