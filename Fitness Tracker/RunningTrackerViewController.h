#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RunningTrackerViewController : UIViewController <CLLocationManagerDelegate> {
	
	CLLocationManager *locationManager;
}

@property (nonatomic, copy) NSString *username;
@property (weak, nonatomic) IBOutlet UIButton *btnStartOutlet;
- (IBAction)btnStart:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEndWorkoutOutlet;
- (IBAction)btnEndWorkout:(id)sender;

@end
