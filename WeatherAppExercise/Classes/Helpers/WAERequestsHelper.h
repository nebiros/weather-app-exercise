//
//  WAERequestsHelper.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/17/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "WAEConstants.h"

@interface WAERequestsHelper : NSObject

+ (void)request:(NSURL *)URL
            via:(NSString *)via
 withParameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block;
+ (void)requestAndSerializeResult:(NSURL *)URL
                              via:(NSString *)via
                   withParameters:(NSDictionary *)params
                         andBlock:(WAERequestCompletionResultBlock)block;

@end
