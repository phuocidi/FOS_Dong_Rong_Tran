//
//  LoginViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "LoginViewController.h"
#import "SingleLineUITextField.h"
#import "HomePageViewController.h"
#import "ResetPasswordViewController.h"
#import "WebService.h"
#import "UserModel.h"
#import "TWMessageBarManager.h"
#import "AMPopTip.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    BOOL areFieldsValid;
}
@property(weak, nonatomic) IBOutlet SingleLineUITextField * mobileField;
@property(weak, nonatomic) IBOutlet SingleLineUITextField * passwordField;
@property(weak, nonatomic) IBOutlet UIButton * doneButton;
@property(weak, nonatomic) IBOutlet UIButton * rerestButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mobileField.delegate = self;
    self.passwordField.delegate = self;
    
    self.mobileField.textColor = [UIColor whiteColor];
    self.passwordField.textColor = [UIColor whiteColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,0.0f,screenWidth,50.0f)];
    [toolbar setTintColor: [UIColor darkGrayColor]];
    
    UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(userDidFinishEditingDatePickerField:)];
    // space bar
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    
    // Customize keyboard
    [self.mobileField setInputAccessoryView:toolbar];
    
}

- (void) userDidFinishEditingDatePickerField:(id)sender {
    [self textFieldShouldReturn:self.mobileField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(SingleLineUITextField *)textField
{
    // restore effect once editting
    [UIView animateWithDuration:0.5 animations:^{
        textField.transform = CGAffineTransformMakeScale(1.1, 1.1) ;
    } completion:^(BOOL finished) {
        textField.transform = CGAffineTransformIdentity;
    }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    //Username /  Email field
    if (textField.tag == 1){
        // General validation
        if(str.length<10 || str.length>13){
            [(SingleLineUITextField*)textField setError:YES message:@"Mobile number must contains 10 to 13 numbers"];
            areFieldsValid = NO;
            return YES;
        }
    }
    // Check password field
    if (textField.tag == 2) {
        NSString *regex = @"^(?=.{8,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$";
        
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isValid = [passwordTest evaluateWithObject:textField.text];
        if(!isValid) {
            [(SingleLineUITextField*)textField setError:YES message:@"Need 8 characters, Must contain at least one lower case letter, one upper case letter, one digit and one special character"];
            areFieldsValid = NO;
            return YES;
        }
        
    }
    
    [(SingleLineUITextField*)textField setError:NO message:nil];
    areFieldsValid = YES;
    return YES;
}



/*


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"loginToHomeSegue"]) {
        User *user = [User sharedInstance];
        user.phone = self.mobileField.text;
        
        [[WebService sharedInstance] loginByPhone:self.mobileField.text userPassword:self.passwordField.text completionHandler:^(BOOL successful) {
            if (successful) {
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Login successfully!"
                                                               description:@""
                                                                      type:TWMessageBarMessageTypeSuccess
                                                                  duration:1.0 ];
            } else {
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Login falied!"
                                                               description:@"please try again"
                                                                      type:TWMessageBarMessageTypeError duration:1.0];
            }
        }];
    }
    return YES;
}

#pragma mark - Navigation


- (IBAction)resetButtonClick:(id)sender
{
    ResetPasswordViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
