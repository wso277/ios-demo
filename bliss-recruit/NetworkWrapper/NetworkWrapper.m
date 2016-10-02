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

-(void)fetchQuestionWithID:(NSString*)questionID andCompletionHandler:(_Nonnull NetworkRequestCompletionHandler) completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@questions/%@", self.baseUrl, questionID]];
    
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

-(void)listQuestionsWithLimit:(int)limit withOffset:(int)offset andFilter:( NSString* _Nullable )filter withCompletionHandler:(_Nonnull NetworkRequestCompletionHandler)completionHandler
{
    NSURL *url;
    if (filter && ![filter isEqualToString:@""]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@questions?limit=%d&offset=%d&filter=%@", self.baseUrl, limit, offset, filter]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@questions?limit=%d&offset=%d", self.baseUrl, limit, offset]];
    }
    
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
                    
                default:
                    completionHandler(data, NO, error);
                    break;
            }
        }
    }] resume];
}

-(void)updateQuestion:(NSMutableDictionary*)question withCompletionHandler:(_Nonnull NetworkRequestCompletionHandler)completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@questions/%@", self.baseUrl, [question objectForKey:@"id"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody:[NSKeyedArchiver archivedDataWithRootObject:question]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionHandler(data, NO, error);
        } else {
            switch ([(NSHTTPURLResponse*)response statusCode]) {
                case 201:
                    
                    completionHandler(data, YES, nil);
                    break;
                    
                case 400:
                    
                    completionHandler(data, NO, error);
                default:
                    completionHandler(data, NO, error);
                    break;
            }
        }
    }] resume];
}

@end
