//
//  FriendsFeedViewController.m
//  Postraits
//
//  Created by Wong You Jing on 12/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "FriendsFeedViewController.h"
#import "FeedTableViewCell.h"
#import "CommentTableViewCell.h"
#import "Photo.h"
#import "Comment.h"
#import "CommentViewController.h"
#import "PhotoViewController.h"

@interface FriendsFeedViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, PhotoDelegate, UserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *pictureArray;
@property User *user;
@property NSMutableSet *followingsImagesId;
@end

@implementation FriendsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureArray = [NSMutableArray new];
    self.tableView.estimatedRowHeight = 400.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.followingsImagesId = [NSMutableSet new];
    [self loadPhotos];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
}

#pragma mark - Helper Methods

- (void) loadPhotos {
    self.pictureArray = [NSMutableArray new];
    NSLog(@"happening test");
    self.user = [[User alloc]initWithKey:[User currentUserId]];
    self.user.delegate = self;
}

- (void)userPropertyDidChange:(User *)user{
    NSLog(@"happening");
    NSLog(@"%@", user.followings);
    if([user.key isEqualToString:[User currentUserId]]){
        for (NSString *followingId in user.followings) {
            NSLog(@"creating user");
            User *user = [[User alloc] initWithKey:followingId];
            user.delegate = self;
        }
    }else{
        NSLog(@"key: %@, photoID %@", user.key, user.photoIds);
        [self.followingsImagesId addObjectsFromArray:user.photoIds];
        NSLog(@"followingsImagesId %@", self.followingsImagesId);
        self.pictureArray = [NSMutableArray new];
        for (NSString *photoId in self.followingsImagesId) {
            Photo *photo = [[Photo alloc] initWithKey:photoId];
            photo.delegate = self;
            [self.pictureArray addObject:photo];
        }
        NSLog(@"pictureArray: %@", self.pictureArray);
        [self.tableView reloadData];
    }
    
}

#pragma mark - TableView


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.pictureArray objectAtIndex:indexPath.section];
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.photoImage.image = photo.image;
        cell.photo = photo;
        cell.commentButton.tag = indexPath.section;
        cell.likesLabel.text = [NSString stringWithFormat:@"%ld likes", photo.likesCount];
        
        if ([photo userLiked:[User currentUserId]]) {
            [cell.likeButton setImage:[UIImage imageNamed:@"red_like"] forState:UIControlStateNormal];
        }else{
            [cell.likeButton setImage:[UIImage imageNamed:@"white_like"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        Comment *comment = [photo.comments objectAtIndex:(row - 1)];
        cell.textLabel.text = comment.bodyWithAuthor;
        cell.textLabel.numberOfLines = 0;
        
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    Photo *photo = [self.pictureArray objectAtIndex:section];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string = photo.user.username;
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.8]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Photo *photo = [self.pictureArray objectAtIndex:section];
    NSUInteger count = photo.comments.count > 2 ? 2 : photo.comments.count;
    return 1 + count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pictureArray.count;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"FriendPhotoShowSegue"]) {
        PhotoViewController *destination = segue.destinationViewController;
        FeedTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Photo *photo = self.pictureArray[indexPath.section];
        destination.photo = photo;
    }else if ([segue.identifier isEqualToString:@"FriendCommentIndexSegue"]){
        CommentViewController *destination = segue.destinationViewController;
        UIButton *commentButton = sender;
        Photo *photo = self.pictureArray[commentButton.tag];
        destination.photo = photo;
    }
}

#pragma mark - Photo Delegate

- (void)photoPropertyDidChange {
    [self.tableView reloadData];
}


@end
