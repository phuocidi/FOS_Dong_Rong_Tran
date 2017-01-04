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


//// Pass parameters for registration like "user_name=aamir" ," user_email=aa@gmail.com" , “user_phone=55565454", " user_password=7011”, “user_add=Delhi"
@interface RegisterViewController () <UITextFieldDelegate>

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
    [textField resignFirstResponder];
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
            [userManager createUser:user_phone name:userName email:userEmail password:password add:address longtitude:-88.2024 latitude:41.5359];
            

            dispatch_async(dispatch_get_main_queue(), ^{
                LoginViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }
    }];
    

}

@end
