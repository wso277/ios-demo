//
//  AppDelegate.h
//  bliss-recruit
//
//  Created by Wilson Oliveira on 30/09/16.
//  Copyright © 2016 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

