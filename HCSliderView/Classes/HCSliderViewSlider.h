//
//  HCSliderViewSlider.h
//  HCSliderView
//
//  Created by Aaron Hull on 6/6/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *svTableViewCellIdentifier = @"svTableViewCellIdentifier";
static NSString *svCollectionViewCellIdentifier = @"internal_svCollectionViewCellIdentifier";

@protocol HCSliderViewSliderDelegate <NSObject, UICollectionViewDelegateFlowLayout>

- (UIView *)headerViewForSlider:(NSInteger)slider;
- (UIView *)footerViewForSlider:(NSInteger)slider;

@required
- (CGFloat)heightForSlider:(NSInteger)slider;

@end

@interface HCSliderViewSliderCollectionView : UICollectionView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat itemHeight;
@end


@interface HCSliderViewSlider : UITableViewCell
@property (nonatomic, assign, readonly) id<HCSliderViewSliderDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> delegate;


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) HCSliderViewSliderCollectionView *collectionView;
@property (nonatomic, strong) NSDictionary *registeredClassesForReuseIdentifier;
@property (nonatomic) NSInteger sliderIndex;

@property (nonatomic) CGPoint contentOffset;
- (void)setSliderDelegate:(id<HCSliderViewSliderDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>)delegate index:(NSUInteger)index;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

@end
