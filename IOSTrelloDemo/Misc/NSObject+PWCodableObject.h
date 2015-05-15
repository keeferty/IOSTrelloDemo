//
//  NSObject+PWCodableObject.h
//
//
//  Created by Pawel Weglewski on 22/08/14.
//

#import <Foundation/Foundation.h>

@interface NSObject (PWCodableObject) <NSCoding>
- (NSArray *)propertyNames;
- (NSArray *)ivarNames;
@end
