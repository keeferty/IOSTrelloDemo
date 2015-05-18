//
//  PWCardSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 18/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWCard.h"
#import <UIKit/UIKit.h>

#define EXP_SHORTHAND

SpecBegin(PWCard)

describe(@"PWCard", ^{
    __block PWCard *card;
    
    beforeEach(^{
        card = [PWCard new];
    });
    
    it(@"has a create card implementation", ^{
        expect(card).to.respondTo(@selector(create));
    });
    
    it(@"has a delete card implementation", ^{
        expect(card).to.respondTo(@selector(remove));
    });
    
    it(@"has a login api call proxy implementation", ^{
        expect(card).to.respondTo(@selector(save));
    });
    
    it(@"has a restart stacked operation implementation", ^{
        expect(card).to.respondTo(@selector(restart));
    });
    
    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd
