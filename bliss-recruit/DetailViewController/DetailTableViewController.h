//
//  DetailTableViewController.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController

@property(nonatomic, strong)    NSDictionary *question;
@property(nonatomic, strong)    NSString *questionID;
@property(nonatomic, strong)    NSArray *answers;

@end
