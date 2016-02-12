//
//  ProfileViewController.m
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "ProfileViewController.h"
#import "ImageCollectionViewCell.h"
#import "DataService.h"
#import "PhotoViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserDelegate, PhotoDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *userImages;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    self.userImages = [NSMutableArray new];
    self.followButton.hidden = YES;
    
    [self loadData];
}
- (void)userPropertyDidChange:(User *)user{
    
    self.usernameLabel.text = user.username;
    self.followersCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)user.followers.count];
    if ([user.followers containsObject:[User currentUserId]]) {
        self.followButton.hidden = NO;
        [self.followButton setTitle:@"Followed" forState:UIControlStateDisabled];
        self.followButton.backgroundColor = [UIColor lightGrayColor];
        self.followButton.enabled = NO;
    }else if([self currentUserAtOwnProfile]){
        self.followButton.hidden = YES;
    }else{
        self.followButton.hidden = NO;
    }
    
    self.followersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)user.followings.count];
    
    self.postCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.user.photoIds.count];
}

- (void) loadData {
    

    
    if (self.user == nil) {
        self.user = [[User alloc] initWithKey:[User currentUserId]];
    }else{
        self.user = [[User alloc] initWithKey:self.user.key];
    }
    self.user.delegate = self;
    
    [self userPropertyDidChange:self.user];
    
    [[[[[DataService dataService] USER_REF] childByAppendingPath:self.user.key] childByAppendingPath:@"images"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        Photo *photo = [[Photo alloc] initWithKey:snapshot.key];
        photo.delegate = self;
        [self.userImages addObject:photo];
    }];
}

- (void)photoPropertyDidChange{
    [self.collectionView reloadData];
}

- (IBAction)onButtonTapped:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    
    if (![[self presentingViewController] presentingViewController]) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Photo *photo = [self.userImages objectAtIndex:indexPath.row];
    cell.imageView.image = photo.image;
    cell.photo = photo;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.bounds.size.width / 3) - 3;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(ImageCollectionViewCell *)sender {
    PhotoViewController *destination = segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    Photo *photo = [self.userImages objectAtIndex:indexPath.row];
    
    destination.photo = photo;
    
}

- (IBAction)onFollowButtonTapped:(UIButton *)sender {
    [[[[DataService dataService] CURRENT_USER_REF] childByAppendingPath:@"followings"] updateChildValues:@{self.user.key: [NSNumber numberWithBool:true]}];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    [[[[[DataService dataService] USER_REF] childByAppendingPath:self.user.key] childByAppendingPath:@"followers"] updateChildValues:@{currentUserId: [NSNumber numberWithBool:true]}];
    
    [self.followButton setTitle:@"Followed" forState:UIControlStateDisabled];
    self.followButton.enabled = NO;
    self.followButton.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)currentUserAtOwnProfile{
    return [self.user.key isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
}

@end
