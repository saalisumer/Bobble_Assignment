//
//  CopyToClipboardCommand.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 30/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import "CopyToClipboardCommand.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CopyToClipboardCommand

- (NSString *)commandType {
    return kCopyToClipboardCommand;
}

-(void)main
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (self.asset.assetType == AssetTypeVideo) {
        NSError * error;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.asset.url]options:NSDataReadingUncached error:&error];
        [pasteBoard setData:data forPasteboardType:@"public.mpeg-4"];
    }
    else
    {
        [pasteBoard setImage:self.asset.image];
    }
    dispatch_async (dispatch_get_main_queue(), ^{
        [self.delegate command:self didReceiveResponse:self.asset];
    });
}
@end
