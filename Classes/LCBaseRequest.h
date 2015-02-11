//
//  BaseRequest.h
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppVersion @"app-Version"
#define kAppModel @"app-model"
#define kSysVersion @"app-Version"
#define kUserAccount @"app-User"
#define kUserToken @"app-token"

#define kGetMethod @"GET"
#define kPostMethod @"POST"
#define kPutMethod @"PUT"

#define fakeToken @"111111111111"

#define appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

typedef NS_ENUM(NSUInteger, PFRequestTag)
{
    PFRequestTagDefault,
};

typedef void (^completionBlock) (PFRequestTag tag, NSData *responseData);
typedef void (^falureBlock) (PFRequestTag tag, NSError *error);

@interface LCBaseRequest : NSObject <NSURLConnectionDataDelegate>
{
    PFRequestTag tag;
}

@property (nonatomic, assign) BOOL userPostBody;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, strong) NSString *method;

@property (nonatomic, copy) completionBlock completion;
@property (nonatomic, copy) falureBlock falure;

@property (nonatomic, strong) NSMutableData *responseData;

- (id)initWithUrl:(NSURL*)url param:(NSDictionary*)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString*)method userPostBody:(BOOL)usePostBody;

- (void)start;
- (void)createRequest;
- (void)generateRequestHeader;
- (NSString*)generateParams;

@end
