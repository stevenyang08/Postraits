//
//  Comment.h
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataService.h"

@protocol CommentDelegate <NSObject>

- (void) commentPropertyDidChange;

@end

@interface Comment : NSObject

@property id <CommentDelegate> delegate;
@property NSString *body;

- (instancetype)initWithKey:(NSString *)key;

@end
