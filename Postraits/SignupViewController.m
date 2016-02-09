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



@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)createAccountButtonTapped:(UIButton *)sender {
    
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://postrait.firebaseio.com"];
    [ref createUser:self.emailTextField.text password:self.passwordTextField.text
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    if (error) {
        // There was an error creating the account
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error creating the account. Try again!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
      //  NSString *uid = [result objectForKey:@"uid"];
       // NSLog(@"Successfully created user account with uid: %@", uid);
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
