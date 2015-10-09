//
//  NavViewController.m
//  test
//
//  Created by wangchen on 15/10/7.
//  Copyright © 2015年 heiguang. All rights reserved.
//

#import "NavViewController.h"
#import "ImageViewController.h"
#import "NavTableViewCell.h"
#define navViewWidth 60

@interface NavViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *navView;

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIView *contentDetailView;

@property (nonatomic,strong)UIView *menuView;

@property (nonatomic,strong)NSArray *constraintsArray;

@property (nonatomic,strong)NSArray *images;

@property (nonatomic,assign)BOOL navOpening;

@property (nonatomic,assign)CGFloat firstX;

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    NSMutableArray *tempPagesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 10; i++) {
        NSDictionary *dictionary = @{@"icon":[NSString stringWithFormat:@"%d",i],@"r":@((float)arc4random_uniform(256) / 255),@"g":@((float)arc4random_uniform(256) / 255),@"b":@((float)arc4random_uniform(256) / 255)};
        NSLog(@"%@",dictionary);
        [tempPagesArray addObject:dictionary];
    }
    _images = tempPagesArray;
    
    UIView *navView = [[UIView alloc]init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    navView.translatesAutoresizingMaskIntoConstraints = NO;
    navView.clipsToBounds = YES;
    _navView = navView;
    
    UIView *contentView = [[UIView alloc]init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    _contentView = contentView;
    
    NSArray *cos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[navView(0)]-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navView,contentView)];
    _constraintsArray = cos;
    NSArray *cos1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[navView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navView)];
    NSArray *cos2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)];
    [self.view addConstraints:_constraintsArray];
    [self.view addConstraints:cos1];
    [self.view addConstraints:cos2];
    //以下4个方法调用后,才能利用frame获取到view的size
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 64)];
    [_contentView addSubview:menuView];
    menuView.autoresizingMask =
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleBottomMargin;
    _menuView = menuView;
    
    UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
//    [menuBtn setImage:[UIImage imageNamed:@"tui01"] forState:UIControlStateNormal];
    [menuBtn setTitle:@"三" forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:menuBtn];
    

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:_navView.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 80;
    tableView.backgroundColor = [UIColor blackColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.bounces = NO;
    [_navView addSubview:tableView];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    ImageViewController *vc = [[ImageViewController alloc]init];
    vc.image = [UIImage imageNamed:[_images[0] objectForKey:@"icon"]];
    vc.view.backgroundColor = [UIColor colorWithRed:[[_images[0] objectForKey:@"r"] floatValue] green:[[_images[0] objectForKey:@"g"] floatValue] blue:[[_images[0] objectForKey:@"b"] floatValue] alpha:1];
    [self setCurrentViewController:vc];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _contentDetailView.frame = self.view.bounds;
}

-(void)menuBtnClick{
    self.navOpening = !self.navOpening;
}

-(void)panning:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (gestureRecognizer.state == 1) {
        _firstX = point.x;
    }else if (gestureRecognizer.state == 2) {
        CGFloat length = point.x - _firstX;
        if (_navOpening) {
            if (length > 0) {
                length = 0;
            }else if (length < -navViewWidth){
                length = -navViewWidth;
            }
            length = navViewWidth + length;
        }else{
            if (length < 0) {
                length = 0;
            }else if (length > navViewWidth){
                length = navViewWidth;
            }
        }
        [self.view removeConstraints:_constraintsArray];
        UIView *navView = _navView;
        UIView *contentView = _contentView;
        NSArray *cos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[navView(length)]-0-[contentView]-0-|" options:0 metrics:@{@"length":@(length)} views:NSDictionaryOfVariableBindings(navView,contentView)];
        _constraintsArray = cos;
        [self.view addConstraints:_constraintsArray];
        //以下4个方法调用后,才能利用frame获取到view的size
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
//        CATransform3D transform3D = CATransform3DIdentity;
//        transform3D.m34 = -1 / 1000;
//        CGFloat angle = - (navViewWidth - length) / navViewWidth / 2 * M_PI;
//        _navView.layer.transform = CATransform3DRotate(transform3D, angle, 0, 1, 0);
        
    }else if (gestureRecognizer.state == 3) {
        
        CGFloat length = point.x - _firstX;
        if (_navOpening) {
            if (length < 0) {
                self.navOpening = NO;
            }
        }else{
            if (length > 0) {
                self.navOpening = YES;
            }
        }
    }
}

-(void)setNavOpening:(BOOL)navOpening{
    if (navOpening) {
        [self navOpened];
    }else{
        [self navClosed];
    }
    _navOpening = navOpening;

}

-(void)navOpened{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view removeConstraints:_constraintsArray];
        
        UIView *navView = _navView;
        UIView *contentView = _contentView;
        
        NSArray *cos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[navView(navViewWidth)]-0-[contentView]-0-|" options:0 metrics:@{@"navViewWidth":@(navViewWidth)} views:NSDictionaryOfVariableBindings(navView,contentView)];
        _constraintsArray = cos;
        [self.view addConstraints:_constraintsArray];
        //以下4个方法调用后,才能利用frame获取到view的size
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

-(void)navClosed{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view removeConstraints:_constraintsArray];
        
        UIView *navView = _navView;
        UIView *contentView = _contentView;
        
        NSArray *cos = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[navView(0)]-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navView,contentView)];
        _constraintsArray = cos;
        [self.view addConstraints:_constraintsArray];
        //以下4个方法调用后,才能利用frame获取到view的size
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

-(void)setCurrentViewController:(UIViewController *)currentViewController{
    if (_currentViewController) {
        [self removeViewFromViewController:_currentViewController];
    }
    [self addViewFromViewController:currentViewController];
    _currentViewController = currentViewController;
}

-(void)removeViewFromViewController:(UIViewController *)vc{
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

-(void)addViewFromViewController:(UIViewController *)vc{
    [self addChildViewController:vc];
    _contentDetailView = vc.view;
    [_contentView insertSubview:_contentDetailView belowSubview:_menuView];
    _contentDetailView.frame = self.view.bounds;
    _contentDetailView.autoresizingMask = 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _images.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NavTableViewCell *cell = [NavTableViewCell cellWithTableView:tableView];
//    cell.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    cell.iconView.image = [UIImage imageNamed:[_images[indexPath.row] objectForKey:@"icon"]];
    cell.backgroundColor = [UIColor blackColor];
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:[[_images[indexPath.row] objectForKey:@"r"] floatValue] green:[[_images[indexPath.row] objectForKey:@"g"] floatValue] blue:[[_images[indexPath.row] objectForKey:@"b"] floatValue] alpha:1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewController *vc = [[ImageViewController alloc]init];
    vc.image =  [UIImage imageNamed:[_images[indexPath.row] objectForKey:@"icon"]];
    vc.view.backgroundColor = [UIColor colorWithRed:[[_images[indexPath.row] objectForKey:@"r"] floatValue] green:[[_images[indexPath.row] objectForKey:@"g"] floatValue] blue:[[_images[indexPath.row] objectForKey:@"b"] floatValue] alpha:1];
    [self setCurrentViewController:vc];
    self.navOpening = NO;
}


@end
