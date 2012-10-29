//
//  TOAgePickerView.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOAgePickerView.h"
#import "TOChild.h"

@interface TOAgePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *agePicker;
@property (strong, nonatomic) NSArray *ages;
@property (strong, nonatomic) NSArray *children;
@end

@implementation TOAgePickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0,0,320,244)];
    if (self) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.bounds),44)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        toolbar.tintColor = [UIColor blackColor];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [toolbar setItems:@[flexSpace, done]];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:toolbar];
        
        NSString *ageFile = [[NSBundle mainBundle] pathForResource:@"ages" ofType:@"plist"];
        self.ages = [NSArray arrayWithContentsOfFile:ageFile];
        
        self.children = [TOChild MR_findAll];
        
    

        self.agePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,44,CGRectGetWidth(self.bounds), 200)];
        self.agePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        self.agePicker.dataSource = self;
        self.agePicker.delegate = self;
        self.agePicker.showsSelectionIndicator = YES;
        [self addSubview:self.agePicker];
        
        [self pickerView:self.agePicker didSelectRow:0 inComponent:0];
        
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
    
    return [self.ages count] + [self.children count] + 1;
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < [self.children count]) {
        TOChild *child = self.children[row];
        return child.name;
    }
    else if (row == [self.children count]) {
        return @"=======================";
    }
    else {
        NSInteger index = row - [self.children count] -1;
        NSDictionary *age = [self.ages objectAtIndex:index];
        return age[@"name"];
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < [self.children count]) {
        TOChild *child = self.children[row];
        //look up the appropriate dictionary in the array
        NSArray *filtered = [self.ages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"age == %d", [child ageInYears]]];
        if ([filtered count] == 0)
            filtered = self.ages;
       
        NSMutableDictionary *ageDict = [NSMutableDictionary dictionaryWithDictionary:filtered[0]];
        ageDict[@"name"] = child.name;
        self.currentAge = ageDict;
    }
    else if (row == [self.children count]) {
        self.currentAge = nil;
    }
    else {
        NSInteger index = row - [self.children count] - 1;
        NSDictionary *age = [self.ages objectAtIndex:index];
        self.currentAge = age;
    }
}

@end
