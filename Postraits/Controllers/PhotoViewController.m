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

@interface PhotoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *email;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    [[[[DataService dataService] IMAGE_REF] childByAppendingPath:self.photo.key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *userId = [snapshot.value objectForKey:@"user"];
        [[[[DataService dataService] USER_REF] childByAppendingPath:[NSString stringWithFormat:@"/%@", userId]] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            self.email = [snapshot.value objectForKey:@"email"];
            [self.tableView reloadData];
        }];
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
        cell.textLabel.text = @"hu";
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
