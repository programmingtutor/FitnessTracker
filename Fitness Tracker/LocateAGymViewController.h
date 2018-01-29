#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocateAGymViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	
	CLLocationManager *locationManager;
	__block BOOL prompted; //If location services prompt has not shown
}
@property (weak, nonatomic) IBOutlet MKMapView *gymMapView;
@property (nonatomic, copy) NSString *username;
- (IBAction)btnMapType:(id)sender;

- (IBAction)btnBack:(id)sender;

@end
