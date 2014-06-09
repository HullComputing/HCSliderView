//
//  HCSliderView.h
//  HCSliderView
//
//  Created by Aaron Hull on 6/6/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//


#import <UIKit/UIKit.h>
//! Project version number for HCSliderView.
FOUNDATION_EXPORT double HCSliderViewVersionNumber;

//! Project version string for HCSliderView.
FOUNDATION_EXPORT const unsigned char HCSliderViewVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HCSliderView/PublicHeader.h>
//#import <HCSliderView/HCSliderView.h>
#import "HCSliderViewCell.h"

@class HCSliderView;

@protocol HCSliderViewDelegate <NSObject>

@required
- (NSInteger)numberOfSlidersInSliderView:(HCSliderView *)sliderView;
- (NSInteger)sliderView:(HCSliderView *)sliderView numberOfItemsInSlider:(NSInteger)slider;
- (CGFloat)sliderView:(HCSliderView *)sliderView heightForSlider:(NSInteger)slider;

- (HCSliderViewCell *)sliderView:(HCSliderView *)sliderView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIView *)sliderView:(HCSliderView *)sliderView viewForHeaderInSlider:(NSInteger)slider;
- (UIView *)sliderView:(HCSliderView *)sliderView viewForFooterInSlider:(NSInteger)slider;
- (void)sliderView:(HCSliderView *)sliderView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)sliderView:(HCSliderView *)sliderView minimumInterItemSpacingForSlider:(NSUInteger)index;

- (CGSize)sliderView:(HCSliderView *)sliderView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HCSliderView : UIView

@property (nonatomic, assign) id<HCSliderViewDelegate>delegate;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (HCSliderViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSIndexPath (HCSliderView)

+ (NSIndexPath *)indexPathForItem:(NSInteger)item inSlider:(NSInteger)slider __AVAILABILITY_INTERNAL__IPHONE_6_1;
//@property (nonatomic, readonly) CGSize contentSize;
@property(nonatomic,readonly) NSInteger item;
@property(nonatomic,readonly) NSInteger slider;

@end