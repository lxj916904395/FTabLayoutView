//
//  FTabView.m
//  LeGu
//
//  Created by 梁显杰 on 2018/5/17.
//  Copyright © 2018年 zhongding. All rights reserved.
//

#import "FTabLayoutView.h"

@interface FTabLayoutView()
@property(strong ,nonatomic) UIView * colorLine;
@property(strong ,nonatomic) NSMutableArray<FTabButton *> * btns;
@property(strong ,nonatomic) NSArray<NSString *> * tabTextsArr;
@property(strong ,nonatomic) FTabLayoutConfig * config;

@property(assign ,nonatomic) CGFloat lineWidth;//底线的宽
@property(assign ,nonatomic) CGFloat lineHeight;//底线的高
@property(assign ,nonatomic) UIColor *lineColor;//底线颜色
@property(strong ,nonatomic) UIFont * font;//字体大小
@property(strong ,nonatomic) UIColor * selectColor;//选中颜色
@property(strong ,nonatomic) UIColor * nolmalColor;//未选中颜色

@end
@implementation FTabLayoutView{
    
    CGFloat _tabCount;//tab个数
    CGFloat _labelWidth;//tab宽
    
     CGFloat _contentOffsetX;//vc scrollview 的偏移量
}


- (instancetype)initWithFrame:(CGRect)frame config:(FTabLayoutConfig *)config{
    if (self = [super initWithFrame:frame]) {
        self.config = config;
        [self _createUI];
    }
    return self;
}


- (UIView *)colorLine{
    if (_colorLine == nil) {
        _colorLine = [UIView new];
    }
    return _colorLine;
}

- (NSMutableArray<FTabButton *> *)btns{
    if (!_btns) {
        _btns = @[].mutableCopy;
    }
    return _btns;
}

- (void)_createUI{
    self.userInteractionEnabled =  YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.tabTextsArr = self.config.texts;
    self.lineWidth = self.config.lineWidth;
    self.lineHeight = self.config.lineHeight;
    self.lineColor = self.config.lineColor;
    self.font = self.config.font;
    self.selectColor = self.config.selectColor;
    self.nolmalColor = self.config.nolmalColor;
    
    [self _createViews];
 
    self.index = 0;
}

- (void)_createViews{
    _tabCount = self.tabTextsArr.count;
    _labelWidth = self.width/_tabCount;
    
    for (int i = 0; i < _tabCount; i++) {
        
        FTabButton *btn = [FTabButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:self.tabTextsArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn setTitleColor:self.nolmalColor forState:UIControlStateNormal];
        
        btn.titleLabel.font = self.font;
        btn.tag = i;
        [btn setFrame:CGRectMake(i*_labelWidth, 0, _labelWidth, self.height)];
        [btn addTarget:self action:@selector(doSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5f];
    line.height = 1;
    line.width = self.width;
    line.bottom = self.bottom;
    [self addSubview:line];
    
    [self addSubview:self.colorLine];
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor?selectColor:[UIColor redColor];
}

- (void)setNolmalColor:(UIColor *)nolmalColor{
    _nolmalColor = nolmalColor?nolmalColor:[UIColor grayColor];
}

- (void)setFont:(UIFont *)font{
    _font = font?font:[UIFont systemFontOfSize:17];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor?lineColor:self.selectColor;
    self.colorLine.backgroundColor = _lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth>0?lineWidth:(self.width/self.tabTextsArr.count);
    self.colorLine.width = _lineWidth;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    _lineHeight = lineHeight>0?lineHeight:1.50f;
    self.colorLine.height = _lineHeight;
    self.colorLine.bottom = self.bottom;
}
#pragma mark - 选中标题
- (void)doSelectIndex:(UIButton *)btn{
    self.index = btn.tag;
    
    //代理回调
    if (_delegate && [_delegate respondsToSelector:@selector(tabView:didSelectIndex:)]) {
        [_delegate tabView:self didSelectIndex:btn.tag];
    }
}

- (void)setIndex:(NSInteger)index{
    [self.btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    
    self.btns[index].selected = YES;
    [_colorLine setCenterX:self.btns[index].centerX];
}

#pragma mark - 观察偏移
- (void)setScrollView:(UIScrollView *)scrollView{
    if (scrollView) {
        _scrollView = scrollView;
        [self addObserve];
    }
}
- (void)addObserve{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserve{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //不需要标题动画
    if (!self.isTitleScaleAnimate)return;
    
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat scrollScale = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
   
    if (scrollScale < 0 || scrollScale >= self.tabTextsArr.count - 1) return;
    CGFloat value = ABS(scrollScale);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    
    FTabButton *btnLeft = self.btns[leftIndex];
    FTabButton *btnRight = self.btns[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scrollScale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    btnLeft.scale = leftScale;
    btnRight.scale = rightScale;
    
    CGFloat currentOffset = self.scrollView.contentOffset.x;
    
    //每一次的偏移量
    CGFloat scaleWidth = fabs(currentOffset - _contentOffsetX);
    
    //每一页的偏移量占屏幕宽的比例
    CGFloat scale = scaleWidth/kScreenWidth;
    
    //两个标题中心点的距离
    CGFloat centerWidth = btnRight.centerX - btnLeft.centerX;
    
    //当前标题底线的中心x
    CGFloat lineCenterX = self.colorLine.centerX;
    CGFloat newlineCenterX = 0;
    
    //左滑
    if (currentOffset > _contentOffsetX) {
        newlineCenterX = lineCenterX+centerWidth*scale;
        
    }else{
        newlineCenterX = lineCenterX-centerWidth*scale;
    }
    
    [self.colorLine setCenterX:newlineCenterX];
    
    _contentOffsetX = currentOffset;
}

- (void)dealloc{
    [self removeObserve];
    NSLog(@"%s",__func__);
}

@end

@implementation FTabButton
- (void)setScale:(CGFloat)scale{

    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0.1; // [1, 1.3]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}
@end
