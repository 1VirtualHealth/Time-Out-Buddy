//
//  TOAgePickerView.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOAgePickerView.h"

@interface TOAgePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *agePicker;
@property (strong, nonatomic) NSArray *ages;
@end

@implementation TOAgePickerView

@synthesize onPickerDone = _onPickerDone;
@synthesize agePicker = _agePicker;
@synthesize ages = _ages;
@synthesize currentAge = _currentAge;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0,0,320,244)];
    if (self) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        toolbar.tintColor = [UIColor blackColor];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolbar setItems:@[flexSpace, done]];
        
        [self addSubview:toolbar];
        
        NSString *ageFile = [[NSBundle mainBundle] pathForResource:@"ages" ofType:@"plist"];
        self.ages = [NSArray arrayWithContentsOfFile:ageFile];
        self.currentAge = [self.ages objectAtIndex:0];
        self.agePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,44,320, 200)];
        self.agePicker.dataSource = self;
        self.agePicker.delegate = self;
        self.agePicker.showsSelectionIndicator = YES;
        [self addSubview:self.agePicker];
        
        [self sizeToFit];
        
    }
    return self;
}

- (void)done:(id)sender
{
    _onPickerDone();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.ages count];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *age = [self.ages objectAtIndex:row];
    return [NSString stringWithFormat:@"%@ years old", [age valueForKey:@"name"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *age = [self.ages objectAtIndex:row];
    self.currentAge = age;
}

@end
