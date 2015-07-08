# PonyChatUI
PonyChatUI is an easy to use Chatting Flow UI Library. It constructed on AsyncDisplayKit and WeChat Resource. You will find it really like WeChat.

## Why we built PonyChatUI
Almost all open source chatting library have the same issue, that is performance. When messages grow as a large number. The memory and CPU usage rate will be really high.
PonyChatUI focus on performance and architecture, brings you an in-believable developing experience.

## Preview

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/DemoVideo.gif)

## Sample Code

The easist way to use PonyChatUI is

```objective-c
@import PonyChatUI;

@interface ViewController ()<PCUDelegate>

@property (nonatomic, strong) PCUCore *core;//create a property to store PCUCore, one ViewController should use one core instance

@property (nonatomic, strong) UIView *chatView;//create a property to store chatView

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _core = [[PCUCore alloc] init];//init the core
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatView = [self.core.wireframe addMainViewToViewController:self
                                                  withMessageManager:self.core.messageManager];//use this method add chatView to self.view
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(receiveTextMessage) userInfo:nil repeats:YES];
    //Debug data
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chatView.frame = self.view.bounds;
}

- (void)receiveTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这只是一堆用来测试的文字，谢谢！Post:%@",
                                   [[NSDate date] description]];
    textMessageItem.ownSender = arc4random() % 5 == 0 ? YES : NO;
    textMessageItem.senderAvatarURLString = @"http://tp4.sinaimg.cn/1651799567/180/1290860930/1";
    [self.core.messageManager didReceiveMessageItem:textMessageItem];//use this method add an item to chatView
}

@end

```

## Installation

* Just have a look, we don't provide any installation guide now. When we finishing development, will add it to CocoaPods.
* Feel free to fork and fix it by yourself, and add it to your project.
