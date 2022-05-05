//
//  windowtest.m
//  Periodic Table Explorer OSX
//
//  Created by Paul Freshney on 11/08/2011.
//  Copyright 2011-2014 freshney.org. All rights reserved.
//
//  July 27th 2017

#import "windowtest.h"
#import <sqlite3.h>
#import "constants.h"
#import "utility.h"
#import "HTMLUtility.h"
#import "SQLUtility.h"

NSArray *ptData, *massData, *elementData, *countryData;

NSString *currentCountry = @"dz";

NSInteger currentElement = 1; // 1..118

NSInteger currentSpectrum = 1;

@implementation windowtest

@synthesize dialogWindow;

// ================================================================================================================
// ================================================================================================================
// == Window Delegate Code ========================================================================================
// ================================================================================================================
// ================================================================================================================

- (BOOL)windowShouldClose:(id)sender {
	
	[[NSApplication sharedApplication] terminate:NULL];
	 
	return TRUE;
}

- (IBAction) showTheSheet:(id)sender {

    [NSApp beginSheet:theSheet
       modalForWindow:(NSWindow *)dialogWindow
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil];
}

-(IBAction)endTheSheet:(id)sender {
    
    [NSApp endSheet:theSheet];
    
    [theSheet orderOut:sender];
}

- (IBAction) clickLink:(id)sender {

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[Utility getLinkAddress:[sender tag]]]];
}

// ================================================================================================================
// ================================================================================================================
// == Application Delegate Code ===================================================================================
// ================================================================================================================
// ================================================================================================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	myElements = [[NSArray alloc] initWithObjects:
                   e1,  e2,  e3,  e4,  e5,  e6,  e7,  e8,  e9,  e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20,
				  e21, e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37, e38, e39, e40,
				  e41, e42, e43, e44, e45, e46, e47, e48, e49, e50, e51, e52, e53, e54, e55, e56, e57, e58, e59, e60,
				  e61, e62, e63, e64, e65, e66, e67, e68, e69, e70, e71, e72, e73, e74, e75, e76, e77, e78, e79, e80,
				  e81, e82, e83, e84, e85, e86, e87, e88, e89, e90, e91, e92, e93, e94, e95, e96, e97, e98, e99, e100,
				  e101, e102, e103, e104, e105, e106, e107, e108, e109, e110, e111, e112, e113, e114, e115, e116, e117, e118,				  
				  nil];

	elementSymbols = [[NSArray alloc] initWithObjects:
                      @"H", @"He", @"Li", @"Be", @"B", @"C", @"N", @"O", @"F", @"Ne",
					  @"Na", @"Mg", @"Al", @"Si", @"P", @"S", @"Cl", @"Ar", @"K", @"Ca", 
					  @"Sc", @"Ti", @"V", @"Cr", @"Mn", @"Fe", @"Co", @"Ni", @"Cu", @"Zn", 
					  @"Ga", @"Ge", @"As", @"Se", @"Br", @"Kr", @"Rb", @"Sr", @"Y", @"Zr",
					  @"Nb", @"Mo", @"Tc", @"Ru", @"Rh", @"Pd", @"Ag", @"Cd", @"In", @"Sn",
					  @"Sb", @"Te", @"I", @"Xe", @"Cs", @"Ba", @"La", @"Ce", @"Pr", @"Nd",
					  @"Pm", @"Sm", @"Eu", @"Gd", @"Tb", @"Dy", @"Ho", @"Er", @"Tm", @"Yb",
					  @"Lu", @"Hf", @"Ta", @"W", @"Re", @"Os", @"Ir", @"Pt", @"Au", @"Hg",
					  @"Tl", @"Pb", @"Bi", @"Po", @"At", @"Rn", @"Fr", @"Ra", @"Ac", @"Th",
					  @"Pa", @"U", @"Np", @"Pu", @"Am", @"Cm", @"Bk", @"Cf", @"Es", @"Fm",
					  @"Md", @"No", @"Lr", @"Rf", @"Db", @"Sg", @"Bh", @"Hs", @"Mt", @"Ds",
					  @"Rg", @"Cn", @"Nh", @"Fl", @"Mc", @"Lv", @"Ts", @"Og",
					  nil];	
	
	stringProperties = [[NSArray alloc] initWithObjects:propertyFromValue1, propertyFromValue2, propertyFromValue3, nil];
	
	[imageSlider setMinValue:1.0];
	[imageSlider setMaxValue:2.0];
	
	[searchCriteria selectItemAtIndex:0];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"PTEType" ofType:@"plist"];
	ptData = [[NSArray alloc] initWithContentsOfFile:path];		
	
	NSString *path2 = [[NSBundle mainBundle] pathForResource:@"awisolist" ofType:@"plist"];
	massData = [[NSArray alloc] initWithContentsOfFile:path2];	
	
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"plist"];
	countryData = [[NSArray alloc] initWithContentsOfFile:path3];	

	NSString *path4 = [[NSBundle mainBundle] pathForResource:@"PTESearch" ofType:@"plist"];
	elementData = [[NSArray alloc] initWithContentsOfFile:path4];	
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"htm"];
	[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];

    [self setAutoPlaySpeechClick:autoPlaySpeechOff];
    
	[self setPTTooltips:tooltipsSimple];
	
	[self buildFromAN:1];
    
    [self continentListClick:NULL];
}

// ================================================================================================================
// ================================================================================================================
// == WebView Delegate Code =======================================================================================
// ================================================================================================================
// ================================================================================================================

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	
	if (sender == xWebView)
	{
		[goForward setEnabled:xWebView.canGoForward];
		[goBack setEnabled:xWebView.canGoBack];
		
		int anFromURL = [Utility getElementANFromPage:[xWebView mainFrameURL]];
		
		if ((anFromURL >= 1) && (anFromURL <= 118))
		{
			if (anFromURL != currentElement)
			{
				currentElement = anFromURL;
				
				[self buildFromAN:currentElement];
			}
		}
	}
	else if (sender == searchWebView)
	{
		//[goForwardSearch setEnabled:searchWebView.canGoForward];
		//[goBackSearch setEnabled:searchWebView.canGoBack];
	}
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {

	if (webView == searchWebView)
	{
		NSRange range = [[[request URL] absoluteString] rangeOfString:@".htm" options:NSCaseInsensitiveSearch];
		
		if (([webView mainFrameURL] == NULL) || (range.location == NSNotFound))
		{	
			[listener use];
		}
		else
		{
			[[xWebView mainFrame] loadRequest:request];
		}
	}
	else if (webView == massCalcWebView)
	{
		NSRange range = [[[request URL] absoluteString] rangeOfString:@".htm" options:NSCaseInsensitiveSearch];
		
		if (([webView mainFrameURL] == NULL) || (range.location == NSNotFound))
		{	
			[listener use];
		}
		else
		{
			[[xWebView mainFrame] loadRequest:request];
		}	
	}
	else if (webView == searchPropertiesView)
	{
		NSRange range = [[[request URL] absoluteString] rangeOfString:@".htm" options:NSCaseInsensitiveSearch];
		
		if (([webView mainFrameURL] == NULL) || (range.location == NSNotFound))
		{	
			[listener use];
		}
		else
		{
			[[xWebView mainFrame] loadRequest:request];
		}
	}
    else if (webView == xWebView)
    {
        if ([[[request URL] absoluteString] rangeOfString:@"sfx:"].location == NSNotFound)
        {
            [listener use];
        }
        else
        {
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld", (long)currentElement] ofType:@"aiff"]] error:NULL];
            
            [audioPlayer play];
            
            [listener ignore];            
        }
    }
}

// ================================================================================================================
// ================================================================================================================
// == Application Code ============================================================================================
// ================================================================================================================
// ================================================================================================================

- (IBAction) elementClicked:(id)sender {
	
	if (sender != NULL)
	{				
		currentElement = [sender tag];
		
		[self buildFromAN:currentElement];
	}
	
    // ===========================================================================================================
    
    if ([autoPlaySpeechOn state] == NSOnState)
    {
        [self playSpeech:nil];
    }

    // ===========================================================================================================
    
	NSInteger whichData;
	
	if ([dataType1 selectedSegment] == -1)
	{
		whichData = 5 + [dataType2 selectedSegment];
	}
	else
	{
		whichData = [dataType1 selectedSegment];
	}
    
    NSString *filePath = [Utility getDataFileName:whichData element:currentElement];
    
	[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]]; 
}

-(IBAction) dataType1Clicked:(id)sender {

	dataType2.selectedSegment = -1;
	
	[self elementClicked:NULL];
}

-(IBAction) dataType2Clicked:(id)sender {
	
	dataType1.selectedSegment = -1;
	
	[self elementClicked:NULL];
}

-(IBAction) clickOnThisDay:(id)sender {
	
	[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[Utility getOnThisDayFileName]]]];
}

-(IBAction) typeClick:(id)sender {

    NSString *filePath = [Utility getTypeFileName:[sender tag]];
	
	if ([filePath isNotEqualTo:@""])
	{
		[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]]; 
	}	
}

- (void) buildFromAN: (NSInteger) an {
	
	NSDictionary *anElement = (NSDictionary *)[ptData objectAtIndex:an - 1];
	
	[tElementName setStringValue:[NSString stringWithFormat:@"%@ [%@]", [anElement objectForKey:@"name"], [anElement objectForKey:@"symbol"]]];

	[tElementData1 setStringValue:[NSString stringWithFormat:@"Atomic Number: %@", [anElement objectForKey:@"atomicnumber"]]];
	[tElementData2 setStringValue:[NSString stringWithFormat:@"Atomic Weight: %@", [anElement objectForKey:@"atomicweight"]]];
	[tElementData3 setStringValue:[NSString stringWithFormat:@"%@. %@.", [anElement objectForKey:@"state"], [anElement objectForKey:@"colour"]]];
	
    [tElementGroup setStringValue:[Utility getGroupName:[[anElement objectForKey:@"type"] intValue]]];
	
	if ([Utility isRadioActive:an - 1])
	{
		[radioactive setHidden:NO];
	}
	else
	{
		[radioactive setHidden:YES];
	}
	
    [spectrum setImage:[NSImage imageNamed:[Utility getSpectrumImage:an withSpectrum:currentSpectrum]]];

	[imageSlider setNumberOfTickMarks:imagesCount[an - 1]];
	[imageSlider setMaxValue:imagesCount[an - 1]];
	
	[imageSlider setIntegerValue:1];
	
	[self imageSliderMoved:imageSlider];
}

-(IBAction) elementListClicked:(id)sender {

	NSString *filePath = [Utility getElementListFileName:[sender tag]];

    if ([filePath isNotEqualTo:@""])
	{
		[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]]; 
	}
}

- (IBAction) playSpeech:(id)sender {
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld", (long)currentElement] ofType:@"aiff"]] error:NULL];
    
    [audioPlayer play];
}

// ================================================================================================================
// ================================================================================================================
// == Image Tab ===================================================================================================
// ================================================================================================================
//=================================================================================================================

-(IBAction) imageSliderMoved:(id)sender {
	
	if (imagesCount[currentElement] != 0)
	{	
		NSString *fileName = [[NSString alloc] initWithFormat:@"%ld_%lu", (long)currentElement, (long)[imageSlider integerValue]];
		
		[imageComment setStringValue:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil]];
		
		[elementImage setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%ld_%lu.jpg", (long)currentElement, (long)[imageSlider integerValue]]]];
		
		[imageCount setStringValue:[NSString stringWithFormat:@"%lu of %d", (long)[imageSlider integerValue], imagesCount[currentElement - 1]]];
        
        [fileName release];
	}
	else
	{
		[imageComment setStringValue:@""];
		
		[elementImage setImage:[NSImage imageNamed:@"na.jpg"]];
		
		[imageCount setStringValue:@"No images."];
	}
}

// ================================================================================================================
// ================================================================================================================
// == Searching ===================================================================================================
// ================================================================================================================
// ================================================================================================================

-(IBAction) clickSearchIn:(id)sender {

    [searchTermHelp setStringValue:[Utility getDefaultSearchHelp:[searchCriteria indexOfSelectedItem]]];
}

-(IBAction) clickSearch:(id)sender {
	
	NSString *userStuff = [sender stringValue];	
	
	if ([userStuff length] > 0)
	{
		const char *pathConstants = [[[NSBundle mainBundle] pathForResource:@"pteConstants" ofType:@"db"] UTF8String];
		const char *pathCompounds = [[[NSBundle mainBundle] pathForResource:@"pteCompounds" ofType:@"db"] UTF8String];
		const char *pathIndex =     [[[NSBundle mainBundle] pathForResource:@"pteIndex"     ofType:@"db"] UTF8String];
		const char *pathEquations = [[[NSBundle mainBundle] pathForResource:@"pteEquations" ofType:@"db"] UTF8String];
		
		int dbrc;
		
		switch ([searchCriteria indexOfSelectedItem])
		{
			case 0:
				dbrc = sqlite3_open_v2(pathIndex, &db, SQLITE_OPEN_READONLY, NULL);
				break;
			case 1:
				dbrc = sqlite3_open_v2(pathCompounds, &db, SQLITE_OPEN_READONLY, NULL);
				break;
			case 2:
				dbrc = sqlite3_open_v2(pathConstants, &db, SQLITE_OPEN_READONLY, NULL);
				break;
			case 3:
				dbrc = sqlite3_open_v2(pathEquations, &db, SQLITE_OPEN_READONLY, NULL);
				break;
		}
		
		if (dbrc != SQLITE_OK)
		{
			NSLog(@"SQlite ERROR");
		}
		else
		{			
            int resultCount = 0;
            
            sqlite3_stmt *dbps;
		
            NSString *HTMLData = [HTMLUtility getDocHeader];
            
            NSString *queryNS = [SQLUtility getSQLFind:[searchCriteria indexOfSelectedItem] with:userStuff];
				
			const char *query = [queryNS UTF8String];
			dbrc = sqlite3_prepare_v2(db, query, -1, &dbps, NULL );
			
			switch ([searchCriteria indexOfSelectedItem])
			{

				case 0: // PTE Content Search
				{
					NSString *currentWord = @"";
			
					while (sqlite3_step(dbps) == SQLITE_ROW)
					{
						resultCount++;
				
						NSString *pteWord  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
						NSString *pteLink  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 1)];
						NSString *pteTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 2)];
						int pteType        = sqlite3_column_int(dbps, 3);
				
						if (![currentWord isEqualToString:pteWord])
						{	
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/><img src=\"bluecube.gif\"> <b class=\"JF\">%@</b><br/>", pteWord]];						
					
							currentWord = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
						}
                        
                        HTMLData = [HTMLData stringByAppendingString:
                                    [NSString stringWithFormat:@"&nbsp;&nbsp;&nbsp;<a class=\"%@\" href=\"%@\">%@</a><br/>", [HTMLUtility getTypeClass:pteType], pteLink, pteTitle]];
                        
						[pteTitle release];
						[pteLink release];
						[pteWord release];
					}
			
					NSString *header = [NSString stringWithFormat:[HTMLUtility getFoundResultsFor:[searchCriteria indexOfSelectedItem]], resultCount, userStuff];
			
					HTMLData = [header stringByAppendingString: HTMLData];
			
					break;
				}
			
				case 1: // COMPOUNDS search
				{
					NSString *pteName     = @"";
					NSString *pteFormulaF = @"";
					NSString *cas         = @"";
					NSString *other1      = @"";
					NSString *other2      = @"";
					NSString *other3      = @"";
					NSString *other4      = @"";
					NSString *other5      = @"";
			 		NSString *other6      = @"";
			  
					while (sqlite3_step(dbps) == SQLITE_ROW)
					{
						resultCount++;
			 
						pteName     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
						pteFormulaF = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 1)];
						cas         = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 3)];
						other1      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 4)];
						other2      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 5)];
						other3      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 6)];
						other4      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 7)];
						other5      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 8)];
						other6      = [NSString stringWithUTF8String:(char *)sqlite3_column_text(dbps, 9)];
			 
						HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/><img src=\"bluecube.gif\"> <b class=\"JF\">%@</b><br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;%@<br/>", pteName, pteFormulaF]];
			 
						if ([cas length] > 0)
						{
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"JX\">CAS:</span> <i class=\"JF\">%@</i><br/><br/>", cas]];
						}
			 
						if ([other1 length] > 0)
						{
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other1]];
			 
							if ([other2 length] > 0)
							{
								HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other2]];
							}
			 
							if ([other3 length] > 0)
							{
								HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other3]];
							}
			 
							if ([other4 length] > 0)
							{
								HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other4]];
							}
			 
							if ([other5 length] > 0)
							{
								HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other5]];
							}
			 
							if ([other6 length] > 0)
							{
								HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getIndentItalic], other6]];
							}
						}
						
					}

					NSString *header = [NSString stringWithFormat:[HTMLUtility getFoundResultsFor:[searchCriteria indexOfSelectedItem]], resultCount, userStuff];
			 
					HTMLData = [header stringByAppendingString: HTMLData];
			 
					break;
				}
			
				case 2: // CONSTANTS search
				{
					
					while (sqlite3_step(dbps) == SQLITE_ROW)
					{
						NSString *pteName   = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
						NSString *pteSymbol = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 1)];
						NSString *pteValue  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 2)];
						NSString *pteUnits  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 3)];
						NSString *pteUncer  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 4)];
						
						HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/><img src=\"bluecube.gif\"> <b class=\"JF\">%@</b><br/><br/>&nbsp;&nbsp;&nbsp;%@ %@<br/>", pteName, pteValue, pteUnits]];
						
						if ([pteUncer length] > 0)
						{
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/>&nbsp;&nbsp;&nbsp;uncertainty: %@<br/>", pteUncer]];
						}
						
						[pteUncer release];
						[pteUnits release];
						[pteValue release];
						[pteSymbol release];
						[pteName release];
                        
                        resultCount++;
					}
					
					NSString *header = [NSString stringWithFormat:[HTMLUtility getFoundResultsFor:[searchCriteria indexOfSelectedItem]], resultCount, userStuff];
					
					HTMLData = [header stringByAppendingString: HTMLData];
					
					break;
				}
					
				case 3: // EQUATIONS search
				{
					while (sqlite3_step(dbps) == SQLITE_ROW)
					{
                    	NSString *pteLink  = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 0)];
						NSString *pteTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(dbps, 1)];
						
						HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/><img src=\"bluecube.gif\"> <a class=\"qlink\" href=\"%@.htm\">%@</a>", pteLink, pteTitle]];
						
						[pteTitle release];
						[pteLink release];
					
                        resultCount++;
                    }
					
					NSString *header = [NSString stringWithFormat:[HTMLUtility getFoundResultsFor:[searchCriteria indexOfSelectedItem]], resultCount, userStuff];
					
					HTMLData = [header stringByAppendingString: HTMLData];
					
					break;
				}
			}
		
			NSString *fileName = [[NSBundle mainBundle] resourcePath];
            
			[[searchWebView mainFrame] loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:fileName]];

			sqlite3_close(db);			
		}
	}
}

// ================================================================================================================
// ================================================================================================================
// == Mass Calculator =============================================================================================
// ================================================================================================================
// ================================================================================================================

- (int) SymbolToAn: (NSString *)symbol {
	
	int anIndex         = -1;
	int symbolListIndex =  0;
	
	while ((anIndex == -1) && (symbolListIndex < 118))
	{
		if ([symbol caseInsensitiveCompare:(NSString *)[elementSymbols objectAtIndex: symbolListIndex]] == NSOrderedSame)
		{
			anIndex = symbolListIndex;
		}
		
		symbolListIndex++;
	}
    
	return anIndex;
}

-(IBAction) clickMassCalc:(id)sender {
	
	NSString *userStuff = [sender stringValue];
    
    NSCharacterSet *setOfLetters  = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    NSCharacterSet *setOfULetters = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSCharacterSet *setOfNumbers  = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
    NSRange validityCheck = [userStuff rangeOfCharacterFromSet:setOfULetters];
    
	if (([userStuff length] > 0) && (validityCheck.location != NSNotFound))
	{
		int ElementCount[118];
		int lastQuantity = 1;
		int QuantityModifier = 1;
		int foundElement;
		float am = 0.0;
		NSString *tempStore = @"";
		NSString *quantity  = @"";
		NSString *cxc       = @"";
					
		NSCharacterSet *setOfLetters  = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
		NSCharacterSet *setOfULetters = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
		NSCharacterSet *setOfNumbers  = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
        NSString *HTMLData = [HTMLUtility getDocHeader];
	
		NSMutableArray *qmList = [[NSMutableArray alloc] initWithCapacity:6];
		[qmList addObject:@"1"];
					
		for (int t = 0; t < 118; t++)
		{
			ElementCount[t] = 0;
		}

    
        for (int t = [userStuff length] - 1; t >= 0; t--)
        {
            cxc = [userStuff substringWithRange:NSMakeRange(t,1)];
					
            tempStore = [NSString stringWithFormat:@"%@%@", cxc, tempStore];
						
            NSRange letterRange  = [cxc rangeOfCharacterFromSet:setOfLetters];
            NSRange letterURange = [cxc rangeOfCharacterFromSet:setOfULetters];
            NSRange numberRange  = [cxc rangeOfCharacterFromSet:setOfNumbers];
						
            if (letterRange.location != NSNotFound)
            {
							
                if (letterURange.location != NSNotFound)            // if we find a lowercase letter we EXPECT it to come before an uppercase letter
                {
                    foundElement = [self SymbolToAn: tempStore];
					
                    if (foundElement != -1)
                    {
                        ElementCount[foundElement] = ElementCount[foundElement] + (lastQuantity * QuantityModifier);
								
                        tempStore    = @"";
                        quantity     = @"";
                        lastQuantity = 1;
                    }
                    else
                    {
                        HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/>&nbsp;<b>Unknown Element: %@</b><br/>", tempStore]];

                        tempStore = @"";
                        quantity  = @"";
                    }
                }
            }
            else if (numberRange.location != NSNotFound)
            {
                quantity     = [NSString stringWithFormat:@"%@%@", tempStore, quantity];
							
                tempStore    = @"";
							
                lastQuantity = [quantity intValue];
            }
            else if (([cxc isEqualToString:@")"]) || ([cxc isEqualToString:@"]"]))
            {
                quantity = @"";
							
                QuantityModifier = QuantityModifier * lastQuantity;
							
                [qmList addObject:[NSString stringWithFormat:@"%d", QuantityModifier]];
							
                lastQuantity = 1;
							
                tempStore = @"";
            }
            else if (([cxc isEqualToString:@"("]) || ([cxc isEqualToString:@"["]))
            {
                [qmList removeLastObject];
				
                NSString *lastQM = (NSString *)[qmList objectAtIndex: [qmList count]-1];
							
                QuantityModifier = [lastQM intValue];
					   
                tempStore        = @"";
            }
        }
			
		if (![tempStore isEqualToString:@""])
		{
			ElementCount[[self SymbolToAn: tempStore]] = ElementCount[[self SymbolToAn: tempStore]] + 1;
		}
					
		// ===============================================================================================
		// == stage 1: calculate atomic mass now =========================================================
		// ===============================================================================================
					
		for (int t = 0; t < 118; t++)
		{
			if (ElementCount[t] != 0)
			{
				am = am + (ElementCount[t] * atomicMass[t]);
			}
		}
					
		HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<br/>&nbsp;&nbsp;&nbsp;Total Mass: <b>%f</b> u<br/><br/>", am]];
				
		// ===============================================================================================
		// == stage 2: calculate % weight by element =====================================================
		// ===============================================================================================
					
		float pam = 0.0;
		float tam = 0.0;
					
		for (int t = 0; t < 118; t++)
		{
			if (ElementCount[t] !=0)
			{
				pam = ((ElementCount[t] * atomicMass[t]) / am) * 100;
				tam = ElementCount[t] * atomicMass[t];
							
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getMassOutput],
                                                               t + 1,
                                                               (NSString *)[elementSymbols objectAtIndex: t], ElementCount[t], pam, tam]];
			
				if ([showMassData state] == NSOnState)
				{
					if ([showMassDataLocation selectedTag] == 1)
					{
						NSDictionary *anElement = (NSDictionary *)[massData objectAtIndex:t];

						int massIsoCounts = [[anElement objectForKey:@"atomicicoint"] intValue];

						HTMLData = [HTMLData stringByAppendingString:@"<br/><table width=\"100%\" class=\"pf\"><tr><td width=\"20\">&nbsp;</td><td width=\"20%\">Isotope</td><td width=\"40%\">Natural Occurence</td><td width=\"25%\">Mass</td></tr>"];
					
						for (int z = 1; z <= massIsoCounts; z++)
						{
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<tr class=\"JZ\"><td>&nbsp;</td><td>%@</td><td>%@%%</td><td>%@</td></tr>", [anElement objectForKey:[NSString stringWithFormat:@"iname%d", z]], [anElement objectForKey:[NSString stringWithFormat:@"ip%d", z]], [anElement objectForKey:[NSString stringWithFormat:@"iw%d", z]]]];
						}

						HTMLData = [HTMLData stringByAppendingString:@"</table><br/>"];
					}
				}
			}
		}
					
		// ===============================================================================================
		// == now lets add subscripts to the formula =====================================================
		// ===============================================================================================
					
		int superMode = 0;
		int subMode   = 0;
					
		NSString *fs = @"";
					
		for (int t = 0; t < [userStuff length]; t++)
		{
						
			NSRange numberRange = [[userStuff substringWithRange:NSMakeRange(t, 1)] rangeOfCharacterFromSet:setOfNumbers];
						
			if (numberRange.location != NSNotFound)
			{
							
				if (superMode == 1)
				{
					fs = [fs stringByAppendingString:[userStuff substringWithRange:NSMakeRange(t,1)]];
				}
				else
				{
					if (t == 0)/* or (formula[t-1]='.') then*/
					{
						if (subMode == 1)
						{
							fs = [fs stringByAppendingString: @"</sub>"];
							
							subMode = 0;
						}
										
						fs = [fs stringByAppendingString:[userStuff substringWithRange:NSMakeRange(t,1)]];
					}
					else
					{
						if (subMode == 1)
						{
							fs = [fs stringByAppendingString:[userStuff substringWithRange:NSMakeRange(t,1)]];
						}
						else
						{
							fs = [fs stringByAppendingString: @"<sub>"];
							fs = [fs stringByAppendingString:[userStuff substringWithRange:NSMakeRange(t,1)]];
						}
									
						subMode  = 1;
					}
				}
			}
			else
			{
				if (subMode == 1)
				{
					fs = [fs stringByAppendingString: @"</sub>"];
							
					subMode = 0;
				}
							
				fs = [fs stringByAppendingString:[userStuff substringWithRange:NSMakeRange(t,1)]];
			}
		}
					
					
		if (subMode == 1)
		{
			fs = [fs stringByAppendingString: @"</sub>"];
		}

		// ===============================================================================================
		// ===============================================================================================

		if ([showMassData state] == NSOnState)
		{
			if ([showMassDataLocation selectedTag] == 0)
			{
				for (int t = 0; t < 118; t++)
				{
					if (ElementCount[t] != 0)
					{
						NSDictionary *anElement = (NSDictionary *)[massData objectAtIndex:t];
						
						int massIsoCounts = [[anElement objectForKey:@"atomicicoint"] intValue];
						
						HTMLData = [HTMLData stringByAppendingString:@"<br/><table width=\"100%\" class=\"pf\"><tr><td width=\"20\">&nbsp;</td><td width=\"20%\">Isotope</td><td width=\"40%\">Natural Occurence</td><td width=\"25%\">Mass</td></tr>"];
						
						for (int z = 1; z <= massIsoCounts; z++)
						{
							HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"<tr class=\"JZ\"><td>&nbsp;</td><td>%@</td><td>%@%%</td><td>%@</td></tr>", [anElement objectForKey:[NSString stringWithFormat:@"iname%d", z]], [anElement objectForKey:[NSString stringWithFormat:@"ip%d", z]], [anElement objectForKey:[NSString stringWithFormat:@"iw%d", z]]]];
						}
						
						HTMLData = [HTMLData stringByAppendingString:@"</table><br/>"];
					}
				}
			}
		}
		
		// ===============================================================================================
		// ===============================================================================================

		NSString *header = [NSString stringWithFormat:@"<div style=\"background-color:#FF88FF\" align='center'>Molecular Mass for \"<b>%@</b>\"</div>", fs];
	
		HTMLData = [header stringByAppendingString: HTMLData];
					
		[qmList release];
					
		NSString *fileName = [[NSBundle mainBundle] resourcePath];
		[[massCalcWebView mainFrame] loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:fileName]];
	}
    else
    {        
        NSString *fileName = [[NSBundle mainBundle] resourcePath];
        [[massCalcWebView mainFrame] loadHTMLString:[HTMLUtility getCalcErrorPage] baseURL:[NSURL fileURLWithPath:fileName]];
    }
	
}

- (IBAction) clickShowAllMassData:(id)sender {
	
	if (sender != showMassDataLocation)
	{
		if ([sender state] == NSOnState)
		{
			showMassData.tag = 1;
	
			[showMassDataLocation setEnabled:YES];
		}
		else
		{
			showMassData.tag = 0;
		
			[showMassDataLocation setEnabled:NO];
		}
	}
		
	[self clickMassCalc:moleculeToCalculate];
}

// ================================================================================================================
// ================================================================================================================
// == Search Properties ===========================================================================================
// ================================================================================================================
// ================================================================================================================

- (NSString*) processScientificNotation:(NSString*)input {
	
	NSString *output = [input stringByReplacingOccurrencesOfString:@"x 10" withString:@"x 10<sup>"];

	output = [output stringByAppendingString:@"</sup>"];
	
	return [output autorelease];
}

- (IBAction) includePropertiesClick:(id)sender {
	
	[self searchPropertiesClick:NULL];
}

- (IBAction) searchPropertiesClick:(id)sender {
	
	NSInteger propertiesType[3];
	float propertiesValueFrom[3];
	float propertiesValueTo[3];
	int foundCount = 0;
	
	propertiesType[0] = [propertyFromValue1 tag];
	propertiesType[1] = [propertyFromValue2 tag];	
	propertiesType[2] = [propertyFromValue3 tag];	

	// ===========================================================================================================
	// ===========================================================================================================
	
	propertiesValueFrom[0] = [propertyFromValue1 floatValue];
	if ([[propertyToValue1 stringValue] isEqualTo:@""])
	{
		propertiesValueTo[0] = [propertyFromValue1 floatValue];
	
		[propertyToValue1 setStringValue:[propertyFromValue1 stringValue]];
	}
	else
	{
		propertiesValueTo[0] = [propertyToValue1 floatValue];
	}

	propertiesValueFrom[1] = [propertyFromValue2 floatValue];
	if ([[propertyToValue2 stringValue] isEqualTo:@""])
	{
		propertiesValueTo[1] = [propertyFromValue2 floatValue];
		
		[propertyToValue2 setStringValue:[propertyFromValue2 stringValue]];
	}
	else
	{
		propertiesValueTo[1] = [propertyToValue2 floatValue];
	}
		
	propertiesValueFrom[2] = [propertyFromValue3 floatValue];
	if ([[propertyToValue3 stringValue] isEqualTo:@""])
	{
		propertiesValueTo[2] = [propertyFromValue3 floatValue];
		
		[propertyToValue3 setStringValue:[propertyFromValue3 stringValue]];
	}
	else
	{
		propertiesValueTo[2] = [propertyToValue3 floatValue];
	}
	
	// ============================================================================================================
	// ============================================================================================================
	
    NSString *HTMLData = [HTMLUtility getDocHeader];
    
	NSString *propertyData = @"";
	
	if ([includeProperties state] == NSOnState)
	{
		if (propertiesType[0] != -1)
		{
			if (((propertiesType[0] >= 305) && (propertiesType[0] <= 307)) || ((propertiesType[0] >= 401) && (propertiesType[0] <= 402)))
			{	
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivContaining], [selectProperty1 title], [propertyFromValue1 stringValue]]];
			}
			else
			{
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivProperty], [selectProperty1 title], [propertyFromValue1 stringValue], [propertyUnitsT1 stringValue], [propertyToValue1 stringValue], [propertyUnitsT1 stringValue]]];
			}
		}
		
		if (propertiesType[1] != -1)
		{
			if (((propertiesType[1] >= 305) && (propertiesType[1] <= 307)) || ((propertiesType[1] >= 401) && (propertiesType[1] <= 402)))
			{	
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivContaining], [selectProperty2 title], [propertyFromValue2 stringValue]]];
			}
			else
			{
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivProperty], [selectProperty2 title], [propertyFromValue2 stringValue], [propertyUnitsT2 stringValue], [propertyToValue2 stringValue], [propertyUnitsT2 stringValue]]];
			}
		}
		
		if (propertiesType[2] != -1)
		{
			if (((propertiesType[2] >= 305) && (propertiesType[2] <= 307)) || ((propertiesType[2] >= 401) && (propertiesType[2] <= 402)))
			{	
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivContaining], [selectProperty3 title], [propertyFromValue3 stringValue]]];
			}
			else
			{
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:[HTMLUtility getDivProperty], [selectProperty3 title], [propertyFromValue3 stringValue], [propertyUnitsT3 stringValue], [propertyToValue3 stringValue], [propertyUnitsT3 stringValue]]];
			}
		}
		
		HTMLData = [HTMLData stringByAppendingString:@"<br/>"];
	}

	// ============================================================================================================
	
	if ((propertiesType[0] != -1) || (propertiesType[1] != -1) || (propertiesType[2] != -1))
	{	
		for (int t = 0; t < 118; t++)
		{
			NSDictionary *anElement = (NSDictionary *)[elementData objectAtIndex:t];

			bool doesMatch = TRUE;
		
			propertyData = @"";
		
			for (int p = 0; p < 3; p++)
			{
				if (propertiesType[p] != -1)
				{
					switch (propertiesType[p])
					{
						case 100: // == abundance (Earth's Core) ======================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"aec_s"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"aec_s"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:100], [self processScientificNotation:[anElement objectForKey:@"aec"]]]];
							}
							break;
                        }
                        case 101: // == human (atoms)
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"aha_s"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"aha_s"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:101], [self processScientificNotation:[anElement objectForKey:@"aha"]]]];
							}
							break;
                        }
                        case 102: // == human (mass)
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"ahw_s"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"ahw_s"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:102], [self processScientificNotation:[anElement objectForKey:@"ahw"]]]];
							}
							break;
                        }
                        case 103: // == sun
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"as_s"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"as_s"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                  [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:103],[self processScientificNotation:[anElement objectForKey:@"as"]]]];
							}
							break;
                        }
						case 104: // == universe
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"au_s"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"au_s"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                  [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:104], [self processScientificNotation:[anElement objectForKey:@"au"]]]];
							}
							break;
                        }
						case 200: // == atomic radius =================================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"ar"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"ar"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:200], [anElement objectForKey:@"ar"]]];
							}
							break;
                        }
                        case 201: // == atomic volume
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"av"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"av"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:201], [anElement objectForKey:@"av"]]];
							}
							break;
                        }
                        case 202: // == electronegativity (Pauling)
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"enps"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"enps"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:202], [anElement objectForKey:@"enps"]]];
							}
							break;
                        }
                        case 203: // == valence electron potential
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"vep"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"vep"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:203], [anElement objectForKey:@"vep"]]];
							}
							break;
                        }
						case 300: // == atomic mass ====================================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"atomicweight"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"atomicweight"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:300], [anElement objectForKey:@"atomicweight"]]];
							}
							break;
                        }
						case 301: // == atomic number
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"atomicnumber"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"atomicnumber"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:301], [anElement objectForKey:@"atomicnumber"]]];
							}
							break;
                        }
						case 302: // == boiling point
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"bp"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"bp"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:302], [anElement objectForKey:@"bp"]]];
							}
							break;
                        }
						case 303: // == density
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"density"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"density"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:303], [anElement objectForKey:@"density"]]];
							}
							break;
                        }
                        case 304: // == melting point
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"mp"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"mp"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:304], [anElement objectForKey:@"mp"]]];
							}
							break;
                        }
                        case 305: // == name
						{
							NSTextField *tf;
						
							tf = (NSTextField *)[stringProperties objectAtIndex: p];
						
							NSRange range = [[anElement objectForKey:@"name"] rangeOfString:[tf stringValue] options:NSCaseInsensitiveSearch];
						
							if (range.location == NSNotFound)
							{
								doesMatch = FALSE;
							}
							else
							{
								//propertyData = [propertyData  stringByAppendingString: [NSString stringWithFormat:@"D<sub>discovery</sub>: %@", [anElement objectForKey:@"dd"]]];
							}
							break;
						}
						case 306: // == symbol
						{
							NSTextField *tf;
						
							tf = (NSTextField *)[stringProperties objectAtIndex: p];
						
							NSRange range = [[anElement objectForKey:@"symbol"] rangeOfString:[tf stringValue] options:NSCaseInsensitiveSearch];
						
							if (range.location == NSNotFound)
							{
								doesMatch = FALSE;
							}
							else
							{
								//propertyData = [propertyData  stringByAppendingString: [NSString stringWithFormat:@"D<sub>discovery</sub>: %@", [anElement objectForKey:@"dd"]]];
							}
							break;
						}
						case 307: // == state
						{
							NSTextField *tf;
						
							tf = (NSTextField *)[stringProperties objectAtIndex: p];
						
							NSRange range = [[anElement objectForKey:@"state"] rangeOfString:[tf stringValue] options:NSCaseInsensitiveSearch];
						
							if (range.location == NSNotFound)
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:307], [anElement objectForKey:@"state"]]];
							}
							break;
						}
						case 400: // == discovery date =================================================================================					
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"dd"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"dd"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:400], [anElement objectForKey:@"dd"]]];
							}
							break;
                        }
                        case 401: // == discovery where
						{
							NSTextField *tf;
						
							tf = (NSTextField *)[stringProperties objectAtIndex: p];
						
							NSRange range = [[anElement objectForKey:@"dl"] rangeOfString:[tf stringValue] options:NSCaseInsensitiveSearch];
						
							if (range.location == NSNotFound)
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:401], [anElement objectForKey:@"dl"]]];
							}
							break;
						}					
						case 402: // == discovery who
						{
							NSTextField *tf;
						
							tf = (NSTextField *)[stringProperties objectAtIndex: p];
						
							NSRange range = [[anElement objectForKey:@"dw"] rangeOfString:[tf stringValue] options:NSCaseInsensitiveSearch];
						
							if (range.location == NSNotFound)
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:402], [anElement objectForKey:@"dw"]]];
							}
							break;
						}
						case 500: // == electrical conductivity ========================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"ec"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"ec"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:500], [anElement objectForKey:@"ec"]]];
							}
							break;
                        }
						case 501: // == electrical resistance
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"er"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"er"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:501], [anElement objectForKey:@"er"]]];
							}
							break;
                        }
                        case 600: // == brinell hardness ===============================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"bh"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"bh"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:600], [anElement objectForKey:@"bh"]]];
							}
							break;
                        }
                        case 601: // == bulk modulus
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"bm"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"bm"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:601], [anElement objectForKey:@"bm"]]];
							}
							break;
                        }
						case 602: // == poisson ratio
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"pr"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"pr"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:602], [anElement objectForKey:@"pr"]]];
							}
							break;
                        }
                        case 603: // == shear modulus
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"sm"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"sm"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:603], [anElement objectForKey:@"sm"]]];
							}
							break;
                        }
						case 604: // == speed of sound
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"sos"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"sos"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:604], [anElement objectForKey:@"sos"]]];
							}
							break;
                        }
						case 605: // == vickers hardness
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"vh"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"vh"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:605], [anElement objectForKey:@"vh"]]];
							}
							break;
                        }
                        case 606: // == young's modulus
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"ym"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"ym"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:606], [anElement objectForKey:@"ym"]]];
							}
							break;
                        }
                        case 700: // == enthalpy of fusion ==============================================================================
                        {
                            if ((propertiesValueFrom[p] > [[anElement objectForKey:@"eof"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"eof"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:700], [anElement objectForKey:@"eof"]]];
							}
							break;
                        }
                        case 701: // == enthalpy of vaporisation
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"tc"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"tc"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:701], [anElement objectForKey:@"tc"]]];
							}
							break;
                        }
                        case 702: // == heat capacity
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"hc"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"hc"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:702], [anElement objectForKey:@"hc"]]];
							}
							break;
                        }
                        case 703: // == thermal conductivity
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"tc"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"tc"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:703], [anElement objectForKey:@"tc"]]];
							}
							break;
                        }
                        case 704: // == thermal resistivity
                        {
							if ((propertiesValueFrom[p] > [[anElement objectForKey:@"tr"] floatValue]) || (propertiesValueTo[p] < [[anElement objectForKey:@"tr"] floatValue]))
							{
								doesMatch = FALSE;
							}
							else
							{
								propertyData = [propertyData stringByAppendingString:
                                                   [NSString stringWithFormat:[HTMLUtility getDivPropertyLong:704], [anElement objectForKey:@"tr"]]];
							}
							break;
                        }
                        default:
							break;
					}
				}
			}
														   
			if (doesMatch)
			{
				HTMLData = [HTMLData stringByAppendingString:
                               [NSString stringWithFormat:@"&nbsp;<a href=\"%d.htm\">%@ (%@)</a><br/>", t + 1,
                                   [anElement objectForKey:@"name"], [anElement objectForKey:@"symbol"]]];
                
				HTMLData = [HTMLData stringByAppendingString: [NSString stringWithFormat:@"%@<br/>", propertyData]];
		
				foundCount++;
			}												  
		}
	}
	else
	{
		HTMLData = [HTMLData stringByAppendingString:@"Please select one or more properties to search!"];		
	}
		
	NSString *header = [NSString stringWithFormat:@"<div style=\"background-color:#88FFFF\" align='center'>Property Search, found %d.</div><br/>", foundCount];
	
	HTMLData = [header stringByAppendingString: HTMLData];	
	
	NSString *fileName = [[NSBundle mainBundle] resourcePath];
	[[searchPropertiesView mainFrame] loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:fileName]];
}

- (IBAction) selectPropertyClick:(id)sender {
	
	bool textSearchMode = FALSE;

	NSInteger pI = [[sender parentItem] tag];
	
	if ([sender tag] >= 1000)
	{
		pI = [sender tag] - 1000;
	}
		
	switch (pI)
	{
		case 0:			
			if ([sender tag] != 1000)
			{
				[selectProperty1 setTitle:[sender title]];
				propertyFromValue1.tag = [sender tag];			
			}
			else
			{	
				[selectProperty1 setTitle:@"Select..."];
				propertyFromValue1.tag = -1;			
				
				[propertyFromValue1 setStringValue:@""];
				[propertyToValue1 setStringValue:@""];
			}

			[propertyUnitsF1 setStringValue:[Utility getPropertyFrom:[sender tag]]];
			[propertyUnitsT1 setStringValue:[Utility getPropertyFrom:[sender tag]]];

			// ===============================================================================================
			
			if ((([sender tag] >= 305) && ([sender tag] <= 307)) || (([sender tag] >= 401) && ([sender tag] <= 402)))
			{
				textSearchMode = TRUE;
				
				[[propertyFromValue1 cell] setPlaceholderString:@"contains..."];
			}
			else
			{
				[[propertyFromValue1 cell] setPlaceholderString:@"from..."];
			}

			[propertyToValue1 setHidden:textSearchMode];
			[propertyUnitsT1 setHidden:textSearchMode];
			
			break;
		case 1:
			if ([sender tag] != 1001)
			{
				[selectProperty2 setTitle:[sender title]];
				propertyFromValue2.tag = [sender tag];			
			}
			else
			{	
				[selectProperty2 setTitle:@"Select..."];
				propertyFromValue2.tag = -1;			
				
				[propertyFromValue2 setStringValue:@""];
				[propertyToValue2 setStringValue:@""];
			}

			[propertyUnitsF2 setStringValue:[Utility getPropertyFrom:[sender tag]]];
			[propertyUnitsT2 setStringValue:[Utility getPropertyFrom:[sender tag]]];
			
			// ===============================================================================================

			if ((([sender tag] >= 305) && ([sender tag] <=307)) || (([sender tag] >= 401) && ([sender tag] <=402)))
			{
				textSearchMode = TRUE;
				
				[[propertyFromValue2 cell] setPlaceholderString:@"contains..."];
			}
			else
			{
				[[propertyFromValue2 cell] setPlaceholderString:@"from..."];
			}
			
			[propertyToValue2 setHidden:textSearchMode];
			[propertyUnitsT2 setHidden:textSearchMode];
			
			break;
		case 2:
			if ([sender tag] != 1002)
			{
				[selectProperty3 setTitle:[sender title]];
				propertyFromValue3.tag = [sender tag];			
			}
			else
			{	
				[selectProperty3 setTitle:@"Select..."];
				propertyFromValue3.tag = -1;		
				
				[propertyFromValue3 setStringValue:@""];
				[propertyToValue3 setStringValue:@""];
			}
			
			[propertyUnitsF3 setStringValue:[Utility getPropertyFrom:[sender tag]]];
			[propertyUnitsT3 setStringValue:[Utility getPropertyFrom:[sender tag]]];
			
			// ===============================================================================================

			if ((([sender tag] >= 305) && ([sender tag] <= 307)) || (([sender tag] >= 401) && ([sender tag] <= 402)))
			{
				textSearchMode = TRUE;
				
				[[propertyFromValue3 cell] setPlaceholderString:@"contains..."];
			}
			else
			{
				[[propertyFromValue3 cell] setPlaceholderString:@"from..."];
			}
			
			[propertyToValue3 setHidden:textSearchMode];
			[propertyUnitsT3 setHidden:textSearchMode];
			
			break;
	}
}

-(IBAction) selectIndex:(id)sender {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[Utility getIndexFileName:[sender indexOfSelectedItem]] ofType:@"htm"];
    
    [[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}

// ================================================================================================================
// ================================================================================================================
// == Graph and State Display Code ================================================================================
// ================================================================================================================
// ================================================================================================================

-(IBAction) selectGraph:(id)sender {
	
	switch ([sender indexOfSelectedItem])
	{
		case 0:
			[self buildDefault];
			break;
		case 1:
			[self buildAR];
			break;
		case 2:
			[self buildAV];
			break;
		case 3:
			[self buildDensity];
			break;
		case 4:
			[self buildBP];
			break;
		case 5:
			[self buildEN];
			break;
		case 6:
			[self buildEOA];
			break;
		case 7:
			[self buildEOF];
			break;
		case 8:
			[self buildEOV];
			break;
		case 9:
			[self buildMP];			
			break;
		case 10:
			[self buildTC];			
			break;
		case 11:
			[self buildTE];			
			break;
		case 12:		
			[self buildVEP];
			break;						
    }
}

-(IBAction) selectView:(id)sender {
	
	switch ([sender indexOfSelectedItem])
	{
		case 0:
			[self buildDefault];
			break;
		case 1:
			[self buildState:1];
			break;
		case 2:
			[self buildState:3];
			break;
		case 3:
			[self buildState:2];
			break;
		case 4:
			[self buildState:4];
			break;
		case 5:
			[self buildRadioactive];
			break;		
	}
}

- (void) buildDefault {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		NSDictionary *anElement = (NSDictionary *)[ptData objectAtIndex:t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"type%d.png", [[anElement objectForKey:@"type"] intValue]]]];
	}
}

- (void) buildState: (int)elementState {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
        [thisButton setImage:[NSImage imageNamed:[Utility getStateImage:state[t] withElementState:elementState]]];
	}
}

- (void) buildRadioactive {
	
	NSButton *thisButton;
	
	for (int an = 0; an < 118; an++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: an];
		
        [thisButton setImage:[NSImage imageNamed:[Utility getRadiationImage:an]]];
 	}
}

- (void) buildHuman {
	
}	

- (void) buildDensity {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataDensity[t]]]];
	}
}

- (void) buildEN {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataEN[t]]]];
	}
}

- (void) buildBP {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataBP[t]]]];
	}
}

- (void) buildMP {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataMP[t]]]];
	}
}

- (void) buildAR {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataAR[t]]]];
	}
}

- (void) buildAV {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataAV[t]]]];
	}
}

- (void) buildVEP {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataVEP[t]]]];
	}
}

- (void) buildEOA {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataEOA[t]]]];
	}
}

- (void) buildEOF {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataEOF[t]]]];
	}
}

- (void) buildEOV {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataEOV[t]]]];
	}
}

- (void) buildTC {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataTC[t]]]];
	}
}

- (void) buildTE {
	
	NSButton *thisButton;
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		[thisButton setImage:[NSImage imageNamed:[NSString stringWithFormat:@"grad%d.png", dataTE[t]]]];
	}
}

// ================================================================================================================
// ================================================================================================================
// == Country Page Code ===========================================================================================
// ================================================================================================================
// ================================================================================================================

- (IBAction) continentListClick:(id)sender {

    if (sender != NULL)
    {
        continentList.tag = [sender tag];
	}
    else
    {
        continentList.tag = 0;
    }
    
	[countryList removeAllItems];

    NSString *continentID = [Utility getCountryCode:continentList.tag];
    
    for (int t = 0; t < countryCount; t++)
    {
        NSDictionary *cdCountry = (NSDictionary *)[countryData objectAtIndex:t];
 
        if ([continentID isEqualToString:[cdCountry objectForKey:@"continent"]])
        {
            [countryList addItemWithObjectValue:[cdCountry objectForKey:@"name"]];
        }
    }
	
	[countryList selectItemAtIndex:0];
    
    [self countryListClick:NULL];
}

- (IBAction) countryListClick:(id)sender {
	
    NSString *selectedCountry = (NSString*)[countryList objectValueOfSelectedItem];
       
    for (int t = 0; t < countryCount; t++)
    {
        NSDictionary *cdCountry = (NSDictionary *)[countryData objectAtIndex:t];
        
        if ([selectedCountry isEqualToString:[cdCountry objectForKey:@"name"]])
        {
            NSArray *products = [[cdCountry objectForKey:@"data"] componentsSeparatedByString:@","];
            
            if (products.count == 2)
            {
                [productionList setStringValue:[products objectAtIndex:0]];
            }
            else
            {
                NSString *productOutput = @"";
                
                for (int p = 0; p < products.count - 1; p++)
                {
                    productOutput = [productOutput stringByAppendingString:[products objectAtIndex:p]];
                
                    if (p != products.count - 2)
                    {
                        productOutput = [productOutput stringByAppendingString:@", "];
                    }
                    
                    if (p == products.count - 3)
                    {
                        productOutput = [productOutput stringByAppendingString:@"and "];
                    }
                }
                
                [productionList setStringValue:productOutput];
            }
        
            [mapImage setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@_m.png", [cdCountry objectForKey:@"code"]]]];
        
            currentCountry = [cdCountry objectForKey:@"code"];
            
            break;
        }
    }
	
}

- (IBAction) openCountryPage:(id)sender {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"m%@", currentCountry] ofType:@"htm"];

    [[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]]; 
}

// ================================================================================================================
// ================================================================================================================
// == Menu Items Code =============================================================================================
// ================================================================================================================
// ================================================================================================================

- (IBAction) setAutoPlaySpeechClick:(id)sender {
    
    [sender setState:NSOnState];
    
    if ([sender tag] == 1)
    {
        [autoPlaySpeechOn setState:NSOffState];
    }
    else
    {
        [autoPlaySpeechOff setState:NSOffState];
    }
}

-(IBAction) setPTTooltips:(id)sender {
	
	NSButton *thisButton;
	
	[sender setState:NSOnState];
	
	for (int t = 0; t < 118; t++)
	{
		thisButton = (NSButton *)[myElements objectAtIndex: t];
		
		switch ([sender tag])
		{
			case 1:
			{
				[thisButton setToolTip:@""];
				break;
			}
			case 2:
			{
				NSDictionary *anElement = (NSDictionary *)[ptData objectAtIndex:t];
				
				[thisButton setToolTip:[anElement objectForKey:@"name"]];
				break;
			}
			case 3:
			{
				NSDictionary *anElement = (NSDictionary *)[ptData objectAtIndex:t];
				
				[thisButton setToolTip:[NSString stringWithFormat:[Utility getToolTipFormat],
                                            [anElement objectForKey:@"name"],
                                            [anElement objectForKey:@"symbol"],
                                            [anElement objectForKey:@"atomicnumber"],
                                            [anElement objectForKey:@"atomicweight"],
                                            [anElement objectForKey:@"state"],
                                            [anElement objectForKey:@"colour"],
                                            [anElement objectForKey:@"bp"],
                                            [anElement objectForKey:@"mp"]]];
				
				break;
			}
		}
	}
	
	if (sender == tooltipsNone)
	{
		[tooltipsSimple setState:NSOffState];
		[tooltipsDetailed setState:NSOffState];
	}
	else if (sender == tooltipsSimple)
	{
		[tooltipsNone setState:NSOffState];
		[tooltipsDetailed setState:NSOffState];
	}
	else
	{
		[tooltipsNone setState:NSOffState];
		[tooltipsSimple setState:NSOffState];
	}
}

-(IBAction) spectrumClicked:(id)sender {

	[sender setState:NSOnState];
	
	currentSpectrum = [sender tag];
	
	if ([sender tag] == 1)
	{
		[spectrumEmission setState:NSOffState];
	}
	else
	{
		[spectrumAbsorption setState:NSOffState];		
	}
	
	[self buildFromAN:currentElement];
}

- (IBAction) clickPropertiesShowRanges:(id)sender {

	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ranges" ofType:@"htm"];
	
	[[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}

-(IBAction) clickHelp:(id)sender {
    
    switch ([sender tag])
    {
        case 0:
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"htm"];
            
            [[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
         
            break;
        }
            
        case 1:
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sources" ofType:@"htm"];
            
            [[xWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
            break;
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [player release];
}

- (IBAction) clickTable:(id)sender {
 
    [mainTab selectTabViewItemAtIndex:0];
}

- (IBAction) clickImages:(id)sender {

    [mainTab selectTabViewItemAtIndex:1];
}

- (IBAction) clickSeach:(id)sender {

    [mainTab selectTabViewItemAtIndex:2];
}
    
- (IBAction) clickProperties:(id)sender {
 
    [mainTab selectTabViewItemAtIndex:3];
}
    
- (IBAction) clicCalc:(id)sender {

    [mainTab selectTabViewItemAtIndex:4];
}

- (IBAction) clickCountry:(id)sender {
    
    [mainTab selectTabViewItemAtIndex:5];
}

@end
