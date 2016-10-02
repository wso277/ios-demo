//
//  DetailAnswerCell.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnswerCellDelegate <NSObject>

-(void)voteButtonPressed:(NSInteger)index;

@end

@interface DetailAnswerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;

@property (nonatomic) NSInteger choiceIndex;

@property id<AnswerCellDelegate> delegate;

@end
