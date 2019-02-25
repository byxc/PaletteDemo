//
//  ViewController.m
//  Palette
//
//  Created by 白云 on 2019/2/22.
//  Copyright © 2019 白云. All rights reserved.
//

#import "ViewController.h"
#import "BYImageCollectionCell.h"
#import "UIImage+Palette.h"

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;
@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Palette";
    // 加载资源
    [self loadIamgeSource];
    if (_dataSource.count > 0) {
        [self paletteImageColorWithIndex:0];
    }
}

- (void)loadIamgeSource {
    for (NSInteger i = 1; i < 6; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",i] ofType:@"jpg"];
        if (path) {
            [self.dataSource addObject:path];
        }
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BYImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    UIImage *img = [UIImage imageNamed:self.dataSource[indexPath.item]];
    cell.imageView.image = img;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self calculatePageIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self calculatePageIndex];
}

#pragma mark - calculate
- (void)calculatePageIndex {
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat contentW = CGRectGetWidth(self.collectionView.frame);
    self.pageIndex = contentOffset.x/contentW;
}

- (void)paletteImageColorWithIndex:(NSUInteger)index {
    if (index >= _dataSource.count) {
        return;
    }
    UIImage *img = [UIImage imageNamed:self.dataSource[index]];
//    [img getPaletteImageColor:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
//        NSString *hex = recommendColor.imageColorString;
//        [self configNavigationColor:[self hexColor:hex]];
//    }];
    
    [img getPaletteImageColorWithMode:DEFAULT_NON_MODE_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
        NSString *hex = recommendColor.imageColorString;
        [self configNavigationColor:[self hexColor:hex]];
    }];
}

#pragma mark - Navigation Color
- (void)configNavigationColor:(UIColor *)color {
    self.navigationController.navigationBar.barTintColor = color;
//    BYImageCollectionCell *cell = (BYImageCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageIndex inSection:0]];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.view.backgroundColor = color;
//        cell.backgroundColor = color;
//    }];
}

#pragma mark - Hex Color
- (UIColor *)hexColor:(NSString *)hex {
    UIColor *color = nil;
    NSString *colorHex = hex;
    if ([hex hasPrefix:@"#"]) {
        colorHex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    NSRange range = NSMakeRange(0, 2);
    NSString *hexR = [colorHex substringWithRange:range];
    range.location = 2;
    NSString *hexG = [colorHex substringWithRange:range];
    range.location = 4;
    NSString *hexB = [colorHex substringWithRange:range];
    
    unsigned int r,g,b;
    
    [[NSScanner
      scannerWithString:hexR] scanHexInt:&r];
    [[NSScanner
      scannerWithString:hexG] scanHexInt:&g];
    [[NSScanner
      scannerWithString:hexB] scanHexInt:&b];
    
    color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return color;
}

#pragma mark - Setter && Getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setPageIndex:(NSUInteger)pageIndex {
    if (pageIndex != _pageIndex && 0 <= pageIndex && _dataSource.count > pageIndex ) {
        _pageIndex = pageIndex;
        [self paletteImageColorWithIndex:pageIndex];
    }
}

@end
