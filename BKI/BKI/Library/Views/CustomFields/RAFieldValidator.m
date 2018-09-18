//
//  RAFieldValidator.m
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "RAFieldValidator.h"
#import <UIKit/UIKit.h>

@implementation RAFieldValidator

@synthesize requiredFields;

static RAFieldValidator *instance = nil;

+ (RAFieldValidator *)sharedInsatnce
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[RAFieldValidator alloc] init];
    });
    return instance;
}


- (id)init
{
    self = [super init];
    if (self) {
        //Setup proprties here
        requiredFields = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (NSDictionary*)validateReuiredFields
{
    for (NSDictionary *field in self.requiredFields) {
        
        UITextField *tf = (UITextField *) field[@"Field"];
        if (tf.text.length == 0) {
            return field;
        }
    }
    
    return nil;
}

@end
