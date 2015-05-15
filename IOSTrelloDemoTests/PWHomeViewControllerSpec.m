//
//  PWHomeViewControllerSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWHomeViewController.h"
#import <UIKit/UIKit.h>

#define EXP_SHORTHAND

SpecBegin(PWHomeViewController)

describe(@"PWHomeViewController", ^{
    __block UIStoryboard *storyboard;
    __block PWHomeViewController *homeCtrl;
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        homeCtrl = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
    });
    
    it(@"does it exist when instantiated via storyboard ID", ^{
        expect(homeCtrl).notTo.beNil();
    });
    
    it(@"is it a PWHomeViewController", ^{
        expect(homeCtrl).to.beKindOf([PWHomeViewController class]);
    });
    
    afterEach(^{
        homeCtrl = nil;
    });
    
    afterAll(^{
        storyboard = nil;
    });
});

SpecEnd
