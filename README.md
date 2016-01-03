<<<<<<< HEAD
# xPickerView-Master
alloc init之后通过
- (void)setDateViewWithTitle:(NSString *)title
withBlock:(XPickViewSubmit)block;

- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title
withBlock:(XPickViewSubmit)block;
设置时间或者数据选择器。
在回调里返回选择的时间或数据。
时间选取器可通过设置以下属性：
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

数据选取器可设置一下属性
//设置是否需要返回是数组第几个,若为yes返回：下标#内容
@property (nonatomic,assign)BOOL Xflag;
=======
# XpickerView-Master
>>>>>>> origin/master
