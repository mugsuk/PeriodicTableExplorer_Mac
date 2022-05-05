//
//  utility.m
//  PTE_Mac
//
//  Created by Paul Freshney on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "utility.h"

@implementation Utility

+ (bool) isRadioActive:(NSInteger)atomicNumber {
    
    // range 0..117
    
    if ((atomicNumber == 42) || (atomicNumber == 60) || (atomicNumber > 81))
    {
        return true;
    }
    else
    {
        return false;
    }
}


+ (NSString *) getPropertyFrom:(NSInteger)index {
    
    switch (index)
    {
        case 100: // == abundance (earth's core) ============================================================================
            return @"ppm";
            break;
        case 101: // == abundance (human atoms)
            return @"ppm";
            break;
        case 102: // == abundance (human mass)
            return @"ppm";
            break;
        case 103: // == abundance (sun)
            return @"ppm";
            break;
        case 104: // == abundance (universe)
            return @"ppm";
            break;
        case 200: // == atomic radius =======================================================================================
            return @"pm";
            break;
        case 201: // == atomic volume
            return @"cm^3/mol";
            break;
        case 202: // == electronegativity (Pauling)
            return @"";
            break;
        case 203: // == valence electron potential
            return @"";
            break;
        case 300: // == atomic mass ==========================================================================================
            return @"";
            break;
        case 301: // == atomic number
            return @"";
            break;
        case 302: // == boiling point
            return @"K";
            break;
        case 303: // == density
            return @"g/cm^3";
            break;
        case 304: // == melting point
            return @"K";
            break;
        case 305: // == name
            return @"";
            break;
        case 306: // == symbol
            return @"";
            break;
        case 307: // == state
            return @"";
            break;
        case 400: // == discovery date ======================================================================================
            return @"";
            break;
        case 401: // == discovery where
            return @"";
            break;
        case 402: // == discovery who
            return @"";
            break;
        case 500: // == electrical conductivity =============================================================================
            return @"Sm^-1";
            break;
        case 501: // == electrical resistance
            return @"S^-1";
            break;
        case 600: // == brinell hardness ====================================================================================
            return@"";
            break;
        case 601: // == bulk modulus
            return @"GPa";
            break;
        case 602: // == poisson ratio
            return @"";
            break;
        case 603: // == shear modulus
            return @"GPa";
            break;
        case 604: // == speed of sound
            return @"m/s";
            break;
        case 605: // == vickers hardness
            return @"";
            break;
        case 606: // == young's modulus
            return @"GPa";
            break;
        case 700: // == enthalpy of fusion ==================================================================================
            return @"K/J/mol";
            break;
        case 701: // == enthalpy of vaporisation
            return @"K/J/mol";
            break;
        case 702: // == heat capacity
            return @"J/K";
            break;
        case 703: // == thermal conductivity
            return @"W/m/K";
            break;
        case 704: // == thermal resistivity
            return @"W/m/K";
            break;		
        case 1000: // == Clear ===============================================================================================
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
}


+ (NSString *) getCountryCode:(NSInteger)countryID {
    
    switch (countryID)
    {
        case 0:
            return @"AF";
            break;
        case 1:
            return @"AS";
            break;
        case 2:
            return @"AU";
            break;
        case 3:
            return @"EU";
            break;
        case 4:
            return @"NA";
            break;
        case 5:
            return @"SA";
            break;
            
        default:
            return @"EU";
            break;
    }
}


+ (NSString *) getDataFileName:(NSInteger)whichData element:(NSInteger)currentElement {
    
    switch (whichData)
    {
        case 0:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 1:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"o%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 2:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"r%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 3:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"p%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 4:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"i%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 5:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"c%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 6:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mac%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 7:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"ad%ld", (long)currentElement] ofType:@"htm"];
            break;
        case 8:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"s%ld", (long)currentElement] ofType:@"htm"];
            break;
        
        default:
            return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld", (long)currentElement] ofType:@"htm"];
            break;
    }
}


+ (NSString *) getDefaultSearchHelp:(NSInteger)searchType {

    switch (searchType)
    {
        case 0:
            return @"(eg. Iron, England, explode)";
            break;
        case 1:
            return @"(eg. H2O, Mg, hexane)";
            break;
        case 2:
            return @"(eg. pi, g, velocity, ratio)";
            break;
        case 3:
            return @"(eg. electron, mass, law)";
            break;
            
        default:
            return @"(eg. Iron, England, explode)";
            break;
    }
}


+ (int) getElementANFromPage:(NSString *)url {
    
    if ([url length] != 0)
    {
        url = [url lastPathComponent];
        
        //NSLog(@"%@", url);
        
        if (![url hasPrefix:@"otd"]) // onthisday (otdDDMM.htm)
        {
            NSCharacterSet *wildCardSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz._ "];
            
            NSString *eAN = [url stringByTrimmingCharactersInSet:wildCardSet];
            
            if ([eAN length] == 0)
            {
                return -1;
            }
            else
            {
                return [eAN intValue];
            }
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -1;
    }
}


+ (NSString *) getElementListFileName:(NSInteger)listID {
    
    switch (listID)
    {
        case 100:
            return [[NSBundle mainBundle] pathForResource:@"idx_byabundanceec" ofType:@"htm"];
            break;
        case 101:
            return [[NSBundle mainBundle] pathForResource:@"idx_byabundanceha" ofType:@"htm"];
            break;
        case 102:
            return [[NSBundle mainBundle] pathForResource:@"idx_byabundancesun" ofType:@"htm"];
            break;
        case 103:
            return [[NSBundle mainBundle] pathForResource:@"idx_byabundanceuni" ofType:@"htm"];
            break;
        case 200:
            return [[NSBundle mainBundle] pathForResource:@"idx_byar" ofType:@"htm"];
            break;
        case 201:
            return [[NSBundle mainBundle] pathForResource:@"idx_byav" ofType:@"htm"];
            break;
        case 202:
            return [[NSBundle mainBundle] pathForResource:@"idx_byenps" ofType:@"htm"];
            break;
        case 203:
            return [[NSBundle mainBundle] pathForResource:@"idx_byvep" ofType:@"htm"];
            break;
        case 300:
            return [[NSBundle mainBundle] pathForResource:@"idx_byam" ofType:@"htm"];
            break;
        case 301:
            return [[NSBundle mainBundle] pathForResource:@"idx_byan" ofType:@"htm"];
            break;
        case 302:
            return [[NSBundle mainBundle] pathForResource:@"idx_bybp" ofType:@"htm"];
            break;
        case 303:
            return [[NSBundle mainBundle] pathForResource:@"idx_bydensity" ofType:@"htm"];
            break;
        case 304:
            return [[NSBundle mainBundle] pathForResource:@"idx_bymp" ofType:@"htm"];
            break;
        case 305:
            return [[NSBundle mainBundle] pathForResource:@"idx_byname" ofType:@"htm"];
            break;
        case 306:
            return [[NSBundle mainBundle] pathForResource:@"idx_bysymbol" ofType:@"htm"];
            break;
        case 400:
            return [[NSBundle mainBundle] pathForResource:@"idx_bydate" ofType:@"htm"];
            break;
        case 401:
            return [[NSBundle mainBundle] pathForResource:@"idx_bydiscoverer" ofType:@"htm"];
            break;
        case 402:
            return [[NSBundle mainBundle] pathForResource:@"idx_bylocation" ofType:@"htm"];
            break;
        case 500:
            return [[NSBundle mainBundle] pathForResource:@"idx_byelcon" ofType:@"htm"];
            break;
        case 501:
            return [[NSBundle mainBundle] pathForResource:@"idx_byelres" ofType:@"htm"];
            break;
        case 600:
            return [[NSBundle mainBundle] pathForResource:@"idx_bybh" ofType:@"htm"];
            break;
        case 601:
            return [[NSBundle mainBundle] pathForResource:@"idx_bybm" ofType:@"htm"];
            break;
        case 602:
            return [[NSBundle mainBundle] pathForResource:@"idx_bypr" ofType:@"htm"];
            break;
        case 603:
            return [[NSBundle mainBundle] pathForResource:@"idx_bysm" ofType:@"htm"];
            break;
        case 604:
            return [[NSBundle mainBundle] pathForResource:@"idx_bysos" ofType:@"htm"];
            break;
        case 605:
            return [[NSBundle mainBundle] pathForResource:@"idx_byvh" ofType:@"htm"];
            break;
        case 606:
            return [[NSBundle mainBundle] pathForResource:@"idx_byym" ofType:@"htm"];
            break;
        case 700:
            return [[NSBundle mainBundle] pathForResource:@"idx_byeof" ofType:@"htm"];
            break;
        case 701:
            return [[NSBundle mainBundle] pathForResource:@"idx_byeov" ofType:@"htm"];
            break;
        case 702:
            return [[NSBundle mainBundle] pathForResource:@"idx_byhc" ofType:@"htm"];
            break;
        case 703:
            return [[NSBundle mainBundle] pathForResource:@"idx_bythcon" ofType:@"htm"];
            break;
        case 704:
            return [[NSBundle mainBundle] pathForResource:@"idx_bythex" ofType:@"htm"];
            break;
            
        default:
            return [[NSBundle mainBundle] pathForResource:@"idx_byabundanceec" ofType:@"htm"];
            break;
    }
}


+ (NSString *) getGroupName:(NSInteger)groupID {
    
    switch (groupID)
    {
        case 0:
            return @"Metalloids";
            break;
        case 1:
            return @"Alkali Metals";
            break;
        case 2:
            return @"Transition Metals";
            break;
        case 3:
            return @"Non-metals";
            break;
        case 4:
            return @"Alkali Earth Metals";
            break;
        case 5:
            return @"Metals";
            break;
        case 6:
            return @"Halogens";
            break;
        case 7:
            return @"Noble Gases";
            break;
        case 8:
            return @"Transactinides";
            break;
        case 9:
            return @"Lanthanoids";
            break;
        case 10:
            return @"Actinoids";
            break;
            
        default:
            return @"Unknown!";
            break;
    }
}


+ (NSString *) getIndexFileName:(NSUInteger)indexID {
    
    switch (indexID)
    {
        case 1:
            return @"idx_content";
            break;
        
        case 2:
            return @"idx_map";
            break;
            
        case 3:
            return @"idx_biog";
            break;
            
        case 4:
            return @"idx_glossary";
            break;
            
        default:
            return @"idx_content";
            break;
    }
}


+ (NSString *) getLinkAddress:(NSUInteger)linkID {
    
    switch (linkID)
    {
        case 0:
            return @"http://www.periodictableexplorer.com";
            break;
        case 1:
            return @"mailto:apps@maximumoctopus.com";
            break;
        case 2:
            return @"http://www.maximumoctopus.com";
            break;
        case 3:
            return @"http://twitter.com/maximumoctopus";
            break;
        case 4:
            return @"https://www.facebook.com/maximumoctopus/";
            break;
        case 5:
            return @"https://itunes.apple.com/gb/app/periodic-table-explorer/id359738395?mt=8";
            break;
            
        default:
            return @"http://www.periodictableexplorer.com";
            break;
    }
}


+ (NSString *) getOnThisDayFileName {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    
    NSString *dateString = @"";
    
    if (day < 10)
    {
        dateString = [dateString stringByAppendingString: [NSString stringWithFormat:@"0%lu", (long)day]];
    }
    else
    {
        dateString = [dateString stringByAppendingString: [NSString stringWithFormat:@"%lu", (long)day]];
    }
    
    if (month < 10)
    {
        dateString = [dateString stringByAppendingString: [NSString stringWithFormat:@"0%lu", (long)month]];
    }
    else
    {
        dateString = [dateString stringByAppendingString: [NSString stringWithFormat:@"%lu", (long)month]];
    }
    
    [calendar release];
    
    return [[NSBundle mainBundle] pathForResource:dateString ofType:@"htm"];
}


+ (NSString *) getRadiationImage:(NSInteger)atomicNumber {
    
    if ([self isRadioActive:atomicNumber])
    {
        return @"grad127.png";
    }
    else
    {
        return @"grad129.png";
    }
}


+ (NSString *) getSpectrumImage:(NSInteger)atomicNumber withSpectrum:(NSInteger)spectrum {

    if (atomicNumber < 99)
    {
        if (spectrum == 1)
        {
            return [NSString stringWithFormat:@"%ld_a.png", (long)atomicNumber];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld_e.png", (long)atomicNumber];
        }
    }
    else
    {
        return @"87_a.png";
    }
}


+ (NSString *) getStateImage:(NSInteger)state withElementState:(NSInteger)elementState {
    
    if (state == elementState)
    {
        switch (elementState)
        {
            case 1:
                return @"grad76.png";
                break;
            case 2:
                return @"grad41.png";
                break;
            case 3:
                return @"grad31.png";
                break;
            case 4:
                return @"grad106.png";
                break;
                
            default:
                return @"grad129.png";
        }
    }
    else
    {
        return @"grad129.png";
    }
}


+ (NSString *) getToolTipFormat {
    
    return @"%@ [%@]\nAtomic Number: %@\nAtomic Weight: %@\n%@. %@.\nBoiling Point: %@\nMelting Point: %@";
}


+ (NSString *) getTypeFileName:(NSInteger)aType {
    
    switch (aType)
    {
        case 0:
            return [[NSBundle mainBundle] pathForResource:@"gmetalloid" ofType:@"htm"];
            break;
        case 1:
            return [[NSBundle mainBundle] pathForResource:@"galkalimetal" ofType:@"htm"];
            break;
        case 2:
            return [[NSBundle mainBundle] pathForResource:@"gtm" ofType:@"htm"];
            break;
        case 3:
            return [[NSBundle mainBundle] pathForResource:@"gnm" ofType:@"htm"];
            break;
        case 4:
            return [[NSBundle mainBundle] pathForResource:@"gaem" ofType:@"htm"];
            break;
        case 5:
            return [[NSBundle mainBundle] pathForResource:@"gmetals" ofType:@"htm"];
            break;
        case 6:
            return [[NSBundle mainBundle] pathForResource:@"ghalogens" ofType:@"htm"];
            break;
        case 7:
            return [[NSBundle mainBundle] pathForResource:@"gnoble" ofType:@"htm"];
            break;
        case 8:
            return [[NSBundle mainBundle] pathForResource:@"gtransactinides" ofType:@"htm"];
            break;
        case 9:
            return [[NSBundle mainBundle] pathForResource:@"glanthanoids" ofType:@"htm"];
            break;
        case 10:
            return [[NSBundle mainBundle] pathForResource:@"gactinoids" ofType:@"htm"];
            break;
            
        default:
            return [[NSBundle mainBundle] pathForResource:@"gmetalloid" ofType:@"htm"];
            break;
    }
}

@end
