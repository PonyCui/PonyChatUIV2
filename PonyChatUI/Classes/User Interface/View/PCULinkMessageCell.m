//
//  PCULinkMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/14.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCULinkMessageCell.h"
#import "PCULinkMessageItemInteractor.h"
#import "PCULinkMessageEntity.h"
#import "PCUPopMenuViewController.h"
#import "PCUImageManager.h"
#import "PCUCore.h"

#define kLinkCellTBSpace 8.0f
#define kLargerLinkLRSpace 16.0f
#define kLargerContentLRSpace 12.0f
#define kLargerThumbImageRatio 16.0f/9.0f

@interface PCULinkMessageCell ()<PCUPopMenuViewControllerDelegate>

@property (nonatomic, strong) ASTextNode *titleNode;

@property (nonatomic, strong) ASTextNode *dateNode;

@property (nonatomic, strong) ASImageNode *thumbImageNode;

@property (nonatomic, strong) ASTextNode *subTitleNode;

@property (nonatomic, strong) ASImageNode *backgroundImageNode;

@property (nonatomic, strong) PCUPopMenuViewController *popMenuViewController;

@end

@implementation PCULinkMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor {
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self.contentNode addSubnode:self.backgroundImageNode];
        [self.contentNode addSubnode:self.titleNode];
        [self.contentNode addSubnode:self.thumbImageNode];
        [self.contentNode addSubnode:self.subTitleNode];
        if ([[self linkMessageInteractor] largerLink]) {
            [self.contentNode addSubnode:self.dateNode];
        }
    }
    return self;
}

#pragma mark - Layout

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    if ([[self linkMessageInteractor] largerLink]) {
        [self.titleNode measure:CGSizeMake(constrainedSize.width - kLargerLinkLRSpace * 2 - kLargerContentLRSpace * 2, CGFLOAT_MAX)];
        [self.dateNode measure:CGSizeMake(constrainedSize.width - kLargerLinkLRSpace * 2 - kLargerContentLRSpace * 2, CGFLOAT_MAX)];
        [self.subTitleNode measure:CGSizeMake(constrainedSize.width - kLargerLinkLRSpace * 2 - kLargerContentLRSpace * 2, CGFLOAT_MAX)];
        CGFloat contentHeight = 0;
        contentHeight += 14.0 + self.titleNode.calculatedSize.height;
        contentHeight += 6.0 + self.dateNode.calculatedSize.height;
        CGFloat imageWidth = constrainedSize.width - kLargerLinkLRSpace * 2 - kLargerContentLRSpace * 2;
        CGFloat imageHeight = imageWidth / (kLargerThumbImageRatio);
        contentHeight += 10.0 + imageHeight;
        contentHeight += 10.0 + self.subTitleNode.calculatedSize.height;
        contentHeight += 14.0;
        self.contentNode.frame = CGRectMake(0, kLinkCellTBSpace, constrainedSize.width, contentHeight);
        return CGSizeMake(constrainedSize.width, contentHeight + kCellGaps + kLinkCellTBSpace * 2);
    }
    return constrainedSize;
}

- (void)layout {
    self.backgroundImageNode.frame = CGRectMake(kLargerLinkLRSpace, 0, self.calculatedSize.width - kLargerLinkLRSpace * 2, self.calculatedSize.height - kCellGaps - kLinkCellTBSpace * 2);
    if ([[self linkMessageInteractor] largerLink]) {
        self.titleNode.frame = CGRectMake(kLargerLinkLRSpace + kLargerContentLRSpace,
                                          14,
                                          self.titleNode.calculatedSize.width,
                                          self.titleNode.calculatedSize.height);
        self.dateNode.frame = CGRectMake(kLargerLinkLRSpace + kLargerContentLRSpace,
                                         self.titleNode.frame.origin.y + self.titleNode.frame.size.height + 6.0,
                                         self.dateNode.calculatedSize.width,
                                         self.dateNode.calculatedSize.height);
        CGFloat imageWidth = self.calculatedSize.width - kLargerLinkLRSpace * 2 - kLargerContentLRSpace * 2;
        CGFloat imageHeight = imageWidth / (kLargerThumbImageRatio);
        self.thumbImageNode.frame = CGRectMake(kLargerLinkLRSpace + kLargerContentLRSpace,
                                               self.dateNode.frame.origin.y + self.dateNode.frame.size.height + 10.0,
                                               imageWidth,
                                               imageHeight);
        self.subTitleNode.frame = CGRectMake(kLargerLinkLRSpace + kLargerContentLRSpace,
                                             self.thumbImageNode.frame.origin.y + self.thumbImageNode.frame.size.height + 10.0,
                                             self.subTitleNode.calculatedSize.width,
                                             self.subTitleNode.calculatedSize.height);
    }
    [self updateLayoutWithContentFrame:self.backgroundImageNode.frame];
}

#pragma mark - PCUPopMenuViewControllerDelegate

- (void)handleBackgroundImageNodeTapped {
    if ([self.delegate respondsToSelector:@selector(PCURequireOpenURL:)]) {
        [self.delegate PCURequireOpenURL:[NSURL URLWithString:[[self linkMessageInteractor] linkURLString]]];
    }
}

- (void)handleBackgroundImageNodeLongPress:(UILongPressGestureRecognizer *)sender {
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
        [[UIPasteboard generalPasteboard] setPersistent:YES];
        [[UIPasteboard generalPasteboard] setString:[[self linkMessageInteractor] linkURLString]];
    }
    else if (itemIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(PCURequireDeleteMessageItem:)]) {
            [self.delegate PCURequireDeleteMessageItem:self.messageInteractor.messageItem];
        }
    }
    else if (itemIndex == 2) {
        if ([self.delegate respondsToSelector:@selector(PCURequireForwardMessageItem:)]) {
            [self.delegate PCURequireForwardMessageItem:self.messageInteractor.messageItem];
        }
    }
    else if (itemIndex == 3) {
        [self.cellDelegate mainViewShouldEnteringSeletionMode];
    }
}

#pragma mark - Getter

- (PCULinkMessageItemInteractor *)linkMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASTextNode *)titleNode {
    if (_titleNode == nil) {
        _titleNode = [[ASTextNode alloc] init];
        if ([self linkMessageInteractor].titleString != nil) {
            if ([[self linkMessageInteractor] largerLink]) {
                NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                        initWithString:[self linkMessageInteractor].titleString
                                                        attributes:@{
                                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
                                                        NSForegroundColorAttributeName: [UIColor blackColor]
                                                        }];
                _titleNode.attributedString = attributedString;
            }
        }
    }
    return _titleNode;
}

- (ASTextNode *)dateNode {
    if (_dateNode == nil) {
        _dateNode = [[ASTextNode alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日"];
        NSString *dateString = [dateFormatter stringFromDate:[[[self linkMessageInteractor] messageItem] messageDate]];
        if (dateString != nil) {
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithString:dateString
                                                    attributes:@{
                                                                 NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                                                 NSForegroundColorAttributeName: [UIColor grayColor]
                                                                 }];
            _dateNode.attributedString = attributedString;
        }
    }
    return _dateNode;
}

- (ASImageNode *)thumbImageNode {
    if (_thumbImageNode == nil) {
        _thumbImageNode = [[ASNetworkImageNode alloc] initWithCache:[PCUImageManager sharedInstance]
                                                         downloader:[PCUImageManager sharedInstance]];
        _thumbImageNode.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageNode.layer.masksToBounds = YES;
        if ([[self linkMessageInteractor] thumbURLString] != nil) {
            [(ASNetworkImageNode *)_thumbImageNode
             setURL:[NSURL URLWithString:[[self linkMessageInteractor] thumbURLString]]];
            _thumbImageNode.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _thumbImageNode.layer.borderWidth = 0.35f;
        }
    }
    return _thumbImageNode;
}

- (ASTextNode *)subTitleNode {
    if (_subTitleNode == nil) {
        _subTitleNode = [[ASTextNode alloc] init];
        if ([self linkMessageInteractor].subTitleString != nil) {
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithString:[self linkMessageInteractor].subTitleString
                                                    attributes:@{
                                                                 NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                                                 NSForegroundColorAttributeName: [UIColor grayColor]
                                                                 }];
            _subTitleNode.attributedString = attributedString;
        }
    }
    return _subTitleNode;
}

- (ASImageNode *)backgroundImageNode {
    if (_backgroundImageNode == nil) {
        if ([self linkMessageInteractor].largerLink) {
            _backgroundImageNode = [[ASImageNode alloc] init];
            _backgroundImageNode.backgroundColor = [UIColor whiteColor];
            _backgroundImageNode.layer.cornerRadius = 8.0f;
            _backgroundImageNode.layer.borderWidth = 0.35f;
            _backgroundImageNode.layer.borderColor = [UIColor grayColor].CGColor;
            _backgroundImageNode.userInteractionEnabled = YES;
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleBackgroundImageNodeLongPress:)];
            gesture.minimumPressDuration = 0.35;
            [_backgroundImageNode.view addGestureRecognizer:gesture];
            [_backgroundImageNode addTarget:self
                                     action:@selector(handleBackgroundImageNodeTapped)
                           forControlEvents:ASControlNodeEventTouchUpInside];
        }
    }
    return _backgroundImageNode;
}

- (PCUPopMenuViewController *)popMenuViewController {
    if (_popMenuViewController == nil) {
        _popMenuViewController = [[PCUPopMenuViewController alloc] init];
        _popMenuViewController.titles = @[@"复制", @"删除", @"转发", @"更多..."];
        _popMenuViewController.delegate = self;
    }
    return _popMenuViewController;
}

@end
