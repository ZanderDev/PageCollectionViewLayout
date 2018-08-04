//
//  PageCollectionViewLayout.h
//  Fashion
//
//  Created by Alpha on 2018/8/4.
//  Copyright © 2018年 Alpha. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 横向滑动，横向分页展示数据
 */

@interface PageCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing; //行间距

@property (nonatomic) CGFloat minimumInteritemSpacing; //item间距

@property (nonatomic) CGSize itemSize; //item大小

@property (nonatomic) UIEdgeInsets sectionInset;

- (instancetype)init;

@end


//let layout = PageCollectionViewLayout()
//layout?.itemSize = CGSize(width: 94.0/2, height: 94.0/2)
//layout?.sectionInset = UIEdgeInsetsMake(2, 10, 4, 10)
//layout?.minimumLineSpacing = 0
//layout?.minimumInteritemSpacing = 0
//
//guard let viewLayout = layout else {
//    return
//}
//
//let collectionV = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 105), collectionViewLayout:viewLayout)
//collectionV.delegate = self
//collectionV.dataSource = self
//collectionV.isPagingEnabled = true
//collectionV.bounces = true
//collectionV.alwaysBounceHorizontal = true
//collectionV.showsHorizontalScrollIndicator = false
//collectionV.showsVerticalScrollIndicator = false
//collectionV.register(UINib.init(nibName: "CellName", bundle: nil), forCellWithReuseIdentifier: "CellName")
//collectionV.backgroundColor = UIColor.white
//collection = collectionV
//self.addSubview(collectionV)
