//
//  MDTextFieldValidator.m
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import "MDTextFieldValidator.h"

@implementation MDTextFieldValidator


- (id)init
{
     NSAssert(NO, @"Use initWithDelegate:DataSource:");
    return nil;
}

-(id)initWithDelegate:(id<MDValidatorDelegate>)delegate dataSource:(id<MDValidationRulesDataSource>)dataSource
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.dataSource = dataSource;
        [self revalidate];
    }
    return self;
}

-(void)revalidate
{
    
}

-(void)addTextField:(UITextField *)textField
{
    [textField addTarget:self action:@selector(validateTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

-(void)validateTextField:(UITextField *)textField
{
    NSAssert(self.dataSource, @"Need dataSorce to validate textField");
    NSAssert([self.dataSource respondsToSelector:@selector(validationRuleForTextField:)], @"DataSource should implement validationRuleForTextField:");

    MDValidationRule rule =  [self.dataSource validationRuleForTextField:textField];
    NSString *str = textField.text;
    BOOL isValid = [self isStringValid:str withRule:rule];
    if([self.delegate respondsToSelector:@selector(textField:validationSuccess:)])
    {
        [self.delegate textField:textField validationSuccess:isValid];
    }
}

-(BOOL)isStringValid:(NSString *)string withRule:(MDValidationRule)rule
{
    if(![string length])
        return YES;
    BOOL isValid = NO;
    switch (rule) {
        case MDValidationRuleCharactersOnly:
            isValid = [self validateStringForCharactersOnly:string];
            break;
        case MDValidationRuleDigitsOnly:
            isValid = [self validateStringForDigitsOnly:string];
            break;
        case MDValidationRuleEmail:
            isValid = [self validateStringForEmail:string];
            break;
            
        default:
            break;
    }
    return isValid;
}

-(BOOL)validateStringForCharactersOnly:(NSString *)string
{
    if([string rangeOfCharacterFromSet:[[NSCharacterSet letterCharacterSet] invertedSet]].location == NSNotFound)
        return YES;
    return NO;
}

-(BOOL)validateStringForDigitsOnly:(NSString *)string
{
    if([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)
        return YES;
    return NO;
}

-(BOOL)validateStringForEmail:(NSString *)string
{
    //регекс честно украл с Хабра
    NSString *emailRegex =  @"^[a-zA-Z0-9_'+*/^&=?~{}\\-](\\.?[a-zA-Z0-9_'+*/^&=?~{}\\-])*\\@((\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(\\:\\d{1,3})?)|(((([a-zA-Z0-9][a-zA-Z0-9\\-]+[a-zA-Z0-9])|([a-zA-Z0-9]{1,2}))[\\.]{1})+([a-zA-Z]{2,6})))$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:string];
}

-(void)dealloc
{
    [super dealloc];
}
@end
