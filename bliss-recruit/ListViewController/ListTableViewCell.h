//
//  ListTableViewCell.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (nonatomic, strong)   NSDictionary* question;
@property (strong, nonatomic) IBOutlet UIImageView *questionThumb;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
