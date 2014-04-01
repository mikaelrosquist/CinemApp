#import <UIKit/UIKit.h>
#import "Movie.h"
#import "RateViewController.h"

@interface RateSearchViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSDictionary * json;
@property (nonatomic, strong) NSMutableArray * resultArray;
@property (nonatomic, strong) NSMutableArray* movieArray;
@property (strong, nonatomic) UITableView *mainTableView;


 @property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;


#pragma mark - Methods
- (void) retrieveData;

@end
