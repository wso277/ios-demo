//
//  DetailHeaderCell.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *questionImage;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@end
