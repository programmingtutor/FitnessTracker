#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController
@property(nonatomic, copy) NSString *username;
-(void)setTouchIDStateOn;
-(void)setTouchIDStateOff;
-(void)enableTouchID;
-(void)disableTouchID;

//@property (weak, nonatomic) IBOutlet UISwitch *touchIDOutlet;

@end
