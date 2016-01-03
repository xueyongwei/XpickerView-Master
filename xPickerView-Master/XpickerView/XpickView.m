//
//  XPickView.m
//
//  Created by 薛永伟 on 15/11/22.
//  Copyright © 2015年 薛永伟. All rights reserved.
//

#import "XpickView.h"
#define SCREENSIZE UIScreen.mainScreen.bounds.size
@interface XpickView()
@property(nonatomic,copy)XPickViewSubmit Sblock;
@end

@implementation XpickView
{
    UIView *bgView;
    NSArray *proTitleList;
    NSString *selectedStr;
    BOOL isDate;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    isDate = NO;
    _XfromNow = NO;
    _Xflag = NO;
    _Xhms = NO;
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _XfromNow = NO;
        isDate = NO;
        _Xhms = NO;
        _Xflag = NO;
    }
    return self;
}
-(void)tapBgVIew
{
    [self hide];
}
- (void)showXpickViewIn:(UIViewController *)vc
{
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgVIew)];
        [bgView addGestureRecognizer:tap];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.0f;
    }

    [vc.view addSubview:bgView];
    
    CGRect frame = self.frame ;
    frame.origin.y = SCREENSIZE.height-frame.size.height;
    self.frame = CGRectMake(0,SCREENSIZE.height, SCREENSIZE.width, frame.size.height);
    [vc.view addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         bgView.alpha = 0.3;
                         self.frame = frame;
                     }
                     completion:nil];
}
- (void)hide
{
    CGRect frame = self.frame;
    frame.origin.y = SCREENSIZE.height;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = frame;
        bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [bgView removeFromSuperview];
    }];
    selectedStr = nil;
}

- (void)setDateViewWithTitle:(NSString *)title withBlock:(XPickViewSubmit)block
{
    isDate = YES;
    proTitleList = @[];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, SCREENSIZE.width - 100, 30)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [self getColor:@"FF8000"];
    titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    
    [header addSubview:titleLbl];
    
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 10, 50 ,30)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50 ,30)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self addSubview:header];
    
    // 1.日期Picker
    UIDatePicker *datePickr = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 270)];
    
    datePickr.backgroundColor = [UIColor whiteColor];
    // 1.1选择datePickr的显示风格
    if (_Xhms) {
        [datePickr setDatePickerMode:UIDatePickerModeDateAndTime];
    }else
    {
        [datePickr setDatePickerMode:UIDatePickerModeDate];
    }
    
    
    // 1.2查询所有可用的地区
    //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    
    // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文
    [datePickr setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    // 1.4监听datePickr的数值变化
    [datePickr addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDate *date = [NSDate date];
    
    //如果设置了限制时间
    if (_XfromDate) {
        datePickr.minimumDate = _XfromDate;
    }
    if (_XtoDate) {
        datePickr.maximumDate = _XtoDate;
    }
    if (_XfromNow) {
        datePickr.minimumDate = date;
    }
    // 2.3 将转换后的日期设置给日期选择控件
    //推延5秒作为时间缓冲，如网络差到服务器时可能已经属于“过去”了。
    NSDate *fuda = [NSDate dateWithTimeInterval:5.0 sinceDate:date];
    [datePickr setDate:fuda];
    
    [self addSubview:datePickr];
    
    float height = 300;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
    
    _Sblock = block;
}
- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title withBlock:(XPickViewSubmit)block
{
    isDate = NO;
    proTitleList = items;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, SCREENSIZE.width - 100, 30)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [self getColor:@"FF8000"];
    titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [header addSubview:titleLbl];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 10, 50 ,30)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50 ,30)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self addSubview:header];
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 270)];
    
    pick.delegate = self;
    pick.backgroundColor = [UIColor whiteColor];
    [self addSubview:pick];
    
    float height = 300;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
    _Sblock = block;
}
#pragma mark DatePicker监听方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    // 1.要转换日期格式, 必须得用到NSDateFormatter, 专门用来转换日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 1.1 先设置日期的格式字符串
    if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSLog(@"%@",datePicker.date);
    // 1.2 使用格式字符串, 将日期转换成字符串
    selectedStr = [formatter stringFromDate:datePicker.date];
    NSLog(@"%@",selectedStr);
}
- (void)cancel:(UIButton *)btn
{
    [self hide];
    
}

- (void)submit:(UIButton *)btn
{
        if(isDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            if (_XdataFormate) {
                [formatter setDateFormat:_XdataFormate];
            }else{
                if (_Xhms) {
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                }else
                {
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                }
            }
            NSLog(@"%@",selectedStr);
            if (!selectedStr) {
                selectedStr = [formatter stringFromDate:[NSDate date]];
            }
        } else {
            if([proTitleList count] > 0) {
                if (_Xflag) {
                    selectedStr = [NSString stringWithFormat:@"0#%@",[proTitleList objectAtIndex:0]];
                }else{
                    selectedStr = proTitleList[0];
                }
            }
        }

    _Sblock(selectedStr);
    [self hide];
    
    
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [proTitleList count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_Xflag) {
        selectedStr = [NSString stringWithFormat:@"%ld#%@",(long)row,[proTitleList objectAtIndex:row]];
    }else
    {
        selectedStr = [proTitleList objectAtIndex:row];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [proTitleList objectAtIndex:row];
    
}
- (UIColor *)getColor:(NSString*)hexColor

{
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}

- (CGSize)workOutSizeWithStr:(NSString *)str andFont:(NSInteger)fontSize value:(NSValue *)value{
    CGSize size;
    if (str) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    }
    return size;
}
@end

