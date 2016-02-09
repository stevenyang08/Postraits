//
//  LoginViewController.m
//  LogIn_SignUp
//
//  Created by Sujin Oh on 2/8/16.
//  Copyright © 2016 Evgeny Shkuratov. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import <Firebase/Firebase.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)loginButtonTapped:(UIButton *)sender {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postrait.firebaseio.com"];
    [ref authUser:self.emailTextField.text password:self.passwordTextField.text
withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error logging the account. Try again!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // We are now logged in
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}];
}

- (IBAction)goBackToLoginVC:(UIStoryboardSegue *)sender{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end