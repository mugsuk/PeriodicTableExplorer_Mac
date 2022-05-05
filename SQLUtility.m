//
//  utility.m
//  PTE_Mac
//
//  Created by Paul Freshney on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "SQLUtility.h"

@implementation SQLUtility

+ (NSString *) getSQLFind:(NSInteger)criteria with:(NSString *)filter {

    switch (criteria)
    {
        case 0:
            return [NSString stringWithFormat:@"SELECT pteWord, pteLink, pteTitle, pteType FROM pteIndex WHERE (pteWord LIKE \"%%%@%%\");", filter];
            break;
    
        case 1:
            return [NSString stringWithFormat:@"SELECT pteName, pteFormulaF, pteFormula, pteCAS, pteOther1, pteOther2, pteOther3, pteOther4, pteOther5, pteOther6 FROM pteCompound WHERE (pteName LIKE \"%%%@%%\") OR (pteFormula LIKE \"%%%@%%\") OR (pteOther1 LIKE \"%%%@%%\") OR (pteOther2 LIKE \"%%%@%%\") OR (pteOther3 LIKE \"%%%@%%\") OR (pteOther4 LIKE \"%%%@%%\") OR (pteOther5 LIKE \"%%%@%%\") OR (pteOther6 LIKE \"%%%@%%\");", filter, filter, filter, filter, filter, filter, filter, filter];
            break;
    
        case 2:
            return [NSString stringWithFormat:@"SELECT pteName, pteSymbol, pteValue, pteUnits, pteUncer FROM pteContants WHERE pteName LIKE \"%%%@%%\";", filter];
            break;
    
        case 3:
            return [NSString stringWithFormat:@"SELECT pteName, pteTitle FROM pteEquation WHERE (pteTitle LIKE \"%%%@%%\");", filter];
            break;
            
        default:
            return @"";
            break;
    }
}

@end
