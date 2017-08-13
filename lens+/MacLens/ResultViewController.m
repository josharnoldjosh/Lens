//
//  ResultViewController.m
//  MacLens
//
//  Created by Josh Arnold on 3/04/17.
//  Copyright © 2017 Josh Arnold. All rights reserved.
//

#import "ResultViewController.h"
#import "CollectionViewItem.h"
#import "Header.h"

@interface ResultViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource>

@end

@implementation ResultViewController
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    
}

- (void)configureCollectionView {
    NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc]init];
    [layout setItemSize:NSSizeFromCGSize(CGSizeMake(100, 100))];
    
    [layout setSectionInset:NSEdgeInsetsMake(30.0, 20.0, 30.0, 20.0)];
    
    [layout setMinimumLineSpacing:10];
    [layout setMinimumInteritemSpacing:10];
    [layout setHeaderReferenceSize:NSSizeFromCGSize(CGSizeMake(300, 25))];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CollectionViewItem class] forItemWithIdentifier:@"cell"];
    self.view.wantsLayer = YES;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 2;
}


- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        Header *header = [self.collectionView makeSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:@"Header2" forIndexPath:indexPath];
        if (kind == NSCollectionElementKindSectionHeader) {
            return header;
        }
    }else{
        Header *header = [self.collectionView makeSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:@"Header" forIndexPath:indexPath];
        if (kind == NSCollectionElementKindSectionHeader) {
            return header;
        }
    }
    return nil;
}
- (IBAction)scanAgain:(id)sender {
    [self dismissController:self];
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _malignant.count;
    }else{
        return _bengin.count;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    //this method is never called
    CollectionViewItem *item = [self.collectionView makeItemWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [item setImageViewImage:[_malignant objectAtIndex:[indexPath item]]];
        [item setMalignantOrBenign:0];
    }else{
        [item setImageViewImage:[_bengin objectAtIndex:[indexPath item]]];
        [item setMalignantOrBenign:1];
    }
    return item;
}

@end
