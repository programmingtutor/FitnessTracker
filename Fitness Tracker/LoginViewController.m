#import "LoginViewController.h"
#import "FitnessTrackerDB.h"
#import "PasswordViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];
	
//
//	NSString *query = [NSString stringWithFormat:@"INSERT INTO UserInfo VALUES('admin', 'password', 'Admin', 'FitnessTracker', '1999-02-10', %d", 0];
//
//	// Execute the query.
//	[self.dbManager executeQuery:query];
//
//	// If the query was successfully executed then pop the view controller.
//	if (self.dbManager.affectedRows != 0) {
//		NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
//	}
//	else{
//		NSLog(@"Could not execute the query.");
//	}

	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[self login];
	return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	if ([[segue identifier] isEqualToString:@"enterPassword"]) {
		
		PasswordViewController *passwordVC = (PasswordViewController *)segue.destinationViewController;
		passwordVC.username = self.userTextField.text;
	}
}

-(void)login {
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"SELECT username FROM UserInfo WHERE username = '%@'", self.userTextField.text];
	
	// Get the results.
	if (self.arrUserInfo != nil) {
		self.arrUserInfo = nil;
	}
	self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
	if ([self.arrUserInfo count] != 0) {
		
		[self performSegueWithIdentifier:@"enterPassword" sender:self];
	}
	else if ([self.userTextField.text length] == 0) {
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please enter username"
																	   message:@"There is no username entered in the field."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
	else {
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No username found"
																	   message:@"There is no username found."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
}


- (IBAction)loginBtn:(UIButton *)sender {
	
	[self login];
	
	/* For debug purposes, this method displays the columns of the table for UserInfo
	NSArray *selectedUser = [self.arrUserInfo objectAtIndex:0];
	
	NSInteger indexOfFirstName = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
	NSInteger indexOfLastName = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
	NSInteger indexOfDOB = [self.dbManager.arrColumnNames indexOfObject:@"dateofbirth"];

	NSLog(@"%@", [NSString stringWithFormat:@"%@, %@, %@", [selectedUser objectAtIndex:indexOfFirstName], [selectedUser objectAtIndex:indexOfLastName], [selectedUser objectAtIndex:indexOfDOB]]);
	 */
}

- (IBAction)btnSignUp:(id)sender {
	
	[self performSegueWithIdentifier:@"registerAccount" sender:self];
}
@end
