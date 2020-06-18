//
//  ZWReleaseSpellList04View.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/4.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWReleaseSpellList04View.h"
#import <YYTextView.h>
#import "ZWAreaManager.h"
#import "ZWMineSpellListManager.h"
#import "ZWMineSaveSpellListAction.h"

@interface ZWReleaseSpellList04View()<UITableViewDelegate, UITableViewDataSource, CSDateManagerDelegate, YYTextViewDelegate, ZWAreaManagerDelegate>
@property(nonatomic, strong)TPKeyboardAvoidingTableView *tableView;
@property(nonatomic, strong)UITextField *decorateStratData;
@property(nonatomic, strong)UITextField *decorateEndData;
@property(nonatomic, strong)UITextField *sepllInvalidDate;
@property(nonatomic, strong)UITextField *cityText;
@property(nonatomic, strong)UILabel *demandLabel;
@property(nonatomic, strong)UILabel *noteLabel;
@property(nonatomic, strong)UILabel *labelCount;
@property(nonatomic, strong)ZWSpellListModel *model;
@property(nonatomic, assign)NSInteger type;//0为发布 1为编辑
@end
@implementation ZWReleaseSpellList04View

-(TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStyleGrouped];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame withModel:(ZWSpellListModel *)model withType:(NSInteger)type;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.type = type;
        [self addSubview:self.tableView];
        [self createNotice];
    }
    return self;
}

- (void)setSelectType:(NSString *)selectType {
    if (self.model.type.length == 0) {
        self.model.type = selectType;
        
        NSDictionary *mydic = [[ZWMineSaveSpellListAction shareAction]takeSixSpellList];
        NSLog(@"%@",mydic);
        NSString *sepllTitle = mydic[@"title"];
        if (self.model.title.length == 0) {
            if(sepllTitle.length > 0) {
//                self.model = [ZWSpellListModel parseJSON:mydic];
                self.model = [ZWSpellListModel mj_objectWithKeyValues:mydic];
            }
        }
        [self.tableView reloadData];

    }
}

- (void)createNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotification:) name:YYTextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:YYTextViewTextDidChangeNotification object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 9;
    }else if (section == 1) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    [self createTableViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)createTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.section == 0) {
        
        NSArray *titleArray = @[@"标题：",@"展会名称：",@"展馆名称：",@"布展时间：",@"撤展时间：",@"城市：",@"出发地：",@"目的地：",@"截止时间："];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.18*kScreenWidth, 0.1*kScreenWidth)];
        titleLabel.font = smallMediumFont;
        titleLabel.text = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        titleLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:titleLabel textAlignmentWith:0.18*kScreenWidth];
        
        if (indexPath.row == 0) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"请输入标题";
            valueText.text = self.model.title;
            valueText.tag = indexPath.row;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            valueText.font = smallMediumFont;
            [cell.contentView addSubview:valueText];
            
            self.labelCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(valueText.frame), 0, 0.15*kScreenWidth, 0.1*kScreenWidth)];
            self.labelCount.text = [NSString stringWithFormat:@"(%lu/20)",(unsigned long)self.model.title.length];
            self.labelCount.font = smallMediumFont;
            [cell.contentView addSubview:self.labelCount];
        }else if (indexPath.row == 1) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"请输入展馆名称";
            valueText.font = smallMediumFont;
            valueText.text = self.model.exhibitionName;
            valueText.tag = indexPath.row;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }else if (indexPath.row == 2) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"请输入展馆名称";
            valueText.font = smallMediumFont;
            valueText.text = self.model.exhibitionHall;
            valueText.tag = indexPath.row;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }else if (indexPath.row == 3) {
            
            UIView *rightView01 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.06*kScreenWidth, 0.06*kScreenWidth)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.01*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth, 0.04*kScreenWidth)];
            imageView.image = [UIImage imageNamed:@"calendar_icon"];
            [rightView01 addSubview:imageView];
            
            self.decorateStratData = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0.02*kScreenWidth, 0.3*kScreenWidth, 0.06*kScreenWidth)];
            self.decorateStratData.placeholder = @"例2020-02-18";
            if (self.model.decorateStartTime.length>=10) {
                self.decorateStratData.text = [self.model.decorateStartTime substringWithRange:NSMakeRange(0, 10)];
            }
            self.decorateStratData.tag = 1001;
            self.decorateStratData.textAlignment = NSTextAlignmentCenter;
            self.decorateStratData.font = smallFont;
            self.decorateStratData.layer.cornerRadius = 3;
            self.decorateStratData.layer.masksToBounds = YES;
            self.decorateStratData.layer.borderColor = [UIColor blackColor].CGColor;
            self.decorateStratData.layer.borderWidth = 1;
            self.decorateStratData.rightView = rightView01;
            self.decorateStratData.rightViewMode = UITextFieldViewModeAlways;
            self.decorateStratData.enabled = YES;
            [cell.contentView addSubview:self.decorateStratData];
            
            UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDateClick:)];
            [self.decorateStratData addGestureRecognizer:tapThree];

        }else if (indexPath.row == 4) {
            
            UIView *rightView01 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.06*kScreenWidth, 0.06*kScreenWidth)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.01*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth, 0.04*kScreenWidth)];
            imageView.image = [UIImage imageNamed:@"calendar_icon"];
            [rightView01 addSubview:imageView];
            
            self.decorateEndData = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0.02*kScreenWidth, 0.3*kScreenWidth, 0.06*kScreenWidth)];
            self.decorateEndData.placeholder = @"例2020-02-18";
            if (self.model.decorateEndTime.length>=10) {
                self.decorateEndData.text = [self.model.decorateEndTime substringWithRange:NSMakeRange(0, 10)];
            }
            self.decorateEndData.tag = 1002;
            self.decorateEndData.textAlignment = NSTextAlignmentCenter;
            self.decorateEndData.font = smallFont;
            self.decorateEndData.layer.cornerRadius = 3;
            self.decorateEndData.layer.masksToBounds = YES;
            self.decorateEndData.layer.borderColor = [UIColor blackColor].CGColor;
            self.decorateEndData.layer.borderWidth = 1;
            self.decorateEndData.rightView = rightView01;
            self.decorateEndData.rightViewMode = UITextFieldViewModeAlways;
            self.decorateEndData.enabled = YES;
            [cell.contentView addSubview:self.decorateEndData];
            
            UITapGestureRecognizer *tapFive = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDateClick:)];
            [self.decorateEndData addGestureRecognizer:tapFive];
            
        }else if (indexPath.row == 5) {
            self.cityText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            self.cityText.placeholder = @"点击选择城市";
            self.cityText.text = self.model.city;
            self.cityText.font = smallMediumFont;
            self.cityText.enabled = NO;
            self.cityText.textColor = skinColor;
            [cell.contentView addSubview:self.cityText];
        }else if (indexPath.row == 6) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"点击输入出发地";
            valueText.font = smallMediumFont;
            valueText.text = self.model.origin;
            valueText.tag = indexPath.row;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }else if (indexPath.row == 7) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"点击输入目的地";
            valueText.font = smallMediumFont;
            valueText.text = self.model.destination;
            valueText.tag = indexPath.row;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }else {
            UIView *rightView02 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.06*kScreenWidth, 0.06*kScreenWidth)];
            UIImageView *imageView02 = [[UIImageView alloc]initWithFrame:CGRectMake(0.01*kScreenWidth, 0.01*kScreenWidth, 0.04*kScreenWidth, 0.04*kScreenWidth)];
            imageView02.image = [UIImage imageNamed:@"calendar_icon"];
            [rightView02 addSubview:imageView02];
            
            self.sepllInvalidDate = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0.02*kScreenWidth, 0.3*kScreenWidth, 0.06*kScreenWidth)];
            self.sepllInvalidDate.placeholder = @"例2020-02-18";
            if (self.model.invalidTime.length>=10) {
                self.sepllInvalidDate.text = [self.model.invalidTime substringWithRange:NSMakeRange(0, 10)];
            }
            self.sepllInvalidDate.tag = 1003;
            self.sepllInvalidDate.textAlignment = NSTextAlignmentCenter;
            self.sepllInvalidDate.font = smallFont;
            self.sepllInvalidDate.layer.cornerRadius = 3;
            self.sepllInvalidDate.layer.masksToBounds = YES;
            self.sepllInvalidDate.layer.borderColor = [UIColor blackColor].CGColor;
            self.sepllInvalidDate.layer.borderWidth = 1;
            self.sepllInvalidDate.rightView = rightView02;
            self.sepllInvalidDate.rightViewMode = UITextFieldViewModeAlways;
            self.sepllInvalidDate.enabled = YES;
            [cell.contentView addSubview:self.sepllInvalidDate];
            
            UITapGestureRecognizer *tapFour = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDateClick:)];
            [self.sepllInvalidDate addGestureRecognizer:tapFour];
        }
    }else if (indexPath.section == 1) {
        
        NSArray *titleArray = @[@"联系人：",@"联系方式："];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0, 0.18*kScreenWidth, 0.1*kScreenWidth)];
        titleLabel.font = smallMediumFont;
        titleLabel.text = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        titleLabel.attributedText = [[ZWToolActon shareAction]createBothEndsWithLabel:titleLabel textAlignmentWith:0.18*kScreenWidth];
        
        if (indexPath.row == 0) {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"请输入联系人姓名";
            valueText.font = smallMediumFont;
            valueText.tag = 100+indexPath.row;
            valueText.text = self.model.contacts;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }else {
            UITextField *valueText = [[UITextField alloc]initWithFrame:CGRectMake(0.205*kScreenWidth, 0, 0.65*kScreenWidth, 0.1*kScreenWidth)];
            valueText.placeholder = @"请输入联系方式";
            valueText.font = smallMediumFont;
            valueText.tag = 100+indexPath.row;
            valueText.text = self.model.telephone;
            valueText.keyboardType = UIKeyboardTypeNumberPad;
            [valueText addTarget:self action:@selector(valueText:) forControlEvents:UIControlEventAllEditingEvents];
            [cell.contentView addSubview:valueText];
        }
        
    }else if (indexPath.section == 2) {
        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.025*kScreenWidth, 0.95*kScreenWidth, 0.1*kScreenWidth)];
        textView.placeholderText = @"点击输入需求";
        textView.text = self.model.requirement;
        textView.delegate = self;
        textView.placeholderFont = smallMediumFont;
        textView.tag = 1;
        textView.font = smallMediumFont;
        [cell.contentView addSubview:textView];
    }else {
        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.025*kScreenWidth, 0.95*kScreenWidth, 0.1*kScreenWidth)];
        textView.placeholderText = @"点击输入备注";
        textView.text = self.model.remarks;
        textView.delegate = self;
        textView.tag = 2;
        textView.placeholderFont = smallMediumFont;
        textView.font = smallMediumFont;
        [cell.contentView addSubview:textView];
    }
}

- (void)tapDateClick:(UITapGestureRecognizer *)gesture {
    [[CSDateManager shareManager]showPickerView:self.ff_navViewController withModeIndex:1 withIndex:gesture.view.tag];
    [CSDateManager shareManager].delegate = self;
}
-(void)takeDateWithStr:(NSString *)date withIndex:(NSInteger)index {
    if (index == 1001) {
        self.model.decorateStartTime = date;
        self.decorateStratData.text = date;
    }else if (index == 1002) {
        self.model.decorateEndTime = date;
        self.decorateEndData.text = date;
    }else {
        self.model.invalidTime = date;
        self.sepllInvalidDate.text = date;
    }
}

- (void)actionSheetPickerView:(nonnull IQActionSheetPickerView *)pickerView didSelectDate:(nonnull NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dataStr = [formatter stringFromDate:date];
    if (pickerView.tag == 1001) {
        self.model.decorateStartTime = dataStr;
        self.decorateStratData.text = dataStr;
    }else if (pickerView.tag == 1002) {
        self.model.decorateEndTime = dataStr;
        self.decorateEndData.text = dataStr;
    }else {
        self.model.invalidTime = dataStr;
        self.sepllInvalidDate.text = dataStr;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 0.2*kScreenWidth;
    }else if (indexPath.section == 3) {
        return 0.2*kScreenWidth;
    }else {
        return 0.1*kScreenWidth;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.08*kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0.3*kScreenWidth+zwTabBarHeight;
    }else {
        return 0.1;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (section == 3) {
        if (self.type == 0) {
            UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake(0.025*kScreenWidth, 0.1*kScreenWidth, 0.95*kScreenWidth, 0.1*kScreenWidth);
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
            [saveBtn setTitleColor:skinColor forState:UIControlStateNormal];
            saveBtn.titleLabel.font = normalFont;
            saveBtn.layer.cornerRadius = 3;
            saveBtn.layer.masksToBounds = YES;
            saveBtn.layer.borderWidth = 1;
            saveBtn.layer.borderColor = skinColor.CGColor;
            [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:saveBtn];
        }

        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(0.025*kScreenWidth, 0.25*kScreenWidth, 0.95*kScreenWidth, 0.1*kScreenWidth);
        [submitBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = normalFont;
        submitBtn.backgroundColor = skinColor;
        submitBtn.layer.cornerRadius = 3;
        submitBtn.layer.masksToBounds = YES;
        [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:submitBtn];
    }
    return view;
}

- (void)saveBtnClick:(UIButton *)btn {
    
    NSLog(@"index = %@",self.model.type);
    
    if (self.model.title.length == 0) {
        [self showAlertWithMessage:@"标题不能为空"];
        return;
    }
    
    NSDictionary *mydic =  [[ZWToolActon shareAction]dicFromObject:self.model];
    [[ZWMineSaveSpellListAction shareAction]saveSixSpellList:mydic];
    [self showAlertWithMessage:@"已保存到本地"];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (section == 0) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.03*kScreenWidth, 0.95*kScreenWidth, 0.05*kScreenWidth)];
        titleLabel.text = @"基本信息";
        titleLabel.font = boldSmallMediumFont;
        [view addSubview:titleLabel];
    }else if (section == 1) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.03*kScreenWidth, 0.95*kScreenWidth, 0.05*kScreenWidth)];
        titleLabel.text = @"联系方式";
        titleLabel.font = boldSmallMediumFont;
        [view addSubview:titleLabel];
    }else if (section == 2) {
        self.demandLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.03*kScreenWidth, 0.95*kScreenWidth, 0.05*kScreenWidth)];
        self.demandLabel.text = [NSString stringWithFormat:@"需求(%lu/30)",(unsigned long)self.model.requirement.length];
        self.demandLabel.font = boldSmallMediumFont;
        [view addSubview:self.demandLabel];
    }else {
        self.noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*kScreenWidth, 0.03*kScreenWidth, 0.95*kScreenWidth, 0.05*kScreenWidth)];
        self.noteLabel.text = [NSString stringWithFormat:@"备注(%lu/30)",(unsigned long)self.model.remarks.length];
        self.noteLabel.font = boldSmallMediumFont;
        [view addSubview:self.noteLabel];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        [[ZWAreaManager shareManager]areaSelectionShow:self.ff_navViewController];
        [ZWAreaManager shareManager].delegate = self;
    }
}

- (void)accessToAreas:(NSDictionary *)dic {
    NSLog(@"我的区域=%@",dic);
    NSDictionary *city;
    if (dic[@"city"]) {
        city = dic[@"city"];
    }else {
        city = dic[@"country"];
    }
    self.cityText.text = city[@"value"];
    self.model.city = city[@"value"];
}

//*********************************************************参数收集*****************************************************************/

- (void)valueText:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag == 0) {
        [self limitedNumberWithText:textField];
    }else if (textField.tag == 1) {
        self.model.exhibitionName = textField.text;
    }else if (textField.tag == 2) {
        self.model.exhibitionHall = textField.text;
    }else if (textField.tag == 3) {
        
    }else if (textField.tag == 4) {
        
    }else if (textField.tag == 5) {
    
    }else if (textField.tag == 6) {
        self.model.origin = textField.text;
    }else if (textField.tag == 7) {
        self.model.destination = textField.text;
    }else if (textField.tag == 8) {

    }else if (textField.tag == 100) {
        self.model.contacts = textField.text;
    }else if (textField.tag == 101) {
        self.model.telephone = textField.text;
    }
}

- (void)limitedNumberWithText:(UITextField *)textField {
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 20)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:20];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:20];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 20)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    NSLog(@"%@",textField.text);
    self.model.title = textField.text;
    self.labelCount.text = [NSString stringWithFormat:@"(%lu/20)",(unsigned long)textField.text.length];
}

- (void)textViewDidChange:(YYTextView *)textView {
    NSLog(@"------%@",textView.text);
    if (textView.tag == 1) {
        self.model.requirement = textView.text;
        self.demandLabel.text = [NSString stringWithFormat:@"需求(%lu/30)",(unsigned long)self.model.requirement.length];
    }else {
        self.model.remarks = textView.text;
        self.noteLabel.text = [NSString stringWithFormat:@"备注(%lu/30)",(unsigned long)self.model.remarks.length];
    }
}

-(void)textViewDidChangeNotification:(NSNotification *)obj{
    YYTextView *textView = (YYTextView *)obj.object;
    NSString *string = textView.text;
    NSInteger maxLength = 30;
    //获取高亮部分
    YYTextRange *selectedRange = [textView valueForKey:@"_markedTextRange"];
    NSRange range = [selectedRange asRange];
    NSString *realString = [string substringWithRange:NSMakeRange(0, string.length - range.length)];
    if (realString.length >= maxLength){
        textView.text = [realString substringWithRange:NSMakeRange(0, maxLength)];
    }
}

//提交数据
- (void)submitBtnClick:(UIButton *)btn {
    if (self.model.title.length == 0) {
        [self showAlertWithMessage:@"拼单名称不能为空"];
        return;
    }
    if (self.model.exhibitionName.length == 0) {
        [self showAlertWithMessage:@"展会名称不能为空"];
        return;
    }
    if (self.model.exhibitionHall.length == 0) {
        [self showAlertWithMessage:@"展馆名称不能为空"];
        return;
    }
    if (self.model.decorateStartTime.length == 0) {
        [self showAlertWithMessage:@"请选择布展日期"];
        return;
    }
    if (self.model.decorateEndTime.length == 0) {
        [self showAlertWithMessage:@"请选择撤展日期"];
        return;
    }
    if (self.model.city.length == 0) {
        [self showAlertWithMessage:@"请选择城市"];
        return;
    }
    if (self.model.origin.length == 0) {
        [self showAlertWithMessage:@"出发地不能为空"];
        return;
    }
    if (self.model.destination.length == 0) {
        [self showAlertWithMessage:@"目的地不能为空"];
        return;
    }
    if (self.model.invalidTime.length == 0) {
        [self showAlertWithMessage:@"请选择拼单截止日期"];
        return;
    }
    if (self.model.contacts.length == 0) {
        [self showAlertWithMessage:@"联系人不能为空"];
        return;
    }
    if (self.model.telephone.length == 0) {
        [self showAlertWithMessage:@"联系人电话不能为空"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"是否确认提交？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.type == 0) {
            [strongSelf submitData];
        }else {
            [strongSelf updateData];
        }
    } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
        
    } showInView:self.ff_navViewController];
}

- (void)showAlertWithMessage:(NSString *)message {
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:self.ff_navViewController] ;
}

- (void)submitData {
    NSDictionary *mydic =  [[ZWToolActon shareAction]dicFromObject:self.model];
    if (mydic) {
        NSLog(@"%@,",mydic);
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwUploadMySpellList parametes:mydic successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [strongSelf removeLocationSepllList];
                [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:@"发布成功" confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
                    if ([[ZWMineSpellListManager shareManager].delegate respondsToSelector:@selector(popToViewControllers:)]) {
                        [[ZWMineSpellListManager shareManager].delegate popToViewControllers:YES];
                    }
                } showInView:strongSelf.ff_navViewController];
            }else {
                [strongSelf showAlertWithMessage:@"发布失败，请稍后再试或联系客服"];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self];
    }
}

- (void)removeLocationSepllList {
    [[ZWMineSaveSpellListAction shareAction]removeSixSpellList];
}

- (void)updateData {
    NSDictionary *mydic =  [[ZWToolActon shareAction]dicFromObject:self.model];
    NSMutableDictionary * myParametes = [[NSMutableDictionary alloc] init];
    [myParametes setValue:self.model.spellId forKey:@"id"];
    [myParametes addEntriesFromDictionary:mydic];
    if (mydic) {
        __weak typeof (self) weakSelf = self;
        [[ZWDataAction sharedAction]postReqeustWithURL:zwUpDateMySpellList parametes:myParametes successBlock:^(NSDictionary * _Nonnull data) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (zw_issuccess) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshSepllListData" object:nil];
                UIViewController *vc = self.ff_navViewController.viewControllers[1];
                [self.ff_navViewController popToViewController:vc animated:YES];
                [strongSelf showAlertWithMessage:@"发布成功"];
            }else {
                [strongSelf showAlertWithMessage:@"发布失败，请稍后再试或联系客服"];
            }
        } failureBlock:^(NSError * _Nonnull error) {

        } showInView:self];
    }
}



@end
