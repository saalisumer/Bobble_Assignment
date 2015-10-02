//
//  KeyboardViewControllerTests.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 02/10/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeyboardViewController.h"

@interface KeyboardViewController()
{
    NSMutableArray * array;
    
    BOOL * loaded;
}
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


-(UIActivityIndicatorView *)activityIndicator;
- (void)loadCollectionView;
-(void)loadNextKeyboardButton;
@end

@interface KeyboardViewControllerTests : XCTestCase
@property (nonatomic) KeyboardViewController * keyboardVC;
@end

@implementation KeyboardViewControllerTests

- (void)setUp {
    [super setUp];
    _keyboardVC = [[KeyboardViewController alloc]init ];
}

- (void)tearDown {
    [super tearDown];
    _keyboardVC = nil;
}

- (void)testActivityIndicatorLoading
{
    UIActivityIndicatorView * activityIndicator1 = [self.keyboardVC activityIndicator];
    UIActivityIndicatorView * activityIndicator2 = [self.keyboardVC activityIndicator];
        XCTAssertNotEqual(self.keyboardVC.activityIndicator, nil,@"Activity Indicator Loading Failed");
        XCTAssertEqualObjects(activityIndicator1, activityIndicator2, @"The activity Indicator lazy loading single Object instantiaion failed");
}

- (void)testCollectionViewLoading
{
    [self.keyboardVC loadCollectionView];
    XCTAssertNotEqual(self.keyboardVC.collectionView, nil,@"Assets Collection View Loading Failed");
}

- (void)testNextKeyboardButtonLoading
{
    [self.keyboardVC loadNextKeyboardButton];
    XCTAssertNotEqual(self.keyboardVC.nextKeyboardButton, nil,@"Assets Collection View Loading Failed");
}

@end
