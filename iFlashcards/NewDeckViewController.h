//
//  NewDeckViewController.h
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCardViewController.h"

@protocol NewDeckViewControllerDelegate <NSObject>
-(void)deckReturned;
@end

@interface NewDeckViewController : UITableViewController <UITextFieldDelegate, AddCardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) NSMutableArray *allCards;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(nonatomic, weak) id<NewDeckViewControllerDelegate> delegate;

@end
