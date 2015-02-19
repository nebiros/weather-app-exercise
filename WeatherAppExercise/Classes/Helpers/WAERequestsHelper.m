//
//  WAERequestsHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/17/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAERequestsHelper.h"

#import <RequestUtils/RequestUtils.h>
#import "JIMEnvironments.h"

@implementation WAERequestsHelper

+ (void)request:(NSURL *)URL
            via:(NSString *)via
 withParameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    NSURLRequest *req = [NSURLRequest HTTPRequestWithURL:URL
                                                  method:[via uppercaseString]
                                              parameters:params];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        return block(req, (NSHTTPURLResponse *) response, data, connectionError);
    }];
}

+ (void)requestFlickrApiWithFlickrMethod:(NSString *)flickrMethod
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    [p setObject:flickrMethod forKey:kWAEFlickrApiParamMethod];
    [p setObject:[JIMEnvironments sharedInstance].environment[@"FlickrApiKey"] forKey:kWAEFlickrApiParamApiKey];
    [p setObject:@"json" forKey:kWAEFlickrApiParamFormat];
    [p setObject:@1 forKey:kWAEFlickrApiParamNoJSONCallback];
    
    NSURL *URL = [NSURL URLWithString:kWAEFlickrApiRestURL];
    
    [self request:URL via:via withParameters:p andBlock:block];
}

+ (void)requestOpenWeatherMapApiWithPath:(NSString *)path
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    [p setObject:[JIMEnvironments sharedInstance].environment[@"OpenWeatherMapApiKey"] forKey:kWAEOpenWeatherMapApiParamApiKey];
    
    NSString *URLAsString = [NSString stringWithFormat:@"%@%@", kWAEOpenWeatherMapApiRestURL, path];
    NSURL *URL = [NSURL URLWithString:URLAsString];
    
    [self request:URL via:via withParameters:p andBlock:block];
}

@end
