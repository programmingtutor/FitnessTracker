#import "PushUpTrackerViewController.h"
#import "FitnessTrackerDB.h"
#import "MainMenuViewController.h"

@interface PushUpTrackerViewController () {
	
	int timeTick;
	NSTimer *timer;
	int pushUpCount;
}

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;

@end

@implementation PushUpTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	//Initialize the pushup counter
	pushUpCount = 0;
	
	/*Invalidate (stop) the timer if it is running, otherwise when this function is called again,
	 the timer would run twice as fast each second and so on. */
	[timer invalidate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)returntoMainMenu {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
	MainMenuViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:navigationController animated:YES completion:nil];
}


- (void)startWorkout
{
	self.lblTimer.text = @"00:00:00";
	self.lblTimer.alpha = 1.0;
	self.lblCount.alpha = 1.0;
	self.btnEndWorkoutOutlet.alpha = 1.0; //Show btnEndWorkout
	//self.btnEndWorkoutOutlet.enabled = YES;
	
	//Enable the proximity sensor to use it
	device = [UIDevice currentDevice];
	device.proximityMonitoringEnabled = YES;
	
	// Proximity Sensor Notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:device]; //Create an observer to detect proximity changes
	
	//Begin the timer
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
}


-(void)timerStart
{
	timeTick++;
	self.lblTimer.text = [self formattedTime: timeTick];
}


- (NSString *)formattedTime:(int)totalSeconds
{
	
	int seconds = totalSeconds % 60;
	int minutes = (totalSeconds / 60) % 60;
	int hours = totalSeconds / 3600;
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


- (void) viewDidDisappear:(BOOL)animated
{
	device.proximityMonitoringEnabled = NO;
	[timer invalidate];
	timer = nil;
}

- (void)proximityChanged:(NSNotification *)notification
{
	device = [notification object];
	
	if (device.proximityState == 1) {
		
		pushUpCount++; //Increment as proximity state changes
		self.lblCount.text = [NSString stringWithFormat:@"%i", pushUpCount]; //Output to the label
		
	}
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
	
	//Create timer object
	//set tick interval to 1.0
	//set selector to the method that should be executed on the interval
	//set repeat to yes meaning it should run continiously, not just once
	
	[UIView animateWithDuration:0.7 animations:^{
		
		self.btnStartOutlet.alpha = 0;
		
	} completion:^(BOOL finished) {
		
		[self startWorkout];
	}];
}

- (IBAction)btnEndWorkout:(id)sender {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *attemptDate = [NSDate date];
	
	NSString *query = [NSString stringWithFormat:@"INSERT INTO Workouts VALUES('%@', '%@', 'Push-Ups', '%d', '%@')", [dateFormatter stringFromDate:attemptDate], self.username, pushUpCount, self.lblTimer.text];
	
	// Execute the query.
	[self.dbManager executeQuery:query];
	
	// If the query was successfully executed then pop the view controller.
	if (self.dbManager.affectedRows != 0) {
		
		NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Workout Finished"
																	   message:[NSString stringWithFormat:@"Score: %d\nWorkout has been saved to history.", pushUpCount]
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Return to Main Menu" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {
																  
																  [self.navigationController popToRootViewControllerAnimated:YES];
															  }];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
	else{
		
		NSLog(@"Could not execute the query.");
	}
	
}

- (IBAction)btnBack:(id)sender {
	
	[self returntoMainMenu];
}

@end
