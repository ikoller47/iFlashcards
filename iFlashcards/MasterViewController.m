//
//  MasterViewController.m
//  iFlashcards
//
//  Created by Ian Koller on 5/15/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import "MasterViewController.h"
#import "SettingsViewController.h"
#import "DetailViewController.h"
#import "BButton.h"
#import "Deck.h"
#import "Card.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    _footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    BButton *newDeckButton = [[BButton alloc] initWithFrame:CGRectMake(85, 20, 160, 44) type:BButtonTypeInverse];
    
    [newDeckButton setTitle:@"New Deck" forState:UIControlStateNormal];
    
    [newDeckButton addTarget:self
                action:@selector(newDeckPressed)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView addSubview:newDeckButton];
    [self convertDefaultsToObjects];

}

-(void)convertDefaultsToObjects
{
//    NSArray *card = [[NSArray alloc] initWithObjects:@"What is your name?", @"Ian", nil];
//    
//    NSArray *card2 = [[NSArray alloc] initWithObjects:@"What is the answer?", @"Test", nil];
//    
//    NSArray *cards = [[NSArray alloc] initWithObjects:card, card2, nil];
//    
//    NSDictionary *deck = [[NSDictionary alloc] initWithObjectsAndKeys:@"History", @"name", cards, @"cards", nil];
//
    _objects = [[NSMutableArray alloc] init];
//
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//    NSArray *decks = [[NSArray alloc] initWithObjects:deck, nil];

//    [defaults setObject:decks forKey:@"decks"];
//    [defaults synchronize];
//
    NSArray *myDecks = [defaults objectForKey:@"decks"];
    if(myDecks == nil){

        NSMutableArray *decks = [[NSMutableArray alloc] init];
        [defaults setObject:decks forKey:@"decks"];
        [defaults synchronize];

    }
    
    for(int i = 0; i < [myDecks count]; i++){
        
        Deck *thisDeck = [[Deck alloc] init];
        thisDeck.name = [[myDecks objectAtIndex:i] objectForKey:@"name"];
        
        NSArray *cards = [[myDecks objectAtIndex:i] objectForKey:@"cards"];
        
        NSMutableArray *cardObjects = [[NSMutableArray alloc] init];
        
        for(int j = 0; j < [cards count]; j++){
            Card * card = [[Card alloc] init];
            card.question = [[cards objectAtIndex:j]objectAtIndex:0];
            card.answer = [[cards objectAtIndex:j]objectAtIndex:1];
            
            [cardObjects addObject:card];
        }
        
        thisDeck.cards = cardObjects;
        [_objects addObject:thisDeck];
    }
    
}

-(void)newDeckPressed{
    [self performSegueWithIdentifier:@"newDeckSegue" sender:self];
}

-(void)showSettings{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SettingsViewController *modalViewController = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Deck *object = _objects[indexPath.row];
    cell.textLabel.text = object.name;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark.png"]]];
    [cell setSelectedBackgroundView:bgView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Decks";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)deckReturned
{
    [self convertDefaultsToObjects];
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Deck *deck = _objects[indexPath.row];
        [[segue destinationViewController] setSentDeck:deck];
        [[segue destinationViewController] setDelegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"newDeckSegue"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
