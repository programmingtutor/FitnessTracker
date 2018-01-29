#import <UIKit/UIKit.h>

@interface UserDetailsViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, copy) NSString *username;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (strong, nonatomic) IBOutlet UIToolbar *txtToolbar;
@property (strong, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;
- (IBAction)btnUpdate:(id)sender;
- (IBAction)dobChanged:(id)sender;
- (IBAction)btnDone:(id)sender;

@end
