//
//  ImageCollectionViewCell.h
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property Photo *photo;

@end
