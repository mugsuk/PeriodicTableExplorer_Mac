//
//  main.m
//  PTE_Mac
//
//  Created by Paul Freshney on 19/05/2011.
//  Copyright 2011-2016 freshney.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

const NSString * global_bundleVersion    = @"1.5";
const NSString * global_bundleIdentifier = @"com.paulalanfreshney.ptemac";

int main(int argc, char *argv[])
{
    
	// put the example receipt on the desktop (or change that path)
	//NSString * pathToReceipt = @"~/Desktop/receipt";
	
	// in your own code you have to do:
	//NSString * pathToReceipt = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/_MASReceipt/receipt"];
	// this example is not a bundle so it wont work here.
	
	//if (!validateReceiptAtPath(pathToReceipt))
	//{
	//	exit(173);
	//}
	
	return NSApplicationMain(argc, (const char **) argv);
}
