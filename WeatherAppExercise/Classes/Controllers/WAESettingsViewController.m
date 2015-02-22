//
//  WAESettingsViewController.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAESettingsViewController.h"

#import <FXKeychain/FXKeychain.h>

#import "WAEConstants.h"
#import "WAECitiesHelper.h"

@interface WAESettingsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *celsiusDegreesImageView;
@property (weak, nonatomic) IBOutlet UILabel *celsiusDegreesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fahrenheitDegreesImageView;
@property (weak, nonatomic) IBOutlet UILabel *fahrenheitDegreesLabel;

@end

@implementation WAESettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat height = CGRectGetHeight(screen) / 2;
    self.celsiusDegreesImageView.frame = CGRectMake(self.celsiusDegreesImageView.frame.origin.x,
                                                    self.topLayoutGuide.length,
                                                    CGRectGetWidth(screen),
                                                    height);
    self.fahrenheitDegreesImageView.frame = CGRectMake(CGRectGetMinX(self.celsiusDegreesImageView.frame),
                                                       CGRectGetMaxY(self.celsiusDegreesImageView.frame),
                                                       CGRectGetWidth(screen),
                                                       height);
#ifdef DEBUG
    NSLog(@"%s, NSStringFromCGRect(screen), %@", __PRETTY_FUNCTION__, NSStringFromCGRect(screen));
    NSLog(@"%s, NSStringFromCGRect(self.celsiusDegreesImageView.frame), %@", __PRETTY_FUNCTION__, NSStringFromCGRect(self.celsiusDegreesImageView.frame));
    NSLog(@"%s, NSStringFromCGRect(self.fahrenheitDegreesImageView.frame), %@", __PRETTY_FUNCTION__, NSStringFromCGRect(self.fahrenheitDegreesImageView.frame));
#endif
}
*/
#pragma mark - UI

- (void)setupControls
{
    self.celsiusDegreesLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapCelsius = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(celsiusDegreesLabelTapped:)];
    tapCelsius.delegate = self;
    [self.celsiusDegreesLabel addGestureRecognizer:tapCelsius];
    
    self.fahrenheitDegreesLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFahrenheit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fahrenheitDegreesLabelTapped:)];
    tapFahrenheit.delegate = self;
    [self.fahrenheitDegreesLabel addGestureRecognizer:tapFahrenheit];
    
    self.celsiusDegreesImageView.image = nil;
    self.fahrenheitDegreesImageView.image = nil;
    
    [WAECitiesHelper getExerciseCitiesWithBlock:^(BOOL succeeded, NSDictionary *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return;
        }
        
        if (result) {
            NSArray *cities = (NSArray *) result[@"cities"];
            
            NSDictionary *randomCityC = cities[arc4random_uniform(cities.count)];
            [self setExerciseCityPhotoWithImageURL:randomCityC[@"imageURL"] andImageView:self.celsiusDegreesImageView];
            
            NSDictionary *randomCityF = cities[arc4random_uniform(cities.count)];
            [self setExerciseCityPhotoWithImageURL:randomCityF[@"imageURL"] andImageView:self.fahrenheitDegreesImageView];
        }
    }];
}

#pragma mark - Callbacks

- (void)celsiusDegreesLabelTapped:(id)sender
{
    [FXKeychain defaultKeychain][kWAEConfigTemperature] = @(WAETemperatureUnitCelsius);
    if ([self.delegate respondsToSelector:@selector(settingsViewController:refreshAfterSettingsSaved:)]) {
        [self.delegate settingsViewController:self refreshAfterSettingsSaved:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fahrenheitDegreesLabelTapped:(id)sender
{
    [FXKeychain defaultKeychain][kWAEConfigTemperature] = @(WAETemperatureUnitFahrenheit);
    if ([self.delegate respondsToSelector:@selector(settingsViewController:refreshAfterSettingsSaved:)]) {
        [self.delegate settingsViewController:self refreshAfterSettingsSaved:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private

- (void)setExerciseCityPhotoWithImageURL:(NSString *)imageURL andImageView:(UIImageView *)imageView
{
    [WAECitiesHelper getExerciseCityPhotoWithImageURL:imageURL andBlock:^(BOOL succeeded, UIImage *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return;
        }
        
        if (result) {
            imageView.image = result;
        }
    }];
}

@end
