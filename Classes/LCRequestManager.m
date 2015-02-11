//
//  RequestManager.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "LCRequestManager.h"

@implementation LCRequestManager

+ (LCRequestManager*)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[LCRequestManager alloc] init];
    });
    
    return instance;
}

#pragma mark Shared method
- (void)startRequestWithUrl:(NSURL*)url params:(NSDictionary *)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    LCBaseRequest *request = [[LCBaseRequest alloc] initWithUrl:url param:param timeout:baseTimeout httpMethod:method userPostBody:userPostBody];
    [request setCompletion:completion];
    [request setFalure:falure];
    
    [request start];
}

- (void)requestWith:(NSURL*)url param:(NSDictionary*)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    [self startRequestWithUrl:url params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

@end
