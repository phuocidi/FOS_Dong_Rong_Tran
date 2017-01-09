//
//  RegisterViewController.m
//  FOS_Dong_Rong_Tran
//
//  Created by Huu Tran on 1/1/17.
//  Copyright © 2017 rjtcompuquest. All rights reserved.
//

#import "RegisterViewController.h"
#import "SingleLineUITextField.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "Webservice.h"
#import "User.h"
#import "TWMessageBarManager.h"
#import "AMPopTip.h"
#import "AppDelegate.h"

//// Pass parameters for registration like "user_name=aamir" ," user_email=aa@gmail.com" , “user_phone=55565454", " user_password=7011”, “user_add=Delhi"
@interface RegisterViewController () <UITextFieldDelegate>
{
    BOOL areFieldsValid;
}
@property (weak, nonatomic) IBOutlet SingleLineUITextField * userNameField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField * userEmailField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField * userPhoneField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField * userPasswordField;
@property (weak, nonatomic) IBOutlet SingleLineUITextField * userAddressField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerButton.layer.cornerRadius = self.registerButton.layer.frame.size.height/2;

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
    [self.userPhoneField setInputAccessoryView:toolbar];
    
}

- (void) userDidFinishEditingDatePickerField:(id)sender {
    [self textFieldShouldReturn:self.userPhoneField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // restore effect once editting
    [UIView animateWithDuration:0.4 animations:^{
        textField.transform = CGAffineTransformMakeScale(1.2, 1.2) ;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)registerButtonClicked:(id)sender {
    UserModel * userManager = [[UserModel alloc] init];
    
    int user_phone = [self.userPhoneField.text intValue];
    NSString * userName = self.userNameField.text;
    NSString * userEmail = self.userEmailField.text;
    NSString * password = self.userPasswordField.text;
    NSString * address = self.userAddressField.text;
    
    
    [[WebService sharedInstance] registerByPhone:self.userPhoneField.text userName:userName userEmail:userEmail userPassword:password address:address completionHandler:^(BOOL successful) {
        if (successful) {
            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            CGFloat longitude =  appDelegate.manager.location.coordinate.longitude;
            CGFloat latitude = appDelegate.manager.location.coordinate.latitude;
            [userManager createUser:user_phone name:userName email:userEmail password:password add:address longtitude:longitude latitude:latitude];
            
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Register successfully!"
                                                           description:@""
                                                                  type:TWMessageBarMessageTypeSuccess
                                                              duration:1.0 ];
            dispatch_async(dispatch_get_main_queue(), ^{
                LoginViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            });

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Register falied!"
                                                                                                                   description:@"Mobile number already exist"
                                                                                                                          type:TWMessageBarMessageTypeError];});
            

        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    // Check password field
    if (textField.tag == 3) {
        NSString *regex = @"^(?=.{8,})(?=.*[0-9])(?=.*[a-zA-Z])([@#$%^&=a-zA-Z0-9_-]+)$";
        
        NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        BOOL isValid = [passwordTest evaluateWithObject:textField.text];
        if(!isValid) {
            [(SingleLineUITextField*)textField setError:YES message:@"Need 8 characters, Must contain at least one lower case letter, one upper case letter, one digit and one special character"];
            areFieldsValid = NO;
            return YES;
        }
        
    }
    
    // Mobile phone length is 10-13
    if(textField.tag == 2 ){
        if(str.length <10 || str.length>13) {
            [(SingleLineUITextField*)textField setError:YES message:@"Mobile phone must contains 10-13 numbers"];
            areFieldsValid = NO;
            return YES;
        }
        
    }
    
    //Email field
    
    if (textField.tag == 4){
        NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
        BOOL isValid = [emailTest evaluateWithObject:textField.text];
        if (! isValid) {
            [(SingleLineUITextField*)textField setError:YES message:@"Invalid email format"];
            areFieldsValid = NO;
            return YES;
        }
    }
    
    // General validation
    if (str.length < 3){
        [(SingleLineUITextField*)textField setError:YES message:@"Must contains more than 3 characters"];
        areFieldsValid = NO;
        return YES;
    }
    
    if ( [str containsString:@" "]) {
        if( textField.tag!= 5 || textField.tag != 6 ){
            [(SingleLineUITextField*)textField setError:YES message:@"Can not have space"];
            areFieldsValid = NO;
            return YES;
        }
        
    }
    
    [(SingleLineUITextField*)textField setError:NO message:nil];
    areFieldsValid = YES;
    return YES;
}

@end
