#import <React/RCTBridgeModule.h>
#import "App-Swift.h"

@interface SimilarMoviesNavigation : NSObject <RCTBridgeModule>
@end

@implementation SimilarMoviesNavigation

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_METHOD(selectMovie:(NSString *)movieID requestID:(NSString *)requestID)
{
    if (movieID == nil || requestID == nil) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowcaseSimilarMovieSelected"
                                                            object:requestID
                                                          userInfo:@{@"movieID": movieID}];
    });
}

RCT_EXPORT_METHOD(reportFirstRowLayout:(NSString *)requestID)
{
    if (![requestID isKindOfClass:[NSString class]]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowcaseSimilarMoviesFirstRowLaidOut"
                                                            object:requestID];
    });
}

RCT_EXPORT_METHOD(loadNextPage:(NSString *)requestID
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (![requestID isKindOfClass:[NSString class]]) {
        reject(@"invalid_request", @"A valid sheet request ID is required.", nil);
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowcaseSimilarMoviesPagination requestNextPage:requestID completion:^(NSDictionary *result) {
            resolve(result);
        }];
    });
}

@end
