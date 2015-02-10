//
//  RequestManager.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (RequestManager*)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] init];
    });
    
    return instance;
}

#pragma mark Shared method
- (void)startRequestWithUrl:(NSURL*)url params:(NSDictionary *)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    BaseRequest *request = [[BaseRequest alloc] initWithUrl:url param:param timeout:baseTimeout httpMethod:method userPostBody:userPostBody];
    [request setCompletion:completion];
    [request setFalure:falure];
    
    [request start];
}

- (void)requestWith:(NSURL*)url param:(NSDictionary*)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    [self startRequestWithUrl:url params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

- (void)requestSearchPinsWithParam:(NSDictionary *)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    [self startRequestWithUrl:[NSURL URLWithString:kSearchUrl] params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

- (void)requestLoginWithParam:(NSDictionary*)param httpMethod:(NSString*)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    [self startRequestWithUrl:[NSURL URLWithString:kLoginUrl] params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

- (void)requestUserPinsWithParam:(NSDictionary*)param httpMethod:(NSString*)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    [self startRequestWithUrl:[NSURL URLWithString:kUserPinsUrl] params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

@end
