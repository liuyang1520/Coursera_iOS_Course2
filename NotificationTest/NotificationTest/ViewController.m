//
//  ViewController.m
//  NotificationTest
//
//  Created by Yang Liu on 2016-03-18.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)askNotiPermission;
- (void)scheduleNotiWithTime:(int)countDownSeconds;
@end

@implementation ViewController

- (void)askNotiPermission {
    UIMutableUserNotificationAction *confirmAction = [[UIMutableUserNotificationAction alloc] init];
    confirmAction.identifier = @"CONFIRM_ACTION";
    confirmAction.title = @"Confirm";
    confirmAction.activationMode = UIUserNotificationActivationModeForeground;
    confirmAction.destructive = NO;
    confirmAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *cancelAction = [[UIMutableUserNotificationAction alloc] init];
    cancelAction.identifier = @"CANCEL_ACTION";
    cancelAction.title = @"Cancel";
    cancelAction.activationMode = UIUserNotificationActivationModeBackground;
    cancelAction.destructive = YES;
    cancelAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *notiCategory = [[UIMutableUserNotificationCategory alloc] init];
    notiCategory.identifier = @"NOTI_CATEGORY";
    [notiCategory setActions:@[confirmAction, cancelAction] forContext:UIUserNotificationActionContextDefault];
    
    UIUserNotificationType notiTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notiTypes categories:[NSSet setWithObjects:notiCategory, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)scheduleNotiWithTime:(int)countDownSeconds {
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.fireDate = [[NSDate date] dateByAddingTimeInterval:countDownSeconds];
    localNoti.timeZone = nil;
    localNoti.alertTitle = @"Alert";
    localNoti.alertBody = @"Alert body";
    localNoti.alertAction = @"OK";
    localNoti.applicationIconBadgeNumber = 1;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    localNoti.category = @"NOTI_CATEGORY";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scheduleButtonTapped:(id)sender {
    [self askNotiPermission];
    [self scheduleNotiWithTime:5];
}

@end
