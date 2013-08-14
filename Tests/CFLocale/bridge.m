#import <Foundation/NSLocale.h>
#import <Foundation/NSString.h>
#import <Foundation/NSUserDefaults>
#include "CoreFoundation/CFString.h"
#include "CoreFoundation/CFDictionary.h"
#include "../CFTesting.h"

void testCFonNS(void);
void testNSonCF(void);

int main(void)
{
	testCFonNS();
	testNSonCF();
	return 0;
}

void testCFonNS(void)
{
	NSLocale* locale = [NSLocale currentLocale];
	CFLocaleRef cfRef = (CFLocaleRef) locale;

	PASS_CF(CFStringCompare(CFLocaleGetIdentifier(cfRef), (CFStringRef) [locale localeIdentifier], 0) == 0,
			"CFLocaleGetIdentifier works");
	
	PASS_CF(CFStringCompare(CFLocaleGetValue(cfRef, kCFLocaleCurrencySymbol),
				(CFStringRef) [locale objectForKey: NSLocaleCurrencySymbol], 0) == 0,
			"CFLocaleGetValue works");
	PASS_CF(CFStringCompare(CFLocaleCopyDisplayNameForPropertyValue(cfRef, kCFLocaleIdentifier, CFSTR("fr_FR")),
				(CFStringRef) [locale displayNameForKey: NSLocaleIdentifier value: @"fr_FR"], 0) == 0,
			"CFLocaleCopyDisplayNameForPropertyValue works");
}

void testNSonCF(void)
{
	CFLocaleRef cfRef = CFLocaleCreate (NULL, CFDictionaryGetValue((CFDictionaryRef)[NSUserDefaults standardUserDefaults], @"Locale");
	NSLocale* locale = (NSLocale*)cfRef;

	PASS_CF(CFStringCompare(CFLocaleGetIdentifier(cfRef), (CFStringRef) [locale localeIdentifier], 0) == 0,
			"CFLocaleGetIdentifier works");
	
	PASS_CF(CFStringCompare(CFLocaleGetValue(cfRef, kCFLocaleCurrencySymbol),
				(CFStringRef) [locale objectForKey: NSLocaleCurrencySymbol], 0) == 0,
			"CFLocaleGetValue works");
	PASS_CF(CFStringCompare(CFLocaleCopyDisplayNameForPropertyValue(cfRef, kCFLocaleIdentifier, CFSTR("fr_FR")),
				(CFStringRef) [locale displayNameForKey: NSLocaleIdentifier value: @"fr_FR"], 0) == 0,
			"CFLocaleCopyDisplayNameForPropertyValue works");
}

