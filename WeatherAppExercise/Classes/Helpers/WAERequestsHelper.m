//
//  WAERequestsHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/17/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAERequestsHelper.h"

#import <RequestUtils/RequestUtils.h>

@implementation WAERequestsHelper

+ (void)request:(NSURL *)URL
     withMethod:(NSString *)method
     parameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    NSURLRequest *req = [NSURLRequest HTTPRequestWithURL:URL
                                                  method:[method uppercaseString]
                                              parameters:params];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        return block(req, (NSHTTPURLResponse *) response, data, connectionError);
    }];
}

@end
