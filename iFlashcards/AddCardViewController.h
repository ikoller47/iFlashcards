//
//  AddCardViewController.h
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
//#import "AddCardViewController.h"

@protocol AddCardViewControllerDelegate <NSObject>
-(void)cardReturned:(Card*) myCard;
@end

@interface AddCardViewController : UITableViewController <UITextFieldDelegate>
@property(nonatomic, weak) id<AddCardViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property(nonatomic, strong) UITextField *questionTextField;
@property(nonatomic, strong) UITextField *answerTextField;

@end
