//
//  ResultViewController.h
//  MacLens
//
//  Created by Josh Arnold on 3/04/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultViewController : NSViewController {
    __weak NSCollectionView *collectionView;
}

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *bengin;
@property (strong, nonatomic) NSMutableArray *malignant;
@end
