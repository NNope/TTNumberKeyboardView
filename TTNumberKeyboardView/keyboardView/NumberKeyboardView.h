//
//  NumberKeyboardView
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/30.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NumberKeyboardView;

@protocol NumberKeyboardViewDelegate <NSObject>

//键盘点击
/*
    tag
    11 = .
    100 = 100
    200 = ABC
    201 = del
    202 = 隐藏
    203 = 确定
 */
-(void)NumberKeyboard:(NumberKeyboardView*)keyboard didClickWithButton:(id)button;

@end

@interface NumberKeyboardView : UIView

// 可能是textField textView
@property (nonatomic, strong) id<UITextInput> textView;
@property (nonatomic, assign) NSUInteger dotvalue;
@property (nonatomic, weak) id<NumberKeyboardViewDelegate>delegate;

+(NumberKeyboardView *)shareKeyboardView;

@end
