//
//  LocationManager.h
//  locationTest
//
//  Created by Bradley Mueller on 3/15/13.
//  Copyright (c) 2013 Cellaflora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

- (void)locationManager:(LocationManager *)mgr receivedNewLocation:(CLLocation *)loc;
- (void)locationManager:(LocationManager *)mgr updatedHeading:(CLHeading *)heading;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager *)sharedManager;
- (void)startMonitoringLocation;
- (void)stopMonitoringLocation;
@property (nonatomic, strong) id <LocationManagerDelegate> delegate;
@end
