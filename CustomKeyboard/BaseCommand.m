//
//  BaseCommand.m
//  CustomKeyboard
//
//  Created by SAALIS UMER on 30/09/15.
//  Copyright © 2015 SAALIS UMER. All rights reserved.
//

#import "BaseCommand.h"
#import "CommandOperationQueue.h"

@implementation BaseCommand

@synthesize delegate = mDelegate;

- (id)init:(id<CommandDelegate>)delegate {
    self = [super init];
    
    if(self != nil) {
        mDelegate = delegate;
    }
    
    return self;
}

-(void)setCommandDelegate:(id<CommandDelegate>)delegate{
    mDelegate = delegate;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (NSString *)commandType {
    return @"";
}

- (void)execute {
    [[CommandOperationQueue instance] addOperation:self];
}
@end
