//
//  FeedViewController.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "FeedViewController.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"
#import "FeedTableViewCell.h"
#import "CommentTableViewCell.h"
#import "Photo.h"
#import "CommentViewController.h"

@interface FeedViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *pictureArray;
@property NSString *userTest;
@property NSString *comment1;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureArray = [NSMutableArray new];
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 40.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.userTest = @"myself123";
    self.comment1 = @"I had the best time ever!!!";

    //self.tableView.rowHeight = 320;
    
    
    // hidden toggle button
    //[TGCamera setOption:kTGCameraOptionHiddenToggleButton value:[NSNumber numberWithBool:YES]];
    //[TGCameraColor setTintColor: [UIColor greenColor]];
    
    // hidden album button
    //[TGCamera setOption:kTGCameraOptionHiddenAlbumButton value:[NSNumber numberWithBool:YES]];
    
    // hide filter button
    //[TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];
    
    
    self.photoView.clipsToBounds = YES;
    
//    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                 target:self
//                                                                                 action:@selector(clearTapped)];
//    
//    self.navigationItem.rightBarButtonItem = clearButton;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userTest2 = @"deZMan45";
    NSString *comment2 = @"Dayme son, dat shit dhere is allz chu needz cuz chu know what i'm saying, homie?";
    if (indexPath.row == 0) {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.photoImage.image = self.photo.image;
    //cell.usernameLabel.text = self.photo.user;
        cell.photoImage.image = [UIImage imageNamed:@"empty"];
        cell.userCommentText.text = [NSString stringWithFormat:@"%@ %@", self.userTest, self.comment1];
        return cell;
    }
    else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.commentTextView.text = [NSString stringWithFormat:@"%@ %@", userTest2, comment2];
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string = self.userTest;
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    CGFloat height = 30.0;
//    return height;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    CGFloat height = 30.0;
//    return height;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}



 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 }
 

@end
