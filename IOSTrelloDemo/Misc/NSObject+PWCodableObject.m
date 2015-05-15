//
//  NSObject+NSCodableObject.m
//
//
//  Created by Pawel Weglewski on 22/08/14.
//

#import "NSObject+PWCodableObject.h"
#import <objc/runtime.h>

@implementation NSObject (PWCodableObject)

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        for (NSString *key in [self ivarNames])
        {
            @try {
                id value = [aDecoder decodeObjectForKey:key];
                if (value) {
                    [self setValue:value forKey:key];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Class is not key value coding-compliant : %@",key);
            }
            @finally {
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self ivarNames])
    {
        @try {
            id value = [self valueForKey:key];
            if (![value isKindOfClass:NSClassFromString(@"NSBlock")] && value ) {
                [aCoder encodeObject:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Class is not key value coding-compliant : %@",key);
        }
        @finally {
        }
    }
}

- (NSArray *)propertyNames
{
    NSMutableArray *array = objc_getAssociatedObject([self class], _cmd);
    if (array)
    {
        return array;
    }
    
    array = [NSMutableArray array];
    Class subclass = [self class];
    while (subclass != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(subclass,
                                                             &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = @(propertyName);
            
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar)
            {
                NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] ||
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                {
                    [array addObject:key];
                }
                free(ivar);
            }
        }
        free(properties);
        subclass = [subclass superclass];
    }
    
    objc_setAssociatedObject([self class], _cmd, array,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return array;
}

- (NSArray *)ivarNames
{
    NSMutableArray *properties = [[self propertyNames]mutableCopy];
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    for (int i = 0; i < ivarCount; i++)
    {
        Ivar ivar = ivars[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *key = @(ivarName);
        if ((![properties containsObject:key])&&(![properties containsObject:[key substringFromIndex:1]])) {
            [properties addObject:key];
        }
    }
    free(ivars);
    return properties;
}

@end
