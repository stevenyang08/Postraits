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

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *userImages;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImages = [NSMutableArray new];
    
    [[[[DataService dataService] CURRENT_USER_REF] childByAppendingPath:@"images"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSString *imageKey = snapshot.key;
        NSString *imagePath = [NSString stringWithFormat:@"%@/string", imageKey];
        
        [[[[DataService dataService] IMAGE_REF] childByAppendingPath:imagePath] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            if(snapshot.value != nil){
                NSData *decodedString = [[NSData alloc] initWithBase64EncodedString:snapshot.value options:0];
                UIImage *decodedImage = [[UIImage alloc] initWithData:decodedString];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.userImages insertObject:decodedImage atIndex:0];
                    [self.collectionView reloadData];
                });
            }
        }];
        
    }];
    
}
- (IBAction)onButtonTapped:(UIButton *)sender {
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image = [self.userImages objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor blackColor];
    
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

@end
