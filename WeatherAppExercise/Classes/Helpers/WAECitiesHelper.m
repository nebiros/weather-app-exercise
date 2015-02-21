//
//  WAECitiesHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAECitiesHelper.h"

#import "WAERequestsHelper.h"

@implementation WAECitiesHelper

+ (void)getExerciseCitiesWithBlock:(WAERequestCompletionResultBlock)block
{
    NSURL *URL = [NSURL URLWithString:kWAEExerciseCitiesURL];
    [WAERequestsHelper requestAndSerializeResult:URL via:@"GET" withParameters:nil andBlock:block];
}

+ (void)getExerciseCityPhotoWithImageURL:(NSString *)imageURL andBlock:(WAERequestCompletionResultBlock)block
{
    NSURL *URL = [NSURL URLWithString:imageURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        
        if (!data) {
            return block(NO, nil, nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];
            return block(YES, image, nil);
        });
    });
}

@end
