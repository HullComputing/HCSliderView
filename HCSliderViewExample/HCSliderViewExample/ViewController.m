//
//  ViewController.m
//  HCSliderViewExample
//
//  Created by Aaron Hull on 6/6/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "ViewController.h"
#import <HCSliderView/HCSliderView.h>

@interface ViewController () <HCSliderViewDelegate>

@property (strong, nonatomic) IBOutlet HCSliderView *sliderView;
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.sliderView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HCSliderViewDelegate
- (NSInteger)numberOfSlidersInSliderView:(HCSliderView *)sliderView
{
    return 3;
}

- (CGFloat)sliderView:(HCSliderView *)sliderView heightForSlider:(NSInteger)slider
{
    return 130.0;
}

- (UIView *)sliderView:(HCSliderView *)sliderView viewForHeaderInSlider:(NSInteger)slider
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sliderView.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor greenColor]];
    return headerView;
}

//- (UIView *)sliderView:(HCSliderView *)sliderView viewForFooterInSlider:(NSInteger)slider
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sliderView.frame.size.width, 10)];
//    [footerView setBackgroundColor:[UIColor blueColor]];
//    return footerView;
//}

- (NSInteger)sliderView:(HCSliderView *)sliderView numberOfItemsInSlider:(NSInteger)slider
{
    return 5;
}

- (CGFloat)sliderView:(HCSliderView *)sliderView minimumInterItemSpacingForSlider:(NSUInteger)index
{
    return 10.0;
}

- (CGSize)sliderView:(HCSliderView *)sliderView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 150);
}

- (HCSliderViewCell *)sliderView:(HCSliderView *)sliderView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCSliderViewCell *cell = [sliderView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"No cell");
    }
    [cell setBackgroundColor:[UIColor grayColor]];
    [cell.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    [cell.layer setBorderWidth:0.5];
    return cell;
}

@end
