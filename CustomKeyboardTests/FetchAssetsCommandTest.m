//
//  FetchAssetsCommandTest.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 02/10/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FetchAssetsCommand.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetModel.h"

@interface FetchAssetsCommand()
- (NSString *)commandType;
- (NSString*) writeVideoFileIntoTemp:(NSString*)fileName andAsset:(ALAsset*)asset;
@end

@interface FetchAssetsCommandTest : XCTestCase <CommandDelegate>
{
    __weak __block XCTestExpectation *expectation;
}
@property (nonatomic) FetchAssetsCommand * fetchAssetsCommand;
@end

@implementation FetchAssetsCommandTest

- (void)setUp {
    [super setUp];
    _fetchAssetsCommand = [[FetchAssetsCommand alloc]init:self ];
}

- (void)tearDown {
    [super tearDown];
    _fetchAssetsCommand = nil;
}

-(void)testCommandType
{
    XCTAssertEqualObjects(self.fetchAssetsCommand.commandType,kAssetsFetchCommand,@"Invalid Command Type");
}

- (void)testVideoFileWriting {
    expectation  = [self expectationWithDescription:@"Testing Async Writing Method To Video File Works!"];
    __block ALAsset * asset;

    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    __block NSString * fileName;
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group)
        {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                

                if(result && asset == nil)
                {
                    fileName = [self.fetchAssetsCommand writeVideoFileIntoTemp:result.defaultRepresentation.url.absoluteString andAsset:result];
                    asset = result;
                    XCTAssertNotNil(fileName,@"Video File not saved");
                    [expectation fulfill];
                }
                
            }];
        }
    } failureBlock:^(NSError *error) {
    }];
    
    if (fileName == nil)
    {
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error,@"Some Error Occured while saving videos assets");
    }];
}

- (void)testFetchCommand {
    expectation = [self expectationWithDescription:@"Testing Async Writing Method To Video File Works!"];

    [self.fetchAssetsCommand execute];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error,@"Some Error Occured while fetching assets");
    }];
}

#pragma mark Command Delegate
- (void)command:(BaseCommand *)cmd didReceiveResponse:(id)response
{
    XCTAssertNotNil(response,@"Returned nil image/video");
    
    XCTAssert([response isKindOfClass:[AssetModel class]],@"Invalid Response");
    XCTAssert(((AssetModel*)response).url != nil,@"Asset URL Missing");
    XCTAssert(((AssetModel*)response).image != nil,@"Asset Image Missing");
    [expectation fulfill];
}

- (void)command:(BaseCommand *)cmd didFailWithError:(NSError *)error
{
    XCTAssertNil(error,@"Some Error Occured while fetching assets");
}

@end
