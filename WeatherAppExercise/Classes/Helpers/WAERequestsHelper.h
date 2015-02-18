//
//  WAERequestsHelper.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/17/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;

#import "WAEConstants.h"

@interface WAERequestsHelper : NSObject

+ (void)request:(NSURL *)URL
     withMethod:(NSString *)method
     parameters:(NSDictionary *)params
       andBlock:(WAENSURLConnectionAsynchronousRequestCompletionHandlerBlock)block;

@end
