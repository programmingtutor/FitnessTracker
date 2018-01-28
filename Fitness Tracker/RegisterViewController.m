#import "RegisterViewController.h"
#import "FitnessTrackerDB.h"

@interface RegisterViewController ()

-(BOOL)validateFields;
@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:tap];
	
	[self.dobPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	self.lblPrompt.hidden = YES;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[textField setInputAccessoryView:self.toolBarTextField];
	
	if (textField.tag == 2 || textField.tag == 3) {
		
		[textField setInputAccessoryView:nil];
	}
	
	if (textField.tag == 4) {
		
		[textField setInputView:self.dobPicker];
		textField.text = @"01/01/2018";
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

-(BOOL)validateFields {
	
	self.lblPrompt.hidden = NO;
	self.lblPrompt.text = @"";
	
	if ([self.txtUsername.text length] == 0) {
		
		self.lblPrompt.text = @"Username must not be empty.";
		
		return NO;
	}
	else if ([self.txtPassword.text length] == 0 || [self.txtCfmPassword.text length] == 0) {
		
		self.lblPrompt.text = @"Password must not be empty.";
		
		return NO;
	}
	else if (self.txtPassword.text != self.txtCfmPassword.text) {
		
		self.lblPrompt.text = @"Passwords do not match.";
		
		return NO;
	}
	else if ([self.txtFirstName.text length] == 0) {
		
		self.lblPrompt.text = @"First Name must not be empty.";
		
		return NO;
	}
	else if ([self.txtLastName.text length] == 0) {
		
		self.lblPrompt.text = @"Last Name must not be empty.";
		
		return NO;
	}
	else if ([self.txtDOB.text length] == 0) {
		
		self.lblPrompt.text = @"Date of Birth must not be empty.";
		
		return NO;
	}
	
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


- (IBAction)btnSignUp:(UIButton *)sender {
	
	if ([self validateFields]) {
		
		self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
		
		//Check if username is taken
		NSString *query = [NSString stringWithFormat:@"SELECT username FROM UserInfo WHERE username = '%@'", self.txtUsername.text];
		
		// Get the results.
		if (self.arrUserInfo != nil) {
			self.arrUserInfo = nil;
		}
		
		self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
		
		if ([self.arrUserInfo count] != 0) {
			
			self.lblPrompt.text = @"Username is taken.";
		}
		else {
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			
			NSString *query = [NSString stringWithFormat:@"INSERT INTO UserInfo VALUES('%@', '%@', '%@', '%@', '%@', %d)", self.txtUsername.text, self.txtPassword.text, self.txtFirstName.text, self.txtLastName.text, [dateFormatter stringFromDate:self.dobPicker.date], 0];
			
			// Execute the query.
			[self.dbManager executeQuery:query];
			
			// If the query was successfully executed then pop the view controller.
			if (self.dbManager.affectedRows != 0) {
				
				NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
				
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Registration Successful"
																			   message:@"You can now log in with your username and password."
																		preferredStyle:UIAlertControllerStyleAlert];
				
				UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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
	}
	
}
- (IBAction)btnDone:(UIBarButtonItem *)sender {
	
	[self.view endEditing:YES];
	
}

- (IBAction)dobChanged:(UIDatePicker *)sender {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];

	
	self.txtDOB.text = [dateFormatter stringFromDate:self.dobPicker.date];
}
@end
