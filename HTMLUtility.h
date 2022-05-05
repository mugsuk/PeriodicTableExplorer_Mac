//
//  HTMLUtility.h
//  PTE_Mac
//
//  Created by Paul Freshney on 19/07/2017.
//
//

@interface HTMLUtility : NSObject

+ (NSString *) getCalcErrorPage;
+ (NSString *) getDivContaining;
+ (NSString *) getDivProperty;
+ (NSString *) getDivPropertyLong:(NSInteger)aPropertyID;
+ (NSString *) getDocHeader;
+ (NSString *) getFoundResultsFor:(NSInteger)searchIndex;
+ (NSString *) getIndentItalic;
+ (NSString *) getMassOutput;
+ (NSString *) getTypeClass:(NSInteger)type;

@end
