#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	
	CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

