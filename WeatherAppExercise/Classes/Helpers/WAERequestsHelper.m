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
    NSURLRequest *req = [NSURLRequest HTTPRequestWithURL:URL
                                                  method:[via uppercaseString]
                                              parameters:params];
#ifdef DEBUG
    NSLog(@"req, %@", req);
#endif
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        return block(req, (NSHTTPURLResponse *) response, data, connectionError);
    }];
}

+ (void)requestAndSerializeResult:(NSURL *)URL
                              via:(NSString *)via
                   withParameters:(NSDictionary *)params
                         andBlock:(WAERequestCompletionResultBlock)block
{
    [self request:URL via:via withParameters:params andBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError && !data) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [connectionError localizedDescription], connectionError.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, connectionError);
        }
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
#ifdef DEBUG
        NSLog(@"json, %@", json);
#endif
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        if (response.statusCode != 200) {
            NSError *e = [NSError
                          errorWithDomain:@"im.juan.WeatherAppExercise"
                          code:response.statusCode
                          userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(json[@"message"], nil),
                                     @"responseStatusCode": @(response.statusCode),
                                     @"responseCode": json[@"code"],
                                     @"responseMessage": json[@"message"]}];
            return block(NO, nil, e);
        }
        
        return block(YES, json, nil);
    }];
}

@end
