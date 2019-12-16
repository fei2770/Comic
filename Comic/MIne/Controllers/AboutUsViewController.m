//
//  AboutUsViewController.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic,strong) UILabel *tipsLab;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Tentang Kami";
    
    [self.view addSubview:self.tipsLab];
}

-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20,kNavHeight+30, kScreenWidth-40,180)];
        _tipsLab.font = [UIFont regularFontWithSize:14.0f];
        _tipsLab.textColor = [UIColor commonColor_black];
        _tipsLab.text = @"\t Pulau komik adalah aplikasi membaca komik di ponsel yang bisa dibuka dimana saja, di dalamnya terdapat banyak komik yang resmi, berkualitas bagus, dan berwarna-warni, di sini kamu bisa membaca komik sepuasmu tanpa henti, kami setiap harinya akan menyediakan untukmu bermacam-macam komik terbaru, kamu bisa membaca komik kapanpun dan dimanapun sesukamu";
        _tipsLab.numberOfLines = 0;
    }
    return _tipsLab;
}

@end
