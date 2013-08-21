//
//  MDTextFieldValidator.h
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDValidationRule){
    MDValidationRuleCharactersOnly = 0,
    MDValidationRuleDigitsOnly = 1,
    MDValidationRuleEmail = 2
};


@protocol MDValidationRulesDataSource <NSObject>

-(MDValidationRule)validationRuleForTextField:(UITextField *)textField;

@end

@protocol MDValidatorDelegate <NSObject>

@optional
-(void)textField:(UITextField *)textField validationSuccess:(BOOL)success;

@end

@interface MDTextFieldValidator : NSObject

@property(nonatomic, unsafe_unretained) id<MDValidationRulesDataSource>dataSource;
@property(nonatomic, unsafe_unretained) id<MDValidatorDelegate>delegate;

-(id)initWithDelegate:(id<MDValidatorDelegate>)delegate dataSource:(id<MDValidationRulesDataSource>)dataSource;

-(void)revalidate;
-(void)addTextField:(UITextField *)textField;

@end
