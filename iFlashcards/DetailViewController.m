//
//  DetailViewController.m
//  iFlashcards
//
//  Created by Ian Koller on 5/15/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import "DetailViewController.h"
#import "BButton.h"
#import "SettingsViewController.h"
#import "StudySessionViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

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
    
    self.navigationItem.title = _sentDeck.name;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    BButton *newDeckButton = [[BButton alloc] initWithFrame:CGRectMake(20, 20, 130, 44) type:BButtonTypeInverse];
    
    [newDeckButton setTitle:@"New Card" forState:UIControlStateNormal];
    
    [newDeckButton addTarget:self
                      action:@selector(newCardPressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    BButton *startStudyButton = [[BButton alloc] initWithFrame:CGRectMake(170, 20, 130, 44) type:BButtonTypeInverse];
    
    [startStudyButton setTitle:@"Start Studying" forState:UIControlStateNormal];
    
    [startStudyButton addTarget:self
                      action:@selector(startPressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:newDeckButton];
    [self.view addSubview:startStudyButton];

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    _allCards = [[NSMutableArray alloc] initWithArray:_sentDeck.cards];
    
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Cards";
}

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
    
    Card *card = [_allCards objectAtIndex:indexPath.row];
    cell.textLabel.text = card.question;
    cell.detailTextLabel.text = card.answer;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark.png"]]];
    [cell setSelectedBackgroundView:bgView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)convertDefaultsToObjects
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [_allCards count]; i++){
        Card *thisCard = [_allCards objectAtIndex:i];
        NSArray *card = [[NSArray alloc] initWithObjects: thisCard.question, thisCard.answer, nil];
        
        [cards addObject:card];
    }
    
    NSDictionary *deck = [[NSDictionary alloc] initWithObjectsAndKeys:_sentDeck.name, @"name", cards, @"cards", nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *myDecks = [[defaults objectForKey:@"decks"] mutableCopy];
    
    NSLog(@"My Decks Before: %@", myDecks);

    
    for(int i = 0; i < [myDecks count]; i++){
        
        Deck *thisDeck = [[Deck alloc] init];
        thisDeck.name = [[myDecks objectAtIndex:i] objectForKey:@"name"];
        
        if([thisDeck.name isEqualToString:_sentDeck.name]){
            
            [myDecks removeObjectAtIndex:i];
            [myDecks insertObject:deck atIndex:i];

        }
    }
    
    NSLog(@"My Decks After: %@", myDecks);
    [defaults setObject:myDecks forKey:@"decks"];
    [defaults synchronize];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self convertDefaultsToObjects];
    [_delegate deckReturned];
}


-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cardReturned:(Card *)myCard
{
    [_allCards addObject:myCard];
    [self.tableView reloadData];
}

-(void)startPressed{
    if([_allCards count]){
        [self performSegueWithIdentifier:@"studySegue" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"You don't have any cards to study."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)newCardPressed{
    [self performSegueWithIdentifier:@"addCard2Segue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"studySegue"]) {
        [[segue destinationViewController] setSentDeck:_sentDeck];
    }
    if ([[segue identifier] isEqualToString:@"addCard2Segue"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)showSettings{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    SettingsViewController *modalViewController = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
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
