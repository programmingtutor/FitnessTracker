#import <UIKit/UIKit.h>

@interface PushUpTrackerViewController : UIViewController {
	
	UIDevice *device;
}
@property (nonatomic, copy) NSString *username;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
- (IBAction)btnStart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnStartOutlet;
@property (weak, nonatomic) IBOutlet UIButton *btnEndWorkoutOutlet;
- (IBAction)btnEndWorkout:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
