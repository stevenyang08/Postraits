//
//  CustomClass.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.comments = [NSMutableArray new];
    }
    
    return self;
}

@end
