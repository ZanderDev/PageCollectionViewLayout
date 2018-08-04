//
//  PageCollectionViewLayout.m
//  Fashion
//
//  Created by Alpha on 2018/8/4.
//  Copyright © 2018年 Alpha. All rights reserved.
//

#import "PageCollectionViewLayout.h"

static CGFloat itemSpacing = 10;
static CGFloat lineSpacing = 10;

@interface PageCollectionViewLayout()

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSMutableArray *leftArray;

@property (nonatomic, strong) NSMutableDictionary *heigthDic;

@property (nonatomic, strong) NSMutableArray *attributes;

@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end

@implementation PageCollectionViewLayout {
    int _row;
    int _line;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        self.leftArray = [NSMutableArray new];
        self.heigthDic = [NSMutableDictionary new];
        self.attributes = [NSMutableArray new];
    }
    return self;

}

- (void)prepareLayout {

    [super prepareLayout];

    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;

    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;

    CGFloat contentWidth = (width - self.sectionInset.left - self.sectionInset.right);
    if (contentWidth >= (2*itemWidth+self.minimumInteritemSpacing)) { //如果列数大于2行
        int m = (contentWidth-itemWidth)/(itemWidth+self.minimumInteritemSpacing);
        _line = m+1;
        int n = (int)(contentWidth-itemWidth)%(int)(itemWidth+self.minimumInteritemSpacing);
        if (n > 0) {
            double offset = ((contentWidth-itemWidth) - m*(itemWidth+self.minimumInteritemSpacing))/m;
            itemSpacing = self.minimumInteritemSpacing + offset;
        }else if (n == 0){
            itemSpacing = self.minimumInteritemSpacing;
        }
    }else{
        itemSpacing = 0;
    }

    CGFloat contentHeight = (height - self.sectionInset.top - self.sectionInset.bottom);
    if (contentHeight >= (2*itemHeight+self.minimumLineSpacing)) {
        int m = (contentHeight-itemHeight)/(itemHeight+self.minimumLineSpacing);
        _row = m+1;
        int n = (int)(contentHeight-itemHeight)%(int)(itemHeight+self.minimumLineSpacing);
        if (n > 0) {
            double offset = ((contentHeight-itemHeight) - m*(itemHeight+self.minimumLineSpacing))/m;
            lineSpacing = self.minimumLineSpacing + offset;
        }else if (n == 0){
            lineSpacing = self.minimumInteritemSpacing;
        }
    } else{
        lineSpacing = 0;
    }

    int itemNumber = 0;

    itemNumber = itemNumber + (int)[self.collectionView numberOfItemsInSection:0];

    pageNumber = (itemNumber - 1)/(_row*_line) + 1;
}


- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity  {
    CGFloat offsetY = MAXFLOAT;
    CGFloat offsetX = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + self.itemSize.width/2;
    CGFloat verticalCenter = proposedContentOffset.y + self.itemSize.height/2;
    CGRect targetRect = CGRectMake(0, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];

    CGPoint offPoint = proposedContentOffset;
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        if (ABS(itemHorizontalCenter - horizontalCenter) && (ABS(offsetX)>ABS(itemHorizontalCenter - horizontalCenter))) {
            offsetX = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
        if (ABS(itemVerticalCenter - verticalCenter) && (ABS(offsetY)>ABS(itemVerticalCenter - verticalCenter))) {
            offsetY = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
    }
    return offPoint;
}

- (CGSize)collectionViewContentSize {

    return CGSizeMake(self.collectionView.bounds.size.width*pageNumber, self.collectionView.bounds.size.height);
}


static long  pageNumber = 1;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGRect frame;
    frame.size = self.itemSize;
    long number = _row * _line;
    long m = 0;  //初始化 m p
    long p = 0;
    if (indexPath.item >= number) {
        p = indexPath.item/number;  //计算页数不同时的左间距
        m = (indexPath.item%number)/_line;
    }else{
        m = indexPath.item/_line;
    }

    long n = indexPath.item%_line;
    frame.origin = CGPointMake(n*self.itemSize.width+(n)*itemSpacing+self.sectionInset.left+(indexPath.section+p)*self.collectionView.frame.size.width,m*self.itemSize.height + (m)*lineSpacing+self.sectionInset.top);

    attribute.frame = frame;
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int j = 0; j < self.collectionView.numberOfSections; j ++)
    {
        NSInteger count = [self.collectionView numberOfItemsInSection:j];
        for (NSInteger i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributes = tmpAttributes;
    return self.attributes;

}

- (BOOL)ShouldinvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return NO;
}

@end
