//
//  LocationManager.m
//  locationTest
//
//  Created by Bradley Mueller on 3/15/13.
//  Copyright (c) 2013 Cellaflora. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation LocationManager

+ (LocationManager *)sharedManager
{
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)startMonitoringLocation
{
    NSLog(@"Setting up location manager");
    if (!self.manager) {
        if ([CLLocationManager locationServicesEnabled])
            NSLog(@"Location services are enabled");
        if ([CLLocationManager authorizationStatus])
            NSLog(@"Locations are authorized");
        
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        self.manager = manager;
    }
    
    [self.manager startUpdatingLocation];
    
    if ([CLLocationManager headingAvailable]) {
        [self.manager startUpdatingHeading];
    }
}

- (void)stopMonitoringLocation
{
    [self.manager stopUpdatingLocation];
    [self.manager stopUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location manager updated locations");
    CLLocation *location = [locations lastObject];
    [self.delegate locationManager:self receivedNewLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed");
    [self.delegate locationManager:self receivedNewLocation:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"Location manager updated heading");
    [self.delegate locationManager:self updatedHeading:newHeading];
}



@end
