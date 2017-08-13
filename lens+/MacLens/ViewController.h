//
//  ViewController.h
//  MacLens
//
//  Created by Josh Arnold on 22/03/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController {
    __weak NSBox *backgroundBox;
    __weak NSBox *lowBox;
    __weak NSBox *mediumBox;
    __weak NSBox *highBox;
    __weak NSTextField *percentLabel;
    __weak NSTextField *instructionLabel;
}

@property (weak) IBOutlet NSTextField *instructionLabel;

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *outputLabel;
@property (strong) IBOutlet NSView *mainView;
@property (weak) IBOutlet NSBox *backgroundBox;
@property (weak) IBOutlet NSBox *lowBox;
@property (weak) IBOutlet NSBox *mediumBox;
@property (weak) IBOutlet NSBox *highBox;
@property (weak) IBOutlet NSTextField *percentLabel;

@end

