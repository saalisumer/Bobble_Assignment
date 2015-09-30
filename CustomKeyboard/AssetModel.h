//
//  AssetModel.h
//  CustomKeyboard
//
//  Created by SAALIS UMER on 30/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum AssetType
{
    AssetTypeImage = 0,
    AssetTypeVideo = 1
}AssetType;

@interface AssetModel : NSObject
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) AssetType assetType;
@end
