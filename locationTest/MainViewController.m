//
//  MainViewController.m
//  locationTest
//
//  Created by Bradley Mueller on 3/15/13.
//  Copyright (c) 2013 Cellaflora. All rights reserved.
//

#import "MainViewController.h"
#import "LocationManager.h"

#import <MapKit/MapKit.h>

@interface MainViewController () <LocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tSpeedLabel;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) NSMutableArray *locations;

@property (nonatomic) CGFloat realDistance;
@property (nonatomic, strong) MKPointAnnotation *startingPointAnnotation;
@property (nonatomic, strong) MKPointAnnotation *currentPointAnnotation;

@end

// Added comment

// Added comment at 8:45 pm

// Added another comment at 8:46 pm

@implementation MainViewController

// Added comment 9:05

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.label) NSLog(@"No label");
    [self.label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelWasTapped:)]];
    self.locations = [[NSMutableArray alloc] init];
    
}

- (MKMapView *)map
{
    if (!_map) {
        _map = [[MKMapView alloc] initWithFrame:self.mapView.bounds];
        _map.delegate = self;
        [self.mapView addSubview:_map];
    }
    return _map;
}

- (void)labelWasTapped:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.locations count] > 0) {
            [[LocationManager sharedManager] stopMonitoringLocation];
            [self.locations removeAllObjects];
            self.startingPointAnnotation = nil;
            self.currentPointAnnotation = nil;
        }
        else {
            LocationManager *locMgr = [LocationManager sharedManager];
            locMgr.delegate = self;
            [locMgr startMonitoringLocation];
        }
    }
}

- (void)locationManager:(LocationManager *)mgr receivedNewLocation:(CLLocation *)loc
{
    if (loc) {
        self.label.text = [loc description];
        
        if ([self.locations count] == 0) {
            self.map.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.01, 0.01));
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.title = @"Start";
            point.subtitle = @"0";
            point.coordinate = loc.coordinate;
            self.startingPointAnnotation = point;
            [self.map addAnnotation:point];
            
            self.realDistance = 0;
        }
        else {
            CLLocation *firstLoc = [self.locations objectAtIndex:0];
            CLLocation *prevLoc = [self.locations lastObject];
            
            if ([prevLoc distanceFromLocation:loc] > 1.0) {
                CGFloat dist = [prevLoc distanceFromLocation:loc];
                self.realDistance += dist;
                CGFloat tDist = self.realDistance;
                CGFloat time = [loc.timestamp timeIntervalSinceDate:prevLoc.timestamp];
                CGFloat tTime = [loc.timestamp timeIntervalSinceDate:firstLoc.timestamp];
                CGFloat speed = dist / time;
                CGFloat avgSpeed = tDist / tTime;
                self.distanceLabel.text = [NSString stringWithFormat:@"Distance: %0.1f m",dist];
                self.timeLabel.text = [NSString stringWithFormat:@"Time: %0.1f s",time];
                self.speedLabel.text = [NSString stringWithFormat:@"Speed: %0.1f m/s",speed];
                self.tDistanceLabel.text = [NSString stringWithFormat:@"Total distance: %0.1f m",tDist];
                self.tTimeLabel.text = [NSString stringWithFormat:@"Total time: %0.1f s",tTime];
                self.tSpeedLabel.text = [NSString stringWithFormat:@"Avg Speed: %0.1f m/s",avgSpeed];
                                
                // Drop another point!
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.title = [NSString stringWithFormat:@"%0.1fm",tDist];
                point.subtitle = [NSString stringWithFormat:@"%d",[self.locations count]];
                point.coordinate = loc.coordinate;
                self.currentPointAnnotation = point;
                [self.map addAnnotation:point];
            }
        }
        [self.locations addObject:loc];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Point"];
    if ([self.startingPointAnnotation isEqual:annotation])
        pinView.pinColor = MKPinAnnotationColorGreen;
    else if ([self.currentPointAnnotation isEqual:annotation])
        pinView.pinColor = MKPinAnnotationColorRed;
    else
        pinView.pinColor = MKPinAnnotationColorPurple;
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    pinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    return pinView;
}

- (void)locationManager:(LocationManager *)mgr updatedHeading:(CLHeading *)heading
{
    self.label2.text = [heading description];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
