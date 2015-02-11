//
//  BaseRequest.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "LCBaseRequest.h"
#import <UIKit/UIKit.h>

@implementation LCBaseRequest

- (id)initWithUrl:(NSURL*)url param:(NSDictionary*)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString *)method userPostBody:(BOOL)usePostBody
{
    self = [super init];
    if (self)
    {
        self.params = dict;
        self.userPostBody = usePostBody;
        self.timeout = timeout;
        self.method = method;
        if (!usePostBody)
        {
            self.url = [self convertParamWithUrl:url];
        }
        else
        {
            self.url = url;
        }
        [self createRequest];
    }
    return self;
}

- (void)start
{
    //開始執行
    self.conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
    [self.conn start];
}

- (void)createRequest
{
    self.request = [NSMutableURLRequest requestWithURL:_url];
    
    [self.request setTimeoutInterval:_timeout];
    [self.request setHTTPMethod:_method];
    [self generateRequestHeader];
    //使用Post Body
    if (self.userPostBody)
    {
        NSString *param = [self generateParams];
        NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [self.request setHTTPBody:data];
        [self.request setValue:[NSString stringWithFormat:@"%li",[data length]] forHTTPHeaderField:@"Content-Length"];
    }
}

- (void)generateRequestHeader
{
    UIDevice *device = [UIDevice currentDevice];
    [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [self.request addValue:appVersion forHTTPHeaderField:kAppVersion];
    [self.request addValue:device.model forHTTPHeaderField:kAppModel];
    [self.request addValue:device.systemVersion forHTTPHeaderField:kSysVersion];
}

- (NSString*)generateParams
{
    NSArray *allKeys = self.params.allKeys;
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in allKeys)
    {
        [string appendFormat:@"%@=%@", key, self.params[key]];
        if (![key isEqualToString:[allKeys lastObject]])
        {
            [string appendFormat:@"&"];
        }
    }
    return string;
}

- (NSURL*)convertParamWithUrl:(NSURL*)url
{
    NSMutableString *newUrl = [NSMutableString stringWithString:url.absoluteString];
    if (self.params)
    {
        [newUrl appendFormat:@"?"];
        [newUrl appendString:[self generateParams]];
    }
    return [NSURL URLWithString:newUrl];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.falure)
    {
        self.falure(tag, error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completion)
    {
        self.completion(tag, self.responseData);
    }
}



@end
