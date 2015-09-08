//
//  MagicMoveTransition.m
//  UIViewTransition2
//
//  Created by 史练练 on 15/9/8.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagicMoveTransition.h"
#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "CollectionViewController.h"
#import "ViewController.h"
@interface MagicMoveTransition()<UIViewControllerAnimatedTransitioning>

@end

@implementation MagicMoveTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{

    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    //1、先拿到前后两个viewcontroller 以及 实现动画的容器
    CollectionViewController *fromVC = (CollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC   = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView   *containerView  = [transitionContext containerView];

   //2、 接下来，获得我们需要过渡的 Cell，并且对它上面的 imageView 截图。这个截图就会用在我们的过渡效果中。同时，我们将这个 imageView 本身隐藏，从而让用户以为是 imageView 在移动的。http://www.cnblogs.com/YouXianMing/p/3819545.html

    //对Cell上的 imageView 截图，同时将这个 imageView 本身隐藏
    CollectionViewCell *cell =(CollectionViewCell *)[fromVC.collectionView cellForItemAtIndexPath:[[fromVC.collectionView indexPathsForSelectedItems] firstObject]];
    fromVC.indexPath = [[fromVC.collectionView indexPathsForSelectedItems]firstObject];

    UIView * snapShotView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = fromVC.finalCellRect = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    cell.imageView.hidden = YES;


    //设置第二个控制器的位置、透明度
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.imageViewForSecond.hidden = YES;

    //把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];

    //动起来。第二个控制器的透明度0~1；让截图SnapShotView的位置更新到最新；

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveLinear animations:^{

        toVC.view.alpha = 1.0;
        snapShotView.frame = [containerView convertRect:toVC.imageViewForSecond.frame fromView:toVC.view];

    } completion:^(BOOL finished) {
        //为了让回来的时候，cell上的图片显示，必须要让cell上的图片显示出来
        toVC.imageViewForSecond.hidden = NO;
        cell.imageView.hidden = NO;
        [snapShotView removeFromSuperview];
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}


/**
 *  关于这个参数transitionContext，我额外岔开话题补充一下， 该参数是一个实现了 UIViewControllerContextTransitioning可以让我们访问一些实现过渡所必须的对象。

 UIViewControllerContextTransitioning 协议中有一些方法：

 1、- (UIView *)containerView;    //转场动画发生的容器

 2、- (UIViewController *)viewControllerForKey:(NSString *)key;    // 我们可以通过它拿到过渡的两个 ViewController。

 3  //通过这两个方法，可以获得过度动画前后两个ViewController的frame。
 - (CGRect)initialFrameForViewController:(UIViewController *)vc;
 - (CGRect)finalFrameForViewController:(UIViewController *)vc;

 */



/**
 *  补充知识点：

 IOS－－ UIView中的坐标转换

 // 将像素point由point所在视图转换到目标视图view中，返回在目标视图view中的像素值

 - (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;

 // 将像素point从view中转换到当前视图中，返回在当前视图中的像素值

 - (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;

 // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect

 - (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;

 // 将rect从view中转换到当前视图中，返回在当前视图中的rect

 - (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;

 你可以想像成额外复制了一个图层叠加在原来那个图层上面，但是这个图层是直接加在最底下的 containerView 。 ——————————
 

 */


@end
