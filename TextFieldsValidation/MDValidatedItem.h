//
//  MDValidatedItem.h
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTextFieldValidator.h"

@interface MDValidatedItem : NSObject

@property(nonatomic, strong) NSString *text;
@property(nonatomic, assign) MDValidationRule validationRule;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL valid;

+(MDValidatedItem *)itemWithTitle:(NSString *)title validationRule:(MDValidationRule)rule;

@end
