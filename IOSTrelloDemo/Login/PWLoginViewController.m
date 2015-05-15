//
//  PWLoginViewController.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWLoginViewController.h"
#import "PWDataManager.h"

@interface PWLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterY;
@property (weak, nonatomic) IBOutlet UILabel *loginInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation PWLoginViewController

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self localize];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.container.layer.cornerRadius = 20;
    self.loginButton.layer.cornerRadius = 5;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Stuff

- (void)localize
{
    self.navigationItem.title = LocString(@"Login");
    self.loginInfoLabel.text = LocString(@"loginInfoText");
    self.loginField.placeholder = LocString(@"loginPlaceholder");
    self.passwordField.placeholder = LocString(@"passwordPlaceholder");
    [self.loginButton setTitle:LocString(@"Login") forState:UIControlStateNormal];
}

-(void) keyboardWillShow:(NSNotification *)note{
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

-(void) keyboardWillHide:(NSNotification *)note{
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

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginField) {
        [self.passwordField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    if (self.loginField.text.length && self.passwordField.text.length) {
        self.loginButton.enabled = YES;
        [self.loginButton setBackgroundColor:[UIColor blueColor]];
    } else {
        self.loginButton.enabled = NO;
        [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    return YES;
}

#pragma mark - IBActions

- (IBAction)login:(id)sender {
    [[PWDataManager sharedInstance] login:self.loginField.text password:self.passwordField.text];
}
@end
