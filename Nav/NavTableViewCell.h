//
//  NavTableViewCell.h
//  test
//
//  Created by wangchen on 15/10/9.
//  Copyright © 2015年 heiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak)UIImageView *iconView;

@end
