//
//  TTKeyboardView.m
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/30.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "NumberKeyboardView.h"
#import "UIImage+Category.h"
#import "GlobeConst.h"

static NumberKeyboardView* keyboardViewInstance = nil;

@implementation NumberKeyboardView
{
    UIButton* _backButton;
}

+(NumberKeyboardView *)shareKeyboardView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NumberKeyboardView" owner:self options:nil];
        if(nib && [nib count] > 0 )
        {
            keyboardViewInstance = [nib objectAtIndex:0];
        }

    });
    return keyboardViewInstance;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        for (UIButton *btn in self.subviews)
        {
            // 分割线，此种方法不合适，换成添加分割线
            btn.layer.borderWidth = .25f;
            btn.layer.borderColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0].CGColor;
            
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        }
    }
    return self;
}

#pragma mark - UIInputViewAudioFeedback
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (IBAction)keyboardClick:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
    
    UIButton *btn = (UIButton *)sender;
    NSString *strValue = nil;
    if ([self.textView isKindOfClass:[UITextView class]])
    {
        strValue = ((UITextView *)self.textView).text;
    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
        strValue = ((UITextField *)self.textView).text;
    }
    
    // 利用textView 在此处修改text，而不是去textField textView修改2遍
    if ([self.delegate respondsToSelector:@selector(NumberKeyboard:didClickWithButton:)])
    {
        // 这样处理的话 这个代理暂时没有用了
        [self.delegate NumberKeyboard:self didClickWithButton:btn];
    }
    
    if (btn.tag <= 100) // 文本
    {
        [self setTextWithSender:btn OriginalText:strValue];
    }
    else // 功能
    {
        switch (btn.tag)
        {
            case 200: // ABC
            {
                id tempTextView = _textView;
                [tempTextView setInputView:nil];
                [tempTextView reloadInputViews];
                [self addBackKeyboardButton:@"More-Key"];
            }
                break;
            case 201: // del
            {
                if(_textView && [_textView respondsToSelector:@selector(deleteBackward)])
                {
                    [_textView deleteBackward];
                }
                else
                {
                    id tempTextView = _textView;
                    if(strValue.length <= 0)
                        return;
                    // 当前文字
                    NSMutableString* strText = [[NSMutableString alloc] initWithString:[tempTextView text]];
                    // 最后一个字符
                    NSRange theRange = NSMakeRange(strText.length-1, 1);
                    [strText deleteCharactersInRange:theRange];
                    [tempTextView setText:[NSString stringWithFormat:@"%@",strText]];
                    [tempTextView setNeedsDisplay];
                }

            }
                break;
            case 202: // 隐藏
            case 203: // 确定
            {
                
                if ([self.textView isKindOfClass:[UITextView class]])
                    [(UITextView *)self.textView resignFirstResponder];
                
                else if ([self.textView isKindOfClass:[UITextField class]])
                    [(UITextField *)self.textView resignFirstResponder];
            }
                break;
                
            default:
                break;
        }
    }

}

- (void)setTextWithSender:(UIButton *)sender OriginalText:(NSString *)strValue
{
    if (sender.tag == 11) // 输入的是小数点
    {
        // 如果已经有点了，不能输入
        if ([strValue rangeOfString:@"."].length != 0)
        {
            return;
        }
        else // 第一次输入.
        {
            // 如果上来就输入了一个小数点 补0
            if ([strValue length] <= 0)
                [self.textView insertText:@"0."];
            else
                [self.textView insertText:sender.titleLabel.text];
        }
    }
    else // 普通文本
    {
        if ([strValue rangeOfString:@"."].length > 0)// 输入文本 原本已经输入过小数点
        {
            //根据小数点分割字符串，然后操作
            NSArray *ay = [strValue componentsSeparatedByString:@"."];
            // 整数值
            NSString *strFirst = [ay objectAtIndex:0];
            // 原有的小数值
            NSString *strDecimal = [ay objectAtIndex:1];
            if (strDecimal && [strDecimal length] > 0) // 已有小数
            {
                if ([strDecimal length] >= self.dotvalue)//超过了允许的小数点位数，不可输入
                    return;
                
                // 可以输入 字符串追加需要输入的数字
                strDecimal = [NSString stringWithFormat:@"%@%@", strDecimal, sender.titleLabel.text];
                if ([strDecimal length] >= self.dotvalue)//超过截断
                {
                    strDecimal = [strDecimal substringToIndex:self.dotvalue];
                }
                //生成新的
                strValue = [NSString stringWithFormat:@"%@.%@", strFirst, strDecimal];
                
            }
            else // 原本无小数
            {
                NSString *title = [sender titleLabel].text;
                if ([title length] >= self.dotvalue)
                {
                    title = [title substringToIndex:self.dotvalue];
                }
                strValue = [NSString stringWithFormat:@"%@.%@", strFirst, title];
            }
            
        }
        else//没有小数点，则直接输入拼接，去掉开始的0
        {
            strValue = [NSString stringWithFormat:@"%@%@", strValue, [sender titleLabel].text];
            
            while ([strValue hasPrefix:@"0"] && [strValue length] > 1)
            {
                strValue = [strValue substringFromIndex:1];
            }
        }
        // 设置文字
        if ([self.textView isKindOfClass:[UITextView class]])
        {
            [(UITextView*)self.textView setText:strValue];
            return;
        }
        else if ([self.textView isKindOfClass:[UITextField class]])
        {
            [(UITextField*)self.textView setText:strValue];
            return;
        }
        
        //            [self.textView insertText:btn.titleLabel.text];
    }

}

/**
 *  增加切换回键盘的按钮
 *
 */
- (void)addBackKeyboardButton:(NSString *)name
{
    // 找到了系统键盘123的view
    UIView *view = [self findKeyView:name];
    if (view)
    {
        [self removeBackButton];
        if(_backButton == nil)
        {
            UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
            CGRect rect=[view convertRect: view.bounds toView:window];
            
            CGFloat y = rect.origin.y;
            CGFloat x = rect.origin.x;
            _backButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, view.frame.size.width, view.frame.size.height)];
            [_backButton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
            [view.window addSubview:_backButton];
        }
    }
}

// 切换回数字键盘
- (void)onClickBack:(id)sender
{
    if ([self.textView isKindOfClass:[UITextView class]])
    {
        UITextView * pActiveView = (UITextView *)self.textView;
        NumberKeyboardView* ppKeyboard = [NumberKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            [self removeBackButton];
            [pActiveView setInputView:ppKeyboard];
            [pActiveView reloadInputViews];
        }
        
    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
        UITextField * pActiveView = (UITextField *)self.textView;
        NumberKeyboardView* ppKeyboard = [NumberKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            [self removeBackButton];
            [pActiveView setInputView:ppKeyboard];
            [pActiveView reloadInputViews];
        }
        
    }
}

- (UIView *)findKeyView:(NSString *)name
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (windows.count < 2)
        return nil;
    UIView *view = [self findKeyView:name inView:[windows objectAtIndex:1]];
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 9) // iOS9下键盘会获取不到，多了一层
    {
        if (view == nil && windows.count > 2)
        {
            UIView *view = [self findKeyView:name inView:[windows objectAtIndex:2]];
            return view;
        }
    }
    return view;
}

- (UIView *)findKeyView:(NSString *)name inView:(UIView *)view
{
    for (id subview in view.subviews)
    {
        NSString *className = NSStringFromClass([subview class]);
        if ([className isEqualToString:@"UIKBKeyView"])
        {
 
            // 每个键盘key
            if ([subview respondsToSelector:@selector(key)])
            {
                id subviewkey = [subview key];
                if([subviewkey respondsToSelector:@selector(name)])
                {
                    // key的name
                    NSString* strKeyname = [NSString stringWithFormat:@"%@",[subviewkey name]];
                    // 是否是more
                    if ((name == nil) || [name isEqualToString:strKeyname])
                    {
                        return subview;
                    }
                }
            }
        }
        else
        {
            UIView *subview2 = [self findKeyView:name inView:subview];
            if(subview2)
                return subview2;
        }
    }
    return nil;
}

- (void)removeBackButton
{
    if(_backButton)
    {
        [_backButton removeFromSuperview];
        _backButton = nil;
    }
}



@end
