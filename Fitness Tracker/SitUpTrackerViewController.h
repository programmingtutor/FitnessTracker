#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SitUpTrackerViewController : UIViewController {
	
	CMMotionManager *motionManager;

}
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIButton *btnStartOutlet;
- (IBAction)btnStart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEndWorkoutOutlet;
- (IBAction)btnEndWorkout:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (nonatomic, copy) NSString *username;
- (IBAction)btnBack:(id)sender;

@end
