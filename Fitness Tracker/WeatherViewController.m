#import "WeatherViewController.h"

@interface WeatherViewController ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSDictionary *weatherInfo;
@property (nonatomic, copy) NSDictionary *relativeHumidity;
@property (nonatomic, copy) NSDictionary *temperature;
@property (nonatomic, copy) NSDictionary *windSpeed;
@property (nonatomic, copy) NSDictionary *direction;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	NSURLSessionConfiguration *config =
	[NSURLSessionConfiguration defaultSessionConfiguration];
	_session = [NSURLSession sessionWithConfiguration:config
											 delegate:nil
										delegateQueue:nil];
	
	[self fetchFeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchFeed {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	
	NSDate *currentDate = [NSDate date];
	
	NSString *requestString = [NSString stringWithFormat:@"https://api.data.gov.sg/v1/environment/24-hour-weather-forecast?date=%@", [dateFormatter stringFromDate:currentDate]];
	
	NSURL *url = [NSURL URLWithString:requestString];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"GET"];
	[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[req addValue:@"rHmPFQIsCt2ruu9jfRJPqhFgslZRV07b" forHTTPHeaderField:@"api-key"];
	
	NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		NSArray *items = jsonObject[@"items"];
		NSDictionary *itemsDictionary = items[0];
		self.weatherInfo = itemsDictionary[@"general"];
		self.relativeHumidity = self.weatherInfo[@"relative_humidity"];
		self.temperature = self.weatherInfo[@"temperature"];
		NSDictionary *wind = self.weatherInfo[@"wind"];
		self.windSpeed = wind[@"speed"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			self.lblForecast.text = self.weatherInfo[@"forecast"];
			self.lblTempLowDegree.text = [NSString stringWithFormat:@"%@°C", self.temperature[@"low"]];
			self.lblTempHighDegree.text = [NSString stringWithFormat:@"%@°C", self.temperature[@"high"]];
			self.lblRHLowPercentage.text = [NSString stringWithFormat:@"%@%%", self.relativeHumidity[@"low"]];
			self.lblRHHighPercentage.text = [NSString stringWithFormat:@"%@%%", self.relativeHumidity[@"high"]];
			self.lblWindSpeedDirection.text = [NSString stringWithFormat:@"%@", wind[@"direction"]];
			self.lblWindSpeedLowKM.text = [NSString stringWithFormat:@"%@", self.windSpeed[@"low"]];
			self.lblWindSpeedHighKM.text = [NSString stringWithFormat:@"%@", self.windSpeed[@"high"]];

			
			
			[UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				
				self.lblForecast.alpha = 1.0;
				
			} completion:^(BOOL finished) {
				
				[UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
					
					self.lblTemperature.alpha = 1.0;
					self.lblTempLow.alpha = 1.0;
					self.lblTempHigh.alpha = 1.0;
					self.lblTempLowDegree.alpha = 1.0;
					self.lblTempHighDegree.alpha = 1.0;
					self.lblRelativeHumidity.alpha = 1.0;
					self.lblRHLow.alpha = 1.0;
					self.lblRHHigh.alpha = 1.0;
					self.lblRHLowPercentage.alpha = 1.0;
					self.lblRHHighPercentage.alpha = 1.0;
					self.lblWindSpeed.alpha = 1.0;
					self.lblWindSpeedLow.alpha = 1.0;
					self.lblWindSpeedHigh.alpha = 1.0;
					self.lblWindSpeedLowKM.alpha = 1.0;
					self.lblWindSpeedHighKM.alpha = 1.0;
					self.lblWindSpeedDirection.alpha = 1.0;
					
				} completion:nil];
			}];
			
		});
		
	}];

	[dataTask resume];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
