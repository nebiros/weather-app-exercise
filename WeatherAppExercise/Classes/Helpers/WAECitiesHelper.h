//
//  WAECitiesHelper.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "WAEConstants.h"

@interface WAECitiesHelper : NSObject

+ (void)getExerciseCitiesWithBlock:(WAERequestCompletionResultBlock)block;
+ (void)getExerciseCityPhotoWithImageURL:(NSString *)imageURL andBlock:(WAERequestCompletionResultBlock)block;

@end
