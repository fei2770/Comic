//
//  EditBookShelfViewController.m
//  Comic
//
//  Created by vision on 2019/11/29.
//  Copyright © 2019 vision. All rights reserved.
//

#import "EditBookShelfViewController.h"
#import "BookCollectionViewCell.h"

#define kImageW  (kScreenWidth-50)/2.0

@interface EditBookShelfViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UIButton    *allSelBtn;
    UIButton    *deleteBtn;
}

@property (nonatomic,strong) UIView           *navbarView;
@property (nonatomic,strong) UILabel          *titleLabel;
@property (nonatomic,strong) UICollectionView *booksCollectionView;
@property (nonatomic,strong) UIView           *bottomView;

@property (nonatomic,assign) NSInteger   selectedBooksCout;

@end

@implementation EditBookShelfViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    self.selectedBooksCout = 0;
    
    [self.view addSubview:self.navbarView];
    [self.view addSubview:self.booksCollectionView];
    [self.view addSubview:self.bottomView];
    
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myBooksArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCollectionViewCell" forIndexPath:indexPath];
    ShelfBookModel *book = self.myBooksArray[indexPath.row];
    [cell displayCellWithBookModel:book isEditing:YES];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShelfBookModel *book = self.myBooksArray[indexPath.row];
    if (![book.isSelected boolValue]) {
        book.isSelected = [NSNumber numberWithBool:YES];
        self.selectedBooksCout ++;
    }else{
        book.isSelected = [NSNumber numberWithBool:NO];
        self.selectedBooksCout --;
    }
    [self.booksCollectionView reloadData];
    
    self.titleLabel.text = self.selectedBooksCout>0?[NSString stringWithFormat:@"Telah dipilih (%ld)",(long)self.selectedBooksCout]:@"Telah dipilih";
}

#pragma mark -- Event response
#pragma mark 取消
-(void)rightNavigationItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 全选或取消全选
-(void)selectAllBooksAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        for (ShelfBookModel *book in self.myBooksArray) {
            book.isSelected = [NSNumber numberWithBool:YES];
        }
    }else{
        for (ShelfBookModel *book in self.myBooksArray) {
            book.isSelected = [NSNumber numberWithBool:NO];
        }
    }
    [self.booksCollectionView reloadData];
}

#pragma mark 删除
-(void)deleteBooksAction:(UIButton *)sender{
    NSMutableArray *booksArr = [[NSMutableArray alloc] init];
    NSMutableArray *bookIdsArr = [[NSMutableArray alloc] init];
    for (ShelfBookModel *book in self.myBooksArray) {
        if ([book.isSelected boolValue]) {
            [booksArr addObject:book];
            [bookIdsArr addObject:book.book_id];
        }
    }
    NSString *bookIds = [[ComicManager sharedComicManager] getValueWithParams:bookIdsArr];
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_ids":bookIds};
    [[HttpRequest sharedInstance] postWithURLString:kDelBookShelfAPI showLoading:YES parameters:params success:^(id responseObject) {
        [ComicManager sharedComicManager].isBookShelfLoad = YES;
        [self.myBooksArray removeObjectsInArray:booksArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.booksCollectionView reloadData];
            self.titleLabel.text = @"Telah dipilih";
            [self.view makeToast:@"Berhasil menghapus" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
    
}


#pragma mark -- Getters
#pragma mark 导航栏
-(UIView *)navbarView{
    if (!_navbarView) {
        _navbarView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kNavHeight)];
        _navbarView.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:backBtn];
        
        self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, KStatusHeight+12,kScreenWidth-140, 22)];
        self.titleLabel.textColor=[UIColor commonColor_black];
        self.titleLabel.font=[UIFont mediumFontWithSize:18];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.text = @"Telah dipilih";
        [_navbarView addSubview:self.titleLabel];
        
        UIButton *allBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, KStatusHeight+2, 75, 40)];
        [allBtn setTitle:@"Batal" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor colorWithHexString:@"#FF9100"] forState:UIControlStateNormal];
        allBtn.titleLabel.font = [UIFont regularFontWithSize:15.0f];
        [allBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:allBtn];
    }
    return _navbarView;
}

#pragma mark 书籍
-(UICollectionView *)booksCollectionView{
    if (!_booksCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kImageW, kImageW+84);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 20);
        
        _booksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.navbarView.bottom, kScreenWidth, kScreenHeight-kNavHeight-52) collectionViewLayout:layout];
        _booksCollectionView.backgroundColor = [UIColor whiteColor];
        [_booksCollectionView registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
        _booksCollectionView.dataSource = self;
        _booksCollectionView.delegate = self;
    }
    return _booksCollectionView;
}

#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-52, kScreenWidth, 52)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#ECEDF1"];
        [_bottomView addSubview:line];
        
        allSelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth/2.0-20, 42)];
        [allSelBtn setTitle:@"Seluruh Episode" forState:UIControlStateNormal];
        [allSelBtn setTitle:@"Batalkan pilihan semua" forState:UIControlStateSelected];
        [allSelBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        allSelBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        [allSelBtn addTarget:self action:@selector(selectAllBooksAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:allSelBtn];
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0+10, 5, kScreenWidth/2.0-20, 42)];
        [deleteBtn setTitle:@"Hapus" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#FF9100"] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        [deleteBtn addTarget:self action:@selector(deleteBooksAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:deleteBtn];
    }
    return _bottomView;
}

@end
