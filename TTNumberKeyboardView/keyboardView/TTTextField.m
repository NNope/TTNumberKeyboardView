//
//  TTTextField.m
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/31.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "TTTextField.h"
#import "GlobeConst.h"

@implementation TTTextField


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyboardViewType = KeyboardViewNum;
        self.dotvalue = 2;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.keyboardViewType = KeyboardViewNum;
        self.dotvalue = 2;
    }
    return self;
}

- (void)setUpKeyboard
{
//    TTKeyboardView *keyboard = [TTKeyboardView shareKeyboardView];
//    keyboard.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
//    self.inputView = keyboard;
}

// 成为第一响应者
- (BOOL)becomeFirstResponder
{
    BOOL bflag = [super becomeFirstResponder];
    if(bflag)
    {
        if (self.keyboardViewType == KeyboardViewNum)
        {
            NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
            keyboard.textView = self;
            keyboard.delegate = self;
            keyboard.dotvalue = self.dotvalue;
        }
        else if (self.keyboardViewType == KeyboardViewRandomNum)
        {
            RanNumKeyboardView *ranKeyboard = [RanNumKeyboardView shareKeyboardView];
            ranKeyboard.delegate = self;
            [ranKeyboard setRandomNumberText];

        }
    }
    return bflag;
}

- (BOOL)resignFirstResponder
{
    if (self.keyboardViewType == KeyboardViewNum)
    {
        NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
        if (keyboard.textView == self)
        {
            keyboard.textView = nil;
            keyboard.delegate = nil;
        }
    }
    else if (self.keyboardViewType == KeyboardViewRandomNum)
    {
        RanNumKeyboardView *ranKeyboard = [RanNumKeyboardView shareKeyboardView];
        ranKeyboard.delegate = nil;
        
    }
//    if ([self isFirstResponder])
//    {
//        if (_delegate && [_delegate respondsToSelector:@selector(UIBaseView:focuseChanged:)])
//        {
//            [_delegate UIBaseView:self focuseChanged:self.text];
//        }
//    }
    return [super resignFirstResponder];
}

#pragma mark - setter
-(void)setKeyboardViewType:(KeyboardViewType)keyboardViewType
{
    _keyboardViewType = keyboardViewType;
    if (keyboardViewType == KeyboardViewNum)
    {
        NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
        keyboard.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kKeyboardHeight);
        self.inputView = keyboard;

    }
    else if (keyboardViewType == KeyboardViewRandomNum)
    {
        RanNumKeyboardView *ranKeyboard = [RanNumKeyboardView shareKeyboardView];
        ranKeyboard.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kKeyboardHeight);
        [ranKeyboard setRandomNumberText];
        
        self.inputView = ranKeyboard;

    }
}

-(void)setDotvalue:(NSUInteger)dotvalue
{
    _dotvalue = dotvalue;
    NumberKeyboardView *keyboard = [NumberKeyboardView shareKeyboardView];
    keyboard.dotvalue = dotvalue;
}

#pragma mark - NumberKeyboardViewDelegate
- (void)NumberKeyboard:(NumberKeyboardView *)keyboard didClickWithButton:(id)button
{
    
}

#pragma mark - RanNumKeyboardViewDelegate
- (void)RanNumKeyboard:(RanNumKeyboardView *)keyboard didClickWithButton:(id)button
{
    UIButton *btn = (UIButton *)button;
    if (btn.tag == kKeyboardDelIndex) // 删除
    {
        [self deleteBackward];
    }
    else if (btn.tag == kKeyboardDoneIndex) // 完成
    {
        [self resignFirstResponder];
    }
    else
    {
        // 默认无限制
        if (self.PWDlength != 0)// 若限制
        {
            if (self.text.length >= self.PWDlength)
            {
                return;
            }
        }
        [self insertText:btn.titleLabel.text];
    }
}

@end
