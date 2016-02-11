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
#import "Constants.h"
#import "DataService.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated{

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"uid"] && [[[DataService dataService] CURRENT_USER_REF] authData]) {
        
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}



- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
    Firebase *ref = [[Firebase alloc] initWithUrl:BASE_URL];
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
        [[NSUserDefaults standardUserDefaults] setValue:authData.uid forKey:@"uid"];
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