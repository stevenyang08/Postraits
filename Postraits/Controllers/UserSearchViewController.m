//
//  UserSearchViewController.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "UserSearchViewController.h"
#import "DataService.h"
#import <Firebase/Firebase.h>

@interface UserSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *allUsers;
@property NSMutableArray *filteredUsers;
@property BOOL isFiltered;

@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allUsers = [NSMutableArray new];
    self.filteredUsers = [NSMutableArray new];
    self.searchBar.delegate = self;
    self.isFiltered = NO;
    
}

-(void)viewWillAppear:(BOOL)animated {
        [self loadUsers];
}

-(void)loadUsers {
    [[[Firebase alloc] initWithUrl:@"https://postrait.firebaseio.com/users"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString *username = [snapshot.value objectForKey:@"username"];
        
        if (username != nil) {
            [self.allUsers insertObject:username atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            NSLog(@"%@", snapshot.value);
        
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.isFiltered == YES) {
        cell.textLabel.text = [self.filteredUsers objectAtIndex:indexPath.row];
    }else {
        cell.textLabel.text = [self.allUsers objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (self.isFiltered == YES) {
            return self.filteredUsers.count;
        }else {
            return self.allUsers.count;
        }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltered = NO;
    } else {
        self.isFiltered = YES;
        self.filteredUsers = [NSMutableArray new];
        for (NSString *friend in self.allUsers) {
            NSRange friendNameRange = [friend rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (friendNameRange.location != NSNotFound) {
                [self.filteredUsers addObject:friend];
            }
        }
    }
    [self.tableView reloadData];
}


@end
