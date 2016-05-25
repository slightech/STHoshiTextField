//
//  STHoshiTextField.h
//  STHoshiTextField
//
//  Created by gejw on 16/5/25.
//  Copyright © 2016年 slightech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STHoshiTextField : UITextField

// 底部横线高亮颜色
@property (nonatomic, strong) IBInspectable UIColor *borderInactiveColor;
// 底部横线普通颜色
@property (nonatomic, strong) IBInspectable UIColor *borderActiveColor;
// placehodler颜色
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
// placeholder字体大小
@property (nonatomic, assign) IBInspectable CGFloat placeholderFontScale;

@end
