//
//  MDViewController.h
//  TextFieldsValidation
//
//  Created by Max Deygin on 21.08.13.
//  Copyright (c) 2013 Max Deygin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate>


@property(strong, nonatomic) IBOutlet UITableView *tableView;
@end
