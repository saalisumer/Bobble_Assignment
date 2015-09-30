//
//  CollectionViewCell.h
//  CustomKeyboard
//
//  Created by SAALIS UMER on 29/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetModel.h"

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView * image;
@property (nonatomic, weak) IBOutlet UILabel * lblVideo;
@property (nonatomic, strong) AssetModel * asset;
@end
