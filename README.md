# PonyChatUI
PonyChatUI is an easy to use Chatting Flow UI Library. It constructed on AsyncDisplayKit and WeChat Resource. You will find it really like WeChat.

## Why we built PonyChatUI
Almost all open source chatting library have the same issue, that is performance. When messages grow as a large number. The memory and CPU usage rate will be really high.
PonyChatUI focus on performance and architecture, brings you an in-believable developing experience.

## History

* 2015.09.09 update, add message date, slide up tips and fetch history message activity indicator view, fixed lots of bugs.

## Preview

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/1.gif)

Here is demo, you can talk to Turing Robot, download as zip, and have a nice try.

## Functions

### Text/Image/Voice/System Message Support

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/DemoVideo.gif)

PonyChatUI provides text/image/voice/system four style message user interface.
Image and Voice message have delegate method, while user tap these messages, developer could handle it.

### History messages

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/3.gif)

Just implement the delegate method, the history message will insert to PCUChatView.

### Slide Up

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/2.gif)

You may add a slide up tips, while user tap it, PonyChatUI leads to the specific message.

### Pop Menu

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/4.png)

Long press message, there's some option, user can choose it, and developer can custom it.

### Multiple Selection

![](https://raw.githubusercontent.com/PonyGroup/PonyChatUIV2/master/screenshot/5.png)

Long press message, choose more action, user can select more than one message.

## Limitation

PonyChatUIV2 only provides an user interface and user interface relation logic, you have to write your Message Networking Service and Message Storage Service. PonyChatUIV2 can run under Parse or LeanCloud perfectely.

The most difficult things of Message Application are user interface and message service, good luck guys.

## Installation

* Just have a look, we don't provide any installation guide now. When we finishing development, will add it to CocoaPods.
* Feel free to fork and fix it by yourself, and add it to your project.
