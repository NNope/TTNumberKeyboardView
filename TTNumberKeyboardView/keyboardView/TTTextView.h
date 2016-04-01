//
//  TTTextView.h
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/31.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

/**
 *  TextView其实一般都不会用到这2种键盘，此处只适配了普通数字键盘，未支持随机数键盘
 *
 *  @param nonatomic <#nonatomic description#>
 *  @param assign    <#assign description#>
 *
 *  @return <#return value description#>
 */
#import <UIKit/UIKit.h>
#import "NumberKeyboardView.h"

@interface TTTextView : UITextView<NumberKeyboardViewDelegate>
@property (nonatomic, assign) NSUInteger dotvalue;
@end
