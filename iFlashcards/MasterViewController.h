//
//  MasterViewController.h
//  iFlashcards
//
//  Created by Ian Koller on 5/15/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDeckViewController.h"

@interface MasterViewController : UITableViewController <NewDeckViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end
