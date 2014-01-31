//
//  DetailViewController.h
//  iFlashcards
//
//  Created by Ian Koller on 5/15/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"
#import "AddCardViewController.h"
#import "NewDeckViewController.h"



@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddCardViewControllerDelegate>

@property (strong, nonatomic) Deck *sentDeck;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allCards;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(nonatomic, weak) id<NewDeckViewControllerDelegate> delegate;
@end
