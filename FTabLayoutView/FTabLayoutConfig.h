//
//  FTabLayoutConfig.h
//  BTC
//
//  Created by 梁显杰 on 2018/5/30.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTabLayoutConfig : NSObject
@property(assign ,nonatomic) CGFloat lineWidth;//底部滑块宽度
@property(assign ,nonatomic) CGFloat lineHeight;//底部滑块高度
@property(strong ,nonatomic) UIColor *lineColor;//底部滑块颜色
@property(strong ,nonatomic) UIFont * font;//字体大小
@property(strong ,nonatomic) UIColor * selectColor;//选中颜色
@property(strong ,nonatomic) UIColor * nolmalColor;//未选中颜色

@property(strong ,nonatomic) NSArray * texts;//标题

@end
