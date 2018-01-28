#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)btnSignUp:(id)sender;

@end
