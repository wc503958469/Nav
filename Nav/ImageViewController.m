//
//  ImageViewController.m
//  test
//
//  Created by wangchen on 15/10/7.
//  Copyright © 2015年 heiguang. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = _image;
    [self.view addSubview:imageView];
    imageView.autoresizingMask = (1 << 6) - 1;
    imageView.contentMode = UIViewContentModeCenter;
    
    
}

@end
