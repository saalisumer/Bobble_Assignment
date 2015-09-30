//
//  CollectionViewCell.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 29/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(void)setAsset:(AssetModel*)asset
{
    _asset = asset;
    self.image.image = asset.image;
    if (asset.assetType == AssetTypeVideo) {
        self.lblVideo.hidden = NO;
    }
    else
    {
        self.lblVideo.hidden = YES;
    }
}
@end
