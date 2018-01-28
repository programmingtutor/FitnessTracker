#import "PasswordViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FitnessTrackerDB.h"

@interface PasswordViewController ()

-(void)authenticateUsingTouchID;
@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;
//-(void)reportTouchIDError: (NSError *)error;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:tap];
	
	self.lblUsername.text = self.username;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	//Animates the welcome prompt
	[UIView animateWithDuration:0.7 animations:^{
		
		self.lblWelcome.alpha = 1.0;
		self.lblUsername.alpha = 1.0;
	}];
}

-(void)authenticateUsingTouchID {
	
	LAContext *authContext = [[LAContext alloc] init];
	NSString *authReason = @"Please use Touch ID to log in to Fitness Tracker";
	NSError *authError;
	
	if ([authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
		
		[authContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:authReason reply:^(BOOL success, NSError * _Nullable error) {
			
			if (success) {
				
				//Authentication is successful
				NSLog(@"success");
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					//Go to main menu
				});
			}
			else {
				
				dispatch_async(dispatch_get_main_queue(), ^{
					
					//[self reportTouchIDError:error];
				});
			}
		}];
	}
	else {
		
		NSLog(@"%@", authError.localizedDescription);
	}
}

//-(void)reportTouchIDError:(NSError *)error {
//
//	switch (error.code) {
//		case LAErrorAuthenticationFailed:
//			NSLog(@"Authentication Failed");
//		case LAErrorPasscodeNotSet:
//			NSLog(@"Passcode not set");
//		case LAErrorSystemCancel:
//			NSLog(@"Authentication was cancelled by the system");
//		case LAErrorUserCancel:
//			NSLog(@"Authentication was cancelled by the user");
//		case LAErrorBiometryNotEnrolled:
//			NSLog(@"User hasn't enrolled any finger with Touch ID");
//		case LAErrorBiometryNotAvailable:
//			NSLog(@"Touch ID is not available");
//		case LAErrorUserFallback:
//			NSLog(@"User tapped enter password");
//		default:
//			NSLog(@"%@", error.localizedDescription);
//	}
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

- (IBAction)useTouchIDBtn:(UIButton *)sender {
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"SELECT useTouchID FROM UserInfo WHERE username = '%@'", self.username];
	
	// Get the results.
	if (self.arrUserInfo != nil) {
		self.arrUserInfo = nil;
	}
	self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
	if ([self.arrUserInfo count] != 0) {
		
		NSArray *selectedUser = [self.arrUserInfo objectAtIndex:0];
		
		NSInteger index = [self.dbManager.arrColumnNames indexOfObject:@"useTouchID"];
		
		if ((NSInteger)[selectedUser objectAtIndex:index] == 1) {
			
			//Check if user has enabled use Touch ID function
			[self authenticateUsingTouchID];
		}
		else {
			
			UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Use Touch ID not enabled"
																		   message:@"Use Touch ID is not enabled in settings. Please log in with your password."
																	preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
																  handler:^(UIAlertAction * action) {}];
			
			[alert addAction:defaultAction];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}
}
- (IBAction)btnLogin:(id)sender {
	
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM UserInfo WHERE username = '%@' AND password = '%@'", self.username, self.txtPassword.text];
	
	// Get the results.
	if (self.arrUserInfo != nil) {
		self.arrUserInfo = nil;
	}
	self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
	if ([self.arrUserInfo count] != 0) {
		
		NSLog(@"success");
		//Move to main menu
	}
	else {
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incorrect password"
																	   message:@"Password is incorrect. Please try again."
																preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
	}
}
@end
