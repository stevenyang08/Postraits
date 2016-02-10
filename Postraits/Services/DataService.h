//
//  DataService.h
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface DataService : NSObject

+ (instancetype) dataService;

@property (nonatomic, assign) Firebase* BASE_REF;
@property (nonatomic, assign) Firebase* USER_REF;
@property (nonatomic, assign) Firebase* IMAGE_REF;
@property (nonatomic, assign) Firebase* CURRENT_USER_REF;

- (void) createNewAccount:(NSString *)uid user:(NSDictionary *)user;

@end
