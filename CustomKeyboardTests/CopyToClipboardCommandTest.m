//
//  CopyToClipboardCommandTest.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 02/10/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AssetModel.h"
#import "CopyToClipboardCommand.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FetchAssetsCommand.h"

@interface CopyToClipboardCommand()
- (NSString *)commandType;

@end

@interface CopyToClipboardCommandTest : XCTestCase<CommandDelegate>
{
    __weak __block XCTestExpectation *expectation;
    AssetModel * videoAsset;
}
@property (nonatomic) CopyToClipboardCommand * commandCopy;
@end

@implementation CopyToClipboardCommandTest

- (void)setUp {
    _commandCopy = [[CopyToClipboardCommand alloc]init:self ];
    [super setUp];
}

- (void)tearDown {
    _commandCopy = nil;
    [super tearDown];
}

-(void)testCommandType
{
    XCTAssertEqualObjects(self.commandCopy.commandType,kCopyToClipboardCommand,@"Invalid Command Type");
}

- (void)testImageCopy {
    expectation  = [self expectationWithDescription:@"Testing Async Clipboard Copy!"];
  
    AssetModel * asset = [[AssetModel alloc]init];
    asset.image = [UIImage imageNamed:@"1.png"];
    asset.url = @"";
    asset.assetType = AssetTypeImage;
    
    self.commandCopy.asset = asset;
    
    [self.commandCopy execute];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error,@"Image Copy Failed");
    }];
}

- (void)testVideoCopy {
    expectation  = [self expectationWithDescription:@"Testing Async Clipboard Copy Video!"];
    FetchAssetsCommand * fetchAssets = [[FetchAssetsCommand alloc]init:self];
    [fetchAssets execute];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error,@"Some Error Occured while copying videos assets");
    }];
}


#pragma mark Command Delegate
- (void)command:(BaseCommand *)cmd didReceiveResponse:(id)response
{
    if ([cmd.commandType isEqualToString: kAssetsFetchCommand]) {
        AssetModel * asset = (AssetModel*)response;
        if (asset.assetType == AssetTypeVideo && videoAsset == nil)
        {
            videoAsset = asset;
            self.commandCopy.asset = asset;
            [self.commandCopy execute];
        }
    }
    else if([cmd.commandType isEqualToString:kCopyToClipboardCommand])
    {
        [expectation fulfill];
    }
}

- (void)command:(BaseCommand *)cmd didFailWithError:(NSError *)error
{
    XCTAssertNil(error,@"Some Error Occured");
}

@end
