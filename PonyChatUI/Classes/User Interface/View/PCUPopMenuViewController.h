//
//  KAGPopMenuViewController.h
//  bubble
//
//  Created by 崔 明辉 on 15/8/13.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUPopMenuViewController;

@protocol PCUPopMenuViewControllerDelegate <NSObject>

@optional
- (void)menuItemDidPressed:(PCUPopMenuViewController *)menuViewController itemIndex:(NSUInteger)itemIndex;

@end

@interface PCUPopMenuViewController : UIViewController

@property (nonatomic, weak) id<PCUPopMenuViewControllerDelegate> delegate;

@property (nonatomic, copy) NSArray *titles;

- (void)presentMenuViewControllerWithReferencePoint:(CGPoint)referencePoint;

@end
