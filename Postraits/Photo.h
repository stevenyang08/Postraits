//
//  CustomClass.h
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataService.h"
#import "User.h"

@interface Photo : NSObject

@property NSString *key;
@property UIImage *image;
@property User *user;
@property NSMutableArray *comments;

@end
