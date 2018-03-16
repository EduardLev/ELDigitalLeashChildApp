//
//  ViewController.m
//  DigitalLeashChildApp
//
//  Created by Eduard Lev on 2/18/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface ViewController () {
  Reachability *internetReachable;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self finishUpdatingUI];
    
    self.child = [[User alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.delegate = self.child;
        [self.manager requestWhenInUseAuthorization];
        [self.manager startUpdatingLocation];
    } else {
        return;
    }
  
  [self testInternetConnection];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testInternetConnection)
    name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUIFromInternetResult:(BOOL)internet {
  if (!internet) {
    self.reportLocationButton.enabled = FALSE;
    self.errorView.hidden = FALSE;
    self.errorLabel.text = @"Please enable internet for this application.";
  } else {
    self.reportLocationButton.enabled = TRUE;
    self.errorView.hidden = TRUE;
  }
}

/**
 * Tests if the internet is reachable using the Reachability class
 * Uses google.com as test
 *
 */
- (void)testInternetConnection {
  internetReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
  
  __weak typeof(self) weakSelf = self;
  
  internetReachable.reachableBlock = ^(Reachability*reach) {
    // Update the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf updateUIFromInternetResult:true];
    });
  };
  
  // Internet is not reachable
  internetReachable.unreachableBlock = ^(Reachability*reach)
  {
    // Update the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf updateUIFromInternetResult:false];
    });
  };
  
  [internetReachable startNotifier];
}

-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC {
    
}
- (IBAction)reportLocationButtonPressed:(UIButton *)sender {

    if ([self validateUsername:self.usernameTextField.text]) {
        self.child.username = self.usernameTextField.text;
            NSDictionary *dict = [self createDictionaryFromCurrentUser];
            NSData *data = [self putDictionaryIntoJSON:dict];
            [self sendUserToFirebase:data];
            NSLog(@"%@,%f,%f",self.child.username,self.child.latitude,self.child.longitude);
            [self performSegueWithIdentifier:@"reportLocation" sender:nil];
        }
    
}

-(NSDictionary*)createDictionaryFromCurrentUser {
    NSString *lat = [NSString stringWithFormat:@"%0.4f", self.child.latitude];
    NSString *log = [NSString stringWithFormat:@"%0.4f", self.child.longitude];
    
    NSDictionary *userDetails = @{
                                  @"username": self.child.username,
                                  @"current_latitude": lat,
                                  @"current_longitude": log,
                                  };
    
    return userDetails;
}

-(NSData*)putDictionaryIntoJSON:(NSDictionary*)dict {
    // Create JSON Object
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

-(void)sendUserToFirebase:(NSData*)userData {
    // Creates url with current user name
    NSURL *url = [[NSURL alloc] withUserName:self.child.username];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:url];
    urlRequest.HTTPMethod = @"PATCH";
    
    // Create data task to put data to url in firebase
    
    NSURLSessionDataTask *putURLToFirebase = [[NSURLSession sharedSession] uploadTaskWithRequest:urlRequest fromData:userData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      dispatch_async(dispatch_get_main_queue(),^{
        if(error) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                      message:[error localizedRecoverySuggestion]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"Dismiss",@"")
                                            otherButtonTitles:nil];
      
      [alert show];
        }
      });
    }];
    [putURLToFirebase resume];
}

-(BOOL)validateUsername:(NSString*)username {
    if (([username isEqualToString:@""])||(username == nil)||([username containsString:@" "])) {
        self.errorView.hidden = FALSE;
        self.errorLabel.text = @"Error: Please enter valid Username";
        return false;
    }
    self.errorView.hidden = TRUE;
    return true;
}

#pragma mark - Graphics Methods
-(void)finishUpdatingUI {
    [self createRoundedButton];
    [self createIndentedTextInput];
}

-(void)createRoundedButton {
    self.reportLocationButton.layer.cornerRadius = 20;
    self.reportLocationButton.clipsToBounds = YES;
}

-(void)createIndentedTextInput {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,40)];
    self.usernameTextField.leftView = paddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
}




@end
