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

@interface PhotoViewController () <UITableViewDataSource, UITableViewDelegate, PhotoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *email;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.photo setDelegate:self];
    [self.tableView reloadData];
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
    if (self.photo.user.username == nil) {
        label.text = @"";
    }else{
        label.text = self.photo.user.username;
    }
    
    [header addSubview:label];
    
    
    return header;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentViewController *destination = [segue destinationViewController];
    destination.photo = self.photo;
}

#pragma mark - Photo Delegate
- (void)photoPropertyDidChange {
    [self.tableView reloadData];
}
@end
