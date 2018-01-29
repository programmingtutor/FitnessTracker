//
//  SitUpTrackerViewController.m
//  Fitness Tracker
//
//  Created by Hongxuan on 29/1/18.
//  Copyright © 2018 ITE. All rights reserved.
//

#import "SitUpTrackerViewController.h"
#import "FitnessTrackerDB.h"
#import "MainMenuViewController.h"

@interface SitUpTrackerViewController () {
	
	int timeTick;
	NSTimer *timer;
	int sitUpCount;
	__block BOOL seatedup;
}

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;

@end

@implementation SitUpTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	//Instantiate motionManager
	motionManager = [[CMMotionManager alloc]init];
	
	//Initialize bool flag for UIAlertController event.
	seatedup = NO;
	
	//Initialize timer
	timeTick = 0;
	
	//Initialize the situp counter
	sitUpCount = 0;
	
	/*Invalidate (stop) the timer if it is running, otherwise when this function is called again,
	 the timer would run twice as fast each second and so on. */
	[timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated
{
	[motionManager stopDeviceMotionUpdates];
	[timer invalidate];
	timer = nil;
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
- (IBAction)btnEndWorkout:(id)sender {
	
	[motionManager stopDeviceMotionUpdates];
	[timer invalidate];
	timer = nil;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *attemptDate = [NSDate date];
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"INSERT INTO Workouts(attemptDate, username, workout_type, result, timeTaken) VALUES('%@', '%@', 'Sit-Ups', '%d', '%@')", [dateFormatter stringFromDate:attemptDate], self.username, sitUpCount, self.lblTimer.text];
	
	// Execute the query.
	[self.dbManager executeQuery:query];
	
	// If the query was successfully executed then pop the view controller.
	if (self.dbManager.affectedRows != 0) {
		
		NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Workout Finished"
																	   message:[NSString stringWithFormat:@"Score: %d\nWorkout has been saved to history.", sitUpCount]
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

- (NSString *)formattedTime:(int)totalSeconds
{
	
	int seconds = totalSeconds % 60;
	int minutes = (totalSeconds / 60) % 60;
	int hours = totalSeconds / 3600;
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)returntoMainMenu {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
	MainMenuViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:navigationController animated:YES completion:nil];
}

-(void)startWorkout {
	
	self.lblTimer.text = @"00:00:00";
	self.lblTimer.alpha = 1.0;
	self.lblCount.alpha = 1.0;
	self.btnEndWorkoutOutlet.alpha = 1.0; //Show btnEndWorkout
	
	[self startSitUpSensor];
	
	//Begin the timer
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
}

-(void)timerStart
{
	timeTick++;
	self.lblTimer.text = [self formattedTime: timeTick];
}

- (void)startSitUpSensor
{
	if (motionManager.deviceMotionAvailable)
	{
		motionManager.deviceMotionUpdateInterval = 0.045;
		
		[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
			
			CMAttitude *attitude = motion.attitude;
			double degree = attitude.pitch * 180.0/M_PI;
		
			dispatch_async(dispatch_get_main_queue(), ^{
				
				// Update UI
				
				if (!seatedup)
				{
					//If device is 75 degrees and above upright position
					if (degree >=75.0)
					{
						sitUpCount++;
						self.lblCount.text = [NSString stringWithFormat:@"%i", sitUpCount];
						seatedup = YES;
					}
				}
				else
				{
					//If device is 10 degrees and below flat position
					if (degree <=10.0)
					{
						seatedup = NO;
					}
				}
			});
		}];
		
		//NSLog(@"Device motion started");
	}
	
	else
	{
		//NSLog(@"Device motion unavailable");
	}
}
- (IBAction)btnBack:(id)sender {
	
	[self returntoMainMenu];
}
@end
