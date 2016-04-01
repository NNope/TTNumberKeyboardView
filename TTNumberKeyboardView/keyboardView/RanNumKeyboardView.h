//
//  RanNumKeyboardView.h
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/4/1.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RanNumKeyboardView;

@protocol RanNumKeyboardViewDelegate <NSObject>

// 随机键盘点击
-(void)RanNumKeyboard:(RanNumKeyboardView*)keyboard didClickWithButton:(id)button;
@end

@interface RanNumKeyboardView : UIView<UIInputViewAudioFeedback>

@property (nonatomic, weak) id<RanNumKeyboardViewDelegate> delegate;

+(RanNumKeyboardView *)shareKeyboardView;

- (void)setRandomNumberText;
@end
