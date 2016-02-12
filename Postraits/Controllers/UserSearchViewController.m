//
//  UserSearchViewController.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "UserSearchViewController.h"
#import "ProfileViewController.h"
#import "DataService.h"
#import <Firebase/Firebase.h>
#import "User.h"

@interface UserSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *allUsers;
@property NSMutableArray *filteredUsers;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allUsers = [NSMutableArray new];
    self.filteredUsers = [NSMutableArray new];
    self.searchBar.delegate = self;
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self loadUsers];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

//- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
//{
//    [self.searchBar resignFirstResponder];
//}

-(void)loadUsers {
    [[[Firebase alloc] initWithUrl:@"https://postrait.firebaseio.com/users"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        User *user = [User new];
        
        user.username = [snapshot.value objectForKey:@"username"];
        user.key = snapshot.key;
        
        if (user.username != nil) {
            [self.allUsers insertObject:user atIndex:0];
            [self.filteredUsers insertObject:user atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [[self.filteredUsers objectAtIndex:indexPath.row] username];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredUsers.count;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.filteredUsers = self.allUsers;
    } else {
        self.filteredUsers = [NSMutableArray new];
        for (User *user in self.allUsers) {
            NSRange friendNameRange = [user.username rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (friendNameRange.location != NSNotFound) {
                [self.filteredUsers addObject:user];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *destination = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    User *user = [self.filteredUsers objectAtIndex:indexPath.row];
    destination.user = user;
    
}
@end
