//
//  NetWorking.m
//  WhatsTheWeather
//
//  Created by StreamWu on 2/28/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking

// -----------------------------------------------------------------------------
#pragma mark - Initialization
// -----------------------------------------------------------------------------
+ (id)sharedNetworking
{
    static dispatch_once_t pred;
    static NetWorking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if ( self = [super init] ) {
        
    }
    return self;
}

#pragma - Requests

- (void)getWeatherForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dic, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     
                                     // handle response
                                     NSLog(@"Data:%@",data);
                                     NSLog(@"Response:%@",response);
                                     NSLog(@"Error:%@",[error localizedDescription]);                                     
                                     
                                     NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                     if (httpResp.statusCode == 200) {
                                         NSError *jsonError;
                                         
                                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                         //NSLog(@"DownloadeData:%@ \n--- ",dic);
                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                         successCompletion(dic,nil);
                                     } else {
                                         NSLog(@"Fail Not 200:");
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (failureCompletion) failureCompletion();
                                         });
                                     }
                                 }] resume];
}


@end