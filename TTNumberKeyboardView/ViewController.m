//
//  ViewController.m
//  TTNumberKeyboardView
//
//  Created by 谈Xx on 16/3/30.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 数字键盘
    self.tdNum.keyboardViewType = KeyboardViewNum; // 默认值
    self.tdNum.dotvalue = 3; // 默认2位小数
    // 随机数键盘
    self.tdRanNum.keyboardViewType = KeyboardViewRandomNum;
    self.tdRanNum.PWDlength = 6; // 默认不限制
}



- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
