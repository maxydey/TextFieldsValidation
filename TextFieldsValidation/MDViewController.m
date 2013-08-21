//
//  MDViewController.m
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import "MDViewController.h"
#import "MDTextFieldTableViewCell.h"
#import "MDTextFieldValidator.h"
#import "MDValidatedItem.h"

@interface MDViewController ()<MDValidationRulesDataSource, MDValidatorDelegate>

@property(nonatomic, strong) NSMutableArray *formItems;
@property(nonatomic, strong) MDTextFieldValidator *validator;
@property(nonatomic, assign) NSInteger editingFieldIndex;

@end

@implementation MDViewController

- (void)viewDidLoad
{
    
    self.formItems = [[NSMutableArray alloc] init];
    
    for(int i = 1; i<6; i++)
    {
        [self.formItems addObject:[MDValidatedItem itemWithTitle:[@"Characters" stringByAppendingFormat:@"%d",i]
                                                  validationRule:MDValidationRuleCharactersOnly]];
        [self.formItems addObject:[MDValidatedItem itemWithTitle:[@"Digits" stringByAppendingFormat:@"%d",i]
                                                  validationRule:MDValidationRuleDigitsOnly]];
        [self.formItems addObject:[MDValidatedItem itemWithTitle:[@"Email" stringByAppendingFormat:@"%d",i]
                                                  validationRule:MDValidationRuleEmail]];
    }
    
    self.validator = [[MDTextFieldValidator alloc] initWithDelegate:self
                                                         dataSource:self];
    
    [super viewDidLoad];
    [self.tableView reloadData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setUpKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeKeyboardNotifications];
}

- (void)dealloc
{
    [_formItems release];
    [_validator release];
    self.validator = nil;
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard notifications
- (void)setUpKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect endFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions opt = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:opt animations:^{
        CGRect r = self.tableView.frame;
        r.size.height = self.view.frame.size.height - endFrame.size.height;
        self.tableView.frame = r;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyboardWasShown:(NSNotification *)notification
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.editingFieldIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions opt = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:opt animations:^{
        
        [self.tableView setFrame:self.view.bounds];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - tableView dataSourse


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.formItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    MDTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[[MDTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    MDValidatedItem *item = self.formItems[indexPath.row];
    [cell.textLabel setText:item.title];
    [cell.textField setText:item.text];
    [cell.textField setTag:indexPath.row];
    [cell.textField setDelegate:self];
    [cell.textField setBackgroundColor:item.valid?[UIColor whiteColor]:[UIColor redColor]];
    [self.validator addTextField:cell.textField];

    return cell;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    MDValidatedItem *item = self.formItems[textField.tag];
    [item setText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.editingFieldIndex = textField.tag;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - validator

-(MDValidationRule)validationRuleForTextField:(UITextField *)textField
{
    return textField.tag%3;
}


-(void)textField:(UITextField *)textField validationSuccess:(BOOL)success
{

    MDValidatedItem *item = self.formItems[textField.tag];
    [item setValid:success];

}




@end
