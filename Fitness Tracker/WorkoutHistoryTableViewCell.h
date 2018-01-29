#import <UIKit/UIKit.h>

@interface WorkoutHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblWorkoutType;
@property (weak, nonatomic) IBOutlet UILabel *lblAttemptDate;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTaken;

@end
