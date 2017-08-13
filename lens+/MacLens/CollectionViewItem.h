//
//  CollectionViewItem.h
//  MacLens
//
//  Created by Josh Arnold on 3/04/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CollectionViewItem : NSCollectionViewItem {
    __weak NSImageView *imageView;
    __weak NSBox *backgroundBox;
}

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSBox *backgroundBox;

-(void)setImageViewImage:(NSImage *)image;
-(void)setMalignantOrBenign:(int)number;

@end
