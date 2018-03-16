//
//  ViewController.h
//  DigitalLeashChildApp
//
//  Created by Eduard Lev on 2/18/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "NSURL+ELWIthUserName.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *reportLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@property (nonatomic) User *child;
@property (nonatomic) BOOL location_enabled;
@property (nonatomic) CLLocationManager *manager;

// Graphics functions
-(void)finishUpdatingUI;
-(void)createRoundedButton;
-(void)createIndentedTextInput;

// Network functions
-(void)sendUserToFirebase:(NSData*)userData;

// Validation functions
-(BOOL)validateUsername:(NSString*)username;

@end

