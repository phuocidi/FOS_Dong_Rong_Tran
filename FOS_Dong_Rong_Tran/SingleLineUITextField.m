//
//  SingleLineUITextField.m
//  ecommerce
//
//  Created by Huu Tran on 12/21/16.
//  Copyright © 2016 rjtcompuquest. All rights reserved.
//

#import "SingleLineUITextField.h"
//-------------------------------
@interface SingleLineUITextField()

@property (strong, nonatomic) CALayer *border;

@end

//-------------------------------
@implementation SingleLineUITextField
//-------------------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.border = [CALayer layer];
        
        CGFloat borderWidth = 2;
        self.border.borderWidth = borderWidth;
        self.border.borderColor = [UIColor colorWithRed:211.0/255.0 green:84.0/255 blue:0.0 alpha:1].CGColor;

        self.border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer: self.border];
        self.layer.masksToBounds = YES;
        
        // Set up poptip
//        self.popTip = [AMPopTip popTip];
//        self.popTip.shouldDismissOnTap = YES;
//        self.popTip.popoverColor = [UIColor purpleColor];
        
        self.imgViewError = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        self.imgViewError.hidden = YES;
        CGFloat height =self.frame.size.height;
        self.imgViewError.frame = CGRectMake(0, 0, height-5, height-5);
        self.imgViewError.userInteractionEnabled = YES;
        
        UIView * iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height) ];
        self.imgViewError.center = iconView.center;
        [iconView addSubview: self.imgViewError];
        
        iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tapGesture.numberOfTapsRequired = 1;

        [iconView addGestureRecognizer:tapGesture];
        self.rightView = iconView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

// tap error image to see error
- (void)imageTapped:(UITapGestureRecognizer*)sender {
//    [self.popTip showText:self.message direction:AMPopTipDirectionUp maxWidth:300 inView:self.superview fromFrame:self.frame];
}


-(instancetype) init{
    if (self = [super init]){
        self.border = [CALayer layer];
        
        CGFloat borderWidth = 2;
        self.border.borderWidth = borderWidth;
        // orange
        self.border.borderColor = [UIColor colorWithRed:1.0 green:149.0/255 blue:0 alpha:1].CGColor;
        self.border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        
        [self.layer addSublayer: self.border];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(instancetype) initWithColor: (UIColor*) color {
    if (self = [super init]){
        self.border = [CALayer layer];
        
        CGFloat borderWidth = 2;
        self.border.borderWidth = borderWidth;
        self.border.borderColor = color.CGColor;
        self.border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
        
        [self.layer addSublayer: self.border];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void) leftViewIconImage:(NSString *)imageName {
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGFloat offset = 5;
    CGFloat height =self.frame.size.height;
    iconImageView.frame = CGRectMake(0, 0, height-offset, height-offset);
    
    UIView * iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height) ];
    
    iconImageView.center = iconView.center;
    [iconView addSubview: iconImageView];
    
    self.leftView = iconView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void) setError:(BOOL)error message:(NSString*)msg {
    self.error = error;
    self.message = msg;
    
    if (error){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgViewError.hidden = NO;
        });
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
    }else{
        self.imgViewError.hidden = YES;
        self.layer.borderWidth = 0;
        
//        [self.popTip hide];
    }
}

@end
