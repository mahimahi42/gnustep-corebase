/* NSCFLocale.m
   
   Copyright (C) 2013 Free Software Foundation, Inc.
   
   Written by: Lubos Dolezel
   Date: March, 2013
   
   This file is part of GNUstep CoreBase Library.
   
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#import <Foundation/NSCalendar.h>

#include "NSCFType.h"
#include "CoreFoundation/CFCalendar.h"

// Private CF functions
extern Boolean
__CFCalendarComposeAbsoluteTimeV (CFCalendarRef cal, CFAbsoluteTime *at,
  const char *componentDesc, int* buffer);

extern Boolean
__CFCalendarAddComponentsV (CFCalendarRef cal, CFAbsoluteTime *at,
  CFOptionFlags options, const char *componentDesc, int* buffer);

extern Boolean
__CFCalendarDecomposeAbsoluteTimeV (CFCalendarRef cal, CFAbsoluteTime at,
  const char *componentDesc, int** buffer);

#define MAX_COMPONENT_DESC_LENGTH 20

@interface NSCFCalendar : NSCalendar
NSCFTYPE_VARS
@end

@interface NSCalendar (CoreBaseAdditions)
- (CFTypeID) _cfTypeID;
@end

static void NSDateComponentToCF(char* descriptionString,
		int* valueBuffer, int* count, NSInteger value, char code)
{
	if (value != NSUndefinedDateComponent)
	{
		descriptionString[*count] = code;
		valueBuffer[*count] = (int)value;
		(*count)++;
	}
}

static void NSDateComponentsToCF(NSDateComponents* comps,
		char* descriptionString, int* valueBuffer)
{
	int numComponents = 0;

	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'G', [comps era]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'y', [comps year]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'M', [comps month]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'd', [comps day]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'H', [comps hour]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'm',
			[comps minute]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 's',
			[comps second]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'w',
			[comps week]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'F',
			[comps weekdayOrdinal]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'E',
			[comps weekday]);
#if 0 // requires a patched Base
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'W',
			[comps weekOfMonth]);
	NSDateComponentToCF(descriptionString, valueBuffer, &numComponents, 'Y',
			[comps yearForWeekOfYear]);
#endif

	descriptionString[numComponents] = '\0';
}

static void NSCalendarUnitToCF(NSUInteger flags, char* descriptionString)
{
	int numComponents = 0;

#define IFFLAG(flag, c) if (flags & flag) descriptionString[numComponents++] = c

	IFFLAG(NSEraCalendarUnit, 'G');
	IFFLAG(NSYearCalendarUnit, 'y');
	IFFLAG(NSMonthCalendarUnit, 'M');
	IFFLAG(NSDayCalendarUnit, 'd');
	IFFLAG(NSHourCalendarUnit, 'H');
	IFFLAG(NSMinuteCalendarUnit, 'm');
	IFFLAG(NSSecondCalendarUnit, 's');
	IFFLAG(NSWeekCalendarUnit, 'w');
	IFFLAG(NSWeekdayCalendarUnit, 'E');
	IFFLAG(NSWeekdayOrdinalCalendarUnit, 'F');
#if 0 // requires a patched Base
	IFFLAG(NSWeekOfMonthCalendarUnit, 'W');
	IFFLAG(NSWeekOfYearCalendarUnit, 'w');
	IFFLAG(NSYearForWeekOfYearCalendarUnit, 'Y');
#endif

#undef IFFLAG

	descriptionString[numComponents] = '\0';
}

@implementation NSCFCalendar
- (id)initWithCalendarIdentifier:(NSString*)string
{
	RELEASE(self);

	self = (NSCFCalendar*)
		CFCalendarCreateWithIdentifier(kCFAllocatorDefault,
		(CFStringRef) string);
	
	return self;
}

- (void)setFirstWeekday:(NSUInteger)weekday
{
	CFCalendarSetFirstWeekday((CFCalendarRef) self, weekday);
}

- (void)setLocale:(NSLocale*)locale
{
	CFCalendarSetLocale((CFCalendarRef) self, (CFLocaleRef) locale);
}

- (void)setMinimumDaysInFirstWeek:(NSUInteger)mdw
{
	CFCalendarSetMinimumDaysInFirstWeek((CFCalendarRef) self, mdw);
}

- (void)setTimeZone:(NSTimeZone*)tz
{
	CFCalendarSetTimeZone((CFCalendarRef) self, (CFTimeZoneRef)tz);
}

- (NSTimeZone*)timeZone
{
	return (NSTimeZone*) CFCalendarCopyTimeZone((CFCalendarRef) self);
}

- (NSString*)calendarIdentifier
{
	return (NSString*) CFCalendarGetIdentifier((CFCalendarRef) self);
}

- (NSDateComponents *)components:(NSUInteger)unitFlags
						fromDate:(NSDate *)date
{
	NSDateComponents *comps;
	CFAbsoluteTime at;
	char componentDesc[MAX_COMPONENT_DESC_LENGTH+1];
	int values[MAX_COMPONENT_DESC_LENGTH];
	int* valuePointers[MAX_COMPONENT_DESC_LENGTH];
	int i;

	for (i = 0; i < MAX_COMPONENT_DESC_LENGTH; i++)
		valuePointers[i] = &values[i];

	at = [date timeIntervalSince1970] - kCFAbsoluteTimeIntervalSince1970;

	NSCalendarUnitToCF(unitFlags, componentDesc);

	if (!__CFCalendarDecomposeAbsoluteTimeV((CFCalendarRef) self, at,
				componentDesc, valuePointers))
	{
		return NO;
	}

	comps = [[NSDateComponents alloc] init];

	// TODO
	return comps;
}

- (NSDateComponents *)components:(NSUInteger)unitFlags
						fromDate:(NSDate *)startingDate
						  toDate:(NSDate *)resultDate
						 options:(NSUInteger)opts
{
	NSDateComponents *comps;
	CFAbsoluteTime atStart, atResult;
	char componentDesc[MAX_COMPONENT_DESC_LENGTH+1];
	int values[MAX_COMPONENT_DESC_LENGTH];
	int* valuePointers[MAX_COMPONENT_DESC_LENGTH];
	int i;

	for (i = 0; i < MAX_COMPONENT_DESC_LENGTH; i++)
		valuePointers[i] = &values[i];

	atStart = [startingDate timeIntervalSince1970]
		- kCFAbsoluteTimeIntervalSince1970;
	atResult = [resultDate timeIntervalSince1970]
		- kCFAbsoluteTimeIntervalSince1970;

	NSCalendarUnitToCF(unitFlags, componentDesc);

	// opts are compatible between NS and CF
	if (!__CFCalendarGetComponentDifferenceV((CFCalendarRef) self, atStart,
				atResult, opts, componentDesc, valuePointers))
	{
		return NULL;
	}

	comps = [[NSDateComponents alloc] init];

	// TODO:
	return comps;
}

- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps
							toDate:(NSDate *)date
						   options:(NSUInteger)opts
{
	char components[MAX_COMPONENT_DESC_LENGTH+1];
	int buffer[MAX_COMPONENT_DESC_LENGTH];
	CFAbsoluteTime at;

	NSDateComponentsToCF(comps, components, buffer);

	NSTimeZone* tz = [comps timeZone];
	if (tz != NULL)
		[self setTimeZone: tz];

	at = [date timeIntervalSince1970] - kCFAbsoluteTimeIntervalSince1970;

	// NS opts are compatible with CF opts here
	if (!__CFCalendarAddComponentsV((CFCalendarRef) self, &at,
				opts, components, buffer))
	{
		return NULL;
	}

	return [NSDate dateWithTimeIntervalSince1970: at
		+ kCFAbsoluteTimeIntervalSince1970];
}

- (NSDate *)dateFromComponents:(NSDateComponents *)comps
{
	char components[MAX_COMPONENT_DESC_LENGTH+1];
	int buffer[MAX_COMPONENT_DESC_LENGTH];
	CFAbsoluteTime at;

	NSDateComponentsToCF(comps, components, buffer);

	NSTimeZone* tz = [comps timeZone];
	if (tz != NULL)
		[self setTimeZone: tz];

	if (!__CFCalendarComposeAbsoluteTimeV((CFCalendarRef) self, &at,
				components, buffer))
	{
		return NULL;
	}

	return [NSDate dateWithTimeIntervalSince1970: at
		+ kCFAbsoluteTimeIntervalSince1970];
}

- (NSUInteger)firstWeekday
{
	return CFCalendarGetFirstWeekday((CFCalendarRef) self);
}

- (NSLocale*)locale
{
	return (NSLocale*) CFCalendarCopyLocale((CFCalendarRef) self);
}

- (NSRange)maximumRangeOfUnit:(NSCalendarUnit)unit
{
	CFRange r;
	r = CFCalendarGetMaximumRangeOfUnit((CFCalendarRef) self, unit);
	return NSMakeRange(r.location, r.length);
}

- (NSUInteger)minimumDaysInFirstWeek
{
	return CFCalendarGetMinimumDaysInFirstWeek((CFCalendarRef) self);
}

- (NSRange)minimumRangeOfUnit:(NSCalendarUnit)unit
{
	CFRange r;
	r = CFCalendarGetMinimumRangeOfUnit((CFCalendarRef) self, unit);
	return NSMakeRange(r.location, r.length);
}

- (NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller
						inUnit:(NSCalendarUnit)larger
					   forDate:(NSDate *)date
{
	CFAbsoluteTime at;
	CFIndex o;

	at = [date timeIntervalSince1970] - kCFAbsoluteTimeIntervalSince1970;
	o = CFCalendarGetOrdinalityOfUnit((CFCalendarRef) self,
			smaller, larger, at);

	return o;
}

- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller
				inUnit:(NSCalendarUnit)larger
			   forDate:(NSDate *)date
{
	CFAbsoluteTime at;
	CFRange cr;

	at = [date timeIntervalSince1970] - kCFAbsoluteTimeIntervalSince1970;
	cr = CFCalendarGetRangeOfUnit((CFCalendarRef) self, smaller, larger, at);

	return NSMakeRange(cr.location, cr.length);
}

- (BOOL)rangeOfUnit:(NSCalendarUnit)unit
		  startDate:(NSDate **)datep
		   interval:(NSTimeInterval *)tip
			forDate:(NSDate *)date
{
	return NO; // Even Apple doesn't implement this
}

@end

@implementation NSCalendar (CoreBaseAdditions)
- (CFTypeID) _cfTypeID
{
	return CFCalendarGetTypeID();
}
@end

