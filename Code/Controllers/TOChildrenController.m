//
//  TOChildrenController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOChildrenController.h"
#import "TOChild.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "TOChildDetailController.h"

@interface TOChildrenController ()<NSFetchedResultsControllerDelegate>

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TOChildrenController




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setEditing:YES];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    NSFetchRequest *fetchRequest = [TOChild MR_requestAll];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"birthdate" ascending:YES]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];


}

#pragma mark - IBAction methods

- (IBAction)doneButtonPressed:(id)sender
{
    _onEndBlock();
}
- (IBAction)addButtonPressed:(id)sender
{
    //Create a scratch context
    ;
    TOChild *newChild = [TOChild MR_createInContext:[NSManagedObjectContext MR_context]];
    
    TOChildDetailController *controller = [[TOChildDetailController alloc] initWithChild:newChild];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    TOChild *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = child.name;
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TOChild *deletedChild = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [deletedChild MR_deleteEntity];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveNestedContexts];
        
    }   

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"childDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath) {
            TOChild *child = [self.fetchedResultsController objectAtIndexPath:indexPath];
            TOChildDetailController *controller = [segue destinationViewController];
            controller.child = child;
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }

    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"childDetails" sender:nil];
    
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    DDLogVerbose(@"Reloading data");
    [self.tableView reloadData];
}
@end
