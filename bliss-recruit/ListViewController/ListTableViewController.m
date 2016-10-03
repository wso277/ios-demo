//
//  ListTableViewController.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "ListTableViewController.h"
#import "NetworkWrapper.h"
#import "ListTableViewCell.h"
#import "DetailTableViewController.h"
#import "ShareViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

-(NSArray*)questions {
    if (_questions == nil) {
        _questions = [[NSMutableArray alloc] init];
    }
    
    return _questions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Questions";
    
    self.limit = 10;
    self.currentOffset = 0;
    
    self.searchBar.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self
                            action:@selector(reloadQuestions)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.refreshControl = refreshControl;
    
    [self performListRequest];
}

-(void)reloadQuestions
{
    self.questions = @[];
    self.currentOffset = 0;
    [self performListRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currentFilter) {
        if ([self.currentFilter isEqualToString:@""]) {
            [self.searchBar becomeFirstResponder];
        } else {
            NSLog(@"%@", self.currentFilter);
            self.searchBar.text = self.currentFilter;
            //TODO Search
        }
        
        [self.searchBar setShowsCancelButton:YES];
    } else {
        [self.searchBar setShowsCancelButton:NO];
    }
}

-(void)performListRequest
{
    [[NetworkWrapper sharedInstance] listQuestionsWithLimit:self.limit withOffset:self.currentOffset andFilter:self.currentFilter withCompletionHandler:^(NSData * _Nullable result, BOOL success, NSError * _Nullable error) {
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:kNilOptions
                                                               error:nil];
        
        if (success) {
            self.questions = [self.questions arrayByAddingObjectsFromArray:(NSArray*)json];
            self.currentOffset += self.limit;
            
            int possibleCells = self.tableView.frame.size.height / 44;
            if (possibleCells > self.currentOffset) {
                [self performListRequest];
            }
            
        } else {
            NSLog(@"[performListRequest]: Error fetching questions");
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
            if (self.currentFilter && ![self.currentFilter isEqualToString:@""]) {
                [self.shareButton setEnabled:YES];
            } else {
                [self.shareButton setEnabled:NO];
            }
            
        }];
    }];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
    self.searchBar.text = @"";
    self.currentFilter = nil;
    [self.searchBar resignFirstResponder];
    self.currentOffset = 0;
    self.questions = @[];
    [self.tableView reloadData];
    [self performListRequest];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.currentFilter = self.searchBar.text;
    [self.searchBar resignFirstResponder];
    self.currentOffset = 0;
    self.questions = @[];
    [self.tableView reloadData];
    [self performListRequest];
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
    
    return [self.questions count];
}

-(void)fetchImageWithCell:(ListTableViewCell*)cell andQuestion:(NSDictionary*)question
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[question valueForKey:@"thumb_url"]]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (data && [cell.question valueForKey:@"id"] == [question valueForKey:@"id"]) {
                
                //            dispatch_async(dispatch_get_main_queue(), ^{
                //                cell.imageView.image = [UIImage imageWithData:data];
                //            });
                
                cell.questionThumb.image = [[UIImage alloc] initWithData:data];
                
            }
        }];
    }] resume];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ListTableViewCell *cell = (ListTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"listCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ListTableViewCell alloc] init];
    }
    
    //    ListTableViewCell *cell = (ListTableViewCell*)([[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCellIdentifier"]);
    
    // Configure the cell...
    
    if (indexPath.row < [self.questions count]) {
        NSDictionary *question = [self.questions objectAtIndex:indexPath.row];
        
        if (question != nil) {
            cell.questionLabel.text = [question valueForKey:@"question"];
            
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.zzzZ"];
            
            NSDate *date = [dateformate dateFromString:[question valueForKey:@"published_at"]];
            
            [dateformate setDateFormat:@"dd/MM/yyyy HH:mm"];
            
            cell.dateLabel.text = [dateformate stringFromDate:date];
            //        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[question valueForKey:@"thumb_url"]]];
            //        cell.imageView.image = [UIImage imageWithData:imageData];
            cell.question = question;
            //cell.imageView.image = [UIImage imageNamed:@"question-block"];
            [self fetchImageWithCell:cell andQuestion:question];
            
        }
    }
    
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self performListRequest];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shareSegue"]) {
        
        ShareViewController *vc = (ShareViewController*)[segue destinationViewController];
        vc.filter = self.currentFilter;
        
    } else {
        DetailTableViewController *vc = [segue destinationViewController];
        
        NSDictionary *question = ((ListTableViewCell*)sender).question;
        
        vc.question = [[NSMutableDictionary alloc] initWithDictionary:question];
        vc.questionID = [question objectForKey:@"id"];
    }
    
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
