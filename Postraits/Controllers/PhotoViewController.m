//
//  PhotoViewController.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoShowTableViewCell.h"
#import "DataService.h"
#import "CommentViewController.h"
#import "Comment.h"

@interface PhotoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *email;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    
    [self loadUserAndComments];
    
}

- (void)loadUserAndComments{
    self.photo.comments = [NSMutableArray new];
    [[[[DataService dataService] IMAGE_REF] childByAppendingPath:self.photo.key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *userId = [snapshot.value objectForKey:@"user"];
        [[[[DataService dataService] USER_REF] childByAppendingPath:[NSString stringWithFormat:@"/%@", userId]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            self.email = [snapshot.value objectForKey:@"email"];
            [self.tableView reloadData];
        }];
        
        NSDictionary *comments = [snapshot.value objectForKey:@"comments"];
        if (comments != nil) {
            for (NSString *comment in comments) {
                [[[[DataService dataService] COMMENT_REF] childByAppendingPath:comment] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    if(snapshot.value != [NSNull new]){
                        Comment *comment = [Comment new];
                        
                        NSString *username = [snapshot.value objectForKey:@"body"];
                        comment.body = username;
                        [self.photo.comments addObject:comment];
                        
                        [self.tableView reloadData];
                    }
                }];
            }
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PhotoShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetWidth(tableView.bounds));
        cell.photoView.image = self.photo.image;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        Comment *comment = [self.photo.comments objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.text = comment.body;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = self.photo.comments.count > 4 ? 4 : self.photo.comments.count;
    return 1 + count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    header.contentView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, self.view.bounds.size.width -30, 30)];
    [label.font fontWithSize:10];
    if (self.email == nil) {
        label.text = @"";
    }else{
        label.text = self.email;
    }
    
    [header addSubview:label];
    
    
    return header;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentViewController *destination = [segue destinationViewController];
    destination.photo = self.photo;
}
@end
