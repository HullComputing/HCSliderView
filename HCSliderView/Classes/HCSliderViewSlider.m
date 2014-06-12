//
//  HCSliderViewSlider.m
//  HCSliderView
//
//  Created by Aaron Hull on 6/6/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCSliderViewSlider.h"
#import "HCSliderViewCell.h"

@implementation HCSliderViewSliderCollectionView

- (void)setFrame:(CGRect)frame
{
//    if (frame.size.height && !CGRectEqualToRect(frame, self.frame)) {
        [self.collectionViewLayout invalidateLayout];
        [super setFrame:frame];
//    }
}

@end


@interface HCSliderViewSlider ()
@property (nonatomic, assign, readwrite) id<HCSliderViewSliderDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> delegate;
@end

@implementation HCSliderViewSlider

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.registeredClassesForReuseIdentifier = [NSDictionary new];
        self.contentOffset = CGPointZero;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[HCSliderViewSliderCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
    }
    return self;
}

- (void)setSliderDelegate:(id<HCSliderViewSliderDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>)delegate index:(NSUInteger)index
{
    self.delegate = delegate;
    self.sliderIndex = index;
    
    if (delegate) {
        CGRect frame = self.frame;
        frame.size.height = [delegate heightForSlider:index];
        self.frame = frame;
    }
    // Remove old views if they exist
    if (self.headerView) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    if (self.footerView) {
        [self.footerView removeFromSuperview];
        self.footerView = nil;
    }
    
    
    // Get the headerView from the delegate if it exists and add it to the view
    if (delegate && [delegate respondsToSelector:@selector(headerViewForSlider:)]) {
        self.headerView = [delegate headerViewForSlider:self.sliderIndex];
        if (self.headerView) {
            CGRect headerFrame = self.headerView.frame;
            headerFrame.origin = CGPointZero;
            headerFrame.size.width = self.frame.size.width;
            self.headerView.frame = headerFrame;
            [self addSubview:self.headerView];
        }
    }
    
    // Get the footerView from the delegate if it exists and add it to the view
    if (delegate && [delegate respondsToSelector:@selector(footerViewForSlider:)]) {
        self.footerView = [delegate footerViewForSlider:self.sliderIndex];
        if (self.footerView) {
            [self addSubview:self.footerView];
        }
    }
    
    // Create the collection view
    if (delegate) {
        
        CGRect collectionViewFrame = self.bounds;
        if (self.headerView) {
            collectionViewFrame.origin.y = CGRectGetMaxY(self.headerView.frame);
            collectionViewFrame.size.height -= collectionViewFrame.origin.y;
        }
        if (self.footerView) {
            collectionViewFrame.size.height -= self.footerView.frame.size.height;
            CGRect footerFrame = self.footerView.frame;
            footerFrame.origin.y = CGRectGetMaxY(collectionViewFrame);
            footerFrame.size.width = self.frame.size.width;
            self.footerView.frame = footerFrame;
        }
        
        self.collectionView.index = index;
        if (!CGRectEqualToRect(collectionViewFrame, self.collectionView.frame)) {
            self.collectionView.frame = collectionViewFrame;
        }
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        self.collectionView.delegate = delegate;
        self.collectionView.dataSource = delegate;
//        [self.collectionView registerClass:[HCSliderViewCell class] forCellWithReuseIdentifier:svCollectionViewCellIdentifier];
        if (!self.collectionView.superview) {
        [self addSubview:self.collectionView];
        }
    }
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.collectionView.contentOffset = self.contentOffset;
    } else {
        self.contentOffset = self.collectionView.contentOffset;
    }
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    frame.size.width = self.superview.frame.size.width;
    self.frame = frame;
    frame = self.collectionView.frame;
    frame.size.width = self.frame.size.width;
    self.collectionView.frame = frame;
    [super layoutSubviews];
    
   
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    
    if (!cellClass) {
        cellClass = [HCSliderViewCell class];
    }
    Class registeredClass = [self.registeredClassesForReuseIdentifier objectForKey:identifier];
    if (!registeredClass || (registeredClass != cellClass)) {
        NSMutableDictionary *mutableRegisteredClasses = [NSMutableDictionary dictionaryWithDictionary:self.registeredClassesForReuseIdentifier];
        [mutableRegisteredClasses setObject:cellClass forKeyedSubscript:identifier];
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        self.registeredClassesForReuseIdentifier = [mutableRegisteredClasses copy];
    }
}


@end
