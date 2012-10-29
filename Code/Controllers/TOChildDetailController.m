//
//  TOChildDetailController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOChildDetailController.h"
#import "TOChild.h"

@interface TOChildDetailController ()<UITextFieldDelegate>

- (void)hideKeyboardIfNecessary:(UITouch *)touch;
- (BOOL)validate;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)dateValueChanged:(id)sender;

@property (nonatomic, readonly) NSManagedObjectContext *scratchContext;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UIDatePicker *birthdayPicker;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation TOChildDetailController

@synthesize scratchContext = _scratchContext;
@synthesize child = _child;

#pragma mark - Private methods

- (NSManagedObjectContext *)scratchContext
{
    if(_scratchContext == nil) {
        _scratchContext = [NSManagedObjectContext MR_context];
    }
    
    return _scratchContext;
}

- (void)hideKeyboardIfNecessary:(UITouch *)touch
{

    if ([self.nameField isFirstResponder] && touch.view != self.nameField) {
        [self.nameField resignFirstResponder];
    }
}

- (BOOL)validate
{
    return self.nameField.text.length > 0;
}

#pragma mark - IBAction methods


- (IBAction)cancelButtonPressed:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
    
    self.child.name = self.nameField.text;
    self.child.birthdate = self.birthdayPicker.date;
    
    [self.child.managedObjectContext MR_saveNestedContextsErrorHandler:^(NSError *error) {
        DDLogError(@"unable to save child:%@", [error localizedDescription]);
    }];
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
    
    
}

- (IBAction)dateValueChanged:(id)sender
{
    [self hideKeyboardIfNecessary:nil];
}


#pragma mark - Public methods


- (void)setChild:(TOChild *)child
{
    if(child != _child) {
        _child = [child MR_inContext:self.scratchContext];
    }
}

- (TOChild *)child
{
    if (_child == nil) {
        _child = [TOChild MR_createInContext:self.scratchContext];
        _child.birthdate = [NSDate date];
    }
    
    return _child;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    self.nameField.text = self.child.name;
    self.birthdayPicker.date = self.child.birthdate;
    
    self.saveButton.enabled = [self validate];

	// Do any additional setup after loading the view.
}


#pragma mark - UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboardIfNecessary:[touches anyObject]];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboardIfNecessary:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.saveButton.enabled = textField.text.length - range.length + string.length > 0;
    return YES;
}


@end
