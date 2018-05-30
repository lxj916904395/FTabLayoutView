//
//  FTabView.h
//  LeGu
//
//  Created by 梁显杰 on 2018/5/17.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTabLayoutConfig : NSObject
@property(assign ,nonatomic) CGFloat lineWidth;//底部滑块宽度
@property(assign ,nonatomic) CGFloat lineHeight;//底部滑块高度
@property(strong ,nonatomic) UIColor *lineColor;//底部滑块颜色
@property(strong ,nonatomic) UIFont * font;//字体大小
@property(strong ,nonatomic) UIColor * selectColor;//选中颜色
@property(strong ,nonatomic) UIColor * nolmalColor;//未选中颜色

@property(strong ,nonatomic) NSArray * texts;//标题

@end


@protocol FTabViewDelegate;
@interface FTabLayoutView : UIView

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

