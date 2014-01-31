//
//  NewDeckViewController.m
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import "NewDeckViewController.h"
#import "BButton.h"
#import "SettingsViewController.h"
@interface NewDeckViewController ()

@end

@implementation NewDeckViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setShowsTouchWhenHighlighted:YES];
    UIImage *backBtnImage = [UIImage imageNamed:@"5-blue-back-button.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton2;
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    _headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    BButton *newDeckButton = [[BButton alloc] initWithFrame:CGRectMake(20, 50, 130, 44) type:BButtonTypeInverse];
    
    [newDeckButton setTitle:@"New Card" forState:UIControlStateNormal];
    
    [newDeckButton addTarget:self
                      action:@selector(newCardPressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    BButton *saveButton = [[BButton alloc] initWithFrame:CGRectMake(170, 50, 130, 44) type:BButtonTypeInverse];
    
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    
    [saveButton addTarget:self
                      action:@selector(savePressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView addSubview:newDeckButton];
    [_headerView addSubview:saveButton];

    _nameTextField.delegate = self;
    _allCards = [[NSMutableArray alloc] init];
    
}


- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cardReturned:(Card *)myCard
{
    NSLog(@"Got the card");
    [_allCards addObject:myCard];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_allCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark.png"]]];
    [cell setSelectedBackgroundView:bgView];
    
    
    Card *thisCard = [_allCards objectAtIndex:indexPath.row];
    cell.textLabel.text = thisCard.question;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Cards";
}

-(void)savePressed{
    if(![_nameTextField.text length]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"You forgot to add a name to the deck."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        [self convertDefaultsToObjects];
        [_delegate deckReturned];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)convertDefaultsToObjects
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [_allCards count]; i++){
        Card *thisCard = [_allCards objectAtIndex:i];
        NSArray *card = [[NSArray alloc] initWithObjects: thisCard.question, thisCard.answer, nil];
        
        [cards addObject:card];
    }
    
    NSDictionary *deck = [[NSDictionary alloc] initWithObjectsAndKeys:_nameTextField.text, @"name", cards, @"cards", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSMutableArray *myDecks = [[defaults objectForKey:@"decks"] mutableCopy];

    
    NSLog(@"myDecks2: %@", myDecks);
    [myDecks addObject:deck];
    NSLog(@"myDecks22: %@", myDecks);
    [defaults setObject:myDecks forKey:@"decks"];
    NSLog(@"2");
    [defaults synchronize];
    
}


-(void)newCardPressed{
    [self performSegueWithIdentifier:@"addCardSegue" sender:self];
}

-(void)showSettings{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SettingsViewController *modalViewController = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}




-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addCardSegue"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_allCards removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

@end
