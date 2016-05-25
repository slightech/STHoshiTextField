//
//  ViewController.m
//  STHoshiTextFieldDemo
//
//  Created by gejw on 16/5/25.
//  Copyright © 2016年 slightech. All rights reserved.
//

#import "ViewController.h"
#import "STHoshiTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        STHoshiTextField *textField = [[STHoshiTextField alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
        textField.placeholder = @"请输入用户名";
        textField.font = [UIFont systemFontOfSize:15];
        textField.borderActiveColor = [UIColor colorWithRed:0.17 green:0.54 blue:0.88 alpha:1.00];
        textField.borderInactiveColor = [UIColor colorWithRed:0.45 green:0.80 blue:0.45 alpha:1.00];
        textField.placeholderColor = [UIColor colorWithRed:0.87 green:0.58 blue:0.16 alpha:1.00];
        [self.view addSubview:textField];
    }
    
    {
        STHoshiTextField *textField = [[STHoshiTextField alloc] initWithFrame:CGRectMake(10, 150, 300, 50)];
        textField.placeholder = @"请输入用户名";
        textField.font = [UIFont systemFontOfSize:15];
        textField.borderActiveColor = [UIColor colorWithRed:0.17 green:0.54 blue:0.88 alpha:1.00];
        textField.borderInactiveColor = [UIColor colorWithRed:0.45 green:0.80 blue:0.45 alpha:1.00];
        textField.placeholderColor = [UIColor colorWithRed:0.87 green:0.58 blue:0.16 alpha:1.00];
        [self.view addSubview:textField];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
