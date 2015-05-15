//
//  PWHomeViewController.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright (c) 2015 Pawel Weglewski. All rights reserved.
//

#import "PWHomeViewController.h"
#import "PWDataManager.h"
#import <JGProgressHUD.h>
#import <I3DragDataSource.h>
#import <UICollectionView+I3Collection.h>
#import <I3GestureCoordinator.h>
#import "FunkRenderDelegate.h"
#import "PWHomeCollectionViewCell.h"

@interface PWHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, I3DragDataSource>
@property (nonatomic, strong) JGProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *middleCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *sourceCollection;

@property (nonatomic, strong) I3GestureCoordinator *dragCoordinator;


@property (weak, nonatomic) IBOutlet UIView *deleteView;
@end

#pragma mark - UIViewController Lifecycle
@implementation PWHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak PWHomeViewController *weakSelf = self;
    [[RACObserve([PWDataManager sharedInstance], board.updated) skip:1] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud dismiss];
            [self.leftCollection reloadData];
            [self.middleCollection reloadData];
            [self.rightCollection reloadData];
        });
    }];
    self.dragCoordinator = [I3GestureCoordinator basicGestureCoordinatorFromViewController:self withCollections:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection] withRecognizer:[UILongPressGestureRecognizer new]];
    self.dragCoordinator.renderDelegate = [[FunkRenderDelegate alloc]initWithPotentialDstViews:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection, self.deleteView] andDeleteArea:self.deleteView];
    I3BasicRenderDelegate *renderDelegate = (I3BasicRenderDelegate *)self.dragCoordinator.renderDelegate;
    renderDelegate.draggingItemOpacity = 0.4;
//    [self.hud showInView:self.view];
    [[PWDataManager sharedInstance] getWholeBoard];
}

#pragma mark - Getters for lazy instantiation

- (JGProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
        _hud.textLabel.text = LocString(@"Loading...");
    }
    return _hud;
}

//- (I3GestureCoordinator *)dragCoordinator
//{
//    if (!_dragCoordinator) {
//        _dragCoordinator = [I3GestureCoordinator basicGestureCoordinatorFromViewController:self withCollections:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection] withRecognizer:[UILongPressGestureRecognizer new]];
//        _dragCoordinator.renderDelegate = [[FunkRenderDelegate alloc]initWithPotentialDstViews:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection, self,_deleteView] andDeleteArea:self.deleteView];
//    }
//    return _dragCoordinator;
//}

#pragma mark - Helper Stuff

-(NSMutableArray *)dataForCollectionView:(UIView *)collectionView{
    
    NSMutableArray *data = nil;
    
    if(collectionView == self.leftCollection){
        data = [PWDataManager sharedInstance].board.toDoList.cards;
    }
    else if(collectionView == self.middleCollection){
        data = [PWDataManager sharedInstance].board.doingList.cards;
    }
    else if(collectionView == self.rightCollection){
        data = [PWDataManager sharedInstance].board.doneList.cards;
    } else {
        data = [@[@111]mutableCopy];
    }
    
    return data;
}

-(BOOL) isPointInDeletionArea:(CGPoint) point fromView:(UIView *)view{
    
    CGPoint localPoint = [self.deleteView convertPoint:point fromView:view];
    return [self.deleteView pointInside:localPoint withEvent:nil];
}


#pragma mark - UICollectionDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section{
    return [[self dataForCollectionView:collectionView] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PWHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    NSArray *data = [self dataForCollectionView:collectionView];
    __weak PWCard *card = [data objectAtIndex:indexPath.row];
    [cell setupWithCard:card];
    return cell;
    
}

#pragma mark - I3DragDataSource


- (BOOL) canItemBeDraggedAt:(NSIndexPath *)at inCollection:(UIView<I3Collection> *)collection
{
    return YES;
}


- (BOOL) canItemFrom:(NSIndexPath *)from beRearrangedWithItemAt:(NSIndexPath *)to inCollection:(UIView<I3Collection> *)collection
{
    return YES;
}


- (BOOL) canItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection beDroppedTo:(NSIndexPath *)to onCollection:(UIView<I3Collection> *)toCollection
{
    return YES;
}


- (BOOL) canItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection beDroppedAtPoint:(CGPoint)at onCollection:(UIView<I3Collection> *)toCollection
{
    return ![self isPointInDeletionArea:at fromView:toCollection];
}


- (BOOL) canItemAt:(NSIndexPath *)from beDeletedFromCollection:(UIView<I3Collection> *)collection atPoint:(CGPoint)to
{
    return [self isPointInDeletionArea:to fromView:self.view];
}


- (void) deleteItemAt:(NSIndexPath *)at inCollection:(UIView<I3Collection> *)collection
{
    NSMutableArray *fromData = [self dataForCollectionView:collection];
    
    [fromData removeObjectAtIndex:at.row];
    [collection deleteItemsAtIndexPaths:@[at]];
}


- (void) rearrangeItemAt:(NSIndexPath *)from withItemAt:(NSIndexPath *)to inCollection:(UIView<I3Collection> *)collection
{
    NSMutableArray *targetData = [self dataForCollectionView:collection];
    
    [targetData exchangeObjectAtIndex:to.row withObjectAtIndex:from.row];
    [collection reloadItemsAtIndexPaths:@[to, from]];
}


- (void) dropItemAt:(NSIndexPath *)fromIndex fromCollection:(UIView<I3Collection> *)fromCollection toItemAt:(NSIndexPath *)toIndex onCollection:(UIView<I3Collection> *)toCollection
{
    NSMutableArray *fromData = [self dataForCollectionView:fromCollection];
    NSMutableArray *toData = [self dataForCollectionView:toCollection];
    
    PWCard *exchangingCard = [fromData objectAtIndex:fromIndex.row];
    
    [fromData removeObjectAtIndex:fromIndex.row];
    [toData insertObject:exchangingCard atIndex:toIndex.row];
    
    [fromCollection deleteItemsAtIndexPaths:@[fromIndex]];
    [toCollection insertItemsAtIndexPaths:@[toIndex]];
}


- (void) dropItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection toPoint:(CGPoint)to onCollection:(UIView<I3Collection> *)toCollection
{
    NSInteger toIndex = [[self dataForCollectionView:toCollection] count];
    NSIndexPath *toIndexPath = [toCollection isKindOfClass:[UITableView class]] ? [NSIndexPath indexPathForRow:toIndex inSection:0] : [NSIndexPath indexPathForItem:toIndex inSection:0];
    
    [self dropItemAt:from fromCollection:fromCollection toItemAt:toIndexPath onCollection:toCollection];
}

@end
