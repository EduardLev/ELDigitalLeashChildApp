//
//  User.h
//  DigitalLeashChildApp
//
//  Created by Eduard Lev on 2/18/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject <CLLocationManagerDelegate>

@property (nonatomic) NSString *username;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
