#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate, title, subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)pTitle andSubtitle: (NSString *)pSubtitle
{
	self = [super init];
	
	if (self)
	{
		coordinate = coord;
		title = pTitle;
		subtitle = pSubtitle;
		
	}
	
	return self;
}

+ (NSMutableArray *)GetAllAnnotations
{
	
	//This method puts all ActiveSG Gyms to pin annotations
	NSMutableArray *AllAnnotations = [[NSMutableArray alloc]init];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3553, 103.8508) title:@"Bishan ActiveSG Gym" andSubtitle:@"5 Bishan Street 14"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3307, 103.8515) title:@"Toa Payoh ActiveSG Gym" andSubtitle:@"301 Lorong 6 Toa Payoh"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3259, 103.9383) title:@"Bedok ActiveSG Gym" andSubtitle:@"5 Bedok North Street 2"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3596, 103.7500) title:@"Bukit Gombak ActiveSG Gym" andSubtitle:@"810 Bukit Batok West Avenue 5"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3910, 103.7481) title:@"Choa Chu Kang ActiveSG Gym" andSubtitle:@"1 Choa Chu Kang Street 53"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3110, 103.7628) title:@"Clementi ActiveSG Gym" andSubtitle:@"518 Clementi Avenue 3"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.2893, 103.8207) title:@"Delta ActiveSG Gym" andSubtitle:@"900 Tiong Bahru Road"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.2872, 103.8126) title:@"Enabling Village ActiveSG Gym" andSubtitle:@"20, Lengkok Bahru, #01-05, Enabling Village"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3709, 103.8880) title:@"Hougang ActiveSG Gym" andSubtitle:@"93 Hougang Avenue 4"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3469, 103.7292) title:@"Jurong East ActiveSG Gym" andSubtitle:@"21 Jurong East Street 31"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3386, 103.6941) title:@"Jurong West ActiveSG Gym" andSubtitle:@"20 Jurong West Street 93"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3742, 103.9497) title:@"Pasir Ris ActiveSG Gym" andSubtitle:@"120 Pasir Ris Central"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3968, 103.8867) title:@"Sengkang ActiveSG Gym" andSubtitle:@"57 Anchorvale Road"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3547, 103.9399) title:@"Tampines ActiveSG Gym" andSubtitle:@"505, Tampines Swimming Complex, Tampines Avenue 5"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.4350, 103.7804) title:@"Woodlands ActiveSG Gym" andSubtitle:@"1 Woodlands Street 13"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.3822, 103.8459) title:@"Yio Chu Kang ActiveSG Gym" andSubtitle:@"200 Ang Mo Kio Avenue 9"]];
	
	[AllAnnotations addObject:[[CustomAnnotation alloc]initWithLocation:CLLocationCoordinate2DMake(1.4121, 103.8311) title:@"Yishun ActiveSG Gym" andSubtitle:@"101 Yishun Avenue 1"]];
	
	
	
	return AllAnnotations;
	
}

@end
