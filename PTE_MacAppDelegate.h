//
//  PTE_MacAppDelegate.h
//  PTE_Mac
//
//  Created by Paul Freshney on 19/05/2011.
//  Copyright 2011-2016 freshney.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "windowtest.h"

@interface PTE_MacAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
}


@property (assign) IBOutlet NSWindow *window;

@end
