//
//  ListTableViewController.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UITableViewController <UISearchBarDelegate>

@property(nonatomic) int currentOffset, limit;
@property(nonatomic, strong)    NSString* currentFilter;
@property(nonatomic, strong)    NSArray* questions;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
