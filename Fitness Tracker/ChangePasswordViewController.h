#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)confirmBtn:(id)sender;
@property (nonatomic, copy) NSString *username;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@end
