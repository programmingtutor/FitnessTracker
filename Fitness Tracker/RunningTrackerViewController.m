#import "RunningTrackerViewController.h"
#import "MainMenuViewController.h"
#import "FitnessTrackerDB.h"

@interface RunningTrackerViewController () {
	
	int timeTick;
	NSTimer *timer;
	double distanceTravelledInKM;
	CLLocation *startLocation;
	CLLocation *endLocation;
}
@property (nonatomic, strong) FitnessTrackerDB *dbManager;

@end

@implementation RunningTrackerViewController

-(void)returntoMainMenu {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
	MainMenuViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	distanceTravelledInKM = 0.0;
	
	/*Invalidate (stop) the timer if it is running, otherwise when this function is called again,
	 the timer would run twice as fast each second and so on. */
	[timer invalidate];
	
	locationManager = [[CLLocationManager alloc]init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startWorkout
{
	self.lblTimer.text = @"00:00:00";
	self.lblTimer.alpha = 1.0;
	self.lblDistance.alpha = 1.0;
	self.btnEndWorkoutOutlet.alpha = 1.0; //Show btnEndWorkout
	//self.btnEndWorkoutOutlet.enabled = YES;

	startLocation = nil;
	endLocation = nil;
	
	//start updating location
	[locationManager startUpdatingLocation];
	
	//Begin the timer
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
}


-(void)timerStart
{
	timeTick++;
	self.lblTimer.text = [self formattedTime: timeTick];
}

- (void) viewWillDisappear:(BOOL)animated {
	
	[timer invalidate];
	timer = nil;
	[locationManager stopUpdatingLocation];
}


- (NSString *)formattedTime:(int)totalSeconds
{
	
	int seconds = totalSeconds % 60;
	int minutes = (totalSeconds / 60) % 60;
	int hours = totalSeconds / 3600;
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)promptUserForLocationSettings
{
	UIAlertController *alert = [UIAlertController
								alertControllerWithTitle:@"Could not find current location"
								message:@"Please turn on location services to allow GPS to track your distance."
								preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *cancelButton = [UIAlertAction
								   actionWithTitle:@"Cancel"
								   style:UIAlertActionStyleCancel
								   handler:^(UIAlertAction * action) {
								   }];
	
	[alert addAction:cancelButton];
	
	UIAlertAction *settingsButton = [UIAlertAction
									 actionWithTitle:@"Open Settings"
									 style:UIAlertActionStyleDefault
									 handler:^(UIAlertAction * action) {
										 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
										 
										 [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
									 }];
	
	[alert addAction:settingsButton];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	
	[self promptUserForLocationSettings];
	[timer invalidate];
	timer = nil;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	
	if (startLocation == nil) {
		
		startLocation = locations.firstObject;
	}
	else {
		
		double lastDistance = [endLocation distanceFromLocation:locations.lastObject];
		distanceTravelledInKM += 1.6 * (lastDistance * 0.000621371);
		
		NSString *trimmedDistance = [NSString stringWithFormat:@"%.2fKM", distanceTravelledInKM];
		
		self.lblDistance.text = trimmedDistance;
	}
	
	if (distanceTravelledInKM >= 2.4) {
		
		[self finishWorkout];
	}
	
	endLocation = locations.lastObject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnStart:(id)sender {
	
	[UIView animateWithDuration:0.7 animations:^{
		
		self.btnStartOutlet.alpha = 0;
		
	} completion:^(BOOL finished) {
		
		[self startWorkout];
	}];
}
- (IBAction)btnBack:(id)sender {
	
	[self returntoMainMenu];
}
- (IBAction)btnEndWorkout:(id)sender {
	
	[self finishWorkout];
}

-(void)finishWorkout {
	
	[timer invalidate];
	timer = nil;
	[locationManager stopUpdatingLocation];
	
	NSString *trimmedDistance = [NSString stringWithFormat:@"%.2fKM", distanceTravelledInKM];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *attemptDate = [NSDate date];
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"INSERT INTO Workouts(attemptDate, username, workout_type, result, timeTaken) VALUES('%@', '%@', '2.4KM Run', '%@', '%@')", [dateFormatter stringFromDate:attemptDate], self.username, trimmedDistance, self.lblTimer.text];
	
	// Execute the query.
	[self.dbManager executeQuery:query];
	
	// If the query was successfully executed then pop the view controller.
	if (self.dbManager.affectedRows != 0) {
		
		NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Workout Finished"
																	   message:[NSString stringWithFormat:@"Result: %@\nWorkout has been saved to history.", trimmedDistance]
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Return to Main Menu" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {
																  
																  [self returntoMainMenu];
															  }];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
	else{
		
		NSLog(@"Could not execute the query.");
	}
}
@end
