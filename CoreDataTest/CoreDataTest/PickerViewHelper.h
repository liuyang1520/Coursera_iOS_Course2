//
//  PickerViewHelper.h
//  CoreDataTest
//
//  Created by Yang Liu on 2016-03-24.
//  Copyright © 2016 Macula Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewHelper : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)setArray:(NSArray *)inputArray;
- (void)addElement:(NSObject *)inputElement;
- (NSObject *)getElementOfIndex:(NSInteger)index;

@end
