//
//  PWLoginViewControllerSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWLoginViewController.h"
#import <UIKit/UIKit.h>

#define EXP_SHORTHAND

SpecBegin(PWLoginViewController)

describe(@"PWLoginViewController", ^{
    __block UIStoryboard *storyboard;
    __block PWLoginViewController *loginCtrl;
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        loginCtrl = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    });
    
    it(@"does it exist when instantiated via storyboard ID", ^{
        expect(loginCtrl).notTo.beNil();
    });
    
    it(@"does it subclass PWViewController", ^{
        expect([loginCtrl class]).to.beSubclassOf([PWViewController class]);
    });
    
    afterEach(^{
        loginCtrl = nil;
    });
    
    afterAll(^{
        storyboard = nil;
    });
});

SpecEnd
