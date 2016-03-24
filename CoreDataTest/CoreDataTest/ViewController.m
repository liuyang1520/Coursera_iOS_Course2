//
//  ViewController.m
//  CoreDataTest
//
//  Created by Yang Liu on 2016-03-23.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ChoreMO.h"
#import "PersonMO.h"
#import "ChoreLogMO.h"
#import "PickerViewHelper.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *choreField;
@property (weak, nonatomic) IBOutlet UITextField *personField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *chorePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *personPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) PickerViewHelper *chorePickerHelper;
@property (nonatomic) PickerViewHelper *personPickerHelper;

- (void)updateLog;
- (NSArray *)fetchArrayFromCoreDataWithEntityName:(NSString *)entityName;
- (void)updatePickerHelper;
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
//    [self.datePicker setLocale:[NSLocale systemLocale]];
    
    self.chorePickerHelper = [PickerViewHelper new];
    [self.chorePicker setDelegate:self.chorePickerHelper];
    [self.chorePicker setDataSource:self.chorePickerHelper];
    
    self.personPickerHelper = [PickerViewHelper new];
    [self.personPicker setDelegate:self.personPickerHelper];
    [self.personPicker setDataSource:self.personPickerHelper];
    
    [self updatePickerHelper];
    [self updateLog];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)addChoreTapped:(id)sender {
    ChoreMO *choreMo = [[self appDelegate] createChoreMO];
    choreMo.choreName = self.choreField.text;
    self.choreField.text = nil;
    [self.appDelegate saveContext];
    [self updatePickerHelper];
}

- (IBAction)addPersonTapped:(id)sender {
    PersonMO *personMo = [[self appDelegate] createPersonMO];
    personMo.personName = self.personField.text;
    self.personField.text = nil;
    [self.appDelegate saveContext];
    [self updatePickerHelper];
}

- (IBAction)addLogTapped:(id)sender {
    ChoreMO *chore = (ChoreMO *)[self.chorePickerHelper getElementOfIndex:[self.chorePicker selectedRowInComponent:0]];
    PersonMO *person = (PersonMO *)[self.personPickerHelper getElementOfIndex:[self.personPicker selectedRowInComponent:0]];
    ChoreLogMO *choreLog = [self.appDelegate createChoreLogMO];
    choreLog.choreDone = chore;
    choreLog.personDid = person;
    choreLog.time = [self.datePicker date];
    [self.appDelegate saveContext];
    [self updateLog];
}

- (IBAction)deleteTapped:(id)sender {
    NSArray *result = [self fetchArrayFromCoreDataWithEntityName:@"Chore"];
    if (result) {
        for (ChoreMO *i in result)
            [self.appDelegate.managedObjectContext deleteObject:i];
    }
    result = [self fetchArrayFromCoreDataWithEntityName:@"Person"];
    if (result) {
        for (PersonMO *i in result)
            [self.appDelegate.managedObjectContext deleteObject:i];
    }
    result = [self fetchArrayFromCoreDataWithEntityName:@"ChoreLog"];
    if (result) {
        for (ChoreLogMO *i in result)
            [self.appDelegate.managedObjectContext deleteObject:i];
    }
    [self updatePickerHelper];
    [self updateLog];
    [self.appDelegate saveContext];
}

- (void)updateLog {
    NSArray *result = [self fetchArrayFromCoreDataWithEntityName:@"ChoreLog"];
    NSMutableString *buffer = [NSMutableString stringWithString:@""];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMM d@h:mm a"];
    if (result)
        for (ChoreLogMO *i in result)
            [buffer appendFormat:@"\n%@ done by %@ at %@", i.choreDone, i.personDid, [dateFormatter stringFromDate:i.time], nil];
    self.logTextView.text = buffer;
}

- (void)updatePickerHelper {
    NSArray *result = [self fetchArrayFromCoreDataWithEntityName:@"Chore"];
    NSMutableArray *choreData = [NSMutableArray arrayWithArray:@[]];
    if (result)
        for (ChoreMO *i in result)
            [choreData addObject:i];
    [self.chorePickerHelper setArray:choreData];
    [self.chorePicker reloadAllComponents];
    
    result = [self fetchArrayFromCoreDataWithEntityName:@"Person"];
    NSMutableArray *personData = [NSMutableArray arrayWithArray:@[]];
    if (result)
        for (PersonMO *i in result)
            [personData addObject:i];
    [self.personPickerHelper setArray:personData];
    [self.personPicker reloadAllComponents];
}

- (NSArray *)fetchArrayFromCoreDataWithEntityName:(NSString *)entityName {
    NSError *fetchError = nil;
    NSArray *result = [self.appDelegate.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:entityName] error:&fetchError];
    if (!result)
        NSLog(@"Fetch error, %@, %@", [fetchError localizedDescription], [fetchError userInfo]);
    return result;
}

@end
