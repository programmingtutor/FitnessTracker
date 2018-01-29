#import "LocateAGymViewController.h"
#import "CustomAnnotation.h"
#import "MainMenuViewController.h"
#import "GymDetailsViewController.h"

@interface LocateAGymViewController () {
	
	//Declare variables to pass annotation properties to view controller
	NSString *annotationTitle;
	NSString *annotationSubtitle;
	CLLocationCoordinate2D annotationCoordinates;
}

@end

@implementation LocateAGymViewController

-(void)returntoMainMenu {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
	MainMenuViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	prompted = NO;
	locationManager = [[CLLocationManager alloc]init];
	self.gymMapView.delegate = self;
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
	
	//Pass array from the called method to use it in a for each loop
	NSMutableArray *AllAnnotations = [CustomAnnotation GetAllAnnotations];
	
	for (CustomAnnotation *annotation in AllAnnotations)
	{
		[self.gymMapView addAnnotation:annotation];
		
	}
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
	
	if([segue.identifier isEqualToString: @"gymDetails"])
	{
		GymDetailsViewController *vc = segue.destinationViewController;

		vc.myTitle = annotationTitle;
		vc.mySubtitle = annotationSubtitle;
		vc.pointCoordinate = annotationCoordinates;
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
	annotationTitle = view.annotation.title;
	annotationSubtitle = view.annotation.subtitle;
	annotationCoordinates = view.annotation.coordinate;
	
	[self performSegueWithIdentifier:@"gymDetails" sender:self];
	
}


- (void) viewWillDisappear:(BOOL)animated {
	
	//Stop using location services when leaving view
	self.gymMapView.showsUserLocation = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
	//Start using location services again when back to the view
	self.gymMapView.showsUserLocation = YES;
}

- (IBAction)btnMapType:(id)sender {
	
	if ([sender selectedSegmentIndex] == 0)
	{
		self.gymMapView.mapType = MKMapTypeStandard;
	}
	else if ([sender selectedSegmentIndex] == 1)
	{
		self.gymMapView.mapType = MKMapTypeSatellite;
	}
	else if ([sender selectedSegmentIndex] == 2)
	{
		self.gymMapView.mapType = MKMapTypeHybrid;
	}
}

- (IBAction)btnBack:(id)sender {
	
	[self returntoMainMenu];
}

- (void)promptUserForLocationSettings
{
	if (!prompted)
	{
		UIAlertController *alert = [UIAlertController
									alertControllerWithTitle:@"Could not find current location"
									message:@"Please turn on location services to allow maps to determine your location."
									preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *cancelButton = [UIAlertAction
									   actionWithTitle:@"Cancel"
									   style:UIAlertActionStyleCancel
									   handler:^(UIAlertAction * action) {
									   }];
		
		[alert addAction:cancelButton];
		
		UIAlertAction *settingsButton = [UIAlertAction
										 actionWithTitle:@"Open Settings"
										 style:UIAlertActionStyleDefault
										 handler:^(UIAlertAction * action) {
											 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
											 
											 [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
										 }];
		
		[alert addAction:settingsButton];
		
		[self presentViewController:alert animated:YES completion:^(void) {prompted = YES;}];
		
	}
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	
	[self promptUserForLocationSettings];
	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	MKCoordinateRegion region;
	
	region.center = locationManager.location.coordinate;
	
	//Zooms in to 5km
	region.span = MKCoordinateSpanMake(0.04504, 0.04504);
	
	[self.gymMapView setRegion:region animated:YES];
	
	//After zooming in, stop updating location to stop calling the delegate method.
	[locationManager stopUpdatingLocation];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	//If class is UserLocation, return nil
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
	
	//If class is CustomAnnotation
	if ([annotation isKindOfClass:[CustomAnnotation class]])
	{
		//Dequeue existing pin view first
		MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
		
		if (!pinView)
		{
			//Create pin view if there is no existing one
			pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
			pinView.pinTintColor = [UIColor colorWithRed:212.0/255 green:108.0/255 blue:247.0/255 alpha:1.0];
			pinView.animatesDrop = YES;
			pinView.canShowCallout = YES;
			
			// Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			
			//action is nil because the selector mapView:annotationView:calloutAccessoryControlTapped is being called twice.
			//Warning message states that action cannot be nil however.
			[rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
			
			pinView.rightCalloutAccessoryView = rightButton;
			
			// Add a custom image to the left side of the callout.
			UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activesg.png"]];
			pinView.leftCalloutAccessoryView = myCustomImage;
			
		}
		else
		{
			pinView.annotation = annotation;
		}
		
		return pinView;
	}
	else
	{
		return nil;
	}
}

@end
