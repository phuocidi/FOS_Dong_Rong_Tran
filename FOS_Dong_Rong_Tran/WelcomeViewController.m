//
//  WelcomeViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
//----------------------------------
@interface WelcomeViewController ()
{
    NSInteger currentImageIndex;
}
@property (copy, atomic) NSArray <UIImage *> *bgImages;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *brandIV;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

//----------------------------------
@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image0 = [UIImage imageNamed:@"login_bg_0"];
    UIImage * image1 = [UIImage imageNamed:@"login_bg_1"];
    UIImage * image2 = [UIImage imageNamed:@"login_bg_2"];
    
    self.bgImages = [NSArray arrayWithObjects:image0, image1, image2, nil];
    self.bgImageView.image = self.bgImages[0];
    //self.bgImageView.layer.opacity = 1.0;
    ++currentImageIndex;
    
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(changeImage)
                                   userInfo:nil
                                    repeats:YES];
    
    self.registerButton.layer.cornerRadius = 3.0;
    self.registerButton.layer.masksToBounds = YES;

    // motion effect
    [self applyMotionEffectToView:self.bgImageView magnitude:15];
    [self applyMotionEffectToView:self.registerButton magnitude:-30];
    [self applyMotionEffectToView:self.loginButton magnitude:-30];
    [self applyMotionEffectToView:self.brandIV magnitude:-30];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeImage {
    
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bgImageView.layer.opacity = 0.0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bgImageView.image = self.bgImages[currentImageIndex++];
            
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1 animations:^{
                self.bgImageView.layer.opacity = 1;
            }];
            
        }];
    }];
    
    if (currentImageIndex == self.bgImages.count){
        currentImageIndex = 0;
    }
}

- (void) applyMotionEffectToView:(UIView*)view magnitude:(CGFloat)magnitude {
    UIInterpolatingMotionEffect * xMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xMotion.minimumRelativeValue = @(-magnitude);
    xMotion.maximumRelativeValue =@(magnitude);
    
    UIInterpolatingMotionEffect * yMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yMotion.minimumRelativeValue = @(-magnitude);
    yMotion.maximumRelativeValue =@(magnitude);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[xMotion, yMotion];
    
    [view addMotionEffect:group];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerButtonClicked:(id)sender {
    RegisterViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    LoginViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
