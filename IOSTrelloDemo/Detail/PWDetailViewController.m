//
//  PWDetailViewController.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWDetailViewController.h"

@interface PWDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterY;
@end

@implementation PWDetailViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = LocString(@"Name");
    self.descriptionLabel.text = LocString(@"Desctiption");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:LocString(@"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = anotherButton;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.descriptionTextView.layer.cornerRadius = 5;
    self.nameField.layer.cornerRadius = 5;
    self.descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descriptionTextView.layer.borderWidth = 1;
    self.nameField.layer.borderWidth = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameField.text = self.card.name;
    self.descriptionTextView.text = self.card.desc;
}

#pragma mark - Custom Stuff

- (void) keyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.containerCenterY.constant = 75;
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.containerCenterY.constant = 0;
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (void)save
{
    self.card.name = self.nameField.text;
    self.card.desc = self.descriptionTextView.text;
    [self.card save];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
