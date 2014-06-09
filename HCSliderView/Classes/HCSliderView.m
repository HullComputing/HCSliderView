//
//  HCSliderView.m
//  HCSliderView
//
//  Created by Aaron Hull on 6/6/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCSliderView.h"
#import "HCSliderViewSlider.h"
#import "HCSliderViewCell.h"

@interface HCSliderView () <UITableViewDataSource, UITableViewDelegate, HCSliderViewSliderDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSDictionary *_cellClassesForReuseIdentifier;
}
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation HCSliderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[HCSliderViewSlider class] forCellReuseIdentifier:svTableViewCellIdentifier];
        [self.tableView setSeparatorColor:[UIColor clearColor]];
        [self addSubview:self.tableView];
        _cellClassesForReuseIdentifier = [NSDictionary dictionaryWithObject:[HCSliderViewCell class] forKey:svCollectionViewCellIdentifier];
    }
    return self;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    if (cellClass && identifier) {
        NSMutableDictionary *mutableClasses = [NSMutableDictionary dictionaryWithDictionary:_cellClassesForReuseIdentifier];
        [mutableClasses setObject:cellClass forKey:identifier];
        _cellClassesForReuseIdentifier = [mutableClasses copy];
    }
    
}

- (HCSliderViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    HCSliderViewSlider *slider = (HCSliderViewSlider *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.slider inSection:0]];
    Class aCellClass = [slider.registeredClassesForReuseIdentifier objectForKey:identifier];
    if (!aCellClass) {
        [slider registerClass:[HCSliderViewCell class] forCellReuseIdentifier:identifier];
    }
    return [slider.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSlidersInSliderView:)]) {
        rows = [self.delegate numberOfSlidersInSliderView:self];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCSliderViewSlider *slider = (HCSliderViewSlider *)[tableView dequeueReusableCellWithIdentifier:svTableViewCellIdentifier];
    
    [slider setSliderDelegate:self index:indexPath.row];
    
    for (NSString *cellIdentifier in _cellClassesForReuseIdentifier) {
        Class aCellClass = [_cellClassesForReuseIdentifier objectForKey:cellIdentifier];
        if (aCellClass && cellIdentifier) {
            [slider registerClass:aCellClass forCellReuseIdentifier:cellIdentifier];
        }
    }
    
    return slider;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITableView Delegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForSlider:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - HCSliderViewSlider Delegate

- (CGFloat)heightForSlider:(NSInteger)slider
{
    CGFloat height = 100.0;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sliderView:heightForSlider:)]) {
        height = [self.delegate sliderView:self heightForSlider:slider];
    }
        if ([self.delegate respondsToSelector:@selector(sliderView:sizeForItemAtIndexPath:)]) {
            CGSize size = [self.delegate sliderView:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSlider:slider]];
            if (height < size.height) {
                height = size.height;
            }
        }
    }
    return height;
}

- (UIView *)headerViewForSlider:(NSInteger)slider
{
    UIView *headerView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:viewForHeaderInSlider:)]) {
        headerView = [self.delegate sliderView:self viewForHeaderInSlider:slider];
    }
    return headerView;
}

- (UIView *)footerViewForSlider:(NSInteger)slider
{
    UIView *footerView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:viewForFooterInSlider:)]) {
        footerView = [self.delegate sliderView:self viewForFooterInSlider:slider];
    }
    return footerView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(HCSliderViewSliderCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(30, 30);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:sizeForItemAtIndexPath:)]) {
        size = [self.delegate sliderView:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSlider:collectionView.index]];
    }
    if (collectionView.itemHeight < size.height) {
        collectionView.itemHeight = size.height;
    }
    return size;
}

- (UIEdgeInsets)collectionView:(HCSliderViewSliderCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if (collectionView.frame.size.height > collectionView.itemHeight) {
        CGFloat verticalInset = (collectionView.frame.size.height - collectionView.itemHeight) / 2.0;
        insets.top = verticalInset;
        insets.bottom = verticalInset;
    }
    NSLog(@"%@, %f, %f", NSStringFromUIEdgeInsets(insets), collectionView.itemHeight, collectionView.frame.size.height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:minimumInterItemSpacingForSlider:)]) {
        insets.left = [self.delegate sliderView:self minimumInterItemSpacingForSlider:section];
        insets.right = [self.delegate sliderView:self minimumInterItemSpacingForSlider:section];
    }
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = 0.0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:minimumInterItemSpacingForSlider:)]) {
        spacing = [self.delegate sliderView:self minimumInterItemSpacingForSlider:section];
    }
    
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:numberOfItemsInSlider:)]) {
        count = [self.delegate sliderView:self numberOfItemsInSlider:section];
    }
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(HCSliderViewSliderCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        return [self.delegate sliderView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:collectionView.index]];
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:svCollectionViewCellIdentifier forIndexPath:indexPath];
    }
}

//@optional

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




#pragma mark - UICollectionView Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // called when the user taps on an already-selected item in multi-select mode
- (void)collectionView:(HCSliderViewSliderCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didSelectItemAtIndexPath:)]) {
        [self.delegate sliderView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:collectionView.index]];
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;

// support for custom transition layout
//- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;



@end

@implementation NSIndexPath (HCSliderView)

+ (NSIndexPath *)indexPathForItem:(NSInteger)item inSlider:(NSInteger)slider
{
    const NSUInteger index[] = {slider, item};
    return [NSIndexPath indexPathWithIndexes:index length:2];
    
}

- (NSInteger)item {
    return [self indexAtPosition:1];
}

- (NSInteger)slider {
    return [self indexAtPosition:0];
}

@end
