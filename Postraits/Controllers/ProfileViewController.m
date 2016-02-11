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


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImages = [NSMutableArray new];
    
    [self.activityIndicator startAnimating];
    
    [[[[DataService dataService] CURRENT_USER_REF] childByAppendingPath:@"images"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
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

@end
