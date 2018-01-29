#import "ChangePasswordViewController.h"
#import "FitnessTrackerDB.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;
@end

@implementation ChangePasswordViewController

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmBtn:(id)sender {
	
	self.lblPrompt.text = @"";
	[self.lblPrompt setHidden:NO];
	
	if ([self.txtOldPassword.text length] == 0 || [self.txtNewPassword.text length] == 0 || [self.txtConfirmPassword.text length] == 0) {
		
		self.lblPrompt.text = @"One or more fields is missing.";
	}
	else if (self.txtNewPassword.text != self.txtConfirmPassword.text) {
		
		self.lblPrompt.text = @"Passwords do not match.";
	}
	else {
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@' AND password = '%@'", self.username, self.txtOldPassword.text];
		
		// Get the results.
		if (self.arrUserInfo != nil) {
			self.arrUserInfo = nil;
		}
		self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
		
		if ([self.arrUserInfo count] != 0) {
			
			[self showOverlayOnTask];
			[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePassword) userInfo:nil repeats:NO];
		
		}
		else {
			
			self.lblPrompt.text = @"Old password is incorrect.";
		}
	}
}

-(void) showOverlayOnTask {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please wait..." preferredStyle: UIAlertControllerStyleAlert];
	
	UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(10, 5, 50, 50)];
	
	loadingIndicator.hidesWhenStopped = YES;
	loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[loadingIndicator startAnimating];
	[alert.view addSubview:loadingIndicator];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void) updatePassword {
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"UPDATE UserInfo SET password = '%@' WHERE username = '%@'", self.txtNewPassword.text, self.username];
		
		// Execute the query.
		[self.dbManager executeQuery:query];
		
		// If the query was successfully executed
		if (self.dbManager.affectedRows != 0) {
			
			NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
			
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Password Changed"
																		   message:@"You can now login with your new password."
																	preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
																  handler:^(UIAlertAction * action) {
																	  [self.navigationController popViewControllerAnimated:YES];
																  }];
			
			[alert addAction:defaultAction];
			[self presentViewController:alert animated:YES completion:nil];
		}
		else{
			
			NSLog(@"Could not execute the query.");
		}
	}];
	
}
@end
