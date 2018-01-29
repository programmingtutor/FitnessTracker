#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GymDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;


@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, copy) NSString *mySubtitle;
@property (nonatomic, assign) CLLocationCoordinate2D pointCoordinate;

- (IBAction)btnGetDirections:(id)sender;
@end
