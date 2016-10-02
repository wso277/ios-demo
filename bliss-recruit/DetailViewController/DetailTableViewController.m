//
//  DetailTableViewController.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "DetailTableViewController.h"
#import "NetworkWrapper.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Question";
    
    if (self.question != nil) {
        self.answers = [self.question objectForKey:@"choices"];
    } else {
        self.answers = [[NSArray alloc] init];
        [self fetchQuestion];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)fetchQuestion
{
    [[NetworkWrapper sharedInstance] fetchQuestionWithID:self.questionID andCompletionHandler:^(NSData * _Nullable result, BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                        options:kNilOptions
                                                                          error:nil];
            
            self.question = [[NSMutableDictionary alloc] initWithDictionary:json];
            
            self.answers = [self.question objectForKey:@"choices"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];

            
        } else {
            NSLog(@"[fetchQuestion]: error fetching question");
        }
    }];
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

    return [self.answers count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DetailHeaderCell *cell = (DetailHeaderCell*)[tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    
    cell.questionLabel.text = [self.question objectForKey:@"question"];
    cell.dateLabel.text = [self.question objectForKey:@"published_at"];
    
    [self fetchImageWithCell:cell];
    
    return cell;
}

-(void)fetchImageWithCell:(DetailHeaderCell*)cell
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.question valueForKey:@"image_url"]]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                cell.imageView.image = [UIImage imageWithData:data];
            //            });
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.questionImage.image = [UIImage imageWithData:data];
            }];
            
        }
        
    }] resume];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailAnswerCell *cell = (DetailAnswerCell*)[tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *choice = [self.answers objectAtIndex:indexPath.row];

    cell.answerLabel.text = [choice objectForKey:@"choice"];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", [choice objectForKey:@"votes"]];
    
    cell.choiceIndex = indexPath.row;
    
    cell.delegate = self;
    
    return cell;
}

-(void)voteButtonPressed:(NSInteger)index
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.answers];
    
    long current = [((NSNumber*)[[self.answers objectAtIndex:index] objectForKey:@"votes"]) longValue];
    long new = current+1;
    
    NSDictionary *newChoice = @{
                                @"choice" : [[self.answers objectAtIndex:index] objectForKey:@"choice"],
                                @"votes"  : [NSNumber numberWithLong:new]
                                };
    
    [arr setObject:newChoice atIndexedSubscript:index];
    
    [self.question setObject:arr forKey:@"choices"];
//    self.answers = arr;
    
//    [self.tableView reloadData];
    
    [[NetworkWrapper sharedInstance] updateQuestion:self.question withCompletionHandler:^(NSData * _Nullable result, BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                                 options:kNilOptions
                                                                   error:nil];
            
            self.question = [[NSMutableDictionary alloc] initWithDictionary:json];
            
            self.answers = [self.question objectForKey:@"choices"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        } else {
            NSLog(@"Error updating question");
        }
    }];
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
