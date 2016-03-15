//
//  ViewController.m
//  socialShare
//
//  Created by Yang Liu on 2016-03-15.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *twitterTextView;
@property (weak, nonatomic) IBOutlet UITextView *facebookTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreTextView;
- (void)configureTextView:(UITextView *)textView;
- (void)displayWarnMessage:(NSString *)warnMessage;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextView:self.twitterTextView];
    [self configureTextView:self.facebookTextView];
    [self configureTextView:self.moreTextView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)configureTextView:(UITextView *)textView{
    UIColor *textViewBGColor = [UIColor alloc];
    if (textView == self.twitterTextView){
        textViewBGColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.8 alpha:0.1];
    }
    else if (textView == self.facebookTextView){
        textViewBGColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.8 alpha:0.1];
    }
    else{
        textViewBGColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.2 alpha:0.1];
    }
    textView.layer.backgroundColor = [textViewBGColor CGColor];
    textView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    textView.layer.borderWidth = 1.3;
}

- (void)displayWarnMessage:(NSString *)warnMessage{
    UIAlertController *warn = [UIAlertController alertControllerWithTitle:@"Warning" message:warnMessage preferredStyle:UIAlertControllerStyleAlert];
    [warn addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:warn animated:YES completion:nil];
}

- (IBAction)twitterButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if ([self.twitterTextView.text length] <= 140)
            [twitterViewController setInitialText:self.twitterTextView.text];
        else
            [twitterViewController setInitialText:[self.twitterTextView.text substringToIndex:140]];
        [self presentViewController:twitterViewController animated:YES completion:nil];
    }
    else{
        [self displayWarnMessage:@"Please sign in to Twitter"];
    }
}

- (IBAction)facebookButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *facebookViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookViewController setInitialText:self.facebookTextView.text];
        [self presentViewController:facebookViewController animated:YES completion:nil];
    }
    else{
        [self displayWarnMessage:@"Please sign in to Facebook"];
    }
}

- (IBAction)moreButtonTapped:(id)sender {
    UIActivityViewController *moreViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.moreTextView.text] applicationActivities:nil];
    [self presentViewController:moreViewController animated:YES completion:nil];
}

- (IBAction)naButtonTapped:(id)sender {
    [self displayWarnMessage:@"No action performed"];
}

@end
