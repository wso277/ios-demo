//
//  ShareViewController.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 02/10/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "ShareViewController.h"
#import "NetworkWrapper.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Share";
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendEmail:)];
    
    self.navigationItem.rightBarButtonItem = sendButton;
}

-(void)sendEmail:(id)sender
{
    NSString *url;
    if (self.filter && ![self.filter isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"blissrecruitment://questions?question_filter=%@", self.filter];
    } else {
        url = [NSString stringWithFormat:@"blissrecruitment://questions?question_id=%d", self.questionID];
    }
    
    if (self.textfield.text && ![self.textfield.text isEqualToString:@""]) {
        [[NetworkWrapper sharedInstance] shareURL:url toEmail:self.textfield.text andCompletionHandler:^(NSData * _Nullable result, BOOL success, NSError * _Nullable error) {
            
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Content shared successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [self.textfield resignFirstResponder];
                        }];
                        
                    }];
                    
                    [alert addAction:okAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }];
            } else {
                NSLog(@"[sendEmail]: error sharing content to email");
            }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid email" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
