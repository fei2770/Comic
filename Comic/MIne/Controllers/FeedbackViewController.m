//
//  FeedbackViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UILabel          *tipsLabel;
@property (nonatomic,strong) UITextView       *myTextView;
@property (nonatomic,strong) UILabel          *contactLabel;           //联系方式标题
@property (nonatomic,strong) UITextField      *contactTextField;       //联系方式
@property (nonatomic,strong) UIButton          *submitBtn;          //提交

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Pendapat dan Umpan balik";
    
    [self initFeedbackView];
    
}

#pragma mark--UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==self.myTextView) {
        if ([textView isFirstResponder]) {
            if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
                return NO;
            }
            
            //判断键盘是不是九宫格键盘
            if ([[ComicManager sharedComicManager] isNineKeyBoard:text] ){
                return YES;
            }else{
                if ([[ComicManager sharedComicManager] hasEmoji:text] || [[ComicManager sharedComicManager] strIsContainEmojiWithStr:text]){
                    return NO;
                }
            }
        }
        
        if ([textView.text length]+text.length>200) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.contactTextField resignFirstResponder];
    return YES;
}

#pragma mark -- event response
-(void)submitFeedbackAction{
    if (kIsEmptyString(self.myTextView.text)) {
        [self.view makeToast:@"Feedback tidak boleh kosong" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *params = @{@"token":kUserTokenValue,@"content":self.myTextView.text,@"contact":kIsEmptyString(self.contactTextField.text)?@"":self.contactTextField.text};
    [[HttpRequest sharedInstance] postWithURLString:kFeedbackAPI showLoading:YES parameters:params success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"Feedback anda telah dikirimkan" duration:1.0 position:CSToastPositionCenter];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
    
}

#pragma mark -- Private methods
#pragma mark 界面初始化
-(void)initFeedbackView{
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.myTextView];
    [self.view addSubview:self.contactLabel];
    [self.view addSubview:self.contactTextField];
    [self.view addSubview:self.submitBtn];
}

#pragma mark -- Getters
#pragma mark 说明
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, kNavHeight+20, kScreenWidth-35, 40)];
        _tipsLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?12.0:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = @"Berikan kontak informasi, Staf kami akan mengurus saran anda";
    }
    return _tipsLabel;
}

#pragma mark 意见
-(UITextView *)myTextView{
    if (!_myTextView) {
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, self.tipsLabel.bottom+10, kScreenWidth-50, 150)];
        _myTextView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        _myTextView.delegate = self;
        _myTextView.font = [UIFont regularFontWithSize:14.0f];
        _myTextView.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _myTextView.layer.borderColor = [UIColor colorWithHexString:@"#EEEFF2"].CGColor;
        _myTextView.layer.borderWidth = 1.0;
        _myTextView.zw_limitCount = 100;
        _myTextView.zw_placeHolder =  @"Silahkan tuliskan pendapat dan saran anda";
    }
    return _myTextView;
}

#pragma mark 联系方式标题
-(UILabel *)contactLabel{
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.myTextView.bottom+20,kScreenWidth-50, 20)];
        _contactLabel.font = [UIFont regularFontWithSize:14.0f];
        _contactLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _contactLabel.text = @"Kontak informasi (pilih)";
    }
    return _contactLabel;
}

#pragma mark 联系方式
-(UITextField *)contactTextField{
    if (!_contactTextField) {
        _contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(25, self.contactLabel.bottom+10, kScreenWidth-50, 38)];
        _contactTextField.font = [UIFont regularFontWithSize:14.0f];
        _contactTextField.textColor = [UIColor commonColor_black];
        _contactTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 38)];
        _contactTextField.leftViewMode = UITextFieldViewModeAlways;
        _contactTextField.layer.borderColor = [UIColor colorWithHexString:@"#EEEFF2"].CGColor;
        _contactTextField.layer.borderWidth = 1.0;
        _contactTextField.returnKeyType = UIReturnKeyDone;
        _contactTextField.delegate = self;
        _contactTextField.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        _contactTextField.placeholder = @"Kami bisa menghubungi anda dengan (email,telepon, Wahtsapp)";
    }
    return _contactTextField;
}

#pragma mark 提交
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, kScreenHeight-65, kScreenWidth-70, 40)];
        _submitBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_submitBtn.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#C66CFF"] endColor:[UIColor colorWithHexString:@"#636FFF"]];
        [_submitBtn setTitle:@"Kirim" forState:UIControlStateNormal];
        [_submitBtn setBorderWithCornerRadius:8.0 type:UIViewCornerTypeAll];
        _submitBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitFeedbackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


@end
