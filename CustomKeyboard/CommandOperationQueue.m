//
//  CommandOperationQueue.m
//  MCommerce
//
//  Created by Saalis Umer on 10/15/12.
//  Copyright (c) 2012 HomeShop18. All rights reserved.
//

#import "CommandOperationQueue.h"

#define kMaxConcurrentOperationCount 10

@implementation CommandOperationQueue

static CommandOperationQueue *singletonInstance = nil;

- (id)init {
	if(self = [super init]) {
        self.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
	}
	return self;
}

+ (CommandOperationQueue *) instance {
	@synchronized(self) {
		if(!singletonInstance) {
			singletonInstance = [[CommandOperationQueue alloc] init];
		}
	}
    
	return singletonInstance;
}

@end
