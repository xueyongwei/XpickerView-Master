//
//  XPickView.h
//
//  Created by 薛永伟 on 15/11/22.
//  Copyright © 2015年 薛永伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XpickView;
typedef void (^XPickViewSubmit)(NSString* resultStr);

@interface XpickView : UIView<UIPickerViewDelegate>
//设置日起的格式
@property (nonatomic,copy)NSString *XdataFormate;
//设置最小可选日期
@property (nonatomic,strong)NSDate *XfromDate;
//设置最大可选日期
@property (nonatomic,strong)NSDate *XtoDate;
//设置只能选择以后的时间
@property (nonatomic,assign)BOOL XfromNow;
//设置是否需要时分秒
@property (nonatomic,assign)BOOL Xhms;
//设置是否需要返回是数组第几个,若为yes返回：下标#内容
@property (nonatomic,assign)BOOL Xflag;

- (void)setDateViewWithTitle:(NSString *)title withBlock:(XPickViewSubmit)block;
- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title withBlock:(XPickViewSubmit)block;
- (void)showXpickViewIn:(UIViewController *)vc;

@end
