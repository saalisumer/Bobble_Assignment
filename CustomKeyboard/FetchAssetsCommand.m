//
//  Command.m
//  MCommerce
//
//  Created by Saalis Umer on 10/12/12.
//  Copyright (c) 2012 HomeShop18. All rights reserved.
//

#import "FetchAssetsCommand.h"
#import "CommandOperationQueue.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetModel.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString(MD5)
- (NSString *)MD5String;
@end

@implementation NSString(MD5)
- (NSString *)MD5String {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end


@interface FetchAssetsCommand()

@end

@implementation FetchAssetsCommand
- (NSString *)commandType {
    return kAssetsFetchCommand;
}

-(void)main
{
    
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if(group)
            {
                //Get photos
                [self getContentFrom:group withAssetFilter:[ALAssetsFilter allPhotos]];
                
                
                //Get videos
                
                [self getContentFrom:group withAssetFilter:[ALAssetsFilter allVideos]];
                
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Error Description %@",[error description]);
        }];
}

-(void) getContentFrom:(ALAssetsGroup *) group withAssetFilter:(ALAssetsFilter *)filter
{
    [group setAssetsFilter:filter];
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result)
        {
            UIImage *img = [UIImage imageWithCGImage:[[result defaultRepresentation] fullResolutionImage]];
            AssetModel * asset = [[AssetModel alloc]init];
            asset.image = img;
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                asset.assetType = AssetTypeVideo;
                asset.url = [self writeVideoFileIntoTemp:result.defaultRepresentation.url.absoluteString andAsset:result];
            }
            else
            {
                asset.assetType = AssetTypeImage;
                asset.url = result.defaultRepresentation.url.absoluteString;
            }
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.delegate command:self didReceiveResponse:asset];
            });
        }
    }];
}

-(NSString*) writeVideoFileIntoTemp:(NSString*)fileName andAsset:(ALAsset*)asset
{
    NSString * tmpfile = [NSTemporaryDirectory() stringByAppendingPathComponent:[fileName MD5String]];
    ALAssetRepresentation * rep = [asset defaultRepresentation];
    
    NSUInteger size = [rep size];
    const int bufferSize = 1024*1024; // or use 8192 size as read from other posts
    
    NSLog(@"Writing to %@",tmpfile);
    FILE* f = fopen([tmpfile cStringUsingEncoding:1], "wb+");
    if (f == NULL) {
        NSLog(@"Can not create tmp file.");
        return nil;
    }
    
    Byte * buffer = (Byte*)malloc(bufferSize);
    NSUInteger read = 0, offset = 0, written = 0;
    NSError* err;
    if (size != 0) {
        do {
            read = [rep getBytes:buffer
                      fromOffset:offset
                          length:bufferSize
                           error:&err];
            written = fwrite(buffer, sizeof(char), read, f);
            offset += read;
        } while (read != 0);
        
        
    }
    fclose(f);
    return tmpfile;
}



@end
