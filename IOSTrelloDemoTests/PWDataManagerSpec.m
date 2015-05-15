//
//  PWDataManagerSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWDataManager.h"

#define EXP_SHORTHAND

SpecBegin(PWDataManager)

describe(@"PWDataManager", ^{
    
    it(@"Check if it is not nill", ^{
        expect([PWDataManager sharedInstance]).notTo.beNil();
    });
    
    it(@"Check if it is a signleton", ^{
        PWDataManager *manager = [PWDataManager sharedInstance];
        expect(manager).to.equal([PWDataManager sharedInstance]);
    });
    
    it(@"has a login api call proxy implementation", ^{
        expect([PWDataManager sharedInstance]).to.respondTo(@selector(login:password:));
    });

});

SpecEnd
