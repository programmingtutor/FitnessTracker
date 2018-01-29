#import "GymDetailsViewController.h"

@interface GymDetailsViewController ()

@end

@implementation GymDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.lblTitle.text = self.myTitle;
	self.lblSubtitle.text = self.mySubtitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnGetDirections:(id)sender {
	
	[self promptToOpenDefaultAppGoogleMaps];
}

- (void)promptToOpenDefaultAppGoogleMaps
{
	
	//Default directions app is Google Maps
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
	{
		
		NSString *directionsURLGoogle = [NSString stringWithFormat:@"comgooglemaps://?saddr=My%%20Location&daddr=%f,%f", self.pointCoordinate.latitude, self.pointCoordinate.longitude];
		
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:directionsURLGoogle] options:@{} completionHandler:nil];
		
	}
	
	//Use Apple Maps if Google Maps is not installed
	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]])
	{
		NSString* directionsURLApple = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=Current%%20Location&daddr=%f,%f", self.pointCoordinate.latitude, self.pointCoordinate.longitude];
		
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURLApple] options:@{} completionHandler:nil];
		
	}
	
	else
	{
		NSLog(@"Could not get directions");
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

@end
