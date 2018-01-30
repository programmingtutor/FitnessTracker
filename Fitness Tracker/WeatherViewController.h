#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblForecast;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;

@property (weak, nonatomic) IBOutlet UILabel *lblTempLow;
@property (weak, nonatomic) IBOutlet UILabel *lblTempLowDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblTempHighDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblTempHigh;


@property (weak, nonatomic) IBOutlet UILabel *lblRelativeHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblRHLow;
@property (weak, nonatomic) IBOutlet UILabel *lblRHHigh;
@property (weak, nonatomic) IBOutlet UILabel *lblRHLowPercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblRHHighPercentage;


@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeedLowKM;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeedHighKM;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeedDirection;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeedLow;
@property (weak, nonatomic) IBOutlet UILabel *lblWindSpeedHigh;

@end
