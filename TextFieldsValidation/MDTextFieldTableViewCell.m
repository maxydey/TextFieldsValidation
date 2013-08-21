//
//  MDTextFieldTableViewCell.m
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import "MDTextFieldTableViewCell.h"
#define titleWIdth 100

@implementation MDTextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UITextField *tf =  [[UITextField alloc] init];
        self.textField = tf;
        [tf release];
        [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textLabel setMinimumFontSize:5];
        [self.textLabel setAdjustsFontSizeToFitWidth:YES];
        [self.textLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = CGRectInset(self.contentView.bounds, 10, 10);
    r.origin.x +=titleWIdth;
    r.size.width -=titleWIdth;
    [self.textLabel setFrame:CGRectMake(10, 0, titleWIdth, self.contentView.frame.size.height)];
    [self.textField setFrame:r];
}

-(void)dealloc
{
    [_textField release];

    [super dealloc];
}

@end
