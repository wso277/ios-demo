//
//  ViewController.m
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import "ViewController.h"
#import "NetworkWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performHealthCheckRequest];
}

-(void)performHealthCheckRequest
{
    [[NetworkWrapper sharedInstance] checkHealthStatusWithCompletionHandler:^(NSData * _Nullable result, BOOL success, NSError * _Nullable error) {
       
        NSLog(@"%@", [NSNumber numberWithBool:success]);
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
                                                             options:kNilOptions
                                                               error:nil];
        
        NSLog(@"%@", json);
        
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *navController = [sb instantiateViewControllerWithIdentifier:@"ListNavigationController"];
            
            [self presentViewController:navController animated:YES completion:nil];
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self.loadingSpinner stopAnimating];
//                [self.retryButton setHidden:NO];
//            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.loadingSpinner stopAnimating];
                [self.retryButton setHidden:NO];
            }];
        }
    }];
}

- (IBAction)retryButtonPressed:(id)sender {
    
    [self.retryButton setHidden:YES];
    [self.loadingSpinner startAnimating];
    [self performHealthCheckRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
