//
//  DetailTableViewController.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHeaderCell.h"
#import "DetailAnswerCell.h"

@interface DetailTableViewController : UITableViewController <AnswerCellDelegate>

@property(nonatomic, strong)    NSMutableDictionary *question;
@property(nonatomic, strong)    NSString *questionID;
@property(nonatomic, strong)    NSArray *answers;

@end
