//
//  ViewController.m
//  xPickerView-Master
//
//  Created by 薛永伟 on 16/1/2.
//  Copyright © 2016年 薛永伟. All rights reserved.
//

#import "ViewController.h"
#import "XpickView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbel;
@property (nonatomic,strong)XpickView *xpicker;
@end

@implementation ViewController

- (IBAction)onClick:(UIButton *)sender {
    _xpicker.Xflag = YES;
    __weak ViewController *weakSelf = self;
    [_xpicker setDataViewWithItem:@[@"薛永伟",@"iOS",@"XpickerView"] title:@"选择数据" withBlock:^(NSString *resultStr) {
        NSLog(@"%@",resultStr);
        weakSelf.lbel.text = resultStr;
    }];
    [_xpicker showXpickViewIn:self];
}

- (IBAction)ontClick:(id)sender {
    _xpicker.XfromNow = YES;
    _xpicker.Xhms = YES;
    __weak ViewController *weakSelf = self;
    [_xpicker setDateViewWithTitle:@"选择时间" withBlock:^(NSString *resultStr) {
        NSLog(@"%@",resultStr);
        weakSelf.lbel.text = resultStr;
    }];
    [_xpicker showXpickViewIn:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _xpicker = [[XpickView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
