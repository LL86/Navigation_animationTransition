//
//  CollectionViewController.h
//  UIViewTransition2
//
//  Created by 史练练 on 15/9/8.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewCell;
@interface CollectionViewController : UICollectionViewController

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)CGRect finalCellRect;

@end
