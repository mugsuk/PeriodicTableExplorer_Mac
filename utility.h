//
//  utility.h
//  PTE_Mac
//
//  Created by Paul Freshney on 12/07/2017.
//
//

@interface Utility : NSObject

+ (bool) isRadioActive:(NSInteger)atomicNumber;

+ (NSString *) getCountryCode:(NSInteger)countryID;
+ (NSString *) getDataFileName:(NSInteger)whichData element:(NSInteger)currentElement;
+ (int) getElementANFromPage:(NSString *)url;
+ (NSString *) getElementListFileName:(NSInteger)listID;
+ (NSString *) getGroupName:(NSInteger)groupID;
+ (NSString *) getIndexFileName:(NSUInteger)indexID;
+ (NSString *) getLinkAddress:(NSUInteger)linkID;
+ (NSString *) getOnThisDayFileName;
+ (NSString *) getPropertyFrom:(NSInteger)index;
+ (NSString *) getRadiationImage:(NSInteger)atomicNumber;
+ (NSString *) getSpectrumImage:(NSInteger)atomicNumber withSpectrum:(NSInteger)spectrum;
+ (NSString *) getStateImage:(NSInteger)state withElementState:(NSInteger)elementState;
+ (NSString *) getToolTipFormat;
+ (NSString *) getTypeFileName:(NSInteger)aType;

+ (NSString *) getDefaultSearchHelp:(NSInteger)searchType;

@end
