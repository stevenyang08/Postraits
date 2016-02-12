//
//  CommentViewController.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "FeedViewController.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PhotoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.photo.delegate = self;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Comment *comment = self.photo.comments[indexPath.row];
    
    cell.textLabel.text = comment.bodyWithAuthor;
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photo.comments.count;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    [self.view layoutIfNeeded];
    self.bottomConstraint.constant = keyboardFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    self.bottomConstraint.constant = 0.0;
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)sendComment:(UIButton *)sender {
    NSString *comment = self.commentTextField.text;
    
    [self.commentTextField resignFirstResponder];
    self.commentTextField.text = @"";
    
    [[DataService dataService] createNewComment:comment photoKey:self.photo.key];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *comment = self.commentTextField.text;
    
    [self.commentTextField resignFirstResponder];
    self.commentTextField.text = @"";
    
    [[DataService dataService] createNewComment:comment photoKey:self.photo.key];
    
    return YES;
}

- (void)photoPropertyDidChange{
    [self.tableView reloadData];
}

@end
