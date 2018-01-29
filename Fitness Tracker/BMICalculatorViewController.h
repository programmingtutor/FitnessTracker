#import <UIKit/UIKit.h>
#import "BMICalculation.h"

@interface BMICalculatorViewController : UIViewController
- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtHeight;

@property (weak, nonatomic) IBOutlet UITextField *txtWeight;

- (IBAction)btnCalculate:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblResult;


@property (strong, nonatomic) BMICalculation *objCalculation;

@property (weak, nonatomic) IBOutlet UILabel *lblYourBMI;

@property (weak, nonatomic) IBOutlet UITextView *lblDescription;

@property (nonatomic, copy) NSString *username;

@end
