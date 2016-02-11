//
//  SignupViewController.m
//  LogIn_SignUp
//
//  Created by Sujin Oh on 2/8/16.
//  Copyright © 2016 Evgeny Shkuratov. All rights reserved.
//

#import "SignupViewController.h"
#import "Firebase/Firebase.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "DataService.h"



@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)createAccountButtonTapped:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *username = self.usernameTextField.text;
    
    Firebase *ref = [[Firebase alloc] initWithUrl:BASE_URL];
    [ref createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        
        if (error) {
            // There was an error creating the account
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error creating the account. Try again!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [[[DataService dataService] BASE_REF] authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
                NSDictionary *user = [[NSDictionary alloc] initWithObjects:@[authData.provider, email, username] forKeys:@[@"provider", @"email", @"username"]];
                
                [[DataService dataService] createNewAccount:authData.uid user:user];
            }];
            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"uid"] forKey:@"uid"];
            [self performSegueWithIdentifier:@"createAccount" sender:self];
        }
    }];
    
}
- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.origin.x, 480.0f + (self.view.frame.size.height/2));
    [UIView commitAnimations];
}

@end
