//
//  RAFieldValidator.h
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAFieldValidator : NSObject

@property(nonatomic,strong) NSMutableArray *requiredFields;
+(RAFieldValidator *)sharedInsatnce;

- (NSDictionary*)validateReuiredFields;
@end
