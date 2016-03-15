//
//  ViewController.m
//  TwitterShare
//
//  Created by Yang Liu on 2016-03-14.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *TwitterTextView;

- (void)configTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showShareAction:(id)sender {
    if ([self.TwitterTextView isFirstResponder])
        [self.TwitterTextView resignFirstResponder];
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Twitter" message:@"Send tweet" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:
                                 ^void(UIAlertAction *action){
                                     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                                         SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                         if ([self.TwitterTextView.text length] <= 140)
                                             [twitterViewController setInitialText:self.TwitterTextView.text];
                                         else
                                             [twitterViewController setInitialText:[self.TwitterTextView.text substringToIndex:140]];
                                         [self presentViewController:twitterViewController animated:YES completion:nil];
                                     }
                                     else{
                                         UIAlertController *warn = [UIAlertController alertControllerWithTitle:@"Twitter" message:@"Please sign in" preferredStyle:UIAlertControllerStyleAlert];
                                         [warn addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                                         [self presentViewController:warn animated:YES completion:nil];
                                     }
                                 }];
    
    [actionController addAction:sendAction];
    [actionController addAction:cancelAction];
    [self presentViewController:actionController animated:YES completion:nil];
}

//- (void)displayAlertMessage:(NSString *) message{
//    
//}

- (void)configTextView{
    self.TwitterTextView.layer.backgroundColor = [UIColor colorWithRed:1 green:0.8 blue:1 alpha:0.2].CGColor;
    self.TwitterTextView.layer.borderColor = [UIColor colorWithRed:0.4 green:1 blue:0.2 alpha:1].CGColor;
    self.TwitterTextView.layer.borderWidth = 2.0;
}


@end
