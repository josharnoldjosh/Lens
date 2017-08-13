//
//  CollectionViewItem.m
//  MacLens
//
//  Created by Josh Arnold on 3/04/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import "CollectionViewItem.h"

@interface CollectionViewItem ()

@end

@implementation CollectionViewItem
@synthesize imageView;
@synthesize backgroundBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
}

-(void)setImageViewImage:(NSImage *)image {
    [self.imageView setImage:image];
}

-(void)setMalignantOrBenign:(int)number {
    if (number == 0) {
        [self.backgroundBox setBorderColor:[NSColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1]];
    }else{
        [self.backgroundBox setBorderColor:[NSColor colorWithRed:0.09 green:0.75 blue:0.28 alpha:1]];
    }
}

@end
