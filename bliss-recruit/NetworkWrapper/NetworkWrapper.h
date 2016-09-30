//
//  NetworkWrapper.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkRequestCompletionHandler) (NSData * _Nullable result, BOOL success, NSError * _Nullable error);

@interface NetworkWrapper : NSObject

+(instancetype _Nullable)sharedInstance;

@property(nonatomic, nonnull)   NSString *baseUrl;

-(void)checkHealthStatusWithCompletionHandler:(_Nonnull NetworkRequestCompletionHandler) completionHandler;

-(void)listQuestionsWithLimit:(int)limit withOffset:(int)offset andFilter:( NSString* _Nullable )filter withCompletionHandler:(_Nonnull NetworkRequestCompletionHandler)completionHandler;

@end
