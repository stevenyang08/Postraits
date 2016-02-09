//
//  DataService.m
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "DataService.h"
#import "Constants.h"
#import <Firebase/Firebase.h>
@interface DataService ()

@end


@implementation DataService

@synthesize BASE_REF;

+ (instancetype) dataService {
    return [[DataService alloc] init];
}


- (Firebase *) BASE_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:BASE_URL];
    return ref;
}

- (Firebase *) USER_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, @"/users"]];
    return ref;
}

- (Firebase *) CURRENT_USER_REF {
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    
    Firebase *ref = [[BASE_REF childByAppendingPath:@"users"] childByAppendingPath:userId];
    
    return ref;
}

- (void) createNewAccount:(NSString *)uid user:(NSDictionary *)user{
    [[[self USER_REF] childByAppendingPath:uid] setValue:user];
}



@end
