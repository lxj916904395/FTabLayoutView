//
//  FTabView.h
//  LeGu
//
//  Created by 梁显杰 on 2018/5/17.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTabLayoutConfig.h"

@protocol FTabViewDelegate;

@interface FTabLayoutView : UIView

@property(assign ,nonatomic) CGFloat lineWidth;//底线的宽
@property(assign ,nonatomic) CGFloat lineHeight;//底线的高
@property(assign ,nonatomic) UIColor *lineColor;//底线颜色

@property(assign ,nonatomic) NSInteger index;//当前title下标
@property(strong ,nonatomic) UIScrollView * scrollView;

@property(nullable,nonatomic,weak) id<FTabViewDelegate>        delegate;//代理回调

@property(assign ,nonatomic) BOOL isTitleScaleAnimate;//标题大小是否需要动画

- (instancetype)initWithFrame:(CGRect)frame config:(FTabLayoutConfig *)config;
@end



@protocol FTabViewDelegate <NSObject>
- (void)tabView:(FTabLayoutView *)tabView didSelectIndex:(NSInteger)index;
@end





@interface FTabButton : UIButton
@property(assign ,nonatomic) CGFloat scale;
@end

