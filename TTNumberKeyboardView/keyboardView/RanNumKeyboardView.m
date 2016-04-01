//
//  RanNumKeyboardView.m
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/4/1.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "RanNumKeyboardView.h"
#import "GlobeConst.h"
#import "UIImage+Category.h"

static RanNumKeyboardView* keyboardViewInstance = nil;

@interface RanNumKeyboardView ()
@property (nonatomic, strong) NSArray *arrKeys;
@end

@implementation RanNumKeyboardView
CGFloat const NavigationBarHeight = 64;

+(RanNumKeyboardView *)shareKeyboardView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        keyboardViewInstance  = [[self alloc] init];
        
    });
    return keyboardViewInstance;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    int row = 4;
    int column = 3;
    
    CGFloat keyWidth = frame.size.width / column;
    CGFloat keyHeight = frame.size.height / row;
    CGFloat keyX = 0;
    CGFloat keyY = 0;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < row*column; i++)
    {
        // 行号
        int rrow = i / column;
        // 列号
        int ccol = i % column;
        keyX = ccol * keyWidth;
        keyY = rrow * keyHeight;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(keyX, keyY, keyWidth, keyHeight);
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(keyboardClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        if (i == kKeyboardDelIndex)
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if (i == kKeyboardDoneIndex)
        {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        [array addObject:btn];
    }
    self.arrKeys = array;
    
    // 分割线
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    CGFloat viewW = frame.size.width;
    CGFloat viewH = 0.5;
    for (int i = 0; i < row; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        [self addSubview:view];
        
        viewY += keyHeight;
    }
    
    // 垂直分隔线
    viewX = keyWidth;
    viewY = 0;
    viewW = 0.5;
    viewH = frame.size.height;
    for (int i = 0; i < column - 1; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        [self addSubview:view];
        
        viewX += keyWidth;
    }

}

// 设置键盘文字
- (void)setRandomNumberText
{
    NSMutableArray *numbers = [NSMutableArray array];
    
    int startNum = 0;
    int length = 10;
    
    // 0-9 string
    for (int i = startNum; i < length; i++)
    {
        [numbers addObject:[NSString stringWithFormat:@"%d", i]];
    }
    // settitle
    for (int i = 0; i < self.arrKeys.count; i++)
    {
        UIButton *button = self.arrKeys[i];
        
        if (i == kKeyboardDelIndex) {
            [button setTitle:kKeyboardDeleteText forState:UIControlStateNormal];
            continue;
        } else if (i == kKeyboardDoneIndex) {
            [button setTitle:kKeyboardDoneText forState:UIControlStateNormal];
            continue;
        }
        
        // 0-9
        int index = arc4random() % numbers.count;
        // 换成索引
        [button setTitle:numbers[index] forState:UIControlStateNormal];
        // count减少
        [numbers removeObjectAtIndex:index];
    }
}

- (void)keyboardClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(RanNumKeyboard:didClickWithButton:)])
    {
        [self.delegate RanNumKeyboard:self didClickWithButton:sender];
    }
}

@end
