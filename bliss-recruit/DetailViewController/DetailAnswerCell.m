//
//  DetailAnswerCell.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "DetailAnswerCell.h"

@implementation DetailAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)voteButtonPressed:(id)sender {
    
    if (self.delegate != nil)
        [self.delegate voteButtonPressed:self.choiceIndex andSpinner:self.voteSpinner];
}
@end
