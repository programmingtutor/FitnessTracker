#import "SettingsTableViewController.h"
#import "FitnessTrackerDB.h"
#import "LoginViewController.h"
#import "ChangePasswordViewController.h"
#import "UserDetailsViewController.h"


@interface SettingsTableViewController ()

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;
-(void)showLoginFailed;
-(void)deleteAccount;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
		
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) {
		return 1;
	}
	else if (section == 1) {

		return 3;
	}
	else if (section == 2) {
		return 2;
	}
	
	return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	//Use Touch ID for Login
	if (indexPath.row == 0 && indexPath.section == 1) {
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@'", self.username];
		
		// Get the results.
		if (self.arrUserInfo != nil) {
			self.arrUserInfo = nil;
		}
		self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
		
		if ([self.arrUserInfo count] != 0) {
			
			NSArray *selectedUser = [self.arrUserInfo objectAtIndex:0];
			
			NSInteger index = [self.dbManager.arrColumnNames indexOfObject:@"useTouchID"];
			
			if ([[selectedUser objectAtIndex:index]  isEqual: @"1"]) {
				
				[self setTouchIDStateOff];
			}
			else {
				
				[self setTouchIDStateOn];
			}
		}
	}
	//Log Out
	else if (indexPath.row == 1 && indexPath.section == 2){
		
		UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		[controller addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			//Go back to login screen
			
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginMenu"];
			[self presentViewController:loginVC animated:YES completion:nil];
		}]];
		
		[controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
		
		[self presentViewController:controller animated:YES completion:nil];
	}
	//Change Password
	else if (indexPath.row == 1 && indexPath.section == 1) {
		
		[self performSegueWithIdentifier:@"changePassword" sender:self];
	}
	//Delete Account
	else if (indexPath.row == 2 && indexPath.section == 1) {
		
		[self deleteAccountPrompt];
	}
	//Update User Details
	else if (indexPath.row == 0 && indexPath.section == 0) {
		
		[self performSegueWithIdentifier:@"updateUserDetails" sender:self];
	}
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell...
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"touchIDIdentifier" forIndexPath:indexPath];

	return cell;
}*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	if ([[segue identifier]  isEqual: @"changePassword"]) {
		
		ChangePasswordViewController *vc = (ChangePasswordViewController *)[segue destinationViewController];
		vc.username = self.username;
	}
	else if ([[segue identifier]  isEqual: @"updateUserDetails"]) {
		
		UserDetailsViewController *vc = (UserDetailsViewController *)[segue destinationViewController];
		vc.username = self.username;
	}
}


-(void)setTouchIDStateOff {
	
	[self showOverlayOnTask];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disableTouchID) userInfo:nil repeats:NO];
}

- (void)setTouchIDStateOn {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Password" message:@"Please enter your password to enable Use Touch ID" preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Password";
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.secureTextEntry = YES;
	}];
	
	[alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSArray * textfields = alert.textFields;
		UITextField *password = textfields[0];
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@' AND password = '%@'", self.username, password.text];
		
		// Get the results.
		if (self.arrUserInfo != nil) {
			self.arrUserInfo = nil;
		}
		self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
		
		if ([self.arrUserInfo count] != 0) {
			
			[self showOverlayOnTask];
			[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(enableTouchID) userInfo:nil repeats:NO];
		}
		else {
			
			[self showOverlayOnTask];
			[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showLoginFailed) userInfo:nil repeats:NO];
		}
		
	}]];
	
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		
	}]];
	
	[self presentViewController:alert animated:YES completion:nil];
	
}


-(void)enableTouchID {
	
	[self dismissViewControllerAnimated:YES completion:^{
	
			
			self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
			
			NSString *query = [NSString stringWithFormat:@"UPDATE UserInfo SET useTouchID = %d WHERE username = '%@'", 1, self.username];
			
			// Execute the query.
			[self.dbManager executeQuery:query];
			
			// If the query was successfully executed
			if (self.dbManager.affectedRows != 0) {
				
				NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
				
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Use Touch ID is now enabled"
																			   message:@"You can now use Touch ID for authentication."
																		preferredStyle:UIAlertControllerStyleAlert];
				
				UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
																	  handler:^(UIAlertAction * action) {
																		  
																	  }];
				
				[alert addAction:defaultAction];
				[self presentViewController:alert animated:YES completion:nil];
			}
			else{
				NSLog(@"Could not execute the query.");
			}
		
		}];
}

-(void)disableTouchID {
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"UPDATE UserInfo SET useTouchID = %d WHERE username = '%@'", 0, self.username];
		
		// Execute the query.
		[self.dbManager executeQuery:query];
		
		// If the query was successfully executed
		if (self.dbManager.affectedRows != 0) {
			
			NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
			
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Use Touch ID is now disabled"
																		   message:@"Use Touch ID is successfully disabled."
																	preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
																  handler:^(UIAlertAction * action) {
																	  
																  }];
			
			[alert addAction:defaultAction];
			[self presentViewController:alert animated:YES completion:nil];
		}
		else{
			NSLog(@"Could not execute the query.");
		}
		
	}];
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


-(void)showLoginFailed {
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incorrect password"
																	   message:@"Password is incorrect. Please try again."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}];
}

-(void)deleteAccountPrompt {
	
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Delete Account" message:@"All data in this account will be deleted. Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
	
	//OK ACTION
	[controller addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		
		//Enter Password
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Password" message:@"Please enter your password to confirm deletion of account." preferredStyle:UIAlertControllerStyleAlert];
		
		[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.placeholder = @"Password";
			textField.clearButtonMode = UITextFieldViewModeWhileEditing;
			textField.secureTextEntry = YES;
		}];
		
		[alert addAction:[UIAlertAction actionWithTitle:@"Delete Account" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
			NSArray * textfields = alert.textFields;
			UITextField *password = textfields[0];
			
			self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
			
			NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@' AND password = '%@'", self.username, password.text];
			
			// Get the results.
			if (self.arrUserInfo != nil) {
				self.arrUserInfo = nil;
			}
			self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
			
			if ([self.arrUserInfo count] != 0) {
				
				//Delete account
				[self showOverlayOnTask];
				[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(deleteAccount) userInfo:nil repeats:NO];
			}
			else {
				
				//Wrong password
				[self showOverlayOnTask];
				[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showLoginFailed) userInfo:nil repeats:NO];
			}
			
		}]];
		
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		}]];
		
		[self presentViewController:alert animated:YES completion:nil];
	}]];
	
	[controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:controller animated:YES completion:nil];
}

-(void)deleteAccount {
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		NSString *query = [NSString stringWithFormat:@"DELETE FROM Workouts WHERE username = '%@'", self.username];
		
		[self.dbManager executeQuery:query];
		
		if (self.dbManager.affectedRows != 0) {
			
			NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
		}
		else{
			NSLog(@"Could not execute the query.");
		}
		
		query = [NSString stringWithFormat:@"DELETE FROM UserInfo WHERE username = '%@'", self.username];
		
		// Execute the query.
		[self.dbManager executeQuery:query];
		
		// If the query was successfully executed
		if (self.dbManager.affectedRows != 0) {
			
			NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
			//Go back to login menu
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginMenu"];
			[self presentViewController:vc animated:YES completion:nil];
		}
		else{
			NSLog(@"Could not execute the query.");
		}
	}];
}
@end
