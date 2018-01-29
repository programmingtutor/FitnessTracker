#import "BMICalculation.h"

@implementation BMICalculation

-(id) init {
	self = [super init];
	if (self) {
		self.height = 0;
		self.weight = 0;
	}
	
	return self;
}

-(float) calculateBMI {
	float result;
	float heightInCms = self.height * 0.01;
	return result = (self.weight / (heightInCms * heightInCms));
}

@end
