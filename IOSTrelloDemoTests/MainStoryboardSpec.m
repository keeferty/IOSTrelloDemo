//
//  MainStoryboardSpec.m
//  IOSTrelloDemo
//
//  Created by Pawel Weglewski on 15/05/15.
//  Copyright 2015 Pawel Weglewski. All rights reserved.
//

#import "Specta.h"
#import "Expecta.h"
#import <UIKit/UIKit.h>
#import "PWNavigationControllerDelegate.h"
#import "PWLoginViewController.h"

#define EXP_SHORTHAND

SpecBegin(MainStoryboard)

describe(@"MainStoryboard", ^{
    __block UIStoryboard *storyboard;
    beforeAll(^{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    });
    
    it(@"does the storyboard exist", ^{
        expect(storyboard).notTo.beNil();
    });  
    
    describe(@"initial view controller", ^{
        __block id ctrl;
        beforeEach(^{
            ctrl = [storyboard instantiateInitialViewController];
        });
        
        it(@"initial view controller is not nil", ^{
            expect(ctrl).notTo.beNil();
        });
        
        it(@"initial view controller is a UINavigationController", ^{
            expect(ctrl).to.beKindOf([UINavigationController class]);
        });
        
            describe(@"UINavigationController animated transitioning tests", ^{
                __block UINavigationController *navCtrl;
                beforeEach(^{
                    navCtrl = (UINavigationController *)ctrl;
                });
                
                it(@"navigation controller has a delegate", ^{
                    expect(navCtrl.delegate).toNot.beNil();
                });
                
                it(@"navigation controller delegate is a PWNavigationControllerDelegate", ^{
                    expect(navCtrl.delegate).to.beKindOf([PWNavigationControllerDelegate class]);
                });
                
                    describe(@"PWNavigationControllerDelegate properly connected test", ^{
                        __block PWNavigationControllerDelegate *animator;
                        beforeEach(^{
                            animator = (PWNavigationControllerDelegate *)navCtrl.delegate;
                        });
                        
                        it(@"PWNavigationControllerDelegate points to the navigation controller that is the initial view controller", ^{
                            expect(animator.navigationController).to.equal(navCtrl);
                        });
                        
                        afterEach(^{
                            animator = nil;
                        });
                    });
                
                afterEach(^{
                    navCtrl = nil;
                });
            });
        
        afterEach(^{
            ctrl = nil;
        });
    });
    
    describe(@"Login view controller storyboard linkup", ^{
        __block UINavigationController *navCtrl;
        beforeEach(^{
            navCtrl = (UINavigationController *)[storyboard instantiateInitialViewController];
        });
        
        it(@"does navigationcontroller have root view controller", ^{
            expect([[navCtrl viewControllers] firstObject]).notTo.beNil();
        });
        
        it(@"root view controller fo navigation controller is a Login view controller", ^{
            expect([[navCtrl viewControllers] firstObject]).to.beAnInstanceOf([PWLoginViewController class]);
        });
        
        afterEach(^{
            navCtrl = nil;
        });
    });
    
    afterAll(^{
        storyboard = nil;
    });
});

SpecEnd
