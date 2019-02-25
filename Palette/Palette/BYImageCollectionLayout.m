//
//  BYImageCollectionLayout.m
//  Palette
//
//  Created by 白云 on 2019/2/22.
//  Copyright © 2019 白云. All rights reserved.
//

#import "BYImageCollectionLayout.h"

@implementation BYImageCollectionLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = self.collectionView.frame.size;
    self.minimumLineSpacing = 0.0;
    self.minimumInteritemSpacing = 0.0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
