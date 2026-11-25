#import <React/RCTBridgeModule.h>

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

@end
