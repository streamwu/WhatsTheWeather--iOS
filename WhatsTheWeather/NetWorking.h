//
//  NetWorking.h
//  WhatsTheWeather
//
//  Created by StreamWu on 2/28/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject

//@property (strong, nonatomic) NSArray* result;
+(id)sharedNetworking;
- (void)getWeatherForURL:(NSString*)url
                 success:(void (^)(NSDictionary *dic, NSError *error))successCompletion
                 failure:(void (^)(void))failureCompletion;

@end
