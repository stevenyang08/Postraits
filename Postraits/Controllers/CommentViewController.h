//
//  CommentViewController.h
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface CommentViewController : UIViewController
@property Photo *photo;
@property (nonatomic) BOOL canGoBack;
@end
