//
//  ShareViewController.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>

@interface ShareViewController : UIViewController <CNContactPickerDelegate>

@property(nonatomic, strong)    NSString *filter;
@property(nonatomic)    int questionID;
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (strong, nonatomic) IBOutlet UIButton *pickButton;

@property(strong, nonatomic)    UIBarButtonItem *sendButton;

@end
