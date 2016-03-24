//
//  PickerViewHelper.m
//  CoreDataTest
//
//  Created by Yang Liu on 2016-03-24.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import "PickerViewHelper.h"

@interface PickerViewHelper ()

@property (nonatomic) NSMutableArray *pickerData;

@end

@implementation PickerViewHelper

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init {
    if ([super init] == nil)
        return nil;
    self.pickerData = [NSMutableArray arrayWithArray:@[]];
    return self;
}

- (void)setArray:(NSArray *)inputArray {
    self.pickerData = [NSMutableArray arrayWithArray:inputArray];
}

- (void)addElement:(NSObject *)inputElement {
    [self.pickerData addObject:inputElement];
}

- (NSObject *)getElementOfIndex:(NSInteger)index {
    return [self.pickerData objectAtIndex:index];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerData count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.pickerData objectAtIndex:row] description];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
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
