//
//  PWWSManagerSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 14/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWWSManager.h"

#define EXP_SHORTHAND


SpecBegin(PWWSManager)

describe(@"PWWSManager", ^{
    
    it(@"Check if it is not nill", ^{
        expect([PWWSManager sharedInstance]).notTo.beNil();
    });
    
    it(@"Check if it is a signleton", ^{
        PWWSManager *manager = [PWWSManager sharedInstance];
        expect(manager).to.equal([PWWSManager sharedInstance]);
    });
    
    it(@"has a login api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(login:password:completionBlock:failureBlock:));
    });

    it(@"has a get boards api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(getOpenBoards:failureBlock:));
    });
    
    it(@"has a get board lists api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(getBoardLists:completionBlock:failureBlock:));
    });
    
    it(@"has a get lists cards api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(getListCards:completionBlock:failureBlock:));
    });
    
    it(@"has a delete cards api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(deleteCard:completionBlock:failureBlock:));
    });
    
    it(@"has a modify cards api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(modifyCard:completionBlock:failureBlock:));
    });
    
    it(@"has a create cards api call implementation", ^{
        expect([PWWSManager sharedInstance]).to.respondTo(@selector(createCard:completionBlock:failureBlock:));
    });
    
});

SpecEnd
