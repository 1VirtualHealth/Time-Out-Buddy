//
//  TOChildDetailController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOChildDetailController.h"
#import "TOChild.h"

@interface TOChildDetailController ()

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@property (nonatomic, readonly) NSManagedObjectContext *scratchContext;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UIDatePicker *birthdayPicker;

@end

@implementation TOChildDetailController

@synthesize scratchContext = _scratchContext;
@synthesize child = _child;


- (NSManagedObjectContext *)scratchContext
{
    if(_scratchContext == nil) {
        _scratchContext = [NSManagedObjectContext MR_context];
    }
    
    return _scratchContext;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.text = self.child.name;
    self.birthdayPicker.date = self.child.birthdate;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
