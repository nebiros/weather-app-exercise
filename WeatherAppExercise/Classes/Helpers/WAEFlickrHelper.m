//
//  WAEFlickrHelper.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAEFlickrHelper.h"

#import "JIMEnvironments.h"

#import "WAERequestsHelper.h"

@implementation WAEFlickrHelper

+ (void)requestFlickrApiWithFlickrMethod:(NSString *)flickrMethod
                                     via:(NSString *)via
                          withParameters:(NSDictionary *)params
                                andBlock:(WAERequestCompletionResultBlock)block
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (params) {
        p = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    [p setObject:flickrMethod forKey:kWAEFlickrApiParamMethod];
    [p setObject:[JIMEnvironments sharedInstance].environment[@"FlickrApiKey"] forKey:kWAEFlickrApiParamApiKey];
    [p setObject:@"json" forKey:kWAEFlickrApiParamFormat];
    [p setObject:@1 forKey:kWAEFlickrApiParamNoJSONCallback];
    // see: https://www.flickr.com/services/api/auth.howto.web.html
    // secret + 'api_key' + [api_key] + 'perms' + [perms]
    /*
     NSString *apiSig = [NSString stringWithFormat:@"%@api_key%@permsread",
     [JIMEnvironments sharedInstance].environment[@"FlickrApiSecret"],
     [JIMEnvironments sharedInstance].environment[@"FlickrApiKey"]];
     [p setObject:[apiSig jim_MD5] forKey:kWAEFlickrApiParamApiSig];
     */
    NSURL *URL = [NSURL URLWithString:kWAEFlickrApiRestURL];
    
    [WAERequestsHelper requestAndSerializeResult:URL via:via withParameters:p andBlock:block];
}

+ (void)getRandomPhotoDataFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self requestFlickrApiWithFlickrMethod:kWAEFlickrApiMethodPhotosSearch
                                       via:@"GET"
                            withParameters:params
                                  andBlock:
     ^(BOOL succeeded, NSDictionary *result, NSError *error) {
         if (error) {
             NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
             NSLog(@"[ERROR] - %s: %@",
                   __PRETTY_FUNCTION__,
                   errorMessage);
             
             return block(NO, nil, error);
         }
         
         NSArray *photos = (NSArray *) result[@"photos"][@"photo"];
         
         if (photos.count > 0) {
             NSDictionary *photoData = [NSDictionary dictionaryWithDictionary:photos[arc4random_uniform(photos.count)]];
#ifdef DEBUG
             NSLog(@"photoData, %@", photoData);
#endif
             return block(YES, photoData, nil);
         }
         
         return block(NO, nil, nil);
     }];
}

+ (void)getRandomPhotoURLFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self getRandomPhotoDataFromFlickrWithParameters:params andBlock:^(BOOL succeeded, NSDictionary *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        NSString *photoURL = [NSString stringWithFormat:kWAEFlickrApiPhotoURLFormat,
                              result[@"farm"],
                              result[@"server"],
                              result[@"id"],
                              result[@"secret"]];
        NSURL *URL = [NSURL URLWithString:photoURL];
#ifdef DEBUG
        NSLog(@"URL.absoluteString, %@", URL.absoluteString);
#endif
        return block(YES, URL, nil);
    }];
}

+ (void)getRandomPhotoFromFlickrWithParameters:(NSDictionary *)params andBlock:(WAERequestCompletionResultBlock)block
{
    [self getRandomPhotoURLFromFlickrWithParameters:params andBlock:^(BOOL succeeded, NSURL *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return block(NO, nil, error);
        }
        
        if (result) {
            NSData *data = [NSData dataWithContentsOfURL:result];
            UIImage *randomPhoto = [UIImage imageWithData:data];
            
            return block(YES, randomPhoto, nil);
        }
        
        return block(NO, nil, nil);
    }];
}

@end
