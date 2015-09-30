//
//  BaseCommand.h
//  CustomKeyboard
//
//  Created by SAALIS UMER on 30/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCopyToClipboardCommand @"CopyToClipboard"
#define kAssetsFetchCommand @"AssetsFetch"

@protocol CommandDelegate;

@interface BaseCommand : NSOperation

//Must override this property for Commands which are asynchronous in nature
@property(readonly) BOOL isAsynchronous;
@property(readonly, weak) id<CommandDelegate> delegate;
@property(readonly, weak) NSString * commandType;
- (void)execute;

- (id)init:(id<CommandDelegate>)delegate;
@end

@protocol CommandDelegate <NSObject>

@optional
- (void)command:(BaseCommand *)cmd didReceiveResponse:(id)response;
- (void)command:(BaseCommand *)cmd didFailWithError:(NSError *)error;

@end