//
//  HTMLUtility.m
//  PTE_Mac
//
//  Created by Paul Freshney on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "HTMLUtility.h"


@implementation HTMLUtility


+ (NSString *) getCalcErrorPage {
    
    return @"<html><head><link type=\"text/css\" rel=\"stylesheet\" href=\"element.css\"></link></head><body class=\"JF\"> \
             <div style=\"background-color:#FF88FF\" align='center'>Molecular Mass</div><br/> \
              <table width=\"100%\" class=\"pf\"><tr><td><b>Invalid input!</b> Calc is <i>case sensitive</i>, so all element sysmbols must be entered with the correct case. e.g. Li not li.</td></tr></table>";

}


+ (NSString *) getDivContaining {
    
    return @"<div class=\"pf\">&nbsp;&nbsp;%@: containing \"%@\"</div>";
}


+ (NSString *) getDivProperty {

    return @"<div class=\"pf\">&nbsp;&nbsp;%@: %@ %@ to %@ %@</div>";
}


+ (NSString *) getDivPropertyLong:(NSInteger)aPropertyID {

    switch (aPropertyID)
    {
        case 100: // == abundance (Earth's Core) ======================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>earth</sub>: %@ ppm</div>";
            break;
        case 101: // == human (atoms)
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>human (atoms)</sub>: %@ ppm</div>";
            break;
        case 102: // == human (mass)
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>human (mass)</sub>: %@ ppm</div>";
            break;
        case 103: // == sun
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>sun</sub>: %@ ppm</div>";
            break;
        case 104: // == universe
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>u</sub>: %@ ppm</div>";
            break;
    
        case 200: // == atomic radius =================================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;A<sub>ø</sub>: %@ pm</div>";
            break;
        case 201: // == atomic volume
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;V<sub>a</sub>: %@ cm<sup>3</sup> mol<sup>-1</sup></div>";
            break;
        case 202: // == electronegativity (Pauling)
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&chi;<sub>Pauling</sub>: %@</div>";
            break;
        case 203: // == valence electron potential
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;-eV: %@</div>";
            break;
    
        case 300: // == atomic mass ====================================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;Mass: %@</div>";
            break;
        case 301: // == atomic number
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;Z: %@</div>";
            break;
        case 302: // == boiling point
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;BP: %@ K</div>";
            break;
        case 303: // == density
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;D: %@ g/cm<sup>3</sup></div>";
            break;
        case 304: // == melting point
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;MP: %@ K</div>";
            break;
        case 305: // == name
            return @"";
            break;
        case 306: // == symbol
            return @"";
            break;
        case 307: // == state
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;%@</div>";
            break;
    
        case 400: // == discovery date =================================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;D<sub>discovery</sub>: %@</div>";
            break;
        case 401: // == discovery where
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;%@</div>";
            break;
        case 402: // == discovery who
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;%@</div>";
            break;
        
        case 500: // == electrical conductivity ========================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&sigma;: %@/cm &#937</div>";
            break;
        case 501: // == electrical resistance
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&rho;: %@ &#937;m</div>";
            break;
        
        case 600: // == brinell hardness ===============================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;BHN: %@</div>";
            break;
        case 601: // == bulk modulus
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;K: %@ GPa</div>";
            break;
        case 602: // == poisson ratio
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&nu;: %@</div>";
            break;
        case 603: // == shear modulus
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;G: %@ GPa</div>";
            break;
        case 604: // == speed of sound
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;v: %@ ms<sup>-1</sup></div>";
            break;
        case 605: // == vickers hardness
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;HV: %@</div>";
            break;
        case 606: // == young's modulus
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;E: %@ GPa</div>";
            break;
        
        case 700: // == enthalpy of fusion ==============================================================================
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&Delta;H<sub>(f)</sub>: %@</div>";
            break;
        case 701: // == enthalpy of vaporisation
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&Delta;H<sub>(v)</sub>: %@</div>";
            break;
        case 702: // == heat capacity
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C: %@</div>";
            break;
        case 703: // == thermal conductivity
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;T<sub>c</sub>: %@</div>";
            break;
        case 704: // == thermal resistivity
            return @"<div class=\"pf\">&nbsp;&nbsp;&nbsp;&nbsp;T<sub>r</sub>: %@</div>";
            break;

        default:
            return @"";
            break;
    }
}


+ (NSString *) getDocHeader {
    
    return @"<html><head><link type=\"text/css\" rel=\"stylesheet\" href=\"element.css\"></link></head><body class=\"JF\">";
}


+ (NSString *) getFoundResultsFor:(NSInteger)searchIndex {
    
    switch(searchIndex)
    {
        case 0:
            return @"<div style=\"background-color:#FF8888\" class=\"JF\" align='center'>Found %d results for \"<b>%@</b>\"</div>";
            break;
        case 1:
            return @"<div style=\"background-color:#8888FF\" class=\"JF\" align='center'>Found %d results for \"<b>%@</b>\"</div>";
            break;
        case 2:
            return @"<div style=\"background-color:#88FF88\" class=\"JF\" align='center'>Found %d results for \"<b>%@</b>\"</div>";
            break;
        case 3:
            return @"<div style=\"background-color:#FFFF88\" class=\"JF\" align='center'>Found %d results for \"<b>%@</b>\"</div>";
            break;
            
        default:
            return @"<div style=\"background-color:#FF8888\" class=\"JF\" align='center'>Found %d results for \"<b>%@</b>\"</div>";
            break;
    }
}


+ (NSString *) getIndentItalic {
    
    return @"&nbsp;&nbsp;&nbsp;&nbsp;<i class=\"JF\">%@</i><br/>";
}


+ (NSString *) getMassOutput {

    return @"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class=\"elink\" href=\"%d.htm\">%@</a>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%d&nbsp;&nbsp;&nbsp;&nbsp;%3.2f%%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%5.3f u<br/>";
}

+ (NSString *) getTypeClass:(NSInteger)type {

    switch (type)
    {
        case 0: // ELEMENT PAGES
            return @"elink";
            break;
        case 1: // Biography
            return @"blink";
            break;
        case 2: // Production
            return @"plink";
            break;
        case 3: // Glossary
            return @"glink";
            break;
        case 4: // Compounds
            return @"clink";
            break;
        case 5: // Reactions
            return @"qlink";
            break;
        case 6: // Equations
            return @"qlink";
            break;
        case 7: // Country
            return @"slink";
            break;
        case 8: // Spectrum
            return @"ulink";
            break;
        case 9: // Isotope
            return @"ilink";
            break;
        case 10: // Allotrope
            return @"alink";
            break;
        case 11: // OnThisDay
            return @"olink";
            break;
            
        default:
            return @"elink";
            break;
    }
}

@end
