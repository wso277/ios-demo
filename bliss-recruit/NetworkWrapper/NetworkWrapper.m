//
//  NetworkWrapper.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "NetworkWrapper.h"

@implementation NetworkWrapper

static NetworkWrapper *sharedInstance;
static dispatch_once_t sharedInstanceToken;

+(instancetype)sharedInstance
{
    dispatch_once(&sharedInstanceToken, ^{
        sharedInstance = [[NetworkWrapper alloc] init];
        sharedInstance.baseUrl = @"https://private-bbbe9-blissrecruitmentapi.apiary-mock.com/";
    });
    
    return sharedInstance;
}

-(void)checkHealthStatusWithCompletionHandler:(_Nonnull NetworkRequestCompletionHandler) completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseUrl, @"health"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            completionHandler(data, NO, error);
        } else {
            switch ([(NSHTTPURLResponse*)response statusCode]) {
                case 200:
                    
                    completionHandler(data, YES, nil);
                    break;
                    
                case 503:
                    
                    completionHandler(data, NO, error);
                default:
                    completionHandler(data, NO, error);
                    break;
            }
        }
    }] resume];
}

@end
