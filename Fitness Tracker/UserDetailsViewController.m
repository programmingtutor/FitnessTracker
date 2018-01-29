//
//  UserDetailsViewController.m
//  Fitness Tracker
//
//  Created by Hongxuan on 29/1/18.
//  Copyright © 2018 ITE. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "FitnessTrackerDB.h"

@interface UserDetailsViewController ()

@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;
@property (nonatomic, copy) NSString *dateOfBirth;

@end

@implementation UserDetailsViewController

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:tap];
	
	[self.dobPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	self.lblUsername.text = self.username;
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@'", self.username];
	
	// Get the results.
	if (self.arrUserInfo != nil) {
		self.arrUserInfo = nil;
	}
	self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
	if ([self.arrUserInfo count] != 0) {
		
		NSArray *selectedUser = [self.arrUserInfo objectAtIndex:0];
		
		NSInteger firstName = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
		NSInteger lastName = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
		NSInteger dateOfBirth = [self.dbManager.arrColumnNames indexOfObject:@"dateofbirth"];

		self.txtFirstName.text = [selectedUser objectAtIndex:firstName];
		self.txtLastName.text = [selectedUser objectAtIndex:lastName];
		self.dateOfBirth = [selectedUser objectAtIndex:dateOfBirth];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate *unformatted = [dateFormatter dateFromString:self.dateOfBirth];
		[self.dobPicker setDate:unformatted];
		[dateFormatter setDateFormat:@"dd/MM/yyyy"];
		self.txtDOB.text = [dateFormatter stringFromDate:unformatted];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[textField setInputAccessoryView:self.txtToolbar];
	
	
	if (textField.tag == 4) {
		
		[textField setInputView:self.dobPicker];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) showOverlayOnTask {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please wait..." preferredStyle: UIAlertControllerStyleAlert];
	
	UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame: CGRectMake(10, 5, 50, 50)];
	
	loadingIndicator.hidesWhenStopped = YES;
	loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[loadingIndicator startAnimating];
	[alert.view addSubview:loadingIndicator];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)updateUserDetails {
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		
		NSString *query = [NSString stringWithFormat:@"UPDATE UserInfo SET firstname = '%@', lastname = '%@', dateofbirth = '%@' WHERE username = '%@'", self.txtFirstName.text, self.txtLastName.text, [dateFormatter stringFromDate:self.dobPicker.date], self.username];
		
		// Execute the query.
		[self.dbManager executeQuery:query];
		
		// If the query was successfully executed then pop the view controller.
		if (self.dbManager.affectedRows != 0) {
			
			NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
			
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"User Details Updated"
																		   message:@"Your user details have been updated."
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


- (IBAction)btnUpdate:(id)sender {
	
	self.lblPrompt.text = @"";
	[self.lblPrompt setHidden:NO];
	
	if ([self.txtFirstName.text length] == 0 || [self.txtLastName.text length] == 0 || [self.txtDOB.text length] == 0) {
		
		self.lblPrompt.text = @"One or more fields is missing.";
	}
	else {
		
		[self showOverlayOnTask];
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUserDetails) userInfo:nil repeats:NO];
	}
}

- (IBAction)dobChanged:(id)sender {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	
	self.txtDOB.text = [dateFormatter stringFromDate:self.dobPicker.date];
}
- (IBAction)btnDone:(id)sender {
	
	[self.view endEditing:YES];
}
@end
