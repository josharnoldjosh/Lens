//
//  Header.h
//  MacLens
//
//  Created by Josh Arnold on 4/04/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Header : NSView {
    __weak NSTextField *textField;
}

@property (weak) IBOutlet NSTextField *textField;

@end
