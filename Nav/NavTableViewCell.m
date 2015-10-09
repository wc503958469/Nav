//
//  NavTableViewCell.m
//  test
//
//  Created by wangchen on 15/10/9.
//  Copyright © 2015年 heiguang. All rights reserved.
//

#import "NavTableViewCell.h"

#define navViewWidth 60
@implementation NavTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    NavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NavTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, navViewWidth, 80);
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, navViewWidth, 80)];
        [self addSubview:iconView];
//        iconView.backgroundColor = [UIColor yellowColor];
        iconView.contentMode = UIViewContentModeCenter;
        _iconView = iconView;
        iconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
    }
    return self;
}
@end
