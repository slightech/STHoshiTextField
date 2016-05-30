//
//  STHoshiTextField.m
//  STHoshiTextField
//
//  Created by gejw on 16/5/25.
//  Copyright © 2016年 slightech. All rights reserved.
//

#import "STHoshiTextField.h"

@implementation NSString (Empty)

- (BOOL)isNotEmpty {
    return self != nil && self.length > 0;
}

- (BOOL)isEmpty {
    return self == nil || self.length == 0;
}

@end

@interface STHoshiTextField() {
    
}

@property (nonatomic, assign) CGFloat inactive;

@property (nonatomic, assign) CGPoint placeholderInsets;

@property (nonatomic, assign) CGPoint textFieldInsets;

@property (nonatomic, strong) CALayer *inactiveBorderLayer;

@property (nonatomic, strong) CALayer *activeBorderLayer;

@property (nonatomic, assign) CGPoint activePlaceholderPoint;

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation STHoshiTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commitIn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitIn];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commitIn];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commitIn {
    _active = 1;
    _inactive = 0.5;
    _placeholderInsets = CGPointMake(0, 6);
    _textFieldInsets = CGPointMake(0, 15);
    _activePlaceholderPoint = CGPointZero;
    _placeholderFontScale = 0.65;
    _placeholderColor = [UIColor blackColor];
    _activeBorderLayer = [[CALayer alloc] init];
    _inactiveBorderLayer = [[CALayer alloc] init];
    _placeholderLabel = [[UILabel alloc] init];
    
    if (self.placeholder) {
        [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}]];
    }
}

- (void)setActive:(CGFloat)active {
    _active = active;
    [self updateBorder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateBorder];
    [self updatePlaceholder];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (!text && [text isNotEmpty]) {
        [self animateViewsForTextEntry];
    } else {
        [self animateViewsForTextDisplay];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self updatePlaceholder];
    if (placeholder) {
        [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}]];
    }
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    [self updateBorder];
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    placeholderColor = placeholderColor;
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    [self updatePlaceholder];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawViewsForRect:rect];
}

- (void)drawViewsForRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    _placeholderLabel.frame = CGRectInset(frame, _placeholderInsets.x, _placeholderInsets.y);
    _placeholderLabel.font = [self placeholderFontFromFont:self.font];
    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer addSublayer:_inactiveBorderLayer];
    [self.layer addSublayer:_activeBorderLayer];
    [self addSubview:_placeholderLabel];
}

- (void)animateViewsForTextDisplay {
    if ([self.text isEmpty]) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.alpha = 1;
        } completion:nil];
        _activeBorderLayer.frame = [self rectForBorder:_active isFilled:false];
    }
}

- (void)animateViewsForTextEntry {
    if ([self.text isEmpty]) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _placeholderLabel.frame = CGRectMake(10, _placeholderLabel.frame.origin.y, _placeholderLabel.frame.size.width, _placeholderLabel.frame.size.height);
            _placeholderLabel.alpha = 0;
        } completion:nil];
    }
    
    [self layoutPlaceholderInTextRect];
    _placeholderLabel.frame = CGRectMake(_activePlaceholderPoint.x, _activePlaceholderPoint.y, _placeholderLabel.frame.size.width, _placeholderLabel.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.placeholderLabel.alpha = 0.5;
    }];
    _activeBorderLayer.frame = [self rectForBorder:_active isFilled:true];
}

- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    if (notification.object == self) {
        [self animateViewsForTextEntry];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    if (notification.object == self) {
        [self animateViewsForTextDisplay];
    }
}

- (void)prepareForInterfaceBuilder {
    [self drawViewsForRect:self.frame];
}

- (void)updateBorder {
    _inactiveBorderLayer.frame = [self rectForBorder:_inactive isFilled:true];
    _inactiveBorderLayer.backgroundColor = _borderInactiveColor.CGColor;
    
    _activeBorderLayer.frame = [self rectForBorder:_active isFilled:false];
    _activeBorderLayer.backgroundColor = _borderActiveColor.CGColor;
}

- (void)updatePlaceholder {
    _placeholderLabel.text = self.placeholder;
    _placeholderLabel.textColor = self.placeholderColor;
    [_placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if ([self isFirstResponder] || [self.text isNotEmpty]) {
        [self animateViewsForTextEntry];
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    return [UIFont fontWithName:font.fontName size:font.pointSize * _placeholderFontScale];
}

- (CGRect)rectForBorder:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
    } else {
        return CGRectMake(0, CGRectGetHeight(self.frame) - thickness, 0, thickness);
    }
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width / 2 - _placeholderLabel.bounds.size.width / 2;
            break;
        case NSTextAlignmentRight:
            originX += textRect.size.width - _placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    _placeholderLabel.frame = CGRectMake(originX, textRect.size.height / 2, _placeholderLabel.bounds.size.width, _placeholderLabel.bounds.size.height);
    _activePlaceholderPoint = CGPointMake(_placeholderLabel.frame.origin.x, _placeholderLabel.frame.origin.y - _placeholderLabel.frame.size.height - _placeholderInsets.y);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, _textFieldInsets.x, _textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, _textFieldInsets.x, _textFieldInsets.y);
}

@end
