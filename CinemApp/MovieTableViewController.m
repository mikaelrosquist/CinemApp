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

@synthesize personTable, personArray, movieTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         //init code
    }
    return self;
}

- (id)initWithData:(NSMutableArray *)castArray{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        
        [self.view setFrame:CGRectMake(10, 275, 300, 400)];
        
        personArray = castArray;
        NSLog(@"TableView PersonArray: %@", personArray);
        
        //Max 7 skådisar visas
        int tableLength;
        if([personArray count] > 7)
            tableLength = 7;
        else
            tableLength = [personArray count];
        
        personTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, tableLength*75)];
        personTable.dataSource = self;
        personTable.delegate = self;
		personTable.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        personTable.separatorColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        personTable.scrollEnabled = NO;
		
        [self.view addSubview:personTable];
        movieTableView = self.view;
    }
    return self;
}

- (id)viewDidLoad:(NSMutableArray *)castArray{
    
    [super viewDidLoad];
    if (self) {
        //NSLog(@"%f", [personTable contentSize].height);
        //[personTable setFrame:CGRectMake(0, 0, 300, [personTable contentSize].height)];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    NSLog(@"numberOfSections");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [personArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"PERSONARRAY: %@", personArray);
    NSLog(@"cellForRowAtIndexPath");
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        NSLog(@"ny cell");
    }
    if(personArray != 0){
    
        NSString *name = [[personArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        NSString *movieChar = [[personArray objectAtIndex:indexPath.row] objectForKey:@"character"];
        
        NSLog(@"NAMN: %@",name);
        NSLog(@"KARAKTÄR: %@",movieChar);
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 240, 30)];
        nameLabel.text = name;
        UILabel *charLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 240, 30)];
        charLabel.text = movieChar;
        charLabel.textColor = [UIColor lightGrayColor];
        
        //profile pics
        
        NSString *imagePath = [[personArray objectAtIndex:indexPath.row] objectForKey:@"profile_path"];
        NSString *imageString = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w90%@", imagePath];
        NSURL *imageURL = [NSURL URLWithString:imageString];
        NSData *personImage = [NSData dataWithContentsOfURL:imageURL];
        UIImageView *personView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 47, 70)];
        if ([imagePath isEqual: [NSNull null]])
            personView.image = [UIImage imageNamed:@"actor-placeholder"];
        else
            personView.image = [UIImage imageWithData:personImage];
        
        NSLog(@"BILD: %@",imagePath);
        
        [cell.contentView addSubview:personView];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:charLabel];
        
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.94 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUserInteractionEnabled:NO];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tv cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}


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
