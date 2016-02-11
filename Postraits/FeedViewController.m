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
#import "Photo.h"

@interface FeedViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *pictureArray;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    self.pictureArray = [NSMutableArray new];
    
    self.tableView.rowHeight = 320;
    
    
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
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.photoImage.image = self.photo.image;
    //cell.usernameLabel.text = self.photo.user;
    cell.usernameLabel.text = @"myself123";
    return cell;
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return 2;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.pictureArray.count;
    return self.pictureArray.count;
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
