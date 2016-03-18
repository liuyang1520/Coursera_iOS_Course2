//
//  ViewController.m
//  PhotoPlus
//
//  Created by Yang Liu on 2016-03-16.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.logoutButton.enabled = NO;
    self.updateButton.enabled = NO;
    self.usernameLabel.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender {
    self.logoutButton.enabled = YES;
    self.updateButton.enabled = YES;
    self.loginButton.enabled = NO;
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
}

- (IBAction)logoutButtonTapped:(id)sender {
    NXOAuth2AccountStore *accountInfo = [NXOAuth2AccountStore sharedStore];
    NSArray *instagramAccount = [accountInfo accountsWithAccountType:@"Instagram"];
    for (id account in instagramAccount) {
        [accountInfo removeAccount:account];
    }
    self.loginButton.enabled = YES;
    self.logoutButton.enabled = NO;
    self.updateButton.enabled = NO;
    self.usernameLabel.text = @"Username";
    self.usernameLabel.textColor = [UIColor whiteColor];
}

- (IBAction)updateButtonTapped:(id)sender {
    NSArray *instagramAccount = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    if ([instagramAccount count] == 0) {
        NSLog(@"Error, no Instagram account signed");
        return;
    }
    NXOAuth2Account *account = instagramAccount[0];
    NSString *token = account.accessToken.accessToken;
    NSURL *feedURL = [NSURL URLWithString:[@"https://api.instagram.com/v1/users/self/media/recent/?access_token=" stringByAppendingString:token]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:feedURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Network error, %@", error);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSLog(@"HTTP error, %@", @(httpResponse.statusCode));
            return;
        }
        NSError *parseError;
        id pkg = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!pkg) {
            NSLog(@"JSON parse error, %@", parseError);
            return;
        }
        if (!(pkg[@"data"] && pkg[@"data"][0] && pkg[@"data"][0][@"images"] && pkg[@"data"][0][@"images"][@"low_resolution"])){
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Key not exist error, %@", jsonString);
            return;
        }
        
        NSURL *imageURL = [NSURL URLWithString:pkg[@"data"][0][@"images"][@"low_resolution"][@"url"]];
        [[session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Network error, %@", error);
                return;
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                NSLog(@"HTTP error, %@", @(httpResponse.statusCode));
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:data];
            });
        }] resume];
        
        self.usernameLabel.text = pkg[@"data"][0][@"user"][@"username"];
//        self.usernameLabel.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        self.usernameLabel.textColor = self.view.tintColor;
    }] resume];
}

@end
