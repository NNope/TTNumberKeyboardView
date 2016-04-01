//
//  TTTextField.h
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/31.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeyboardView.h"
#import "RanNumKeyboardView.h"

typedef NS_ENUM(NSInteger,KeyboardViewType){
    KeyboardViewNum,
    KeyboardViewRandomNum
};

@interface TTTextField : UITextField<NumberKeyboardViewDelegate,RanNumKeyboardViewDelegate>
/**
 *  随机数 还是 普通数字键盘
 */
@property (nonatomic, assign) KeyboardViewType keyboardViewType;
/**
 *  数字键盘 限制小数位数    默认2位
 */
@property (nonatomic, assign) NSUInteger dotvalue;
/**
 *  随机键盘 限制输入长度    默认不限制
 */
@property (nonatomic, assign) NSUInteger PWDlength;
@end
