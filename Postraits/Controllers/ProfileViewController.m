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

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
    self.userImages = [NSMutableArray new];
    self.followButton.hidden = YES;
    [self.activityIndicator startAnimating];
    
    [self loadData];
}

- (void) loadData {
    

    
    if (self.user == nil) {
        self.user = [User new];
        self.user.key = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    }
    
    [[[[DataService dataService] USER_REF] childByAppendingPath:self.user.key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.usernameLabel.text = [snapshot.value objectForKey:@"username"];
        NSDictionary *followers = [snapshot.value objectForKey:@"followers"];
        
        if (followers) {
            self.followersCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[followers allKeys] count]];
        }else{
            self.followersCountLabel.text = [NSString stringWithFormat:@"%d", 0];
        }
        
        // hide follow button if u followed
        if ([[followers allKeys] containsObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]]) {
            self.followButton.hidden = NO;
            [self.followButton setTitle:@"Followed" forState:UIControlStateDisabled];
            self.followButton.backgroundColor = [UIColor lightGrayColor];
            self.followButton.enabled = NO;
        }else if ([self currentUserAtOwnProfile]){
            self.followButton.hidden = YES;
        }else{
            self.followButton.hidden = NO;
        }
        
        NSDictionary *followings = [snapshot.value objectForKey:@"followings"];
        
        if (followings) {
            self.followingCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[followings allKeys] count]];
        }else{
            self.followingCountLabel.text = [NSString stringWithFormat:@"%d", 0];
        }
        
        
        
        NSDictionary *images = [snapshot.value objectForKey:@"images"];
        
        if (images) {
            self.postCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[images allKeys] count]];
        }else{
            self.postCountLabel.text = [NSString stringWithFormat:@"%d", 0];
        }
    }];
    
    
    [[[[[DataService dataService] USER_REF] childByAppendingPath:self.user.key] childByAppendingPath:@"images"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSString *imageKey = snapshot.key;
        NSString *imagePath = [NSString stringWithFormat:@"%@", imageKey];
        
        [[[[DataService dataService] IMAGE_REF] childByAppendingPath:imagePath] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            if(snapshot.value != nil){
                if ([snapshot.value objectForKey:@"string"] != nil) {
                    Photo *photo = [[Photo alloc] init];
                    
                    NSData *decodedString = [[NSData alloc] initWithBase64EncodedString:[snapshot.value objectForKey:@"string"] options:0];
                    UIImage *decodedImage = [[UIImage alloc] initWithData:decodedString];
                    
                    photo.image = decodedImage;
                    photo.key   = snapshot.ref.key;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.userImages insertObject:photo atIndex:0];
                        [self.collectionView reloadData];
                        [self.activityIndicator stopAnimating];
                    });
                }
            }
        }];
        
    }];
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
