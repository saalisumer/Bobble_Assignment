//
//  CopyToClipboardCommand.h
//  CustomKeyboard
//
//  Created by SAALIS UMER on 30/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCommand.h"
#import "AssetModel.h"
@interface CopyToClipboardCommand : BaseCommand
@property (nonatomic, strong) AssetModel * asset;
@end
