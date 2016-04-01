//
//  TTTextView.m
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/31.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "TTTextView.h"

@implementation TTTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpKeyboard];
        self.dotvalue = 2;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpKeyboard];
        self.dotvalue = 2;
    }
    return self;
}

- (void)setUpKeyboard
{
    NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
    keyboard.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    self.inputView = keyboard;
}

// 成为第一响应者
- (BOOL)becomeFirstResponder
{
    BOOL bflag = [super becomeFirstResponder];
    if(bflag)
    {
        NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
        keyboard.textView = self;
        keyboard.delegate = self;
        keyboard.dotvalue = self.dotvalue;
    }
    return bflag;
}

- (BOOL)resignFirstResponder
{
    NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
    if (keyboard.textView == self)
    {
        keyboard.textView = nil;
        keyboard.delegate = nil;
    }
    return [super resignFirstResponder];
}

-(void)setDotvalue:(NSUInteger)dotvalue
{
    _dotvalue = dotvalue;
    NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
    keyboard.dotvalue = dotvalue;
}

- (void)NumberKeyboard:(NumberKeyboardView *)keyboard didClickWithButton:(id)button
{
    //    UIButton *btn = (UIButton *)button;
    //    NSString *text = self.text;
}


@end
