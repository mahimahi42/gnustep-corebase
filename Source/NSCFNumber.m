/* NSCFNumber.m
   
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

#import <Foundation/NSValue.h>
#import <Foundation/NSDecimal.h>
#import <Foundation/NSString.h>

#include "NSCFType.h"
#include "CoreFoundation/CFNumber.h"

@interface NSCFNumber : NSNumber
NSCFTYPE_VARS
@end

@interface NSNumber (CoreBaseAdditions)
- (CFTypeID) _cfTypeID;
@end

@implementation NSCFNumber
+ (void) load
{
  NSCFInitialize ();
}

+ (void) initialize
{
  GSObjCAddClassBehavior (self, [NSCFType class]);
}

- (id) initWithInteger: (NSInteger)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberIntType, &value);
  
  return self;
}

- (id) initWithLong: (signed long)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberLongType, &value);
  
  return self;
}

- (id) initWithUnsignedLong: (unsigned long)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  // FIXME: unsigned long?
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberLongType, &value);
  
  return self;
}

- (id) initWithLongLong: (signed long long)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberLongLongType, &value);
  
  return self;
}

- (id) initWithUnsignedLongLong: (unsigned long long)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  // FIXME: unsigned long long?
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberLongType, &value);
  
  return self;
}

- (id) initWithDouble: (double)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberDoubleType, &value);
  
  return self;
}

- (id) initWithFloat: (float)value
{
  CFAllocatorRef allocator = kCFAllocatorDefault;
  RELEASE(self);
  
  self = (NSCFNumber*) CFNumberCreate(allocator, kCFNumberFloatType, &value);
  
  return self;
}

- (BOOL) boolValue
{
  int value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberIntType, &value);
  return value ? YES : NO;
}

- (signed char) charValue
{
  signed char value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberSInt8Type, &value);
  return value;
}

- (double) doubleValue
{
  double value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberDoubleType, &value);
  return value;
}

- (float) floatValue
{
  float value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberFloatType, &value);
  return value;
}

- (int) intValue
{
  int value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberIntType, &value);
  return value;
}

- (NSInteger) integerValue
{
  if (sizeof(NSInteger) == sizeof(int))
    return [self intValue];
  else if (sizeof(NSInteger) == sizeof(long long))
    return [self longLongValue];
  else
    return (NSInteger) [self longLongValue];
}

- (long long) longLongValue
{
  long long value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberLongLongType, &value);
  return value;
}

- (long) longValue
{
  long value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberLongType, &value);
  return value;
}

- (short) shortValue
{
  short value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberShortType, &value);
  return value;
}

- (unsigned char) unsignedCharValue
{
  char value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberSInt8Type, &value);
  return value;
}

- (NSUInteger) unsignedIntegerValue
{
  if (sizeof(NSUInteger) == sizeof(unsigned int))
    return [self unsignedIntValue];
  else if (sizeof(NSUInteger) == sizeof(unsigned long long))
    return [self unsignedLongLongValue];
  else
    return (NSUInteger) [self unsignedLongLongValue];
}

- (unsigned int) unsignedIntValue
{
  unsigned int value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberIntType, &value);
  return value;
}

- (unsigned long long) unsignedLongLongValue
{
  unsigned long long value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberLongLongType, &value);
  return value;
}

- (unsigned long) unsignedLongValue
{
  unsigned long value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberLongType, &value);
  return value;
}

- (unsigned short) unsignedShortValue
{
  unsigned short value;
  CFNumberGetValue((CFNumberRef) self, kCFNumberShortType, &value);
  return value;
}

- (const char *)objCType
{
  CFNumberType myType = CFNumberGetType((CFNumberRef) self);
  
  switch (myType)
  {
    case kCFNumberSInt8Type:
      return @encode(SInt8);
    case kCFNumberSInt16Type:
      return @encode(SInt16);
    case kCFNumberSInt32Type:
      return @encode(SInt32);
    case kCFNumberSInt64Type:
      return @encode(SInt64);
    case kCFNumberFloatType:
    case kCFNumberFloat32Type:
      return @encode(float);
    case kCFNumberDoubleType:
    case kCFNumberFloat64Type:
      return @encode(double);
    case kCFNumberCharType:
      return @encode(char);
    case kCFNumberShortType:
      return @encode(short);
    case kCFNumberIntType:
      return @encode(int);
    case kCFNumberLongType:
      return @encode(long);
    case kCFNumberLongLongType:
      return @encode(long long);
    case kCFNumberCFIndexType:
      return @encode(CFIndex);
    case kCFNumberNSIntegerType:
      return @encode(NSInteger);
    case kCFNumberCGFloatType:
      return @encode(double); // FIXME: this is a guess
  }
}

- (NSString *)descriptionWithLocale:(id)aLocale
{
  NSString* str = [NSString alloc];
  CFNumberType myType = CFNumberGetType((CFNumberRef) self);
  
  switch (myType)
  {
    case kCFNumberCharType:
    case kCFNumberSInt8Type:
      str = [str initWithFormat: @"%i" locale: aLocale, [self charValue]];
      break;
    case kCFNumberShortType:
    case kCFNumberSInt16Type:
      str = [str initWithFormat: @"%hi" locale: aLocale, [self shortValue]];
      break;
    case kCFNumberIntType:
    case kCFNumberSInt32Type:
      str = [str initWithFormat: @"%i" locale: aLocale, [self intValue]];
      break;
    case kCFNumberCFIndexType:
    case kCFNumberNSIntegerType:
    case kCFNumberLongLongType:
    case kCFNumberSInt64Type:
      str = [str initWithFormat: @"%lli" locale: aLocale, [self longLongValue]];
      break;
    case kCFNumberFloatType:
    case kCFNumberFloat32Type:
      str = [str initWithFormat: @"%0.7g" locale: aLocale, [self floatValue]];
      break;
    case kCFNumberDoubleType:
    case kCFNumberCGFloatType:
    case kCFNumberFloat64Type:
      str = [str initWithFormat: @"%0.16g" locale: aLocale, [self doubleValue]];
      break;
    case kCFNumberLongType:
      str = [str initWithFormat: @"%li" locale: aLocale, [self longValue]];
      break;
  }
  
  return AUTORELEASE(str);
}

- (BOOL)isEqualToValue:(NSValue *)value
{
  NSString* me = [self description];
  NSString* that = [value description];
  
  return [me isEqualToString: that];
}

- (BOOL)isEqual:(NSObject *)value
{
  if ([value isKindOfClass: [NSValue class]])
    return [self isEqualToValue: (NSValue*) value];
  else
    return NO;
}

- (BOOL)isEqualToNumber:(NSNumber *)value
{
  return [self isEqualToValue: value];
}

- (void)getValue:(void *)buffer
{
  CFNumberType type = CFNumberGetType((CFNumberRef) self);
  
  CFNumberGetValue((CFNumberRef) self, type, buffer);
}
@end


@implementation NSNumber (CoreBaseAdditions)
- (CFTypeID) _cfTypeID
{
  return CFNumberGetTypeID();
}
@end
