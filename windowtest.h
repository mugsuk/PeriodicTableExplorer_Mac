//
//  windowtest.h
//  PTE_Mac
//
//  Created by Paul Freshney on 11/08/2011.
//  Copyright 2011-2016 freshney.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h> 
#import <sqlite3.h>

@interface windowtest : NSObject <NSApplicationDelegate, NSWindowDelegate, AVAudioPlayerDelegate> {

    IBOutlet NSPanel *theSheet;
    
    IBOutlet NSWindow *newWindow;
    
	// ============================================================================================================
	// == Tool Bar ================================================================================================
	// ============================================================================================================

    
	// ============================================================================================================
	// == Menu Bar ================================================================================================
	// ============================================================================================================
    
	IBOutlet NSMenuItem *spectrumAbsorption, *spectrumEmission, *tooltipsNone, *tooltipsSimple, *tooltipsDetailed;
    IBOutlet NSMenuItem *autoPlaySpeechOn, *autoPlaySpeechOff;
	
	// ============================================================================================================
	// == Periodic Table Tab ======================================================================================
	// ============================================================================================================
		
	IBOutlet NSButton *e1,   *e2,   *e3,   *e4,   *e5,   *e6,   *e7,   *e8,   *e9,   *e10;
	IBOutlet NSButton *e11,  *e12,  *e13,  *e14,  *e15,  *e16,  *e17,  *e18,  *e19,  *e20;
	IBOutlet NSButton *e21,  *e22,  *e23,  *e24,  *e25,  *e26,  *e27,  *e28,  *e29,  *e30;
	IBOutlet NSButton *e31,  *e32,  *e33,  *e34,  *e35,  *e36,  *e37,  *e38,  *e39,  *e40;
	IBOutlet NSButton *e41,  *e42,  *e43,  *e44,  *e45,  *e46,  *e47,  *e48,  *e49,  *e50;
	IBOutlet NSButton *e51,  *e52,  *e53,  *e54,  *e55,  *e56,  *e57,  *e58,  *e59,  *e60;
	IBOutlet NSButton *e61,  *e62,  *e63,  *e64,  *e65,  *e66,  *e67,  *e68,  *e69,  *e70;
	IBOutlet NSButton *e71,  *e72,  *e73,  *e74,  *e75,  *e76,  *e77,  *e78,  *e79,  *e80;
	IBOutlet NSButton *e81,  *e82,  *e83,  *e84,  *e85,  *e86,  *e87,  *e88,  *e89,  *e90;
	IBOutlet NSButton *e91,  *e92,  *e93,  *e94,  *e95,  *e96,  *e97,  *e98,  *e99,  *e100;
	IBOutlet NSButton *e101, *e102, *e103, *e104, *e105, *e106, *e107, *e108, *e109, *e110;
	IBOutlet NSButton *e111, *e112, *e113, *e114, *e115, *e116, *e117, *e118;

	IBOutlet NSTextField *tElementName, *tElementGroup, *tElementData1, *tElementData2, *tElementData3;
		
	IBOutlet NSImageView *radioactive, *spectrum;
    
    IBOutlet NSButton *speech;

	// ============================================================================================================
	// == Images Tab ==============================================================================================
	// ============================================================================================================
	
	IBOutlet NSImageView *elementImage;
	
	IBOutlet NSTextField *imageComment, *imageCount;
	
	IBOutlet NSSlider *imageSlider;

	// ============================================================================================================
	// == Search Tab ==============================================================================================
	// ============================================================================================================
		
	IBOutlet NSTextField *searchTerm, *searchTermHelp;
	IBOutlet NSComboBox *searchCriteria;
	
	IBOutlet NSButton *goBackSearch, *goForwardSearch;
	
	IBOutlet WebView *searchWebView;

	// ============================================================================================================
	// == Search 2 Tab ============================================================================================
	// ============================================================================================================
	
	IBOutlet WebView *searchPropertiesView;
	
	IBOutlet NSPopUpButton *selectProperty1, *selectProperty2, *selectProperty3;
	
	IBOutlet NSTextField *propertyUnitsF1, *propertyUnitsT1, *propertyFromValue1, *propertyToValue1;
	IBOutlet NSTextField *propertyUnitsF2, *propertyUnitsT2, *propertyFromValue2, *propertyToValue2;
	IBOutlet NSTextField *propertyUnitsF3, *propertyUnitsT3, *propertyFromValue3, *propertyToValue3;
	
	IBOutlet NSButton *searchProperties, *includeProperties;
	
	// ============================================================================================================
	// == Mass Calculator Tab =====================================================================================
	// ============================================================================================================
		
	IBOutlet NSTextField *moleculeToCalculate;
	IBOutlet WebView *massCalcWebView;	
	
	IBOutlet NSButton *showMassData;
	
	IBOutlet NSMatrix *showMassDataLocation;
	
	// ============================================================================================================
	// == Country Tab =============================================================================================
	// ============================================================================================================

	IBOutlet NSTextField *productionList;
    IBOutlet NSImageView *mapImage;
	IBOutlet NSPopUpButton *continentList;
	IBOutlet NSComboBox *countryList;
	
	// ============================================================================================================
	// == Content Box =============================================================================================
	// ============================================================================================================
	
	IBOutlet WebView *xWebView;
	IBOutlet NSSegmentedControl *dataType1, *dataType2;
	
	IBOutlet NSButton *goBack, *goForward;
	
	IBOutlet NSButton *bGlossary, *Biographies;	
	
	// ============================================================================================================
	// == Global ==================================================================================================
	// ============================================================================================================
	
	sqlite3 *db;
    
    IBOutlet NSTabView *mainTab;
	
	NSArray *myElements;
	NSArray *stringProperties;	
    NSArray *elementSymbols;
}

- (void) buildFromAN: (NSInteger) an;

-(IBAction) clickSearch:(id)sender;
-(IBAction) clickSearchIn:(id)sender;

-(IBAction) spectrumClicked:(id)sender;

- (int) SymbolToAn: (NSString *)symbol;
-(IBAction) clickMassCalc:(id)sender;

-(IBAction) clickShowAllMassData:(id)sender;

-(IBAction) imageSliderMoved:(id)sender;

-(IBAction) elementClicked:(id)sender;

-(IBAction) typeClick:(id)sender;

-(IBAction) elementListClicked:(id)sender;
-(IBAction) setPTTooltips:(id)sender;

-(IBAction) dataType1Clicked:(id)sender;
-(IBAction) dataType2Clicked:(id)sender;

-(IBAction) clickOnThisDay:(id)sender;

-(IBAction) selectGraph:(id)sender;
-(IBAction) selectView:(id)sender;

-(IBAction) selectIndex:(id)sender;

- (void) buildState: (int)elementState;
- (void) buildRadioactive;

- (void) buildDefault;
- (void) buildDensity;
- (void) buildEN;
- (void) buildBP;
- (void) buildMP;
- (void) buildAR;
- (void) buildAV;
- (void) buildVEP;
- (void) buildEOA;
- (void) buildEOF;
- (void) buildEOV;
- (void) buildTC;
- (void) buildTE;

- (IBAction) setAutoPlaySpeechClick:(id)sender;

- (IBAction) continentListClick:(id)sender;
- (IBAction) countryListClick:(id)sender;
- (IBAction) openCountryPage:(id)sender;

- (IBAction) clickPropertiesShowRanges:(id)sender;
- (IBAction) clickHelp:(id)sender;

- (NSString *) processScientificNotation:(NSString *)input;
- (IBAction) selectPropertyClick:(id)sender;
- (IBAction) searchPropertiesClick:(id)sender;
- (IBAction) includePropertiesClick:(id)sender;

- (IBAction) playSpeech:(id)sender;

- (IBAction) clickTable:(id)sender;
- (IBAction) clickImages:(id)sender;
- (IBAction) clickSeach:(id)sender;
- (IBAction) clickProperties:(id)sender;
- (IBAction) clicCalc:(id)sender;
- (IBAction) clickCountry:(id)sender;

- (IBAction) clickLink:(id)sender;

@property (assign) IBOutlet NSWindow *dialogWindow;

@end
