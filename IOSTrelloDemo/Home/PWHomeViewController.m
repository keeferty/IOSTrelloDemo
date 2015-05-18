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
#import "PWDetailViewController.h"

@interface PWHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, I3DragDataSource>
@property (nonatomic, strong) JGProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollection;
@property (strong, nonatomic) UIRefreshControl *leftRefreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *middleCollection;
@property (strong, nonatomic) UIRefreshControl *middleRefreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollection;
@property (strong, nonatomic) UIRefreshControl *rightRefreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *sourceCollection;

@property (nonatomic, strong) I3GestureCoordinator *dragCoordinator;

@property (nonatomic) BOOL locked;
@property (nonatomic, weak) PWCard *passThruCard;

@property (weak, nonatomic) IBOutlet UIView *deleteView;


@end

#pragma mark - UIViewController Lifecycle
@implementation PWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftRefreshControl = [self refreshControlForCollection:self.leftCollection];
    self.middleRefreshControl = [self refreshControlForCollection:self.middleCollection];
    self.rightRefreshControl = [self refreshControlForCollection:self.rightCollection];
    if ([PWDataManager sharedInstance].board == nil) {
        [[PWDataManager sharedInstance] getWholeBoard];
        [self.hud showInView:self.view];
        [self.hud dismissAfterDelay:10 animated:YES];
    }
    if ([PWDataManager sharedInstance].stack.count) {
        [[PWDataManager sharedInstance] reloadStackedOperations];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:LocString(@"Lock") style:UIBarButtonItemStylePlain target:self action:@selector(lockList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    __weak PWHomeViewController *weakSelf = self;
    [[RACObserve([PWDataManager sharedInstance], board.updated) skip:[PWDataManager sharedInstance].board?0:4] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.hud.isVisible) {
                [weakSelf.hud dismiss];
            }
            if (weakSelf.leftRefreshControl.isRefreshing) {
                [weakSelf.leftRefreshControl endRefreshing];
            }
            if (weakSelf.middleRefreshControl.isRefreshing) {
                [weakSelf.middleRefreshControl endRefreshing];
            }
            if (weakSelf.rightRefreshControl.isRefreshing) {
                [weakSelf.rightRefreshControl endRefreshing];
            }
            [self reloadCollections];
        });
    }];
    [self reloadCollections];
    
    self.dragCoordinator = [I3GestureCoordinator basicGestureCoordinatorFromViewController:self withCollections:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection] withRecognizer:[UILongPressGestureRecognizer new]];
    self.dragCoordinator.renderDelegate = [[FunkRenderDelegate alloc]initWithPotentialDstViews:@[self.leftCollection, self.middleCollection, self.rightCollection, self.sourceCollection, self.deleteView] andDeleteArea:self.deleteView];
    I3BasicRenderDelegate *renderDelegate = (I3BasicRenderDelegate *)self.dragCoordinator.renderDelegate;
    renderDelegate.draggingItemOpacity = 0.4;
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

#pragma mark - Helper Stuff

- (void)reloadCollections
{
    [self.leftCollection reloadData];
    [self.middleCollection reloadData];
    [self.rightCollection reloadData];
}

- (UIRefreshControl *)refreshControlForCollection:(UICollectionView *)collection
{
    UIRefreshControl *tmpControl = [UIRefreshControl new];
    [tmpControl addTarget:self action:@selector(updateCollection:) forControlEvents:UIControlEventValueChanged];
    [collection addSubview:tmpControl];
    return tmpControl;
}

- (void)updateCollection:(UIRefreshControl *)control
{
    PWList *list = nil;
    if (control == self.leftRefreshControl) {
        list = [PWDataManager sharedInstance].board.toDoList;
    }else if (control == self.middleRefreshControl) {
        list = [PWDataManager sharedInstance].board.doingList;
    }else {
        list = [PWDataManager sharedInstance].board.doneList;
    }
    [[PWDataManager sharedInstance] getListCards:list];
}

- (NSMutableArray *)dataForCollectionView:(UIView *)collectionView{
    
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
        PWCard *card = [PWCard new];
        card.name = LocString(@"New Item");
        card.desc = LocString(@"Drag me");
        card.operationType = CardOperationTypeRedy;
        data = [@[card]mutableCopy];
    }
    return data;
}

- (NSString *)idListForCollectionView:(UIView *)collectionView{
    
    if(collectionView == self.leftCollection){
        return [PWDataManager sharedInstance].board.toDoList.identifier;
    }
    else if(collectionView == self.middleCollection){
        return [PWDataManager sharedInstance].board.doingList.identifier;
    }
    else if(collectionView == self.rightCollection){
        return [PWDataManager sharedInstance].board.doneList.identifier;
    }
    return nil;
}

- (BOOL) isPointInDeletionArea:(CGPoint) point fromView:(UIView *)view{
    
    CGPoint localPoint = [self.deleteView convertPoint:point fromView:view];
    return [self.deleteView pointInside:localPoint withEvent:nil];
}

- (void)lockList
{
    __weak PWHomeViewController *weakSelf = self;
    if (!self.locked) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.navigationItem.rightBarButtonItem.title = LocString(@"Unlock");
            weakSelf.middleCollection.backgroundColor = [UIColor redColor];
            weakSelf.rightCollection.backgroundColor = [UIColor redColor];
            self.locked = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.navigationItem.rightBarButtonItem.title = LocString(@"Lock");
            weakSelf.middleCollection.backgroundColor = weakSelf.leftCollection.backgroundColor;
            weakSelf.rightCollection.backgroundColor = weakSelf.leftCollection.backgroundColor;
            self.locked = NO;
        }];
    }
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView != self.sourceCollection) {
        self.passThruCard = [[self dataForCollectionView:collectionView] objectAtIndex:indexPath.item];
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
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
    if (self.locked) {
        if (fromCollection == self.sourceCollection) {
            if (toCollection ==self.leftCollection) {
                return YES;
            }else
                return NO;
        }else
            return YES;
    }else
        return YES;
}


- (BOOL) canItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection beDroppedAtPoint:(CGPoint)at onCollection:(UIView<I3Collection> *)toCollection
{
    if (self.locked) {
        if (fromCollection == self.sourceCollection) {
            if (toCollection ==self.leftCollection) {
                return YES && ![self isPointInDeletionArea:at fromView:toCollection];
            }else
                return NO;
        }else
            return YES && ![self isPointInDeletionArea:at fromView:toCollection];
    }else
        return ![self isPointInDeletionArea:at fromView:toCollection];
}


- (BOOL) canItemAt:(NSIndexPath *)from beDeletedFromCollection:(UIView<I3Collection> *)collection atPoint:(CGPoint)to
{
    return [self isPointInDeletionArea:to fromView:self.view];
}


- (void) deleteItemAt:(NSIndexPath *)at inCollection:(UIView<I3Collection> *)collection
{
    if (collection != self.sourceCollection) {
        NSMutableArray *fromData = [self dataForCollectionView:collection];
        PWCard *deletedCard = [fromData objectAtIndex:at.row];
        [deletedCard remove];
        [fromData removeObjectAtIndex:at.row];
        [collection deleteItemsAtIndexPaths:@[at]];
    }else {
        [collection reloadItemsAtIndexPaths:@[at]];
    }
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
    exchangingCard.idList = [self idListForCollectionView:toCollection];
    
    [fromData removeObjectAtIndex:fromIndex.row];
    [toData insertObject:exchangingCard atIndex:toIndex.row];
    
    
    if (fromCollection != self.sourceCollection) {
        [fromCollection deleteItemsAtIndexPaths:@[fromIndex]];
        [exchangingCard save];
    }else {
        [exchangingCard create];
    }
    [toCollection insertItemsAtIndexPaths:@[toIndex]];
}


- (void) dropItemAt:(NSIndexPath *)from fromCollection:(UIView<I3Collection> *)fromCollection toPoint:(CGPoint)to onCollection:(UIView<I3Collection> *)toCollection
{
    NSInteger toIndex = [[self dataForCollectionView:toCollection] count];
    NSIndexPath *toIndexPath = [toCollection isKindOfClass:[UITableView class]] ? [NSIndexPath indexPathForRow:toIndex inSection:0] : [NSIndexPath indexPathForItem:toIndex inSection:0];
    
    [self dropItemAt:from fromCollection:fromCollection toItemAt:toIndexPath onCollection:toCollection];
}

#pragma mark - Navigation Stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWDetailViewController *detCtrl = [segue destinationViewController];
    detCtrl.card = self.passThruCard;
}
@end
