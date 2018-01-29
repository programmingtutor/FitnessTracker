#import "WorkoutHistoryTableViewController.h"
#import "FitnessTrackerDB.h"
#import "WorkoutHistoryTableViewCell.h"

@interface WorkoutHistoryTableViewController ()
@property (nonatomic, strong) FitnessTrackerDB *dbManager;
@property (nonatomic, strong) NSArray *arrUserInfo;
@end

@implementation WorkoutHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
	self.dbManager = [[FitnessTrackerDB alloc] initWithDatabaseFilename:@"fitnesstrackerdb.sql"];
	
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM Workouts WHERE username = '%@'", self.username];
	
	// Get the results.
	if (self.arrUserInfo != nil) {
		self.arrUserInfo = nil;
	}
	self.arrUserInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
	
	[self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 79.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return self.arrUserInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkoutHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attemptCell" forIndexPath:indexPath];
    
    // Configure the cell...
	NSArray *selectedUser = [self.arrUserInfo objectAtIndex:indexPath.row];
	
	NSInteger workouttype = [self.dbManager.arrColumnNames indexOfObject:@"workout_type"];
	NSInteger attemptDate = [self.dbManager.arrColumnNames indexOfObject:@"attemptDate"];
	NSInteger result = [self.dbManager.arrColumnNames indexOfObject:@"result"];
	NSInteger timeTaken = [self.dbManager.arrColumnNames indexOfObject:@"timeTaken"];
	
	cell.lblWorkoutType.text = [selectedUser objectAtIndex:workouttype];
	cell.lblResult.text = [NSString stringWithFormat:@"Result: %@", [selectedUser objectAtIndex:result]];
	cell.lblTimeTaken.text = [NSString stringWithFormat:@"Time: %@", [selectedUser objectAtIndex:timeTaken]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *unformatted = [dateFormatter dateFromString:[selectedUser objectAtIndex:attemptDate]];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	cell.lblAttemptDate.text = [dateFormatter stringFromDate:unformatted];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
