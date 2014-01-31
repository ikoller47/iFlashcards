//
//  AddCardViewController.m
//  iFlashcards
//
//  Created by Ian Koller on 5/16/13.
//  Copyright (c) 2013 koller. All rights reserved.
//

#import "AddCardViewController.h"
#import "BButton.h"
#import "Card.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController

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
    
    self.tableView.backgroundView = nil;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    _footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5-blue-background.jpg"]];
    
    BButton *saveButton = [[BButton alloc] initWithFrame:CGRectMake(85, 20, 160, 44) type:BButtonTypeInverse];
    
    [saveButton setTitle:@"Save Card" forState:UIControlStateNormal];
    
    [saveButton addTarget:self
                      action:@selector(savePressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    _questionTextField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 12.0, 200.0, 34.0)];
    
    _questionTextField.delegate = self;
    
    _answerTextField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 12.0, 200.0, 34.0)];
    
    _answerTextField.delegate = self;
    
    [_footerView addSubview:saveButton];
    
    
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)savePressed
{
    if(![_questionTextField.text length]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"You forgot to add a question to your flash card."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else if(![_answerTextField.text length]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Oops"
                              message: @"You forgot to add an answer to your flash card."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        Card *newCard = [[Card alloc] init];
        newCard.question = _questionTextField.text;
        newCard.answer = _answerTextField.text;
        
        [_delegate cardReturned:newCard];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Question:";
        [cell addSubview:_questionTextField];

    }
    else{
        cell.textLabel.text = @"Answer:";
        [cell addSubview:_answerTextField];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
