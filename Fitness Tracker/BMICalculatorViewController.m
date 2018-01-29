#import "BMICalculatorViewController.h"
#import "MainMenuViewController.h"

@interface BMICalculatorViewController ()

@end

@implementation BMICalculatorViewController

-(void)dismissKeyboard
{
	[self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.objCalculation = [[BMICalculation alloc]init];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertWithMessage: (NSString *)msg
{
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Input"
																   message:msg
															preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {}];
	
	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)btnCalculate:(id)sender {
	
	[self.view endEditing:YES];
	
	if ([self.txtHeight.text  isEqualToString: @""] || [self.txtWeight.text  isEqualToString: @""])
	{
		[self alertWithMessage:@"Please enter your height or weight."];
	}
	
	else if ([self.txtHeight.text floatValue] < 134.0 || [self.txtHeight.text floatValue] > 241.0)
	{
		[self alertWithMessage:@"Please enter your height between 134 and 241cm."];
		
	}
	
	else if ([self.txtWeight.text floatValue] < 35.0 || [self.txtWeight.text floatValue] > 200.0)
	{
		[self alertWithMessage:@"Please enter your weight between 35 and 200kg."];
	}
	
	else
	{
		
		self.objCalculation.height = [self.txtHeight.text floatValue];
		self.objCalculation.weight = [self.txtWeight.text floatValue];
		
		//Transition start
		CATransition *animation = [CATransition animation];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		animation.type = kCATransitionFade;
		animation.duration = 0.8;
		[self.lblYourBMI.layer addAnimation:animation forKey:@"kCATransitionFade"];
		[self.lblResult.layer addAnimation:animation forKey:@"kCATransitionFade"];
		[self.lblDescription.layer addAnimation:animation forKey:@"kcATransitionFade"];
		
		// This will fade:
		self.lblYourBMI.text = @"Your BMI is...";
		
		self.lblResult.text = [NSString stringWithFormat:@"%0.1f", self.objCalculation.calculateBMI];
		
		//Transition end
		
		
		if (self.lblResult.text.floatValue < 18.4)
		{
			
			self.lblResult.textColor = [UIColor redColor];
			
			self.lblDescription.text = @"You are at risk of developing problems such as nutritional deficiency and osteoporosis.";
			self.lblDescription.selectable = NO;
			
		}
		else if (self.lblResult.text.floatValue < 23.0)
		{
			self.lblResult.textColor = [UIColor greenColor];
			
			self.lblDescription.text = @"Low Risk (healthy range)";
			self.lblDescription.selectable = NO;
			
		}
		else if (self.lblResult.text.floatValue < 27.5)
		{
			self.lblResult.textColor = [UIColor orangeColor];
			
			self.lblDescription.text = @"You are at moderate risk of developing problems such as heart disease, high blood pressure, stroke and diabetes.";
			self.lblDescription.selectable = NO;
			
		}
		else
		{
			self.lblResult.textColor = [UIColor redColor];
			
			self.lblDescription.text = @"You are at high risk of developing problems such as heart disease, high blood pressure, stroke and diabetes.";
			self.lblDescription.selectable = NO;
			
		}
	}
}

-(void)returntoMainMenu {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
	MainMenuViewController *vc = navigationController.viewControllers[0];
	vc.username = self.username;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentViewController:navigationController animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack:(id)sender {
	
	[self returntoMainMenu];
}
@end
