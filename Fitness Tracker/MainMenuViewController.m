#import "MainMenuViewController.h"
#import "SettingsTableViewController.h"
#import "PushUpTrackerViewController.h"
#import "WorkoutHistoryTableViewController.h"
#import "SitUpTrackerViewController.h"
#import "BMICalculatorViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	if ([[segue identifier]  isEqual: @"showSettings"]) {
		
		SettingsTableViewController *vc = [segue destinationViewController];
		vc.username = self.username;
	}
	else if ([[segue identifier] isEqual:@"showWorkoutHistory"]) {
		
		WorkoutHistoryTableViewController *vc = [segue destinationViewController];
		vc.username = self.username;
	}
}


- (IBAction)btnPushUpTracker:(id)sender {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PushUpTracker" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"pushUpTracker"];
	PushUpTrackerViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)btnSitUpTracker:(id)sender {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SitUpTracker" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"sitUpTracker"];
	SitUpTrackerViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)btnBMICalculator:(id)sender {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BMICalculator" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"bmiCalculator"];
	BMICalculatorViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:navigationController animated:YES completion:nil];
}
@end
