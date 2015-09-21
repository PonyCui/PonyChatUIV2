//
//  TuringRobotViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/8.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "TuringRobotViewController.h"
#import "TuringRobotMoreViewController.h"
@import PonyChatUI;

@interface TuringRobotViewController ()<PCUDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PCUCore *core;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolViewBottomSpaceConstraint;

@end

@implementation TuringRobotViewController

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
    [self configureChatView];
    [self installKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutChatView];
}

- (IBAction)handleMoreButtonTapped:(id)sender {
    TuringRobotMoreViewController *robotViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TuringRobotMoreViewController"];
    [robotViewController fetchHistoryDataWithCompletionBlock:^{
        [self.navigationController pushViewController:robotViewController animated:YES];
    }];
}

#pragma mark - ChatView

- (void)configureChatView {
    self.chatView = [self.core.wireframe addMainViewToViewController:self
                                                  withMessageManager:self.core.messageManager];
    [self.chatView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleChatViewTapped)]];
    [self layoutChatView];
    for (id viewController in [self childViewControllers]) {
        if ([viewController isKindOfClass:[PCUMainViewController class]]) {
            self.chatViewController = viewController;
            break;
        }
    }
    [self.view sendSubviewToBack:self.chatView];
}

- (void)layoutChatView {
    CGRect chatViewFrame = CGRectZero;
    if (self.chatViewController.contentSize.height > CGRectGetHeight(self.view.bounds) - self.toolViewHeightConstraint.constant) {
        chatViewFrame = CGRectMake(0,
                                   -self.toolViewBottomSpaceConstraint.constant,
                                   CGRectGetWidth(self.view.bounds),
                                   CGRectGetHeight(self.view.bounds) - self.toolViewHeightConstraint.constant);
    }
    else {
        chatViewFrame = CGRectMake(0,
                                   0,
                                   CGRectGetWidth(self.view.bounds),
                                   CGRectGetHeight(self.view.bounds) - self.toolViewBottomSpaceConstraint.constant - self.toolViewHeightConstraint.constant);
    }
    if (!CGRectEqualToRect(self.chatView.frame, chatViewFrame)) {
        self.chatView.frame = chatViewFrame;
        [self.chatViewController forceScroll];
    }
}

- (void)handleChatViewTapped {
    [self.view endEditing:YES];
}

#pragma mark - Notifications

- (void)installKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUIKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUIKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)uninstallKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)sender {
    self.toolViewBottomSpaceConstraint.constant = CGRectGetHeight([sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutChatView];
        [self.view layoutIfNeeded];
    }];
}

- (void)handleUIKeyboardWillHideNotification:(NSNotification *)sender {
    self.toolViewBottomSpaceConstraint.constant = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutChatView];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return YES;
}

#pragma mark - PCUDelegate

- (BOOL)PCUCellShowNickname {
    return YES;
}

#pragma mark - Sending And Receiving

- (void)sendMessage {
    NSString *text = self.textField.text;
    if (text.length) {
        self.textField.text = @"";
        PCUTextMessageEntity *messageItem = [[PCUTextMessageEntity alloc] init];
        messageItem.ownSender = YES;
        messageItem.messageID = [NSString stringWithFormat:@"%@.%u", [NSDate date], arc4random()];
        messageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
        messageItem.messageDate = [NSDate date];
        messageItem.senderID = @"1";
        messageItem.senderNicknameString = @"Pony";
        messageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1756798423/180/5736676775/1";
        messageItem.sendingStatus = PCUMessageItemSendingStatusProcessing;
        messageItem.messageText = text;
        [self.core.messageManager didReceiveMessageItem:messageItem];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.tuling123.com/openapi/api?key=8e7aaff9540811ecfafbdd16ed6caaeb&info=%@", [messageItem.messageText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != nil) {
                messageItem.sendingStatus = PCUMessageItemSendingStatusFailure;
            }
            else {
                messageItem.sendingStatus = PCUMessageItemSendingStatusSucceed;
                [self receivedMessage:data];
            }
        }];
    }
}

- (void)receivedMessage:(NSData *)messageData {
    if (messageData != nil) {
        NSDictionary *messageDictionary = [NSJSONSerialization JSONObjectWithData:messageData options:kNilOptions error:NULL];
        if ([messageDictionary isKindOfClass:[NSDictionary class]]) {
            NSString *text = messageDictionary[@"text"];
            if ([text isKindOfClass:[NSString class]]) {
                PCUTextMessageEntity *messageItem = [[PCUTextMessageEntity alloc] init];
                messageItem.messageID = [NSString stringWithFormat:@"%@.%u", [NSDate date], arc4random()];
                messageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
                messageItem.messageDate = [NSDate date];
                messageItem.senderID = @"2";
                messageItem.senderNicknameString = @"Turing";
                messageItem.senderAvatarURLString = @"http://tp2.sinaimg.cn/1756627157/180/40029973996/1";
                messageItem.messageText = text;
                [self.core.messageManager didReceiveMessageItem:messageItem];
                NSLog(@"%@, %@", messageItem, messageItem.messageText);
            }
        }
    }
}

@end
