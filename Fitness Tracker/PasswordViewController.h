#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController <UITextFieldDelegate>
- (IBAction)useTouchIDBtn:(UIButton *)sender;
@property (nonatomic, strong) NSString *username;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome;

@end
