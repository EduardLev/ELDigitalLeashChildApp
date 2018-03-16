//
//  User.m
//  DigitalLeashChildApp
//
//  Created by Eduard Lev on 2/18/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

#import "User.h"

@implementation User

// Notification that the location manager retrieved a new location.
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    NSLog(@"%f,%f",self.latitude,self.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
    }
}

// Notification that the location manager was unable to retrieve a location value.
-(void)locationManager:(CLLocationManager *)manager
    didFailWithError:(nonnull NSError *)error {
    
}

@end
