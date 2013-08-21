//
//  MDValidatedItem.m
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import "MDValidatedItem.h"

@implementation MDValidatedItem

+(MDValidatedItem *)itemWithTitle:(NSString *)title validationRule:(MDValidationRule)rule
{
  MDValidatedItem *item = [[[MDValidatedItem alloc] init] autorelease];
    item.validationRule = rule;
    item.title = title;
    item.valid = YES;
    return item;
}

-(void)dealloc
{
    [_title release];
    [_text release];
    [super dealloc];
}

@end
