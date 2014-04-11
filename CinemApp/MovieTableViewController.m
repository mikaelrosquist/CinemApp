//
//  MovieTableViewController.m
//  CinemApp
//
//  Created by mikael on 08/04/14.
//  Copyright (c) 2014 Rosquist Östlund. All rights reserved.
//

#import "MovieTableViewController.h"

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController

@synthesize personTable, personArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(UITableViewStyle)style :(NSArray *)array{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        personArray = array;
        NSLog(@"PersonArray: %@", personArray);
        [self.tableView setFrame:CGRectMake(10, 220, 300, 300)];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.Delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)makeTableView:(UITableView *)table{
    table = self.tableView;
    NSLog(@"maketableview");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [personArray count];
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"PERSONARRAY: %@", personArray);
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *name = [[personArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    [cell.textLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Regular" size: 14.0]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", name];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: cell.textLabel.attributedText];
    [text addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Light" size: 13.0] range: NSMakeRange([name length]+1, 6)];
    [cell.textLabel setAttributedText: text];

    
    //cell.textLabel.text = [personArray objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
