//
//  PWDetailViewControllerSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import "PWDetailViewController.h"
#import <UIKit/UIKit.h>

#define EXP_SHORTHAND

SpecBegin(PWDetailViewController)

describe(@"PWDetailViewController", ^{
    __block UIStoryboard *storyboard;
    __block PWDetailViewController *detailCtrl;
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    beforeEach(^{
        detailCtrl = [storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    });
    
    it(@"does it exist when instantiated via storyboard ID", ^{
        expect(detailCtrl).notTo.beNil();
    });
    
    it(@"is it a PWHomeViewController", ^{
        expect(detailCtrl).to.beKindOf([PWDetailViewController class]);
    });
    
    afterEach(^{
        detailCtrl = nil;
    });
    
    afterAll(^{
        storyboard = nil;
    });
});

SpecEnd
