//
//  RootViewController.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/16/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAERootViewController.h"

#import "JIMEnvironments.h"

#import "WAEConstants.h"
#import "WAERequestsHelper.h"

@interface WAERootViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation WAERootViewController

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(currentLocation)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self setupNavigation];
    [self setCurrentLocationFromLocationManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(currentLocation))]) {
        
    }
}

#pragma mark - UI

- (void)setupNavigation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Setttings", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(settingsButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cities", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(citiesButtonTapped:)];
}

#pragma mark - Callbacks

- (void)settingsButtonTapped:(id)sender
{
}

- (void)citiesButtonTapped:(id)sender
{
}

#pragma mark - Location

- (void)setCurrentLocationFromLocationManager
{
#ifdef TARGET_IPHONE_SIMULATOR
    [self findWeatherByCityName:[JIMEnvironments sharedInstance].environment[@"OpenWeatherMapDefaultQueryCity"]];
#else
    // when iOS7…
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
#endif
}

- (void)findWeatherByCityName:(NSString *)city
{
    [WAERequestsHelper requestOpenWeatherMapApiWithPath:kWAEOpenWeatherMapApiRestWeatherPath
                                                    via:@"GET"
                                         withParameters:@{kWAEOpenWeatherMapApiParamQuery: city}
                                               andBlock:
     ^(BOOL succeeded, NSDictionary *result, NSError *error) {
         if (error) {
             NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
             NSLog(@"[ERROR] - %s: %@",
                   __PRETTY_FUNCTION__,
                   errorMessage);
             
             return;
         }
         
         self.currentLocation = [[CLLocation alloc] initWithLatitude:[result[@"coord"][@"lat"] doubleValue] longitude:[result[@"coord"][@"lon"] doubleValue]];
     }];
}

#pragma mark - CLLocationManagerDelegate

NSInteger startUpdatingLocationTimes = 0;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (kWAEConfigTimesToRetry < startUpdatingLocationTimes) {
        [self.locationManager stopUpdatingLocation]; return;
    }
    
    NSLog(@"[ERROR] - %s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo]);
    
    [self.locationManager stopUpdatingLocation];
    
    if (![CLLocationManager locationServicesEnabled] ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *title = [NSString stringWithFormat:@"Turn On Location Services To Allow \"%@\" to Determine Your Location", kWAEConfigApplicationDisplayName];
        NSString *message = @"This will make it much easier for you to find and record stuff nearby";
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(title, nil)
                              message:NSLocalizedString(message, nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self.locationManager startUpdatingLocation];
    
    startUpdatingLocationTimes++;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    // see: http://stackoverflow.com/a/12848776/255463
    //
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.currentLocation = newLocation;
        
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self.locationManager stopUpdatingLocation];
        }
    }
}

@end
